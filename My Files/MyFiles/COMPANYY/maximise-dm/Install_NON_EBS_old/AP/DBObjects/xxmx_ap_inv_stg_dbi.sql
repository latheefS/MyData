--
--
--*****************************************************************************
--**
--**                 Copyright (c) 2022 Version 1
--**
--**                           Millennium House,
--**                           Millennium Walkway,
--**                           Dublin 1
--**                           D01 F5P8
--**
--**                           All rights reserved.
--**
--*****************************************************************************
--**
--**
--** FILENAME  :  xxmx_ap_inv_stg_dbi.sql
--**
--** FILEPATH  :  ????
--**
--** VERSION   :  1.0
--**
--** EXECUTE
--** IN SCHEMA :  APPS
--**
--** AUTHORS   :  Ian S. Vickerstaff
--**
--** PURPOSE   :  This script installs the XXMX_STG DB Objects for the Maximise
--**              AP Invoices Data Migration.
--**
--** NOTES     :
--**
--******************************************************************************
--**
--** PRE-REQUISITIES
--** ---------------
--**
--** If this script is to be executed as part of an installation script, ensure
--** that the installation script performs the following tasks prior to calling
--** this script.
--**
--** Task  Description
--** ----  ---------------------------------------------------------------------
--** 1.    None
--**
--** If this script is not to be executed as part of an installation script,
--** ensure that the tasks above are, or have been, performed prior to executing
--** this script.
--**
--******************************************************************************
--**
--** CALLING INSTALLATION SCRIPTS
--** ----------------------------
--**
--** The following installation scripts call this script:
--**
--** File Path                                     File Name
--** --------------------------------------------  ------------------------------
--** N/A                                           N/A
--**
--******************************************************************************
--**
--** PARAMETERS
--** ----------
--**
--** Parameter                       IN OUT  Type
--** -----------------------------  ------  ------------------------------------
--** [parameter_name]                IN OUT
--**
--******************************************************************************
--**
--** [previous_filename] HISTORY
--** -----------------------------
--**
--**   Vsn  Change Date  Changed By          Change Description
--** -----  -----------  ------------------  -----------------------------------
--** [ 1.0  DD-Mon-YYYY  Change Author       Created.                          ]
--**
--******************************************************************************
--**
--** xxcust_common_pkg.sql HISTORY
--** ------------------------------------
--**
--**   Vsn  Change Date  Changed By          Change Description
--** -----  -----------  ------------------  -----------------------------------
--**   1.0  08-JAN-2021  Ian S. Vickerstaff  Created for Maximise.
--**
--**   1.1  20-JAN-2021  Ian S. Vickerstaff  Grants added.
--**
--**   1.2  14-JUL-2021  Ian S. Vickerstaff  Header comment updates.
--**
--******************************************************************************
--
--
PROMPT
PROMPT
PROMPT **********************************************************************
PROMPT **
PROMPT ** Installing Database Objects for Maximise AP Invoices Data Migration
PROMPT **
PROMPT **********************************************************************
PROMPT
PROMPT
--
--
PROMPT
PROMPT
PROMPT ******************
PROMPT ** Dropping Tables
PROMPT ******************
--
--
PROMPT
PROMPT Dropping Table xxmx_ap_invoices_stg
PROMPT
--
EXEC DropTable ('XXMX_AP_INVOICES_STG')
--
PROMPT
PROMPT Dropping Table xxmx_ap_invoice_lines_stg
PROMPT
--
EXEC DropTable ('XXMX_AP_INVOICE_LINES_STG')
--
PROMPT
PROMPT
PROMPT ******************
PROMPT ** Creating Tables
PROMPT ******************
--
--
PROMPT
PROMPT Creating Table xxmx_ap_invoices_stg
PROMPT
--
/*
** CREATE TABLE: xxmx_ap_invoices_stg
*/
--Migration_set_id is generated in the maximise Code
--File_set_id is mandatory for Data File (non-Ebs Source)
--
CREATE TABLE xxmx_ap_invoices_stg
     (
	  file_set_id                     VARCHAR2(30)
     ,migration_set_id                NUMBER   
     ,migration_set_name              VARCHAR2(100)
     ,migration_status                VARCHAR2(50)
     ,invoice_id                      NUMBER(15,0)
     ,operating_unit                  VARCHAR2(240)
     ,ledger_name                     VARCHAR2(30)
     ,invoice_num                     VARCHAR2(50)
     ,invoice_amount                  NUMBER
     ,invoice_date                    DATE
     ,vendor_name                     VARCHAR2(240)
     ,vendor_num                      VARCHAR2(30)
     ,vendor_site_code                VARCHAR2(15)
     ,invoice_currency_code           VARCHAR2(15)
     ,payment_currency_code           VARCHAR2(15)
     ,description                     VARCHAR2(240)
     ,invoice_type_lookup_code        VARCHAR2(25)
     ,legal_entity_name               VARCHAR2(50)
     ,cust_registration_number        VARCHAR2(30)
     ,cust_registration_code          VARCHAR2(30)
     ,first_party_registration_num    VARCHAR2(60)
     ,third_party_registration_num    VARCHAR2(60)
     ,terms_name                      VARCHAR2(50)
     ,terms_date                      DATE
     ,goods_received_date             DATE
     ,invoice_received_date           DATE
     ,gl_date                         DATE
     ,payment_method_code             VARCHAR2(30)
     ,pay_group_lookup_code           VARCHAR2(25)
     ,exclusive_payment_flag          VARCHAR2(1)
     ,amount_applicable_to_discount   NUMBER
     ,prepay_num                      VARCHAR2(50)
     ,prepay_line_num                 NUMBER
     ,prepay_apply_amount             NUMBER
     ,prepay_gl_date                  DATE
     ,invoice_includes_prepay_flag    VARCHAR2(1)
     ,exchange_rate_type              VARCHAR2(30)
     ,exchange_date                   DATE
     ,exchange_rate                   NUMBER
     ,accts_pay_code_concatenated     VARCHAR2(250)
     ,doc_category_code               VARCHAR2(30)
     ,voucher_num                     VARCHAR2(50)
     ,requester_first_name            VARCHAR2(150)
     ,requester_last_name             VARCHAR2(150)
     ,requester_employee_num          VARCHAR2(30)
     ,delivery_channel_code           VARCHAR2(30)
     ,bank_charge_bearer              VARCHAR2(30)
     ,remit_to_supplier_name          VARCHAR2(240)
     ,remit_to_supplier_num           VARCHAR2(30)
     ,remit_to_address_name           VARCHAR2(240)
     ,payment_priority                NUMBER(2,0)
     ,settlement_priority             VARCHAR2(30)
     ,unique_remittance_identifier    VARCHAR2(30)
     ,uri_check_digit                 VARCHAR2(2)
     ,payment_reason_code             VARCHAR2(30)
     ,payment_reason_comments         VARCHAR2(240)
     ,remittance_message1             VARCHAR2(150)
     ,remittance_message2             VARCHAR2(150)
     ,remittance_message3             VARCHAR2(150)
     ,awt_group_name                  VARCHAR2(25)
     ,ship_to_location                VARCHAR2(40)
     ,taxation_country                VARCHAR2(30)
     ,document_sub_type               VARCHAR2(150)
     ,tax_invoice_internal_seq        VARCHAR2(150)
     ,supplier_tax_invoice_number     VARCHAR2(150)
     ,tax_invoice_recording_date      DATE
     ,supplier_tax_invoice_date       DATE
     ,supplier_tax_exchange_rate      NUMBER
     ,port_of_entry_code              VARCHAR2(30)
     ,correction_year                 NUMBER
     ,correction_period               VARCHAR2(15)
     ,import_document_number          VARCHAR2(50)
     ,import_document_date            DATE
     ,control_amount                  NUMBER
     ,calc_tax_during_import_flag     VARCHAR2(1)
     ,add_tax_to_inv_amt_flag         VARCHAR2(1)
     ,attribute_category              VARCHAR2(150)
     ,attribute1                      VARCHAR2(150)
     ,attribute2                      VARCHAR2(150)
     ,attribute3                      VARCHAR2(150)
     ,attribute4                      VARCHAR2(150)
     ,attribute5                      VARCHAR2(150)
     ,attribute6                      VARCHAR2(150)
     ,attribute7                      VARCHAR2(150)
     ,attribute8                      VARCHAR2(150)
     ,attribute9                      VARCHAR2(150)
     ,attribute10                     VARCHAR2(150)
     ,attribute11                     VARCHAR2(150)
     ,attribute12                     VARCHAR2(150)
     ,attribute13                     VARCHAR2(150)
     ,attribute14                     VARCHAR2(150)
     ,attribute15                     VARCHAR2(150)
     ,attribute_number1               NUMBER
     ,attribute_number2               NUMBER
     ,attribute_number3               NUMBER
     ,attribute_number4               NUMBER
     ,attribute_number5               NUMBER
     ,attribute_date1                 DATE
     ,attribute_date2                 DATE
     ,attribute_date3                 DATE
     ,attribute_date4                 DATE
     ,attribute_date5                 DATE
     ,global_attribute_category       VARCHAR2(150)
     ,global_attribute1               VARCHAR2(150)
     ,global_attribute2               VARCHAR2(150)
     ,global_attribute3               VARCHAR2(150)
     ,global_attribute4               VARCHAR2(150)
     ,global_attribute5               VARCHAR2(150)
     ,global_attribute6               VARCHAR2(150)
     ,global_attribute7               VARCHAR2(150)
     ,global_attribute8               VARCHAR2(150)
     ,global_attribute9               VARCHAR2(150)
     ,global_attribute10              VARCHAR2(150)
     ,global_attribute11              VARCHAR2(150)
     ,global_attribute12              VARCHAR2(150)
     ,global_attribute13              VARCHAR2(150)
     ,global_attribute14              VARCHAR2(150)
     ,global_attribute15              VARCHAR2(150)
     ,global_attribute16              VARCHAR2(150)
     ,global_attribute17              VARCHAR2(150)
     ,global_attribute18              VARCHAR2(150)
     ,global_attribute19              VARCHAR2(150)
     ,global_attribute20              VARCHAR2(150)
     ,global_attribute_number1        NUMBER
     ,global_attribute_number2        NUMBER
     ,global_attribute_number3        NUMBER
     ,global_attribute_number4        NUMBER
     ,global_attribute_number5        NUMBER
     ,global_attribute_date1          DATE
     ,global_attribute_date2          DATE
     ,global_attribute_date3          DATE
     ,global_attribute_date4          DATE
     ,global_attribute_date5          DATE
     ,image_document_uri              VARCHAR2(4000)
     );
--
PROMPT
PROMPT Creating Table xxmx_ap_invoice_lines_stg
PROMPT
--
/*
** CREATE TABLE: xxmx_ap_invoice_lines_stg
*/
--
CREATE TABLE  xxmx_ap_invoice_lines_stg
     ( 
	  file_set_id                     VARCHAR2(30)
     ,migration_set_id                NUMBER
     ,migration_set_name              VARCHAR2(100)                 
     ,migration_status                VARCHAR2(50)
     ,invoice_id                      NUMBER(15,0)
     ,line_number                     NUMBER(18,0)
     ,line_type_lookup_code           VARCHAR2(25)
     ,amount                          NUMBER
     ,quantity_invoiced               NUMBER
     ,unit_price                      NUMBER
     ,unit_of_meas_lookup_code        VARCHAR2(25)
     ,description                     VARCHAR2(240) 
     ,po_number                       VARCHAR2(20)
     ,po_line_number                  NUMBER
     ,po_shipment_num                 NUMBER
     ,po_distribution_num             NUMBER
     ,item_description                VARCHAR2(240)
     ,release_num                     NUMBER 
     ,purchasing_category             VARCHAR2(2000)
     ,receipt_number                  VARCHAR2(30)
     ,receipt_line_number             VARCHAR2(25)
     ,consumption_advice_number       VARCHAR2(20)
     ,consumption_advice_line_number  NUMBER
     ,packing_slip                    VARCHAR2(25) 
     ,final_match_flag                VARCHAR2(1)
     ,dist_code_concatenated          VARCHAR2(250)
     ,distribution_set_name           VARCHAR2(50)
     ,accounting_date                 DATE
     ,account_segment                 VARCHAR2(25)
     ,balancing_segment               VARCHAR2(25)
     ,cost_center_segment             VARCHAR2(25) 
     ,tax_classification_code         VARCHAR2(30) 
     ,ship_to_location_code           VARCHAR2(60)
     ,ship_from_location_code         VARCHAR2(60)
     ,final_discharge_location_code   VARCHAR2(60)
     ,trx_business_category           VARCHAR2(240)
     ,product_fisc_classification     VARCHAR2(240)
     ,primary_intended_use            VARCHAR2(30)
     ,user_defined_fisc_class         VARCHAR2(240)
     ,product_type                    VARCHAR2(240)
     ,assessable_value                NUMBER
     ,product_category                VARCHAR2(240)
     ,control_amount                  NUMBER
     ,tax_regime_code                 VARCHAR2(30)
     ,tax                             VARCHAR2(30)
     ,tax_status_code                 VARCHAR2(30)
     ,tax_jurisdiction_code           VARCHAR2(30)
     ,tax_rate_code                   VARCHAR2(150)
     ,tax_rate                        NUMBER
     ,awt_group_name                  VARCHAR2(25)
     ,type_1099                       VARCHAR2(10)
     ,income_tax_region               VARCHAR2(10)
     ,prorate_across_flag             VARCHAR2(1)
     ,line_group_number               NUMBER
     ,cost_factor_name                VARCHAR2(80)
     ,stat_amount                     NUMBER
     ,assets_tracking_flag            VARCHAR2(1)
     ,asset_book_type_code            VARCHAR2(30)
     ,asset_category_id               NUMBER(18,0)
     ,serial_number                   VARCHAR2(35)
     ,manufacturer                    VARCHAR2(30)
     ,model_number                    VARCHAR2(40)
     ,warranty_number                 VARCHAR2(15)
     ,price_correction_flag           VARCHAR2(1)
     ,price_correct_inv_num           VARCHAR2(50)
     ,price_correct_inv_line_num      NUMBER
     ,requester_first_name            VARCHAR2(150)
     ,requester_last_name             VARCHAR2(150)
     ,requester_employee_num          VARCHAR2(30)
     ,attribute_category              VARCHAR2(150)
     ,attribute1                      VARCHAR2(150)
     ,attribute2                      VARCHAR2(150)
     ,attribute3                      VARCHAR2(150)
     ,attribute4                      VARCHAR2(150)
     ,attribute5                      VARCHAR2(150)
     ,attribute6                      VARCHAR2(150)
     ,attribute7                      VARCHAR2(150)
     ,attribute8                      VARCHAR2(150)
     ,attribute9                      VARCHAR2(150)
     ,attribute10                     VARCHAR2(150)
     ,attribute11                     VARCHAR2(150)
     ,attribute12                     VARCHAR2(150)
     ,attribute13                     VARCHAR2(150)
     ,attribute14                     VARCHAR2(150)
     ,attribute15                     VARCHAR2(150)
     ,attribute_number1               NUMBER
     ,attribute_number2               NUMBER
     ,attribute_number3               NUMBER
     ,attribute_number4               NUMBER
     ,attribute_number5               NUMBER
     ,attribute_date1                 DATE
     ,attribute_date2                 DATE
     ,attribute_date3                 DATE
     ,attribute_date4                 DATE
     ,attribute_date5                 DATE
     ,global_attribute_category       VARCHAR2(150)
     ,global_attribute1               VARCHAR2(150)
     ,global_attribute2               VARCHAR2(150)
     ,global_attribute3               VARCHAR2(150)
     ,global_attribute4               VARCHAR2(150)
     ,global_attribute5               VARCHAR2(150)
     ,global_attribute6               VARCHAR2(150)
     ,global_attribute7               VARCHAR2(150)
     ,global_attribute8               VARCHAR2(150)
     ,global_attribute9               VARCHAR2(150)
     ,global_attribute10              VARCHAR2(150)
     ,global_attribute11              VARCHAR2(150)
     ,global_attribute12              VARCHAR2(150)
     ,global_attribute13              VARCHAR2(150)
     ,global_attribute14              VARCHAR2(150)
     ,global_attribute15              VARCHAR2(150)
     ,global_attribute16              VARCHAR2(150)
     ,global_attribute17              VARCHAR2(150)
     ,global_attribute18              VARCHAR2(150)
     ,global_attribute19              VARCHAR2(150)
     ,global_attribute20              VARCHAR2(150)
     ,global_attribute_number1        NUMBER
     ,global_attribute_number2        NUMBER
     ,global_attribute_number3        NUMBER
     ,global_attribute_number4        NUMBER
     ,global_attribute_number5        NUMBER
     ,global_attribute_date1          DATE
     ,global_attribute_date2          DATE
     ,global_attribute_date3          DATE
     ,global_attribute_date4          DATE
     ,global_attribute_date5          DATE
     ,pjc_project_id                  NUMBER(18,0)
     ,pjc_task_id                     NUMBER(18,0)
     ,pjc_expenditure_type_id         NUMBER(18,0)
     ,pjc_expenditure_item_date       DATE
     ,pjc_organization_id             NUMBER(18,0)
     ,pjc_project_number              VARCHAR2(25)
     ,pjc_task_number                 VARCHAR2(100)
     ,pjc_expenditure_type_name       VARCHAR2(240)
     ,pjc_organization_name           VARCHAR2(240)
     ,pjc_reserved_attribute1         VARCHAR2(150)
     ,pjc_reserved_attribute2         VARCHAR2(150)
     ,pjc_reserved_attribute3         VARCHAR2(150)
     ,pjc_reserved_attribute4         VARCHAR2(150)
     ,pjc_reserved_attribute5         VARCHAR2(150)
     ,pjc_reserved_attribute6         VARCHAR2(150)
     ,pjc_reserved_attribute7         VARCHAR2(150)
     ,pjc_reserved_attribute8         VARCHAR2(150)
     ,pjc_reserved_attribute9         VARCHAR2(150)
     ,pjc_reserved_attribute10        VARCHAR2(150)
     ,pjc_user_def_attribute1         VARCHAR2(150)
     ,pjc_user_def_attribute2         VARCHAR2(150)
     ,pjc_user_def_attribute3         VARCHAR2(150)
     ,pjc_user_def_attribute4         VARCHAR2(150)
     ,pjc_user_def_attribute5         VARCHAR2(150)
     ,pjc_user_def_attribute6         VARCHAR2(150)
     ,pjc_user_def_attribute7         VARCHAR2(150)
     ,pjc_user_def_attribute8         VARCHAR2(150)
     ,pjc_user_def_attribute9         VARCHAR2(150)
     ,pjc_user_def_attribute10        VARCHAR2(150)
     ,fiscal_charge_type              VARCHAR2(30)
     ,def_acctg_start_date            DATE
     ,def_acctg_end_date              DATE
     ,def_accrual_code_concatenated   DATE
     ,pjc_project_name                VARCHAR2(240)
     ,pjc_task_name                   VARCHAR2(255)
     );
--
--
PROMPT
PROMPT
PROMPT ***********************
PROMPT ** Granting Permissions
PROMPT ***********************
--
--
GRANT ALL ON xxmx_ap_invoices_stg TO xxmx_core;
--
--
GRANT ALL ON xxmx_ap_invoice_lines_stg TO xxmx_core;
--
--
--
PROMPT
PROMPT
PROMPT ********************************************************************************
PROMPT **                                
PROMPT ** Completed Installing Database Objects for Maximise AP Invoices Data Migration
PROMPT **                                
PROMPT ********************************************************************************
PROMPT
PROMPT
--
