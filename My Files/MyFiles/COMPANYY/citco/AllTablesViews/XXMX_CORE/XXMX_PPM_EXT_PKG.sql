--------------------------------------------------------
--  DDL for Package XXMX_PPM_EXT_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "XXMX_CORE"."XXMX_PPM_EXT_PKG" AUTHID current_user AS
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
     **   1.0  16-MAY-2022  Dhanu Gundala       Initial implementation
     ******************************************************************************
     */
    PROCEDURE transform_project_template (
        pt_i_applicationsuite      IN    xxmx_seeded_extensions.application_suite%TYPE,
        pt_i_application           IN    xxmx_seeded_extensions.application%TYPE,
        pt_i_businessentity        IN    xxmx_seeded_extensions.business_entity%TYPE,
--        pt_i_subentity             IN    xxmx_seeded_extensions.business_entity%TYPE,
        pt_i_stgpopulationmethod   IN    xxmx_core_parameters.parameter_value%TYPE,
        pt_i_filesetid             IN    xxmx_migration_headers.file_set_id%TYPE,
        pt_i_migrationsetid        IN    xxmx_migration_headers.migration_set_id%TYPE,
        pv_o_returnstatus          OUT   VARCHAR2
    );
--
--
    PROCEDURE transform_poo (
        pt_i_applicationsuite      IN    xxmx_seeded_extensions.application_suite%TYPE,
        pt_i_application           IN    xxmx_seeded_extensions.application%TYPE,
        pt_i_businessentity        IN    xxmx_seeded_extensions.business_entity%TYPE,
--        pt_i_subentity             IN    xxmx_seeded_extensions.business_entity%TYPE,
        pt_i_stgpopulationmethod   IN    xxmx_core_parameters.parameter_value%TYPE,
        pt_i_filesetid             IN    xxmx_migration_headers.file_set_id%TYPE,
        pt_i_migrationsetid        IN    xxmx_migration_headers.migration_set_id%TYPE,
        pv_o_returnstatus          OUT   VARCHAR2
    );
--
    PROCEDURE transform_task_number (
        pt_i_applicationsuite      IN    xxmx_seeded_extensions.application_suite%TYPE,
        pt_i_application           IN    xxmx_seeded_extensions.application%TYPE,
        pt_i_businessentity        IN    xxmx_seeded_extensions.business_entity%TYPE,
--        pt_i_subentity             IN    xxmx_seeded_extensions.business_entity%TYPE,
        pt_i_stgpopulationmethod   IN    xxmx_core_parameters.parameter_value%TYPE,
        pt_i_filesetid             IN    xxmx_migration_headers.file_set_id%TYPE,
        pt_i_migrationsetid        IN    xxmx_migration_headers.migration_set_id%TYPE,
        pv_o_returnstatus          OUT   VARCHAR2
    );	
--	
    PROCEDURE transform_description (
        pt_i_applicationsuite      IN    xxmx_seeded_extensions.application_suite%TYPE,
        pt_i_application           IN    xxmx_seeded_extensions.application%TYPE,
        pt_i_businessentity        IN    xxmx_seeded_extensions.business_entity%TYPE,
--        pt_i_subentity             IN    xxmx_seeded_extensions.business_entity%TYPE,
        pt_i_stgpopulationmethod   IN    xxmx_core_parameters.parameter_value%TYPE,
        pt_i_filesetid             IN    xxmx_migration_headers.file_set_id%TYPE,
        pt_i_migrationsetid        IN    xxmx_migration_headers.migration_set_id%TYPE,
        pv_o_returnstatus          OUT   VARCHAR2
    );	
--	
    PROCEDURE transform_trx_control_task_num (
        pt_i_applicationsuite      IN    xxmx_seeded_extensions.application_suite%TYPE,
        pt_i_application           IN    xxmx_seeded_extensions.application%TYPE,
        pt_i_businessentity        IN    xxmx_seeded_extensions.business_entity%TYPE,
--        pt_i_subentity             IN    xxmx_seeded_extensions.business_entity%TYPE,
        pt_i_stgpopulationmethod   IN    xxmx_core_parameters.parameter_value%TYPE,
        pt_i_filesetid             IN    xxmx_migration_headers.file_set_id%TYPE,
        pt_i_migrationsetid        IN    xxmx_migration_headers.migration_set_id%TYPE,
        pv_o_returnstatus          OUT   VARCHAR2
    );	
--		
PROCEDURE transform(
        pt_i_applicationsuite      IN    xxmx_seeded_extensions.application_suite%TYPE,
        pt_i_application           IN    xxmx_seeded_extensions.application%TYPE,
        pt_i_businessentity        IN    xxmx_seeded_extensions.business_entity%TYPE,
--        pt_i_subentity             IN    xxmx_seeded_extensions.business_entity%TYPE,
        pt_i_stgpopulationmethod   IN    xxmx_core_parameters.parameter_value%TYPE,
        pt_i_filesetid             IN    xxmx_migration_headers.file_set_id%TYPE,
        pt_i_migrationsetid        IN    xxmx_migration_headers.migration_set_id%TYPE,
        pv_o_returnstatus          OUT   VARCHAR2
    );
END xxmx_ppm_ext_pkg;


/
