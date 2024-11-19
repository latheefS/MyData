create or replace PACKAGE xxmx_validate_customer_setup_pkg
AS
--
     --
     /*
     ******************************************************************************
     **
     **                 Copyright (c) 2020 Version 1
     **
     **                           Millennium House,
     **                           Millennium Walkway,
     **                           Dublin 1    
     **                           D01 F5P8
     **
     **                           All rights reserved.
     **
     ******************************************************************************
     **
     **
     ** FILENAME  :  xxmx_validate_customer_setup_pkg
     **
     ** FILEPATH  :  $XXV1_TOP/install/sql
     **
     ** VERSION   :  1.0
     **
     ** EXECUTE
     ** IN SCHEMA :  APPS
     **
     ** AUTHORS   :  Meenakshi Rajendran
     **
     ** PURPOSE   :  This script validate the customer setups for Data Migration.
     **
     ** NOTES     :
     **
     *******************************************************************************
     **
     ** PRE-REQUISITIES
     ** ---------------
     **
     ** If this script is to be executed as part of an installation script, ensure
     ** that the installation script performs the following tasks prior to calling
     ** this script.
     **
     ** Task  Description
     ** ----  ---------------------------------------------------------------------
     ** 1.   Make sure maximise solution(tables and other DB objects) is present in the environment
     **
     ** If this script is not to be executed as part of an installation script,
     ** ensure that the tasks above are, or have been, performed prior to executing
     ** this script.
     **
     ******************************************************************************
     **
     ** CALLING INSTALLATION SCRIPTS
     ** ----------------------------
     **
     ** The following installation scripts call this script:
     **
     ** File Path                                     File Name
     ** --------------------------------------------  ------------------------------
     ** N/A                                           N/A
     **
     ******************************************************************************
     **
     ** CALLED INSTALLATION SCRIPTS
     ** ---------------------------
     **
     ** The following installation scripts are called by this script:
     **
     ** File Path                                    File Name
     ** -------------------------------------------  ------------------------------
     ** N/A                                          N/A
     **
     ******************************************************************************
     **
     ** PARAMETERS
     ** ----------
     **
     ** Parameter                       IN OUT  Type
     ** -----------------------------  ------  ------------------------------------
     ** [parameter_name]                IN OUT
     **
     ******************************************************************************
     **
     ** [previous_filename] HISTORY
     ** -----------------------------
     **
     **   Vsn  Change Date  Changed By          Change Description
     ** -----  -----------  ------------------  -----------------------------------
     ** [ 1.0  DD-Mon-YYYY  Change Author       Created.                          ]
     **
     ******************************************************************************
     **
     ** xxmx_validate_customer_setup_pkg.pks HISTORY
     ** ------------------------------------
     **
     **   Vsn  Change Date  Changed By                Change Description
     ** -----  -----------  ------------------        -----------------------------
     **   1.0  15-MAR-2024  Meenakshi Rajendran       Initial implementation
     ******************************************************************************
     */

     --
     PROCEDURE insert_data 
	 (
        p_valid_type IN varchar2,
        x_status     OUT varchar2
	 );

     PROCEDURE validate_data 
	 (
        p_valid_type IN varchar2,
        x_status      OUT varchar2
     );

END xxmx_validate_customer_setup_pkg ;