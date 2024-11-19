create or replace PACKAGE xxmx_validate_code_comb_cvr_pkg
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
     ** PURPOSE   :  This script validate the code combination against CVR for all the entities during
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
     PROCEDURE gl_code_comb_cvr (
        p_xfm_tbl IN varchar2,
        x_status      OUT varchar2);
        
        PROCEDURE tot_count (
        p_xfm_tbl IN varchar2,
        x_count      OUT number,
        x_status      OUT varchar2);
        
        PROCEDURE acct_combination (p_xfm_tbl IN varchar2,
        p_cur      OUT sys_refcursor,
        x_status      OUT varchar2,
        p_var_skip     IN number);
     --
     --
      --
      --
END xxmx_validate_code_comb_cvr_pkg ;