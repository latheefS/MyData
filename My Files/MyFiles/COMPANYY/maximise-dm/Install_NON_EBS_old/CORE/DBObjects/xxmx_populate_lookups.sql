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
--**   1.0  13-DEC-2020  Ian S. Vickerstaff  Created for Maximise.
--**
--**   1.1  13-JAN-2021  Ian S. Vickerstaff  Added Lookup Types and Codes.
--**
--**   1.2  14-JUL-2021  Ian S. Vickerstaff  Header comment updates.
--**
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
         ,'AP_INVOICES'
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
         ,'PROJECTS'
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
         'PRJ_BILL_EVNT',
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
	   


/*********************************************************************************/
--
COMMIT;
/
--   
	   
	   
	   
	   
	   

/*********************************************************************************/
--
COMMIT;
/
--