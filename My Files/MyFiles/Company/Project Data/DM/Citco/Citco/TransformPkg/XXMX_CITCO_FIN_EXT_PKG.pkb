create or replace PACKAGE BODY xxmx_citco_fin_ext_pkg AS
--
/*
     ******************************************************************************
	 ** PURPOSE   : transform_coa_segments - this procedure transforms COA individual segments  
	 ******************************************************************************

*/
    PROCEDURE transform_coa_segments (
        pt_i_applicationsuite    IN xxmx_seeded_extensions.application_suite%TYPE,
        pt_i_application         IN xxmx_seeded_extensions.application%TYPE,
        pt_i_businessentity      IN xxmx_seeded_extensions.business_entity%TYPE,
        pt_i_stgpopulationmethod IN xxmx_core_parameters.parameter_value%TYPE,
        pt_i_filesetid           IN xxmx_migration_headers.file_set_id%TYPE,
        pt_i_migrationsetid      IN xxmx_migration_headers.migration_set_id%TYPE,
        pv_o_returnstatus        OUT VARCHAR2
    ) IS

        tablename        VARCHAR2(200);
        v_select_sql     VARCHAR2(350);
        v_mapping_sql    VARCHAR2(350);
        v_update_sql     VARCHAR2(350);
        v_rowid          VARCHAR2(200);
        v_segment1       VARCHAR2(100);
        v_segment3       VARCHAR2(100);--Added by sushma chowdary to set interco values to '122' where account_code is in '409109','409129','409137','409159','409199','409209','409298'(21/Jun/2023)
        v_segment2       VARCHAR2(100);
        v_segment5       VARCHAR2(100);
        v_segment1_name  VARCHAR2(100);
        v_segment2_name  VARCHAR2(100);
        v_segment3_name VARCHAR2(100);--Added by sushma chowdary to set interco values to '122' where account_code is in '409109','409129','409137','409159','409199','409209','409298'(21/Jun/2023)
        v_segment4_name  VARCHAR2(100);
        v_segment5_name  VARCHAR2(100);
        v_trans_segment1 VARCHAR2(100);
        v_table_name     VARCHAR2(250);
        l_account_type   VARCHAR2(1);
        l_location       VARCHAR2(250);
        l_gl_counts      NUMBER := 0;
        v_prc_bu_name    VARCHAR2(250);
        v_loc_segment1   VARCHAR2(60);
        v_deprn_exp_seg1 VARCHAR2(60);
        v_loc_segment4   VARCHAR2(60);
        l_loc_seg        VARCHAR2(60);
        l_count          NUMBER := 0;
        v_trans_segment5 VARCHAR2(60);
		v_trans_segment3 VARCHAR2(60); --Added by sushma chowdary to set interco values to '122' where account_code is in '409109','409129','409137','409159','409199','409209','409298'(20/Jun/2023)
        l_error_message  VARCHAR2(1200);
		l_IC_PL_count      NUMBER := 0;
		TYPE v_segments_record IS RECORD (
            rid      VARCHAR2(250),
            segment1 VARCHAR2(250),
            segment2 VARCHAR2(250),
			segment3 VARCHAR2(250),--Added by sushma chowdary to set interco values to '122' where account_code is in '409109','409129','409137','409159','409199','409209','409298'(21/Jun/2023)
            segment5 VARCHAR2(250)
        );
        TYPE v_mappings_record IS RECORD (
            input_code_1  VARCHAR2(250),
            output_code_1 VARCHAR2(250),
            output_code_2 VARCHAR2(250),
            output_code_3 VARCHAR2(250),
            output_code_4 VARCHAR2(250),
            output_code_5 VARCHAR(250)--Added by sushma chowdary to set interco values to '122' where account_code is in '409109','409129','409137','409159','409199','409209','409298'(21/Jun/2023)
        );
        TYPE v_segments_tbl IS
            TABLE OF v_segments_record INDEX BY BINARY_INTEGER;
        TYPE v_mappings_tbl IS
            TABLE OF v_mappings_record INDEX BY BINARY_INTEGER;
        v_segments_tb    v_segments_tbl := v_segments_tbl();
        v_mappings_tb    v_mappings_tbl := v_mappings_tbl();
    BEGIN
        BEGIN
--            dbms_output.enable(1000000);
--added OUTPUT_CODE_5 by sushma chowdary to set interco values to '122' where account_code is in '409109','409129','409137','409159','409199','409209','409298'(21/Jun/2023)
            v_mapping_sql := 'SELECT INPUT_CODE_1,OUTPUT_CODE_1 ,OUTPUT_CODE_2,OUTPUT_CODE_3,OUTPUT_CODE_4,OUTPUT_CODE_5   FROM    xxmx_mapping_master WHERE  application = :pt_i_application'
                             || ' AND CATEGORY_CODE ='
                             || '''COA_SEGMENTS'''
                             || '    AND  business_entity = :pt_i_businessentity ';
            EXECUTE IMMEDIATE v_mapping_sql
            BULK COLLECT
            INTO v_mappings_tb
                USING pt_i_application, pt_i_businessentity;
        EXCEPTION
            WHEN OTHERS THEN
                xxmx_fin_error_log_prc(
                                      NULL,
                                      sqlcode,
                                      'Error in getting the mapping details ' || sqlerrm
                );
                raise_application_error(
                                       -20111,
                                       'Error text :' || dbms_utility.format_error_backtrace
                );
        END;

        v_table_name := NULL;
        v_segment1_name := NULL;
        v_segment2_name := NULL;
		v_segment3_name := NULL;-- Added by sushma chowdary to set interco values to '122' where account_code is in '409109','409129','409137','409159','409199','409209','409298'(21/Jun/2023)
        v_segment4_name := NULL;
        v_segment5_name := NULL;
        FOR i IN 1..v_mappings_tb.count LOOP
            IF v_mappings_tb(i).input_code_1 IS NULL THEN
--                dbms_output.put_line('Error in Procedure xxmx_citco_fin_ext_pkg.transform_coa_segments no table mapping exists');
                NULL;
    ELSE
        v_table_name := v_mappings_tb(i).input_code_1;
        v_rowid := NULL;
        v_segment1 := NULL;
        v_segment2 := NULL;
		v_segment3 := NULL; --Added by sushma chowdary to set interco values to '122' where account_code is in '409109','409129','409137','409159','409199','409209','409298'(21/Jun/2023)
        v_segment5 := NULL;
        v_trans_segment1 := NULL;
        v_trans_segment5 := NULL;
		v_trans_segment3 := NULL; --Added by sushma chowdary to set interco values to '122' where account_code is in '409109','409129','409137','409159','409199','409209','409298'(20/Jun/2023)
        v_segment1_name := v_mappings_tb(i).output_code_1;
        v_segment2_name := v_mappings_tb(i).output_code_2;
		v_segment3_name := v_mappings_tb(i).output_code_5; --Added by sushma chowdary to set interco values to '122' where account_code is in '409109','409129','409137','409159','409199','409209','409298'(21/Jun/2023)
        v_segment4_name := v_mappings_tb(i).output_code_3;
        v_segment5_name := v_mappings_tb(i).output_code_4;
        v_select_sql := 'Select rowid,'
                        || v_segment1_name
                        || ','
                        || v_segment2_name
                        || ','
						|| v_segment3_name     --Added by sushma chowdary to set interco values to '122' where account_code is in '409109','409129','409137','409159','409199','409209','409298'(21/Jun/2023)a
						|| ','                  --Added by sushma chowdary to set interco values to '122' where account_code is in '409109','409129','409137','409159','409199','409209','409298'(21/Jun/2023)
                        || v_segment5_name
                        || ' from xxmx_xfm.'
                        || v_table_name
                        || ' WHERE MIGRATION_SET_ID = :PT_I_MIGRATIONSETID';

        EXECUTE IMMEDIATE v_select_sql
        BULK COLLECT
        INTO v_segments_tb
            USING pt_i_migrationsetid;
        FOR i IN 1..v_segments_tb.count LOOP
            BEGIN
                v_rowid := v_segments_tb(i).rid;
                v_segment1 := v_segments_tb(i).segment1;
                v_segment2 := v_segments_tb(i).segment2;
				v_segment3 := v_segments_tb(i).segment3;
                v_segment5 := v_segments_tb(i).segment5;
                SELECT
                    output_code_1
                INTO l_account_type
                FROM
                    xxmx_mapping_master
                WHERE
                    application_suite = 'FIN'
                    AND application = 'GL'
                    AND category_code = 'LOCATION'
                    AND input_code_1 = v_segment2;

            EXCEPTION
                WHEN OTHERS THEN
                    l_error_message := 'Error in getting account values from mapping master '
                                       || v_segment2
                                       || ' v_table_name '
                                       || v_table_name
                                       || sqlerrm;
                    xxmx_fin_error_log_prc(
                                          v_rowid,
                                          sqlcode,
                                          l_error_message
                    );
                    GOTO skip_update;
            END;

            BEGIN
                v_trans_segment1 := NULL;
                SELECT
                    output_code_1
                INTO v_trans_segment1
                FROM
                    xxmx_mapping_master
                WHERE
                    application_suite = 'FIN'
                    AND application = 'GL'
                    AND category_code = 'COMPANY'
                    AND input_code_1 = v_segment1;

            EXCEPTION
                WHEN OTHERS THEN
                    l_error_message := 'Error in getting company values from mapping master '
                                       || v_segment1
                                       || ' v_table_name '
                                       || v_table_name
                                       || sqlerrm;
                    xxmx_fin_error_log_prc(
                                          v_rowid,
                                          sqlcode,
                                          l_error_message
                    );
                    GOTO skip_update;
            END;

            BEGIN
                v_trans_segment5 := NULL;
				--IF v_segment5 != '0000'--commented by sushma chowdary to set the interco value to '0000' where account_code is in '081500','081600'(05/May/2023)
                IF v_segment5 != '0000' AND v_segment2 NOT IN ('081500','081600') THEN --added by sushma chowdary to set the interco value to '0000' where account_code is in '081500','081600'(05/May/2023)
                    SELECT
                        output_code_1
                    INTO v_trans_segment5
                    FROM
                        xxmx_mapping_master
                    WHERE
                        application_suite = 'FIN'
                        AND application = 'GL'
                        AND category_code = 'COMPANY'
                        AND input_code_1 = v_segment5;
				--added by sushma chowdary to set the interco value to '0000' where account_code is in '081500','081600'(05/May/2023)
				ELSIF v_segment2  IN ('081500','081600') THEN

					SELECT
                        output_code_1
                    INTO v_trans_segment5
                    FROM
                        xxmx_mapping_master
                    WHERE
                        application_suite = 'FIN'
                     --   AND application = 'GL'
                        AND category_code = 'BS_RULE_3'
                        AND input_code_1 = v_segment2;
				--End changes added by sushma chowdary to set the interco value to '0000' where account_code is in '081500','081600'(05/May/2023)
                END IF;


            EXCEPTION
                WHEN no_data_found THEN
                    v_trans_segment5 := v_segment5;
                WHEN OTHERS THEN
                    l_error_message := 'Error in getting company values from mapping master '
                                       || v_segment5
                                       || ' v_table_name '
                                       || v_table_name
                                       || sqlerrm;
                    xxmx_fin_error_log_prc(
                                          v_rowid,
                                          sqlcode,
                                          l_error_message
                    );
                    GOTO skip_update;
            END;
			--Added by sushma chowdary to set interco values to '122' where account_code is in '409109','409129','409137','409159','409199','409209','409298'(20/Jun/2023)
			BEGIN

				IF V_SEGMENT2 IN('409109','409129','409137','409159','409199','409209','409298') THEN 
					SELECT
                        output_code_1
                    INTO v_trans_segment3
                    FROM
                        xxmx_mapping_master
                    WHERE
                        application_suite = 'FIN'
                     --   AND application = 'GL'
                        AND category_code = 'PL_RULE_9'
                        AND input_code_1 = v_segment2;
				ELSE
					v_trans_segment3 := v_segment3;
				END IF;
			EXCEPTION
                WHEN no_data_found THEN
                    v_trans_segment3 := v_segment3;
                WHEN OTHERS THEN
                    l_error_message := 'Error in getting PL Rule 9 values from mapping master '
                                       || ' v_table_name '
                                       || v_table_name
                                       || sqlerrm;
                    xxmx_fin_error_log_prc(
                                          v_rowid,
                                          sqlcode,
                                          l_error_message
                    );
                    GOTO skip_update;
			END;
			--End changes Added by sushma chowdary to set interco values to '122' where account_code is in '409109','409129','409137','409159','409199','409209','409298'(20/Jun/2023)
            IF v_table_name = 'XXMX_SCM_PO_DISTRIBUTIONS_STD_XFM' THEN
                IF l_account_type IN ( 'A', 'L', 'O' ) THEN
                    l_location := '0000';
                ELSIF l_account_type IN ( 'E', 'R' ) THEN
                    BEGIN
                        v_prc_bu_name := NULL;
                        SELECT
                            poh.prc_bu_name
                        INTO v_prc_bu_name
                        FROM
                            xxmx_scm_po_distributions_std_xfm pdx,
                            xxmx_scm_po_headers_std_xfm       poh
                        WHERE
                            pdx.po_header_id = poh.po_header_id
                            AND pdx.rowid = v_rowid;

                    EXCEPTION
                        WHEN OTHERS THEN
                            l_error_message := 'Error in getting PRC_BU_NAME '
                                               || v_table_name
                                               || sqlerrm;
                            xxmx_fin_error_log_prc(
                                                  v_rowid,
                                                  sqlcode,
                                                  l_error_message
                            );
                            v_prc_bu_name := NULL;
                            GOTO skip_update;
                            end;
                            IF v_prc_bu_name IS NOT NULL THEN
                                BEGIN
                                    SELECT
                                        output_code_1
                                    INTO l_location
                                    FROM
                                        xxmx_mapping_master
                                    WHERE
                                        application_suite = 'SCM'
                                        AND application = 'PO'
                                        AND category_code = 'PO_LOCATION'
                                        AND upper(input_code_1) = upper(v_prc_bu_name);

                                EXCEPTION
                                    WHEN OTHERS THEN
                                        l_error_message := 'Error in getting PO_LOCATION from xxmx_mapping_master for BU  '
                                                           || v_prc_bu_name
                                                           || sqlerrm;
                                        xxmx_fin_error_log_prc(
                                                              v_rowid,
                                                              sqlcode,
                                                              l_error_message
                                        );
                                        GOTO skip_update;
                                END;
                            END IF;

                    END if;
                ELSIF v_table_name = 'XXMX_FA_MASS_ADDITION_DIST_XFM' THEN
                    BEGIN
                        v_loc_segment1 := NULL;
                        v_deprn_exp_seg1 := NULL;
                        v_loc_segment4 := NULL;
                        SELECT
                            xfad.location_segment1,
                            xfad.deprn_expense_segment1,
                            xfad.location_segment4
                        INTO
                            v_loc_segment1,
                            v_deprn_exp_seg1,
                            v_loc_segment4
                        FROM
                            xxmx_fa_mass_addition_dist_xfm xfad
                        WHERE
                            xfad.rowid = v_rowid;

                    EXCEPTION
                        WHEN OTHERS THEN
                            l_error_message := 'Error in getting values LOCATION_SEGMENT1,DEPRN_EXPENSE_SEGMENT1,LOCATION_SEGMENT4  from table '
                                               || v_table_name
                                               || sqlerrm;
                            xxmx_fin_error_log_prc(
                                                  v_rowid,
                                                  sqlcode,
                                                  l_error_message
                            );
                            v_loc_segment1 := NULL;
                            GOTO skip_update;
                    END;

                    SELECT
                        COUNT(1)
                    INTO l_count
                    FROM
                        xxmx_mapping_master
                    WHERE
                        application_suite = 'FIN'
                        AND application = 'FA'
                        AND category_code = 'FA_LOC_SEGMENT'
                        AND upper(input_code_1) = upper(v_deprn_exp_seg1);

                    IF
                        l_count != 0
                        AND v_loc_segment1 IS NOT NULL
                    THEN
                        SELECT
                            output_code_1
                        INTO l_loc_seg
                        FROM
                            xxmx_mapping_master
                        WHERE
                            application_suite = 'FIN'
                            AND application = 'FA'
                            AND category_code = 'FA_LOC_SEGMENT'
                            AND upper(input_code_1) = upper(v_deprn_exp_seg1);

                        IF l_loc_seg = v_loc_segment1 THEN
                            SELECT
                                output_code_1
                            INTO l_location
                            FROM
                                xxmx_mapping_master
                            WHERE
                                application_suite = 'FIN'
                                AND application = 'FA'
                                AND category_code = 'FA_LOCATION_MAPPING'
                                AND upper(input_code_1) = upper(v_loc_segment4);

                        ELSE
                            SELECT
                                output_code_2
                            INTO l_location
                            FROM
                                xxmx_mapping_master
                            WHERE
                                application_suite = 'FIN'
                                AND application = 'FA'
                                AND category_code = 'FA_LOC_SEGMENT'
                                AND upper(input_code_1) = upper(v_deprn_exp_seg1);

                        END IF;

                    ELSE
                        IF l_account_type IN ( 'A', 'L', 'O' ) THEN
                            l_location := '0000';
                        ELSIF l_account_type IN ( 'E', 'R' ) THEN
                            SELECT
                                output_code_2
                            INTO l_location
                            FROM
                                xxmx_mapping_master
                            WHERE
                                application_suite = 'FIN'
                                AND application = 'GL'
                                AND category_code = 'COMPANY'
                                AND input_code_1 = v_segment1;

                        ELSE
                            l_location := 'Location Value not defined in the master';
                            xxmx_fin_error_log_prc(
                                                  v_rowid,
                                                  sqlcode,
                                                  l_location
                            );
                            GOTO skip_update;
                        END IF;
                    END IF;

                ELSE
                    IF l_account_type IN ( 'A', 'L', 'O' ) THEN
                        l_location := '0000';
                    ELSIF l_account_type IN ( 'E', 'R' ) THEN
                        SELECT
                            output_code_2
                        INTO l_location
                        FROM
                            xxmx_mapping_master
                        WHERE
                            application_suite = 'FIN'
                            AND application = 'GL'
                            AND category_code = 'COMPANY'
                            AND input_code_1 = v_segment1;

                    ELSE
                        l_location := 'Location Value not defined in the master';
                        xxmx_fin_error_log_prc(
                                              v_rowid,
                                              sqlcode,
                                              l_location
                        );
                        GOTO skip_update;
                    END IF;
                END IF;

                BEGIN
                    IF v_segment2 IS NOT NULL THEN
                        SELECT
                            COUNT(1)
                        INTO l_ic_pl_count
                        FROM
                            xxmx_mapping_master
                        WHERE
                            category_code = 'IC_PL_ACCOUNTS'
                            AND input_code_1 = v_segment2;

                        IF l_ic_pl_count >= 1 THEN
                            l_location := '0000';
                        END IF;
                    END IF;

                EXCEPTION
                    WHEN OTHERS THEN
                        l_error_message := 'Error in getting the mappings for Intercompany and PL accounts  from table '
                                           || v_table_name
                                           || sqlerrm;
                        xxmx_fin_error_log_prc(
                                              v_rowid,
                                              sqlcode,
                                              l_error_message
                        );
                        l_ic_pl_count := 0;
                        GOTO skip_update;
                        end;
                        BEGIN
                            v_update_sql := 'UPDATE xxmx_xfm.'
                                            || v_table_name
                                            || ' SET '
                                            || v_segment4_name
                                            || '= :l_location, '
                                            || v_segment1_name
                                            || '= :v_trans_segment1, '
											|| v_segment3_name                       --Added by sushma chowdary to set interco values to '122' where account_code is in '409109','409129','409137','409159','409199','409209','409298'(20/Jun/2023)
                                            || '= :v_trans_segment3, '               --Added by sushma chowdary to set interco values to '122' where account_code is in '409109','409129','409137','409159','409199','409209','409298'(20/Jun/2023)
                                            || v_segment5_name
                                            || '= :v_trans_segment5 WHERE rowid = :v_rowid and MIGRATION_SET_ID= :PT_I_MIGRATIONSETID';

                            EXECUTE IMMEDIATE v_update_sql
                                USING l_location, v_trans_segment1,v_trans_segment3, nvl(  
                                                                       v_trans_segment5,
                                                                       '0000'
                                                                    ), v_rowid, pt_i_migrationsetid;

                        EXCEPTION
                            WHEN OTHERS THEN
                                l_error_message := 'Error in updating location values '
                                                   || sqlerrm
                                                   || v_update_sql;
                                xxmx_fin_error_log_prc(
                                                      v_rowid,
                                                      sqlcode,
                                                      l_error_message
                                );
                                GOTO skip_update;
                        END;

                END loop;

                pv_o_returnstatus := 'S';
        --
                COMMIT;
                << skip_update >> ROLLBACK;
            END IF;

        END LOOP;

    EXCEPTION
        WHEN OTHERS THEN

                --
            ROLLBACK;
            xxmx_fin_error_log_prc(
                                  NULL,
                                  sqlcode,
                                  'Error in Procedure xxmx_citco_fin_ext_pkg.transform_coa_segments'
                                  || sqlerrm
                                  || 'Error text :'
                                  || dbms_utility.format_error_backtrace
            );
--            dbms_output.put_line('Error in Procedure xxmx_citco_fin_ext_pkg.transform_coa_segments');
--            dbms_output.put_line('Error Message :' || sqlerrm);
--            dbms_output.put_line('Error text :' || dbms_utility.format_error_backtrace);
            raise_application_error(
                                   -20111,
                                   'Error text :' || dbms_utility.format_error_backtrace
            );
    END transform_coa_segments;
--
/*
     ******************************************************************************
	 ** PURPOSE   : transform_code_combo - this procedure transforms code combination values 
	 ******************************************************************************

*/
    PROCEDURE transform_code_combo (
        pt_i_applicationsuite    IN xxmx_seeded_extensions.application_suite%TYPE,
        pt_i_application         IN xxmx_seeded_extensions.application%TYPE,
        pt_i_businessentity      IN xxmx_seeded_extensions.business_entity%TYPE,
        pt_i_stgpopulationmethod IN xxmx_core_parameters.parameter_value%TYPE,
        pt_i_filesetid           IN xxmx_migration_headers.file_set_id%TYPE,
        pt_i_migrationsetid      IN xxmx_migration_headers.migration_set_id%TYPE,
        pv_o_returnstatus        OUT VARCHAR2
    ) IS

        tablename       VARCHAR2(200);
        v_select_sql    VARCHAR2(350);
        v_mapping_sql   VARCHAR2(350);
        v_update_sql    VARCHAR2(350);
        v_rowid         VARCHAR2(200);
        v_segment1      VARCHAR2(100);
        v_segment2      VARCHAR2(100);
        v_segment3      VARCHAR2(100);
        v_segment4      VARCHAR2(100);
        v_segment5      VARCHAR2(100);
        v_segment6      VARCHAR2(100);
        v_segment7      VARCHAR2(100);
        v_tr_segment4   VARCHAR2(100);
        v_tr_segment1   VARCHAR2(100);
        v_tr_segment6   VARCHAR2(100);
        v_tr_segment7   VARCHAR2(100);
        v_tr_segment5   VARCHAR2(100);
        v_tr_code_combo VARCHAR2(250);
        v_table_name    VARCHAR2(250);
        l_account_type  VARCHAR2(1);
        l_location      VARCHAR2(250);
        l_gl_counts     NUMBER := 0;
		l_IC_PL_count     NUMBER := 0;
        l_error_message VARCHAR2(1200);
        TYPE v_segments_record IS RECORD (
            rid               VARCHAR2(250),
            code_combinations VARCHAR2(250)
        );
        TYPE v_mappings_record IS RECORD (
            input_code_1  VARCHAR2(250),
            output_code_1 VARCHAR2(250)
        );
        TYPE v_segments_tbl IS
            TABLE OF v_segments_record INDEX BY BINARY_INTEGER;
        TYPE v_mappings_tbl IS
            TABLE OF v_mappings_record INDEX BY BINARY_INTEGER;
        v_segments_tb   v_segments_tbl := v_segments_tbl();
        v_mappings_tb   v_mappings_tbl := v_mappings_tbl();
    BEGIN
        BEGIN
--            dbms_output.enable(1000000);
            v_mapping_sql := 'SELECT INPUT_CODE_1,OUTPUT_CODE_1    FROM    xxmx_mapping_master WHERE  application =:pt_i_application '
                             || ' AND CATEGORY_CODE ='
                             || '''CODE_COMBINATIONS'''
                             || '    AND  business_entity = :pt_i_businessentity ';
            EXECUTE IMMEDIATE v_mapping_sql
            BULK COLLECT
            INTO v_mappings_tb
                USING pt_i_application, pt_i_businessentity;
        EXCEPTION
            WHEN OTHERS THEN
                xxmx_fin_error_log_prc(
                                      NULL,
                                      sqlcode,
                                      'Error in getting the mapping details for code combinations' || sqlerrm
                );
                raise_application_error(
                                       -20111,
                                       'Error text :' || dbms_utility.format_error_backtrace
                );
        END;

        FOR i IN 1..v_mappings_tb.count LOOP
            IF v_mappings_tb(i).input_code_1 IS NULL THEN
                dbms_output.put_line('Error in Procedure xxmx_citco_fin_ext_pkg.transform_code_combo no table mapping exists');
            ELSE
                BEGIN

                 v_select_sql := 'Select rowid,'
                                    || v_mappings_tb(i).output_code_1
                                    || ' from xxmx_xfm.'
                                    || v_mappings_tb(i).input_code_1
                                    || ' WHERE MIGRATION_SET_ID = :PT_I_MIGRATIONSETID';

                    EXECUTE IMMEDIATE v_select_sql
                    BULK COLLECT
                    INTO v_segments_tb
                        USING pt_i_migrationsetid;
                EXCEPTION
                    WHEN OTHERS THEN
                        xxmx_fin_error_log_prc(
                                              NULL,
                                              sqlcode,
                                              'Error in getting code Combination details ' || sqlerrm
                        );
                        raise_application_error(
                                               -20111,
                                               'Error text :' || dbms_utility.format_error_backtrace
                        );
                END;

                FOR j IN 1..v_segments_tb.count LOOP
                    BEGIN
                        v_segment1 := NULL;
                        v_segment2 := NULL;
                        v_segment3 := NULL;
                        v_segment4 := NULL;
                        v_segment5 := NULL;
                        v_segment6 := NULL;
                        v_segment7 := NULL;
                        v_tr_segment4 := NULL;
                        v_tr_segment1 := NULL;
                        v_tr_segment6 := NULL;
                        v_tr_segment7 := NULL;
                        v_tr_segment5 := NULL;
                        BEGIN
                            SELECT
                                nvl(
                                    regexp_substr(
                                        v_segments_tb(j).code_combinations, '[^.]+', 1, 1
                                    ), '-'
                                ),
                                nvl(
                                    regexp_substr(
                                        v_segments_tb(j).code_combinations, '[^.]+', 1, 2
                                    ), '-'
                                ),
                                nvl(
                                    regexp_substr(
                                        v_segments_tb(j).code_combinations, '[^.]+', 1, 3
                                    ), '-'
                                ),
                                nvl(
                                    regexp_substr(
                                        v_segments_tb(j).code_combinations, '[^.]+', 1, 4
                                    ), '-'
                                ),
                                nvl(
                                    regexp_substr(
                                        v_segments_tb(j).code_combinations, '[^.]+', 1, 5
                                    ), '-'
                                ),
                                nvl(
                                    regexp_substr(
                                        v_segments_tb(j).code_combinations, '[^.]+', 1, 6
                                    ), '-'
                                ),
                                nvl(
                                    regexp_substr(
                                        v_segments_tb(j).code_combinations, '[^.]+', 1, 7
                                    ), '-'
                                )
                            INTO
                                v_segment1,
                                v_segment2,
                                v_segment3,
                                v_segment4,
                                v_segment5,
                                v_segment6,
                                v_segment7
                            FROM
                                dual;

                        EXCEPTION
                            WHEN OTHERS THEN
                                xxmx_fin_error_log_prc(
                                                      v_segments_tb(j).rid,
                                                      sqlcode,
                                                      'Error in getting individual segment details for table:  '
                                                      || v_mappings_tb(i).input_code_1
                                                      || ' column: '
                                                      || v_mappings_tb(i).output_code_1
                                );
--                                dbms_output.put_line('Error in getting individual segment details for table:  '
--                                                     || v_mappings_tb(i).input_code_1
--                                                     || ' rowid: '
--                                                     || v_segments_tb(j).rid
--                                                     || ' column: '
--                                                     || v_mappings_tb(i).output_code_1);

                                raise_application_error(
                                                       -20111,
                                                       'Error text :' || dbms_utility.format_error_backtrace
                                );
                        END;

                        IF v_segment1 = '-' THEN
                            l_error_message := 'Error in getting account values from mapping master '
                                               || v_mappings_tb(i).input_code_1
                                               || ' column: '
                                               || v_mappings_tb(i).output_code_1;

                            xxmx_fin_error_log_prc(
                                                  v_segments_tb(j).rid,
                                                  sqlcode,
                                                  l_error_message
                            );
                            GOTO skip_update;
                        ELSIF
                            v_segment1 IS NOT NULL
                            AND v_segment7 = '-'
                        THEN
                            BEGIN
                                SELECT
                                    output_code_1
                                INTO v_tr_segment1
                                FROM
                                    xxmx_mapping_master
                                WHERE
                                    application_suite = 'FIN'
                                    AND application = 'GL'
                                    AND category_code = 'COMPANY'
                                    AND input_code_1 = v_segment1;

                            EXCEPTION
                                WHEN OTHERS THEN
                                    xxmx_fin_error_log_prc(
                                                          v_segments_tb(j).rid,
                                                          sqlcode,
                                                          'Error in getting xxmx_mapping_master company value' || sqlerrm
                                    );
                                    raise_application_error(
                                                           -20111,
                                                           'Error text :' || dbms_utility.format_error_backtrace
                                    );
                            END;

                            BEGIN
                                SELECT
                                    CASE (
                                        SELECT
                                            output_code_1
                                        FROM
                                            xxmx_mapping_master
                                        WHERE
                                            application_suite = 'FIN'
                                            AND application = 'GL'
                                            AND category_code = 'LOCATION'
                                            AND input_code_1 = v_segment2
                                    )
                                    WHEN 'A'  THEN
                                    '0000'
                                    WHEN 'L'  THEN
                                    '0000'
                                    WHEN 'O'  THEN
                                    '0000'
                                    WHEN 'E'  THEN
                                    (
                                        SELECT
                                            output_code_2
                                        FROM
                                            xxmx_mapping_master
                                        WHERE
                                            application_suite = 'FIN'
                                            AND application = 'GL'
                                            AND category_code = 'COMPANY'
                                            AND input_code_1 = v_segment1
                                    )
                                    WHEN 'R'  THEN
                                    (
                                        SELECT
                                            output_code_2
                                        FROM
                                            xxmx_mapping_master
                                        WHERE
                                            application_suite = 'FIN'
                                            AND application = 'GL'
                                            AND category_code = 'COMPANY'
                                            AND input_code_1 = v_segment1
                                    )
                                    WHEN NULL THEN
                                    'Please define Mapping'
                                    END
                                INTO v_tr_segment4
                                FROM
                                    dual;

                                BEGIN
                                    IF v_segment5 != '0000' THEN
                                        SELECT
                                            output_code_1
                                        INTO v_tr_segment5
                                        FROM
                                            xxmx_mapping_master
                                        WHERE
                                            application_suite = 'FIN'
                                            AND application = 'GL'
                                            AND category_code = 'COMPANY'
                                            AND input_code_1 = v_segment5;

                                    END IF;

                                EXCEPTION
                                    WHEN no_data_found THEN
                                        v_tr_segment5:=v_segment5;
                                    WHEN OTHERS THEN
                                        l_error_message := 'Error in getting company values from mapping master '
                                                           || v_segment5
                                                           || ' v_table_name '
                                                           || v_table_name
                                                           || sqlerrm;
                                        xxmx_fin_error_log_prc(
                                                              v_segments_tb(j).rid,
                                                              sqlcode,
                                                              l_error_message
                                        );
                                        GOTO skip_update;
                                END;

                            EXCEPTION
                                WHEN OTHERS THEN
                                    l_error_message := 'Error in getting location details ' || sqlerrm;
                                    xxmx_fin_error_log_prc(
                                                          v_segments_tb(j).rid,
                                                          sqlcode,
                                                          l_error_message
                                    );
                                    GOTO skip_update;
                            END;
								BEGIN
								IF v_segment2 IS NOT NULL
					THEN
					select count(1) 
					into l_IC_PL_count  
					from xxmx_mapping_master 
					where category_code='IC_PL_ACCOUNTS' 
					and INPUT_CODE_1=v_segment2;

					IF l_IC_PL_count>=1 THEN
					v_tr_segment4:='0000';
					END IF;
					END IF;
					EXCEPTION
                            WHEN OTHERS THEN
                                l_error_message := 'Error in getting the mappings for Intercompany and PL accounts  from table '
                                                   || v_table_name
                                                   || sqlerrm;
                                xxmx_fin_error_log_prc(
                                                      v_rowid,
                                                      sqlcode,
                                                      l_error_message
                                );
                                l_IC_PL_count := 0;
								v_tr_segment4:=NULL;
                                GOTO skip_update;

					END;

                            v_tr_segment7 := v_segment6;
                            v_tr_segment6 := '0000000';
                            v_tr_code_combo := v_tr_segment1
                                               || '.'
                                               || v_segment2
                                               || '.'
                                               || v_segment3
                                               || '.'
                                               || v_tr_segment4
                                               || '.'
                                               || nvl(
                                                     v_tr_segment5,
                                                     v_segment5
                                                  )
                                               || '.'
                                               || v_tr_segment6
                                               || '.'
                                               || v_tr_segment7;

                        ELSE
                            xxmx_fin_error_log_prc(
                                                  v_segments_tb(j).rid,
                                                  sqlcode,
                                                  'The segments are not in right state to transform'
                            );
--                            dbms_output.put_line('The segments are not in right state to transform');
                        END IF;

                    EXCEPTION
                        WHEN OTHERS THEN
                            l_error_message := 'Error in defining code combinations for table: '
                                               || v_mappings_tb(i).input_code_1
                                               || ' column: '
                                               || v_mappings_tb(i).output_code_1;

                            xxmx_fin_error_log_prc(
                                                  v_segments_tb(j).rid,
                                                  sqlcode,
                                                  l_error_message
                            );
                            GOTO skip_update;
                    END;

                    BEGIN
                        v_update_sql := 'UPDATE xxmx_xfm.'
                                        || v_mappings_tb(i).input_code_1
                                        || ' SET '
                                        || v_mappings_tb(i).output_code_1
                                        || '  =:v_tr_code_combo WHERE rowid = :v_rowid and MIGRATION_SET_ID= :PT_I_MIGRATIONSETID';

                        EXECUTE IMMEDIATE v_update_sql
                            USING v_tr_code_combo, v_segments_tb(j).rid, pt_i_migrationsetid;
                    EXCEPTION
                        WHEN OTHERS THEN
                            xxmx_fin_error_log_prc(
                                                  v_segments_tb(j).rid,
                                                  sqlcode,
                                                  'Error in updating table  '
                                                  || v_mappings_tb(i).input_code_1
                                                  || ' column: '
                                                  || v_mappings_tb(i).output_code_1
                                                  || ' Code combination value: '
                                                  || v_tr_code_combo
                            );
--                            dbms_output.put_line('Error in updating table  '
--                                                 || v_mappings_tb(i).input_code_1
--                                                 || ' rowid: '
--                                                 || v_segments_tb(j).rid
--                                                 || ' column: '
--                                                 || v_mappings_tb(i).output_code_1
--                                                 || ' Code combination value: '
--                                                 || v_tr_code_combo);
                    END;

                END LOOP;

                COMMIT;
                << skip_update >> ROLLBACK;
            END IF;
        END LOOP;

    EXCEPTION
        WHEN OTHERS THEN
            v_table_name := NULL;
            xxmx_fin_error_log_prc(
                                  NULL,
                                  sqlcode,
                                  'Error in Procedure xxmx_citco_fin_ext_pkg.transform_code_combo'
                                  || sqlerrm
                                  || 'Error text :'
                                  || dbms_utility.format_error_backtrace
            );
--            dbms_output.put_line('Error in Procedure xxmx_citco_fin_ext_pkg.transform_code_combo');
--            dbms_output.put_line('Error Message :' || sqlerrm);
--            dbms_output.put_line('Error text :' || dbms_utility.format_error_backtrace);
            raise_application_error(
                                   -20111,
                                   'Error text :' || dbms_utility.format_error_backtrace
            );
    END transform_code_combo;
--
/*
     ******************************************************************************
	 ** PURPOSE   : transform_gl_ref_code - this procedure transforms reference21 values in GL xfm tables
	 ******************************************************************************

*/
    PROCEDURE transform_gl_ref_code (
        pt_i_applicationsuite    IN xxmx_seeded_extensions.application_suite%TYPE,
        pt_i_application         IN xxmx_seeded_extensions.application%TYPE,
        pt_i_businessentity      IN xxmx_seeded_extensions.business_entity%TYPE,
        pt_i_stgpopulationmethod IN xxmx_core_parameters.parameter_value%TYPE,
        pt_i_filesetid           IN xxmx_migration_headers.file_set_id%TYPE,
        pt_i_migrationsetid      IN xxmx_migration_headers.migration_set_id%TYPE,
        pv_o_returnstatus        OUT VARCHAR2
    ) IS
    BEGIN
        UPDATE xxmx_gl_opening_balances_xfm
        SET
            reference21 = reference10,
            reference22 = reference10,
            segment6    = '0000000',
            segment7    = '0000'
        WHERE
            migration_set_id = pt_i_migrationsetid;

        UPDATE xxmx_gl_summary_balances_xfm
        SET
            reference21 = reference10,
            reference22 = reference10,
            segment6    = '0000000',
            segment7    = '0000'
        WHERE
            migration_set_id = pt_i_migrationsetid;

    /* Added on 23-Aug-22*/
        UPDATE xxmx_gl_detail_balances_xfm
        SET
            reference21 = reference10,
            reference22 = global_attribute20,
            reference23 = global_attribute19,
            segment6    = '0000000',
            segment7    = '0000'
        WHERE
            migration_set_id = pt_i_migrationsetid;

        UPDATE xxmx_gl_detail_balances_xfm
        SET
            global_attribute19 = NULL,
            global_attribute20 = NULL
        WHERE
            migration_set_id = pt_i_migrationsetid;
    /* End of addition on 23-Aug-22*/

       UPDATE xxmx_gl_historicalrates_xfm
        SET
            credit_amount_rate = ((credit_amount_rate)*-1),
            segment6    = '0000000',
            segment7    = '0000'
        WHERE
            migration_set_id = pt_i_migrationsetid;

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            raise_application_error(
                                   -20111,
                                   'Error text :' || dbms_utility.format_error_backtrace
            );
    END transform_gl_ref_code;
--
/*
     ******************************************************************************
	 ** PURPOSE   : transform_sup_bank_branches - this procedure transforms supplier bank & branch details
	 ******************************************************************************

*/
    PROCEDURE transform_sup_bank_branches (
        pt_i_applicationsuite    IN xxmx_seeded_extensions.application_suite%TYPE,
        pt_i_application         IN xxmx_seeded_extensions.application%TYPE,
        pt_i_businessentity      IN xxmx_seeded_extensions.business_entity%TYPE,
        pt_i_subentity           IN xxmx_seeded_extensions.business_entity%TYPE,
        pt_i_stgpopulationmethod IN xxmx_core_parameters.parameter_value%TYPE,
        pt_i_filesetid           IN xxmx_migration_headers.file_set_id%TYPE,
        pt_i_migrationsetid      IN xxmx_migration_headers.migration_set_id%TYPE,
        pv_o_returnstatus        OUT VARCHAR2
    ) IS

        v_select_sql          VARCHAR2(250);
        v_update_sql          VARCHAR2(250);
        v_rowid               VARCHAR2(200);
        l_bank_name           VARCHAR2(250);
        l_bank_branch         VARCHAR2(250);
        l_bank_branch_country VARCHAR2(100);
        v_table_name          VARCHAR2(250);
        l_account_type        VARCHAR2(1);
        l_location            VARCHAR2(250);
        l_gl_counts           NUMBER := 0;
        TYPE v_banks_record IS RECORD (
            rid                   VARCHAR2(250),
            v_bank_name           VARCHAR2(250),
            v_bank_branch         VARCHAR2(250),
            v_bank_branch_country VARCHAR2(250)
        );
        TYPE v_banks_tbl IS
            TABLE OF v_banks_record INDEX BY BINARY_INTEGER;
        v_banks_tb            v_banks_tbl := v_banks_tbl();
    BEGIN
        BEGIN
            SELECT
                xfm_table
            INTO v_table_name
            FROM
                xxmx_migration_metadata
            WHERE
                business_entity = pt_i_businessentity
                AND sub_entity = pt_i_subentity;

        EXCEPTION
            WHEN OTHERS THEN
                v_table_name := NULL;
                xxmx_fin_error_log_prc(
                                      NULL,
                                      sqlcode,
                                      'Error in Procedure xxmx_citco_fin_ext_pkg.transform_sup_bank_branches'
                                      || sqlerrm
                                      || 'Error text :'
                                      || dbms_utility.format_error_backtrace
                );
--                dbms_output.put_line('Error in Procedure xxmx_citco_ap_ext_pkg.transform_sup_bank_branches');
--                dbms_output.put_line('Error Message :' || sqlerrm);
--                dbms_output.put_line('Error text :' || dbms_utility.format_error_backtrace);
                raise_application_error(
                                       -20111,
                                       'Error text :' || dbms_utility.format_error_backtrace
                );
        END;

        IF v_table_name IS NULL THEN
            dbms_output.put_line('Error in Procedure xxmx_citco_ap_ext_pkg.transform_sup_bank_branches no table mapping exists');
        ELSE
            v_select_sql := 'Select rowid,bank_Name,BRANCH_NAME,COUNTRY_CODE from xxmx_xfm.'
                            || v_table_name
                            || ' WHERE MIGRATION_SET_ID = :PT_I_MIGRATIONSETID';
            EXECUTE IMMEDIATE v_select_sql
            BULK COLLECT
            INTO v_banks_tb
                USING pt_i_migrationsetid;
            FOR i IN 1..v_banks_tb.count LOOP
                BEGIN
                    SELECT
                        xmm.output_code_1,
                        xmm.output_code_2,
                        xmm.output_code_3
                    INTO
                        l_bank_name,
                        l_bank_branch,
                        l_bank_branch_country
                    FROM
                        xxmx_mapping_master xmm
                    WHERE
                        xmm.application = 'AP'
                        AND xmm.business_entity = 'SUPPLIERS'
                        AND xmm.sub_entity = 'SUPPLIER_BANK_ACCOUNTS'
                        AND upper(
                            xmm.input_code_1
                        ) = upper(v_banks_tb(i).v_bank_name
                                  || '|'
                                  || v_banks_tb(i).v_bank_branch
                                  || '|'
                                  || v_banks_tb(i).v_bank_branch_country)
                        AND ROWNUM = 1;

                EXCEPTION
                    WHEN OTHERS THEN
                   /*     xxmx_fin_error_log_prc(
                                              v_banks_tb(i).rid,
                                              sqlcode,
                                              sqlerrm
                                              || '      '
                                              || v_banks_tb(i).v_bank_name
                                              || '|'
                                              || v_banks_tb(i).v_bank_branch
                                              || '|'
                                              || v_banks_tb(i).v_bank_branch_country
                        );*/
                        l_bank_name := v_banks_tb(i).v_bank_name;
                        l_bank_branch := v_banks_tb(i).v_bank_branch;
                        l_bank_branch_country := v_banks_tb(i).v_bank_branch_country; 
                        xxmx_fin_error_log_prc(
                                              v_banks_tb(i).rid,
                                              sqlcode,
                                              'Error in getting account values from mapping master so copying existing values '
                                              || ' Bank Name value: '
                                              || l_bank_name
                                              || ' Bank Branch value: '
                                              || l_bank_branch
                                              || ' Branch country  value: '
                                              || l_bank_branch_country
                        );                        
--                        dbms_output.put_line(sqlerrm
--                                             || '      '
--                                             || v_banks_tb(i).v_bank_name
--                                             || '|'
--                                             || v_banks_tb(i).v_bank_branch
--                                             || '|'
--                                             || v_banks_tb(i).v_bank_branch_country);

--                        dbms_output.put_line('Error in getting account values from mapping master v_banks_tb(i).rid: '
--                                             || v_banks_tb(i).rid
--                                             || ' Bank Name value: '
--                                             || l_bank_name
--                                             || ' Bank Branch value: '
--                                             || l_bank_branch
--                                             || ' Branch country  value: '
--                                             || l_bank_branch_country);

                END;

                /*IF
                    l_bank_name IS NOT NULL
                    AND l_bank_branch IS NOT NULL
                    AND l_bank_branch_country IS NOT NULL
                THEN*/
                    BEGIN
                        v_update_sql := 'UPDATE xxmx_xfm.'
                                        || v_table_name
                                        || ' SET bank_Name=:l_bank_name,BRANCH_NAME=:l_bank_branch,COUNTRY_CODE=:l_bank_branch_COUNTRY WHERE rowid = :v_rowid and MIGRATION_SET_ID= :PT_I_MIGRATIONSETID';
                        EXECUTE IMMEDIATE v_update_sql
                            USING l_bank_name, l_bank_branch, l_bank_branch_country, v_banks_tb(i).rid, pt_i_migrationsetid;

                        dbms_output.put_line('updated bank values for v_banks_tb(i).rid: '
                                             || v_banks_tb(i).rid
                                             || ' Bank Name value: '
                                             || l_bank_name
                                             || ' Bank Branch value: '
                                             || l_bank_branch
                                             || ' Branch country  value: '
                                             || l_bank_branch_country);

                    EXCEPTION
                        WHEN OTHERS THEN
                            xxmx_fin_error_log_prc(
                                                  v_banks_tb(i).rid,
                                                  sqlcode,
                                                  'Error in updating location values'
                            );
--                            dbms_output.put_line('Error in updating location values for v_banks_tb(i).rid: ' || v_banks_tb(i).rid
--                            );
                    END;

               /* ELSE
                    xxmx_fin_error_log_prc(
                                          v_banks_tb(i).rid,
                                          sqlcode,
                                          'Bank values not updated'
                                          || ' Bank Name value: '
                                          || l_bank_name
                                          || ' Bank Branch value: '
                                          || l_bank_branch
                                          || ' Branch country  value: '
                                          || l_bank_branch_country
                    );
--                    dbms_output.put_line('Bank values not updated for v_banks_tb(i).rid: '
--                                         || v_banks_tb(i).rid
--                                         || ' Bank Name value: '
--                                         || l_bank_name
--                                         || ' Bank Branch value: '
--                                         || l_bank_branch
--                                         || ' Branch country  value: '
--                                         || l_bank_branch_country);
                END IF;*/

            END LOOP;
        --

        END IF;

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN

                --
            ROLLBACK;
            xxmx_fin_error_log_prc(
                                  NULL,
                                  sqlcode,
                                  'Error in Procedure xxmx_citco_fin_ext_pkg.transform_sup_bank_branches'
                                  || sqlerrm
                                  || 'Error text :'
                                  || dbms_utility.format_error_backtrace
            );
--            dbms_output.put_line('Error in Procedure xxmx_citco_ap_ext_pkg.transform_sup_bank_branches');
--            dbms_output.put_line('Error Message :' || sqlerrm);
--            dbms_output.put_line('Error text :' || dbms_utility.format_error_backtrace);
            raise_application_error(
                                   -20111,
                                   'Error text :' || dbms_utility.format_error_backtrace
            );
    END transform_sup_bank_branches;

	/*
     ******************************************************************************
	 ** PURPOSE   : transform_gl_ref_code - this procedure transforms reference21 values in GL xfm tables
	 ******************************************************************************

*/
    PROCEDURE transform_gl_ledgers (
        pt_i_applicationsuite    IN xxmx_seeded_extensions.application_suite%TYPE,
        pt_i_application         IN xxmx_seeded_extensions.application%TYPE,
        pt_i_businessentity      IN xxmx_seeded_extensions.business_entity%TYPE,
        pt_i_stgpopulationmethod IN xxmx_core_parameters.parameter_value%TYPE,
        pt_i_filesetid           IN xxmx_migration_headers.file_set_id%TYPE,
        pt_i_migrationsetid      IN xxmx_migration_headers.migration_set_id%TYPE,
        pv_o_returnstatus        OUT VARCHAR2
    ) IS
        /*v_old_ledger_name VARCHAR2(250);
        v_new_ledger_name VARCHAR2(250);
        v_new_ledger_id   NUMBER;
    BEGIN
        SELECT
            input_code_1,
            output_code_1,
            output_code_3
        INTO
            v_old_ledger_name,
            v_new_ledger_name,
            v_new_ledger_id
        FROM
            xxmx_mapping_master
        WHERE
            category_code = 'COA_LEDGER_MAPPING'
            AND application = 'GL'
            AND OUTPUT_CODE_3 is not null ;

        UPDATE xxmx_gl_opening_balances_xfm
        SET
            ledger_id = v_new_ledger_id,
            ledger_name = v_new_ledger_name
        WHERE
            migration_set_id = pt_i_migrationsetid
            AND segment1 = '2430'
            AND ledger_name = v_old_ledger_name;

        UPDATE xxmx_gl_summary_balances_xfm
        SET
            ledger_id = v_new_ledger_id,
            ledger_name = v_new_ledger_name
        WHERE
            migration_set_id = pt_i_migrationsetid
            AND segment1 = '2430'
            AND ledger_name = v_old_ledger_name;

        UPDATE xxmx_gl_detail_balances_xfm
        SET
            ledger_id = v_new_ledger_id,
            ledger_name = v_new_ledger_name
        WHERE
            migration_set_id = pt_i_migrationsetid
            AND segment1 = '2430'
            AND ledger_name = v_old_ledger_name;

        COMMIT;*/
        v_old_ledger_name VARCHAR2(2500);
        v_new_ledger_name VARCHAR2(2500);
        v_new_ledger_id   NUMBER;
        v_segment1 varchar2(100);

        CURSOR Leger_transform_cur
        is
        SELECT
            input_code_1,
            input_code_3,
            output_code_1,
            output_code_3
        FROM
            xxmx_mapping_master
        WHERE
            category_code = 'COA_LEDGER_MAPPING'
            AND application = 'GL';
    BEGIN

    FOR rec_ledger_transform in Leger_transform_cur loop

         v_old_ledger_name:=rec_ledger_transform.input_code_1;
            v_segment1:=rec_ledger_transform.input_code_3;
            v_new_ledger_name:=rec_ledger_transform.output_code_1;
            v_new_ledger_id:=rec_ledger_transform.output_code_3;

        UPDATE xxmx_gl_opening_balances_xfm
        SET
            ledger_id = v_new_ledger_id,
            ledger_name = v_new_ledger_name
        WHERE
            migration_set_id = pt_i_migrationsetid
            AND segment1 = v_segment1--'2430'
            AND ledger_name = v_old_ledger_name;

        UPDATE xxmx_gl_summary_balances_xfm
        SET
            ledger_id = v_new_ledger_id,
            ledger_name = v_new_ledger_name
        WHERE
            migration_set_id = pt_i_migrationsetid
            AND segment1 = v_segment1--'2430'
            AND ledger_name = v_old_ledger_name;

        UPDATE xxmx_gl_detail_balances_xfm
        SET
            ledger_id = v_new_ledger_id,
            ledger_name = v_new_ledger_name
        WHERE
            migration_set_id = pt_i_migrationsetid
            AND segment1 = v_segment1--'2430'
            AND ledger_name = v_old_ledger_name;

        COMMIT;

        END LOOP;
    EXCEPTION
        WHEN OTHERS THEN
            raise_application_error(
                                   -20111,
                                   'Error text :' || dbms_utility.format_error_backtrace
            );
    END transform_gl_ledgers;

/*
     ******************************************************************************
	 ** PURPOSE   : transform_gl_histrates_values - this procedure transforms GL Historical Rates records  
	 ******************************************************************************

*/
    PROCEDURE transform_gl_histrates_values (
        pt_i_applicationsuite    IN xxmx_seeded_extensions.application_suite%TYPE,
        pt_i_application         IN xxmx_seeded_extensions.application%TYPE,
        pt_i_businessentity      IN xxmx_seeded_extensions.business_entity%TYPE,
        pt_i_stgpopulationmethod IN xxmx_core_parameters.parameter_value%TYPE,
        pt_i_filesetid           IN xxmx_migration_headers.file_set_id%TYPE,
        pt_i_migrationsetid      IN xxmx_migration_headers.migration_set_id%TYPE,
        pv_o_returnstatus        OUT VARCHAR2
    ) IS

        CURSOR GLHistoricalrates_xfm_cur(pt_i_migrationsetid NUMBER)
          IS
             --
             --
			 SELECT
					migration_set_id,
					migration_set_name,
					migration_status,
					ledger_name,
					import_action,
					segment1,
					segment2,
					segment3,
					segment4,
					segment5,
					segment6,
					segment7,
					period_name,
					target_currency_code,
					value_type_code,
					SUM(credit_amount_rate) credit_amount_rate,
					auto_roll_forward_flag,
                    'Y' status_flag
				FROM
					xxmx_xfm.xxmx_gl_historicalrates_xfm
			    WHERE 	migration_set_id = pt_i_migrationsetid	
                AND     migration_status = 'PRE-TRANSFORM'   
				GROUP BY
					migration_set_id,migration_set_name,migration_status,ledger_name,import_action,segment1,segment2,
					segment3,segment4,segment5,segment6,segment7,period_name,target_currency_code,value_type_code,auto_roll_forward_flag
				ORDER BY
					ledger_name,target_currency_code,segment1,segment2,segment3,segment4,segment5,segment6,segment7;

				--** END CURSOR **
                --
                --
                --********************
                --** Type Declarations
                --********************
                --
		        TYPE gl_historicalrates_tt IS TABLE OF GLHistoricalrates_xfm_cur%ROWTYPE INDEX BY BINARY_INTEGER;

				--****************************
				--** PL/SQL Table Declarations
				--****************************
				--
				gl_historicalrates_tbl          gl_historicalrates_tt;

BEGIN

        OPEN GLHistoricalrates_xfm_cur(pt_i_migrationsetid);

		LOOP
            --
            FETCH        GLHistoricalrates_xfm_cur
                BULK COLLECT
                INTO         gl_historicalrates_tbl
                LIMIT        xxmx_utilities_pkg.gcn_BulkCollectLimit;
            --
                EXIT WHEN    gl_historicalrates_tbl.COUNT = 0;


				 FORALL GLHistoricalrates_idx 
                IN 1..gl_historicalrates_tbl.COUNT
            --
                INSERT
                INTO   xxmx_xfm.xxmx_gl_historicalrates_xfm
                (
                                                               migration_set_id
                                                              ,migration_set_name
                                                              ,migration_status
                                                              ,ledger_name
                                                              ,import_action
															  ,segment1
															  ,segment2
															  ,segment3
															  ,segment4
															  ,segment5
															  ,segment6
															  ,segment7
															  ,segment8
															  ,segment9
															  ,segment10
															  ,segment11
															  ,segment12
															  ,segment13
															  ,segment14
															  ,segment15
															  ,segment16
															  ,segment17
															  ,segment18
															  ,segment19
															  ,segment20
															  ,segment21
															  ,segment22
															  ,segment23
															  ,segment24
															  ,segment25
															  ,segment26
															  ,segment27
															  ,segment28
															  ,segment29
															  ,segment30
															  ,period_name
															  ,target_currency_code
															  ,value_type_code
															  ,credit_amount_rate
															  ,auto_roll_forward_flag
															  ,attribute_category
															  ,attribute1
															  ,attribute2
															  ,attribute3
															  ,attribute4
															  ,attribute5
                                                              ,status_flag

                )
                VALUES
                (
    gl_historicalrates_tbl(glhistoricalrates_idx).migration_set_id --migration_set_id
    ,
    gl_historicalrates_tbl(glhistoricalrates_idx).migration_set_name -- migration_set_name
    ,
    gl_historicalrates_tbl(glhistoricalrates_idx).migration_status   -- migration_status
    ,
    gl_historicalrates_tbl(glhistoricalrates_idx).ledger_name     -- ledger_name
    ,
    gl_historicalrates_tbl(glhistoricalrates_idx).import_action   --import_action
    ,
    gl_historicalrates_tbl(glhistoricalrates_idx).segment1        -- segment1
    ,
    gl_historicalrates_tbl(glhistoricalrates_idx).segment2        -- segment2
    ,
    gl_historicalrates_tbl(glhistoricalrates_idx).segment3        -- segment3
    ,
    gl_historicalrates_tbl(glhistoricalrates_idx).segment4        -- segment4
    ,
    gl_historicalrates_tbl(glhistoricalrates_idx).segment5        -- segment5
    ,
    gl_historicalrates_tbl(glhistoricalrates_idx).segment6        -- segment6
    ,
    gl_historicalrates_tbl(glhistoricalrates_idx).segment7        -- segment7
    ,
    null        -- segment8
    ,
    null        -- segment9
    ,
    null        -- segment10
    ,
    null        -- segment11
    ,
    null        -- segment12
    ,
    null        -- segment13
    ,
    null        -- segment14
    ,
    null        -- segment15
    ,
    null        -- segment16
    ,
    null        -- segment17
    ,
    null        -- segment18
    ,
    null        -- segment19
    ,
    null        -- segment20
    ,
    null        -- segment21
    ,
    null        -- segment22
    ,
    null        -- segment23
    ,
    null        -- segment24
    ,
    null        -- segment25
    ,
    null        -- segment26
    ,
    null        -- segment27
    ,
    null        -- segment28
    ,
    null        -- segment29
    ,
    null        -- segment30
    ,
    gl_historicalrates_tbl(glhistoricalrates_idx).period_name     --period_name
    ,
    gl_historicalrates_tbl(glhistoricalrates_idx).target_currency_code --target_currency_code                                                          -- attribute_date4
    ,
    gl_historicalrates_tbl(glhistoricalrates_idx).value_type_code    --value_type_code                                                          -- attribute_date5
    ,
    gl_historicalrates_tbl(glhistoricalrates_idx).credit_amount_rate --credit_amount_rate                                                          -- attribute_number1
    ,
    gl_historicalrates_tbl(glhistoricalrates_idx).auto_roll_forward_flag --auto_roll_forward_flag                                                          -- attribute_number2
    ,
    null                                                          -- attribute_category
    ,
    null                                                          -- attribute1
    ,
    null                                                          -- attribute2
    ,
    null                                                          -- attribute3
    ,
    null                                                          -- attribute4
    ,
    null                                                          -- attribute5
    ,
    gl_historicalrates_tbl(glhistoricalrates_idx).status_flag     -- status_flag
);
                --
                --** END FORALL 
                --
            END LOOP; --** GLHistoricalrates_xfm_cur BULK COLLECT LOOP

            CLOSE GLHistoricalrates_xfm_cur;				

       BEGIN
       --null;
       DELETE FROM xxmx_gl_historicalrates_xfm WHERE status_flag IS NULL;
	   EXCEPTION
	   WHEN OTHERS THEN
                xxmx_fin_error_log_prc(
                                      NULL,
                                      sqlcode,
                                      'Delete from xxmx_gl_historicalrates_xfm -  ' || sqlerrm
                );
                raise_application_error(
                                       -20111,
                                       'Error text :' || dbms_utility.format_error_backtrace
                );	
       END;

		COMMIT;


		  EXCEPTION

               WHEN OTHERS
               THEN
                    --
                    IF   GLHistoricalrates_xfm_cur%ISOPEN
                    THEN
                         --
                         CLOSE GLHistoricalrates_xfm_cur;
                         --
                    END IF;

				xxmx_fin_error_log_prc(
                                      NULL,
                                      sqlcode,
                                      'Error: transform_gl_histrates_values -  ' || sqlerrm
                );
                raise_application_error(
                                       -20111,
                                       'Error text :' || dbms_utility.format_error_backtrace
                );	
                    --
                    ROLLBACK;
                    --


    END transform_gl_histrates_values;  

    PROCEDURE transform_exp_org (
        pt_i_applicationsuite    IN xxmx_seeded_extensions.application_suite%TYPE,
        pt_i_application         IN xxmx_seeded_extensions.application%TYPE,
        pt_i_businessentity      IN xxmx_seeded_extensions.business_entity%TYPE,
        pt_i_stgpopulationmethod IN xxmx_core_parameters.parameter_value%TYPE,
        pt_i_filesetid           IN xxmx_migration_headers.file_set_id%TYPE,
        pt_i_migrationsetid      IN xxmx_migration_headers.migration_set_id%TYPE,
        pv_o_returnstatus        OUT VARCHAR2
    ) IS
        BEGIN



     UPDATE XXMX_SCM_PO_DISTRIBUTIONS_STD_XFM a
        SET
            EXPENDITURE_ORGANIZATION = NVL((SELECT OUTPUT_CODE_1 
            FROM   	xxmx_mapping_master 
            WHERE  application = 'HR'
			 AND simple_or_complex ='C'
             AND CATEGORY_CODE ='PPM_ORG'
             and input_code_1=a.expenditure_organization
             group by input_code_1,output_code_1),a.expenditure_organization);

        COMMIT;


    EXCEPTION
        WHEN OTHERS THEN
            raise_application_error(
                                   -20111,
                                   'Error text :' || dbms_utility.format_error_backtrace
            );
    END transform_exp_org;

    PROCEDURE transform_gl_src (
        pt_i_applicationsuite    IN xxmx_seeded_extensions.application_suite%TYPE,
        pt_i_application         IN xxmx_seeded_extensions.application%TYPE,
        pt_i_businessentity      IN xxmx_seeded_extensions.business_entity%TYPE,
        pt_i_stgpopulationmethod IN xxmx_core_parameters.parameter_value%TYPE,
        pt_i_filesetid           IN xxmx_migration_headers.file_set_id%TYPE,
        pt_i_migrationsetid      IN xxmx_migration_headers.migration_set_id%TYPE,
        pv_o_returnstatus        OUT VARCHAR2
    ) IS
        v_old_src VARCHAR2(250);
        v_new_src VARCHAR2(250);

    BEGIN
        SELECT
            input_code_1,
            output_code_1
        INTO
            v_old_src,
            v_new_src
        FROM
            xxmx_mapping_master
        WHERE
            category_code = 'GL_SOURCE'
            AND application = 'GL'
            AND simple_or_complex='C';

        /*UPDATE xxmx_gl_opening_balances_xfm
        SET
            user_je_source_name = v_new_src
        WHERE
            migration_set_id = pt_i_migrationsetid
            AND user_je_source_name = v_old_src;

        UPDATE xxmx_gl_summary_balances_xfm
        SET
            user_je_source_name = v_new_src
        WHERE
            migration_set_id = pt_i_migrationsetid
            AND user_je_source_name = v_old_src;*/

        UPDATE xxmx_gl_detail_balances_xfm
        SET
            user_je_source_name = v_new_src
        WHERE
            migration_set_id = pt_i_migrationsetid
            AND user_je_source_name = v_old_src;

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            raise_application_error(
                                   -20111,
                                   'Error text :' || dbms_utility.format_error_backtrace
            );
    END transform_gl_src;


        /*PROCEDURE transform_gl_category (
        pt_i_applicationsuite    IN xxmx_seeded_extensions.application_suite%TYPE,
        pt_i_application         IN xxmx_seeded_extensions.application%TYPE,
        pt_i_businessentity      IN xxmx_seeded_extensions.business_entity%TYPE,
        pt_i_stgpopulationmethod IN xxmx_core_parameters.parameter_value%TYPE,
        pt_i_filesetid           IN xxmx_migration_headers.file_set_id%TYPE,
        pt_i_migrationsetid      IN xxmx_migration_headers.migration_set_id%TYPE,
        pv_o_returnstatus        OUT VARCHAR2
    ) IS
        v_old_cat VARCHAR2(250);
        v_new_cat VARCHAR2(250);

    BEGIN
        SELECT
            input_code_1,
            output_code_1
        INTO
            v_old_cat,
            v_new_cat
        FROM
            xxmx_mapping_master
        WHERE
            category_code = 'GL_CATEGORY'
            AND application = 'GL'
            AND simple_or_complex='C';

        UPDATE xxmx_gl_opening_balances_xfm
        SET
            user_je_category_name = v_new_cat
        WHERE
            migration_set_id = pt_i_migrationsetid
            AND user_je_category_name = v_old_cat;

        UPDATE xxmx_gl_summary_balances_xfm
        SET
            user_je_category_name = v_new_cat
        WHERE
            migration_set_id = pt_i_migrationsetid
            AND user_je_category_name = v_old_cat;

        UPDATE xxmx_gl_detail_balances_xfm
        SET
            user_je_category_name = v_new_cat
        WHERE
            migration_set_id = pt_i_migrationsetid
            AND user_je_category_name = v_old_cat;

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            raise_application_error(
                                   -20111,
                                   'Error text :' || dbms_utility.format_error_backtrace
            );
    END transform_gl_category;*/


    PROCEDURE transform_supp_party (
        pt_i_applicationsuite    IN xxmx_seeded_extensions.application_suite%TYPE,
        pt_i_application         IN xxmx_seeded_extensions.application%TYPE,
        pt_i_businessentity      IN xxmx_seeded_extensions.business_entity%TYPE,
        pt_i_stgpopulationmethod IN xxmx_core_parameters.parameter_value%TYPE,
        pt_i_filesetid           IN xxmx_migration_headers.file_set_id%TYPE,
        pt_i_migrationsetid      IN xxmx_migration_headers.migration_set_id%TYPE,
        pv_o_returnstatus        OUT VARCHAR2
    ) IS

    CURSOR APSupplierSiteTax_xfm_cur(pt_i_migrationsetid NUMBER)
          IS
             --
             --
			 SELECT
    file_set_id,
    migration_set_id,
    migration_set_name,
    migration_status,
    segment1,
    --vendor_site_code,
    party_type_code,
    party_number,
    party_name,
    country_code,
    rep_registration_number,
    process_for_applicability_flag,
    allow_offset_tax_flag
FROM
    xxmx_ap_supp_tax_prof_xfm
    WHERE 	migration_set_id = pt_i_migrationsetid	
                AND     migration_status = 'PRE-TRANSFORM'
                AND party_type_code='Third party site'
GROUP BY
    file_set_id,
    migration_set_id,
    migration_set_name,
    migration_status,
    segment1,
    --vendor_site_code,
    party_type_code,
    party_number,
    party_name,
    country_code,
    rep_registration_number,
    process_for_applicability_flag,
    allow_offset_tax_flag;


				--** END CURSOR **
                --
                --
                --********************
                --** Type Declarations
                --********************
                --
		        TYPE APSupplierSiteTax_tt IS TABLE OF APSupplierSiteTax_xfm_cur%ROWTYPE INDEX BY BINARY_INTEGER;

				--****************************
				--** PL/SQL Table Declarations
				--****************************
				--
				APSupplierSiteTax_tbl          APSupplierSiteTax_tt;


    BEGIN

   UPDATE xxmx_ap_supp_tax_prof_xfm a
SET
    a.party_number = (
        SELECT 
            party_number
        FROM
            xxmx_saas_ap_supp_site_reg_dtl
        WHERE
            segment1 = a.segment1
            AND party_type_code=a.party_type_code
            group by party_number
    )
    ,
    a.party_type_code='Third party'
WHERE
    a.party_type_code = 'THIRD_PARTY';

UPDATE xxmx_ap_supp_tax_prof_xfm a
SET
    a.party_number = (
        SELECT 
            party_site_number
        FROM
            xxmx_saas_ap_supp_site_reg_dtl
        WHERE
            segment1 = a.segment1
            AND vendor_site_code = a.vendor_site_code
            AND business_unit = a.business_unit
            AND party_type_code=a.party_type_code
            group by party_site_number
    ),
    a.party_type_code='Third party site'
WHERE
    a.party_type_code = 'THIRD_PARTY_SITE';

    COMMIT;

    INSERT INTO xxmx_ap_supp_tax_prof_error 
    SELECT
        a.*,sysdate
    FROM
        xxmx_ap_supp_tax_prof_xfm a
    WHERE
        party_number IS NULL
        ;
    commit;


    OPEN APSupplierSiteTax_xfm_cur(pt_i_migrationsetid);

		LOOP
            --
            FETCH        APSupplierSiteTax_xfm_cur
                BULK COLLECT
                INTO         APSupplierSiteTax_tbl
                LIMIT        xxmx_utilities_pkg.gcn_BulkCollectLimit;
            --
                EXIT WHEN    APSupplierSiteTax_tbl.COUNT = 0;


				 FORALL APSupplierSiteTax_idx 
                IN 1..APSupplierSiteTax_tbl.COUNT
            --
                INSERT
                INTO   xxmx_xfm.xxmx_ap_supp_tax_prof_xfm
                (
                                                               file_set_id,
    migration_set_id,
    migration_set_name,
    migration_status,
    segment1,
    --vendor_site_code,
    party_type_code,
    party_number,
    party_name,
    country_code,
    rep_registration_number,
    process_for_applicability_flag,
    allow_offset_tax_flag
                )
                VALUES
                (

    APSupplierSiteTax_tbl(APSupplierSiteTax_idx).file_set_id,
    APSupplierSiteTax_tbl(APSupplierSiteTax_idx).migration_set_id,
    APSupplierSiteTax_tbl(APSupplierSiteTax_idx).migration_set_name,
    APSupplierSiteTax_tbl(APSupplierSiteTax_idx).migration_status,
    APSupplierSiteTax_tbl(APSupplierSiteTax_idx).segment1,
    --APSupplierSiteTax_tbl(APSupplierSiteTax_idx).vendor_site_code,
    APSupplierSiteTax_tbl(APSupplierSiteTax_idx).party_type_code,
    APSupplierSiteTax_tbl(APSupplierSiteTax_idx).party_number,
    APSupplierSiteTax_tbl(APSupplierSiteTax_idx).party_name,
    APSupplierSiteTax_tbl(APSupplierSiteTax_idx).country_code,
    APSupplierSiteTax_tbl(APSupplierSiteTax_idx).rep_registration_number,
    APSupplierSiteTax_tbl(APSupplierSiteTax_idx).process_for_applicability_flag,
    APSupplierSiteTax_tbl(APSupplierSiteTax_idx).allow_offset_tax_flag
);
                --
                --** END FORALL 
                --
            END LOOP; --** GLHistoricalrates_xfm_cur BULK COLLECT LOOP

            CLOSE APSupplierSiteTax_xfm_cur;


  BEGIN
    Delete
    FROM
        xxmx_ap_supp_tax_prof_xfm
    WHERE
        party_number IS NULL or business_unit is not null;
        EXCEPTION
        WHEN OTHERS
               THEN
                    --
                    IF   APSupplierSiteTax_xfm_cur%ISOPEN
                    THEN
                         --
                         CLOSE APSupplierSiteTax_xfm_cur;
                         --
                    END IF;

				xxmx_fin_error_log_prc(
                                      NULL,
                                      sqlcode,
                                      'Error: transform_suppliers_tax_values -  ' || sqlerrm
                );
                raise_application_error(
                                       -20111,
                                       'Error text :' || dbms_utility.format_error_backtrace
                );	
                    --
                    ROLLBACK;
                    --
       END;
   commit;




    EXCEPTION
        WHEN OTHERS THEN
            raise_application_error(
                                   -20111,
                                   'Error text :' || dbms_utility.format_error_backtrace
            );
    END transform_supp_party;



    PROCEDURE transform_supp_reg (
        pt_i_applicationsuite    IN xxmx_seeded_extensions.application_suite%TYPE,
        pt_i_application         IN xxmx_seeded_extensions.application%TYPE,
        pt_i_businessentity      IN xxmx_seeded_extensions.business_entity%TYPE,
        pt_i_stgpopulationmethod IN xxmx_core_parameters.parameter_value%TYPE,
        pt_i_filesetid           IN xxmx_migration_headers.file_set_id%TYPE,
        pt_i_migrationsetid      IN xxmx_migration_headers.migration_set_id%TYPE,
        pv_o_returnstatus        OUT VARCHAR2
    ) IS

    CURSOR APSupplierSiteReg_xfm_cur(pt_i_migrationsetid NUMBER)
          IS
             --
             --
			 SELECT
    file_set_id,
    migration_set_id,
    migration_set_name,
    migration_status,
    segment1,
    --vendor_site_code,
    party_type_code,
    party_number,
    party_name,
    TAX_REGIME_CODE,
    tax_registration_status,
    registration_number,
    effective_from,
    source,
    validation_type


FROM
    xxmx_ap_supp_tax_reg_xfm
    WHERE 	migration_set_id = pt_i_migrationsetid	
                AND     migration_status = 'PRE-TRANSFORM'
                AND party_type_code='Third party site'
GROUP BY
    file_set_id,
    migration_set_id,
    migration_set_name,
    migration_status,
    segment1,
    --vendor_site_code,
    party_type_code,
    party_number,
    party_name,
    TAX_REGIME_CODE,
    tax_registration_status,
    registration_number,
    effective_from,
    source,
    validation_type;


				--** END CURSOR **
                --
                --
                --********************
                --** Type Declarations
                --********************
                --
		        TYPE APSupplierSiteReg_tt IS TABLE OF APSupplierSiteReg_xfm_cur%ROWTYPE INDEX BY BINARY_INTEGER;

				--****************************
				--** PL/SQL Table Declarations
				--****************************
				--
				APSupplierSiteReg_tbl          APSupplierSiteReg_tt;


    BEGIN

   UPDATE xxmx_ap_supp_tax_reg_xfm a
SET
    a.party_number = (
        SELECT 
            party_number
        FROM
            xxmx_saas_ap_supp_site_reg_dtl
        WHERE
            segment1 = a.segment1
            AND party_type_code=a.party_type_code
            group by party_number
    )
    ,
    a.party_type_code='Third party'
WHERE
    a.party_type_code = 'THIRD_PARTY';

UPDATE xxmx_ap_supp_tax_reg_xfm a
SET
    a.party_number = (
        SELECT 
            party_site_number
        FROM
            xxmx_saas_ap_supp_site_reg_dtl
        WHERE
            segment1 = a.segment1
            AND vendor_site_code = a.vendor_site_code
            AND business_unit = a.business_unit
            AND party_type_code=a.party_type_code
            group by party_site_number
    ),
    a.party_type_code='Third party site'
WHERE
    a.party_type_code = 'THIRD_PARTY_SITE';

    COMMIT;

    INSERT INTO xxmx_ap_supp_tax_reg_error 
    SELECT
        a.*,sysdate
    FROM
        xxmx_ap_supp_tax_reg_xfm a
    WHERE
        party_number IS NULL
        ;
    commit;


    OPEN APSupplierSiteReg_xfm_cur(pt_i_migrationsetid);

		LOOP
            --
            FETCH        APSupplierSiteReg_xfm_cur
                BULK COLLECT
                INTO         APSupplierSiteReg_tbl
                LIMIT        xxmx_utilities_pkg.gcn_BulkCollectLimit;
            --
                EXIT WHEN    APSupplierSiteReg_tbl.COUNT = 0;


				 FORALL APSupplierSiteTax_idx 
                IN 1..APSupplierSiteReg_tbl.COUNT
            --
                INSERT
                INTO   xxmx_xfm.xxmx_ap_supp_tax_reg_xfm
                (
                                                               file_set_id,
    migration_set_id,
    migration_set_name,
    migration_status,
    segment1,
    --vendor_site_code,
    party_type_code,
    party_number,
    party_name,
    TAX_REGIME_CODE,
    tax_registration_status,
    registration_number,
    effective_from,
    source,
    validation_type
                )
                VALUES
                (

    APSupplierSitereg_tbl(APSupplierSiteTax_idx).file_set_id,
    APSupplierSitereg_tbl(APSupplierSiteTax_idx).migration_set_id,
    APSupplierSitereg_tbl(APSupplierSiteTax_idx).migration_set_name,
    APSupplierSitereg_tbl(APSupplierSiteTax_idx).migration_status,
    APSupplierSitereg_tbl(APSupplierSiteTax_idx).segment1,
    --APSupplierSiteTax_tbl(APSupplierSiteTax_idx).vendor_site_code,
    APSupplierSitereg_tbl(APSupplierSiteTax_idx).party_type_code,
    APSupplierSitereg_tbl(APSupplierSiteTax_idx).party_number,
    APSupplierSitereg_tbl(APSupplierSiteTax_idx).party_name,
    APSupplierSitereg_tbl(APSupplierSiteTax_idx).TAX_REGIME_CODE,
    APSupplierSitereg_tbl(APSupplierSiteTax_idx).tax_registration_status,
    APSupplierSitereg_tbl(APSupplierSiteTax_idx).registration_number,
    APSupplierSitereg_tbl(APSupplierSiteTax_idx).effective_from,
    APSupplierSitereg_tbl(APSupplierSiteTax_idx).source,
    APSupplierSitereg_tbl(APSupplierSiteTax_idx).validation_type
);
                --
                --** END FORALL 
                --
            END LOOP; --** GLHistoricalrates_xfm_cur BULK COLLECT LOOP

            CLOSE APSupplierSiteReg_xfm_cur;


  BEGIN
    Delete
    FROM
        xxmx_ap_supp_tax_reg_xfm
    WHERE
        party_number IS NULL or business_unit is not null;
        EXCEPTION
        WHEN OTHERS
               THEN
                    --
                    IF   APSupplierSiteReg_xfm_cur%ISOPEN
                    THEN
                         --
                         CLOSE APSupplierSiteReg_xfm_cur;
                         --
                    END IF;

				xxmx_fin_error_log_prc(
                                      NULL,
                                      sqlcode,
                                      'Error: transform_suppliers_reg_values -  ' || sqlerrm
                );
                raise_application_error(
                                       -20111,
                                       'Error text :' || dbms_utility.format_error_backtrace
                );	
                    --
                    ROLLBACK;
                    --
       END;
   commit;




    EXCEPTION
        WHEN OTHERS THEN
            raise_application_error(
                                   -20111,
                                   'Error text :' || dbms_utility.format_error_backtrace
            );
    END transform_supp_reg;

    PROCEDURE transform_ledger_name(
        pt_i_applicationsuite    IN xxmx_seeded_extensions.application_suite%TYPE,
        pt_i_application         IN xxmx_seeded_extensions.application%TYPE,
        pt_i_businessentity      IN xxmx_seeded_extensions.business_entity%TYPE,
        pt_i_stgpopulationmethod IN xxmx_core_parameters.parameter_value%TYPE,
        pt_i_filesetid           IN xxmx_migration_headers.file_set_id%TYPE,
        pt_i_migrationsetid      IN xxmx_migration_headers.migration_set_id%TYPE,
        pv_o_returnstatus        OUT VARCHAR2
    ) is

    BEGIN
    update xxmx_gl_detail_balances_xfm a set ledger_name=(select distinct ledger_name from xxmx_dm_fusion_Das b where b.ledger_id= a.ledger_id );
    Commit;
    update xxmx_gl_summary_balances_xfm a set ledger_name=(select distinct ledger_name from xxmx_dm_fusion_Das b where b.ledger_id= a.ledger_id );
    commit;
    update xxmx_gl_opening_balances_xfm a set ledger_name=(select distinct ledger_name from xxmx_dm_fusion_Das b where b.ledger_id= a.ledger_id );
    commit;
    EXCEPTION
        WHEN OTHERS THEN
            raise_application_error(
                                   -20111,
                                   'Error text :' || dbms_utility.format_error_backtrace
            );
    END transform_ledger_name;




END xxmx_citco_fin_ext_pkg;