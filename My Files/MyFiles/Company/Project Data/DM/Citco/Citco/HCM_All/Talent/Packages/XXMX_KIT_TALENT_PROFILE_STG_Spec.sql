create or replace PACKAGE xxmx_kit_talent_profile_stg AS

      --
      --
      --//================================================================================
      --// Version1
      --// $Id:$
      --//================================================================================
      --// Object Name        :: xxmx_kit_talent_profile_stg
      --//
      --// Object Type        :: Package Body
      --//
      --// Object Description :: This package contains procedures for extracting Performance Ratings and Competence 
		--//                       Data from EBS.
      --//
      --//
      --// Version Control
      --//================================================================================
      --// Version      Author               Date               Description
      --//--------------------------------------------------------------------------------
      --// 1.0          Vamsi              15/04/2022           Initial Build
      --// 1.1          Vamsi              20/05/2022           Added Talent Profile
      --//================================================================================
      --
      --

  PROCEDURE export
    (p_bg_name                      IN      varchar2
    ,p_bg_id                        in      number
    ,pt_i_MigrationSetID            IN      xxmx_migration_headers.migration_set_id%TYPE
    ,pt_i_MigrationSetName          IN      xxmx_migration_headers.migration_set_name%TYPE ) ;

/* Code added for Profile Item */
PROCEDURE export_person_talent_profile
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          NUMBER
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE );


   PROCEDURE export_performance_ratings
    (p_bg_name                      IN      varchar2
    ,p_bg_id                        IN      number
    ,pt_i_MigrationSetID            IN      xxmx_migration_headers.migration_set_id%TYPE
    ,pt_i_MigrationSetName          IN      xxmx_migration_headers.migration_set_name%TYPE ) ;

/*   PROCEDURE export_competences
    (p_bg_name                      IN      varchar2
    ,p_bg_id                        IN      number
    ,pt_i_MigrationSetID            IN      xxmx_migration_headers.migration_set_id%TYPE
    ,pt_i_MigrationSetName          IN      xxmx_migration_headers.migration_set_name%TYPE ) ;  */
/* Code Ended for Talent Profile and Profile Item */

  PROCEDURE purge
    (pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE ) ;

END XXMX_KIT_TALENT_PROFILE_STG;