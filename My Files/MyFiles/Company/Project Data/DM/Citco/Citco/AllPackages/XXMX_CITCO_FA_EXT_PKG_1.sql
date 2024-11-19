--------------------------------------------------------
--  DDL for Package Body XXMX_CITCO_FA_EXT_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "XXMX_CORE"."XXMX_CITCO_FA_EXT_PKG" 
as 
 Procedure Transform_code ( pt_i_applicationsuite      IN    xxmx_seeded_extensions.application_suite%TYPE,
        pt_i_application           IN    xxmx_seeded_extensions.application%TYPE,
        pt_i_businessentity        IN    xxmx_seeded_extensions.business_entity%TYPE,
        pt_i_stgpopulationmethod   IN    xxmx_core_parameters.parameter_value%TYPE,
        pt_i_filesetid             IN    xxmx_migration_headers.file_set_id%TYPE,
        pt_i_migrationsetid        IN    xxmx_migration_headers.migration_set_id%TYPE,
        pv_o_returnstatus          OUT   VARCHAR2
    )
    AS 
    
    BEGIN 

    update xxmx_fa_mass_Additions_xfm
    set interface_line_num= mass_addition_id
    where migration_Set_id = pt_i_migrationsetid;

    Update xxmx_fa_mass_addition_dist_xfm
    set interface_line_num= mass_addition_id
    where migration_Set_id = pt_i_migrationsetid;

      Update xxmx_fa_mass_rates_xfm
    set interface_line_num= mass_addition_id
    where migration_Set_id = pt_i_migrationsetid;

        EXCEPTION
            WHEN OTHERS THEN
                    raise;
        END;


END xxmx_citco_fa_ext_pkg;

/
