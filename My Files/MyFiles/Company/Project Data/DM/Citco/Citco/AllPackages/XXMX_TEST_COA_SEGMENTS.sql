--------------------------------------------------------
--  DDL for Procedure XXMX_TEST_COA_SEGMENTS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "XXMX_CORE"."XXMX_TEST_COA_SEGMENTS" (
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
            output_code_5 VARCHAR2(250)
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

            v_mapping_sql := 'SELECT INPUT_CODE_1,OUTPUT_CODE_1 ,OUTPUT_CODE_2,OUTPUT_CODE_3,OUTPUT_CODE_4,OUTPUT_CODE_5   FROM    xxmx_mapping_master WHERE  application = :pt_i_application'
                             || ' AND CATEGORY_CODE ='
                             || '''COA_SEGMENTS'''
                             || ' AND input_code_1='
                             || '''XXMX_TEST_OPENING_BALANCES_XFM'''
                             || '    AND  business_entity = :pt_i_businessentity ';
            EXECUTE IMMEDIATE v_mapping_sql
            BULK COLLECT
            INTO v_mappings_tb
                USING pt_i_application, pt_i_businessentity;
        EXCEPTION
            WHEN OTHERS THEN

            dbms_output.put_line('Error in getting the mapping details sqlcode ' || sqlerrm);
               /* xxmx_fin_error_log_prc(
                                      NULL,
                                      sqlcode,
                                      'Error in getting the mapping details ' || sqlerrm
                );*/
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
		v_segment3_name := v_mappings_tb(i).output_code_5; --MR
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
                                       dbms_output.put_line(l_error_message);
                    /*xxmx_fin_error_log_prc(
                                          v_rowid,
                                          sqlcode,
                                          l_error_message
                    );*/
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
                                        dbms_output.put_line(l_error_message);
                   /* xxmx_fin_error_log_prc(
                                          v_rowid,
                                          sqlcode,
                                          l_error_message
                    );*/
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
                                        dbms_output.put_line(l_error_message);
                   /* xxmx_fin_error_log_prc(
                                          v_rowid,
                                          sqlcode,
                                          l_error_message
                    );*/
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
                                        dbms_output.put_line(l_error_message);
                    /*xxmx_fin_error_log_prc(
                                          v_rowid,
                                          sqlcode,
                                          l_error_message
                    );*/
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
                                                dbms_output.put_line(l_error_message);
                            /*xxmx_fin_error_log_prc(
                                                  v_rowid,
                                                  sqlcode,
                                                  l_error_message
                            );*/
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
                                                            dbms_output.put_line(l_error_message);
                                        /*xxmx_fin_error_log_prc(
                                                              v_rowid,
                                                              sqlcode,
                                                              l_error_message
                                        );*/
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
                                                dbms_output.put_line(l_error_message);
                           /* xxmx_fin_error_log_prc(
                                                  v_rowid,
                                                  sqlcode,
                                                  l_error_message
                            );*/
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
                             dbms_output.put_line(l_location);
                           /* xxmx_fin_error_log_prc(
                                                  v_rowid,
                                                  sqlcode,
                                                  l_location
                            );*/
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
                         dbms_output.put_line(l_location);
                       /* xxmx_fin_error_log_prc(
                                              v_rowid,
                                              sqlcode,
                                              l_location
                        );*/
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
                                            dbms_output.put_line(l_error_message);
                        /*xxmx_fin_error_log_prc(
                                              v_rowid,
                                              sqlcode,
                                              l_error_message
                        );*/
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
											|| v_segment3_name                             --Added by sushma chowdary to set interco values to '122' where account_code is in '409109','409129','409137','409159','409199','409209','409298'(20/Jun/2023)
                                            || '= :v_trans_segment3, '                 --Added by sushma chowdary to set interco values to '122' where account_code is in '409109','409129','409137','409159','409199','409209','409298'(20/Jun/2023)
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
                                                    dbms_output.put_line(l_error_message);
                                /*xxmx_fin_error_log_prc(
                                                      v_rowid,
                                                      sqlcode,
                                                      l_error_message
                                );*/
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
             dbms_output.put_line('Error in Procedure xxmx_test_coa_segments'
                                  || sqlerrm);
           /* xxmx_fin_error_log_prc(
                                  NULL,
                                  sqlcode,
                                  'Error in Procedure xxmx_citco_fin_ext_pkg.transform_coa_segments'
                            1      || sqlerrm
                                  || 'Error text :'
                                  || dbms_utility.format_error_backtrace
            );*/
--            dbms_output.put_line('Error in Procedure xxmx_citco_fin_ext_pkg.transform_coa_segments');
--            dbms_output.put_line('Error Message :' || sqlerrm);
--            dbms_output.put_line('Error text :' || dbms_utility.format_error_backtrace);
--            raise_application_error(
--                                   -20111,
--                                   'Error text :' || dbms_utility.format_error_backtrace
--            );
    END xxmx_test_coa_segments;

/

  GRANT EXECUTE ON "XXMX_CORE"."XXMX_TEST_COA_SEGMENTS" TO "XXMX_XFM";
  GRANT DEBUG ON "XXMX_CORE"."XXMX_TEST_COA_SEGMENTS" TO "XXMX_XFM";
