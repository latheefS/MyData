--------------------------------------------------------
--  DDL for Package Body XXMX_CITCO_FA_LOCATION
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "XXMX_CORE"."XXMX_CITCO_FA_LOCATION" AS

    PROCEDURE xxfa_location_proc (
        pt_i_applicationsuite      IN    xxmx_seeded_extensions.application_suite%TYPE,
        pt_i_application           IN    xxmx_seeded_extensions.application%TYPE,
        pt_i_businessentity        IN    xxmx_seeded_extensions.business_entity%TYPE,
        pt_i_stgpopulationmethod   IN    xxmx_core_parameters.parameter_value%TYPE,
        pt_i_filesetid             IN    xxmx_migration_headers.file_set_id%TYPE,
        pt_i_migrationsetid        IN    xxmx_migration_headers.migration_set_id%TYPE,
        pv_o_returnstatus          OUT   VARCHAR2
    ) IS

        tablename               VARCHAR2(200);
        v_select_sql            VARCHAR2(350);
        v_mapping_sql           VARCHAR2(350);
        v_update_sql            VARCHAR2(350);
        v_rowid                 VARCHAR2(200);
        v_segment1              VARCHAR2(100);
        v_segment2              VARCHAR2(100);
        v_segment5              VARCHAR2(100);
        v_segment1_name         VARCHAR2(100);
        v_segment2_name         VARCHAR2(100);
        v_segment4_name         VARCHAR2(100);
        v_segment5_name         VARCHAR2(100);
        v_trans_segment1        VARCHAR2(100);
        v_table_name            VARCHAR2(250);
        l_account_type          VARCHAR2(1);
        l_location              VARCHAR2(250);
        l_gl_counts             NUMBER := 0;
        v_bill_to_location   VARCHAR2(250);
		v_loc_segment1          VARCHAR2(60);
        v_deprn_exp_seg1        VARCHAR2(60);
        v_loc_segment4          VARCHAR2(60);
        l_loc_seg               VARCHAR2(60);
        l_count                 NUMBER := 0;
        v_trans_segment5        VARCHAR2(60);
        TYPE v_segments_record IS RECORD (
            rid        VARCHAR2(250),
            segment1   VARCHAR2(250),
            segment2   VARCHAR2(250),
            segment5   VARCHAR2(250) 
        );
        TYPE v_mappings_record IS RECORD (
            input_code_1    VARCHAR2(250),
            output_code_1   VARCHAR2(250),
            output_code_2   VARCHAR2(250),
            output_code_3   VARCHAR2(250),
            output_code_4   VARCHAR2(250)
        );
        TYPE v_segments_tbl IS
            TABLE OF v_segments_record INDEX BY BINARY_INTEGER;
        TYPE v_mappings_tbl IS
            TABLE OF v_mappings_record INDEX BY BINARY_INTEGER;
        v_segments_tb           v_segments_tbl := v_segments_tbl();
        v_mappings_tb           v_mappings_tbl := v_mappings_tbl();
    BEGIN
        BEGIN
--            dbms_output.enable(1000000);

            v_mapping_sql := 'SELECT INPUT_CODE_1,OUTPUT_CODE_1 ,OUTPUT_CODE_2,OUTPUT_CODE_3,OUTPUT_CODE_4   FROM    xxmx_mapping_master WHERE  application = :pt_i_application'
                             || ' AND CATEGORY_CODE ='
                             || '''COA_SEGMENTS'''
                             || ' AND  INPUT_CODE_1 =' 
                             || '''XXMX_GL_TEST_XFM'''
--                             || '''XXMX_FA_LOCATION_TEST'''
                             || '    AND  business_entity = :pt_i_businessentity ';
            EXECUTE IMMEDIATE v_mapping_sql BULK COLLECT
            INTO v_mappings_tb
                USING pt_i_application, pt_i_businessentity;
        EXCEPTION
            WHEN OTHERS THEN
--                dbms_output.put_line('Error in getting the mapping details ' || sqlerrm);
                raise_application_error(-20111, 'Error text :' || dbms_utility.format_error_backtrace);
        END;

        v_table_name := NULL;
        v_segment1_name := NULL;
        v_segment2_name := NULL;
        v_segment4_name := NULL;
        v_segment5_name := NULL;
        FOR i IN 1..v_mappings_tb.count LOOP
            IF v_mappings_tb(i).input_code_1 IS NULL THEN
--                dbms_output.put_line('Error in Procedure XXMX_CITCO_FA_LOCATION.transform_gl_location no table mapping exists');
            null;
            ELSE

                v_table_name := v_mappings_tb(i).input_code_1;
                v_rowid := NULL;
                v_segment1 := NULL;
                v_segment2 := NULL;
                v_segment5 := NULL;
                v_trans_segment1 := NULL;
                v_trans_segment5 := NULL;
                v_segment1_name := v_mappings_tb(i).output_code_1;
                v_segment2_name := v_mappings_tb(i).output_code_2;
                v_segment4_name := v_mappings_tb(i).output_code_3;
                v_segment5_name := v_mappings_tb(i).output_code_4;                
                v_select_sql := 'Select rowid,'
                                || v_segment1_name
                                || ','
                                || v_segment2_name
                                || ','
                                || v_segment5_name
                                || ' from xxmx_xfm.'
                                || v_table_name
                                || ' WHERE MIGRATION_SET_ID = :PT_I_MIGRATIONSETID';
               
--dbms_output.put_line('Segment5 Value:' || v_segment5_name);
                EXECUTE IMMEDIATE v_select_sql BULK COLLECT
                INTO v_segments_tb
                    USING pt_i_migrationsetid;
                FOR i IN 1..v_segments_tb.count LOOP
                    BEGIN

                        v_rowid := v_segments_tb(i).rid;
                        v_segment1 := v_segments_tb(i).segment1;
                        v_segment2 := v_segments_tb(i).segment2;
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
--dbms_output.put_line('Rowid: ' || v_rowid||'Account Type: ' || l_account_type);
                    EXCEPTION
                        WHEN OTHERS THEN
                            dbms_output.put_line('Error in getting account values from mapping master '
                                                 || v_segment2
                                                 || ' v_table_name '
                                                 || v_table_name
                                                 || ' v_rowid '
                                                 || v_rowid
                                                 || sqlerrm);

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
                            dbms_output.put_line('Error in getting company values from mapping master '
                                                 || v_segment1
                                                 || ' v_table_name '
                                                 || v_table_name
                                                 || ' v_rowid '
                                                 || v_rowid
                                                 || sqlerrm);

                            GOTO skip_update;
                    END;
                    
                    
                    BEGIN
                       v_trans_segment5 := NULL;
                    -- IF v_segment5!='0000' THEN 
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
                   -- END IF;

                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN 
                        v_trans_segment5 := '0000';
                        WHEN OTHERS THEN
                            dbms_output.put_line('Error in getting company values from mapping master '
                                                 || v_segment5
                                                 || ' v_table_name '
                                                 || v_table_name
                                                 || ' v_rowid '
                                                 || v_rowid
                                                 || sqlerrm);

                            GOTO skip_update;
                    END;
                  

                    IF v_table_name = 'XXMX_SCM_PO_DISTRIBUTIONS_STD_XFM' THEN

                        BEGIN
v_bill_to_location := NULL;
                            SELECT    poh.bill_to_location
                           INTO v_bill_to_location
                            FROM
                                xxmx_scm_po_distributions_std_xfm pdx,
                                XXMX_SCM_PO_headerS_STD_xfm poh
                            WHERE
                                pdx.PO_HEADER_ID=poh.PO_HEADER_ID
                            and    pdx.ROWID = v_rowid;

                        EXCEPTION
                            WHEN OTHERS THEN
                                dbms_output.put_line('Error in getting bill_to_location '
                                                     || v_table_name
                                                     || ' v_rowid '
                                                     || v_rowid
                                                     || sqlerrm);

                                v_bill_to_location := NULL;
                                GOTO skip_update;
                        END;

                        IF v_bill_to_location IS NOT NULL THEN
                            SELECT
                                output_code_1
                            INTO l_location
                            FROM
                                xxmx_mapping_master
                            WHERE
                                application_suite = 'SCM'
                                AND application = 'PO'
                                AND category_code = 'PO_LOCATION'
                                AND upper(input_code_1) = upper(v_bill_to_location);

                        END IF;

					ELSIF v_table_name = 'XXMX_FA_LOCATION_TEST' THEN --XXMX_FA_MASS_ADDITION_DIST_XFM

                        BEGIN
                            v_loc_segment1   := NULL;
							v_deprn_exp_seg1 := NULL;
							v_loc_segment4   := NULL;

                            SELECT xfad.LOCATION_SEGMENT1,xfad.DEPRN_EXPENSE_SEGMENT1,xfad.LOCATION_SEGMENT4
							INTO v_loc_segment1,v_deprn_exp_seg1,v_loc_segment4
							FROM XXMX_FA_LOCATION_TEST xfad --XXMX_FA_MASS_ADDITION_DIST_XFM xfad
							WHERE xfad.rowid = v_rowid;

                        EXCEPTION
                            WHEN OTHERS THEN
                                dbms_output.put_line('Error in getting values '
                                                     || v_table_name
                                                     || ' v_rowid '
                                                     || v_rowid
                                                     || sqlerrm);

                                v_loc_segment1 := NULL;
                                GOTO skip_update;
                        END;
                        

                            SELECT COUNT(1) 
							INTO l_count
						    FROM xxmx_mapping_master
							WHERE application_suite='FIN'
							AND application='FA'
							AND category_code='FA_LOC_SEGMENT'
							AND upper(input_code_1)=upper(v_deprn_exp_seg1);
--							AND upper(output_code_1)=upper(v_loc_segment1);
--                              dbms_output.put_line('Count '||l_count);
--                              dbms_output.put_line('v_deprn_exp_seg1 '||v_deprn_exp_seg1);
                                                 
                        
                        IF  l_count!=0 AND v_loc_segment1 IS NOT NULL THEN
						    SELECT output_code_1
							INTO l_loc_seg
							FROM xxmx_mapping_master
							WHERE application_suite='FIN'
							AND application='FA'
							AND category_code='FA_LOC_SEGMENT'
							AND upper(input_code_1)=upper(v_deprn_exp_seg1);

--              dbms_output.put_line(l_loc_seg);
                 
						IF  l_loc_seg = v_loc_segment1 THEN 

						SELECT output_code_1
						INTO l_location
						FROM xxmx_mapping_master
						WHERE application_suite='FIN'
						AND application='FA'
						AND category_code='FA_LOCATION_MAPPING'
						AND upper(input_code_1)=upper(v_loc_segment4);	
                                            
                       ELSE 
                        SELECT output_code_2
						INTO l_location
						FROM xxmx_mapping_master
						WHERE application_suite='FIN'
						AND application='FA'
						AND category_code='FA_LOC_SEGMENT'
						AND upper(input_code_1)=upper(v_deprn_exp_seg1);
                        
                         END IF;
                         
                  ELSE
                        IF l_account_type IN (
                            'A',
                            'L',
                            'O'
                        ) THEN
                            l_location := '0000';
                        ELSIF l_account_type IN (
                            'E',
                            'R'
                        ) THEN
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
                            GOTO skip_update;
                        END IF;
                         
                     END IF;
                     
                    ELSE
                        IF l_account_type IN (
                            'A',
                            'L',
                            'O'
                        ) THEN
                            l_location := '0000';
                        ELSIF l_account_type IN (
                            'E',
                            'R'
                        ) THEN
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
                            GOTO skip_update;
                        END IF;
                    END IF;
	

                    BEGIN
--                        dbms_output.put_line('Before update  v_table_name '
--                                             || v_table_name
--                                             || ' v_rowid '
--                                             || v_rowid);
                        v_update_sql := 'UPDATE xxmx_xfm.'
                                        || v_table_name
                                        || ' SET '
                                        || v_segment4_name
                                        || '= :l_location, '
                                        || v_segment1_name
                                        || '= :v_trans_segment1, '
                                        || v_segment5_name
                                        || '= :v_trans_segment5 WHERE rowid = :v_rowid and MIGRATION_SET_ID= :PT_I_MIGRATIONSETID'
                                        ;

                        EXECUTE IMMEDIATE v_update_sql
                            USING l_location, v_trans_segment1, v_trans_segment5, v_rowid, pt_i_migrationsetid;
--                        dbms_output.put_line('updated location values for v_segments_tb(i).rid: '
--                                             || v_rowid
--                                             || ' Location value: '
--                                             || l_location);
                    EXCEPTION
                        WHEN OTHERS THEN
                            dbms_output.put_line('Error in updating location values for v_segments_tb(i).rid: '
                                                 || v_rowid
                                                 || sqlerrm
                                                 || v_update_sql);
                    END;

                    << skip_update >> null; --dbms_output.put_line('End');
                END LOOP;
                pv_o_returnstatus:='S';
        --

            END IF;

            COMMIT;
        END LOOP;

    EXCEPTION
        WHEN OTHERS THEN

                --
            ROLLBACK;
            dbms_output.put_line('Error in Procedure XXMX_CITCO_FA_LOCATION.xxfa_location_proc');
            dbms_output.put_line('Error Message :' || sqlerrm);
            dbms_output.put_line('Error text :' || dbms_utility.format_error_backtrace);
            raise_application_error(-20111, 'Error text :' || dbms_utility.format_error_backtrace);
    END xxfa_location_proc;
    
PROCEDURE xx_gl_code_combo (
        pt_i_applicationsuite      IN    xxmx_seeded_extensions.application_suite%TYPE,
        pt_i_application           IN    xxmx_seeded_extensions.application%TYPE,
        pt_i_businessentity        IN    xxmx_seeded_extensions.business_entity%TYPE,
        pt_i_stgpopulationmethod   IN    xxmx_core_parameters.parameter_value%TYPE,
        pt_i_filesetid             IN    xxmx_migration_headers.file_set_id%TYPE,
        pt_i_migrationsetid        IN    xxmx_migration_headers.migration_set_id%TYPE,
        pv_o_returnstatus          OUT   VARCHAR2
    ) IS

        tablename         VARCHAR2(200);
        v_select_sql      VARCHAR2(350);
        v_mapping_sql     VARCHAR2(350);
        v_update_sql      VARCHAR2(350);
        v_rowid           VARCHAR2(200);
        v_segment1        VARCHAR2(100);
        v_segment2        VARCHAR2(100);
        v_segment3        VARCHAR2(100);
        v_segment4        VARCHAR2(100);
        v_segment5        VARCHAR2(100);
        v_segment6        VARCHAR2(100);
        v_segment7        VARCHAR2(100);
        v_tr_segment4     VARCHAR2(100);
        v_tr_segment1     VARCHAR2(100);
        v_tr_segment6     VARCHAR2(100);
        v_tr_segment7     VARCHAR2(100);
        v_tr_segment5     VARCHAR2(100);
        v_tr_code_combo   VARCHAR2(250);
        v_table_name      VARCHAR2(250);
        l_account_type    VARCHAR2(1);
        l_location        VARCHAR2(250);
        l_gl_counts       NUMBER := 0;
        TYPE v_segments_record IS RECORD (
            rid                 VARCHAR2(250),
            code_combinations   VARCHAR2(250)
        );
        TYPE v_mappings_record IS RECORD (
            input_code_1    VARCHAR2(250),
            output_code_1   VARCHAR2(250)
        );
        TYPE v_segments_tbl IS
            TABLE OF v_segments_record INDEX BY BINARY_INTEGER;
        TYPE v_mappings_tbl IS
            TABLE OF v_mappings_record INDEX BY BINARY_INTEGER;
        v_segments_tb     v_segments_tbl := v_segments_tbl();
        v_mappings_tb     v_mappings_tbl := v_mappings_tbl();
    BEGIN
        BEGIN
            dbms_output.enable(1000000);
            v_mapping_sql := 'SELECT INPUT_CODE_1,OUTPUT_CODE_1    FROM    xxmx_mapping_master WHERE  application =:pt_i_application '
                             || ' AND CATEGORY_CODE ='
                             || '''CODE_COMBINATIONS'''
                             || ' AND  INPUT_CODE_1 =' 
                             || '''XXMX_SUP_TEST_GL_COMBO'''
                             || '    AND  business_entity = :pt_i_businessentity ';
            EXECUTE IMMEDIATE v_mapping_sql BULK COLLECT
            INTO v_mappings_tb
                USING pt_i_application, pt_i_businessentity;
        EXCEPTION
            WHEN OTHERS THEN
                dbms_output.put_line('Error in getting the mapping details ' || sqlerrm);
                raise_application_error(-20111, 'Error text :' || dbms_utility.format_error_backtrace);
        END;

        FOR i IN 1..v_mappings_tb.count LOOP
            IF v_mappings_tb(i).input_code_1 IS NULL THEN
                dbms_output.put_line('Error in Procedure XXMX_CITCO_FA_LOCATION.xx_gl_code_combo no table mapping exists');
            ELSE
                BEGIN
                    v_select_sql := 'Select rowid,'
                                    || v_mappings_tb(i).output_code_1
                                    || ' from xxmx_xfm.'
                                    || v_mappings_tb(i).input_code_1
                                    || ' WHERE MIGRATION_SET_ID = :PT_I_MIGRATIONSETID';

                    EXECUTE IMMEDIATE v_select_sql BULK COLLECT
                    INTO v_segments_tb
                        USING pt_i_migrationsetid;
                EXCEPTION
                    WHEN OTHERS THEN
                        dbms_output.put_line('Error in getting code Combination details ' || sqlerrm);
                        raise_application_error(-20111, 'Error text :' || dbms_utility.format_error_backtrace);
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
                                nvl(regexp_substr(v_segments_tb(j).code_combinations, '[^.]+', 1, 1), '-'),
                                nvl(regexp_substr(v_segments_tb(j).code_combinations, '[^.]+', 1, 2), '-'),
                                nvl(regexp_substr(v_segments_tb(j).code_combinations, '[^.]+', 1, 3), '-'),
                                nvl(regexp_substr(v_segments_tb(j).code_combinations, '[^.]+', 1, 4), '-'),
                                nvl(regexp_substr(v_segments_tb(j).code_combinations, '[^.]+', 1, 5), '-'),
                                nvl(regexp_substr(v_segments_tb(j).code_combinations, '[^.]+', 1, 6), '-'),
                                nvl(regexp_substr(v_segments_tb(j).code_combinations, '[^.]+', 1, 7), '-')
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
                                dbms_output.put_line('Error in getting individual segment details for table:  '
                                                     || v_mappings_tb(i).input_code_1
                                                     || ' rowid: '
                                                     || v_segments_tb(j).rid
                                                     || ' column: '
                                                     || v_mappings_tb(i).output_code_1);

                                raise_application_error(-20111, 'Error text :' || dbms_utility.format_error_backtrace);
                        END;

                        IF v_segment1 = '-' THEN
                            dbms_output.put_line('Error in getting account values from mapping master for table:  '
                                                 || v_mappings_tb(i).input_code_1
                                                 || ' rowid: '
                                                 || v_segments_tb(j).rid
                                                 || ' column: '
                                                 || v_mappings_tb(i).output_code_1);

                            GOTO skip_update;
                        ELSIF v_segment1 IS NOT NULL AND v_segment7 = '-' THEN
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
                                    dbms_output.put_line('Error in getting xxmx_mapping_master company value' || sqlerrm);
                                    raise_application_error(-20111, 'Error text :' || dbms_utility.format_error_backtrace);
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
                                        WHEN 'A'    THEN
                                            '0000'
                                        WHEN 'L'    THEN
                                            '0000'
                                        WHEN 'O'    THEN
                                            '0000'
                                        WHEN 'E'    THEN
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
                                        WHEN 'R'    THEN
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
                                        WHEN NULL   THEN
                                            'Please define Mapping'
                                    END
                                INTO v_tr_segment4
                                FROM
                                    dual;
                                    
                            BEGIN
               
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
                            EXCEPTION
                                WHEN NO_DATA_FOUND THEN 
                                v_tr_segment5 := '0000';
                                WHEN OTHERS THEN
                                    dbms_output.put_line('Error in getting xxmx_mapping_master company value' || sqlerrm);
                                    raise_application_error(-20111, 'Error text :' || dbms_utility.format_error_backtrace);
                                    GOTO skip_update;
                            END;

                            EXCEPTION
                                WHEN OTHERS THEN
                                    dbms_output.put_line('Error in getting location details ' || sqlerrm);
                                    raise_application_error(-20111, 'Error text :' || dbms_utility.format_error_backtrace);
                                    GOTO skip_update;
                            END;
                            
                           /* ELSIF v_segment5 IS NOT NULL THEN 
                            */

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
                                               || v_tr_segment5
                                               || '.'
                                               || v_tr_segment6
                                               || '.'
                                               || v_tr_segment7;

                        ELSE
                            dbms_output.put_line('The segments are not in right state to transform');
                        END IF;

                    EXCEPTION
                        WHEN OTHERS THEN
                            dbms_output.put_line('Error in defining code combinations  for for table:  '
                                                 || v_mappings_tb(i).input_code_1
                                                 || ' rowid: '
                                                 || v_segments_tb(j).rid
                                                 || ' column: '
                                                 || v_mappings_tb(i).output_code_1);

                            GOTO skip_update;
                    END;

                    BEGIN
                        v_update_sql := 'UPDATE xxmx_xfm.'
                                        || v_mappings_tb(i).input_code_1
                                        || ' SET '
                                        || v_mappings_tb(i).output_code_1
                                        || '  =:v_tr_code_combo WHERE rowid = :v_rowid and MIGRATION_SET_ID= :PT_I_MIGRATIONSETID'
                                        ;

                        EXECUTE IMMEDIATE v_update_sql
                            USING v_tr_code_combo, v_segments_tb(j).rid, pt_i_migrationsetid;
--                        dbms_output.put_line('updated code  values for table  '
--                                             || v_mappings_tb(i).input_code_1
--                                             || ' rowid: '
--                                             || v_segments_tb(j).rid
--                                             || ' column: '
--                                             || v_mappings_tb(i).output_code_1
--                                             || ' Code combination value: '
--                                             || v_tr_code_combo);


                    EXCEPTION
                        WHEN OTHERS THEN
                            dbms_output.put_line('Error in updating table  '
                                                 || v_mappings_tb(i).input_code_1
                                                 || ' rowid: '
                                                 || v_segments_tb(j).rid
                                                 || ' column: '
                                                 || v_mappings_tb(i).output_code_1
                                                 || ' Code combination value: '
                                                 || v_tr_code_combo);
                    END;

                    << skip_update >> dbms_output.put_line('End');
                END LOOP;

            END IF;

            COMMIT;
        END LOOP;

    EXCEPTION
        WHEN OTHERS THEN
            v_table_name := NULL;
            dbms_output.put_line('Error in Procedure XXMX_CITCO_FA_LOCATION.xx_gl_code_combo');
            dbms_output.put_line('Error Message :' || sqlerrm);
            dbms_output.put_line('Error text :' || dbms_utility.format_error_backtrace);
            raise_application_error(-20111, 'Error text :' || dbms_utility.format_error_backtrace);
    END xx_gl_code_combo;
END xxmx_citco_fa_location;

/
