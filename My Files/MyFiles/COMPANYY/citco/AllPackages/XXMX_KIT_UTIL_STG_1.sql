--------------------------------------------------------
--  DDL for Package Body XXMX_KIT_UTIL_STG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "XXMX_CORE"."XXMX_KIT_UTIL_STG" AS

		--
		--//================================================================================
		--// Version1
		--// $Id:$
		--//================================================================================
		--// Object Name        :: xxmx_kit_util_stg
		--//
		--// Object Type        :: Package Body
		--//
		--// Object Description :: This package contains procedures for extracting HCM
		--//                       Data from EBS.This Packages calls all HCM Code
		--//
		--//
		--// Version Control
		--//================================================================================
		--// Version      Author               Date               Description
		--//--------------------------------------------------------------------------------
		--// 1.1         Pallavi                26/05/2020         Initial Build
		--//================================================================================
		--
		--
     --

    gvv_ReturnStatus                            VARCHAR2(1);
    gvv_ProgressIndicator                       VARCHAR2(100);
    gvn_RowCount                                NUMBER;
    gvt_ReturnMessage                           xxmx_module_messages .module_message%TYPE;
    gvt_MigrationSetName                        XXMX_MIGRATION_HEADERS.MIGRATION_SET_NAME%TYPE;
    gvt_Severity                                xxmx_module_messages .severity%TYPE;
    gvt_OracleError                             xxmx_module_messages .oracle_error%TYPE;
    gvt_ModuleMessage                           xxmx_module_messages .module_message%TYPE;

    --
    /*
    **********************
    ** Global Declarations
    **********************
    */
    --
    /* Maximise Integration Globals */
    --
    /* Global Constants for use in all xxmx_utilities_pkg Procedure/Function Calls within this package */
    --
    gcv_PackageName                           CONSTANT VARCHAR2(30)                                := 'xxmx_kit_util_stg';
    gct_ApplicationSuite                      CONSTANT xxmx_module_messages.application_suite%TYPE := 'HCM';
    gct_Application                           CONSTANT xxmx_module_messages.application%TYPE       := 'HR';
    gv_i_BusinessEntity                       CONSTANT VARCHAR2(100) := 'ALL';



    e_ModuleError                 EXCEPTION;

    g_set_code VARCHAR2(1000) DEFAULT 'COMMON';

    g_legal_employer_name VARCHAR2(1000) DEFAULT 'Moon Corporation DL';

        g_business_name VARCHAR2(1000) DEFAULT 'Moon Corp Letd BU';

    /* Talent management */

    g_memb_cnt_typ VARCHAR2(1000) DEFAULT 'MEMBERSHIP';

    g_ed_lvl_cnt_typ VARCHAR2(1000) DEFAULT 'EDUCATION_LEVEL';

    g_lang_cnt_typ VARCHAR2(1000) DEFAULT 'LANGUAGE';

    g_deg_cnt_typ VARCHAR2(1000) DEFAULT 'DEGREE';

    g_hon_cnt_typ VARCHAR2(1000) DEFAULT 'DEGREE';

    g_cert_cnt_typ VARCHAR2(1000) DEFAULT 'CERTIFICATION';

    g_perf_rat_cnt_typ VARCHAR2(1000) DEFAULT 'PERFORMANCE_RATING';

    g_cmp_cnt_typ VARCHAR2(1000) DEFAULT 'COMPETENCY';

    g_goal_cnt_typ VARCHAR2(1000) DEFAULT 'GOAL';

    /* Person types */

    g_qualifier VARCHAR2(1000) DEFAULT 'PR';

    g_comp_qualifier VARCHAR2(1000) DEFAULT 'R';

    g_comp_qualifier_set_code VARCHAR2(1000) DEFAULT 'EVAL_TYPE';

    g_per_type_emp VARCHAR2(1000) DEFAULT 'Employee';

    g_per_type_cwk VARCHAR2(1000) DEFAULT 'Contingent Worker';

    /* Assignment status types */

    g_astat_active_np VARCHAR2(1000) DEFAULT 'ACTIVE_NO_PROCESS';

    g_astat_active_p VARCHAR2(1000) DEFAULT 'ACTIVE_PROCESS';

    g_astat_inactive_np VARCHAR2(1000) DEFAULT 'INACTIVE_NO_PROCESS';

    g_astat_inactive_p VARCHAR2(1000) DEFAULT 'INACTIVE_PROCESS';

    g_astat_suspend_np VARCHAR2(1000) DEFAULT 'SUSPEND_NO_PROCESS';

    g_astat_suspend_p VARCHAR2(1000) DEFAULT 'SUSPEND_PROCESS';

    /*profile types */

    g_per_prof_typ VARCHAR2(1000) DEFAULT 'PERSON';
    g_org_prof_typ VARCHAR2(1000) DEFAULT 'ORGANIZATION';
    g_job_prof_typ VARCHAR2(1000) DEFAULT 'JOB';
    g_pos_prof_typ VARCHAR2(1000) DEFAULT 'POSITION';

    /* profile relations */

    g_pos_prof_reln VARCHAR2(1000) DEFAULT 'POSITION';
    g_org_prof_reln VARCHAR2(1000) DEFAULT 'ORGANIZATION';
    g_job_prof_reln VARCHAR2(1000) DEFAULT 'JOB';

    g_legislation_code VARCHAR2(1000) DEFAULT  'US';

    TYPE g_lkp_map_typ IS RECORD (ebs_lookup_type     VARCHAR2(200)
                                ,ebs_lookup_code     VARCHAR2(200)
                                ,fusion_lookup_code  VARCHAR2(200));

    TYPE g_lkp_map_table IS TABLE OF g_lkp_map_typ INDEX BY pls_integer;

    g_lkp_map g_lkp_map_table;

    g_org_type_map g_lkp_map_table;

    g_loc_type_map g_lkp_map_table;

    g_pos_lkp_map g_lkp_map_table;

    g_per_lkp_map g_lkp_map_table;

    g_perf_rat_lvl_map g_lkp_map_table;

    g_wrk_lkp_map g_lkp_map_table;

    g_talent_lkp_map g_lkp_map_table;

    TYPE seed_cmp_frq_codes IS VARRAY (4) OF VARCHAR2(264);

    g_seed_cmp_frq_codes seed_cmp_frq_codes DEFAULT seed_cmp_frq_codes ('D'
                                                                        ,'H'
                                                                        ,'M'
                                                                        ,'Y');

    TYPE seed_cmp_clst_codes IS VARRAY (2) OF VARCHAR2(264);

    g_seed_cmp_clst_codes seed_cmp_clst_codes DEFAULT seed_cmp_clst_codes ('NORMAL_COMPETENCE'
                                                                        ,'UNIT_STANDARD');

    PROCEDURE Update_Procedure
	IS
	BEGIN

		--Changing all Person_id Column from '16167_PERSON' to 16167 only

		UPDATE xxmx_per_pos_wr_stg
		SET person_id = SUBSTR(person_id,1,instr(person_id,'_')-1)
        WHERE person_id IN ( SELECT  person_id
                          FROM xxmx_per_pos_wr_stg
                          WHERE person_id like '%PERSON%');

		UPDATE xxmx_per_asg_sup_f_stg
		SET person_id = SUBSTR(person_id,1,instr(person_id,'_')-1)
        WHERE person_id IN ( SELECT  person_id
                          FROM xxmx_per_asg_sup_f_stg
                          WHERE person_id like '%PERSON%');


		UPDATE xxmx_per_assignments_m_stg
		SET person_id = SUBSTR(person_id,1,instr(person_id,'_')-1)
        WHERE person_id IN ( SELECT  person_id
                          FROM xxmx_per_assignments_m_stg
                          WHERE person_id like '%PERSON%');

			--Changing all Person_id Column from '16167_PERSON' to 16167 only

		UPDATE xxmx_per_people_f_stg
		 SET person_id = SUBSTR(person_id,1,instr(person_id,'_')-1)
        WHERE person_id IN ( SELECT  person_id
                          FROM xxmx_per_people_f_stg
                          WHERE person_id like '%PERSON%');


		UPDATE xxmx_per_leg_f_stg
		SET person_id = SUBSTR(person_id,1,instr(person_id,'_')-1)
        WHERE person_id IN ( SELECT  person_id
                          FROM xxmx_per_leg_f_stg
                          WHERE person_id like '%PERSON%');


		UPDATE xxmx_per_contacts_stg
		SET person_id = SUBSTR(person_id,1,instr(person_id,'_')-1)
        WHERE person_id IN ( SELECT  person_id
                          FROM xxmx_per_contacts_stg
                          WHERE person_id like '%PERSON%');



		UPDATE xxmx_per_phones_stg
		SET person_id = SUBSTR(person_id,1,instr(person_id,'_')-1)
        WHERE person_id IN ( SELECT  person_id
                          FROM xxmx_per_phones_stg
                          WHERE person_id like '%PERSON%');


		UPDATE xxmx_per_nid_f_stg
		SET person_id = SUBSTR(person_id,1,instr(person_id,'_')-1)
        WHERE person_id IN ( SELECT  person_id
                          FROM xxmx_per_nid_f_stg
                          WHERE person_id like '%PERSON%');

		UPDATE XXMX_PER_PERSONS_STG
		SET person_id = SUBSTR(person_id,1,instr(person_id,'_')-1)
        WHERE person_id IN ( SELECT  person_id
                          FROM XXMX_PER_PERSONS_STG
                          WHERE person_id like '%PERSON%');

        COMMIT;

	END;


  function get_set_code return VARCHAR2 as
  begin
    return g_set_code;
  end get_set_code;

  function get_legal_employer_name return VARCHAR2 as
  begin
    return g_legal_employer_name;
  end get_legal_employer_name;

  function get_memb_cnt_typ return VARCHAR2 as
  begin
    return g_memb_cnt_typ;
  end get_memb_cnt_typ;

  function get_edulvl_cnt_typ return VARCHAR2 as
  begin
    return g_ed_lvl_cnt_typ;
  end get_edulvl_cnt_typ;

  function get_lang_cnt_typ return VARCHAR2 as
  begin
    return g_lang_cnt_typ;
  end get_lang_cnt_typ;

  function get_deg_cnt_typ return VARCHAR2 as
  begin
    return g_deg_cnt_typ;
  end get_deg_cnt_typ;

  function get_hon_cnt_typ return VARCHAR2 as
  begin
    return g_hon_cnt_typ;
  end get_hon_cnt_typ;

  function get_cert_cnt_typ return VARCHAR2 as
  begin
    return g_cert_cnt_typ;
  end get_cert_cnt_typ;

  function get_perf_rat_cnt_typ return VARCHAR2 as
  begin
    return g_perf_rat_cnt_typ;
  end get_perf_rat_cnt_typ;

  function get_per_prof_typ return VARCHAR2 as
  begin
    return g_per_prof_typ;
  end get_per_prof_typ;

  function get_cmp_cnt_typ return VARCHAR2 as
  begin
    return g_cmp_cnt_typ;
  end get_cmp_cnt_typ;

  function get_qualifier return VARCHAR2 as
  begin
    return g_qualifier;
  end get_qualifier;

  function get_comp_qualifier return VARCHAR2 as
  begin
    return g_comp_qualifier;
  end get_comp_qualifier;

  function get_comp_qualifier_set return VARCHAR2 as
  begin
    return g_comp_qualifier_set_code;
  end get_comp_qualifier_set;






  function get_goal_type return VARCHAR2 as
  begin
    return g_goal_cnt_typ;
  end get_goal_type;


/* Person types */

  function get_per_emp_type return VARCHAR2 as
  begin
    return g_per_type_emp;
  end get_per_emp_type;

  function get_per_cwk_type return VARCHAR2 as
  begin
    return g_per_type_cwk;
  end get_per_cwk_type;


  procedure set_per_emp_type ( p_per_type_emp in VARCHAR2 ) as
  begin
    g_per_type_emp := p_per_type_emp;
  end set_per_emp_type;

  procedure set_per_cwk_type ( p_per_type_cwk in VARCHAR2 ) as
  begin
    g_per_type_cwk := p_per_type_cwk;
  end set_per_cwk_type;


/* Assignment status types */

  function get_astat_active_nopay return VARCHAR2 as
  begin
    return g_astat_active_np;
  end get_astat_active_nopay;

  function get_astat_active_pay return VARCHAR2 as
  begin
    return g_astat_active_p;
  end get_astat_active_pay;

  function get_astat_inactive_nopay return VARCHAR2 as
  begin
    return g_astat_inactive_np;
  end get_astat_inactive_nopay;

  function get_astat_inactive_pay return VARCHAR2 as
  begin
    return g_astat_inactive_p;
  end get_astat_inactive_pay;

  function get_astat_suspend_nopay return VARCHAR2 as
  begin
    return g_astat_suspend_np;
  end get_astat_suspend_nopay;

  function get_astat_suspend_pay return VARCHAR2 as
  begin
    return g_astat_suspend_p;
  end get_astat_suspend_pay;

  procedure set_astat_active_nopay ( p_astat_active_np in VARCHAR2 ) as
  begin
    g_astat_active_np := p_astat_active_np;
  end set_astat_active_nopay;

  procedure set_astat_active_pay ( p_astat_active_p in VARCHAR2 ) as
  begin
    g_astat_active_p := p_astat_active_p;
  end set_astat_active_pay;

  procedure set_astat_inactive_nopay ( p_astat_inactive_np in VARCHAR2 ) as
  begin
    g_astat_inactive_np := p_astat_inactive_np;
  end set_astat_inactive_nopay;

  procedure set_astat_inactive_pay ( p_astat_inactive_p in VARCHAR2 ) as
  begin
    g_astat_inactive_p := p_astat_inactive_p;
  end set_astat_inactive_pay;

  procedure set_astat_suspend_nopay ( p_astat_suspend_np in VARCHAR2 ) as
  begin
    g_astat_suspend_np := p_astat_suspend_np;
  end set_astat_suspend_nopay;

  procedure set_astat_suspend_pay ( p_astat_suspend_p in VARCHAR2 ) as
  begin
    g_astat_suspend_p := p_astat_suspend_p;
  end set_astat_suspend_pay;

/* setters */

  function get_business_name return VARCHAR2 as
  begin
    return g_business_name;
  end get_business_name;


  procedure set_business_name ( p_business_name in VARCHAR2 ) as
  begin
    g_business_name := p_business_name;
  end set_business_name;


  procedure set_set_code ( p_set_code in VARCHAR2 ) as
  begin
    g_set_code := p_set_code;
  end set_set_code;

  procedure set_legal_employer_name ( p_legal_employer_name in VARCHAR2 ) as
  begin
    g_legal_employer_name := p_legal_employer_name;
  end set_legal_employer_name;

  procedure set_memb_cnt_typ ( p_memb_cnt_typ in VARCHAR2 ) as
  begin
    g_memb_cnt_typ := p_memb_cnt_typ;
  end set_memb_cnt_typ;

  procedure set_edulvl_cnt_typ ( p_ed_lvl_cnt_typ in VARCHAR2 ) as
  begin
    g_ed_lvl_cnt_typ := p_ed_lvl_cnt_typ;
  end set_edulvl_cnt_typ;

  procedure set_lang_cnt_typ ( p_lang_cnt_typ in VARCHAR2 ) as
  begin
    g_lang_cnt_typ := p_lang_cnt_typ;
  end set_lang_cnt_typ;

  procedure set_deg_cnt_typ ( p_deg_cnt_typ in VARCHAR2 ) as
  begin
    g_deg_cnt_typ := p_deg_cnt_typ;
  end set_deg_cnt_typ;

  procedure set_hon_cnt_typ ( p_hon_cnt_typ in VARCHAR2 ) as
  begin
    g_hon_cnt_typ := p_hon_cnt_typ;
  end set_hon_cnt_typ;

  procedure set_cert_cnt_typ ( p_cert_cnt_typ in VARCHAR2 ) as
  begin
    g_cert_cnt_typ := p_cert_cnt_typ;
  end set_cert_cnt_typ;

  procedure set_perf_rat_cnt_typ ( p_perf_rat_cnt_typ in VARCHAR2 ) as
  begin
    g_perf_rat_cnt_typ := p_perf_rat_cnt_typ;
  end set_perf_rat_cnt_typ;

  procedure set_per_prof_typ ( p_per_prof_typ in VARCHAR2 ) as
  begin
    g_per_prof_typ := p_per_prof_typ;
  end set_per_prof_typ;

  procedure set_cmp_cnt_typ ( p_cmp_cnt_typ in VARCHAR2 ) as
  begin
    g_cmp_cnt_typ := p_cmp_cnt_typ;
  end set_cmp_cnt_typ;

  procedure set_qualifier ( p_qualifier in VARCHAR2 ) as
  begin
    g_qualifier := p_qualifier;
  end set_qualifier;

  procedure set_goal_typ ( p_goal_cnt_typ in VARCHAR2 ) as
  begin
    g_goal_cnt_typ := p_goal_cnt_typ;
  end set_goal_typ;


  function get_org_prof_typ return VARCHAR2 as
  begin
    return g_org_prof_typ;
  end get_org_prof_typ;

  function get_org_prof_reln return VARCHAR2 as
  begin
    return g_org_prof_reln;
  end get_org_prof_reln;


  function get_job_prof_typ return VARCHAR2 as
  begin
    return g_job_prof_typ;
  end get_job_prof_typ;

  function get_job_prof_reln return VARCHAR2 as
  begin
    return g_job_prof_reln;
  end get_job_prof_reln;

  function get_pos_prof_typ return VARCHAR2 as
  begin
    return g_pos_prof_typ;
  end get_pos_prof_typ;

  function get_pos_prof_reln return VARCHAR2 as
  begin
    return g_pos_prof_reln;
  end get_pos_prof_reln;

/* setters */

  procedure  set_org_prof_typ ( p_org_prof_typ in VARCHAR2 ) as
  begin
    g_org_prof_typ := p_org_prof_typ;
  end set_org_prof_typ;

  procedure set_org_prof_reln ( p_org_prof_reln in VARCHAR2 ) as
  begin
    g_org_prof_reln := p_org_prof_reln;
  end set_org_prof_reln;

  procedure  set_job_prof_typ ( p_job_prof_typ in VARCHAR2 ) as
  begin
    g_job_prof_typ := p_job_prof_typ;
  end set_job_prof_typ;

  procedure set_job_prof_reln ( p_job_prof_reln in VARCHAR2 ) as
  begin
    g_job_prof_reln := p_job_prof_reln;
  end set_job_prof_reln;

  procedure  set_pos_prof_typ ( p_pos_prof_typ in VARCHAR2 ) as
  begin
    g_pos_prof_typ := p_pos_prof_typ;
  end set_pos_prof_typ;

  procedure set_pos_prof_reln ( p_pos_prof_reln in VARCHAR2 ) as
  begin
    g_pos_prof_reln := p_pos_prof_reln;
  end set_pos_prof_reln;

 function get_legislation_code(p_business_id NUMBER)
 return VARCHAR2 as
	l_leg_code VARCHAR2(100);
  begin
		BEGIN
			SELECT  legislation_code INTO l_leg_code
			FROM    per_business_groups@MXDM_NVIS_EXTRACT
			where   business_group_id = p_business_id;
		exception
		when no_data_found then
			l_leg_code := NULL;
		end;

    return l_leg_code;
  end get_legislation_code;

/* setters */

  procedure  set_legislation_code ( p_legislation_code in VARCHAR2 ) as
  begin
    g_legislation_code := p_legislation_code;
  end set_legislation_code;

   PROCEDURE export_lookups IS
     CURSOR c1 IS
       SELECT  'ORG_TYPE' ebs_lookup_type
              ,lookup_code ebs_lookup_code
              ,lookup_code target_lookup_code
       FROM    fnd_lookup_values_vl@MXDM_NVIS_EXTRACT flv
       WHERE   lookup_type = 'ORG_TYPE'
       AND     view_application_id = 3;

     CURSOR c2 IS
       SELECT  'TERRITORY_CODE' ebs_lookup_type
              ,territory_code ebs_lookup_code
              ,territory_code target_lookup_code
       FROM    fnd_territories@MXDM_NVIS_EXTRACT;
     v_cnt NUMBER DEFAULT 0;
   BEGIN
     FOR v_cur IN c1 LOOP
       v_cnt := v_cnt + 1;

       g_org_type_map (v_cnt).ebs_lookup_type := v_cur.ebs_lookup_type;

       g_org_type_map (v_cnt).ebs_lookup_code := v_cur.ebs_lookup_code;

       g_org_type_map (v_cnt).fusion_lookup_code := v_cur.target_lookup_code;
     END LOOP;

     FOR v_cur IN c2 LOOP
       v_cnt := v_cnt + 1;

       g_loc_type_map (v_cnt).ebs_lookup_type := v_cur.ebs_lookup_type;

       g_loc_type_map (v_cnt).ebs_lookup_code := v_cur.ebs_lookup_code;

       g_loc_type_map (v_cnt).fusion_lookup_code := v_cur.target_lookup_code;
     END LOOP;
   END export_lookups;

   FUNCTION get_target_lookup_code
     (p_entity_name     IN VARCHAR2
     ,p_src_lkp_typ     IN VARCHAR2
     ,p_src_lookup_code IN VARCHAR2) RETURN VARCHAR2 IS
     v_ret VARCHAR2(200);
   BEGIN
     IF p_entity_name = 'LOCATION' THEN
       g_lkp_map := g_loc_type_map;
     ELSIF p_entity_name = 'ORGANIZATION' THEN
       g_lkp_map := g_org_type_map;
     ELSIF p_entity_name = 'POSITION' THEN
       g_lkp_map := g_pos_lkp_map;
     ELSIF p_entity_name = 'PERSON' THEN
       g_lkp_map := g_per_lkp_map;
     ELSIF p_entity_name = 'WORKER' THEN
       g_lkp_map := g_wrk_lkp_map;
     ELSIF p_entity_name = 'TALENT' THEN
       g_lkp_map := g_talent_lkp_map;
     ELSIF p_entity_name = 'PERFORMANCE' THEN
       g_lkp_map := g_perf_rat_lvl_map;
     ELSE
       RETURN v_ret;
     END IF;

     IF g_lkp_map IS NULL THEN
       RETURN v_ret;
     END IF;

     IF g_lkp_map.count = 0 THEN
       RETURN v_ret;
     END IF;

     FOR i IN g_lkp_map.first .. g_lkp_map.last LOOP
       IF g_lkp_map (i).ebs_lookup_type = p_src_lkp_typ  and g_lkp_map (i).ebs_lookup_code = p_src_lookup_code THEN
         v_ret := g_lkp_map (i).fusion_lookup_code;
       END IF;
     END LOOP;

     RETURN v_ret;
   END get_target_lookup_code;


    --*******************
    --** PROCEDURE: purge
    --*******************
    --
    /*PROCEDURE purge
                    (
                    pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    )
    IS
        --
        --
        cv_ProcOrFuncName                   CONSTANT      VARCHAR2(30) := 'purge';
        ct_Phase                            CONSTANT      xxmx_module_messages.phase%TYPE  := 'CORE';
        cv_i_BusinessEntityLevel            CONSTANT      VARCHAR2(100) DEFAULT 'PERSON PURGE';
        --
        e_ModuleError                   EXCEPTION;
        --

    BEGIN
        --
        --
        gvv_ProgressIndicator := '0010';
        --
        --
        gvv_ReturnStatus  := '';
        gvt_ReturnMessage := '';
        --
        --
        xxmx_utilities_pkg.clear_messages
            (
            pt_i_ApplicationSuite     => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_Phase               => ct_Phase
            ,pt_i_MessageType         => 'MODULE'
            ,pv_o_ReturnStatus        => gvv_ReturnStatus
            );
        --
        --
        IF   gvv_ReturnStatus = 'F'
        THEN
                --
                --
                xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                    ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_Severity            => 'ERROR'
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => '- Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
                    ,pt_i_OracleError         => gvt_ReturnMessage
                    );
                --
                --
                RAISE e_ModuleError;
                --
                --
        END IF;
        --
        --
        gvv_ProgressIndicator := '0020';
        --
        --
        xxmx_utilities_pkg.log_module_message
            (pt_i_ApplicationSuite    => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_Phase               => ct_Phase
            ,pt_i_Severity            => 'NOTIFICATION'
            ,pt_i_PackageName         => gcv_PackageName
            ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
            ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
            ,pt_i_ModuleMessage       => 'Procedure "'
                                        ||gcv_PackageName
                                        ||'.'
                                        ||cv_ProcOrFuncName
                                        ||'" initiated.'
            ,pt_i_OracleError         => NULL
            );
        --
        --
        IF   pt_i_MigrationSetID IS NULL
        THEN
                --
                --
                gvt_Severity      := 'ERROR';
                gvt_ModuleMessage := '- "pt_i_MigrationSetID" parameter is mandatory.';
                --
                --
                RAISE e_ModuleError;
                --
                --
        END IF;
        --
        --
        gvv_ProgressIndicator := '0020';
        xxmx_utilities_pkg.log_module_message
            (pt_i_ApplicationSuite    => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_Phase               => ct_Phase
            ,pt_i_Severity            => 'NOTIFICATION'
            ,pt_i_PackageName         => gcv_PackageName
            ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
            ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
            ,pt_i_ModuleMessage       => 'Execute grade purge'
            ,pt_i_OracleError         => NULL
            );
        --
        xxmx_kit_grade_stg.purge (pt_i_MigrationSetID );
        --
        --
        gvv_ProgressIndicator := '0020';
        xxmx_utilities_pkg.log_module_message
            (pt_i_ApplicationSuite    => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_Phase               => ct_Phase
            ,pt_i_Severity            => 'NOTIFICATION'
            ,pt_i_PackageName         => gcv_PackageName
            ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
            ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
            ,pt_i_ModuleMessage       => 'Execute job purge'
            ,pt_i_OracleError         => NULL
            );
        --
        xxmx_kit_job_stg.purge (pt_i_MigrationSetID );
        --
        --
        gvv_ProgressIndicator := '0020';
        xxmx_utilities_pkg.log_module_message
            (pt_i_ApplicationSuite    => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_Phase               => ct_Phase
            ,pt_i_Severity            => 'NOTIFICATION'
            ,pt_i_PackageName         => gcv_PackageName
            ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
            ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
            ,pt_i_ModuleMessage       => 'Execute location purge'
            ,pt_i_OracleError         => NULL
            );
        --
        xxmx_kit_location_stg.purge (pt_i_MigrationSetID );
        --
        --
        gvv_ProgressIndicator := '0020';
        xxmx_utilities_pkg.log_module_message
            (pt_i_ApplicationSuite    => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_Phase               => ct_Phase
            ,pt_i_Severity            => 'NOTIFICATION'
            ,pt_i_PackageName         => gcv_PackageName
            ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
            ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
            ,pt_i_ModuleMessage       => 'Execute kit purge'
            ,pt_i_OracleError         => NULL
            );
        --
        xxmx_kit_org_stg.purge (pt_i_MigrationSetID );
        --
        --
        gvv_ProgressIndicator := '0020';
        xxmx_utilities_pkg.log_module_message
            (pt_i_ApplicationSuite    => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_Phase               => ct_Phase
            ,pt_i_Severity            => 'NOTIFICATION'
            ,pt_i_PackageName         => gcv_PackageName
            ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
            ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
            ,pt_i_ModuleMessage       => 'Execute person purge'
            ,pt_i_OracleError         => NULL
            );
        --
        xxmx_kit_person_stg.purge (pt_i_MigrationSetID );
        --
        --
        gvv_ProgressIndicator := '0020';
        xxmx_utilities_pkg.log_module_message
            (pt_i_ApplicationSuite    => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_Phase               => ct_Phase
            ,pt_i_Severity            => 'NOTIFICATION'
            ,pt_i_PackageName         => gcv_PackageName
            ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
            ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
            ,pt_i_ModuleMessage       => 'Execute postion purge'
            ,pt_i_OracleError         => NULL
            );
        --
        xxmx_kit_position_stg.purge (pt_i_MigrationSetID );
        --
        --
        gvv_ProgressIndicator := '0020';
        xxmx_utilities_pkg.log_module_message
            (pt_i_ApplicationSuite    => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_Phase               => ct_Phase
            ,pt_i_Severity            => 'NOTIFICATION'
            ,pt_i_PackageName         => gcv_PackageName
            ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
            ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
            ,pt_i_ModuleMessage       => 'Execute talent purge'
            ,pt_i_OracleError         => NULL
            );
        --
        xxmx_kit_talent_stg.purge (pt_i_MigrationSetID );
         --
        --
        gvv_ProgressIndicator := '0020';
        xxmx_utilities_pkg.log_module_message
            (pt_i_ApplicationSuite    => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_Phase               => ct_Phase
            ,pt_i_Severity            => 'NOTIFICATION'
            ,pt_i_PackageName         => gcv_PackageName
            ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
            ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
            ,pt_i_ModuleMessage       => 'Execute worker purge'
            ,pt_i_OracleError         => NULL
            );
        --
        xxmx_kit_worker_stg.purge (pt_i_MigrationSetID );
        --
        COMMIT;
        --
        --
        xxmx_utilities_pkg.log_module_message
                 (pt_i_ApplicationSuite    => gct_ApplicationSuite
                ,pt_i_Application         => gct_Application
                ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                ,pt_i_Phase               => ct_Phase
                ,pt_i_Severity            => 'NOTIFICATION'
                ,pt_i_PackageName         => gcv_PackageName
                ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                ,pt_i_ModuleMessage       => 'Procedure "'
                                        ||gcv_PackageName
                                        ||'.'
                                        ||cv_ProcOrFuncName
                                        ||'" completed.'
                ,pt_i_OracleError         => NULL
                );
        --
        --
        EXCEPTION
                --
                --
                WHEN OTHERS
                THEN
                    --
                    --
                    ROLLBACK;
                    --
                    --
                    gvt_OracleError := SUBSTR(
                                            SQLERRM
                                            ||'** ERROR_BACKTRACE: '
                                            ||dbms_utility.format_error_backtrace
                                            ,1
                                            ,4000
                                            );
                    --
                    --
                    xxmx_utilities_pkg.log_module_message
                        (pt_i_ApplicationSuite    => gct_ApplicationSuite
                        ,pt_i_Application         => gct_Application
                        ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                        ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                        ,pt_i_Phase               => ct_Phase
                        ,pt_i_Severity            => 'ERROR'
                        ,pt_i_PackageName         => gcv_PackageName
                        ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                        ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                        ,pt_i_ModuleMessage       => 'Oracle error encounted at after Progress Indicator.'
                        ,pt_i_OracleError         => gvt_OracleError
                        );
                    --
                    --
                    RAISE;
                    --
                    --
                --** END OTHERS Exception
                --
                --
        --** END Exception Handler
        --
        --
    END purge;
*/
    procedure run_extract
        (  pt_i_ClientCode                 IN      xxmx_client_config_parameters.client_code%TYPE
          ,pt_i_MigrationSetName           IN      xxmx_migration_headers.migration_set_name%TYPE )
    IS
        l_leg_code VARCHAR2(1000);
        l_bg_name VARCHAR2(1000);
        l_bg_id NUMBER;

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'run_extract';
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT '';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'RUN EXTRACT';

        vt_MigrationSetID                           xxmx_migration_headers.migration_set_id%TYPE;
        pt_i_MigrationSetID                         xxmx_migration_headers.migration_set_id%TYPE;
        vt_BusinessEntitySeq                            xxmx_migration_metadata.business_entity_seq%TYPE;

        lv_sql 								VARCHAR2(32000);

        CURSOR c_business_groups
        IS
            SELECT DISTINCT
                    haou.organization_id,
                    haou.name
            FROM    apps.hr_all_organization_units@MXDM_NVIS_EXTRACT    haou
                  ,apps.hr_organization_information@MXDM_NVIS_EXTRACT  hoi
           WHERE   1 = 1
           AND     hoi.organization_id   = haou.organization_id
           AND     hoi.org_information1  = 'HR_BG'
           AND     haou.name            IN (
                                            SELECT xp.parameter_value
                                            FROM   xxmx_migration_parameters  xp
                                            WHERE  1 = 1
                                            AND    xp.application_suite      = 'HCM'
                                            AND    xp.application            = 'HR'
                                            AND    xp.business_entity        = 'ALL'
                                            AND    xp.sub_entity             = 'ALL'
                                            AND    xp.parameter_code         = 'BUSINESS_GROUP_NAME'
                                            AND    NVL(xp.enabled_flag, 'N') = 'Y'
                        		)
                ;
		CURSOR c_package_name
		IS
			/*SELECT distinct (entity_package_name||'.export') v_package,file_group_number
			FROM     xxmx_migration_metadata a
			WHERE application_suite = 'HCM'
			--AND exp_procedure_name = 'export'
			AND Business_Entity IN ('LOCATION',
                                'GRADE',
                                'POSITION',
                                'JOB',
                                'TALENT',
								'ORGANIZATION',
                                'WORKER')
			AND a.enabled_flag = 'Y'
			and UPPER(entity_package_name) NOT LIKE '%HDL%'
            and file_group_number is not null
            order by file_group_number;*/

            SELECT  distinct (entity_package_name||'.export') v_package,file_group_number
			FROM     xxmx_migration_metadata a
			WHERE application_suite = 'HCM'
            AND Application = 'HR'
			--AND exp_procedure_name = ''
			AND a.enabled_flag = 'Y'
			and BUSINESS_ENTITY NOT IN 'PROFILE'
			AND FILE_GEN_PROCEDURE_NAME is NULL
            order by file_group_number;


    BEGIN
        -- setup
        --
        gvv_ReturnStatus  := '';
        gvv_ProgressIndicator := '0000';
        xxmx_utilities_pkg.clear_messages
            (
            pt_i_ApplicationSuite     => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_Phase               => ct_Phase
            ,pt_i_MessageType         => 'MODULE'
            ,pv_o_ReturnStatus        => gvv_ReturnStatus
            );
        --
        IF   gvv_ReturnStatus = 'F'
        THEN
            --
            xxmx_utilities_pkg.log_module_message(
                    pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                    ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_Severity            => 'ERROR'
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => 'Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
                ,pt_i_OracleError         => gvt_ReturnMessage
                );
            --
            RAISE e_ModuleError;
            --
        END IF;
        --
        --
        gvv_ProgressIndicator := '0010';
        xxmx_utilities_pkg.init_migration_set
            (
            pt_i_ApplicationSuite  => gct_ApplicationSuite
            ,pt_i_Application       => gct_Application
            ,pt_i_BusinessEntity    => gv_i_BusinessEntity
            ,pt_i_MigrationSetName  => pt_i_MigrationSetName
            ,pt_o_MigrationSetID    => vt_MigrationSetID
            );

         --
        xxmx_utilities_pkg.log_module_message(
                        pt_i_ApplicationSuite    => gct_ApplicationSuite
                        ,pt_i_Application         => gct_Application
                        ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                        ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                        ,pt_i_Phase               => ct_Phase
                        ,pt_i_Severity            => 'NOTIFICATION'
                        ,pt_i_PackageName         => gcv_PackageName
                        ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                        ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                        ,pt_i_ModuleMessage       => 'Migration Set "'
                                    ||pt_i_MigrationSetName
                                    ||'" initialized (Generated Migration Set ID = '
                                    ||vt_MigrationSetID
                                    ||').  Processing extracts:'       ,
                        pt_i_OracleError         => NULL
            );
        --
        --
        --main


    FOR r_business_group IN c_business_groups
    LOOP
        --MAIN--
        BEGIN
            SELECT  legislation_code INTO l_leg_code
            FROM    per_business_groups@MXDM_NVIS_EXTRACT
            where   name = r_business_group.name;
        exception
            when no_data_found then
            l_leg_code := NULL;
        end;


        l_bg_name := r_business_group.name;
        l_bg_id := r_business_group.organization_id;
        if l_leg_code is not null then
            set_legislation_code (l_leg_code);
        end if;

        if l_bg_name is not null then
			FOR r_package_name IN c_package_name
			LOOP

				dbms_output.put_line(' #' ||r_package_name.v_package ||' #'|| l_bg_name || '  #' || l_bg_id || '  #' || vt_MigrationSetID || '  #' || pt_i_MigrationSetName  );

				lv_sql:= 'BEGIN '
                        ||r_package_name.v_package
                        ||'('||''''|| l_bg_name
						||''','
						||l_bg_id
						||','
						||vt_MigrationSetID
						||','''
						||pt_i_MigrationSetName
						||''''||'); END;'
						;

				DBMS_OUTPUT.PUT_LINE(lv_sql);

				execute immediate lv_sql;

				/*xxmx_kit_location_stg.export                     (l_bg_name, l_bg_id, vt_MigrationSetID, pt_i_MigrationSetName );
				xxmx_kit_org_stg.export                          (l_bg_name, l_bg_id, vt_MigrationSetID, pt_i_MigrationSetName );
				xxmx_kit_job_stg.export                          (l_bg_name, l_bg_id, vt_MigrationSetID, pt_i_MigrationSetName );
				xxmx_kit_position_stg.export                     (l_bg_name, l_bg_id, vt_MigrationSetID, pt_i_MigrationSetName );
				xxmx_kit_grade_stg.export                        (l_bg_name, l_bg_id, vt_MigrationSetID, pt_i_MigrationSetName );
				xxmx_kit_talent_stg.export                       (l_bg_name, l_bg_id, vt_MigrationSetID, pt_i_MigrationSetName );
				xxmx_kit_person_stg.export                       (l_bg_name, l_bg_id, vt_MigrationSetID, pt_i_MigrationSetName );
				xxmx_kit_worker_stg.export                       (l_bg_name, l_bg_id, vt_MigrationSetID, pt_i_MigrationSetName );
				xxmx_kit_person_stg.perf_rating_model_setup      (l_bg_name, l_bg_id, vt_MigrationSetID, pt_i_MigrationSetName );
				xxmx_kit_job_stg.export_profiles_job             (l_bg_name, l_bg_id, vt_MigrationSetID, pt_i_MigrationSetName );
				xxmx_kit_position_stg.export_profiles_position   (l_bg_name, l_bg_id, vt_MigrationSetID, pt_i_MigrationSetName );
				xxmx_kit_org_stg.export_profiles_org             (l_bg_name, l_bg_id, vt_MigrationSetID, pt_i_MigrationSetName );
				xxmx_kit_person_stg.export_profiles_person       (l_bg_name, l_bg_id, vt_MigrationSetID, pt_i_MigrationSetName );*/
			END LOOP;
        else
             dbms_output.put_line('Business Group with the given short name does not exist.');
            --NULL;
        end if;
    END LOOP;

	gvv_ProgressIndicator := '0020';
	  xxmx_utilities_pkg.log_module_message(
                        pt_i_ApplicationSuite    => gct_ApplicationSuite
                        ,pt_i_Application         => gct_Application
                        ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                        ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                        ,pt_i_Phase               => ct_Phase
                        ,pt_i_Severity            => 'NOTIFICATION'
                        ,pt_i_PackageName         => gcv_PackageName
                        ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                        ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                        ,pt_i_ModuleMessage       => '- Calling Procedure "' ||gcv_PackageName ||'.Update_Procedure;".'
                        ,pt_i_OracleError         => NULL   );
		--
		--
	Update_Procedure;

	--
    EXCEPTION
        WHEN OTHERS THEN

            --
            --
            ROLLBACK;
            --
            --
            gvt_OracleError := SUBSTR(
                                    SQLERRM
                                    ||'** ERROR_BACKTRACE: '
                                    ||dbms_utility.format_error_backtrace
                                    ,1
                                    ,4000
                                    );
            --
            xxmx_utilities_pkg.log_module_message
                (pt_i_ApplicationSuite    => gct_ApplicationSuite
                ,pt_i_Application         => gct_Application
                ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                ,pt_i_Phase               => ct_Phase
                ,pt_i_Severity            => 'ERROR'
                ,pt_i_PackageName         => gcv_PackageName
                ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                ,pt_i_ModuleMessage       => 'Oracle error encounted at after Progress Indicator.'
                ,pt_i_OracleError         => gvt_OracleError
                );
            --
            RAISE;

            -- Hr_Utility.raise_error@MXDM_NVIS_EXTRACT;
    END run_extract;

	Procedure truncate_tables (p_tablename in VARCHAR2)
	As
	lv_sql VARCHAR2(10000):= NULL;
	BEGIN
		lv_sql:= 'DELETE FROM '||p_tablename;

		EXECUTE IMMEDIATE lv_sql;
		COMMIT;

	END truncate_tables;
END xxmx_kit_util_stg;

/