--------------------------------------------------------
--  DDL for Package XXMX_KIT_UTIL_STG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "XXMX_CORE"."XXMX_KIT_UTIL_STG" AS

      --
      --
      --//================================================================================
      --// Version1
      --// $Id:$
      --//================================================================================
      --// Object Name        :: xxmx_kit_util_stg
      --//
      --// Object Type        :: Package Body
      --//
      --// Object Description :: This package contains procedures for populating HCM
      --//                        Data from EBS. This inturns Calls HCM Procedures
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

  FUNCTION get_set_code RETURN varchar2;

  FUNCTION get_legal_employer_name RETURN varchar2;

  FUNCTION get_memb_cnt_typ RETURN varchar2;

  FUNCTION get_edulvl_cnt_typ RETURN varchar2;

  FUNCTION get_lang_cnt_typ RETURN varchar2;

  FUNCTION get_deg_cnt_typ RETURN varchar2;

  FUNCTION get_hon_cnt_typ RETURN varchar2;

  FUNCTION get_cert_cnt_typ RETURN varchar2;

  FUNCTION get_perf_rat_cnt_typ RETURN varchar2;

  FUNCTION get_per_prof_typ RETURN varchar2;

  FUNCTION get_cmp_cnt_typ RETURN varchar2;

  FUNCTION get_qualifier RETURN varchar2;

  function get_comp_qualifier return VARCHAR2;

  function get_comp_qualifier_set return VARCHAR2;

  FUNCTION get_goal_type RETURN varchar2;

  PROCEDURE set_set_code
    (p_set_code IN varchar2);

  PROCEDURE set_legal_employer_name
    (p_legal_employer_name IN varchar2);

  PROCEDURE set_memb_cnt_typ
    (p_memb_cnt_typ IN varchar2);

  PROCEDURE set_edulvl_cnt_typ
    (p_ed_lvl_cnt_typ IN varchar2);

  PROCEDURE set_lang_cnt_typ
    (p_lang_cnt_typ IN varchar2);

  PROCEDURE set_deg_cnt_typ
    (p_deg_cnt_typ IN varchar2);

  PROCEDURE set_hon_cnt_typ
    (p_hon_cnt_typ IN varchar2);

  PROCEDURE set_cert_cnt_typ
    (p_cert_cnt_typ IN varchar2);

  PROCEDURE set_perf_rat_cnt_typ
    (p_perf_rat_cnt_typ IN varchar2);

  PROCEDURE set_per_prof_typ
    (p_per_prof_typ IN varchar2);

  PROCEDURE set_cmp_cnt_typ
    (p_cmp_cnt_typ IN varchar2);

  PROCEDURE set_qualifier
    (p_qualifier IN varchar2);

  PROCEDURE set_goal_typ
		(p_goal_cnt_typ IN varchar2);

  FUNCTION get_org_prof_typ RETURN varchar2;

  FUNCTION get_org_prof_reln RETURN varchar2;

  FUNCTION get_job_prof_typ RETURN varchar2;

  FUNCTION get_job_prof_reln RETURN varchar2;

  FUNCTION get_pos_prof_typ RETURN varchar2;

  FUNCTION get_pos_prof_reln RETURN varchar2;

  FUNCTION get_per_emp_type RETURN varchar2;

  FUNCTION get_per_cwk_type RETURN varchar2;

  PROCEDURE set_org_prof_typ
    (p_org_prof_typ IN varchar2);

  PROCEDURE set_org_prof_reln
    (p_org_prof_reln IN varchar2);

  PROCEDURE set_job_prof_typ
    (p_job_prof_typ IN varchar2);

  PROCEDURE set_job_prof_reln
    (p_job_prof_reln IN varchar2);

  PROCEDURE set_pos_prof_typ
    (p_pos_prof_typ IN varchar2);

  PROCEDURE set_pos_prof_reln
    (p_pos_prof_reln IN varchar2);

  PROCEDURE set_astat_active_nopay
    (p_astat_active_np IN varchar2);

  PROCEDURE set_astat_active_pay
    (p_astat_active_p IN varchar2);

  PROCEDURE set_astat_inactive_nopay
    (p_astat_inactive_np IN varchar2);

  PROCEDURE set_astat_inactive_pay
    (p_astat_inactive_p IN varchar2);

  PROCEDURE set_astat_suspend_nopay
    (p_astat_suspend_np IN varchar2);

  PROCEDURE set_astat_suspend_pay
    (p_astat_suspend_p IN varchar2);

  PROCEDURE set_per_emp_type
    (p_per_type_emp IN varchar2);

  PROCEDURE set_per_cwk_type
    (p_per_type_cwk IN varchar2);

  PROCEDURE set_business_name
    (p_business_name IN varchar2);

  PROCEDURE set_legislation_code ( p_legislation_code in varchar2 );

  FUNCTION  get_legislation_code (p_business_id NUMBER) return VARCHAR2;

  FUNCTION get_astat_active_nopay RETURN varchar2;

  FUNCTION get_astat_active_pay RETURN varchar2;

  FUNCTION get_astat_inactive_nopay RETURN varchar2;

  FUNCTION get_business_name RETURN varchar2;

  FUNCTION get_astat_inactive_pay RETURN varchar2;

  FUNCTION get_astat_suspend_nopay RETURN varchar2;

  FUNCTION get_astat_suspend_pay RETURN varchar2;

  PROCEDURE export_lookups;

  FUNCTION get_target_lookup_code
    (p_entity_name     IN varchar2
    ,p_src_lkp_typ     IN varchar2
    ,p_src_lookup_code IN varchar2) RETURN varchar2;

  PROCEDURE run_extract
    (  pt_i_ClientCode                 IN      xxmx_client_config_parameters.client_code%TYPE
      ,pt_i_MigrationSetName           IN      xxmx_migration_headers.migration_set_name%TYPE ) ;

  PROCEDURE truncate_tables( p_tablename IN VARCHAR2);

  -- PROCEDURE purge
  --   (pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE ) ;

END xxmx_kit_util_stg;

/
