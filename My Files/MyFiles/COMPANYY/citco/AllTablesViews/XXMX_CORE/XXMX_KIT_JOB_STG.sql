--------------------------------------------------------
--  DDL for Package XXMX_KIT_JOB_STG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "XXMX_CORE"."XXMX_KIT_JOB_STG" AS


      --
      --
      --//================================================================================
      --// Version1
      --// $Id:$
      --//================================================================================
      --// Object Name        :: xxmx_kit_job_stg
      --//
      --// Object Type        :: Package Body
      --//
      --// Object Description :: This package contains procedures for populating HCM 
      --//                            Jobs from EBS
      --//
      --//
      --// Version Control
      --//================================================================================
      --// Version      Author               Date               Description
      --//--------------------------------------------------------------------------------
      --// 1.0         Pallavi Kanajar       26/05/2020         Initial Build

      --//================================================================================
      --
      --

   PROCEDURE export
    (p_bg_name                      IN      varchar2
    ,p_bg_id                        in      number
    ,pt_i_MigrationSetID            IN      xxmx_migration_headers.migration_set_id%TYPE
    ,pt_i_MigrationSetName          IN      xxmx_migration_headers.migration_set_name%TYPE ) ;

   PROCEDURE export_profiles_job
    (p_bg_name                      IN      varchar2
    ,p_bg_id                        in      number
    ,pt_i_MigrationSetID            IN      xxmx_migration_headers.migration_set_id%TYPE
    ,pt_i_MigrationSetName          IN      xxmx_migration_headers.migration_set_name%TYPE ) ;

  PROCEDURE export_jobs_f_10
    (p_bg_name                      IN      varchar2
    ,p_bg_id                        in      number
    ,pt_i_MigrationSetID            IN      xxmx_migration_headers.migration_set_id%TYPE
    ,pt_i_MigrationSetName          IN      xxmx_migration_headers.migration_set_name%TYPE ) ;

   PROCEDURE export_jobs_f_15
    (p_bg_name                      IN      varchar2
    ,p_bg_id                        in      number
    ,pt_i_MigrationSetID            IN      xxmx_migration_headers.migration_set_id%TYPE
    ,pt_i_MigrationSetName          IN      xxmx_migration_headers.migration_set_name%TYPE ) ;

   PROCEDURE export_jobs_f_20
    (p_bg_name                      IN      varchar2
    ,p_bg_id                        in      number
    ,pt_i_MigrationSetID            IN      xxmx_migration_headers.migration_set_id%TYPE
    ,pt_i_MigrationSetName          IN      xxmx_migration_headers.migration_set_name%TYPE ) ;

   PROCEDURE export_jobs_f_tl_25
    (p_bg_name                      IN      varchar2
    ,p_bg_id                        in      number
    ,pt_i_MigrationSetID            IN      xxmx_migration_headers.migration_set_id%TYPE
    ,pt_i_MigrationSetName          IN      xxmx_migration_headers.migration_set_name%TYPE ) ;

   PROCEDURE export_jobs_f_tl_35
    (p_bg_name                      IN      varchar2
    ,p_bg_id                        in      number
    ,pt_i_MigrationSetID            IN      xxmx_migration_headers.migration_set_id%TYPE
    ,pt_i_MigrationSetName          IN      xxmx_migration_headers.migration_set_name%TYPE ) ;

   PROCEDURE export_profiles_b_2_job_65
    (p_bg_name                      IN      varchar2
    ,p_bg_id                        in      number
    ,pt_i_MigrationSetID            IN      xxmx_migration_headers.migration_set_id%TYPE
    ,pt_i_MigrationSetName          IN      xxmx_migration_headers.migration_set_name%TYPE ) ;

   PROCEDURE export_profiles_tl_2_1_job_70
    (p_bg_name                      IN      varchar2
    ,p_bg_id                        in      number
    ,pt_i_MigrationSetID            IN      xxmx_migration_headers.migration_set_id%TYPE
    ,pt_i_MigrationSetName          IN      xxmx_migration_headers.migration_set_name%TYPE ) ;

   PROCEDURE export_profile_relns_1_job_80
    (p_bg_name                      IN      varchar2
    ,p_bg_id                        in      number
    ,pt_i_MigrationSetID            IN      xxmx_migration_headers.migration_set_id%TYPE
    ,pt_i_MigrationSetName          IN      xxmx_migration_headers.migration_set_name%TYPE ) ;

   PROCEDURE export_profile_items_1_job_85
    (p_bg_name                      IN      varchar2
    ,p_bg_id                        in      number
    ,pt_i_MigrationSetID            IN      xxmx_migration_headers.migration_set_id%TYPE
    ,pt_i_MigrationSetName          IN      xxmx_migration_headers.migration_set_name%TYPE ) ;

  PROCEDURE purge
    (pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE ) ;

END xxmx_kit_job_stg;

/
