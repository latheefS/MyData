--------------------------------------------------------
--  DDL for Package XXMX_CITCO_FIN_EXT_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "XXMX_CORE"."XXMX_CITCO_FIN_EXT_PKG" AUTHID current_user AS
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
     ** FILENAME  :  xxmx_citco_fin_ext_pkg.sql
     **
     ** FILEPATH  :  $XXV1_TOP/install/sql
     **
     ** VERSION   :  1.0
     **
     ** EXECUTE
     ** IN SCHEMA :  APPS
     **
     ** AUTHORS   :  Laxmikanth Muppiri/Meenakshi Rajendran
     **
     ** PURPOSE   :  This script installs the package specification for the xxmx_citco_fin_ext_pkg custom Procedures and Functions.
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
     ** xxmx_citco_gl_ext_pkg.sql HISTORY
     ** ------------------------------------
     **
     **   Vsn  Change Date  Changed By          Change Description
     ** -----  -----------  ------------------  -----------------------------------
     **   1.0  05-APR-2022  Laxmikanth Muppiri        Initial implementation
     **   1.1  12-JUL-2022  Meenakshi Rajendran       Added new procedure transform_gl_ref_code
     **   1.2  14-NOV-2022  Meenakshi Rajendran       Added new procedure transform_gl_histrates_values
     **   1.3  30-JAN-2023  Gaurav Kumar              Add two new procedure transform_gl_src, transform_gl_category
     ******************************************************************************
     */
    PROCEDURE transform_coa_segments (
        pt_i_applicationsuite      IN    xxmx_seeded_extensions.application_suite%TYPE,
        pt_i_application           IN    xxmx_seeded_extensions.application%TYPE,
        pt_i_businessentity        IN    xxmx_seeded_extensions.business_entity%TYPE,
        pt_i_stgpopulationmethod   IN    xxmx_core_parameters.parameter_value%TYPE,
        pt_i_filesetid             IN    xxmx_migration_headers.file_set_id%TYPE,
        pt_i_migrationsetid        IN    xxmx_migration_headers.migration_set_id%TYPE,
        pv_o_returnstatus          OUT   VARCHAR2
    );

    PROCEDURE transform_code_combo (
        pt_i_applicationsuite      IN    xxmx_seeded_extensions.application_suite%TYPE,
        pt_i_application           IN    xxmx_seeded_extensions.application%TYPE,
        pt_i_businessentity        IN    xxmx_seeded_extensions.business_entity%TYPE,
        pt_i_stgpopulationmethod   IN    xxmx_core_parameters.parameter_value%TYPE,
        pt_i_filesetid             IN    xxmx_migration_headers.file_set_id%TYPE,
        pt_i_migrationsetid        IN    xxmx_migration_headers.migration_set_id%TYPE,
        pv_o_returnstatus          OUT   VARCHAR2
    );
     PROCEDURE transform_exp_org (
        pt_i_applicationsuite    IN xxmx_seeded_extensions.application_suite%TYPE,
        pt_i_application         IN xxmx_seeded_extensions.application%TYPE,
        pt_i_businessentity      IN xxmx_seeded_extensions.business_entity%TYPE,
        pt_i_stgpopulationmethod IN xxmx_core_parameters.parameter_value%TYPE,
        pt_i_filesetid           IN xxmx_migration_headers.file_set_id%TYPE,
        pt_i_migrationsetid      IN xxmx_migration_headers.migration_set_id%TYPE,
        pv_o_returnstatus        OUT VARCHAR2
    );
    PROCEDURE transform_gl_ref_code ( 
        pt_i_applicationsuite      IN    xxmx_seeded_extensions.application_suite%TYPE,
        pt_i_application           IN    xxmx_seeded_extensions.application%TYPE,
        pt_i_businessentity        IN    xxmx_seeded_extensions.business_entity%TYPE,
        pt_i_stgpopulationmethod   IN    xxmx_core_parameters.parameter_value%TYPE,
        pt_i_filesetid             IN    xxmx_migration_headers.file_set_id%TYPE,
        pt_i_migrationsetid        IN    xxmx_migration_headers.migration_set_id%TYPE,
        pv_o_returnstatus          OUT   VARCHAR2
    );
	PROCEDURE transform_sup_bank_branches (
        pt_i_applicationsuite      IN    xxmx_seeded_extensions.application_suite%TYPE,
        pt_i_application           IN    xxmx_seeded_extensions.application%TYPE,
        pt_i_businessentity        IN    xxmx_seeded_extensions.business_entity%TYPE,
        pt_i_subentity             IN    xxmx_seeded_extensions.business_entity%TYPE,
        pt_i_stgpopulationmethod   IN    xxmx_core_parameters.parameter_value%TYPE,
        pt_i_filesetid             IN    xxmx_migration_headers.file_set_id%TYPE,
        pt_i_migrationsetid        IN    xxmx_migration_headers.migration_set_id%TYPE,
        pv_o_returnstatus          OUT   VARCHAR2
    );

     PROCEDURE transform_gl_ledgers (
        pt_i_applicationsuite    IN xxmx_seeded_extensions.application_suite%TYPE,
        pt_i_application         IN xxmx_seeded_extensions.application%TYPE,
        pt_i_businessentity      IN xxmx_seeded_extensions.business_entity%TYPE,
        pt_i_stgpopulationmethod IN xxmx_core_parameters.parameter_value%TYPE,
        pt_i_filesetid           IN xxmx_migration_headers.file_set_id%TYPE,
        pt_i_migrationsetid      IN xxmx_migration_headers.migration_set_id%TYPE,
        pv_o_returnstatus        OUT VARCHAR2
    );

     PROCEDURE transform_gl_histrates_values (
        pt_i_applicationsuite    IN xxmx_seeded_extensions.application_suite%TYPE,
        pt_i_application         IN xxmx_seeded_extensions.application%TYPE,
        pt_i_businessentity      IN xxmx_seeded_extensions.business_entity%TYPE,
        pt_i_stgpopulationmethod IN xxmx_core_parameters.parameter_value%TYPE,
        pt_i_filesetid           IN xxmx_migration_headers.file_set_id%TYPE,
        pt_i_migrationsetid      IN xxmx_migration_headers.migration_set_id%TYPE,
        pv_o_returnstatus        OUT VARCHAR2
    );

    /*PROCEDURE transform_gl_category (
        pt_i_applicationsuite    IN xxmx_seeded_extensions.application_suite%TYPE,
        pt_i_application         IN xxmx_seeded_extensions.application%TYPE,
        pt_i_businessentity      IN xxmx_seeded_extensions.business_entity%TYPE,
        pt_i_stgpopulationmethod IN xxmx_core_parameters.parameter_value%TYPE,
        pt_i_filesetid           IN xxmx_migration_headers.file_set_id%TYPE,
        pt_i_migrationsetid      IN xxmx_migration_headers.migration_set_id%TYPE,
        pv_o_returnstatus        OUT VARCHAR2
    );*/

    PROCEDURE transform_gl_src (
        pt_i_applicationsuite    IN xxmx_seeded_extensions.application_suite%TYPE,
        pt_i_application         IN xxmx_seeded_extensions.application%TYPE,
        pt_i_businessentity      IN xxmx_seeded_extensions.business_entity%TYPE,
        pt_i_stgpopulationmethod IN xxmx_core_parameters.parameter_value%TYPE,
        pt_i_filesetid           IN xxmx_migration_headers.file_set_id%TYPE,
        pt_i_migrationsetid      IN xxmx_migration_headers.migration_set_id%TYPE,
        pv_o_returnstatus        OUT VARCHAR2
    );

    PROCEDURE transform_supp_party (
        pt_i_applicationsuite    IN xxmx_seeded_extensions.application_suite%TYPE,
        pt_i_application         IN xxmx_seeded_extensions.application%TYPE,
        pt_i_businessentity      IN xxmx_seeded_extensions.business_entity%TYPE,
        pt_i_stgpopulationmethod IN xxmx_core_parameters.parameter_value%TYPE,
        pt_i_filesetid           IN xxmx_migration_headers.file_set_id%TYPE,
        pt_i_migrationsetid      IN xxmx_migration_headers.migration_set_id%TYPE,
        pv_o_returnstatus        OUT VARCHAR2
    );

    PROCEDURE transform_supp_reg (
        pt_i_applicationsuite    IN xxmx_seeded_extensions.application_suite%TYPE,
        pt_i_application         IN xxmx_seeded_extensions.application%TYPE,
        pt_i_businessentity      IN xxmx_seeded_extensions.business_entity%TYPE,
        pt_i_stgpopulationmethod IN xxmx_core_parameters.parameter_value%TYPE,
        pt_i_filesetid           IN xxmx_migration_headers.file_set_id%TYPE,
        pt_i_migrationsetid      IN xxmx_migration_headers.migration_set_id%TYPE,
        pv_o_returnstatus        OUT VARCHAR2
    );

PROCEDURE transform_ledger_name (
        pt_i_applicationsuite    IN xxmx_seeded_extensions.application_suite%TYPE,
        pt_i_application         IN xxmx_seeded_extensions.application%TYPE,
        pt_i_businessentity      IN xxmx_seeded_extensions.business_entity%TYPE,
        pt_i_stgpopulationmethod IN xxmx_core_parameters.parameter_value%TYPE,
        pt_i_filesetid           IN xxmx_migration_headers.file_set_id%TYPE,
        pt_i_migrationsetid      IN xxmx_migration_headers.migration_set_id%TYPE,
        pv_o_returnstatus        OUT VARCHAR2
    );
    gn_limit CONSTANT NUMBER := 1000;    -- cursor fetch limit
END xxmx_citco_fin_ext_pkg;

/
