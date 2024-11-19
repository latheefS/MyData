--------------------------------------------------------
--  DDL for Package Body XXMX_CITCO_GL_EXT_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "XXMX_CORE"."XXMX_CITCO_GL_EXT_PKG" AS

    PROCEDURE transform_gl_location (
        pt_i_applicationsuite      IN    xxmx_seeded_extensions.application_suite%TYPE,
        pt_i_application           IN    xxmx_seeded_extensions.application%TYPE,
        pt_i_businessentity        IN    xxmx_seeded_extensions.business_entity%TYPE,
        pt_i_stgpopulationmethod   IN    xxmx_core_parameters.parameter_value%TYPE,
        pt_i_filesetid             IN    xxmx_migration_headers.file_set_id%TYPE,
        pt_i_migrationsetid        IN    xxmx_migration_headers.migration_set_id%TYPE,
        pv_o_returnstatus          OUT   VARCHAR2
    ) IS

        tablename               VARCHAR2(200);
        v_select_sql            VARCHAR2(250);
        v_mapping_sql           VARCHAR2(250);
        v_update_sql            VARCHAR2(250);
        v_rowid                 VARCHAR2(200);
        v_segment1              VARCHAR2(100);
        v_segment2              VARCHAR2(100);
        v_segment1_name         VARCHAR2(100);
        v_segment2_name         VARCHAR2(100);
        v_segment4_name         VARCHAR2(100);
        v_trans_segment1        VARCHAR2(100);
        v_table_name            VARCHAR2(250);
        l_account_type          VARCHAR2(1);
        l_location              VARCHAR2(250);
        l_gl_counts             NUMBER := 0;
        v_bill_to_location   VARCHAR2(250);
        TYPE v_segments_record IS RECORD (
            rid        VARCHAR2(250),
            segment1   VARCHAR2(250),
            segment2   VARCHAR2(250)
        );
        TYPE v_mappings_record IS RECORD (
            input_code_1    VARCHAR2(250),
            output_code_1   VARCHAR2(250),
            output_code_2   VARCHAR2(250),
            output_code_3   VARCHAR2(250)
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

            v_mapping_sql := 'SELECT INPUT_CODE_1,OUTPUT_CODE_1 ,OUTPUT_CODE_2,OUTPUT_CODE_3   FROM    xxmx_mapping_master WHERE  application = :pt_i_application'
                             || ' AND CATEGORY_CODE ='
                             || '''COA_SEGMENTS'''                            
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
        FOR i IN 1..v_mappings_tb.count LOOP
            IF v_mappings_tb(i).input_code_1 IS NULL THEN
--                dbms_output.put_line('Error in Procedure XXMX_CITCO_GL_EXT_PKG.transform_gl_location no table mapping exists');
            null;
            ELSE

                v_table_name := v_mappings_tb(i).input_code_1;
                v_rowid := NULL;
                v_segment1 := NULL;
                v_segment2 := NULL;
                v_trans_segment1 := NULL;
                v_segment1_name := v_mappings_tb(i).output_code_1;
                v_segment2_name := v_mappings_tb(i).output_code_2;
                v_segment4_name := v_mappings_tb(i).output_code_3;
                v_select_sql := 'Select rowid,'
                                || v_segment1_name
                                || ','
                                || v_segment2_name
                                || ' from xxmx_xfm.'
                                || v_table_name
                                || ' WHERE MIGRATION_SET_ID = :PT_I_MIGRATIONSETID';

                EXECUTE IMMEDIATE v_select_sql BULK COLLECT
                INTO v_segments_tb
                    USING pt_i_migrationsetid;
                FOR i IN 1..v_segments_tb.count LOOP
                    BEGIN

                        v_rowid := v_segments_tb(i).rid;
                        v_segment1 := v_segments_tb(i).segment1;
                        v_segment2 := v_segments_tb(i).segment2;
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
                                        || '= :v_trans_segment1 WHERE rowid = :v_rowid and MIGRATION_SET_ID= :PT_I_MIGRATIONSETID'
                                        ;

                        EXECUTE IMMEDIATE v_update_sql
                            USING l_location, v_trans_segment1, v_rowid, pt_i_migrationsetid;
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
            dbms_output.put_line('Error in Procedure XXMX_CITCO_GL_EXT_PKG.transform_gl_location');
            dbms_output.put_line('Error Message :' || sqlerrm);
            dbms_output.put_line('Error text :' || dbms_utility.format_error_backtrace);
            raise_application_error(-20111, 'Error text :' || dbms_utility.format_error_backtrace);
    END transform_gl_location;

    PROCEDURE transform_gl_code_combo (
        pt_i_applicationsuite      IN    xxmx_seeded_extensions.application_suite%TYPE,
        pt_i_application           IN    xxmx_seeded_extensions.application%TYPE,
        pt_i_businessentity        IN    xxmx_seeded_extensions.business_entity%TYPE,
        pt_i_stgpopulationmethod   IN    xxmx_core_parameters.parameter_value%TYPE,
        pt_i_filesetid             IN    xxmx_migration_headers.file_set_id%TYPE,
        pt_i_migrationsetid        IN    xxmx_migration_headers.migration_set_id%TYPE,
        pv_o_returnstatus          OUT   VARCHAR2
    ) IS

        tablename         VARCHAR2(200);
        v_select_sql      VARCHAR2(250);
        v_mapping_sql     VARCHAR2(250);
        v_update_sql      VARCHAR2(250);
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
                dbms_output.put_line('Error in Procedure XXMX_CITCO_GL_EXT_PKG.transform_gl_code_combo no table mapping exists');
            ELSE
                BEGIN
                IF pt_i_application = 'HR' THEN 
                  v_select_sql := 'Select rowid,'
                                    || v_mappings_tb(i).output_code_1
                                    || ' from xxmx_xfm.'
                                    || v_mappings_tb(i).input_code_1
                                    || ' WHERE MIGRATION_SET_ID = :PT_I_MIGRATIONSETID AND ACTION_CODE = ''CURRENT''';
ELSE
                    v_select_sql := 'Select rowid,'
                                    || v_mappings_tb(i).output_code_1
                                    || ' from xxmx_xfm.'
                                    || v_mappings_tb(i).input_code_1
                                    || ' WHERE MIGRATION_SET_ID = :PT_I_MIGRATIONSETID';
END IF;
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
                         /*   dbms_output.put_line('Error in getting account values from mapping master for table:  '
                                                 || v_mappings_tb(i).input_code_1
                                                 || ' rowid: '
                                                 || v_segments_tb(j).rid
                                                 || ' column: '
                                                 || v_mappings_tb(i).output_code_1);*/

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

                            EXCEPTION
                                WHEN OTHERS THEN
                                    dbms_output.put_line('Error in getting location details ' || sqlerrm);
                                    raise_application_error(-20111, 'Error text :' || dbms_utility.format_error_backtrace);
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
                                               || v_segment5
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
--                     /*   dbms_output.put_line('updated code  values for table  '
--                                             || v_mappings_tb(i).input_code_1
--                                             || ' rowid: '
--                                             || v_segments_tb(j).rid
--                                             || ' column: '
--                                             || v_mappings_tb(i).output_code_1
--                                             || ' Code combination value: '
--                                             || v_tr_code_combo);*/


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

                    << skip_update >> null;--dbms_output.put_line('End');
                END LOOP;

            END IF;

            COMMIT;
        END LOOP;

    EXCEPTION
        WHEN OTHERS THEN
            v_table_name := NULL;
            dbms_output.put_line('Error in Procedure XXMX_CITCO_GL_EXT_PKG.transform_gl_code_combo');
            dbms_output.put_line('Error Message :' || sqlerrm);
            dbms_output.put_line('Error text :' || dbms_utility.format_error_backtrace);
            raise_application_error(-20111, 'Error text :' || dbms_utility.format_error_backtrace);
    END transform_gl_code_combo;

 PROCEDURE transform_ref_code ( 
        pt_i_applicationsuite      IN    xxmx_seeded_extensions.application_suite%TYPE,
        pt_i_application           IN    xxmx_seeded_extensions.application%TYPE,
        pt_i_businessentity        IN    xxmx_seeded_extensions.business_entity%TYPE,
        pt_i_stgpopulationmethod   IN    xxmx_core_parameters.parameter_value%TYPE,
        pt_i_filesetid             IN    xxmx_migration_headers.file_set_id%TYPE,
        pt_i_migrationsetid        IN    xxmx_migration_headers.migration_set_id%TYPE,
        pv_o_returnstatus          OUT   VARCHAR2
    )
    IS 

    BEGIN 

    UPDATE xxmx_gl_opening_balances_xfm 
    SET reference21 = reference10,reference22 = reference10
    WHERE migration_set_id=pt_i_migrationsetid;

    UPDATE xxmx_gl_summary_balances_xfm 
    SET reference21 = reference10,reference22 = reference10
    WHERE migration_set_id=pt_i_migrationsetid;

	COMMIT;

        EXCEPTION
            WHEN OTHERS THEN
                    raise_application_error(-20111, 'Error text :' || dbms_utility.format_error_backtrace);
        END transform_ref_code;

END xxmx_citco_gl_ext_pkg;

/
