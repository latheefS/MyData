create or replace PACKAGE xxmx_kit_learning_stg AS

      --
      --
      --//================================================================================
      --// Version1
      --// $Id:$
      --//================================================================================
      --// Object Name        :: xxmx_kit_learning_stg
      --//
      --// Object Type        :: Package Body
      --//
      --// Object Description :: This package contains procedures for populating HCM 
      --//                            Learning/Course Details from EBS
      --//
      --//
      --// Version Control
      --//================================================================================
      --// Version      Author               Date               Description
      --//--------------------------------------------------------------------------------
      --// 1.0         Vamsi Krishna       14/03/2022         Initial Build

      --//================================================================================
      --
      --

  PROCEDURE export
    (p_bg_name                      IN      varchar2
    ,p_bg_id                        in      number
    ,pt_i_MigrationSetID            IN      xxmx_migration_headers.migration_set_id%TYPE
    ,pt_i_MigrationSetName          IN      xxmx_migration_headers.migration_set_name%TYPE ) ;

  PROCEDURE export_learning_certification
    (p_bg_name                      IN      varchar2
    ,p_bg_id                        IN      number
    ,pt_i_MigrationSetID            IN      xxmx_migration_headers.migration_set_id%TYPE
    ,pt_i_MigrationSetName          IN      xxmx_migration_headers.migration_set_name%TYPE ) ;

  PROCEDURE export_learning_classes
    (p_bg_name                      IN      varchar2
    ,p_bg_id                        IN      number
    ,pt_i_MigrationSetID            IN      xxmx_migration_headers.migration_set_id%TYPE
    ,pt_i_MigrationSetName          IN      xxmx_migration_headers.migration_set_name%TYPE ) ;

  PROCEDURE export_learning_courses
    (p_bg_name                      IN      varchar2
    ,p_bg_id                        IN      number
    ,pt_i_MigrationSetID            IN      xxmx_migration_headers.migration_set_id%TYPE
    ,pt_i_MigrationSetName          IN      xxmx_migration_headers.migration_set_name%TYPE ) ;

  PROCEDURE export_learner_records
    (p_bg_name                      IN      varchar2
    ,p_bg_id                        IN      number
    ,pt_i_MigrationSetID            IN      xxmx_migration_headers.migration_set_id%TYPE
    ,pt_i_MigrationSetName          IN      xxmx_migration_headers.migration_set_name%TYPE ) ;


  PROCEDURE purge
    (pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE ) ;

END XXMX_KIT_LEARNING_STG;