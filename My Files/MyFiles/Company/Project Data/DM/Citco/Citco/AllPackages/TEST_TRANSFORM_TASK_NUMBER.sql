--------------------------------------------------------
--  DDL for Procedure TEST_TRANSFORM_TASK_NUMBER
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "XXMX_CORE"."TEST_TRANSFORM_TASK_NUMBER" (
        pt_i_applicationsuite      IN    xxmx_seeded_extensions.application_suite%TYPE,
        pt_i_application           IN    xxmx_seeded_extensions.application%TYPE,
        pt_i_businessentity        IN    xxmx_seeded_extensions.business_entity%TYPE,
--        pt_i_subentity             IN    xxmx_seeded_extensions.business_entity%TYPE,
        pt_i_stgpopulationmethod   IN    xxmx_core_parameters.parameter_value%TYPE,       
        pt_i_migrationsetid        IN    xxmx_migration_headers.migration_set_id%TYPE
    ) IS

        v_select_sql            VARCHAR2(250);
        v_update_sql            VARCHAR2(250);
        v_rowid                 VARCHAR2(200);
        l_task_number           VARCHAR2(250);
        v_table_name            VARCHAR2(250);
        v_task_number           VARCHAR2(250);
        TYPE v_projects_record IS RECORD (
		     rid                VARCHAR2(250),
             v_task_number      VARCHAR2(250)
                                             );
        TYPE v_projects_tbl IS
            TABLE OF v_projects_record INDEX BY BINARY_INTEGER;
        v_projects_tb              v_projects_tbl := v_projects_tbl();
    BEGIN

/*
        BEGIN
            SELECT
                xfm_table
            INTO v_table_name
            FROM
                xxmx_migration_metadata
            WHERE
                business_entity = pt_i_businessentity
                AND sub_entity = 'TASKS';
--      dbms_output.put_line('v_table_name :' ||v_table_name);
        EXCEPTION
            WHEN OTHERS THEN
                v_table_name := NULL;
                dbms_output.put_line('Error in Procedure xxmx_ppm_ext_pkg.transform_task_number');
                dbms_output.put_line('Error Message :' || sqlerrm);
                dbms_output.put_line('Error text :' || dbms_utility.format_error_backtrace);
                raise_application_error(-20111, 'Error text :' || dbms_utility.format_error_backtrace);
        END;

        IF v_table_name IS NULL THEN
            dbms_output.put_line('Error in Procedure xxmx_ppm_ext_pkg.transform_task_number no table mapping exists');
        ELSE
            v_select_sql := 'SELECT rowid,task_number from ' 
                            || v_table_name
                            || ' WHERE migration_set_id = :PT_I_MIGRATIONSETID';
            EXECUTE IMMEDIATE v_select_sql BULK COLLECT
            INTO v_projects_tb
                USING pt_i_migrationsetid;
--                dbms_output.put_line('v_select_sql :' ||v_select_sql);
            FOR i IN 1..v_projects_tb.count LOOP
                BEGIN
		            v_rowid       := NULL;
                    v_task_number := NULL;
				    v_rowid       := v_projects_tb(i).rid;
					v_task_number := v_projects_tb(i).v_task_number;

                    SELECT
                        xmm.output_code_1
                    INTO
                        l_task_number
                    FROM
                        xxmx_mapping_master xmm
                    WHERE
                        xmm.application         = 'PPM'
--                        AND xmm.business_entity = 'PROJECTS'
--                        AND xmm.sub_entity      = 'TASKS'
						AND xmm.category_code   = 'TASK_NUMBER'
                        AND upper(xmm.input_code_1) = upper(v_task_number) --upper(v_projects_tb(i).v_task_number)
                        AND ROWNUM = 1;
--                dbms_output.put_line('v_task_number :' ||v_task_number);
                EXCEPTION
                WHEN NO_DATA_FOUND THEN
                     NULL;   
                WHEN OTHERS THEN
                        dbms_output.put_line(sqlerrm
                                             || '      '
                                             || v_projects_tb(i).v_task_number
                                             );

                        dbms_output.put_line('Error in getting values from mapping master v_projects_tb(i).rid: '
                                             || v_projects_tb(i).rid
                                             || ' task_number Name: '
                                             || l_task_number
                                            );

                END;

                IF l_task_number IS NOT NULL THEN
                    BEGIN
                        v_update_sql := 'UPDATE '
                                        || v_table_name
                                        || ' SET task_number= nvl(:l_task_number,task_number) WHERE rowid = :v_rowid and MIGRATION_SET_ID= :pt_i_migrationsetid'
                                        ;
                        EXECUTE IMMEDIATE v_update_sql
                            USING l_task_number, v_rowid, pt_i_migrationsetid;
--   dbms_output.put_line('Test : '|| v_update_sql);
--                        dbms_output.put_line('updated project Task Number values for v_projects_tb(i).rid: '
--                                             || v_rowid
--                                             || ' task_number value: '
--                                            || l_task_number
--                                             );

                    EXCEPTION
                      WHEN NO_DATA_FOUND THEN
                           NULL;                      
--                        WHEN OTHERS THEN
--                            dbms_output.put_line('Error in updating values for v_projects_tb(i).rid: ' || v_projects_tb(i).rid
--                            );
                    END;

                ELSE
                BEGIN
                null;
--                    dbms_output.put_line('task_number value not updated for v_projects_tb(i).rid: '
--                                         || v_projects_tb(i).rid
--                                         || ' task_number Name value: '
--                                         || l_task_number
--                                        ); 
--                    dbms_output.put_line('Test : '|| v_update_sql);

             EXCEPTION
               WHEN NO_DATA_FOUND THEN
               NULL; 
               WHEN OTHERS THEN
               NULL; 
               END;
            END IF;
            END LOOP;
        --

        END IF;
*/

        UPDATE xxmx_ppm_prj_Tasks_xfm_test x  
               set x.task_number = nvl((select xmm.output_code_1
                                    from xxmx_mapping_master xmm
                                     WHERE
                                           xmm.application     = 'PPM'
					                   AND xmm.category_code   = 'TASK_NUMBER'
                                       AND upper(xmm.input_code_1) = upper(x.task_number) 
                                       AND ROWNUM = 1
                                       ),x.task_number)
                where  x.MIGRATION_SET_ID = pt_i_migrationsetid
                  and  x.task_number is not null;

        COMMIT;
--
        DELETE FROM xxmx_ppm_prj_Tasks_xfm_test where task_number='N/A';
--
            UPDATE xxmx_ppm_prj_Tasks_xfm_test x 
               set x.parent_task_number = nvl((select xmm.output_code_1
                                    from xxmx_mapping_master xmm
                                     WHERE
                                           xmm.application     = 'PPM'
					                   AND xmm.category_code   = 'TASK_NUMBER'
                                       AND upper(xmm.input_code_1) = upper(x.parent_task_number) 
                                       AND ROWNUM = 1
                                       ),x.parent_task_number)
                where  x.MIGRATION_SET_ID = pt_i_migrationsetid
                  and  x.parent_task_number is not null;

        DELETE FROM xxmx_ppm_prj_Tasks_xfm_test where parent_task_number='N/A';

        DELETE FROM xxmx_ppm_prj_Tasks_xfm_test t
        where t.parent_task_number is not null
        and not exists 
            (select null from xxmx_ppm_prj_Tasks_xfm_test p 
             where p.project_number = t.project_number
               and p.task_number    = t.parent_task_number);


		COMMIT;
--		
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
         NULL;    
        WHEN OTHERS THEN

                --
            ROLLBACK;
            dbms_output.put_line('Error in Procedure xxmx_ppm_ext_pkg.transform_task_number');
            dbms_output.put_line('Error Message :' || sqlerrm);
            dbms_output.put_line('Error text :' || dbms_utility.format_error_backtrace);
            raise_application_error(-20111, 'Error text :' || dbms_utility.format_error_backtrace);
    END test_transform_task_number;
    
    
    
    select * from xxmx_ppm_prj_Tasks_xfm_test

/
