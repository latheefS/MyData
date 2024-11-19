--------------------------------------------------------
--  DDL for Package XXMX_PPM_TRANSACTIONS_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "XXMX_CORE"."XXMX_PPM_TRANSACTIONS_PKG" AS 
--*****************************************************************************
--**
--**                 Copyright (c) 2020 Version 1
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
--** FILENAME  :  XXMX_PPM_TRANSACTIONS_PKG.pkb
--**
--** FILEPATH  :  $XXV1_TOP/install/sql
--**
--** VERSION   :  1.0
--**
--** EXECUTE
--** IN SCHEMA :  XXMX_STG
--**
--** AUTHORS   :  Dhanu Gundala
--**
--** PURPOSE   :  This package contains procedures for extracting Project Billing Events and Cost
--                into Staging tables
--***************************************************************************************************
--**   Vsn  Change Date  Changed By          Change Description
--** -----  -----------  ------------------  -----------------------------------
--**   1.0  07-APR-2022  Dhanu Gundala       Created for Citco.
--***************************************************************************************************


   PROCEDURE stg_main
                     (pt_i_ClientCode                 IN      xxmx_client_config_parameters.client_code%TYPE
                     ,pt_i_MigrationSetName           IN      xxmx_migration_headers.migration_set_name%TYPE ) ;



   PROCEDURE src_pa_all_lbr_costs
                     (pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                     ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE);                     

   PROCEDURE src_pa_all_misc_costs
                     (pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                     ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE);        


  PROCEDURE src_pa_all_events
                     (pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                     ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE);        

  PROCEDURE src_pa_lic_ap_inv;

END XXMX_PPM_TRANSACTIONS_PKG;

/
