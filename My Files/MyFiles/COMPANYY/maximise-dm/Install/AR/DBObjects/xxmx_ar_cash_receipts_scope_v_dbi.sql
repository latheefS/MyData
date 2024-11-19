--
--
--*****************************************************************************
--**
--**                 Copyright (c) 2021 Version 1
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
--** FILENAME  :  xxmx_ar_cash_receipts_scope_v.sql
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
--** PURPOSE   :  This script installs the XXMX_CORE Synonyms to the XXMX_STG
--**              and XXMX_XFM schema tables.
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
--**   1.0  09-FEB-2021  Ian S. Vickerstaff  Created for Maximise.
--**
--**   1.1  16-FEB-2021  Ian S. Vickerstaff  Modified Org Query.
--**
--**   1.2  24-FEB-2021  Ian S. Vickerstaff  Modified Receipt Status rules.
--**
--**   1.3  26-FEB-2021  Ian S. Vickerstaff  Modified Receipt Status rules.
--**
--**   1.4  16-JUN-2021  Ian S. Vickerstaff  Modified view to retrieve Amount
--**                                         Due remaining from Payment
--**                                         Schedules table.
--**
--**   1.5  14-JUL-2021  Ian S. Vickerstaff  Header comment updates.
--**
--******************************************************************************
--
--
PROMPT
PROMPT
PROMPT *****************
PROMPT ** Creating Views
PROMPT *****************
--
--
PROMPT
PROMPT Creating View xxmx_ar_cash_receipts_scope_v
PROMPT
--
/*
***************************************
** VIEW : xxmx_ar_cash_receipts_scope_v
***************************************
*/
--
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_AR_CASH_RECEIPTS_SCOPE_V" ("ORG_ID", "OPERATING_UNIT_NAME", "CASH_RECEIPT_ID", "PAYMENT_SCHEDULE_ID", "CUSTOMER_ID", "EXCHANGE_RATE_TYPE", "EXCHANGE_RATE", "RECEIPT_AMOUNT_ORIGINAL", "RECEIPT_AMOUNT_REMAINING", "RECEIPT_METHOD_NAME") AS 
  WITH
     eligible_org_id_list
     AS
          (
           SELECT  DISTINCT
                   haou.organization_id                                AS org_id
                  ,haou.name                                           AS operating_unit_name
           FROM    apps.hr_all_organization_units@MXDM_NVIS_EXTRACT    haou
                  ,apps.hr_organization_information@MXDM_NVIS_EXTRACT  hoi
           WHERE   1 = 1
           AND     hoi.organization_id   = haou.organization_id
           AND     hoi.org_information1  = 'OPERATING_UNIT'
           AND     haou.name            IN (
                                            SELECT xsou.source_operating_unit_name
                                            FROM    xxmx_source_operating_units  xsou
                                            WHERE  1 = 1
                                            AND    NVL(xsou.migration_enabled_flag, 'N') = 'Y'
                                           )
          )
      SELECT  DISTINCT
              eoil.org_id
             ,eoil.operating_unit_name
             ,acra.cash_receipt_id
             ,apsa.payment_schedule_id
             ,apsa.customer_id
             ,apsa.exchange_rate_type
             ,apsa.exchange_rate
             ,ABS(apsa.amount_due_original)   AS receipt_amount_original
             ,ABS(apsa.amount_due_remaining)  AS receipt_amount_remaining
             ,(
               SELECT arm.name
               FROM   apps.ar_receipt_methods@MXDM_NVIS_EXTRACT      arm
               WHERE  1 = 1
               AND    arm.receipt_method_id = acra.receipt_method_id
              )                                                      AS receipt_method_name
     FROM     eligible_org_id_list                                   eoil
             ,apps.ar_cash_receipts_all@MXDM_NVIS_EXTRACT            acra
             ,apps.ar_payment_schedules_all@MXDM_NVIS_EXTRACT        apsa
             ,apps.ar_receivable_applications_all@MXDM_NVIS_EXTRACT  araa
     WHERE    1 = 1
     AND      acra.org_id                    = eoil.org_id                /* Cash Receipts to Operating Unit Parameters Join */
     AND      acra.type                     != 'MISC'                     /* Ensure Miscellaneous Receipts are omitted       */
     AND      apsa.org_id                    = acra.org_id                /* Payment Schedule to Cash Receipts Joins         */
     AND      apsa.cash_receipt_id           = acra.cash_receipt_id       /* Payment Schedule to Cash Receipts Joins         */
     AND      apsa.class                     = 'PMT'                      /* Payment Schedule Class for Cash Receipts        */
     AND      apsa.status                    = 'OP'                       /* Payment Schedule is OPen                        */
     AND      araa.org_id                    = apsa.org_id                /* Receipt Application to Payment Schedule Joins   */
     AND      araa.cash_receipt_id           = acra.cash_receipt_id       /* Receipt Application to Payment Schedule Joins   */
     AND      araa.payment_schedule_id       = apsa.payment_schedule_id   /* Receipt Application to Payment Schedule Joins   */
     AND      CASE
                   WHEN acra.status          = 'APP'
                   AND  araa.status          = 'ACC'
                   AND  araa.display         = 'Y'                        /* On Account Receipts                             */
                        THEN 'Y'                                          
                   WHEN acra.status          = 'APP'                      
                   AND  araa.status          = 'UNAPP'                    
                   AND  araa.display         = 'Y'                        /* Unapplied receipts - Criteria 1                 */
                        THEN 'Y'                                          
                   WHEN acra.status          = 'UNAPP'                    
                   AND  araa.amount_applied >= 0                          
                        THEN 'Y'                                          /* Unapplied receipts - Criteria 2                 */
                   WHEN acra.status          = 'UNID'                     
                   AND  araa.status          = 'UNID'                     /* Unidentified Receipts                           */
                        THEN 'Y'
                   ELSE 'N'
              END                            = 'Y';
/