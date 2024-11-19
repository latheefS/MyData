--------------------------------------------------------
--  DDL for Package Body XXMX_CITCO_AP_EXT_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "XXMX_CORE"."XXMX_CITCO_AP_EXT_PKG" AS

    PROCEDURE transform_sup_bank_branches (
        pt_i_applicationsuite      IN    xxmx_seeded_extensions.application_suite%TYPE,
        pt_i_application           IN    xxmx_seeded_extensions.application%TYPE,
        pt_i_businessentity        IN    xxmx_seeded_extensions.business_entity%TYPE,
        pt_i_subentity             IN    xxmx_seeded_extensions.business_entity%TYPE,
        pt_i_stgpopulationmethod   IN    xxmx_core_parameters.parameter_value%TYPE,
        pt_i_filesetid             IN    xxmx_migration_headers.file_set_id%TYPE,
        pt_i_migrationsetid        IN    xxmx_migration_headers.migration_set_id%TYPE,
        pv_o_returnstatus          OUT   VARCHAR2
    ) IS

        v_select_sql            VARCHAR2(250);
        v_update_sql            VARCHAR2(250);
        v_rowid                 VARCHAR2(200);
        l_bank_name             VARCHAR2(250);
        l_bank_branch           VARCHAR2(250);
        l_bank_branch_country   VARCHAR2(100);
        v_table_name            VARCHAR2(250);
        l_account_type          VARCHAR2(1);
        l_location              VARCHAR2(250);
        l_gl_counts             NUMBER := 0;
        TYPE v_banks_record IS RECORD (
            rid                     VARCHAR2(250),
            v_bank_name             VARCHAR2(250),
            v_bank_branch           VARCHAR2(250),
            v_bank_branch_country   VARCHAR2(250)
        );
        TYPE v_banks_tbl IS
            TABLE OF v_banks_record INDEX BY BINARY_INTEGER;
        v_banks_tb              v_banks_tbl := v_banks_tbl();
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
                dbms_output.put_line('Error in Procedure xxmx_citco_ap_ext_pkg.transform_sup_bank_branches');
                dbms_output.put_line('Error Message :' || sqlerrm);
                dbms_output.put_line('Error text :' || dbms_utility.format_error_backtrace);
                raise_application_error(-20111, 'Error text :' || dbms_utility.format_error_backtrace);
        END;

        IF v_table_name IS NULL THEN
            dbms_output.put_line('Error in Procedure xxmx_citco_ap_ext_pkg.transform_sup_bank_branches no table mapping exists');
        ELSE
            v_select_sql := 'Select rowid,bank_Name,BRANCH_NAME,COUNTRY_CODE from xxmx_xfm.'
                            || v_table_name
                            || ' WHERE MIGRATION_SET_ID = :PT_I_MIGRATIONSETID';
            EXECUTE IMMEDIATE v_select_sql BULK COLLECT
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
                        AND upper(xmm.input_code_1) = upper(v_banks_tb(i).v_bank_name
                                                            || '|'
                                                            || v_banks_tb(i).v_bank_branch
                                                            || '|'
                                                            || v_banks_tb(i).v_bank_branch_country)
                        AND ROWNUM = 1;

                EXCEPTION
                    WHEN OTHERS THEN
                        dbms_output.put_line(sqlerrm
                                             || '      '
                                             || v_banks_tb(i).v_bank_name
                                             || '|'
                                             || v_banks_tb(i).v_bank_branch
                                             || '|'
                                             || v_banks_tb(i).v_bank_branch_country);

                        dbms_output.put_line('Error in getting account values from mapping master v_banks_tb(i).rid: '
                                             || v_banks_tb(i).rid
                                             || ' Bank Name value: '
                                             || l_bank_name
                                             || ' Bank Branch value: '
                                             || l_bank_branch
                                             || ' Branch country  value: '
                                             || l_bank_branch_country);

                END;

                IF l_bank_name IS NOT NULL AND l_bank_branch IS NOT NULL AND l_bank_branch_country IS NOT NULL THEN
                    BEGIN
                        v_update_sql := 'UPDATE xxmx_xfm.'
                                        || v_table_name
                                        || ' SET bank_Name=:l_bank_name,BRANCH_NAME=:l_bank_branch,COUNTRY_CODE=:l_bank_branch_COUNTRY WHERE rowid = :v_rowid and MIGRATION_SET_ID= :PT_I_MIGRATIONSETID'
                                        ;
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
                            dbms_output.put_line('Error in updating location values for v_banks_tb(i).rid: ' || v_banks_tb(i).rid
                            );
                    END;

                ELSE
                    dbms_output.put_line('Bank values not updated for v_banks_tb(i).rid: '
                                         || v_banks_tb(i).rid
                                         || ' Bank Name value: '
                                         || l_bank_name
                                         || ' Bank Branch value: '
                                         || l_bank_branch
                                         || ' Branch country  value: '
                                         || l_bank_branch_country);
                END IF;

            END LOOP;
        --

        END IF;

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN

                --
            ROLLBACK;
            dbms_output.put_line('Error in Procedure xxmx_citco_ap_ext_pkg.transform_sup_bank_branches');
            dbms_output.put_line('Error Message :' || sqlerrm);
            dbms_output.put_line('Error text :' || dbms_utility.format_error_backtrace);
            raise_application_error(-20111, 'Error text :' || dbms_utility.format_error_backtrace);
    END transform_sup_bank_branches;

END xxmx_citco_ap_ext_pkg;

/
