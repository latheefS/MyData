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
--** FILENAME  :  xxmx_populate_fusion_job_defs.sql
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
--** PURPOSE   :  This script populates the XXMX_FUSION_JOB_DEFINITIONS and
--**              XXMX_FUSION_JOB_PARAMETERS tables.
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
--**   1.0  05-NOV-2020  Ian S. Vickerstaff  Created for Maximise.
--**
--**   1.1  22-OCT-2020  Ian S. Vickerstaff  Added Job Definitions.
--**
--**   1.2  06-DEC-2020  Ian S. Vickerstaff  Added Job Definitions.
--**
--**   1.3  20-JAN-2021  Ian S. Vickerstaff  Added Job Definitions.
--**
--**   1.4  21-JAN-2021  Ian S. Vickerstaff  Added Job Definitions.
--**
--**   1.5  26-JAN-2021  Ian S. Vickerstaff  Parameter Changes.
--**
--**   1.6  27_JAN-2021  Ian S. Vickerstaff  Parameter Changes.
--**
--**   1.7  18-FEB-2021  Ian S. Vickerstaff  Parameter Changes.
--**
--**   1.8  19-FEB-2021  Ian S. Vickerstaff  Parameter Changes.
--**
--**   1.9  26-FEB-2021  Ian S. Vickerstaff  Parameter Changes.
--**
--**  1.10  14-JUL-2021  Ian S. Vickerstaff  Header comment updates.
--**
--******************************************************************************
--
----
--** Delete Existing Data
--
DELETE
FROM    xxmx_fusion_job_definitions;
--
DELETE
FROM    xxmx_fusion_job_parameters;
--
VARIABLE vn_ParameterSeq      NUMBER;
--
PROMPT ********************************************
PROMPT ** POPULATING PROPERTIES FILE METADATA TABLE
PROMPT ********************************************
--
/*
*******************************************************************************
*/
--
/*
************
** Suppliers
************
*/
--
INSERT
INTO    xxmx_fusion_job_definitions
         (
          application_suite
         ,application
         ,business_entity
         ,file_group_number
         ,fusion_job_package_name
         ,fusion_job_definition_name
         )
VALUES
         (
          'FIN'                                       -- application_suite
         ,'AP'                                        -- application
         ,'SUPPLIERS'                                 -- business_entity
         ,1                                           -- file_group_number
         ,'/oracle/apps/ess/prc/poz/supplierImport/'  -- fusion_job_package_name
         ,'ImportSuppliers'                           -- fusion_job_definition_name
         );
--
EXECUTE :vn_ParameterSeq := 1;
--
INSERT
INTO    xxmx_fusion_job_parameters
         (
          fusion_job_definition_name
         ,parameter_seq
         ,parameter_name
         ,parameter_value
         ,fusion_mandatory
         ,user_updateable
         )
VALUES
         (
          'ImportSuppliers'         -- fusion_job_definition_name
         ,:vn_ParameterSeq          -- parameter_seq
         ,'Import Options'          -- parameter_name
         ,'NEW'                     -- parameter_value
         ,'Y'                       -- fusion_mandatory
         ,'Y'                       -- user_updateable
         );
--
EXECUTE :vn_ParameterSeq := :vn_ParameterSeq + 1;
--
INSERT
INTO    xxmx_fusion_job_parameters
         (
          fusion_job_definition_name
         ,parameter_seq
         ,parameter_name
         ,parameter_value
         ,fusion_mandatory
         ,user_updateable
         )
VALUES
         (
          'ImportSuppliers'         -- fusion_job_definition_name
         ,:vn_ParameterSeq          -- parameter_seq
         ,'Report Exceptions Only'  -- parameter_name
         ,'N'                      -- parameter_value
         ,'Y'                       -- fusion_mandatory
         ,'Y'                       -- user_updateable
         );
--
EXECUTE :vn_ParameterSeq := :vn_ParameterSeq + 1;
--
INSERT
INTO    xxmx_fusion_job_parameters
         (
          fusion_job_definition_name
         ,parameter_seq
         ,parameter_name
         ,parameter_value
         ,fusion_mandatory
         ,user_updateable
         )
VALUES
         (
          'ImportSuppliers'         -- fusion_job_definition_name
         ,:vn_ParameterSeq          -- parameter_seq
         ,'Import Options'          -- parameter_name
         ,'[MIGRATION_SET_ID]'      -- parameter_value
         ,'Y'                       -- fusion_mandatory
         ,'N'                       -- user_updateable
         );
--
/*
*********************
** Supplier Addresses
*********************
*/
--
INSERT
INTO    xxmx_fusion_job_definitions
         (
          application_suite
         ,application
         ,business_entity
         ,file_group_number
         ,fusion_job_package_name
         ,fusion_job_definition_name
         )
VALUES
         (
          'FIN'                                       -- application_suite
         ,'AP'                                        -- application
         ,'SUPPLIERS'                                 -- business_entity
         ,2                                           -- file_group_number
         ,'/oracle/apps/ess/prc/poz/supplierImport/'  -- fusion_job_package_name
         ,'ImportSupplierAddresses'                   -- fusion_job_definition_name
         );
--
EXECUTE :vn_ParameterSeq := 1;
--
INSERT
INTO    xxmx_fusion_job_parameters
         (
          fusion_job_definition_name
         ,parameter_seq
         ,parameter_name
         ,parameter_value
         ,fusion_mandatory
         ,user_updateable
         )
VALUES
         (
          'ImportSupplierAddresses'  -- fusion_job_definition_name
         ,:vn_ParameterSeq           -- parameter_seq
         ,'Import Options'           -- parameter_name
         ,'NEW'                      -- parameter_value
         ,'Y'                        -- fusion_mandatory
         ,'Y'                        -- user_updateable
         );
--
EXECUTE :vn_ParameterSeq := :vn_ParameterSeq + 1;
--
INSERT
INTO    xxmx_fusion_job_parameters
         (
          fusion_job_definition_name
         ,parameter_seq
         ,parameter_name
         ,parameter_value
         ,fusion_mandatory
         ,user_updateable
         )
VALUES
         (
          'ImportSupplierAddresses'  -- fusion_job_definition_name
         ,:vn_ParameterSeq           -- parameter_seq
         ,'Report Exceptions Only'   -- parameter_name
         ,'N'                        -- parameter_value
         ,'Y'                        -- fusion_mandatory
         ,'Y'                        -- user_updateable
         );
--
EXECUTE :vn_ParameterSeq := :vn_ParameterSeq + 1;
--
INSERT
INTO    xxmx_fusion_job_parameters
         (
          fusion_job_definition_name
         ,parameter_seq
         ,parameter_name
         ,parameter_value
         ,fusion_mandatory
         ,user_updateable
         )
VALUES
         (
          'ImportSupplierAddresses'  -- fusion_job_definition_name
         ,:vn_ParameterSeq           -- parameter_seq
         ,'Import Options'           -- parameter_name
         ,'[MIGRATION_SET_ID]'       -- parameter_value
         ,'Y'                        -- fusion_mandatory
         ,'N'                        -- user_updateable
         );
--
/*
*****************
** Supplier Sites
*****************
*/
--
INSERT
INTO    xxmx_fusion_job_definitions
         (
          application_suite
         ,application
         ,business_entity
         ,file_group_number
         ,fusion_job_package_name
         ,fusion_job_definition_name
         )
VALUES
         (
          'FIN'                                       -- application_suite
         ,'AP'                                        -- application
         ,'SUPPLIERS'                                 -- business_entity
         ,3                                           -- file_group_number
         ,'/oracle/apps/ess/prc/poz/supplierImport/'  -- fusion_job_package_name
         ,'ImportSupplierSites'                       -- fusion_job_definition_name
         );
--
EXECUTE :vn_ParameterSeq := 1;
--
INSERT
INTO    xxmx_fusion_job_parameters
         (
          fusion_job_definition_name
         ,parameter_seq
         ,parameter_name
         ,parameter_value
         ,fusion_mandatory
         ,user_updateable
         )
VALUES
         (
          'ImportSupplierSites'  -- fusion_job_definition_name
         ,:vn_ParameterSeq       -- parameter_seq
         ,'Import Options'       -- parameter_name
         ,'NEW'                  -- parameter_value
         ,'Y'                    -- fusion_mandatory
         ,'Y'                    -- user_updateable
         );
--
EXECUTE :vn_ParameterSeq := :vn_ParameterSeq + 1;
--
INSERT
INTO    xxmx_fusion_job_parameters
         (
          fusion_job_definition_name
         ,parameter_seq
         ,parameter_name
         ,parameter_value
         ,fusion_mandatory
         ,user_updateable
         )
VALUES
         (
          'ImportSupplierSites'     -- fusion_job_definition_name
         ,:vn_ParameterSeq          -- parameter_seq
         ,'Report Exceptions Only'  -- parameter_name
         ,'N'                      -- parameter_value
         ,'Y'                       -- fusion_mandatory
         ,'Y'                       -- user_updateable
         );
--
EXECUTE :vn_ParameterSeq := :vn_ParameterSeq + 1;
--
INSERT
INTO    xxmx_fusion_job_parameters
         (
          fusion_job_definition_name
         ,parameter_seq
         ,parameter_name
         ,parameter_value
         ,fusion_mandatory
         ,user_updateable
         )
VALUES
         (
          'ImportSupplierSites'  -- fusion_job_definition_name
         ,:vn_ParameterSeq       -- parameter_seq
         ,'Import Options'       -- parameter_name
         ,'[MIGRATION_SET_ID]'   -- parameter_value
         ,'Y'                    -- fusion_mandatory
         ,'N'                    -- user_updateable
         );
--
/*
****************************
** Supplier Site Assignments
****************************
*/
--
INSERT
INTO    xxmx_fusion_job_definitions
         (
          application_suite
         ,application
         ,business_entity
         ,file_group_number
         ,fusion_job_package_name
         ,fusion_job_definition_name
         )
VALUES
         (
          'FIN'                                       -- application_suite
         ,'AP'                                        -- application
         ,'SUPPLIERS'                                 -- business_entity
         ,5                                           -- file_group_number
         ,'/oracle/apps/ess/prc/poz/supplierImport/'  -- fusion_job_package_name
         ,'ImportSupplierSiteAssignments'             -- fusion_job_definition_name
         );
--
EXECUTE :vn_ParameterSeq := 1;
--
INSERT
INTO    xxmx_fusion_job_parameters
         (
          fusion_job_definition_name
         ,parameter_seq
         ,parameter_name
         ,parameter_value
         ,fusion_mandatory
         ,user_updateable
         )
VALUES
         (
          'ImportSupplierSiteAssignments'  -- fusion_job_definition_name
         ,:vn_ParameterSeq                 -- parameter_seq
         ,'Import Options'                 -- parameter_name
         ,'NEW'                            -- parameter_value
         ,'Y'                              -- fusion_mandatory
         ,'Y'                              -- user_updateable
         );
--
EXECUTE :vn_ParameterSeq := :vn_ParameterSeq + 1;
--
INSERT
INTO    xxmx_fusion_job_parameters
         (
          fusion_job_definition_name
         ,parameter_seq
         ,parameter_name
         ,parameter_value
         ,fusion_mandatory
         ,user_updateable
         )
VALUES
         (
          'ImportSupplierSiteAssignments'     -- fusion_job_definition_name
         ,:vn_ParameterSeq                    -- parameter_seq
         ,'Report Exceptions Only'            -- parameter_name
         ,'N'                                 -- parameter_value
         ,'Y'                                 -- fusion_mandatory
         ,'Y'                                 -- user_updateable
         );
--
EXECUTE :vn_ParameterSeq := :vn_ParameterSeq + 1;
--
INSERT
INTO    xxmx_fusion_job_parameters
         (
          fusion_job_definition_name
         ,parameter_seq
         ,parameter_name
         ,parameter_value
         ,fusion_mandatory
         ,user_updateable
         )
VALUES
         (
          'ImportSupplierSiteAssignments'  -- fusion_job_definition_name
         ,:vn_ParameterSeq                 -- parameter_seq
         ,'Import Options'                 -- parameter_name
         ,'[MIGRATION_SET_ID]'             -- parameter_value
         ,'Y'                              -- fusion_mandatory
         ,'N'                              -- user_updateable
         );
--
/*
********************
** Supplier Contacts
********************
*/
--
INSERT
INTO    xxmx_fusion_job_definitions
         (
          application_suite
         ,application
         ,business_entity
         ,file_group_number
         ,fusion_job_package_name
         ,fusion_job_definition_name
         )
VALUES
         (
          'FIN'                                       -- application_suite
         ,'AP'                                        -- application
         ,'SUPPLIERS'                                 -- business_entity
         ,4                                           -- file_group_number
         ,'/oracle/apps/ess/prc/poz/supplierImport/'  -- fusion_job_package_name
         ,'ImportSupplierContacts'                    -- fusion_job_definition_name
         );
--
EXECUTE :vn_ParameterSeq := 1;
--
INSERT
INTO    xxmx_fusion_job_parameters
         (
          fusion_job_definition_name
         ,parameter_seq
         ,parameter_name
         ,parameter_value
         ,fusion_mandatory
         ,user_updateable
         )
VALUES
         (
          'ImportSupplierContacts'  -- fusion_job_definition_name
         ,:vn_ParameterSeq          -- parameter_seq
         ,'Import Options'          -- parameter_name
         ,'NEW'                     -- parameter_value
         ,'Y'                       -- fusion_mandatory
         ,'Y'                       -- user_updateable
         );
--
EXECUTE :vn_ParameterSeq := :vn_ParameterSeq + 1;
--
INSERT
INTO    xxmx_fusion_job_parameters
         (
          fusion_job_definition_name
         ,parameter_seq
         ,parameter_name
         ,parameter_value
         ,fusion_mandatory
         ,user_updateable
         )
VALUES
         (
          'ImportSupplierContacts'     -- fusion_job_definition_name
         ,:vn_ParameterSeq             -- parameter_seq
         ,'Report Exceptions Only'     -- parameter_name
         ,'N'                          -- parameter_value
         ,'Y'                          -- fusion_mandatory
         ,'Y'                          -- user_updateable
         );
--
EXECUTE :vn_ParameterSeq := :vn_ParameterSeq + 1;
--
INSERT
INTO    xxmx_fusion_job_parameters
         (
          fusion_job_definition_name
         ,parameter_seq
         ,parameter_name
         ,parameter_value
         ,fusion_mandatory
         ,user_updateable
         )
VALUES
         (
          'ImportSupplierContacts'  -- fusion_job_definition_name
         ,:vn_ParameterSeq          -- parameter_seq
         ,'Import Options'          -- parameter_name
         ,'[MIGRATION_SET_ID]'      -- parameter_value
         ,'Y'                       -- fusion_mandatory
         ,'N'                       -- user_updateable
         );
--
/*
*************************
** Supplier Bank Accounts
*************************
*/
--
INSERT
INTO    xxmx_fusion_job_definitions
         (
          application_suite
         ,application
         ,business_entity
         ,file_group_number
         ,fusion_job_package_name
         ,fusion_job_definition_name
         )
VALUES
         (
          'FIN'                                                               -- application_suite
         ,'AP'                                                                -- application
         ,'SUPPLIERS'                                                         -- business_entity
         ,6                                                                   -- file_group_number
         ,'/oracle/apps/ess/financials/payments/fundsDisbursement/payments/'  -- fusion_job_package_name
         ,'ImportSuppBankAccounts'                                            -- fusion_job_definition_name
         );
--
EXECUTE :vn_ParameterSeq := 1;
--
INSERT
INTO    xxmx_fusion_job_parameters
         (
          fusion_job_definition_name
         ,parameter_seq
         ,parameter_name
         ,parameter_value
         ,fusion_mandatory
         ,user_updateable
         )
VALUES
         (
          'ImportSuppBankAccounts'   -- fusion_job_definition_name
         ,:vn_ParameterSeq           -- parameter_seq
         ,'Feeder Batch Identifier'  -- parameter_name
         ,'[MIGRATION_SET_ID]'       -- parameter_value
         ,'Y'                        -- fusion_mandatory
         ,'N'                        -- user_updateable
         );
--
/*
*********************************************************************************
*/
--
/*
**************
** AP Invoices
**************
*/
--
INSERT
INTO    xxmx_fusion_job_definitions
         (
          application_suite
         ,application
         ,business_entity
         ,file_group_number
         ,fusion_job_package_name
         ,fusion_job_definition_name
         )
VALUES
         (
          'FIN'                                                          -- application_suite
         ,'AP'                                                           -- application
         ,'INVOICES'                                                     -- business_entity
         ,1                                                           -- file_group_number
         ,'/oracle/apps/ess/financials/payables/invoices/transactions/'  -- fusion_job_package_name
         ,'APXIIMPT'                                                     -- fusion_job_definition_name
         );
--
EXECUTE :vn_ParameterSeq := 1;
--
INSERT
INTO    xxmx_fusion_job_parameters
         (
          fusion_job_definition_name
         ,parameter_seq
         ,parameter_name
         ,parameter_value
         ,fusion_mandatory
         ,user_updateable
         )
VALUES
         (
          'APXIIMPT'              -- fusion_job_definition_name
         ,:vn_ParameterSeq        -- parameter_seq
         ,'Business Unit'         -- parameter_name
         ,'[BUSINESS_UNIT_NAME]'  -- parameter_value
         ,'Y'                     -- fusion_mandatory
         ,'N'                     -- user_updateable
         );
--
EXECUTE :vn_ParameterSeq := :vn_ParameterSeq + 1;
--
INSERT
INTO    xxmx_fusion_job_parameters
         (
          fusion_job_definition_name
         ,parameter_seq
         ,parameter_name
         ,parameter_value
         ,fusion_mandatory
         ,user_updateable
         )
VALUES
         (
          'APXIIMPT'        -- fusion_job_definition_name
         ,:vn_ParameterSeq  -- parameter_seq
         ,'Ledger Name'     -- parameter_name
         ,'[LEDGER_NAME]'   -- parameter_value
         ,'Y'               -- fusion_mandatory
         ,'N'               -- user_updateable
         );
--
EXECUTE :vn_ParameterSeq := :vn_ParameterSeq + 1;
--
INSERT
INTO    xxmx_fusion_job_parameters
         (
          fusion_job_definition_name
         ,parameter_seq
         ,parameter_name
         ,parameter_value
         ,fusion_mandatory
         ,user_updateable
         )
VALUES
         (
          'APXIIMPT'        -- fusion_job_definition_name
         ,:vn_ParameterSeq  -- parameter_seq
         ,'Source'          -- parameter_name
         ,'Data Migration'  -- parameter_value
         ,'Y'               -- fusion_mandatory
         ,'N'               -- user_updateable
         );
--
EXECUTE :vn_ParameterSeq := :vn_ParameterSeq + 1;
--
INSERT
INTO    xxmx_fusion_job_parameters
         (
          fusion_job_definition_name
         ,parameter_seq
         ,parameter_name
         ,parameter_value
         ,fusion_mandatory
         ,user_updateable
         )
VALUES
         (
          'APXIIMPT'            -- fusion_job_definition_name
         ,:vn_ParameterSeq      -- parameter_seq
         ,'Import Set'          -- parameter_name
         ,'[MIGRATION_SET_ID]'  -- parameter_value
         ,'N'                   -- fusion_mandatory
         ,'N'                   -- user_updateable
         );
--
EXECUTE :vn_ParameterSeq := :vn_ParameterSeq + 1;
--
INSERT
INTO    xxmx_fusion_job_parameters
         (
          fusion_job_definition_name
         ,parameter_seq
         ,parameter_name
         ,parameter_value
         ,fusion_mandatory
         ,user_updateable
         )
VALUES
         (
          'APXIIMPT'        -- fusion_job_definition_name
         ,:vn_ParameterSeq  -- parameter_seq
         ,'Invoice Group'   -- parameter_name
         ,'#NULL'           -- parameter_value
         ,'N'               -- fusion_mandatory
         ,'Y'               -- user_updateable
         );
--
EXECUTE :vn_ParameterSeq := :vn_ParameterSeq + 1;
--
INSERT
INTO    xxmx_fusion_job_parameters
         (
          fusion_job_definition_name
         ,parameter_seq
         ,parameter_name
         ,parameter_value
         ,fusion_mandatory
         ,user_updateable
         )
VALUES
         (
          'APXIIMPT'                   -- fusion_job_definition_name
         ,:vn_ParameterSeq             -- parameter_seq
         ,'Hold (Hold Type to apply)'  -- parameter_name
         ,'#NULL'                      -- parameter_value
         ,'N'                          -- fusion_mandatory
         ,'Y'                          -- user_updateable
         );
--
EXECUTE :vn_ParameterSeq := :vn_ParameterSeq + 1;
--
INSERT
INTO    xxmx_fusion_job_parameters
         (
          fusion_job_definition_name
         ,parameter_seq
         ,parameter_name
         ,parameter_value
         ,fusion_mandatory
         ,user_updateable
         )
VALUES
         (
          'APXIIMPT'  -- fusion_job_definition_name
         ,:vn_ParameterSeq        -- parameter_seq
         ,'Hold Reason'           -- parameter_name
         ,'#NULL'                 -- parameter_value
         ,'N'                     -- fusion_mandatory
         ,'Y'                     -- user_updateable
         );
--
EXECUTE :vn_ParameterSeq := :vn_ParameterSeq + 1;
--
INSERT
INTO    xxmx_fusion_job_parameters
         (
          fusion_job_definition_name
         ,parameter_seq
         ,parameter_name
         ,parameter_value
         ,fusion_mandatory
         ,user_updateable
         )
VALUES
         (
          'APXIIMPT'          -- fusion_job_definition_name
         ,:vn_ParameterSeq    -- parameter_seq
         ,'Accounting Date'   -- parameter_name
         ,'#NULL'             -- parameter_value
         ,'N'                 -- fusion_mandatory
         ,'Y'                 -- user_updateable
         );
--
EXECUTE :vn_ParameterSeq := :vn_ParameterSeq + 1;
--
INSERT
INTO    xxmx_fusion_job_parameters
         (
          fusion_job_definition_name
         ,parameter_seq
         ,parameter_name
         ,parameter_value
         ,fusion_mandatory
         ,user_updateable
         )
VALUES
         (
          'APXIIMPT'        -- fusion_job_definition_name
         ,:vn_ParameterSeq  -- parameter_seq
         ,'Purge'           -- parameter_name
         ,'No'              -- parameter_value
         ,'N'               -- fusion_mandatory
         ,'Y'               -- user_updateable
         );
--
EXECUTE :vn_ParameterSeq := :vn_ParameterSeq + 1;
--
INSERT
INTO    xxmx_fusion_job_parameters
         (
          fusion_job_definition_name
         ,parameter_seq
         ,parameter_name
         ,parameter_value
         ,fusion_mandatory
         ,user_updateable
         )
VALUES
         (
          'APXIIMPT'          -- fusion_job_definition_name
         ,:vn_ParameterSeq    -- parameter_seq
         ,'Summarize Report'  -- parameter_name
         ,'No'                -- parameter_value
         ,'N'                 -- fusion_mandatory
         ,'Y'                 -- user_updateable
         );
--
EXECUTE :vn_ParameterSeq := :vn_ParameterSeq + 1;
--
INSERT
INTO    xxmx_fusion_job_parameters
         (
          fusion_job_definition_name
         ,parameter_seq
         ,parameter_name
         ,parameter_value
         ,fusion_mandatory
         ,user_updateable
         )
VALUES
         (
          'APXIIMPT'                      -- fusion_job_definition_name
         ,:vn_ParameterSeq                -- parameter_seq
         ,'Number of Parallel Processes'  -- parameter_name
         ,'1'                             -- parameter_value
         ,'N'                             -- fusion_mandatory
         ,'Y'                             -- user_updateable
         );
--
/*
**********************************************************************************
*/
--
/*
***************
** AR Customers
***************
*/
--
INSERT
INTO    xxmx_fusion_job_definitions
         (
          application_suite
         ,application
         ,business_entity
         ,file_group_number
         ,fusion_job_package_name
         ,fusion_job_definition_name
         )
VALUES
         (
          'FIN'                                                                 -- application_suite
         ,'AR'                                                                  -- application
         ,'CUSTOMERS'                                                           -- business_entity
         ,1                                                                     -- file_group_number
         ,'/oracle/apps/ess/cdm/foundation/bulkImport/'                         -- fusion_job_package_name
         ,'CDMAutoBulkImportJob'                                                       -- fusion_job_definition_name
         );
--
EXECUTE :vn_ParameterSeq := 1;
--
INSERT
INTO    xxmx_fusion_job_parameters
         (
          fusion_job_definition_name
         ,parameter_seq
         ,parameter_name
         ,parameter_value
         ,fusion_mandatory
         ,user_updateable
         )
VALUES
         (
          'CDMAutoBulkImportJob'         -- fusion_job_definition_name
         ,:vn_ParameterSeq        -- parameter_seq
         ,'Batch ID'              -- parameter_name
         ,'[MIGRATION_SET_ID]'    -- parameter_value
         ,'Y'                     -- fusion_mandatory
         ,'N'                     -- user_updateable
         );
--
EXECUTE :vn_ParameterSeq := :vn_ParameterSeq + 1;
--
INSERT
INTO    xxmx_fusion_job_parameters
         (
          fusion_job_definition_name
         ,parameter_seq
         ,parameter_name
         ,parameter_value
         ,fusion_mandatory
         ,user_updateable
         )
VALUES
         (
          'CDMAutoBulkImportJob'         -- fusion_job_definition_name
         ,:vn_ParameterSeq        -- parameter_seq
         ,'Batch Name'            -- parameter_name
         ,'[MIGRATION_SET_ID]'    -- parameter_value
         ,'Y'                     -- fusion_mandatory
         ,'Y'                     -- user_updateable
         );
--
EXECUTE :vn_ParameterSeq := :vn_ParameterSeq + 1;
--
INSERT
INTO    xxmx_fusion_job_parameters
         (
          fusion_job_definition_name
         ,parameter_seq
         ,parameter_name
         ,parameter_value
         ,fusion_mandatory
         ,user_updateable
         )
VALUES
         (
          'CDMAutoBulkImportJob'         -- fusion_job_definition_name
         ,:vn_ParameterSeq        -- parameter_seq
         ,'Load Type'             -- parameter_name
         ,'CUSTOMER'              -- parameter_value
         ,'Y'                     -- fusion_mandatory
         ,'N'                     -- user_updateable
         );
--
EXECUTE :vn_ParameterSeq := :vn_ParameterSeq + 1;
--
INSERT
INTO    xxmx_fusion_job_parameters
         (
          fusion_job_definition_name
         ,parameter_seq
         ,parameter_name
         ,parameter_value
         ,fusion_mandatory
         ,user_updateable
         )
VALUES
         (
          'CDMAutoBulkImportJob'         -- fusion_job_definition_name
         ,:vn_ParameterSeq        -- parameter_seq
         ,'Source'                -- parameter_name
         ,'CSV'                   -- parameter_value
         ,'Y'                     -- fusion_mandatory
         ,'N'                     -- user_updateable
         );
--
/*********************************************************************************/
--
/*
**************
** AR Invoices
**************
*/
--
INSERT
INTO    xxmx_fusion_job_definitions
         (
          application_suite
         ,application
         ,business_entity
         ,file_group_number
         ,fusion_job_package_name
         ,fusion_job_definition_name
         )
VALUES
         (
          'FIN'                                                                 -- application_suite
         ,'AR'                                                                  -- application
         ,'TRANSACTIONS'                                                        -- business_entity
         ,1                                                                     -- file_group_number
         ,'/oracle/apps/ess/financials/receivables/transactions/autoInvoices/'  -- fusion_job_package_name
         ,'AutoInvoiceMasterEss'                                                -- fusion_job_definition_name
         );
--
EXECUTE :vn_ParameterSeq := 1;
--
INSERT
INTO    xxmx_fusion_job_parameters
         (
          fusion_job_definition_name
         ,parameter_seq
         ,parameter_name
         ,parameter_value
         ,fusion_mandatory
         ,user_updateable
         )
VALUES
         (
          'AutoInvoiceMasterEss'  -- fusion_job_definition_name
         ,:vn_ParameterSeq        -- parameter_seq
         ,'Number Of Workers'     -- parameter_name
         ,'1'                     -- parameter_value
         ,'Y'                     -- fusion_mandatory
         ,'N'                     -- user_updateable
         );
--
EXECUTE :vn_ParameterSeq := :vn_ParameterSeq + 1;
--
INSERT
INTO    xxmx_fusion_job_parameters
         (
          fusion_job_definition_name
         ,parameter_seq
         ,parameter_name
         ,parameter_value
         ,fusion_mandatory
         ,user_updateable
         )
VALUES
         (
          'AutoInvoiceMasterEss'  -- fusion_job_definition_name
         ,:vn_ParameterSeq        -- parameter_seq
         ,'Business Unit'         -- parameter_name
         ,'[BUSINESS_UNIT_NAME]'  -- parameter_value
         ,'Y'                     -- fusion_mandatory
         ,'N'                     -- user_updateable
         );
--
EXECUTE :vn_ParameterSeq := :vn_ParameterSeq + 1;
--
INSERT
INTO    xxmx_fusion_job_parameters
         (
          fusion_job_definition_name
         ,parameter_seq
         ,parameter_name
         ,parameter_value
         ,fusion_mandatory
         ,user_updateable
         )
VALUES
         (
          'AutoInvoiceMasterEss'  -- fusion_job_definition_name
         ,:vn_ParameterSeq        -- parameter_seq
         ,'Source'                -- parameter_name
         ,'[AR_TXN_SOURCE_ID]'    -- parameter_value
         ,'Y'                     -- fusion_mandatory
         ,'N'                     -- user_updateable
         );
--
EXECUTE :vn_ParameterSeq := :vn_ParameterSeq + 1;
--
INSERT
INTO    xxmx_fusion_job_parameters
         (
          fusion_job_definition_name
         ,parameter_seq
         ,parameter_name
         ,parameter_value
         ,fusion_mandatory
         ,user_updateable
         )
VALUES
         (
          'AutoInvoiceMasterEss'   -- fusion_job_definition_name
         ,:vn_ParameterSeq         -- parameter_seq
         ,'Default Date'           -- parameter_name
         ,'[SYSDATEAS:RRRR-MM-DD]' -- parameter_value
         ,'Y'                      -- fusion_mandatory
         ,'Y'                      -- user_updateable
         );
--
EXECUTE :vn_ParameterSeq := :vn_ParameterSeq + 1;
--
INSERT
INTO    xxmx_fusion_job_parameters
         (
          fusion_job_definition_name
         ,parameter_seq
         ,parameter_name
         ,parameter_value
         ,fusion_mandatory
         ,user_updateable
         )
VALUES
         (
          'AutoInvoiceMasterEss'  -- fusion_job_definition_name
         ,:vn_ParameterSeq        -- parameter_seq
         ,'Transaction Type'      -- parameter_name
         ,'#NULL'                 -- parameter_value
         ,'N'                     -- fusion_mandatory
         ,'Y'                     -- user_updateable
         );
--
EXECUTE :vn_ParameterSeq := :vn_ParameterSeq + 1;
--
INSERT
INTO    xxmx_fusion_job_parameters
         (
          fusion_job_definition_name
         ,parameter_seq
         ,parameter_name
         ,parameter_value
         ,fusion_mandatory
         ,user_updateable
         )
VALUES
         (
          'AutoInvoiceMasterEss'  -- fusion_job_definition_name
         ,:vn_ParameterSeq        -- parameter_seq
         ,'From Customer'         -- parameter_name
         ,'#NULL'                 -- parameter_value
         ,'N'                     -- fusion_mandatory
         ,'Y'                     -- user_updateable
         );
--
EXECUTE :vn_ParameterSeq := :vn_ParameterSeq + 1;
--
INSERT
INTO    xxmx_fusion_job_parameters
         (
          fusion_job_definition_name
         ,parameter_seq
         ,parameter_name
         ,parameter_value
         ,fusion_mandatory
         ,user_updateable
         )
VALUES
         (
          'AutoInvoiceMasterEss'  -- fusion_job_definition_name
         ,:vn_ParameterSeq        -- parameter_seq
         ,'To Customer'           -- parameter_name
         ,'#NULL'                 -- parameter_value
         ,'N'                     -- fusion_mandatory
         ,'Y'                     -- user_updateable
         );
--
EXECUTE :vn_ParameterSeq := :vn_ParameterSeq + 1;
--
INSERT
INTO    xxmx_fusion_job_parameters
         (
          fusion_job_definition_name
         ,parameter_seq
         ,parameter_name
         ,parameter_value
         ,fusion_mandatory
         ,user_updateable
         )
VALUES
         (
          'AutoInvoiceMasterEss'          -- fusion_job_definition_name
         ,:vn_ParameterSeq                -- parameter_seq
         ,'From Customer Account Number'  -- parameter_name
         ,'#NULL'                         -- parameter_value
         ,'N'                             -- fusion_mandatory
         ,'Y'                             -- user_updateable
         );
--
EXECUTE :vn_ParameterSeq := :vn_ParameterSeq + 1;
--
INSERT
INTO    xxmx_fusion_job_parameters
         (
          fusion_job_definition_name
         ,parameter_seq
         ,parameter_name
         ,parameter_value
         ,fusion_mandatory
         ,user_updateable
         )
VALUES
         (
          'AutoInvoiceMasterEss'        -- fusion_job_definition_name
         ,:vn_ParameterSeq              -- parameter_seq
         ,'To Customer Account Number'  -- parameter_name
         ,'#NULL'                       -- parameter_value
         ,'N'                           -- fusion_mandatory
         ,'Y'                           -- user_updateable
         );
--
EXECUTE :vn_ParameterSeq := :vn_ParameterSeq + 1;
--
INSERT
INTO    xxmx_fusion_job_parameters
         (
          fusion_job_definition_name
         ,parameter_seq
         ,parameter_name
         ,parameter_value
         ,fusion_mandatory
         ,user_updateable
         )
VALUES
         (
          'AutoInvoiceMasterEss'  -- fusion_job_definition_name
         ,:vn_ParameterSeq        -- parameter_seq
         ,'From Accounting Date'  -- parameter_name
         ,'#NULL'                 -- parameter_value
         ,'N'                     -- fusion_mandatory
         ,'Y'                     -- user_updateable
         );
--
EXECUTE :vn_ParameterSeq := :vn_ParameterSeq + 1;
--
INSERT
INTO    xxmx_fusion_job_parameters
         (
          fusion_job_definition_name
         ,parameter_seq
         ,parameter_name
         ,parameter_value
         ,fusion_mandatory
         ,user_updateable
         )
VALUES
         (
          'AutoInvoiceMasterEss'  -- fusion_job_definition_name
         ,:vn_ParameterSeq        -- parameter_seq
         ,'To Accounting Date'    -- parameter_name
         ,'#NULL'                 -- parameter_value
         ,'N'                     -- fusion_mandatory
         ,'Y'                     -- user_updateable
         );
--
EXECUTE :vn_ParameterSeq := :vn_ParameterSeq + 1;
--
INSERT
INTO    xxmx_fusion_job_parameters
         (
          fusion_job_definition_name
         ,parameter_seq
         ,parameter_name
         ,parameter_value
         ,fusion_mandatory
         ,user_updateable
         )
VALUES
         (
          'AutoInvoiceMasterEss'  -- fusion_job_definition_name
         ,:vn_ParameterSeq        -- parameter_seq
         ,'From Ship Date'        -- parameter_name
         ,'#NULL'                 -- parameter_value
         ,'N'                     -- fusion_mandatory
         ,'Y'                     -- user_updateable
         );
--
EXECUTE :vn_ParameterSeq := :vn_ParameterSeq + 1;
--
INSERT
INTO    xxmx_fusion_job_parameters
         (
          fusion_job_definition_name
         ,parameter_seq
         ,parameter_name
         ,parameter_value
         ,fusion_mandatory
         ,user_updateable
         )
VALUES
         (
          'AutoInvoiceMasterEss'  -- fusion_job_definition_name
         ,:vn_ParameterSeq        -- parameter_seq
         ,'To Ship Date'          -- parameter_name
         ,'#NULL'                 -- parameter_value
         ,'N'                     -- fusion_mandatory
         ,'Y'                     -- user_updateable
         );
--
EXECUTE :vn_ParameterSeq := :vn_ParameterSeq + 1;
--
INSERT
INTO    xxmx_fusion_job_parameters
         (
          fusion_job_definition_name
         ,parameter_seq
         ,parameter_name
         ,parameter_value
         ,fusion_mandatory
         ,user_updateable
         )
VALUES
         (
          'AutoInvoiceMasterEss'     -- fusion_job_definition_name
         ,:vn_ParameterSeq           -- parameter_seq
         ,'From Transaction Number'  -- parameter_name
         ,'#NULL'                    -- parameter_value
         ,'N'                        -- fusion_mandatory
         ,'Y'                        -- user_updateable
         );
--
EXECUTE :vn_ParameterSeq := :vn_ParameterSeq + 1;
--
INSERT
INTO    xxmx_fusion_job_parameters
         (
          fusion_job_definition_name
         ,parameter_seq
         ,parameter_name
         ,parameter_value
         ,fusion_mandatory
         ,user_updateable
         )
VALUES
         (
          'AutoInvoiceMasterEss'   -- fusion_job_definition_name
         ,:vn_ParameterSeq         -- parameter_seq
         ,'To Transaction Number'  -- parameter_name
         ,'#NULL'                  -- parameter_value
         ,'N'                      -- fusion_mandatory
         ,'Y'                      -- user_updateable
         );
--
EXECUTE :vn_ParameterSeq := :vn_ParameterSeq + 1;
--
INSERT
INTO    xxmx_fusion_job_parameters
         (
          fusion_job_definition_name
         ,parameter_seq
         ,parameter_name
         ,parameter_value
         ,fusion_mandatory
         ,user_updateable
         )
VALUES
         (
          'AutoInvoiceMasterEss'     -- fusion_job_definition_name
         ,:vn_ParameterSeq           -- parameter_seq
         ,'From Sales Order Number'  -- parameter_name
         ,'#NULL'                    -- parameter_value
         ,'N'                        -- fusion_mandatory
         ,'Y'                        -- user_updateable
         );
--
EXECUTE :vn_ParameterSeq := :vn_ParameterSeq + 1;
--
INSERT
INTO    xxmx_fusion_job_parameters
         (
          fusion_job_definition_name
         ,parameter_seq
         ,parameter_name
         ,parameter_value
         ,fusion_mandatory
         ,user_updateable
         )
VALUES
         (
          'AutoInvoiceMasterEss'   -- fusion_job_definition_name
         ,:vn_ParameterSeq         -- parameter_seq
         ,'To Sales Order Number'  -- parameter_name
         ,'#NULL'                  -- parameter_value
         ,'N'                      -- fusion_mandatory
         ,'Y'                      -- user_updateable
         );
--
EXECUTE :vn_ParameterSeq := :vn_ParameterSeq + 1;
--
INSERT
INTO    xxmx_fusion_job_parameters
         (
          fusion_job_definition_name
         ,parameter_seq
         ,parameter_name
         ,parameter_value
         ,fusion_mandatory
         ,user_updateable
         )
VALUES
         (
          'AutoInvoiceMasterEss'   -- fusion_job_definition_name
         ,:vn_ParameterSeq         -- parameter_seq
         ,'From Transaction Date'  -- parameter_name
         ,'#NULL'                  -- parameter_value
         ,'N'                      -- fusion_mandatory
         ,'Y'                      -- user_updateable
         );
--
EXECUTE :vn_ParameterSeq := :vn_ParameterSeq + 1;
--
INSERT
INTO    xxmx_fusion_job_parameters
         (
          fusion_job_definition_name
         ,parameter_seq
         ,parameter_name
         ,parameter_value
         ,fusion_mandatory
         ,user_updateable
         )
VALUES
         (
          'AutoInvoiceMasterEss' -- fusion_job_definition_name
         ,:vn_ParameterSeq       -- parameter_seq
         ,'To Transaction Date'  -- parameter_name
         ,'#NULL'                -- parameter_value
         ,'N'                    -- fusion_mandatory
         ,'Y'                    -- user_updateable
         );
--
EXECUTE :vn_ParameterSeq := :vn_ParameterSeq + 1;
--
INSERT
INTO    xxmx_fusion_job_parameters
         (
          fusion_job_definition_name
         ,parameter_seq
         ,parameter_name
         ,parameter_value
         ,fusion_mandatory
         ,user_updateable
         )
VALUES
         (
          'AutoInvoiceMasterEss'                  -- fusion_job_definition_name
         ,:vn_ParameterSeq                        -- parameter_seq
         ,'From Ship-To Customer Account Number'  -- parameter_name
         ,'#NULL'                                 -- parameter_value
         ,'N'                                     -- fusion_mandatory
         ,'Y'                                     -- user_updateable
         );
--
EXECUTE :vn_ParameterSeq := :vn_ParameterSeq + 1;
--
INSERT
INTO    xxmx_fusion_job_parameters
         (
          fusion_job_definition_name
         ,parameter_seq
         ,parameter_name
         ,parameter_value
         ,fusion_mandatory
         ,user_updateable
         )
VALUES
         (
          'AutoInvoiceMasterEss'                -- fusion_job_definition_name
         ,:vn_ParameterSeq                      -- parameter_seq
         ,'To Ship-To Customer Account Number'  -- parameter_name
         ,'#NULL'                               -- parameter_value
         ,'N'                                   -- fusion_mandatory
         ,'Y'                                   -- user_updateable
         );
--
EXECUTE :vn_ParameterSeq := :vn_ParameterSeq + 1;
--
INSERT
INTO    xxmx_fusion_job_parameters
         (
          fusion_job_definition_name
         ,parameter_seq
         ,parameter_name
         ,parameter_value
         ,fusion_mandatory
         ,user_updateable
         )
VALUES
         (
          'AutoInvoiceMasterEss'        -- fusion_job_definition_name
         ,:vn_ParameterSeq              -- parameter_seq
         ,'From Ship-To Customer Name'  -- parameter_name
         ,'#NULL'                       -- parameter_value
         ,'N'                           -- fusion_mandatory
         ,'Y'                           -- user_updateable
         );
--
EXECUTE :vn_ParameterSeq := :vn_ParameterSeq + 1;
--
INSERT
INTO    xxmx_fusion_job_parameters
         (
          fusion_job_definition_name
         ,parameter_seq
         ,parameter_name
         ,parameter_value
         ,fusion_mandatory
         ,user_updateable
         )
VALUES
         (
          'AutoInvoiceMasterEss'      -- fusion_job_definition_name
         ,:vn_ParameterSeq            -- parameter_seq
         ,'To Ship-To Customer Name'  -- parameter_name
         ,'#NULL'                     -- parameter_value
         ,'N'                         -- fusion_mandatory
         ,'Y'                         -- user_updateable
         );
--
EXECUTE :vn_ParameterSeq := :vn_ParameterSeq + 1;
--
INSERT
INTO    xxmx_fusion_job_parameters
         (
          fusion_job_definition_name
         ,parameter_seq
         ,parameter_name
         ,parameter_value
         ,fusion_mandatory
         ,user_updateable
         )
VALUES
         (
          'AutoInvoiceMasterEss'               -- fusion_job_definition_name
         ,:vn_ParameterSeq                     -- parameter_seq
         ,'Base Due Date on Transaction Date'  -- parameter_name
         ,'N'                                  -- parameter_value
         ,'Y'                                  -- fusion_mandatory
         ,'Y'                                  -- user_updateable
         );
--
EXECUTE :vn_ParameterSeq := :vn_ParameterSeq + 1;
--
INSERT
INTO    xxmx_fusion_job_parameters
         (
          fusion_job_definition_name
         ,parameter_seq
         ,parameter_name
         ,parameter_value
         ,fusion_mandatory
         ,user_updateable
         )
VALUES
         (
          'AutoInvoiceMasterEss'      -- fusion_job_definition_name
         ,:vn_ParameterSeq            -- parameter_seq
         ,'Due Date Adjustment Days'  -- parameter_name
         ,'#NULL'                     -- parameter_value
         ,'N'                         -- fusion_mandatory
         ,'Y'                         -- user_updateable
         );
--
--
/*********************************************************************************/
--
/*
*******************
** AR Cash Receipts
*******************
*/
--
INSERT
INTO    xxmx_fusion_job_definitions
         (
          application_suite
         ,application
         ,business_entity
         ,file_group_number
         ,fusion_job_package_name
         ,fusion_job_definition_name
         )
VALUES
         (
          'FIN'                                                          -- application_suite
         ,'AR'                                                           -- application
         ,'CASH_RECEIPTS'                                                -- business_entity
         ,1                                                              -- file_group_number
         ,'/oracle/apps/ess/financials/receivables/receipts/lockboxes/'  -- fusion_job_package_name
         ,'LockboxImportEss'                                             -- fusion_job_definition_name
         );
--
EXECUTE :vn_ParameterSeq := 1;
--
INSERT
INTO    xxmx_fusion_job_parameters
         (
          fusion_job_definition_name
         ,parameter_seq
         ,parameter_name
         ,parameter_value
         ,fusion_mandatory
         ,user_updateable
         )
VALUES
         (
          'LockboxImportEss'      -- fusion_job_definition_name
         ,:vn_ParameterSeq        -- parameter_seq
         ,'Business Unit'         -- parameter_name
         ,'[BUSINESS_UNIT_NAME]'  -- parameter_value
         ,'Y'                     -- fusion_mandatory
         ,'N'                     -- user_updateable
         );
--
EXECUTE :vn_ParameterSeq := :vn_ParameterSeq + 1;
--
INSERT
INTO    xxmx_fusion_job_parameters
         (
          fusion_job_definition_name
         ,parameter_seq
         ,parameter_name
         ,parameter_value
         ,fusion_mandatory
         ,user_updateable
         )
VALUES
         (
          'LockboxImportEss'      -- fusion_job_definition_name
         ,:vn_ParameterSeq        -- parameter_seq
         ,'Import Process ID'     -- parameter_name
         ,'#NULL'                 -- parameter_value
         ,'N'                     -- fusion_mandatory
         ,'Y'                     -- user_updateable
         );
--
EXECUTE :vn_ParameterSeq := :vn_ParameterSeq + 1;
--
INSERT
INTO    xxmx_fusion_job_parameters
         (
          fusion_job_definition_name
         ,parameter_seq
         ,parameter_name
         ,parameter_value
         ,fusion_mandatory
         ,user_updateable
         )
VALUES
         (
          'LockboxImportEss'      -- fusion_job_definition_name
         ,:vn_ParameterSeq        -- parameter_seq
         ,'New Transmission'      -- parameter_name
         ,'Y'                     -- parameter_value
         ,'Y'                     -- fusion_mandatory
         ,'Y'                     -- user_updateable
         );
--
EXECUTE :vn_ParameterSeq := :vn_ParameterSeq + 1;
--
INSERT
INTO    xxmx_fusion_job_parameters
         (
          fusion_job_definition_name
         ,parameter_seq
         ,parameter_name
         ,parameter_value
         ,fusion_mandatory
         ,user_updateable
         )
VALUES
         (
          'LockboxImportEss'      -- fusion_job_definition_name
         ,:vn_ParameterSeq        -- parameter_seq
         ,'Transmission Name'     -- parameter_name
         ,'#NULL'                 -- parameter_value
         ,'Y'                     -- fusion_mandatory
         ,'Y'                     -- user_updateable
         );
--
EXECUTE :vn_ParameterSeq := :vn_ParameterSeq + 1;
--
INSERT
INTO    xxmx_fusion_job_parameters
         (
          fusion_job_definition_name
         ,parameter_seq
         ,parameter_name
         ,parameter_value
         ,fusion_mandatory
         ,user_updateable
         )
VALUES
         (
          'LockboxImportEss'      -- fusion_job_definition_name
         ,:vn_ParameterSeq        -- parameter_seq
         ,'Submit Import'         -- parameter_name
         ,'N'                     -- parameter_value
         ,'Y'                     -- fusion_mandatory
         ,'Y'                     -- user_updateable
         );
--
EXECUTE :vn_ParameterSeq := :vn_ParameterSeq + 1;
--
INSERT
INTO    xxmx_fusion_job_parameters
         (
          fusion_job_definition_name
         ,parameter_seq
         ,parameter_name
         ,parameter_value
         ,fusion_mandatory
         ,user_updateable
         )
VALUES
         (
          'LockboxImportEss'      -- fusion_job_definition_name
         ,:vn_ParameterSeq        -- parameter_seq
         ,'Data File'             -- parameter_name
         ,'N'                     -- parameter_value
         ,'N'                     -- fusion_mandatory
         ,'Y'                     -- user_updateable
         );
--
EXECUTE :vn_ParameterSeq := :vn_ParameterSeq + 1;
--
INSERT
INTO    xxmx_fusion_job_parameters
         (
          fusion_job_definition_name
         ,parameter_seq
         ,parameter_name
         ,parameter_value
         ,fusion_mandatory
         ,user_updateable
         )
VALUES
         (
          'LockboxImportEss'      -- fusion_job_definition_name
         ,:vn_ParameterSeq        -- parameter_seq
         ,'Control File'          -- parameter_name
         ,'N'                     -- parameter_value
         ,'N'                     -- fusion_mandatory
         ,'Y'                     -- user_updateable
         );
--
EXECUTE :vn_ParameterSeq := :vn_ParameterSeq + 1;
--
INSERT
INTO    xxmx_fusion_job_parameters
         (
          fusion_job_definition_name
         ,parameter_seq
         ,parameter_name
         ,parameter_value
         ,fusion_mandatory
         ,user_updateable
         )
VALUES
         (
          'LockboxImportEss'      -- fusion_job_definition_name
         ,:vn_ParameterSeq        -- parameter_seq
         ,'Transmission Format'   -- parameter_name
         ,'Default Lockbox'       -- parameter_value
         ,'N'                     -- fusion_mandatory
         ,'Y'                     -- user_updateable
         );
--
EXECUTE :vn_ParameterSeq := :vn_ParameterSeq + 1;
--
INSERT
INTO    xxmx_fusion_job_parameters
         (
          fusion_job_definition_name
         ,parameter_seq
         ,parameter_name
         ,parameter_value
         ,fusion_mandatory
         ,user_updateable
         )
VALUES
         (
          'LockboxImportEss'      -- fusion_job_definition_name
         ,:vn_ParameterSeq        -- parameter_seq
         ,'Submit Validation'     -- parameter_name
         ,'N'                     -- parameter_value
         ,'Y'                     -- fusion_mandatory
         ,'Y'                     -- user_updateable
         );
--
EXECUTE :vn_ParameterSeq := :vn_ParameterSeq + 1;
--
INSERT
INTO    xxmx_fusion_job_parameters
         (
          fusion_job_definition_name
         ,parameter_seq
         ,parameter_name
         ,parameter_value
         ,fusion_mandatory
         ,user_updateable
         )
VALUES
         (
          'LockboxImportEss'      -- fusion_job_definition_name
         ,:vn_ParameterSeq        -- parameter_seq
         ,'Lockbox'               -- parameter_name
         ,'#NULL'                 -- parameter_value
         ,'N'                     -- fusion_mandatory
         ,'Y'                     -- user_updateable
         );
--
EXECUTE :vn_ParameterSeq := :vn_ParameterSeq + 1;
--
INSERT
INTO    xxmx_fusion_job_parameters
         (
          fusion_job_definition_name
         ,parameter_seq
         ,parameter_name
         ,parameter_value
         ,fusion_mandatory
         ,user_updateable
         )
VALUES
         (
          'LockboxImportEss'      -- fusion_job_definition_name
         ,:vn_ParameterSeq        -- parameter_seq
         ,'Accounting Date'       -- parameter_name
         ,'[SYSDATE]'             -- parameter_value
         ,'N'                     -- fusion_mandatory
         ,'Y'                     -- user_updateable
         );
--
EXECUTE :vn_ParameterSeq := :vn_ParameterSeq + 1;
--
INSERT
INTO    xxmx_fusion_job_parameters
         (
          fusion_job_definition_name
         ,parameter_seq
         ,parameter_name
         ,parameter_value
         ,fusion_mandatory
         ,user_updateable
         )
VALUES
         (
          'LockboxImportEss'      -- fusion_job_definition_name
         ,:vn_ParameterSeq        -- parameter_seq
         ,'Report Format'         -- parameter_name
         ,'All'                   -- parameter_value
         ,'N'                     -- fusion_mandatory
         ,'Y'                     -- user_updateable
         );
--
EXECUTE :vn_ParameterSeq := :vn_ParameterSeq + 1;
--
INSERT
INTO    xxmx_fusion_job_parameters
         (
          fusion_job_definition_name
         ,parameter_seq
         ,parameter_name
         ,parameter_value
         ,fusion_mandatory
         ,user_updateable
         )
VALUES
         (
          'LockboxImportEss'       -- fusion_job_definition_name
         ,:vn_ParameterSeq         -- parameter_seq
         ,'Complete Batches Only'  -- parameter_name
         ,'N'                      -- parameter_value
         ,'Y'                      -- fusion_mandatory
         ,'Y'                      -- user_updateable
         );
--
EXECUTE :vn_ParameterSeq := :vn_ParameterSeq + 1;
--
INSERT
INTO    xxmx_fusion_job_parameters
         (
          fusion_job_definition_name
         ,parameter_seq
         ,parameter_name
         ,parameter_value
         ,fusion_mandatory
         ,user_updateable
         )
VALUES
         (
          'LockboxImportEss'                     -- fusion_job_definition_name
         ,:vn_ParameterSeq                       -- parameter_seq
         ,'Allow Payment of Unrelated Invoices'  -- parameter_name
         ,'N'                                    -- parameter_value
         ,'Y'                                    -- fusion_mandatory
         ,'Y'                                    -- user_updateable
         );
--
EXECUTE :vn_ParameterSeq := :vn_ParameterSeq + 1;
--
INSERT
INTO    xxmx_fusion_job_parameters
         (
          fusion_job_definition_name
         ,parameter_seq
         ,parameter_name
         ,parameter_value
         ,fusion_mandatory
         ,user_updateable
         )
VALUES
         (
          'LockboxImportEss'                                              -- fusion_job_definition_name
         ,:vn_ParameterSeq                                                -- parameter_seq
         ,'Post Receipt with Invalid Transaction Reference as Unapplied'  -- parameter_name
         ,'N'                                                             -- parameter_value
         ,'Y'                                                             -- fusion_mandatory
         ,'Y'                                                             -- user_updateable
         );
--
EXECUTE :vn_ParameterSeq := :vn_ParameterSeq + 1;
--
INSERT
INTO    xxmx_fusion_job_parameters
         (
          fusion_job_definition_name
         ,parameter_seq
         ,parameter_name
         ,parameter_value
         ,fusion_mandatory
         ,user_updateable
         )
VALUES
         (
          'LockboxImportEss'      -- fusion_job_definition_name
         ,:vn_ParameterSeq        -- parameter_seq
         ,'Submit Post Receipts'  -- parameter_name
         ,'N'                     -- parameter_value
         ,'Y'                     -- fusion_mandatory
         ,'Y'                     -- user_updateable
         );
--
EXECUTE :vn_ParameterSeq := :vn_ParameterSeq + 1;
--
INSERT
INTO    xxmx_fusion_job_parameters
         (
          fusion_job_definition_name
         ,parameter_seq
         ,parameter_name
         ,parameter_value
         ,fusion_mandatory
         ,user_updateable
         )
VALUES
         (
          'LockboxImportEss'                          -- fusion_job_definition_name
         ,:vn_ParameterSeq                            -- parameter_seq
         ,'Number of Instances to Process AutoApply'  -- parameter_name
         ,'1'                                         -- parameter_value
         ,'Y'                                         -- fusion_mandatory
         ,'Y'                                         -- user_updateable
         );
--
/*
**********************************************************************************
*/
--
/*
******************************************
** GL Balances (loaded via Journal Import)
******************************************
*/
--
INSERT
INTO    xxmx_fusion_job_definitions
         (
          application_suite
         ,application
         ,business_entity
         ,file_group_number
         ,fusion_job_package_name
         ,fusion_job_definition_name
         )
VALUES
         (
          'FIN'                                                                 -- application_suite
         ,'GL'                                                                  -- application
         ,'BALANCES'                                                            -- business_entity
         ,1                                                                     -- file_group_number
         ,'/oracle/apps/ess/financials/generalLedger/programs/common/'          -- fusion_job_package_name
         ,'JournalImportLauncher'                                               -- fusion_job_definition_name
         );
--
EXECUTE :vn_ParameterSeq := 1;
--
INSERT
INTO    xxmx_fusion_job_parameters
         (
          fusion_job_definition_name
         ,parameter_seq
         ,parameter_name
         ,parameter_value
         ,fusion_mandatory
         ,user_updateable
         )
VALUES
         (
          'JournalImportLauncher'  -- fusion_job_definition_name
         ,:vn_ParameterSeq         -- parameter_seq
         ,'Data Access Set'        -- parameter_name
         ,'[LEDGER_NAME]'          -- parameter_value
         ,'N'                      -- fusion_mandatory
         ,'Y'                      -- user_updateable
         );
--
EXECUTE :vn_ParameterSeq := :vn_ParameterSeq + 1;
--
INSERT
INTO    xxmx_fusion_job_parameters
         (
          fusion_job_definition_name
         ,parameter_seq
         ,parameter_name
         ,parameter_value
         ,fusion_mandatory
         ,user_updateable
         )
VALUES
         (
          'JournalImportLauncher'  -- fusion_job_definition_name
         ,:vn_ParameterSeq         -- parameter_seq
         ,'Source'                 -- parameter_name
         ,'Data Migration'         -- parameter_value
         ,'Y'                      -- fusion_mandatory
         ,'N'                      -- user_updateable
         );
--
EXECUTE :vn_ParameterSeq := :vn_ParameterSeq + 1;
--
INSERT
INTO    xxmx_fusion_job_parameters
         (
          fusion_job_definition_name
         ,parameter_seq
         ,parameter_name
         ,parameter_value
         ,fusion_mandatory
         ,user_updateable
         )
VALUES
         (
          'JournalImportLauncher'  -- fusion_job_definition_name
         ,:vn_ParameterSeq         -- parameter_seq
         ,'Ledger'       		   -- parameter_name
         ,'[LEDGER_NAME]'          -- parameter_value
         ,'Y'                      -- fusion_mandatory
         ,'N'                      -- user_updateable
         );
--
EXECUTE :vn_ParameterSeq := :vn_ParameterSeq + 1;
--
INSERT
INTO    xxmx_fusion_job_parameters
         (
          fusion_job_definition_name
         ,parameter_seq
         ,parameter_name
         ,parameter_value
         ,fusion_mandatory
         ,user_updateable
         )
VALUES
         (
          'JournalImportLauncher'  -- fusion_job_definition_name
         ,:vn_ParameterSeq         -- parameter_seq
         ,'Group ID'               -- parameter_name
         ,'[MIGRATION_SET_ID]'     -- parameter_value
         ,'N'                      -- fusion_mandatory
         ,'Y'                      -- user_updateable
         );
--
EXECUTE :vn_ParameterSeq := :vn_ParameterSeq + 1;
--
INSERT
INTO    xxmx_fusion_job_parameters
         (
          fusion_job_definition_name
         ,parameter_seq
         ,parameter_name
         ,parameter_value
         ,fusion_mandatory
         ,user_updateable
         )
VALUES
         (
          'JournalImportLauncher'            -- fusion_job_definition_name
         ,:vn_ParameterSeq                   -- parameter_seq
         ,'Post Account Errors to Suspense'  -- parameter_name
         ,'No'                               -- parameter_value
         ,'N'                                -- fusion_mandatory
         ,'Y'                                -- user_updateable
         );
--
EXECUTE :vn_ParameterSeq := :vn_ParameterSeq + 1;
--
INSERT
INTO    xxmx_fusion_job_parameters
         (
          fusion_job_definition_name
         ,parameter_seq
         ,parameter_name
         ,parameter_value
         ,fusion_mandatory
         ,user_updateable
         )
VALUES
         (
          'JournalImportLauncher'    -- fusion_job_definition_name
         ,:vn_ParameterSeq           -- parameter_seq
         ,'Create Summary Journals'  -- parameter_name
         ,'No'                       -- parameter_value
         ,'N'                        -- fusion_mandatory
         ,'Y'                        -- user_updateable
         );
--
EXECUTE :vn_ParameterSeq := :vn_ParameterSeq + 1;
--
INSERT
INTO    xxmx_fusion_job_parameters
         (
          fusion_job_definition_name
         ,parameter_seq
         ,parameter_name
         ,parameter_value
         ,fusion_mandatory
         ,user_updateable
         )
VALUES
         (
          'JournalImportLauncher'          -- fusion_job_definition_name
         ,:vn_ParameterSeq                 -- parameter_seq
         ,'Import Descriptive Flexfields'  -- parameter_name
         ,'No'                             -- parameter_value
         ,'N'                              -- fusion_mandatory
         ,'Y'                              -- user_updateable
         );
--
COMMIT;


