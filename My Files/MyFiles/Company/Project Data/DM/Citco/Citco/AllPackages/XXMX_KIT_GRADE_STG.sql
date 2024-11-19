--------------------------------------------------------
--  DDL for Package XXMX_KIT_GRADE_STG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "XXMX_CORE"."XXMX_KIT_GRADE_STG" AS

      --
      --
      --//================================================================================
      --// Version1
      --// $Id:$
      --//================================================================================
      --// Object Name        :: xxmx_kit_grade_stg
      --//
      --// Object Type        :: Package Body
      --//
      --// Object Description :: This package contains procedures for populating HCM
      --//                            Grades from EBS
      --//
      --//
      --// Version Control
      --//================================================================================
      --// Version      Author               Date               Description
      --//--------------------------------------------------------------------------------
      --// 1.1         Pallavi Kanajar       26/05/2020         Initial Build

      --//================================================================================
      --
      --


  PROCEDURE export
    (p_bg_name                      IN      varchar2
    ,p_bg_id                        in      number
    ,pt_i_MigrationSetID            IN      xxmx_migration_headers.migration_set_id%TYPE
    ,pt_i_MigrationSetName          IN      xxmx_migration_headers.migration_set_name%TYPE ) ;

  PROCEDURE export_grades_f_5
    (p_bg_name                      IN      varchar2
    ,p_bg_id                        in      number
    ,pt_i_MigrationSetID            IN      xxmx_migration_headers.migration_set_id%TYPE
    ,pt_i_MigrationSetName          IN      xxmx_migration_headers.migration_set_name%TYPE ) ;

  PROCEDURE export_grades_f_10
    (p_bg_name                      IN      varchar2
    ,p_bg_id                        in      number
    ,pt_i_MigrationSetID            IN      xxmx_migration_headers.migration_set_id%TYPE
    ,pt_i_MigrationSetName          IN      xxmx_migration_headers.migration_set_name%TYPE ) ;

  PROCEDURE export_grades_f_tl_15
    (p_bg_name                      IN      varchar2
    ,p_bg_id                        in      number
    ,pt_i_MigrationSetID            IN      xxmx_migration_headers.migration_set_id%TYPE
    ,pt_i_MigrationSetName          IN      xxmx_migration_headers.migration_set_name%TYPE ) ;

  PROCEDURE export_grades_f_tl_25
    (p_bg_name                      IN      varchar2
    ,p_bg_id                        in      number
    ,pt_i_MigrationSetID            IN      xxmx_migration_headers.migration_set_id%TYPE
    ,pt_i_MigrationSetName          IN      xxmx_migration_headers.migration_set_name%TYPE ) ;

  PROCEDURE purge
    (pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE ) ;

END xxmx_kit_grade_stg;

/
