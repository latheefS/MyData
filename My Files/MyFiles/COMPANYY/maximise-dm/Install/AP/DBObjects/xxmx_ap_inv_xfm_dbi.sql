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
--** FILENAME  :  xxmx_ap_inv_XFM_dbi.sql
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
--** PURPOSE   :  This script installs the XXMX_XFM DB Objects for the Cloudbridge
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
--**   1.0  08-JAN-2021  Ian S. Vickerstaff  Created for Cloudbridge.
--**
--**   1.1  20-JAN-2021  Ian S. Vickerstaff  Grants added.
--**
--**   1.2  14-JUL-2021  Ian S. Vickerstaff  Header comment updates.
--**
--**   1.3  25-OCT-2023  Sinchana Ramesh     Added new columns.

--******************************************************************************
--
--
PROMPT
PROMPT
PROMPT **********************************************************************
PROMPT **
PROMPT ** Installing Database Objects for Cloudbridge AP Invoices Data Migration
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
PROMPT Dropping Table xxmx_ap_invoices_XFM
PROMPT
--
EXEC DropTable ('XXMX_AP_INVOICES_XFM')
--
PROMPT
PROMPT Dropping Table xxmx_ap_invoice_lines_XFM
PROMPT
--
EXEC DropTable ('XXMX_AP_INVOICE_LINES_XFM')
--
PROMPT
PROMPT
PROMPT ******************
PROMPT ** Creating Tables
PROMPT ******************
--
--
PROMPT
PROMPT Creating Table xxmx_ap_invoices_XFM
PROMPT
--
/*
** CREATE TABLE: xxmx_ap_invoices_XFM
*/
--Migration_set_id is generated in the Cloudbridge Code
--File_set_id is mandatory for Data File (non-Ebs Source)
--
CREATE TABLE XXMX_XFM.XXMX_AP_INVOICES_XFM
 (
   FILE_SET_ID                         VARCHAR2(30)  ,
   MIGRATION_SET_ID                    NUMBER        ,     
   MIGRATION_SET_NAME                  VARCHAR2(100) , 
   MIGRATION_STATUS                    VARCHAR2(50)  , 
   INVOICE_ID                          NUMBER(15)    , 
   SOURCE_OPERATING_UNIT               VARCHAR2(240) , 
   FUSION_BUSINESS_UNIT                VARCHAR2(240) , 
   SOURCE_LEDGER_NAME                  VARCHAR2(30)  , 
   FUSION_LEDGER_NAME                  VARCHAR2(30)  , 
   SOURCE                              VARCHAR2(80)  , 
   INVOICE_NUM                         VARCHAR2(50)  , 
   INVOICE_AMOUNT                      NUMBER        , 
   INVOICE_DATE                        DATE          , 
   VENDOR_NAME                         VARCHAR2(240) , 
   VENDOR_NUM                          VARCHAR2(30)  , 
   VENDOR_SITE_CODE                    VARCHAR2(15)  , 
   INVOICE_CURRENCY_CODE               VARCHAR2(15)  , 
   PAYMENT_CURRENCY_CODE               VARCHAR2(15)  , 
   DESCRIPTION                         VARCHAR2(240) , 
   IMPORT_SET                          VARCHAR2(80)  , 
   INVOICE_TYPE_LOOKUP_CODE            VARCHAR2(25)  , 
   LEGAL_ENTITY_NAME                   VARCHAR2(50)  , 
   CUST_REGISTRATION_NUMBER            VARCHAR2(30)  , 
   CUST_REGISTRATION_CODE              VARCHAR2(30)  , 
   FIRST_PARTY_REGISTRATION_NUM        VARCHAR2(60)  , 
   THIRD_PARTY_REGISTRATION_NUM        VARCHAR2(60)  , 
   TERMS_NAME                          VARCHAR2(50)  , 
   TERMS_DATE                          DATE          , 
   GOODS_RECEIVED_DATE                 DATE          , 
   INVOICE_RECEIVED_DATE               DATE          ,
   GL_DATE                             DATE          , 
   PAYMENT_METHOD_CODE                 VARCHAR2(30)  , 
   PAY_GROUP_LOOKUP_CODE               VARCHAR2(25)  , 
   EXCLUSIVE_PAYMENT_FLAG              VARCHAR2(1)   , 
   AMOUNT_APPLICABLE_TO_DISCOUNT       NUMBER        , 
   PREPAY_NUM                          VARCHAR2(50)  , 
   PREPAY_LINE_NUM                     NUMBER        , 
   PREPAY_APPLY_AMOUNT                 NUMBER        , 
   PREPAY_GL_DATE                      DATE          , 
   INVOICE_INCLUDES_PREPAY_FLAG        VARCHAR2(1)   , 
   EXCHANGE_RATE_TYPE                  VARCHAR2(30)  , 
   EXCHANGE_DATE                       DATE          , 
   EXCHANGE_RATE                       NUMBER        , 
   ACCTS_PAY_CODE_CONCATENATED         VARCHAR2(250) , 
   DOC_CATEGORY_CODE                   VARCHAR2(30)  , 
   VOUCHER_NUM                         VARCHAR2(50)  , 
   REQUESTER_FIRST_NAME                VARCHAR2(150) , 
   REQUESTER_LAST_NAME                 VARCHAR2(150) , 
   REQUESTER_EMPLOYEE_NUM              VARCHAR2(30)  , 
   DELIVERY_CHANNEL_CODE               VARCHAR2(30)  , 
   BANK_CHARGE_BEARER                  VARCHAR2(30)  , 
   REMIT_TO_SUPPLIER_NAME              VARCHAR2(240) , 
   REMIT_TO_SUPPLIER_NUM               VARCHAR2(30)  , 
   REMIT_TO_ADDRESS_NAME               VARCHAR2(240) , 
   PAYMENT_PRIORITY                    NUMBER(2)     , 
   SETTLEMENT_PRIORITY                 VARCHAR2(30)  , 
   UNIQUE_REMITTANCE_IDENTIFIER        VARCHAR2(30)  , 
   URI_CHECK_DIGIT                     VARCHAR2(2)   , 
   PAYMENT_REASON_CODE                 VARCHAR2(30)  , 
   PAYMENT_REASON_COMMENTS             VARCHAR2(240) , 
   REMITTANCE_MESSAGE1                 VARCHAR2(150) , 
   REMITTANCE_MESSAGE2                 VARCHAR2(150) , 
   REMITTANCE_MESSAGE3                 VARCHAR2(150) , 
   AWT_GROUP_NAME                      VARCHAR2(25)  , 
   SHIP_TO_LOCATION                    VARCHAR2(40)  , 
   TAXATION_COUNTRY                    VARCHAR2(30)  , 
   DOCUMENT_SUB_TYPE                   VARCHAR2(150) , 
   TAX_INVOICE_INTERNAL_SEQ            VARCHAR2(150) , 
   SUPPLIER_TAX_INVOICE_NUMBER         VARCHAR2(150) , 
   TAX_INVOICE_RECORDING_DATE          DATE          , 
   SUPPLIER_TAX_INVOICE_DATE           DATE          , 
   SUPPLIER_TAX_EXCHANGE_RATE          NUMBER        , 
   PORT_OF_ENTRY_CODE                  VARCHAR2(30)  , 
   CORRECTION_YEAR                     NUMBER        , 
   CORRECTION_PERIOD                   VARCHAR2(15)  , 
   IMPORT_DOCUMENT_NUMBER              VARCHAR2(50)  , 
   IMPORT_DOCUMENT_DATE                DATE          , 
   CONTROL_AMOUNT                      NUMBER        , 
   CALC_TAX_DURING_IMPORT_FLAG         VARCHAR2(1)   , 
   ADD_TAX_TO_INV_AMT_FLAG             VARCHAR2(1)   , 
   ATTRIBUTE_CATEGORY                  VARCHAR2(150) ,
   ATTRIBUTE1                          VARCHAR2(150) , 
   ATTRIBUTE2                          VARCHAR2(150) , 
   ATTRIBUTE3                          VARCHAR2(150) , 
   ATTRIBUTE4                          VARCHAR2(150) , 
   ATTRIBUTE5                          VARCHAR2(150) , 
   ATTRIBUTE6                          VARCHAR2(150) , 
   ATTRIBUTE7                          VARCHAR2(150) , 
   ATTRIBUTE8                          VARCHAR2(150) , 
   ATTRIBUTE9                          VARCHAR2(150) , 
   ATTRIBUTE10                         VARCHAR2(150) , 
   ATTRIBUTE11                         VARCHAR2(150) , 
   ATTRIBUTE12                         VARCHAR2(150) , 
   ATTRIBUTE13                         VARCHAR2(150) , 
   ATTRIBUTE14                         VARCHAR2(150) , 
   ATTRIBUTE15                         VARCHAR2(150) , 
   ATTRIBUTE_NUMBER1                   NUMBER        , 
   ATTRIBUTE_NUMBER2                   NUMBER        , 
   ATTRIBUTE_NUMBER3                   NUMBER        , 
   ATTRIBUTE_NUMBER4                   NUMBER        , 
   ATTRIBUTE_NUMBER5                   NUMBER        , 
   ATTRIBUTE_DATE1                     DATE          , 
   ATTRIBUTE_DATE2                     DATE          , 
   ATTRIBUTE_DATE3                     DATE          , 
   ATTRIBUTE_DATE4                     DATE          , 
   ATTRIBUTE_DATE5                     DATE          , 
   GLOBAL_ATTRIBUTE_CATEGORY           VARCHAR2(150) , 
   GLOBAL_ATTRIBUTE1                   VARCHAR2(150) , 
   GLOBAL_ATTRIBUTE2                   VARCHAR2(150) , 
   GLOBAL_ATTRIBUTE3                   VARCHAR2(150) , 
   GLOBAL_ATTRIBUTE4                   VARCHAR2(150) , 
   GLOBAL_ATTRIBUTE5                   VARCHAR2(150) , 
   GLOBAL_ATTRIBUTE6                   VARCHAR2(150) , 
   GLOBAL_ATTRIBUTE7                   VARCHAR2(150) , 
   GLOBAL_ATTRIBUTE8                   VARCHAR2(150) , 
   GLOBAL_ATTRIBUTE9                   VARCHAR2(150) , 
   GLOBAL_ATTRIBUTE10                  VARCHAR2(150) , 
   GLOBAL_ATTRIBUTE11                  VARCHAR2(150) , 
   GLOBAL_ATTRIBUTE12                  VARCHAR2(150) ,
   GLOBAL_ATTRIBUTE13                  VARCHAR2(150) , 
   GLOBAL_ATTRIBUTE14                  VARCHAR2(150) , 
   GLOBAL_ATTRIBUTE15                  VARCHAR2(150) , 
   GLOBAL_ATTRIBUTE16                  VARCHAR2(150) , 
   GLOBAL_ATTRIBUTE17                  VARCHAR2(150) , 
   GLOBAL_ATTRIBUTE18                  VARCHAR2(150) , 
   GLOBAL_ATTRIBUTE19                  VARCHAR2(150) , 
   GLOBAL_ATTRIBUTE20                  VARCHAR2(150) , 
   GLOBAL_ATTRIBUTE_NUMBER1            NUMBER        , 
   GLOBAL_ATTRIBUTE_NUMBER2            NUMBER        , 
   GLOBAL_ATTRIBUTE_NUMBER3            NUMBER        , 
   GLOBAL_ATTRIBUTE_NUMBER4            NUMBER        , 
   GLOBAL_ATTRIBUTE_NUMBER5            NUMBER        , 
   GLOBAL_ATTRIBUTE_DATE1              DATE          , 
   GLOBAL_ATTRIBUTE_DATE2              DATE          , 
   GLOBAL_ATTRIBUTE_DATE3              DATE          , 
   GLOBAL_ATTRIBUTE_DATE4              DATE          , 
   GLOBAL_ATTRIBUTE_DATE5              DATE          , 
   IMAGE_DOCUMENT_URI                  VARCHAR2(4000) ,
   EXTERNAL_BANK_ACCOUNT_NUMBER        VARCHAR2(100),
   EXT_BANK_ACCOUNT_IBAN_NUMBER        VARCHAR2(50),
   REQUESTER_EMAIL_ADDRESS             VARCHAR2(240),
   LOAD_BATCH                          VARCHAR2(300)
);

--
PROMPT
PROMPT Creating Table xxmx_ap_invoice_lines_XFM
PROMPT
--
/*
** CREATE TABLE: xxmx_ap_invoice_lines_XFM
*/
--

CREATE TABLE  XXMX_XFM.XXMX_AP_INVOICE_LINES_XFM
( 
   FILE_SET_ID                         VARCHAR2(30)    ,
   MIGRATION_SET_ID                     NUMBER         ,        
   MIGRATION_SET_NAME                   VARCHAR2(100)  ,
   MIGRATION_STATUS                     VARCHAR2(50)   ,
   INVOICE_ID                           NUMBER(15)     ,
   LINE_NUMBER                          NUMBER(18)     ,
   LINE_TYPE_LOOKUP_CODE                VARCHAR2(25)   ,
   AMOUNT                               NUMBER         ,
   QUANTITY_INVOICED                    NUMBER         ,
   UNIT_PRICE                           NUMBER         ,
   UNIT_OF_MEAS_LOOKUP_CODE             VARCHAR2(25)   ,
   DESCRIPTION                          VARCHAR2(240)  ,
   PO_NUMBER                            VARCHAR2(20)   ,
   PO_LINE_NUMBER                       NUMBER         ,
   PO_SHIPMENT_NUM                      NUMBER         ,
   PO_DISTRIBUTION_NUM                  NUMBER         ,
   ITEM_DESCRIPTION                     VARCHAR2(240)  ,
   RELEASE_NUM                          NUMBER         ,
   PURCHASING_CATEGORY                  VARCHAR2(2000) ,
   RECEIPT_NUMBER                       VARCHAR2(30)   ,
   RECEIPT_LINE_NUMBER                  VARCHAR2(25)   ,
   CONSUMPTION_ADVICE_NUMBER            VARCHAR2(20)   ,
   CONSUMPTION_ADVICE_LINE_NUMBER       NUMBER         ,
   PACKING_SLIP                         VARCHAR2(25)   ,
   FINAL_MATCH_FLAG                     VARCHAR2(1)    ,
   DIST_CODE_CONCATENATED               VARCHAR2(250)  ,
   DISTRIBUTION_SET_NAME                VARCHAR2(50)   ,
   ACCOUNTING_DATE                      DATE           ,
   ACCOUNT_SEGMENT                      VARCHAR2(25)   ,
   BALANCING_SEGMENT                    VARCHAR2(25)   ,
   COST_CENTER_SEGMENT                  VARCHAR2(25)   ,
   TAX_CLASSIFICATION_CODE              VARCHAR2(30)   ,
   SHIP_TO_LOCATION_CODE                VARCHAR2(60)   ,
   SHIP_FROM_LOCATION_CODE              VARCHAR2(60)   ,
   FINAL_DISCHARGE_LOCATION_CODE        VARCHAR2(60)   ,
   TRX_BUSINESS_CATEGORY                VARCHAR2(240)  ,
   PRODUCT_FISC_CLASSIFICATION          VARCHAR2(240)  ,
   PRIMARY_INTENDED_USE                 VARCHAR2(30)   ,
   USER_DEFINED_FISC_CLASS              VARCHAR2(240)  ,
   PRODUCT_TYPE                         VARCHAR2(240)  ,
   ASSESSABLE_VALUE                     NUMBER         ,
   PRODUCT_CATEGORY                     VARCHAR2(240)  ,
   CONTROL_AMOUNT                       NUMBER         ,
   TAX_REGIME_CODE                      VARCHAR2(30)   ,
   TAX                                  VARCHAR2(30)   ,
   TAX_STATUS_CODE                      VARCHAR2(30)   ,
   TAX_JURISDICTION_CODE                VARCHAR2(30)   ,
   TAX_RATE_CODE                        VARCHAR2(150)  ,
   TAX_RATE                             NUMBER         ,
   AWT_GROUP_NAME                       VARCHAR2(25)   ,
   TYPE_1099                            VARCHAR2(10)   ,
   INCOME_TAX_REGION                    VARCHAR2(10)   ,
   PRORATE_ACROSS_FLAG                  VARCHAR2(1)    ,
   LINE_GROUP_NUMBER                    NUMBER         ,
   COST_FACTOR_NAME                     VARCHAR2(80)   ,
   STAT_AMOUNT                          NUMBER         ,
   ASSETS_TRACKING_FLAG                 VARCHAR2(1)    ,
   ASSET_BOOK_TYPE_CODE                 VARCHAR2(30)   ,
   ASSET_CATEGORY_ID                    NUMBER(18)     ,
   SERIAL_NUMBER                        VARCHAR2(35)   ,
   MANUFACTURER                         VARCHAR2(30)   ,
   MODEL_NUMBER                         VARCHAR2(40)   ,
   WARRANTY_NUMBER                      VARCHAR2(15)   ,
   PRICE_CORRECTION_FLAG                VARCHAR2(1)    ,
   PRICE_CORRECT_INV_NUM                VARCHAR2(50)   ,
   PRICE_CORRECT_INV_LINE_NUM           NUMBER         ,
   REQUESTER_FIRST_NAME                 VARCHAR2(150)  ,
   REQUESTER_LAST_NAME                  VARCHAR2(150)  ,
   REQUESTER_EMPLOYEE_NUM               VARCHAR2(30)   ,
   ATTRIBUTE_CATEGORY                   VARCHAR2(150)  ,
   ATTRIBUTE1                           VARCHAR2(150)  ,
   ATTRIBUTE2                           VARCHAR2(150)  ,
   ATTRIBUTE3                           VARCHAR2(150)  ,
   ATTRIBUTE4                           VARCHAR2(150)  ,
   ATTRIBUTE5                           VARCHAR2(150)  ,
   ATTRIBUTE6                           VARCHAR2(150)  ,
   ATTRIBUTE7                           VARCHAR2(150)  ,
   ATTRIBUTE8                           VARCHAR2(150)  ,
   ATTRIBUTE9                           VARCHAR2(150)  ,
   ATTRIBUTE10                          VARCHAR2(150)  ,
   ATTRIBUTE11                          VARCHAR2(150)  ,
   ATTRIBUTE12                          VARCHAR2(150)  ,
   ATTRIBUTE13                          VARCHAR2(150)  ,
   ATTRIBUTE14                          VARCHAR2(150)  ,
   ATTRIBUTE15                          VARCHAR2(150)  ,
   ATTRIBUTE_NUMBER1                    NUMBER         ,
   ATTRIBUTE_NUMBER2                    NUMBER         ,
   ATTRIBUTE_NUMBER3                    NUMBER         ,
   ATTRIBUTE_NUMBER4                    NUMBER         ,
   ATTRIBUTE_NUMBER5                    NUMBER         ,
   ATTRIBUTE_DATE1                      DATE           ,
   ATTRIBUTE_DATE2                      DATE           ,
   ATTRIBUTE_DATE3                      DATE           ,
   ATTRIBUTE_DATE4                      DATE           ,
   ATTRIBUTE_DATE5                      DATE           ,
   GLOBAL_ATTRIBUTE_CATEGORY            VARCHAR2(150)  ,
   GLOBAL_ATTRIBUTE1                    VARCHAR2(150)  ,
   GLOBAL_ATTRIBUTE2                    VARCHAR2(150)  ,
   GLOBAL_ATTRIBUTE3                    VARCHAR2(150)  ,
   GLOBAL_ATTRIBUTE4                    VARCHAR2(150)  ,
   GLOBAL_ATTRIBUTE5                    VARCHAR2(150)  ,
   GLOBAL_ATTRIBUTE6                    VARCHAR2(150)  ,
   GLOBAL_ATTRIBUTE7                    VARCHAR2(150)  ,
   GLOBAL_ATTRIBUTE8                    VARCHAR2(150)  ,
   GLOBAL_ATTRIBUTE9                    VARCHAR2(150)  ,
   GLOBAL_ATTRIBUTE10                   VARCHAR2(150)  ,
   GLOBAL_ATTRIBUTE11                   VARCHAR2(150)  ,
   GLOBAL_ATTRIBUTE12                   VARCHAR2(150)  ,
   GLOBAL_ATTRIBUTE13                   VARCHAR2(150)  ,
   GLOBAL_ATTRIBUTE14                   VARCHAR2(150)  ,
   GLOBAL_ATTRIBUTE15                   VARCHAR2(150)  ,
   GLOBAL_ATTRIBUTE16                   VARCHAR2(150)  ,
   GLOBAL_ATTRIBUTE17                   VARCHAR2(150)  ,
   GLOBAL_ATTRIBUTE18                   VARCHAR2(150)  ,
   GLOBAL_ATTRIBUTE19                   VARCHAR2(150)  ,
   GLOBAL_ATTRIBUTE20                   VARCHAR2(150)  ,
   GLOBAL_ATTRIBUTE_NUMBER1             NUMBER         ,
   GLOBAL_ATTRIBUTE_NUMBER2             NUMBER         ,
   GLOBAL_ATTRIBUTE_NUMBER3             NUMBER         ,
   GLOBAL_ATTRIBUTE_NUMBER4             NUMBER         ,
   GLOBAL_ATTRIBUTE_NUMBER5             NUMBER         ,
   GLOBAL_ATTRIBUTE_DATE1               DATE           ,
   GLOBAL_ATTRIBUTE_DATE2               DATE           ,
   GLOBAL_ATTRIBUTE_DATE3               DATE           ,
   GLOBAL_ATTRIBUTE_DATE4               DATE           ,
   GLOBAL_ATTRIBUTE_DATE5               DATE           ,
   PJC_PROJECT_ID                       NUMBER(18)     ,
   PJC_TASK_ID                          NUMBER(18)     ,
   PJC_EXPENDITURE_TYPE_ID              NUMBER(18)     ,
   PJC_EXPENDITURE_ITEM_DATE            DATE           ,
   PJC_ORGANIZATION_ID                  NUMBER(18)     ,
   PJC_PROJECT_NUMBER                   VARCHAR2(25)   ,
   PJC_TASK_NUMBER                      VARCHAR2(100)  ,
   PJC_EXPENDITURE_TYPE_NAME            VARCHAR2(240)  ,
   PJC_ORGANIZATION_NAME                VARCHAR2(240)  ,
   PJC_RESERVED_ATTRIBUTE1              VARCHAR2(150)  ,
   PJC_RESERVED_ATTRIBUTE2              VARCHAR2(150)  ,
   PJC_RESERVED_ATTRIBUTE3              VARCHAR2(150)  ,
   PJC_RESERVED_ATTRIBUTE4              VARCHAR2(150)  ,
   PJC_RESERVED_ATTRIBUTE5              VARCHAR2(150)  ,
   PJC_RESERVED_ATTRIBUTE6              VARCHAR2(150)  ,
   PJC_RESERVED_ATTRIBUTE7              VARCHAR2(150)  ,
   PJC_RESERVED_ATTRIBUTE8              VARCHAR2(150)  ,
   PJC_RESERVED_ATTRIBUTE9              VARCHAR2(150)  ,
   PJC_RESERVED_ATTRIBUTE10             VARCHAR2(150)  ,
   PJC_USER_DEF_ATTRIBUTE1              VARCHAR2(150)  ,
   PJC_USER_DEF_ATTRIBUTE2              VARCHAR2(150)  ,
   PJC_USER_DEF_ATTRIBUTE3              VARCHAR2(150)  ,
   PJC_USER_DEF_ATTRIBUTE4              VARCHAR2(150)  ,
   PJC_USER_DEF_ATTRIBUTE5              VARCHAR2(150)  ,
   PJC_USER_DEF_ATTRIBUTE6              VARCHAR2(150)  ,
   PJC_USER_DEF_ATTRIBUTE7              VARCHAR2(150)  ,
   PJC_USER_DEF_ATTRIBUTE8              VARCHAR2(150)  ,
   PJC_USER_DEF_ATTRIBUTE9              VARCHAR2(150)  ,
   PJC_USER_DEF_ATTRIBUTE10             VARCHAR2(150)  ,
   FISCAL_CHARGE_TYPE                   VARCHAR2(30)   ,
   DEF_ACCTG_START_DATE                 DATE           ,
   DEF_ACCTG_END_DATE                   DATE           ,
   DEF_ACCRUAL_CODE_CONCATENATED        DATE           ,
   PJC_PROJECT_NAME                     VARCHAR2(240),
   PJC_TASK_NAME                        VARCHAR2(255), 
   PJC_WORK_TYPE                        VARCHAR2(240),
   PJC_CONTRACT_NAME                    VARCHAR2(300),
   PJC_CONTRACT_NUMBER                  VARCHAR2(120),
   PJC_FUNDING_SOURCE_NAME              VARCHAR2(360),
   PJC_FUNDING_SOURCE_NUMBER            VARCHAR2(50),
   REQUESTER_EMAIL_ADDRESS              VARCHAR2(240),
   LOAD_BATCH                           VARCHAR2(300),
   RCV_TRANSACTION_ID                   NUMBER(20)     
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
GRANT ALL ON XXMX_XFM.xxmx_ap_invoices_XFM TO xxmx_core;
--
--
GRANT ALL ON XXMX_XFM.xxmx_ap_invoice_lines_XFM TO xxmx_core;
--
--
--
PROMPT
PROMPT
PROMPT ********************************************************************************
PROMPT **                                
PROMPT ** Completed Installing Database Objects for Cloudbridge AP Invoices Data Migration
PROMPT **                                
PROMPT ********************************************************************************
PROMPT
PROMPT
--
