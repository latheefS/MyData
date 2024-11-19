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
--** FILENAME  :  xxmx_populate_file_groups.sql
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
--** PURPOSE   :  This script populates the XXMX_FILE_GROUP_PROPERTIES table.
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
--**   1.0  04-NOV-2020  Ian S. Vickerstaff  Created for Cloudbridge.
--**
--**   1.1  14-JUL-2021  Ian S. Vickerstaff  Header comment updates.
--**
--******************************************************************************
--
--
--** Delete Existing Data
--
DELETE FROM xxmx_file_group_properties;
--
PROMPT ****************************************
PROMPT ** POPULATING FILE GROUPS METADATA TABLE
PROMPT ****************************************
--
/*********************************************************************************/
--
--** Insert Values
--
INSERT
INTO     xxmx_file_group_properties
        (
         application_suite        
        ,application              
        ,business_entity          
        ,file_group_number          
        ,property_file_name_prefix
        )
SELECT     DISTINCT
           application_suite
          ,application
          ,business_entity
          ,file_group_number
          ,LOWER(
                 application
               ||'_'
               ||business_entity
               ||'_'
               ||file_group_number
                )  AS property_file_prefix
FROM       xxmx_migration_metadata
ORDER BY  application
         ,business_entity
         ,file_group_number;

--
--/*********************************************************************************/
--
COMMIT;
