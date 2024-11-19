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
--** FILENAME  :  xxmx_configuration_issues_dbi.sql
--**
--** FILEPATH  :  ????
--**
--** VERSION   :  1.0
--**
--** EXECUTE
--** IN SCHEMA :  APPS
--**
--** AUTHORS   :  Sinchana Ramesh
--**
--** PURPOSE   :  This script installs the configuration issues table in Maximise.
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
--**   Vsn  Created Date  Created By          Description
--** -----  -----------  ------------------  -----------------------------------
--** [ 1.0  DD-Mon-YYYY  Change Author       Created.                          ]
--**
--******************************************************************************
--**
--** xxcust_common_pkg.sql HISTORY
--** ------------------------------------
--**
--**   Vsn  Created Date  Created By             Description
--** -----  -----------  ------------------  -----------------------------------
--**   1.0  01-FEB-2024  Sinchana Ramesh      Created for Cloudbridge.
--**
--**   1.0  01-FEB-2024  Sinchana Ramesh      Created table for configuration check package.
--**
--******************************************************************************
--
CREATE TABLE XXMX_CONFIGURATION_ISSUES
(
APPLICATION_SUITE                     VARCHAR2(50), 
APPLICATION                           VARCHAR2(50),  
BUSINESS_ENTITY                       VARCHAR2(50),  
SUB_ENTITY                            VARCHAR2(50), 
STG_TABLE_EXISTS                      VARCHAR2(500), 
XFM_TABLE_EXISTS                      VARCHAR2(500), 
STG_ARCH_EXISTS                       VARCHAR2(500), 
XFM_ARCH_EXISTS                       VARCHAR2(500), 
STG_POPULATE_EXISTS                   VARCHAR2(500), 
XFM_POPULATE_EXISTS                   VARCHAR2(500), 
METADATA_ENTRY                        VARCHAR2(500), 
COLUMN_STATUS                         VARCHAR2(500), 
FILE_LOCATION_STATUS                  VARCHAR2(500), 
DIRECTORY_STATUS                      VARCHAR2(500),
INCLUDE_IN_OUTBOUND_FILE_STATUS       VARCHAR2(500)
);
/