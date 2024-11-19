--
--
--*****************************************************************************
--**
--**                 Copyright (c) 2023 Version 1
--**
--**                           Millennium House,
--**                           Millennium Walkway,
--**                           Dublin 1f
--**                           D01 F5P8
--**
--**                           All rights reserved.
--**
--*****************************************************************************
--**
--**
--** FILENAME  :  xxmx_populate_lookups.sql
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
--** PURPOSE   :  This script populates the XXMX_LOOKUP_TYPES and
--**              XXMX_LOOKUP_VALUES tables.
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
--**   1.0  13-DEC-2020  Ian S. Vickerstaff  Created for Cloudbridge.
--**
--**   1.1  13-JAN-2021  Ian S. Vickerstaff  Added Lookup Types and Codes.
--**
--**   1.2  14-JUL-2021  Ian S. Vickerstaff  Header comment updates.
--**
--**   1.3  28-FEB-2023  Pallavi Kanajar     Updated the script for Supplier_contact Business Entity
--**
--**   1.4  29-MAY-2023  Soundarya Kamatagi  Updated the script for Hcm_hr_location Business Entity
--**   1.5  26-DEC-2023  Pallavi Kanajar     Added entries for Payroll and Goal
--******************************************************************************
--
----
--** Delete Existing Data
--
DELETE
FROM   xxmx_core.xxmx_lookup_values xlv
WHERE  1 = 1
AND    EXISTS (
               SELECT 'X'
               FROM   xxmx_core.xxmx_lookup_types  xlt
               WHERE  1 = 1
               AND    xlt.lookup_type         = xlv.lookup_type
               AND    xlt.customisation_level = 'S'
              );
--
DELETE
FROM   xxmx_core.xxmx_lookup_types  xlt
WHERE  1 = 1
AND    xlt.customisation_level = 'S';
--
PROMPT *************************************
PROMPT ** POPULATING LOOKUPS METADATA TABLES
PROMPT *************************************
--
/*********************************************************************************/
--
/*
** Application Suites
*/
--
INSERT
INTO   xxmx_core.xxmx_lookup_types
          (
           application
          ,lookup_type
          ,customisation_level
          )
VALUES
          (
           'XXMX'
          ,'APPLICATION_SUITES'
          ,'S'
          );
          
--
INSERT
INTO   xxmx_core.xxmx_lookup_types
          (
           application
          ,lookup_type
          ,customisation_level
          )
VALUES
          (
           'XXMX','STG_POPULATION_METHODS','S'
          );
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'APPLICATION_SUITES'
         ,'FIN'
         ,'Financials'
         ,NULL
         ,'Y'
         ,'Y'
         );
         
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'APPLICATION_SUITES'
         ,'PPM'
         ,'Projects'
         ,NULL
         ,'Y'
         ,'Y'
         );         
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'APPLICATION_SUITES'
         ,'HCM'
         ,'Human Capital Management'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
/*********************************************************************************/
--
/*
** Application Codes
*/
--
INSERT
INTO   xxmx_core.xxmx_lookup_types
          (
           application
          ,lookup_type
          ,customisation_level
          )
VALUES
          (
           'XXMX'
          ,'APPLICATIONS'
          ,'S'
          );
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'APPLICATIONS'
         ,'AP'
         ,'Accounts Payable'
         ,NULL
         ,'Y'
         ,'Y'
         );
         
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'APPLICATIONS'
         ,'AR'
         ,'Accounts Receivable'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'APPLICATIONS'
         ,'FA'
         ,'Fixed Assets'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'APPLICATIONS'
         ,'GL'
         ,'General Ledger'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'APPLICATIONS'
         ,'PO'
         ,'Purchasing'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'APPLICATIONS'
         ,'HR'
         ,'Global Human Resources'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'APPLICATIONS'
         ,'PAY'
         ,'Payroll'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
/*********************************************************************************/
--
/*
** Business Entity Levels
*/
--
INSERT
INTO   xxmx_core.xxmx_lookup_types
          (
           application
          ,lookup_type
          ,customisation_level
          )
VALUES
          (
           'XXMX'
          ,'BUSINESS_ENTITY_LEVELS'
          ,'S'
          );
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'BUSINESS_ENTITY_LEVELS'
         ,'BE'
         ,'Business Entity'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'BUSINESS_ENTITY_LEVELS'
         ,'SE'
         ,'Sub-Entity'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
/*********************************************************************************/
--
/*
** Business Entities
*/
--
INSERT
INTO   xxmx_core.xxmx_lookup_types
          (
           application
          ,lookup_type
          ,customisation_level
          )
VALUES
          (
           'XXMX'
          ,'BUSINESS_ENTITIES'
          ,'S'
          );
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'BUSINESS_ENTITIES'
         ,'BANKS_AND_BRANCHES'
         ,'HCM Banks and Branches'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'BUSINESS_ENTITIES'
         ,'LOCATION'
         ,'LOCATION'
         ,NULL
         ,'Y'
         ,'Y'
         );


INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'BUSINESS_ENTITIES'
         ,'TALENT'
         ,'Talent Profile'
         ,NULL
         ,'Y'
         ,'Y'
         );		 
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'BUSINESS_ENTITIES'
         ,'BALANCES'
         ,'GL Balances'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'BUSINESS_ENTITIES'
         ,'OPEN_BAL'
         ,'OPEN BALANCES'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'BUSINESS_ENTITIES'
         ,'SUMM_BAL'
         ,'SUMMARY BALANCES'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'BUSINESS_ENTITIES'
         ,'DETAIL_BAL'
         ,'DETAIL BALANCES'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'BUSINESS_ENTITIES'
         ,'CHART_OF_ACCOUNTS'
         ,'HCM Banks and Branches'
         ,NULL
         ,'Y'
         ,'Y'
         );
		 
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'BUSINESS_ENTITIES'
         ,'SUPPLIERS'
         ,'Suppliers'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'BUSINESS_ENTITIES'
         ,'SUPPLIER_SITES'
         ,'Supplier Sites'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'BUSINESS_ENTITIES'
         ,'SUPPLIER_ADDRESSES'
         ,'Supplier Address'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'BUSINESS_ENTITIES'
         ,'SUPPLIER_SITE_ASSIGNS'
         ,'Supplier Site Assignments'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'BUSINESS_ENTITIES'
         ,'SUPPLIER_BANK_ACCOUNTS'
         ,'Supplier Banks'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'BUSINESS_ENTITIES'
         ,'SUPPLIER_TAX'
         ,'SUPPLIER TAX'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'BUSINESS_ENTITIES'
         ,'CUSTOMERS'
         ,'Customers'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'BUSINESS_ENTITIES'
         ,'INVOICES'
         ,'Invoices'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'BUSINESS_ENTITIES'
         ,'PURCHASE_ORDERS'
         ,'Purchase Orders'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
/*********************************************************************************/
--
/*
** Sub-Entity Types
*/
--
INSERT
INTO   xxmx_core.xxmx_lookup_types
          (
           application
          ,lookup_type
          ,customisation_level
          )
VALUES
          (
           'XXMX'
          ,'SUB-ENTITIES'
          ,'S'
          );
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'BANKS'
         ,'Banks'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'BANK_BRANCHES'
         ,'Bank Branches'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'LOCATION'
         ,'LOCATION'
         ,NULL
         ,'Y'
         ,'Y'
         );
		 
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'SEGMENT_VALUES'
         ,'GL Segment Value Set Values'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'SEGMENT_HIERARCHS'
         ,'GL Segment Value Hierarchies'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'ACCOUNT_CODES'
         ,'GL Account Code Combinations'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'BALANCES'
         ,'GL Balances'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'OPEN_BAL'
         ,'OPEN BALANCES'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'SUMM_BAL'
         ,'SUMMARY BALANCES'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'DETAIL_BAL'
         ,'DETAIL BALANCES'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'SUPPLIERS'
         ,'Suppliers'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'SUPPLIER_ADDRESSES'
         ,'Supplier Addresses'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'SUPPLIER_SITES'
         ,'Suppliers Sites'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'SUPPLIER_SITE_ASSIGNS'
         ,'Supplier Site Assignments'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'SUPPLIER_CONTACTS'
         ,'Supplier Contacts'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'SUPPLIER_CONT_ADDRS'
         ,'Supplier Contact Addresses'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'SUPPLIER_THIRD_PARTY_RELS'
         ,'Supplier 3rd Party Relationships'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'SUPPLIER_PAYEES'
         ,'Supplier Payees'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'SUPPLIER_PMT_INSTRS'
         ,'Supplier Payment Instruments'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'SUPPLIER_BANK_ACCOUNTS'
         ,'Supplier Bank Accounts'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'SUPPLIER_BUSINESS_CLASSIFS'
         ,'Supplier Business Classififcations'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'PARTY_TAX_PROFILE_CTL'
         ,'PARTY TAX PROFILE CONTROLS'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'TAX_REGISTRATIONS'
         ,'TAX REGISTRATIONS'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'INVOICE_HEADERS'
         ,'Invoice Headers'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'INVOICE_LINES'
         ,'Invoice Lines'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'CUSTOMER_ACCOUNTS'
         ,'Customer Accounts'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'CUSTOMER_ACCOUNT_SITES'
         ,'Customer Accounts'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'CUSTOMER_ACCOUNT_SITE_USES'
         ,'Customer Account Site Uses'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'CUST_ACCT_CONTACTS'
         ,'Customer Account Contacts'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'CUSTOMER_PROFILES'
         ,'Customer Profiles'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'CUST_ACCT_RELATIONSHIPS'
         ,'Customer Account Relationships'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'PARTIES'
         ,'Parties'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'PARTY_SITES'
         ,'Party Sites'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'PARTY_SITES_USES'
         ,'Party Site Uses'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'CONTACT_POINTS'
         ,'Customer Contact Points'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'ORG_CONTACTS'
         ,'Customer Org Contacts'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'CONTACT_ROLES'
         ,'Customer Contact Roles'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'ROLES_AND_RESPONSIBILITIES'
         ,'Customer Roles and Responsibilities'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'LOCATIONS'
         ,'Party Locations'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'PERSON_LANGUAGES'
         ,'Person Languages'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'CUST_RECEIPT_METHODS'
         ,'Customer Receipt Methods'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'RA_CUST_INV_DIST'
         ,'Customer Transaction Distributions'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'SALESCREDITS'
         ,'Customer Transaction Salescredits'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'CASH_RECEIPTS'
         ,'Cash Receipts'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'HCMEMPLOYEE'
         ,'Employees'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
--/*********************************************************************************/
--
/*
** XXMX Utilities Procedure/Function Call Sources
*/
--
INSERT
INTO   xxmx_core.xxmx_lookup_types
          (
           application
          ,lookup_type
          ,customisation_level
          )
VALUES
          (
           'XXMX'
          ,'CALL_SOURCES'
          ,'S'
          );
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'CALL_SOURCES'
         ,'PLSQL'
         ,'PL/SQL'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'CALL_SOURCES'
         ,'OIC'
         ,'Oracle Integration Cloud'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
--/*********************************************************************************/
--
/*
** XXMX Utilities Transform Performers
*/
--
INSERT
INTO   xxmx_core.xxmx_lookup_types
          (
           application
          ,lookup_type
          ,customisation_level
          )
VALUES
          (
           'XXMX'
          ,'TRANSFORM_PERFORMERS'
          ,'S'
          );
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'TRANSFORM_PERFORMERS'
         ,'PLSQL'
         ,'PL/SQL'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'TRANSFORM_PERFORMERS'
         ,'OIC'
         ,'Oracle Integration Cloud'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
--/*********************************************************************************/
--
/*
** XXMX File Types
*/
--
INSERT
INTO   xxmx_core.xxmx_lookup_types
          (
           application
          ,lookup_type
          ,customisation_level
          )
VALUES
          (
           'XXMX'
          ,'FILE_TYPES'
          ,'S'
          );
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'FILE_TYPES'
         ,'DATA'
         ,'Data Files (generated from Client Extract Data)'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'FILE_TYPES'
         ,'PROPERTIES'
         ,'Properties File required to initiate auto-import in Fusion Cloud'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'FILE_TYPES'
         ,'ZIP'
         ,'Zip File contains Data Files and a Properties File'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
/*********************************************************************************/
--
/*
** XXMX File Location Types
*/
--
INSERT
INTO   xxmx_core.xxmx_lookup_types
          (
           application
          ,lookup_type
          ,customisation_level
          )
VALUES
          (
           'XXMX'
          ,'FILE_LOCATION_TYPES'
          ,'S'
          );
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'FILE_LOCATION_TYPES'
         ,'OIC_INTERNAL'
         ,'OIC Flow Temporary File Area'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'FILE_LOCATION_TYPES'
         ,'FTP_DATA'
         ,'Data File Source Location on FTP Server'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'FILE_LOCATION_TYPES'
         ,'FTP_PROCESS'
         ,'Data File Processing Location on FTP Server'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'FILE_LOCATION_TYPES'
         ,'FTP_OUTPUT'
         ,'Generated Zip File Location on FTP Server'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'APPLICATION'
         ,'PPM'
         ,'PPM'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'BUSINESS_ENTITIES'
         ,'AR_INVOICES'
         ,'Invoices'
         ,NULL
         ,'Y'
         ,'Y'
         );         
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'BUSINESS_ENTITIES'
         ,'CANDIDATE'
         ,'Candidate'
         ,NULL
         ,'Y'
         ,'Y'
         );   
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'BUSINESS_ENTITIES'
         ,'CANDIDATE_POOL'
         ,'Candidate Pool'
         ,NULL
         ,'Y'
         ,'Y'
         );
--         
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'BUSINESS_ENTITIES'
         ,'FIXED_ASSETS'
         ,'Fixed Assets'
         ,NULL
         ,'Y'
         ,'Y'
         );          
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'BUSINESS_ENTITIES'
         ,'GENERAL_LEDGER'
         ,'GL Journal'
         ,NULL
         ,'Y'
         ,'Y'
         );         
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'BUSINESS_ENTITIES'
         ,'GEOGRAPHY_HIERARCHY'
         ,'Geography Hierarchy'
         ,NULL
         ,'Y'
         ,'Y'
         ); 
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'BUSINESS_ENTITIES'
         ,'JOB_REFERRAL'
         ,'Job Referral'
         ,NULL
         ,'Y'
         ,'Y'
         );  
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'BUSINESS_ENTITIES'
         ,'JOB_REQUISITION'
         ,'Job Requisition'
         ,NULL
         ,'Y'
         ,'Y'
         );  
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'BUSINESS_ENTITIES'
         ,'PRJ_FOUNDATION'
         ,'Projects'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'BUSINESS_ENTITIES'
         ,'PROSPECT'
         ,'Prospect'
         ,NULL
         ,'Y'
         ,'Y'
         ); 
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'BUSINESS_ENTITIES'
         ,'WORKER'
         ,'WORKER'
         ,NULL
         ,'Y'
         ,'Y'
         );        
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'STG_POPULATION_METHODS'
         ,'DATA_FILE'
         ,'Client Data loaded from Data File'
         ,NULL
         ,'Y'
         ,'Y'
         );    
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'STG_POPULATION_METHODS'
         ,'DB_LINK'
         ,'Client Data extracted via DB Link'
         ,NULL
         ,'Y'
         ,'Y'
         );   
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUPPLIER_TYPE'
         ,'Internal'
         ,'Valid Supplier Type'
         ,NULL
         ,'Y'
         ,'Y'
         ); 
         
--

Insert into xxmx_lookup_values
      (  
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
values ('XXMX',
         'BUSINESS_ENTITIES',
         'PRJ_COST',
         'Project_cost',
         NULL,
         'Y',
         'Y'
       );        
--
Insert into xxmx_lookup_values
      (  
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
values ('XXMX',
         'BUSINESS_ENTITIES',
         'PRJ_RBS',
         'Project Resources',
         NULL,
         'Y',
         'Y'
       );       
--         
Insert into xxmx_lookup_values
      (  
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
values ('XXMX',
         'BUSINESS_ENTITIES',
         'PRJ_EVENTS',
         'Project Billing Events',
         NULL,
         'Y',
         'Y'
       );
       
Insert into xxmx_lookup_values
      (  
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
values ('XXMX',
         'BUSINESS_ENTITIES',
         'CASH_RECEIPTS',
         'AR Cash Receipts',
         NULL,
         'Y',
         'Y'
       );  


Insert into xxmx_lookup_values
      (  
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
values ('XXMX',
         'BUSINESS_ENTITIES',
         'TRANSACTIONS',
         'AR Transactions',
         NULL,
         'Y',
         'Y'
       ); 

Insert into xxmx_lookup_values
      (  
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
values ('XXMX',
         'BUSINESS_ENTITIES',
         'PERSON',
         'Person',
         NULL,
         'Y',
         'Y'
       );  

Insert into xxmx_lookup_values
      (  
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
values ('XXMX',
         'BUSINESS_ENTITIES',
         'PURCHASE_ORDERS_BPA',
         'Blanket Purchase',
         NULL,
         'Y',
         'Y'
       );  
--
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'PO_HEADERS_BPA'
         ,'BPA Headers'
         ,NULL
         ,'Y'
         ,'Y'
         );
		 
--
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'PO_LINES_BPA'
         ,'BPA Lines'
         ,NULL
         ,'Y'
         ,'Y'
         );		       
--
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'PO_LINE_LOCATIONS_BPA'
         ,'BPA Line Locations'
         ,NULL
         ,'Y'
         ,'Y'
         );
		 
--
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'PO_ORG_ASSIGN_BPA'
         ,'BPA Org Assignments'
         ,NULL
         ,'Y'
         ,'Y'
         );		       
--
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'PO_ATTR_VALUES_BPA'
         ,'BPA Attribute Values'
         ,NULL
         ,'Y'
         ,'Y'
         );
		 
--
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'PO_ATTR_TLP_BPA'
         ,'BPA Translated Attributes'
         ,NULL
         ,'Y'
         ,'Y'
         );		       
	   
--
--
Insert into xxmx_lookup_values
      (  
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
values ('XXMX',
         'BUSINESS_ENTITIES',
         'PURCHASE_ORDERS_CPA',
         'Contract Purchase',
         NULL,
         'Y',
         'Y'
       ); 
--
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'PO_HEADERS_CPA'
         ,'CPA Headers'
         ,NULL
         ,'Y'
         ,'Y'
         );		 
--
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'PO_ORG_ASSIGN_CPA'
         ,'CPA Org Assignments'
         ,NULL
         ,'Y'
         ,'Y'
         );		       
	   
--
--
Insert into xxmx_lookup_values
      (  
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
values ('XXMX',
         'BUSINESS_ENTITIES',
         'DAILY_RATES',
         'GL Daily Rates',
         NULL,
         'Y',
         'Y'
       ); 

INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'BUSINESS_ENTITIES'
         ,'HISTORICAL_RATES'
         ,'Historical Rates'
         ,NULL
         ,'Y'
         ,'Y'
         );
		 
--
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'HISTORICAL_RATES'
         ,'Historical Rates'
         ,NULL
         ,'Y'
         ,'Y'
         );
       
--       
--     
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'BUSINESS_ENTITIES'
         ,'PURCHASE_ORDER_RECEIPT'
         ,'Purchase Order Receipt'
         ,NULL
         ,'Y'
         ,'Y'
         );
		 
--
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'PO_RECEIPT_HEADERS'
         ,'PO Receipt Headers'
         ,NULL
         ,'Y'
         ,'Y'
         );
		 
--
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'PO_RECEIPT_TRANSACTIONS'
         ,'PO Receipt Transactions'
         ,NULL
         ,'Y'
         ,'Y'
         );		       
	   
--
--
--Added as part of V1.3
INSERT 
INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES (
	'XXMX'
	,'BUSINESS_ENTITIES'
	,'SUPPLIER_CONTACT'
	,'Supplier Contact'
	,NULL
	,'Y'
	,'Y'
	);

INSERT 
INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES (
	'XXMX'
	,'BUSINESS_ENTITIES'
	,'LEARNING'
	,'Learning'
	,NULL
	,'Y'
	,'Y'
	);


INSERT 
INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES (
	'XXMX'
	,'BUSINESS_ENTITIES'
	,'LEARNING_V3'
	,'Learning Version 3'
	,NULL
	,'Y'
	,'Y'
	);

INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'BUSINESS_ENTITIES'
         ,'CALC_CARDS_PAE'
         ,'PAE Calculation Card'
         ,NULL
         ,'Y'
         ,'Y'
         );
		 
--
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'CALC_CARDS_PAE'
         ,'calc cards pae'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'COMP_DTL_PAE'
         ,'comp dtl pae'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'COMP_ASOC_PAE'
         ,'comp asoc pae'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'COMP_ASOC_DTL_PAE'
         ,'comp asoc dtl pae'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'BUSINESS_ENTITIES'
         ,'CALC_CARDS_SD'
         ,'Statutory Deductions'
         ,NULL
         ,'Y'
         ,'Y'
         );
		 
--
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'CALC_CARDS_SD'
         ,'calc cards sd'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'COMP_DTL_SD'
         ,'comp dtl sd'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'BUSINESS_ENTITIES'
         ,'CALC_CARDS_SL'
         ,'Student Loan'
         ,NULL
         ,'Y'
         ,'Y'
         );
		 
--
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'CALC_CARDS_SL'
         ,'calc cards sl'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'COMP_SL'
         ,'comp sl'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'CARD_ASOC_SL'
         ,'card asoc sl'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'COMP_DTL_SL'
         ,'comp dtl sl'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'COMP_ASOC_SL'
         ,'comp asoc sl'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'BUSINESS_ENTITIES'
         ,'CALC_CARDS_BP'
         ,'Benefit and Pension'
         ,NULL
         ,'Y'
         ,'Y'
         );
		 
--
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'CALC_CARDS_BP'
         ,'calc cards bp'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'CARD_COMP_BP'
         ,'card comp bp'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'ASOC_BP'
         ,'asoc bp'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'ASOC_DTL_BP'
         ,'asoc dtl bp'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'COMP_DTL_BP'
         ,'comp dtl bp'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'ENTVAL_BP'
         ,'entval bp'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'CALC_VALDF_BP'
         ,'calc valdf bp'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'BUSINESS_ENTITIES'
         ,'CALC_CARDS_NSD'
         ,'New Starter Declaration'
         ,NULL
         ,'Y'
         ,'Y'
         );
		 
--
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'CALC_CARDS_NSD'
         ,'calc cards nsd'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'CARD_COMP_NSD'
         ,'card comp nsd'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'ASOC_NSD'
         ,'asoc nsd'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'ASOC_DTL_NSD'
         ,'asoc dtl nsd'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'COMP_DTL_NSD'
         ,'comp dtl nsd'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'ENTVAL_NSD'
         ,'entval nsd'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'CALC_VALDF_NSD'
         ,'calc valdf nsd'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'BUSINESS_ENTITIES'
         ,'CALC_CARDS_PGL'
         ,'Post Graduate Loan'
         ,NULL
         ,'Y'
         ,'Y'
         );
		 
--
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'CALC_CARDS_PGL'
         ,'calc cards pgl'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'CARD_COMP_PGL'
         ,'card comp pgl'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'ASOC_PGL'
         ,'asoc pgl'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'ASOC_DTL_PGL'
         ,'asoc dtl pgl'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'COMP_DTL_PGL'
         ,'comp dtl pgl'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'ENTVAL_PGL'
         ,'entval pgl'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'CALC_VALDF_PGL'
         ,'calc valdf pgl'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'BUSINESS_ENTITIES'
         ,'PAY_BALANCES'
         ,'Balances'
         ,NULL
         ,'Y'
         ,'Y'
         );
		 
--
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'BALANCE_HEADERS'
         ,'Pay balance headers'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'BALANCE_LINES'
         ,'Pay balance lines'
         ,NULL
         ,'Y'
         ,'Y'
         );
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'BUSINESS_ENTITIES'
         ,'ELEMENTS'
         ,'Elements'
         ,NULL
         ,'Y'
         ,'Y'
         );
		 
--
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'ELEMENTS'
         ,'Pay elements'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'ELEM_ENTRIES'
         ,'Element entries'
         ,NULL
         ,'Y'
         ,'Y'
         );

INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'BUSINESS_ENTITIES'
         ,'GOAL'
         ,'GOAL'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
/*********************************************************************************/
--
/*
** Sub-Entity Types
*/
--
INSERT
INTO   xxmx_core.xxmx_lookup_types
          (
           application
          ,lookup_type
          ,customisation_level
          )
VALUES
          (
           'XXMX'
          ,'SUB-ENTITIES'
          ,'S'
          );
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'GOAL'
         ,'GOAL'
         ,NULL
         ,'Y'
         ,'Y'
         );

INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'GTARGT_OUTCME_PROFILE_ITM'
         ,'GTARGT OUTCME PROFILE ITM'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'GOAL_ACCESS'
         ,'GOAL ACCESS'
         ,NULL
         ,'Y'
         ,'Y'
         );
--                                                                                                                                                                                                                    
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'GOAL_ACTION'
         ,'GOAL ACTION'
         ,NULL
         ,'Y'
         ,'Y'
         );

--                                                                                                                                                                                                                    
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'GOAL_ALIGNMENT'
         ,'GOAL ALIGNMENT'
         ,NULL
         ,'Y'
         ,'Y'
         );
		 
--                                                                                                                                                                                                                    
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'GOAL_PLAN_GOAL'
         ,'GOAL PLAN GOAL'
         ,NULL
         ,'Y'
         ,'Y'
         );
--                                                                                                                                                                                                                    
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'GTARGET_OUTCOME'
         ,'GTARGET OUTCOME'
         ,NULL
         ,'Y'
         ,'Y'
         );
--                                                                                                                                                                                                                    
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'GOAL_MEASUREMENT'
         ,'GOAL MEASUREMENT'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'BUSINESS_ENTITIES'
         ,'GOAL_PLAN'
         ,'GOAL PLAN'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
/*********************************************************************************/
--
/*
** Sub-Entity Types
*/
--
INSERT
INTO   xxmx_core.xxmx_lookup_types
          (
           application
          ,lookup_type
          ,customisation_level
          )
VALUES
          (
           'XXMX'
          ,'SUB-ENTITIES'
          ,'S'
          );
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'GOAL_PLAN'
         ,'GOAL PLAN'
         ,NULL
         ,'Y'
         ,'Y'
         );

INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'GOAL_PLAN_GOAL'
         ,'GOAL PLAN GOAL'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'MASS_REQUEST'
         ,'MASS REQUEST'
         ,NULL
         ,'Y'
         ,'Y'
         );
--                                                                                                                                                                                                                    
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'ELIGIBILITY_PROFILE_OBJECT'
         ,'ELIGIBILITY PROFILE OBJECT'
         ,NULL
         ,'Y'
         ,'Y'
         );

--                                                                                                                                                                                                                    
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'MASS_REQUEST_ASSIGNMENT'
         ,'MASS REQUEST ASSIGNMENT'
         ,NULL
         ,'Y'
         ,'Y'
         );
		 
--                                                                                                                                                                                                                    
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'MASS_REQUEST_HIERARCHY'
         ,'MASS REQUEST HIERARCHY'
         ,NULL
         ,'Y'
         ,'Y'
         );
--                                                                                                                                                                                                                    
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'MASS_REQUEST_EXEMPTION'
         ,'MASS REQUEST EXEMPTION'
         ,NULL
         ,'Y'
         ,'Y'
         );
--                                                                                                                                                                                                                    
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'GOAL_PLAN_DOC_TYPES'
         ,'GOAL PLAN DOC TYPES'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
--

--                                                                                                                                                                                                                    
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'GOAL_PLAN_ASSIGNMENT'
         ,'GOAL PLAN ASSIGNMENT'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'BUSINESS_ENTITIES'
         ,'GOAL PLAN SET'
         ,'GOAL PLAN SET'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
/*********************************************************************************/
--
/*
** Sub-Entity Types
*/
--*********************************************************************************/
--
INSERT
INTO   xxmx_core.xxmx_lookup_types
          (
           application
          ,lookup_type
          ,customisation_level
          )
VALUES
          (
           'XXMX'
          ,'SUB-ENTITIES'
          ,'S'
          );
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'GOAL_PLAN_SET'
         ,'GOAL PLAN SET'
         ,NULL
         ,'Y'
         ,'Y'
         );

INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'GOAL_PLAN_SET_PLAN'
         ,'GOAL PLAN SET PLAN'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'GPSET_MASS_REQUEST'
         ,'GPSET MASS REQUEST'
         ,NULL
         ,'Y'
         ,'Y'
         );
--                                                                                                                                                                                                                    
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'GPSET_ELIGIBILITY_PRO_OBJ'
         ,'GPSET ELIGIBILITY PRO OBJ'
         ,NULL
         ,'Y'
         ,'Y'
         );

--                   
--                                                                                                                                                                                                                    
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'GPSET_MASS_REQUEST_HIERARCHY'
         ,'GPSET MASS REQUEST HIERARCHY'
         ,NULL
         ,'Y'
         ,'Y'
         );
--                   
--                                                                                                                                                                                                                    
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'GPSET_MASS_REQUEST_EXEMPTION'
         ,'GPSET MASS REQUEST EXEMPTION'
         ,NULL
         ,'Y'
         ,'Y'
         );

INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'BUSINESS_ENTITIES'
         ,'PERFORMANCE_DOCUMENT'
         ,'Performance Document'
         ,NULL
         ,'Y'
         ,'Y'
         );
		 
--
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'PERFORMANCE_DOCUMENT'
         ,'Performance Document'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'ATTACHMENT'
         ,'Attachment'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'PARTICIPANT'
         ,'Participant'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
--
INSERT
INTO   xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'RATINGS_COMMENTS'
         ,'Ratings And Comments'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
--
--
INSERT INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'BUSINESS_ENTITIES'
         ,'ITEM'
         ,'ITEM'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
--
--
/*********************************************************************************/
--
/*
** Sub-Entity Types
*/
--
INSERT
INTO   xxmx_core.xxmx_lookup_types
          (
           application
          ,lookup_type
          ,customisation_level
          )
VALUES
          (
           'XXMX'
          ,'SUB-ENTITIES'
          ,'S'
          );
--
--
--
INSERT INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'ITEMS_IMPORT'
         ,'ITEMS IMPORT'
         ,NULL
         ,'Y'
         ,'Y'
         );
--

INSERT INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'ITEM_REVISIONS_IMP'
         ,'ITEM REVISIONS IMP'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
--
INSERT INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'ITEM_CATEGORIES_IMP'
         ,'ITEM CATEGORIES IMP'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
--
INSERT INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'ITEM_ASSOCIATIONS_IMP'
         ,'ITEM ASSOCIATIONS IMP'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
--
INSERT INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'ITEM_RELATIONSHIPS_IMP'
         ,'ITEM RELATIONSHIPS IMP'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
--
INSERT INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'ITEM_EXT_FLEXFIELDS_IMP'
         ,'ITEM EXT FLEXFIELDS IMP'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
--
INSERT INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'ITEM_TRANS_EXT_FLEXFIELDS_IMP'
         ,'ITEM TRANS EXT FLEXFIELDS IMP'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
--
INSERT INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'ITEM_REVISION_EXT_FLEXFIELDS_IMP'
         ,'ITEM REVISION EXT FLEXFIELDS IMP'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
--
INSERT INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'ITEM_REV_TRANS_EXT_FLEXFIELDS_IMP'
         ,'ITEM REV TRANS EXT FLEXFIELDS IMP'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
--
INSERT INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'ITEM_SUPPLIER_EXT_FLEXFIELDS_IMP'
         ,'ITEM SUPPLIER EXT FLEXFIELDS IMP'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
--
INSERT INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'ITEM_SUPP_TRANS_EXT_FLEXFIELDS_IMP'
         ,'ITEM SUPP TRANS EXT FLEXFIELDS IMP'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
--
INSERT INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'ITEM_STYLE_VAR_ATTR_VAL'
         ,'ITEM STYLE VAR ATTR VAL'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
--
INSERT INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'TRADING_PARTNER_ITEMS_IMPORT'
         ,'TRADING PARTNER ITEMS IMPORT'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
--
--
INSERT INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'BUSINESS_ENTITIES'
         ,'ITEM_STRUCTURE'
         ,'ITEM STRUCTURE'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
--
--
/*********************************************************************************/
--
/*
** Sub-Entity Types
*/
--
INSERT
INTO   xxmx_core.xxmx_lookup_types
          (
           application
          ,lookup_type
          ,customisation_level
          )
VALUES
          (
           'XXMX'
          ,'SUB-ENTITIES'
          ,'S'
          );
--
--
INSERT INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'STRUCTURE_HEADERS_IMP'
         ,'STRUCTURE HEADERS IMP'
         ,NULL
         ,'Y'
         ,'Y'
         );

-- 
--
INSERT INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'COMPONENTS_IMPORT'
         ,'COMPONENTS IMPORT'
         ,NULL
         ,'Y'
         ,'Y'
         );

-- 
--
INSERT INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'SUBSTITUTE_COMPONENTS_IMP'
         ,'SUBSTITUTE COMPONENTS IMP'
         ,NULL
         ,'Y'
         ,'Y'
         );

-- 
--
INSERT INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'REFERENCE_DESIGNATORS_IMP'
         ,'REFERENCE DESIGNATORS IMP'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
--
INSERT INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'BUSINESS_ENTITIES'
         ,'INVENTORY_TRANSACTIONS'
         ,'INVENTORY TRANSACTIONS'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
--
/*********************************************************************************/
--
/*
** Sub-Entity Types
*/
--
INSERT
INTO   xxmx_core.xxmx_lookup_types
          (
           application
          ,lookup_type
          ,customisation_level
          )
VALUES
          (
           'XXMX'
          ,'SUB-ENTITIES'
          ,'S'
          );
--
--
INSERT INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'INVENTORY_TRANSACTION_IMP'
         ,'INVENTORY TRANSACTION IMP'
         ,NULL
         ,'Y'
         ,'Y'
         );

-- 
--
INSERT INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'INVENTORY_LOTS_IMP'
         ,'INVENTORY LOTS IMP'
         ,NULL
         ,'Y'
         ,'Y'
         );

-- 
--
INSERT INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'INV_SERIAL_NUM_IMP'
         ,'INV SERIAL NUM IMP'
         ,NULL
         ,'Y'
         ,'Y'
         );

-- 
--
INSERT INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'TRANSACTION_COSTS_IMP'
         ,'TRANSACTION COSTS IMP'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
--
--
INSERT INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'BUSINESS_ENTITIES'
         ,'PRICE_LIST'
         ,'PRICE LIST'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
--
--
/*********************************************************************************/
--
/*
** Sub-Entity Types
*/
--
INSERT
INTO   xxmx_core.xxmx_lookup_types
          (
           application
          ,lookup_type
          ,customisation_level
          )
VALUES
          (
           'XXMX'
          ,'SUB-ENTITIES'
          ,'S'
          );
--
--
INSERT INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'PRICE_LIST_HEADER_IMP'
         ,'PRICE LIST HEADER IMP'
         ,NULL
         ,'Y'
         ,'Y'
         );

-- 
--
INSERT INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'PRICE_LIST_ACCESS_SETS_IMP'
         ,'PRICE LIST ACCESS SETS IMP'
         ,NULL
         ,'Y'
         ,'Y'
         );

-- 
--
INSERT INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'PRICE_LIST_ITEMS_IMP'
         ,'PRICE LIST ITEMS IMP'
         ,NULL
         ,'Y'
         ,'Y'
         );

-- 
--
INSERT INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'PRICE_LIST_CHARGES_IMP'
         ,'PRICE LIST CHARGES IMP'
         ,NULL
         ,'Y'
         ,'Y'
         );

-- 
--
INSERT INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'PRICE_LIST_COMP_ITEMS_IMP'
         ,'PRICE LIST COMP ITEMS IMP'
         ,NULL
         ,'Y'
         ,'Y'
         );

-- 
--
INSERT INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'PRICE_LIST_COVERED_ITEMS_IMP'
         ,'PRICE LIST COVERED ITEMS IMP'
         ,NULL
         ,'Y'
         ,'Y'
         );

-- 
--
INSERT INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'PRICE_LIST_TIER_HDR_IMP'
         ,'PRICE LIST TIER HDR IMP'
         ,NULL
         ,'Y'
         ,'Y'
         );

-- 
--
INSERT INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'PRICE_LIST_TIER_LINES_IMP'
         ,'PRICE LIST TIER LINES IMP'
         ,NULL
         ,'Y'
         ,'Y'
         );

-- 
--
INSERT INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'PRICE_LIST_MATRIX_IMP'
         ,'PRICE LIST MATRIX IMP'
         ,NULL
         ,'Y'
         ,'Y'
         );

-- 
--
INSERT INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'PRICE_LIST_MATRIX_RULES_IMP'
         ,'PRICE LIST MATRIX RULES IMP'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
--
--
INSERT INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'BUSINESS_ENTITIES'
         ,'DISCOUNT_LISTS'
         ,'DISCOUNT LISTS'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
--
/*********************************************************************************/
--
/*
** Sub-Entity Types
*/
--
INSERT
INTO   xxmx_core.xxmx_lookup_types
          (
           application
          ,lookup_type
          ,customisation_level
          )
VALUES
          (
           'XXMX'
          ,'SUB-ENTITIES'
          ,'S'
          );
--
--
INSERT INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'DL_HEADER_IMPORT'
         ,'DL HEADER IMPORT'
         ,NULL
         ,'Y'
         ,'Y'
         );

-- 
--
INSERT INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'DL_ACCESS_SETS_IMP'
         ,'DL ACCESS SETS IMP'
         ,NULL
         ,'Y'
         ,'Y'
         );

-- 
--
INSERT INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'DISCOUNT_LIST_ITEMS_IMP'
         ,'DISCOUNT LIST ITEMS IMP'
         ,NULL
         ,'Y'
         ,'Y'
         );

-- 
--
INSERT INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'PRICING_TERMS_IMP'
         ,'PRICING TERMS IMP'
         ,NULL
         ,'Y'
         ,'Y'
         );

-- 
--
INSERT INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'DL_MATRIX_DIMENSION_IMP'
         ,'DL MATRIX DIMENSION IMP'
         ,NULL
         ,'Y'
         ,'Y'
         );

-- 
--
INSERT INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'DL_MATRIX_RULES_IMP'
         ,'DL MATRIX RULES IMP'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
--
INSERT INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'BUSINESS_ENTITIES'
         ,'COST_LISTS'
         ,'COST LISTS'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
--
--
/*********************************************************************************/
--
/*
** Sub-Entity Types
*/
--
INSERT
INTO   xxmx_core.xxmx_lookup_types
          (
           application
          ,lookup_type
          ,customisation_level
          )
VALUES
          (
           'XXMX'
          ,'SUB-ENTITIES'
          ,'S'
          );
--
--
INSERT INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'COST_LIST_HEADER_IMPORT'
         ,'COST LIST HEADER IMPORT'
         ,NULL
         ,'Y'
         ,'Y'
         );

-- 
--
INSERT INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'COST_LIST_ACCESS_SETS_IMPORT'
         ,'COST LIST ACCESS SETS IMPORT'
         ,NULL
         ,'Y'
         ,'Y'
         );

-- 
--
INSERT INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'COST_LIST_ITEMS_IMPORT'
         ,'COST LIST ITEMS IMPORT'
         ,NULL
         ,'Y'
         ,'Y'
         );

-- 
--
INSERT INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'COST_LIST_CHARGES_IMPORT'
         ,'COST LIST CHARGES IMPORT'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
--
--
INSERT INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'BUSINESS_ENTITIES'
         ,'SALES_ORDERS'
         ,'SALES ORDERS'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
--
--
/*********************************************************************************/
--
/*
** Sub-Entity Types
*/
--
INSERT
INTO   xxmx_core.xxmx_lookup_types
          (
           application
          ,lookup_type
          ,customisation_level
          )
VALUES
          (
           'XXMX'
          ,'SUB-ENTITIES'
          ,'S'
          );
--
--
INSERT INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'ORDER_HEADERS_IMPORT'
         ,'ORDER HEADERS IMPORT'
         ,NULL
         ,'Y'
         ,'Y'
         );

-- 
--
INSERT INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'ORDER_LINES_IMPORT'
         ,'ORDER LINES IMPORT'
         ,NULL
         ,'Y'
         ,'Y'
         );

-- 
--
INSERT INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'ORDER_ADDRESSES_IMPORT'
         ,'ORDER ADDRESSES IMPORT'
         ,NULL
         ,'Y'
         ,'Y'
         );

-- 
--
INSERT INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'ORDER_TRANSACTION_ATTRIBUTES_IMPORT'
         ,'ORDER TRANSACTION ATTRIBUTES IMPORT'
         ,NULL
         ,'Y'
         ,'Y'
         );

-- 
--
INSERT INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'ORDER_SALES_CREDITS_IMPORT'
         ,'ORDER SALES CREDITS IMPORT'
         ,NULL
         ,'Y'
         ,'Y'
         );

-- 
--
INSERT INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'ORDER_PAYMENTS_IMPORT'
         ,'ORDER PAYMENTS IMPORT'
         ,NULL
         ,'Y'
         ,'Y'
         );

-- 
--
INSERT INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'ORDER_LOT_SERIALS_IMPORT'
         ,'ORDER LOT SERIALS IMPORT'
         ,NULL
         ,'Y'
         ,'Y'
         );

-- 
--
INSERT INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'ORDER_DOCUMENT_REFERENCES_IMPORT'
         ,'ORDER DOCUMENT REFERENCES IMPORT'
         ,NULL
         ,'Y'
         ,'Y'
         );

-- 
--
INSERT INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'ORDER_CHARGES_IMPORT'
         ,'ORDER CHARGES IMPORT'
         ,NULL
         ,'Y'
         ,'Y'
         );

-- 
--
INSERT INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'ORDER_CHARGE_COMPONENTS_IMPORT'
         ,'ORDER CHARGE COMPONENTS IMPORT'
         ,NULL
         ,'Y'
         ,'Y'
         );

-- 
--
INSERT INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'ORDER_BILLING_PLANS_IMPORT'
         ,'ORDER BILLING PLANS IMPORT'
         ,NULL
         ,'Y'
         ,'Y'
         );

-- 
--
INSERT INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'ORDER_MANUAL_PRICE_ADJUSTMENT_IMPORT'
         ,'ORDER MANUAL PRICE ADJUSTMENT IMPORT'
         ,NULL
         ,'Y'
         ,'Y'
         );

-- 
--
INSERT INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'ORDER_HEADER_EXTENSIBLE_FLEXFIELDS_IMPORT'
         ,'ORDER HEADER EXTENSIBLE FLEXFIELDS IMPORT'
         ,NULL
         ,'Y'
         ,'Y'
         );

-- 
--
INSERT INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'ORDER_LINE_EXTENSIBLE_FLEXFIELDS_IMPORT'
         ,'ORDER LINE EXTENSIBLE FLEXFIELDS IMPORT'
         ,NULL
         ,'Y'
         ,'Y'
         );

-- 
--
INSERT INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'ORDER_LINE_PROJECTS_IMPORT'
         ,'ORDER LINE PROJECTS IMPORT'
         ,NULL
         ,'Y'
         ,'Y'
         );

-- 
--
INSERT INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'ORDER_TERMS_IMPORT'
         ,'ORDER TERMS IMPORT'
         ,NULL
         ,'Y'
         ,'Y'
         );

-- 
--
INSERT INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'ORDER_CHARGE_TIERS_IMPORT'
         ,'ORDER CHARGE TIERS IMPORT'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
--
INSERT INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'BUSINESS_ENTITIES'
         ,'PROC_WORK_DEF_IMP'
         ,'PROC WORK DEF IMP'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
--
--
/*********************************************************************************/
--
/*
** Sub-Entity Types
*/
--
INSERT
INTO   xxmx_core.xxmx_lookup_types
          (
           application
          ,lookup_type
          ,customisation_level
          )
VALUES
          (
           'XXMX'
          ,'SUB-ENTITIES'
          ,'S'
          );
--
--
INSERT INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'IMPORT_BATCHES'
         ,'IMPORT BATCHES'
         ,NULL
         ,'Y'
         ,'Y'
         );

-- 
--
INSERT INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'WORK_DEFINITION_HDR'
         ,'WORK DEFINITION HDR'
         ,NULL
         ,'Y'
         ,'Y'
         );

-- 
--
INSERT INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'WORK_DEFINITION_OPR'
         ,'WORK DEFINITION OPR'
         ,NULL
         ,'Y'
         ,'Y'
         );

-- 
--
INSERT INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'OPERATION_ITEMS'
         ,'OPERATION ITEMS'
         ,NULL
         ,'Y'
         ,'Y'
         );

-- 
--
INSERT INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'OPERATION_OUTPUTS'
         ,'OPERATION OUTPUTS'
         ,NULL
         ,'Y'
         ,'Y'
         );

-- 
--
INSERT INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'OPERATION_RESOURCES'
         ,'OPERATION RESOURCES'
         ,NULL
         ,'Y'
         ,'Y'
         );

-- 
--
INSERT INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'OPERATION_ALT_RES'
         ,'OPERATION ALT RES'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
--
INSERT INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'BUSINESS_ENTITIES'
         ,'WIE_MATERIAL_TRANS'
         ,'WIE MATERIAL TRANS'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
--
/*********************************************************************************/
--
/*
** Sub-Entity Types
*/
--
INSERT
INTO   xxmx_core.xxmx_lookup_types
          (
           application
          ,lookup_type
          ,customisation_level
          )
VALUES
          (
           'XXMX'
          ,'SUB-ENTITIES'
          ,'S'
          );
--
--
INSERT INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'INTERFACE_BATCH'
         ,'INTERFACE BATCH'
         ,NULL
         ,'Y'
         ,'Y'
         );

-- 
--
INSERT INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'MAT_TRANSAC_HDR'
         ,'MAT TRANSAC HDR'
         ,NULL
         ,'Y'
         ,'Y'
         );

-- 
--
INSERT INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'MAT_TRANSAC_LOTS'
         ,'MAT TRANSAC LOTS'
         ,NULL
         ,'Y'
         ,'Y'
         );

-- 
--
INSERT INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'MAT_TRANSAC_SERIALS'
         ,'MAT TRANSAC SERIALS'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
--
--
INSERT INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'BUSINESS_ENTITIES'
         ,'WIE_OP_TRANS_INT'
         ,'WIE OP TRANS INT'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
--
--
/*********************************************************************************/
--
/*
** Sub-Entity Types
*/
--
INSERT
INTO   xxmx_core.xxmx_lookup_types
          (
           application
          ,lookup_type
          ,customisation_level
          )
VALUES
          (
           'XXMX'
          ,'SUB-ENTITIES'
          ,'S'
          );
--
--
INSERT INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'BATCH_DETAILS'
         ,'BATCH DETAILS'
         ,NULL
         ,'Y'
         ,'Y'
         );

-- 
--
INSERT INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'OPERATION_TRANSACTION_HEADER'
         ,'OPERATION TRANSACTION HEADER'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
--
INSERT INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'BUSINESS_ENTITIES'
         ,'WIE_ORDER_IMP'
         ,'WIE ORDER IMP'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
/*********************************************************************************/
--
/*
** Sub-Entity Types
*/
--
INSERT
INTO   xxmx_core.xxmx_lookup_types
          (
           application
          ,lookup_type
          ,customisation_level
          )
VALUES
          (
           'XXMX'
          ,'SUB-ENTITIES'
          ,'S'
          );
--
--
INSERT INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'WO_BATCHES'
         ,'WO BATCHES'
         ,NULL
         ,'Y'
         ,'Y'
         );

-- 
--
INSERT INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'WO_HEADER'
         ,'WO HEADER'
         ,NULL
         ,'Y'
         ,'Y'
         );

-- 
--
INSERT INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'WO_OPERATIONS'
         ,'WO OPERATIONS'
         ,NULL
         ,'Y'
         ,'Y'
         );

-- 
--
INSERT INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'WO_OPN_RES'
         ,'WO OPN RES'
         ,NULL
         ,'Y'
         ,'Y'
         );

-- 
--
INSERT INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'WO_OPN_RES_INST'
         ,'WO OPN RES INST'
         ,NULL
         ,'Y'
         ,'Y'
         );

-- 
--
INSERT INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'WO_OPN_MAT'
         ,'WO OPN MAT'
         ,NULL
         ,'Y'
         ,'Y'
         );

-- 
--
INSERT INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'WO_OPR_OUTPUT'
         ,'WO OPR OUTPUT'
         ,NULL
         ,'Y'
         ,'Y'
         );

-- 
--
INSERT INTO xxmx_core.xxmx_lookup_values
         (
          application
         ,lookup_type
         ,lookup_code
         ,meaning
         ,description
         ,enabled_flag
         ,seeded
         )
VALUES
         (
          'XXMX'
         ,'SUB-ENTITIES'
         ,'WO_PROD_LOTS'
         ,'WO PROD LOTS'
         ,NULL
         ,'Y'
         ,'Y'
         );
--
--
/*********************************************************************************/
--
COMMIT;
/
--