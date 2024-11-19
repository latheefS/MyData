--------------------------------------------------------
--  DDL for Package XXMX_VALIDATE_FA_SETUP_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "XXMX_CORE"."XXMX_VALIDATE_FA_SETUP_PKG" 
AS
--
     --
     /*
     *****************************************************************************
     **
     **                 Copyright (c) 2023 Version 1
     **
     **                           Millennium House,
     **                           Millennium Walkway,
     **                           Dublin 1
     **                           D01 F5P8
     **
     **                           All rights reserved.
     **
     *****************************************************************************
     **
     **
     ** FILENAME  :  <<Package_Name>>
     **
     ** FILEPATH  :  $XXMX_TOP/install/sql
     **
     ** VERSION   :  1.3
     **
     ** EXECUTE
     ** IN SCHEMA :  APPS
     **
     ** AUTHORS   :  <<Author Name>>
     **
     ** PURPOSE   :  This script validate the supplier setups for
     **              Data Migration.
     **
     ** NOTES     :
     **
     ******************************************************************************
     **
     ** PRE-REQUISITIES
     ** ---------------
     **

     */


     --
     PROCEDURE insert_data (
        p_valid_type IN varchar2,
        x_status      OUT varchar2);

        PROCEDURE validate_data (
        p_valid_type IN varchar2,
        x_status      OUT varchar2);


     --
     --
      --
      --
END xxmx_validate_fa_setup_pkg ;

/
