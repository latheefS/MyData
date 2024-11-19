--------------------------------------------------------
--  DDL for Package Body XXMX_KIT_POSITION_STG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "XXMX_CORE"."XXMX_KIT_POSITION_STG" AS


		--
		--//================================================================================
		--// Version1
		--// $Id:$
		--//================================================================================
		--// Object Name        :: xxmx_kit_position_stg
		--//
		--// Object Type        :: Package Body
		--//
		--// Object Description :: This package contains procedures for extracting Position
		--//                       Data from EBS.
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
    gvv_cmp_cnt_typ                               VARCHAR2(1000) DEFAULT xxmx_KIT_UTIL_stg.get_cmp_cnt_typ;
    gvv_pos_prof_typ                              VARCHAR2(1000) DEFAULT xxmx_KIT_UTIL_stg.get_pos_prof_typ;
    gvv_pos_prof_reln                             VARCHAR2(1000) DEFAULT xxmx_KIT_UTIL_stg.get_pos_prof_reln;
    gvv_business_name                             VARCHAR2(1000) DEFAULT xxmx_KIT_UTIL_stg.get_business_name;

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
    gcv_PackageName                           CONSTANT VARCHAR2(30)                                := 'xxmx_kit_position_stg';
    gct_ApplicationSuite                      CONSTANT xxmx_module_messages.application_suite%TYPE := 'HCM';
    gct_Application                           CONSTANT xxmx_module_messages.application%TYPE       := 'HR';
    gv_i_BusinessEntity                       CONSTANT VARCHAR2(100) DEFAULT 'POSITION';

    gvv_ReturnStatus                            VARCHAR2(1);
    gvv_ProgressIndicator                       VARCHAR2(100);
    gvn_RowCount                                NUMBER;
    gvt_ReturnMessage                           xxmx_module_messages .module_message%TYPE;
    gvt_Severity                                xxmx_module_messages .severity%TYPE;
    gvt_OracleError                             xxmx_module_messages .oracle_error%TYPE;
    gvt_ModuleMessage                           xxmx_module_messages .module_message%TYPE;
    e_ModuleError                 EXCEPTION;

    TYPE pos_lkp_map_rec IS RECORD (ebs_lookup_type     VARCHAR2(200)
                                  ,ebs_lookup_code     VARCHAR2(200)
                                  ,fusion_lookup_code  VARCHAR2(200));

    TYPE pos_lkp_map_tab IS TABLE OF pos_lkp_map_rec INDEX BY pls_integer;

    g_pos_lkp_map pos_lkp_map_tab;

    PROCEDURE export
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          NUMBER
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export';
        vt_ClientSchemaName                             xxmx_client_config_parameters.config_value%TYPE;
        vt_MigrationSetID                               xxmx_migration_headers.migration_set_id%TYPE;
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT '';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'POSITION EXPORT';

        vt_BusinessEntitySeq                            xxmx_migration_metadata.business_entity_seq%TYPE;

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
        --main
        --   1
        gvv_ProgressIndicator := '0050';
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
                            ,pt_i_ModuleMessage       => 'Calling Procedure "' ||gcv_PackageName ||'.load_position_lookups".'
                        ,pt_i_OracleError         => NULL   );
        --
        load_position_lookups ();
        --   2
        gvv_ProgressIndicator := '0050';
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
                            ,pt_i_ModuleMessage       => 'Calling Procedure "' ||gcv_PackageName ||'.export_positions_f_10".'
                        ,pt_i_OracleError         => NULL   );
        --
        export_positions_f_10 (p_bg_name, p_bg_id, pt_i_MigrationSetID, pt_i_MigrationSetName);
        --   3
        gvv_ProgressIndicator := '0050';
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
                            ,pt_i_ModuleMessage       => 'Calling Procedure "' ||gcv_PackageName ||'.export_positions_f_tl_15".'
                        ,pt_i_OracleError         => NULL   );
        --
        export_positions_f_tl_15 (p_bg_name, p_bg_id, pt_i_MigrationSetID, pt_i_MigrationSetName);
        --
        --
    EXCEPTION
        WHEN OTHERS THEN
        --
        ROLLBACK;
        --
        gvt_OracleError := SUBSTR(
                                    SQLERRM ||'** ERROR_BACKTRACE: ' ||dbms_utility.format_error_backtrace
                                    ,1
                                    ,4000
                                    );
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
                ,pt_i_ModuleMessage       => 'Oracle error encounted at after Progress Indicator.'
                    ,pt_i_OracleError         => gvt_OracleError       );
        --
        RAISE;
        -- Hr_Utility.raise_error@MXDM_NVIS_EXTRACT;
        --
    END export;

    PROCEDURE load_position_lookups IS
        v_cnt NUMBER DEFAULT 0;
        TYPE seed_pos_type_codes IS VARRAY (4) OF VARCHAR2(264);
        v_seed_pos_typ_lkp_codes seed_pos_type_codes DEFAULT seed_pos_type_codes ('NONE'
                                                                                ,'SINGLE'
                                                                                ,'SHARED'
                                                                                ,'POOLED');
        TYPE seed_pos_status_codes IS VARRAY (2) OF VARCHAR2(264);
        v_seed_pos_st_lkp_codes seed_pos_status_codes DEFAULT seed_pos_status_codes ('VALID'
                                                                                    ,'INVALID');
        TYPE seed_frq_codes IS VARRAY (16) OF VARCHAR2(264);
        v_seed_pos_frq_lkp_codes seed_frq_codes DEFAULT seed_frq_codes ('D'
                                                                        ,'H'
                                                                        ,'M'
                                                                        ,'MIN'
                                                                        ,'Q'
                                                                        ,'W'
                                                                        ,'Y'
                                                                        ,'ANUALLY'
                                                                        ,'BIMONTHLY'
                                                                        ,'BIWEEKLY'
                                                                        ,'MONTHLY'
                                                                        ,'QUARTERLY'
                                                                        ,'SEMI_ANUALLY'
                                                                        ,'SEMI_MONTHLY'
                                                                        ,'WEEKLY'
                                                                        ,'YEARLY');
    BEGIN
        FOR i IN 1 .. v_seed_pos_typ_lkp_codes.last LOOP
            v_cnt := i;

            g_pos_lkp_map (v_cnt).ebs_lookup_type := 'POSITION_TYPE';

            g_pos_lkp_map (v_cnt).ebs_lookup_code := v_seed_pos_typ_lkp_codes (i);

            g_pos_lkp_map (v_cnt).fusion_lookup_code := v_seed_pos_typ_lkp_codes (i);
        END LOOP;

        FOR i IN 1 .. v_seed_pos_st_lkp_codes.last LOOP
            v_cnt := v_cnt + 1;

            g_pos_lkp_map (v_cnt).ebs_lookup_type := 'POSITION_STATUS';

            g_pos_lkp_map (v_cnt).ebs_lookup_code := v_seed_pos_st_lkp_codes (i);

            g_pos_lkp_map (v_cnt).fusion_lookup_code := CASE
                                                        WHEN v_seed_pos_st_lkp_codes (i) = 'VALID' THEN
                                                            'A'
                                                        ELSE
                                                            'I'
                                                        END;
        END LOOP;

        FOR i IN 1 .. v_seed_pos_frq_lkp_codes.last LOOP
            v_cnt := v_cnt + 1;

            g_pos_lkp_map (v_cnt).ebs_lookup_type := 'FREQUENCY';

            g_pos_lkp_map (v_cnt).ebs_lookup_code := v_seed_pos_frq_lkp_codes (i);

            g_pos_lkp_map (v_cnt).fusion_lookup_code := v_seed_pos_frq_lkp_codes (i);
        END LOOP;

        load_usr_pos_lkp ('POSITION_STATUS');

        load_usr_pos_lkp ('BARGAINING_UNIT_CODE');
    END load_position_lookups;

    PROCEDURE load_usr_pos_lkp
        (p_lkp_type IN VARCHAR2) IS

        v_cnt NUMBER DEFAULT 0;

        CURSOR c1
        (c_lkp_type IN VARCHAR2) IS
            SELECT  lookup_type ebs_lookup_type
                    ,lookup_code ebs_lookup_code
                    ,lookup_code target_lookup_code
            FROM    fnd_lookup_values_vl@MXDM_NVIS_EXTRACT flv
            WHERE   lookup_type = c_lkp_type
            AND     view_application_id = 3;

        v_pos_lkp_map pos_lkp_map_tab;
        v_src_lkp_type VARCHAR2(200);
        v_src_lkp_code VARCHAR2(200);
        v_tgt_lkp_code VARCHAR2(200);
    BEGIN
        v_cnt := g_pos_lkp_map.last + 1;

        OPEN c1 (p_lkp_type);

        LOOP
            FETCH c1
            INTO    v_src_lkp_type
                    ,v_src_lkp_code
                    ,v_tgt_lkp_code;

            IF c1%FOUND THEN
                g_pos_lkp_map (v_cnt).ebs_lookup_type := v_src_lkp_type;

                g_pos_lkp_map (v_cnt).ebs_lookup_code := v_src_lkp_code;

                g_pos_lkp_map (v_cnt).fusion_lookup_code := v_tgt_lkp_code;

                v_cnt := v_cnt + 1;
            END IF;

            EXIT WHEN c1%NOTFOUND;
        END LOOP;

        CLOSE c1;
    EXCEPTION
        WHEN no_data_found THEN
            RETURN;
    END load_usr_pos_lkp;

    FUNCTION get_target_lookup_code
        (p_src_lookup_code IN VARCHAR2) RETURN VARCHAR2 IS
        v_ret VARCHAR2(200);
    BEGIN
        FOR i IN g_pos_lkp_map.first .. g_pos_lkp_map.last LOOP
            IF g_pos_lkp_map (i).ebs_lookup_code = p_src_lookup_code THEN
                v_ret := g_pos_lkp_map (i).fusion_lookup_code;
            END IF;
        END LOOP;

        RETURN v_ret;
    END get_target_lookup_code;

    PROCEDURE export_profiles_position
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          NUMBER
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_profiles_position';
        vt_ClientSchemaName                             xxmx_client_config_parameters.config_value%TYPE;
        vt_MigrationSetID                               xxmx_migration_headers.migration_set_id%TYPE;
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT '';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'PROFILES_POSITION';

        vt_BusinessEntitySeq                            xxmx_migration_metadata.business_entity_seq%TYPE;

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
        --main
        --1
        gvv_ProgressIndicator := '0050';
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
                            ,pt_i_ModuleMessage       => 'Calling Procedure "' ||gcv_PackageName ||'.export_profiles_b_3_pos_40".'
                        ,pt_i_OracleError         => NULL   );
        --
        export_profiles_b_3_pos_40 (p_bg_name, p_bg_id, pt_i_MigrationSetID, pt_i_MigrationSetName);
        --2
        gvv_ProgressIndicator := '0060';
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
                            ,pt_i_ModuleMessage       => 'Calling Procedure "' ||gcv_PackageName ||'.export_profiles_tl_3_1_pos_45".'
                        ,pt_i_OracleError         => NULL   );
        --
        export_profiles_tl_3_1_pos_45 (p_bg_name, p_bg_id, pt_i_MigrationSetID, pt_i_MigrationSetName);
        --3
        gvv_ProgressIndicator := '0070';
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
                            ,pt_i_ModuleMessage       => 'Calling Procedure "' ||gcv_PackageName ||'.export_profile_relns_2_pos_55".'
                        ,pt_i_OracleError         => NULL   );
        --
        export_profile_relns_2_pos_55 (p_bg_name, p_bg_id, pt_i_MigrationSetID, pt_i_MigrationSetName);
        --4
        gvv_ProgressIndicator := '0080';
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
                            ,pt_i_ModuleMessage       => 'Calling Procedure "' ||gcv_PackageName ||'.export_profile_items_1_pos_60".'
                        ,pt_i_OracleError         => NULL   );
        --
        export_profile_items_1_pos_60 (p_bg_name, p_bg_id, pt_i_MigrationSetID, pt_i_MigrationSetName);
        --
        --
    EXCEPTION
        WHEN OTHERS THEN
            --
            ROLLBACK;
            --
            gvt_OracleError := SUBSTR(
                                        SQLERRM ||'** ERROR_BACKTRACE: ' ||dbms_utility.format_error_backtrace
                                        ,1
                                        ,4000
                                        );
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
                ,pt_i_ModuleMessage       => 'Oracle error encounted at after Progress Indicator.'
                    ,pt_i_OracleError         => gvt_OracleError       );
            --
            RAISE;
            -- Hr_Utility.raise_error@MXDM_NVIS_EXTRACT;
    END export_profiles_position;

    PROCEDURE export_positions_f_10
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          NUMBER
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_email_addresses';
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'xxmx_per_email_f_stg';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'EMAIL_ADDRESSES';

    BEGIN
        --
        --
        --
        gvv_ReturnStatus  := '';
        gvt_ReturnMessage := '';
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
                ,pt_i_OracleError         => gvt_ReturnMessage    );
            --
            RAISE e_ModuleError;
        END IF;
        --
        gvv_ReturnStatus  := '';
        gvt_ReturnMessage := '';
        gvv_ProgressIndicator := '0005';
        xxmx_utilities_pkg.clear_messages
            (pt_i_ApplicationSuite     => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_Phase               => ct_Phase
            ,pt_i_MessageType         => 'DATA'
            ,pv_o_ReturnStatus        => gvv_ReturnStatus
            );
        IF   gvv_ReturnStatus = 'F'
        THEN
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
                ,pt_i_ModuleMessage       => 'Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
                ,pt_i_OracleError         => gvt_ReturnMessage
                );
            --
            RAISE e_ModuleError;
        END IF;
        --
        gvv_ProgressIndicator := '0010';
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
                ,pt_i_ModuleMessage       => 'Deleting from "' || cv_StagingTable   || '".'
                ,pt_i_OracleError         => gvt_ReturnMessage  );
        --
        DELETE
        FROM    xxmx_positions_f_stg
        WHERE   bg_id    = p_bg_id    ;

        COMMIT;
        --
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
                        ,pt_i_ModuleMessage       => 'Extracting data into "' || cv_StagingTable   || '".'
                        ,pt_i_OracleError         => gvt_ReturnMessage       );
        --
        INSERT
        INTO    xxmx_positions_f_stg
                (migration_set_id
                ,migration_set_name
                ,migration_status
                ,bg_name
                ,bg_id
                ,effective_start_date
                ,effective_end_date
                ,business_unit_name
                ,position_code
                ,organization_id
                ,job_id
                ,location_id
                ,supervisor_id
                ,action_occurrence_id
                ,active_status
                ,hiring_status
                ,position_type
                ,permanent_temporary_flag
                ,fte
                ,max_persons
                ,working_hours
                ,frequency
                ,time_normal_start
                ,time_normal_finish
                ,probation_period
                ,probation_period_unit_cd
                ,bargaining_unit_cd
                ,position_synchronization_flag
                ,overlap_allowed
                ,seasonal_flag
                ,seasonal_start_date
                ,seasonal_end_date
                ,position_id)
        SELECT   pt_i_MigrationSetID
                ,pt_i_MigrationSetName
                ,'EXTRACTED'
                ,p_bg_name
                ,p_bg_id
                ,hr_all_positions_f.effective_start_date effective_start_date
                ,hr_all_positions_f.effective_end_date effective_end_date
                ,gvv_business_name
                ,per_position_definitions.segment1 position_code
                ,nvl2 (hr_all_positions_f.organization_id
                    ,hr_all_positions_f.organization_id
                        || '_ORGANIZATION'
                    ,NULL) organization_id
                ,nvl2 (hr_all_positions_f.job_id
                    ,hr_all_positions_f.job_id
                        || '_JOB'
                    ,NULL) job_id
                ,nvl2 (hr_all_positions_f.location_id
                    ,hr_all_positions_f.location_id
                        || '_LOCATION'
                    ,NULL) location_id
                ,nvl2 (hr_all_positions_f.supervisor_id
                    ,hr_all_positions_f.location_id
                        || '_SUPERVISOR'
                    ,NULL) supervisor_id
                ,- 1
                ,nvl (get_target_lookup_code (hr_all_positions_f.status)
                    ,decode (
                            (
                            SELECT  system_type_cd
                            FROM    per_shared_types@MXDM_NVIS_EXTRACT
                            WHERE   shared_type_id = hr_all_positions_f.availability_status_id
                            )
                            ,'ACTIVE'
                            ,'A'
                            ,'PROPOSED'
                            ,'A'
                            ,'FROZEN'
                            ,'A'
                            ,'DELETED'
                            ,'I'
                            ,'ELIMINATED'
                            ,'I')) active_status
                ,decode (
                        (
                        SELECT  system_type_cd
                        FROM    per_shared_types@MXDM_NVIS_EXTRACT
                        WHERE   shared_type_id = hr_all_positions_f.availability_status_id
                        )
                        ,'ACTIVE'
                        ,'APPROVED'
                        ,'DELETED'
                        ,'APPROVED'
                        ,'ELIMINATED'
                        ,'APPROVED'
                        ,'FROZEN'
                        ,'FROZEN'
                        ,'PROPOSED'
                        ,'PROPOSED') hiring_status
                ,get_target_lookup_code (hr_all_positions_f.position_type) position_type
                ,decode (hr_all_positions_f.permanent_temporary_flag
                        ,'Y'
                        ,'R'
                        ,'N'
                        ,'T') permanent_temporary_flag
                ,nvl (hr_all_positions_f.fte
                    ,1) fte
                ,nvl (hr_all_positions_f.max_persons
                    ,1) max_persons
                ,hr_all_positions_f.working_hours working_hours
                ,get_target_lookup_code (hr_all_positions_f.frequency) frequency
                ,hr_all_positions_f.time_normal_start time_normal_start
                ,hr_all_positions_f.time_normal_finish time_normal_finish
                ,hr_all_positions_f.probation_period probation_period
                ,hr_all_positions_f.probation_period_unit_cd probation_period_unit_cd
                ,get_target_lookup_code (hr_all_positions_f.bargaining_unit_cd) bargaining_unit_cd
                ,'N' position_synchronization_flag
                ,nvl2 (
                        (
                        SELECT  1
                        FROM    per_position_extra_info@MXDM_NVIS_EXTRACT
                        WHERE   position_id = hr_all_positions_f.position_id
                        AND     information_type = 'PER_OVERLAP'
                        )
                    ,'Y'
                    ,'N') overlap_allowed
                ,hr_all_positions_f.seasonal_flag seasonal_flag
                ,NULL seasonal_start_date
                ,NULL seasonal_end_date
                ,position_id
                || '_POSITION'
        FROM    hr_all_positions_f@MXDM_NVIS_EXTRACT hr_all_positions_f
                ,per_position_definitions@MXDM_NVIS_EXTRACT per_position_definitions
                ,hr_all_organization_units@MXDM_NVIS_EXTRACT horg
        WHERE   (
                        hr_all_positions_f.position_definition_id = per_position_definitions.position_definition_id
                )
        AND     (
                        horg.organization_id = hr_all_positions_f.business_group_id
                )
        AND     (
                        horg.name = p_bg_name
                )
        ;

        COMMIT;
        --
        --
        --
        gvv_ProgressIndicator := '0030';
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
                        ,pt_i_ModuleMessage       => 'End of extraction at ' || to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS.FF2') || '. Procedure completed'
                        ,pt_i_OracleError         => gvt_ReturnMessage       );

    EXCEPTION
        WHEN e_ModuleError THEN
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
                    ,pt_i_ModuleMessage       => gvt_ModuleMessage
                    ,pt_i_OracleError         => gvt_ReturnMessage       );
            --
            RAISE;
            --** END e_ModuleError Exception
            --
        WHEN OTHERS THEN
            --
            ROLLBACK;
            --
            gvt_OracleError := SUBSTR(
                                        SQLERRM
                                    ||'** ERROR_BACKTRACE: '
                                    ||dbms_utility.format_error_backtrace
                                    ,1
                                    ,4000
                                    );
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
                    ,pt_i_ModuleMessage       => 'Oracle error encounted at after Progress Indicator.'
                    ,pt_i_OracleError         => gvt_OracleError       );
            --
            RAISE;
            -- Hr_Utility.raise_error@MXDM_NVIS_EXTRACT;

    END export_positions_f_10;

    PROCEDURE export_positions_f_tl_15
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          NUMBER
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_email_addresses';
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'xxmx_per_email_f_stg';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'EMAIL_ADDRESSES';

    BEGIN
        --
        --
        --
        gvv_ReturnStatus  := '';
        gvt_ReturnMessage := '';
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
                ,pt_i_OracleError         => gvt_ReturnMessage    );
            --
            RAISE e_ModuleError;
        END IF;
        --
        gvv_ReturnStatus  := '';
        gvt_ReturnMessage := '';
        gvv_ProgressIndicator := '0005';
        xxmx_utilities_pkg.clear_messages
            (pt_i_ApplicationSuite     => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_Phase               => ct_Phase
            ,pt_i_MessageType         => 'DATA'
            ,pv_o_ReturnStatus        => gvv_ReturnStatus
            );
        IF   gvv_ReturnStatus = 'F'
        THEN
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
                ,pt_i_ModuleMessage       => 'Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
                ,pt_i_OracleError         => gvt_ReturnMessage
                );
            --
            RAISE e_ModuleError;
        END IF;
        --
        gvv_ProgressIndicator := '0010';
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
                ,pt_i_ModuleMessage       => 'Deleting from "' || cv_StagingTable   || '".'
                ,pt_i_OracleError         => gvt_ReturnMessage  );
        --
        DELETE
        FROM    xxmx_positions_f_tl_stg
        WHERE   bg_id    = p_bg_id    ;

        COMMIT;
        --
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
                        ,pt_i_ModuleMessage       => 'Extracting data into "' || cv_StagingTable   || '".'
                        ,pt_i_OracleError         => gvt_ReturnMessage       );
        --
        INSERT
        INTO    xxmx_positions_f_tl_stg
                (migration_set_id
                ,migration_set_name
                ,migration_status
                ,bg_name
                ,bg_id
                ,position_id
                ,language
                ,effective_start_date
                ,effective_end_date
                ,source_lang
                ,name)
        SELECT   pt_i_MigrationSetID
                ,pt_i_MigrationSetName
                ,'EXTRACTED'
                ,p_bg_name
                ,p_bg_id
                ,hr_all_positions_f.position_id
                || '_POSITION' position_id
                ,'US' language
                ,effective_start_date effective_start_date
                ,effective_end_date effective_end_date
                ,'US' source_lang
                ,hr_all_positions_f.name
        FROM    hr_all_positions_f@MXDM_NVIS_EXTRACT hr_all_positions_f
                ,hr_all_positions_f_tl@MXDM_NVIS_EXTRACT hr_all_positions_f_tl
                ,hr_all_organization_units@MXDM_NVIS_EXTRACT horg
        WHERE   hr_all_positions_f_tl.position_id = hr_all_positions_f.position_id
        AND     hr_all_positions_f_tl.language = 'US'
        AND     horg.organization_id = hr_all_positions_f.business_group_id
        AND     horg.name = p_bg_name;

      COMMIT;
        --
        --
        --
        gvv_ProgressIndicator := '0030';
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
                        ,pt_i_ModuleMessage       => 'End of extraction at ' || to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS.FF2') || '. Procedure completed'
                        ,pt_i_OracleError         => gvt_ReturnMessage       );

    EXCEPTION
        WHEN e_ModuleError THEN
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
                    ,pt_i_ModuleMessage       => gvt_ModuleMessage
                    ,pt_i_OracleError         => gvt_ReturnMessage       );
            --
            RAISE;
            --** END e_ModuleError Exception
            --
        WHEN OTHERS THEN
            --
            ROLLBACK;
            --
            gvt_OracleError := SUBSTR(
                                        SQLERRM
                                    ||'** ERROR_BACKTRACE: '
                                    ||dbms_utility.format_error_backtrace
                                    ,1
                                    ,4000
                                    );
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
                    ,pt_i_ModuleMessage       => 'Oracle error encounted at after Progress Indicator.'
                    ,pt_i_OracleError         => gvt_OracleError       );
            --
            RAISE;
            -- Hr_Utility.raise_error@MXDM_NVIS_EXTRACT;

    END export_positions_f_tl_15;

    PROCEDURE export_profiles_b_3_pos_40
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          NUMBER
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_email_addresses';
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'xxmx_per_email_f_stg';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'EMAIL_ADDRESSES';

    BEGIN
        --
        --
        --
        gvv_ReturnStatus  := '';
        gvt_ReturnMessage := '';
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
                ,pt_i_OracleError         => gvt_ReturnMessage    );
            --
            RAISE e_ModuleError;
        END IF;
        --
        gvv_ReturnStatus  := '';
        gvt_ReturnMessage := '';
        gvv_ProgressIndicator := '0005';
        xxmx_utilities_pkg.clear_messages
            (pt_i_ApplicationSuite     => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_Phase               => ct_Phase
            ,pt_i_MessageType         => 'DATA'
            ,pv_o_ReturnStatus        => gvv_ReturnStatus
            );
        IF   gvv_ReturnStatus = 'F'
        THEN
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
                ,pt_i_ModuleMessage       => 'Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
                ,pt_i_OracleError         => gvt_ReturnMessage
                );
            --
            RAISE e_ModuleError;
        END IF;
        --
        gvv_ProgressIndicator := '0010';
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
                ,pt_i_ModuleMessage       => 'Deleting from "' || cv_StagingTable   || '".'
                ,pt_i_OracleError         => gvt_ReturnMessage  );
        --
        DELETE
        FROM    xxmx_hrt_profile_b_stg
        WHERE   profile_id IN
                (
                SELECT  DISTINCT
                        position_id
                        || '_PROFILE'
                FROM    xxmx_positions_f_stg
                )
        AND     bg_id    = p_bg_id    ;

        COMMIT;
        --
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
                        ,pt_i_ModuleMessage       => 'Extracting data into "' || cv_StagingTable   || '".'
                        ,pt_i_OracleError         => gvt_ReturnMessage       );
        --
        INSERT
        INTO    xxmx_hrt_profile_b_stg
                (migration_set_id
                ,migration_set_name
                ,migration_status
                ,bg_name
                ,bg_id
                ,profile_type_id
                ,profile_code
                ,profile_status_code
                ,profile_usage_code
                ,profile_id)
        SELECT   pt_i_MigrationSetID
                ,pt_i_MigrationSetName
                ,'EXTRACTED'
                ,p_bg_name
                ,p_bg_id
                ,gvv_pos_prof_typ profile_type_id
                ,substrb ('POSITION_'
                        || position_id
                        ,1
                        ,30) profile_code
                ,'A' profile_status_code
                ,'M' profile_usage_code
                ,position_id
                || '_POSITION_PROFILE'
        FROM    hr_all_positions_f@MXDM_NVIS_EXTRACT hr_all_positions_f
                ,hr_all_organization_units@MXDM_NVIS_EXTRACT horg
        WHERE   (
                        hr_all_positions_f.effective_start_date =
                        (
                        SELECT  max (t.effective_start_date)
                        FROM    hr_all_positions_f@MXDM_NVIS_EXTRACT t
                        WHERE   t.position_id = hr_all_positions_f.position_id
                        )
                )
        AND     horg.organization_id = hr_all_positions_f.business_group_id
        AND     horg.name = p_bg_name;

        COMMIT;
        --
        --
        --
        gvv_ProgressIndicator := '0030';
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
                        ,pt_i_ModuleMessage       => 'End of extraction at ' || to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS.FF2') || '. Procedure completed'
                        ,pt_i_OracleError         => gvt_ReturnMessage       );

    EXCEPTION
        WHEN e_ModuleError THEN
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
                    ,pt_i_ModuleMessage       => gvt_ModuleMessage
                    ,pt_i_OracleError         => gvt_ReturnMessage       );
            --
            RAISE;
            --** END e_ModuleError Exception
            --
        WHEN OTHERS THEN
            --
            ROLLBACK;
            --
            gvt_OracleError := SUBSTR(
                                        SQLERRM
                                    ||'** ERROR_BACKTRACE: '
                                    ||dbms_utility.format_error_backtrace
                                    ,1
                                    ,4000
                                    );
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
                    ,pt_i_ModuleMessage       => 'Oracle error encounted at after Progress Indicator.'
                    ,pt_i_OracleError         => gvt_OracleError       );
            --
            RAISE;
            -- Hr_Utility.raise_error@MXDM_NVIS_EXTRACT;

    END export_profiles_b_3_pos_40;

    PROCEDURE export_profiles_tl_3_1_pos_45
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          NUMBER
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_email_addresses';
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'xxmx_per_email_f_stg';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'EMAIL_ADDRESSES';

    BEGIN
        --
        --
        --
        gvv_ReturnStatus  := '';
        gvt_ReturnMessage := '';
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
                ,pt_i_OracleError         => gvt_ReturnMessage    );
            --
            RAISE e_ModuleError;
        END IF;
        --
        gvv_ReturnStatus  := '';
        gvt_ReturnMessage := '';
        gvv_ProgressIndicator := '0005';
        xxmx_utilities_pkg.clear_messages
            (pt_i_ApplicationSuite     => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_Phase               => ct_Phase
            ,pt_i_MessageType         => 'DATA'
            ,pv_o_ReturnStatus        => gvv_ReturnStatus
            );
        IF   gvv_ReturnStatus = 'F'
        THEN
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
                ,pt_i_ModuleMessage       => 'Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
                ,pt_i_OracleError         => gvt_ReturnMessage
                );
            --
            RAISE e_ModuleError;
        END IF;
        --
        gvv_ProgressIndicator := '0010';
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
                ,pt_i_ModuleMessage       => 'Deleting from "' || cv_StagingTable   || '".'
                ,pt_i_OracleError         => gvt_ReturnMessage  );
        --
        DELETE
        FROM    xxmx_hrt_profile_tl_stg
        WHERE   profile_id IN
                (
                SELECT  DISTINCT
                        position_id
                        || '_PROFILE'
                FROM    xxmx_positions_f_stg
                )
        AND     bg_id    = p_bg_id    ;

        COMMIT;
        --
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
                        ,pt_i_ModuleMessage       => 'Extracting data into "' || cv_StagingTable   || '".'
                        ,pt_i_OracleError         => gvt_ReturnMessage       );
        --
        INSERT
        INTO    xxmx_hrt_profile_tl_stg
                (migration_set_id
                ,migration_set_name
                ,migration_status
                ,bg_name
                ,bg_id
                ,profile_id
                ,language
                ,source_lang
                ,description)
        SELECT   pt_i_MigrationSetID
                ,pt_i_MigrationSetName
                ,'EXTRACTED'
                ,p_bg_name
                ,p_bg_id
                ,hr_all_positions_f.position_id
                || '_POSITION_PROFILE' profile_id
                ,'US' language
                ,'US' source_lang
                ,hr_all_positions_f_tl.name description
        FROM    hr_all_positions_f@MXDM_NVIS_EXTRACT hr_all_positions_f
                ,hr_all_positions_f_tl@MXDM_NVIS_EXTRACT hr_all_positions_f_tl
                ,hr_all_organization_units@MXDM_NVIS_EXTRACT horg
        WHERE   hr_all_positions_f.effective_start_date =
                (
                SELECT  max (t.effective_start_date)
                FROM    hr_all_positions_f@MXDM_NVIS_EXTRACT t
                WHERE   t.position_id = hr_all_positions_f.position_id
                )
        AND     (
                        hr_all_positions_f.position_id = hr_all_positions_f_tl.position_id
                )
        AND     (
                        hr_all_positions_f_tl.language = 'US'
                )
        AND     horg.organization_id = hr_all_positions_f.business_group_id
        AND     horg.name = p_bg_name;

        COMMIT;
        --
        --
        --
        gvv_ProgressIndicator := '0030';
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
                        ,pt_i_ModuleMessage       => 'End of extraction at ' || to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS.FF2') || '. Procedure completed'
                        ,pt_i_OracleError         => gvt_ReturnMessage       );

    EXCEPTION
        WHEN e_ModuleError THEN
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
                    ,pt_i_ModuleMessage       => gvt_ModuleMessage
                    ,pt_i_OracleError         => gvt_ReturnMessage       );
            --
            RAISE;
            --** END e_ModuleError Exception
            --
        WHEN OTHERS THEN
            --
            ROLLBACK;
            --
            gvt_OracleError := SUBSTR(
                                        SQLERRM
                                    ||'** ERROR_BACKTRACE: '
                                    ||dbms_utility.format_error_backtrace
                                    ,1
                                    ,4000
                                    );
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
                    ,pt_i_ModuleMessage       => 'Oracle error encounted at after Progress Indicator.'
                    ,pt_i_OracleError         => gvt_OracleError       );
            --
            RAISE;
            -- Hr_Utility.raise_error@MXDM_NVIS_EXTRACT;

    END export_profiles_tl_3_1_pos_45;

    PROCEDURE export_profile_relns_2_pos_55
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          NUMBER
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_email_addresses';
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'xxmx_per_email_f_stg';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'EMAIL_ADDRESSES';

    BEGIN
        --
        --
        --
        gvv_ReturnStatus  := '';
        gvt_ReturnMessage := '';
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
                ,pt_i_OracleError         => gvt_ReturnMessage    );
            --
            RAISE e_ModuleError;
        END IF;
        --
        gvv_ReturnStatus  := '';
        gvt_ReturnMessage := '';
        gvv_ProgressIndicator := '0005';
        xxmx_utilities_pkg.clear_messages
            (pt_i_ApplicationSuite     => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_Phase               => ct_Phase
            ,pt_i_MessageType         => 'DATA'
            ,pv_o_ReturnStatus        => gvv_ReturnStatus
            );
        IF   gvv_ReturnStatus = 'F'
        THEN
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
                ,pt_i_ModuleMessage       => 'Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
                ,pt_i_OracleError         => gvt_ReturnMessage
                );
            --
            RAISE e_ModuleError;
        END IF;
        --
        gvv_ProgressIndicator := '0010';
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
                ,pt_i_ModuleMessage       => 'Deleting from "' || cv_StagingTable   || '".'
                ,pt_i_OracleError         => gvt_ReturnMessage  );
        --
        DELETE
        FROM    xxmx_hrt_profile_rel_stg
        WHERE   profile_id IN
                (
                SELECT  DISTINCT
                        position_id
                        || '_PROFILE'
                FROM    xxmx_positions_f_stg
                )
        AND     bg_id    = p_bg_id    ;

        COMMIT;
        --
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
                        ,pt_i_ModuleMessage       => 'Extracting data into "' || cv_StagingTable   || '".'
                        ,pt_i_OracleError         => gvt_ReturnMessage       );
        --
        INSERT
        INTO    xxmx_hrt_profile_rel_stg
                (migration_set_id
                ,migration_set_name
                ,migration_status
                ,bg_name
                ,bg_id
                ,profile_id
                ,relation_id
                ,object_id
                ,object_eff_start_date
                ,object_eff_end_date
                ,profile_relation_id)
        SELECT   pt_i_MigrationSetID
                ,pt_i_MigrationSetName
                ,'EXTRACTED'
                ,p_bg_name
                ,p_bg_id
                ,position_id
                || '_POSITION_PROFILE' profile_id
                ,gvv_pos_prof_reln relation_id
                ,position_id
                || '_POSITION' object_id
                ,effective_start_date object_eff_start_date
                ,effective_end_date object_eff_end_date
                ,position_id
                || '_PROFILE_RELATION_ID'
        FROM    hr_all_positions_f@MXDM_NVIS_EXTRACT hr_all_positions_f
                ,hr_all_organization_units@MXDM_NVIS_EXTRACT horg
        WHERE   (
                    hr_all_positions_f.effective_start_date =
                    (
                    SELECT  max (t.effective_start_date)
                    FROM    hr_all_positions_f@MXDM_NVIS_EXTRACT t
                    WHERE   t.position_id = hr_all_positions_f.position_id
                    )
                )
        AND     horg.organization_id = hr_all_positions_f.business_group_id
        AND     horg.name = p_bg_name;

        COMMIT;
        --
        --
        --
        gvv_ProgressIndicator := '0030';
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
                        ,pt_i_ModuleMessage       => 'End of extraction at ' || to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS.FF2') || '. Procedure completed'
                        ,pt_i_OracleError         => gvt_ReturnMessage       );

    EXCEPTION
        WHEN e_ModuleError THEN
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
                    ,pt_i_ModuleMessage       => gvt_ModuleMessage
                    ,pt_i_OracleError         => gvt_ReturnMessage       );
            --
            RAISE;
            --** END e_ModuleError Exception
            --
        WHEN OTHERS THEN
            --
            ROLLBACK;
            --
            gvt_OracleError := SUBSTR(
                                        SQLERRM
                                    ||'** ERROR_BACKTRACE: '
                                    ||dbms_utility.format_error_backtrace
                                    ,1
                                    ,4000
                                    );
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
                    ,pt_i_ModuleMessage       => 'Oracle error encounted at after Progress Indicator.'
                    ,pt_i_OracleError         => gvt_OracleError       );
            --
            RAISE;
            -- Hr_Utility.raise_error@MXDM_NVIS_EXTRACT;

    END export_profile_relns_2_pos_55;

    PROCEDURE export_profile_items_1_pos_60
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          NUMBER
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_email_addresses';
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'xxmx_per_email_f_stg';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'EMAIL_ADDRESSES';

    BEGIN
        --
        --
        --
        gvv_ReturnStatus  := '';
        gvt_ReturnMessage := '';
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
                ,pt_i_OracleError         => gvt_ReturnMessage    );
            --
            RAISE e_ModuleError;
        END IF;
        --
        gvv_ReturnStatus  := '';
        gvt_ReturnMessage := '';
        gvv_ProgressIndicator := '0005';
        xxmx_utilities_pkg.clear_messages
            (pt_i_ApplicationSuite     => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_Phase               => ct_Phase
            ,pt_i_MessageType         => 'DATA'
            ,pv_o_ReturnStatus        => gvv_ReturnStatus
            );
        IF   gvv_ReturnStatus = 'F'
        THEN
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
                ,pt_i_ModuleMessage       => 'Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
                ,pt_i_OracleError         => gvt_ReturnMessage
                );
            --
            RAISE e_ModuleError;
        END IF;
        --
        gvv_ProgressIndicator := '0010';
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
                ,pt_i_ModuleMessage       => 'Deleting from "' || cv_StagingTable   || '".'
                ,pt_i_OracleError         => gvt_ReturnMessage  );
        --
        DELETE
        FROM    xxmx_hrt_pfl_items_stg
        WHERE   profile_id IN
                (
                SELECT  DISTINCT
                        position_id
                        || '_PROFILE'
                FROM    xxmx_positions_f_stg
                )
        AND     bg_id    = p_bg_id    ;

        COMMIT;
        --
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
                        ,pt_i_ModuleMessage       => 'Extracting data into "' || cv_StagingTable   || '".'
                        ,pt_i_OracleError         => gvt_ReturnMessage       );
        --
        INSERT
        INTO    xxmx_hrt_pfl_items_stg
                (migration_set_id
                ,migration_set_name
                ,migration_status
                ,bg_name
                ,bg_id
                ,profile_id
                ,content_type_id
                ,content_item_id
                ,date_from
                ,date_to
                ,rating_model_id1
                ,rating_model_id2
                ,rating_level_id1
                ,rating_level_id2
                ,mandatory
                ,importance
                ,profile_item_id)
        SELECT   pt_i_MigrationSetID
                ,pt_i_MigrationSetName
                ,'EXTRACTED'
                ,p_bg_name
                ,p_bg_id
                ,position_id
                || '_POSITION_PROFILE' profile_id
                ,gvv_cmp_cnt_typ content_type_id
                ,competence_id
                || '_CMP_CNT_ITEM' content_item_id
                ,effective_date_from date_from
                ,effective_date_to date_to
                ,
                (
                SELECT  rating_model_id
                FROM    xxmx_hrt_cnt_items_b_stg
                WHERE   content_item_id = competence_id
                                            || '_CMP_CNT_ITEM'
                ) rating_model_id1
                ,
                (
                SELECT  rating_model_id
                FROM    xxmx_hrt_cnt_items_b_stg
                WHERE   content_item_id = competence_id
                                            || '_CMP_CNT_ITEM'
                ) rating_model_id2
                ,nvl2 (proficiency_level_id
                    ,proficiency_level_id
                        || '_RATING_LEVEL'
                    ,NULL) rating_level_id1
                ,nvl2 (high_proficiency_level_id
                    ,high_proficiency_level_id
                        || '_RATING_LEVEL'
                    ,NULL) rating_level_id2
                ,decode (per_competence_elements.mandatory
                        ,'Y'
                        ,'true'
                        ,'false') mandatory
                ,2 importance
                ,competence_element_id
                || '_POSITION_PROF_ITEM'
        FROM    per_competence_elements@MXDM_NVIS_EXTRACT per_competence_elements
                ,hr_all_organization_units@MXDM_NVIS_EXTRACT horg
        WHERE   (
                        (
                                per_competence_elements.position_id IS NOT NULL
                        )
                AND     per_competence_elements.type = 'REQUIREMENT'
                )
        AND     horg.organization_id = per_competence_elements.business_group_id
        AND     horg.name = p_bg_name;

        COMMIT;
        --
        --
        --
        gvv_ProgressIndicator := '0030';
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
                        ,pt_i_ModuleMessage       => 'End of extraction at ' || to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS.FF2') || '. Procedure completed'
                        ,pt_i_OracleError         => gvt_ReturnMessage       );

    EXCEPTION
        WHEN e_ModuleError THEN
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
                    ,pt_i_ModuleMessage       => gvt_ModuleMessage
                    ,pt_i_OracleError         => gvt_ReturnMessage       );
            --
            RAISE;
            --** END e_ModuleError Exception
            --
        WHEN OTHERS THEN
            --
            ROLLBACK;
            --
            gvt_OracleError := SUBSTR(
                                        SQLERRM
                                    ||'** ERROR_BACKTRACE: '
                                    ||dbms_utility.format_error_backtrace
                                    ,1
                                    ,4000
                                    );
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
                    ,pt_i_ModuleMessage       => 'Oracle error encounted at after Progress Indicator.'
                    ,pt_i_OracleError         => gvt_OracleError       );
            --
            RAISE;
            -- Hr_Utility.raise_error@MXDM_NVIS_EXTRACT;

    END export_profile_items_1_pos_60;

    --*******************
    --** PROCEDURE: purge
    --*******************
    --
    PROCEDURE purge
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
            ,pt_i_ModuleMessage       => '- Purging tables.'
            ,pt_i_OracleError         => NULL
            );
        --
        --
        gvv_ProgressIndicator := '0030';
        --
        --
        DELETE
        FROM   xxmx_hrt_profile_b_stg
        WHERE  migration_set_id = pt_i_MigrationSetID;
        --
        --
        gvn_RowCount := SQL%ROWCOUNT;
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
            ,pt_i_ModuleMessage       => '  - Records purged from "xxmx_hrt_profile_b_stg" table: '
                                      ||gvn_RowCount
              ,pt_i_OracleError         => NULL
              );
        --
        --
        gvv_ProgressIndicator := '0040';
        --
        --
        DELETE
        FROM   xxmx_hrt_profile_tl_stg
        WHERE  migration_set_id = pt_i_MigrationSetID;
        --
        --
        gvn_RowCount := SQL%ROWCOUNT;
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
            ,pt_i_ModuleMessage       => '  - Records purged from "xxmx_hrt_profile_tl_stg" table: '
                                      ||gvn_RowCount
              ,pt_i_OracleError         => NULL
              );
        --
        --
        gvv_ProgressIndicator := '0050';
        --
        --
        DELETE
        FROM   xxmx_hrt_profile_rel_stg
        WHERE  migration_set_id = pt_i_MigrationSetID;
        --
        --
        gvn_RowCount := SQL%ROWCOUNT;
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
            ,pt_i_ModuleMessage       => '  - Records purged from "xxmx_hrt_profile_rel_stg" table: '
                                      ||gvn_RowCount
              ,pt_i_OracleError         => NULL
              );
        --
        --
        gvv_ProgressIndicator := '0060';
        --
        --
        DELETE
        FROM   xxmx_hrt_pfl_items_stg
        WHERE  migration_set_id = pt_i_MigrationSetID;
        --
        --
        gvn_RowCount := SQL%ROWCOUNT;
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
            ,pt_i_ModuleMessage       => '  - Records purged from "xxmx_hrt_pfl_items_stg" table: '
                                      ||gvn_RowCount
              ,pt_i_OracleError         => NULL
              );
        --
        --
        gvv_ProgressIndicator := '0070';
        --
        --
        DELETE
        FROM   xxmx_positions_f_stg
        WHERE  migration_set_id = pt_i_MigrationSetID;
        --
        --
        gvn_RowCount := SQL%ROWCOUNT;
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
            ,pt_i_ModuleMessage       => '  - Records purged from "xxmx_positions_f_stg" table: '
                                      ||gvn_RowCount
              ,pt_i_OracleError         => NULL
              );
        --
        --
        gvv_ProgressIndicator := '0080';
        --
        --
        DELETE
        FROM   xxmx_positions_f_tl_stg
        WHERE  migration_set_id = pt_i_MigrationSetID;
        --
        --
        gvn_RowCount := SQL%ROWCOUNT;
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
            ,pt_i_ModuleMessage       => '  - Records purged from "xxmx_positions_f_tl_stg" table: '
                                      ||gvn_RowCount
              ,pt_i_OracleError         => NULL
              );
        --
        --
        gvv_ProgressIndicator := '0110';
        --
        --
        DELETE
        FROM   xxmx_migration_details
        WHERE  migration_set_id = pt_i_MigrationSetID;
        --
        --
        gvn_RowCount := SQL%ROWCOUNT;
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
            ,pt_i_ModuleMessage       => '  - Records purged from "XXMX_MIGRATION_DETAILS" table: '
                                      ||gvn_RowCount
              ,pt_i_OracleError         => NULL
              );
        --
        --
        gvv_ProgressIndicator := '0120';
        --
        --
        DELETE
        FROM   xxmx_migration_headers
        WHERE  migration_set_id = pt_i_MigrationSetID;
        --
        --
        gvn_RowCount := SQL%ROWCOUNT;
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
            ,pt_i_ModuleMessage       => '  - Records purged from "XXMX_MIGRATION_HEADERS" table: '
                                      ||gvn_RowCount
              ,pt_i_OracleError         => NULL
              );
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
            ,pt_i_ModuleMessage       => '- Purging complete.'
              ,pt_i_OracleError         => NULL
              );
        --
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
END xxmx_kit_position_stg;

/
