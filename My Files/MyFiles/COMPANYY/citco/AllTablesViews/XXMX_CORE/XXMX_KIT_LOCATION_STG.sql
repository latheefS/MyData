--------------------------------------------------------
--  DDL for Package XXMX_KIT_LOCATION_STG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "XXMX_CORE"."XXMX_KIT_LOCATION_STG" AS

      --
      --
      --//================================================================================
      --// Version1
      --// $Id:$
      --//================================================================================
      --// Object Name        :: xxmx_kit_location_stg
      --//
      --// Object Type        :: Package Body
      --//
      --// Object Description :: This package contains procedures for populating HCM 
      --//                            location from EBS
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

  PROCEDURE export_locations_10
    (p_bg_name                      IN      varchar2
    ,p_bg_id                        in      number
    ,pt_i_MigrationSetID            IN      xxmx_migration_headers.migration_set_id%TYPE
    ,pt_i_MigrationSetName          IN      xxmx_migration_headers.migration_set_name%TYPE ) ;

  PROCEDURE export_addresses_f_20
    (p_bg_name                      IN      varchar2
    ,p_bg_id                        in      number
    ,pt_i_MigrationSetID            IN      xxmx_migration_headers.migration_set_id%TYPE
    ,pt_i_MigrationSetName          IN      xxmx_migration_headers.migration_set_name%TYPE ) ;

  PROCEDURE export_addresses_f_30
    (p_bg_name                      IN      varchar2
    ,p_bg_id                        in      number
    ,pt_i_MigrationSetID            IN      xxmx_migration_headers.migration_set_id%TYPE
    ,pt_i_MigrationSetName          IN      xxmx_migration_headers.migration_set_name%TYPE ) ;

  PROCEDURE export_loc_address_usages_f_20
    (p_bg_name                      IN      varchar2
    ,p_bg_id                        in      number
    ,pt_i_MigrationSetID            IN      xxmx_migration_headers.migration_set_id%TYPE
    ,pt_i_MigrationSetName          IN      xxmx_migration_headers.migration_set_name%TYPE ) ;

  PROCEDURE export_loc_address_usages_f_30
    (p_bg_name                      IN      varchar2
    ,p_bg_id                        in      number
    ,pt_i_MigrationSetID            IN      xxmx_migration_headers.migration_set_id%TYPE
    ,pt_i_MigrationSetName          IN      xxmx_migration_headers.migration_set_name%TYPE ) ;

  PROCEDURE export_location_details_f_40
    (p_bg_name                      IN      varchar2
    ,p_bg_id                        in      number
    ,pt_i_MigrationSetID            IN      xxmx_migration_headers.migration_set_id%TYPE
    ,pt_i_MigrationSetName          IN      xxmx_migration_headers.migration_set_name%TYPE ) ;

  PROCEDURE export_location_details_f_50
    (p_bg_name                      IN      varchar2
    ,p_bg_id                        in      number
    ,pt_i_MigrationSetID            IN      xxmx_migration_headers.migration_set_id%TYPE
    ,pt_i_MigrationSetName          IN      xxmx_migration_headers.migration_set_name%TYPE ) ;

  PROCEDURE export_location_details_tl_60
    (p_bg_name                      IN      varchar2
    ,p_bg_id                        in      number
    ,pt_i_MigrationSetID            IN      xxmx_migration_headers.migration_set_id%TYPE
    ,pt_i_MigrationSetName          IN      xxmx_migration_headers.migration_set_name%TYPE ) ;

  PROCEDURE export_location_details_tl_70
    (p_bg_name                      IN      varchar2
    ,p_bg_id                        in      number
    ,pt_i_MigrationSetID            IN      xxmx_migration_headers.migration_set_id%TYPE
    ,pt_i_MigrationSetName          IN      xxmx_migration_headers.migration_set_name%TYPE ) ;

  PROCEDURE export_lookups;

  FUNCTION get_target_lookup_code
    (p_src_lookup_code IN varchar2) RETURN varchar2;

  PROCEDURE purge
    (pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE ) ;

END xxmx_kit_location_stg;

/
