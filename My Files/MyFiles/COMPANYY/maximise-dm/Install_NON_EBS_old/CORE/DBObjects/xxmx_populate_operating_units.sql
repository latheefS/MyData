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
--** FILENAME  :  xxmx_populate_operating_units.sql
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
--** PURPOSE   :  This script populates the XXMX_SOURCE_OPERATING_UNITS table.
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
--**   1.0  16-FEB-2021  Ian S. Vickerstaff  Created for Maximise.
--**
--**   1.1  25-FEB-2021  Ian S. Vickerstaff  Default Value changes and addition
--**                                         of new lockbox related columns
--**                                         (lockbox_transmission_fmt_name and
--**                                         lockbox_transmission_fmt_id).
--**
--**   1.2  14-JUL-2021  Ian S. Vickerstaff  Header comment updates.
--**
--******************************************************************************
--
--
ALTER SESSION SET CONTAINER = MXDM_PDB1;
--
--
PROMPT **************************************************
PROMPT ** POPULATION OF XXMX_SOURCE_OPERATING_UNITS TABLE
PROMPT **************************************************
PROMPT
--
--
INSERT
INTO    xxmx_source_operating_units
         (
          source_operating_unit_name
         ,fusion_business_unit_name
         ,fusion_business_unit_id
         ,ap_inv_fusion_clearing_acct
         ,ar_trx_fusion_clearing_acct
         ,lockbox_number
         ,lockbox_id
         ,lockbox_transmission_fmt_name
         ,lockbox_transmission_fmt_id
         ,migration_enabled_flag
         )
SELECT    distinct_op_units.name              -- source_operating_unit_name
         ,'SMBC Primary'                      -- fusion_business_unit_name
         ,300000003935060                     -- fusion_business_unit_id
         ,'AP*XXXXXX*XXXXXX*XXXXXX*00000000'  -- ap_inv_fusion_clearing_acct
         ,'AR*YYYYYY*YYYYYY*YYYYYY*00000000'  -- ar_trx_fusion_clearing_acct
         ,'LOCKBOX1'                          -- lockbox_number
         ,300000012267485                     -- lockbox_id
         ,'MXDM'                              -- lockbox_transmission_fmt_name
         ,300000054952932                     -- lockbox_transmission_fmt_id
         ,'Y'                                 -- migration_enabled_flag
FROM     (
          SELECT  DISTINCT
                  haou.name
          FROM    apps.hr_all_organization_units@mxdm_nvis_extract    haou
                 ,apps.hr_organization_information@mxdm_nvis_extract  hoi
          WHERE   1 = 1
          AND     hoi.organization_id         = haou.organization_id
          AND     hoi.orG_information_context = 'CLASS'
          AND     hoi.org_information1        = 'OPERATING_UNIT'
          AND     NOT EXISTS (
                              SELECT 'X'
                              FROM    xxmx_source_operating_units xsou2
                              WHERE  1 = 1
                              AND    xsou2.source_operating_unit_name = haou.name
                             )
         )   distinct_op_units;
--
--
COMMIT;
--
