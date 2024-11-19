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
--** FILENAME  :  xxmx_populate_file_locations.sql
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
--** PURPOSE   :  This script populates the XXMX_FILE_LOCATIONS table.
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
--**   1.0  05-NOV-2020  Ian S. Vickerstaff  Created for Cloudbridge.
--**
--**   1.1  14-JUL-2021  Ian S. Vickerstaff  Header comment updates.
--**
--******************************************************************************
--
--
--** Delete Existing Data
--
DELETE FROM xxmx_file_locations;
--
PROMPT *******************************************
PROMPT ** POPULATING FILE LOCATIONS METADATA TABLE
PROMPT *******************************************
--
/*********************************************************************************/
--
/*
** Auto-populate from other metadata tables
*/
--
INSERT
INTO     xxmx_file_locations
        (
         application_suite
        ,application      
        ,business_entity  
        ,file_group_number 
        ,used_by          
        ,file_type        
        ,file_location_type        
        ,file_location        
        )
SELECT   application_suite            -- application_suite
        ,application                  -- application      
        ,business_entity              -- business_entity  
        ,file_group_number            -- file_group_number  
        ,'OIC'                        -- used_by          
        ,'DATA'                       -- file_type   
        ,'OIC_INTERNAL'               -- file_location_type        
        ,LOWER(                               
               '/'
             ||application_suite
             ||'/'
             ||application
             ||'/'
             ||business_entity
             ||file_group_number
             ||'/'
              )                       -- file_location
FROM      xxmx_file_group_properties;
--
/*
** Create FTP locations based on OIC Data File Locations
*/
--
INSERT
INTO     xxmx_file_locations
        (
         application_suite
        ,application      
        ,business_entity  
        ,file_group_number 
        ,used_by          
        ,file_type
        ,file_location_type        
        ,file_location        
        )
SELECT   application_suite            -- application_suite
        ,application                  -- application      
        ,business_entity              -- business_entity  
        ,file_group_number            -- file_group_number  
        ,'OIC'                        -- used_by          
        ,'DATA'                       -- file_type
        ,'FTP_DATA'                   -- file_location_type        
        ,LOWER(                               
               '/'
             ||application_suite
             ||'/'
             ||application
             ||'/'
             ||business_entity
             ||file_group_number
             ||'/'
             ||'data'
             ||'/'
              )                       -- file_location
FROM      xxmx_file_group_properties;
--
--
/*
** Create FTP locations based on OIC Data File Locations
*/
--
INSERT
INTO     xxmx_file_locations
        (
         application_suite
        ,application      
        ,business_entity  
        ,file_group_number 
        ,used_by          
        ,file_type        
        ,file_location_type        
        ,file_location        
        )
SELECT   application_suite            -- application_suite
        ,application                  -- application      
        ,business_entity              -- business_entity  
        ,file_group_number            -- file_group_number  
        ,'OIC'                        -- used_by          
        ,'DATA'                       -- file_type        
        ,'FTP_PROCESS'                -- file_location_type        
        ,LOWER(                               
               '/'
             ||application_suite
             ||'/'
             ||application
             ||'/'
             ||business_entity
             ||file_group_number
             ||'/'
             ||'process'
             ||'/'
              )                       -- file_location
FROM      xxmx_file_group_properties;
--
--
/*
** Create FTP locations based on OIC Data File Locations
*/
--
INSERT
INTO     xxmx_file_locations
        (
         application_suite
        ,application      
        ,business_entity  
        ,file_group_number 
        ,used_by          
        ,file_type        
        ,file_location_type        
        ,file_location        
        )
SELECT   application_suite            -- application_suite
        ,application                  -- application      
        ,business_entity              -- business_entity  
        ,file_group_number            -- file_group_number  
        ,'OIC'                        -- used_by          
        ,'DATA'                       -- file_type        
        ,'FTP_OUTPUT'                 -- file_location_type        
        ,LOWER(                               
               '/'
             ||application_suite
             ||'/'
             ||application
             ||'/'
             ||business_entity
             ||file_group_number
             ||'/'
             ||'output'
             ||'/'
              )                       -- file_location
FROM      xxmx_file_group_properties;
--
--
--/*********************************************************************************/
--
COMMIT;
