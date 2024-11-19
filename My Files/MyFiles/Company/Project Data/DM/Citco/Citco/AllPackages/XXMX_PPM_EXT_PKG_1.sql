--------------------------------------------------------
--  DDL for Package Body XXMX_PPM_EXT_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "XXMX_CORE"."XXMX_PPM_EXT_PKG" AS

    PROCEDURE transform_project_template (
        pt_i_applicationsuite      IN    xxmx_seeded_extensions.application_suite%TYPE,
        pt_i_application           IN    xxmx_seeded_extensions.application%TYPE,
        pt_i_businessentity        IN    xxmx_seeded_extensions.business_entity%TYPE,
--        pt_i_subentity             IN    xxmx_seeded_extensions.business_entity%TYPE,
        pt_i_stgpopulationmethod   IN    xxmx_core_parameters.parameter_value%TYPE,
        pt_i_filesetid             IN    xxmx_migration_headers.file_set_id%TYPE,
        pt_i_migrationsetid        IN    xxmx_migration_headers.migration_set_id%TYPE,
        pv_o_returnstatus          OUT   VARCHAR2
    ) IS

        v_select_sql            VARCHAR2(250); 
        v_update_sql            VARCHAR2(250);
        v_rowid                 VARCHAR2(200);
        l_template              VARCHAR2(250);
        v_table_name            VARCHAR2(250);
        TYPE v_projects_record IS RECORD (
		     rid                VARCHAR2(250),
             v_template         VARCHAR2(250)
                                             );
        TYPE v_projects_tbl IS
            TABLE OF v_projects_record INDEX BY BINARY_INTEGER;
        v_projects_tb              v_projects_tbl := v_projects_tbl();
    BEGIN
        BEGIN
            SELECT
                xfm_table
            INTO v_table_name
            FROM
                xxmx_migration_metadata
            WHERE
                business_entity = pt_i_businessentity
                AND sub_entity = 'PROJECTS';

        EXCEPTION
            WHEN OTHERS THEN
                v_table_name := NULL;
                dbms_output.put_line('Error in Procedure xxmx_ppm_ext_pkg.transform_project_template');
                dbms_output.put_line('Error Message :' || sqlerrm);
                dbms_output.put_line('Error text :' || dbms_utility.format_error_backtrace);
                raise_application_error(-20111, 'Error text :' || dbms_utility.format_error_backtrace);
        END;

        IF v_table_name IS NULL THEN
            dbms_output.put_line('Error in Procedure xxmx_ppm_ext_pkg.transform_project_template no table mapping exists');
        ELSE
            v_select_sql := 'SELECT rowid,source_template_number from '
                            || v_table_name
                            || ' WHERE migration_set_id = :PT_I_MIGRATIONSETID';
            EXECUTE IMMEDIATE v_select_sql BULK COLLECT
            INTO v_projects_tb
                USING pt_i_migrationsetid;
            FOR i IN 1..v_projects_tb.count LOOP
                BEGIN
                    SELECT
                        xmm.output_code_1
                    INTO
                        l_template
                    FROM
                        xxmx_mapping_master xmm
                    WHERE
                        xmm.application             = 'PPM'
                     --   AND xmm.business_entity     = 'PROJECTS'
                     --   AND xmm.sub_entity          = 'PROJECTS'
                        AND upper(xmm.input_code_1) != upper(xmm.output_code_1)
						AND xmm.category_code       = 'SOURCE_TEMPLATE_NUMBER'
                        AND upper(xmm.input_code_1) = upper(v_projects_tb(i).v_template)
                        AND ROWNUM = 1;

                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                    NULL;				
                    WHEN OTHERS THEN
                        dbms_output.put_line(sqlerrm
                                             || '      '
                                             || v_projects_tb(i).v_template
                                             );

                        dbms_output.put_line('Error in getting values from mapping master v_projects_tb(i).rid: '
                                             || v_projects_tb(i).rid
                                             || ' Template Name: '
                                             || l_template
                                            );

                END;

                IF l_template IS NOT NULL THEN
                    BEGIN
                        v_update_sql := 'UPDATE xxmx_xfm.'
                                        || v_table_name
                                        || ' SET source_template_number=:l_template WHERE rowid = :v_rowid and MIGRATION_SET_ID= :PT_I_MIGRATIONSETID'
                                        ;
                        EXECUTE IMMEDIATE v_update_sql
                            USING l_template, v_projects_tb(i).rid, pt_i_migrationsetid;

                   /*     dbms_output.put_line('updated Source Template values for v_projects_tb(i).rid: '
                                             || v_projects_tb(i).rid
                                             || ' Template Name value: '
                                             || l_template
                                             ); */

                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                           NULL;                    
                        WHEN OTHERS THEN
                        dbms_output.put_line('Error in updating location values for sql ' || v_update_sql );
                            dbms_output.put_line('Error in updating location values for v_projects_tb(i).rid: ' || v_projects_tb(i).rid
                            );
                    END;

                ELSE

                  null;
  /*                  dbms_output.put_line('Template value not updated for v_projects_tb(i).rid: '
                                         || v_projects_tb(i).rid
                                         || ' Template Name value: '
                                         || l_template
                                        ); */
                END IF;

            END LOOP;
        --

        END IF;

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN

                --
            ROLLBACK;
            dbms_output.put_line('Error in Procedure xxmx_ppm_ext_pkg.transform_project_template');
            dbms_output.put_line('Error Message :' || sqlerrm);
            dbms_output.put_line('Error text :' || dbms_utility.format_error_backtrace);
            raise_application_error(-20111, 'Error text :' || dbms_utility.format_error_backtrace);
    END transform_project_template;
--
   PROCEDURE transform_poo (
        pt_i_applicationsuite      IN    xxmx_seeded_extensions.application_suite%TYPE,
        pt_i_application           IN    xxmx_seeded_extensions.application%TYPE,
        pt_i_businessentity        IN    xxmx_seeded_extensions.business_entity%TYPE,
--        pt_i_subentity             IN    xxmx_seeded_extensions.business_entity%TYPE,
        pt_i_stgpopulationmethod   IN    xxmx_core_parameters.parameter_value%TYPE,
        pt_i_filesetid             IN    xxmx_migration_headers.file_set_id%TYPE,
        pt_i_migrationsetid        IN    xxmx_migration_headers.migration_set_id%TYPE,
        pv_o_returnstatus          OUT   VARCHAR2
    ) IS

        v_select_sql            VARCHAR2(250);
        v_update_sql            VARCHAR2(250);
        v_rowid                 VARCHAR2(200);
        l_poo                   VARCHAR2(250);
        v_table_name            VARCHAR2(250);
        TYPE v_projects_record IS RECORD (
		     rid                VARCHAR2(250),
             v_poo              VARCHAR2(250)
                                             );
        TYPE v_projects_tbl IS
            TABLE OF v_projects_record INDEX BY BINARY_INTEGER;
        v_projects_tb              v_projects_tbl := v_projects_tbl();
    BEGIN
        BEGIN
            SELECT
                xfm_table
            INTO v_table_name
            FROM
                xxmx_migration_metadata
            WHERE
                business_entity = pt_i_businessentity
                AND sub_entity = 'PROJECTS';

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                 NULL;		
            WHEN OTHERS THEN
                v_table_name := NULL;
                dbms_output.put_line('Error in Procedure xxmx_ppm_ext_pkg.transform_poo');
                dbms_output.put_line('Error Message :' || sqlerrm);
                dbms_output.put_line('Error text :' || dbms_utility.format_error_backtrace);
                raise_application_error(-20111, 'Error text :' || dbms_utility.format_error_backtrace);
        END;

        IF v_table_name IS NULL THEN
            dbms_output.put_line('Error in Procedure xxmx_ppm_ext_pkg.transform_poo no table mapping exists');
        ELSE
            v_select_sql := 'SELECT rowid,organization_name from xxmx_xfm.'
                            || v_table_name
                            || ' WHERE migration_set_id = :PT_I_MIGRATIONSETID';
            EXECUTE IMMEDIATE v_select_sql BULK COLLECT
            INTO v_projects_tb
                USING pt_i_migrationsetid;
            FOR i IN 1..v_projects_tb.count LOOP
                BEGIN
                    SELECT
                        xmm.output_code_1
                    INTO
                        l_poo
                    FROM
                        xxmx_mapping_master xmm
                    WHERE
                        xmm.application         = 'PPM'
--                        AND xmm.business_entity = 'PROJECTS'
--                        AND xmm.sub_entity      = 'PROJECTS'
						AND xmm.category_code   = 'BUSINESS_UNIT'
                        AND upper(xmm.input_code_1) = upper(v_projects_tb(i).v_poo)
                        AND ROWNUM = 1;

                EXCEPTION
	                WHEN NO_DATA_FOUND THEN
                         NULL;
                    WHEN OTHERS THEN
                        dbms_output.put_line(sqlerrm
                                             || '      '
                                             || v_projects_tb(i).v_poo
                                             );

                        dbms_output.put_line('Error in getting values from mapping master v_projects_tb(i).rid: '
                                             || v_projects_tb(i).rid
                                             || ' poo Name: '
                                             || l_poo
                                            );

                END;

                IF l_poo IS NOT NULL THEN
                    BEGIN
                        v_update_sql := 'UPDATE xxmx_xfm.'
                                        || v_table_name
                                        || ' SET organization_name=:l_poo WHERE rowid = :v_rowid and MIGRATION_SET_ID= :PT_I_MIGRATIONSETID'
                                        ;
                        EXECUTE IMMEDIATE v_update_sql
                            USING l_poo, v_projects_tb(i).rid, pt_i_migrationsetid;

/*                        dbms_output.put_line('updated project Owning Org values for v_projects_tb(i).rid: '
                                             || v_projects_tb(i).rid
                                             || ' poo Name value: '
                                             || l_poo
                                             );  */

                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                        NULL;
                        WHEN OTHERS THEN
                            dbms_output.put_line('Error in updating values for v_projects_tb(i).rid: ' || v_projects_tb(i).rid
                            );
                    END;

                ELSE
                    dbms_output.put_line('POO value not updated for v_projects_tb(i).rid: '
                                         || v_projects_tb(i).rid
                                         || ' poo Name value: '
                                         || l_poo
                                        );
                END IF;

            END LOOP;
        --

        END IF;

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN

                --
            ROLLBACK;
            dbms_output.put_line('Error in Procedure xxmx_ppm_ext_pkg.transform_poo');
            dbms_output.put_line('Error Message :' || sqlerrm);
            dbms_output.put_line('Error text :' || dbms_utility.format_error_backtrace);
            raise_application_error(-20111, 'Error text :' || dbms_utility.format_error_backtrace);
    END transform_poo;
    --
PROCEDURE transform_task_poo (
        pt_i_applicationsuite      IN    xxmx_seeded_extensions.application_suite%TYPE,
        pt_i_application           IN    xxmx_seeded_extensions.application%TYPE,
        pt_i_businessentity        IN    xxmx_seeded_extensions.business_entity%TYPE,
--        pt_i_subentity             IN    xxmx_seeded_extensions.business_entity%TYPE,
        pt_i_stgpopulationmethod   IN    xxmx_core_parameters.parameter_value%TYPE,
        pt_i_filesetid             IN    xxmx_migration_headers.file_set_id%TYPE,
        pt_i_migrationsetid        IN    xxmx_migration_headers.migration_set_id%TYPE,
        pv_o_returnstatus          OUT   VARCHAR2
    ) IS

        v_select_sql            VARCHAR2(250);

    BEGIN


            UPDATE XXMX_PPM_PRJ_TASKS_XFM x 
               set x.organization_name = nvl((select xmm.output_code_1
                                    from xxmx_mapping_master xmm
                                     WHERE
                                           xmm.application     = 'PPM'
					                   AND xmm.category_code   = 'PROJ_OWNING_ORG'
                                       AND upper(xmm.input_code_1) = upper(x.organization_name) 
                                       AND ROWNUM = 1
                                       ),x.organization_name)
                where  x.MIGRATION_SET_ID = pt_i_migrationsetid
                  and  x.organization_name is not null;

    EXCEPTION
        WHEN OTHERS THEN

                --
            ROLLBACK;
            dbms_output.put_line('Error in Procedure xxmx_ppm_ext_pkg.transform_poo');
            dbms_output.put_line('Error Message :' || sqlerrm);
            dbms_output.put_line('Error text :' || dbms_utility.format_error_backtrace);
            raise_application_error(-20111, 'Error text :' || dbms_utility.format_error_backtrace);
    END transform_task_poo;
--
   PROCEDURE transform_task_number (
        pt_i_applicationsuite      IN    xxmx_seeded_extensions.application_suite%TYPE,
        pt_i_application           IN    xxmx_seeded_extensions.application%TYPE,
        pt_i_businessentity        IN    xxmx_seeded_extensions.business_entity%TYPE,
--        pt_i_subentity             IN    xxmx_seeded_extensions.business_entity%TYPE,
        pt_i_stgpopulationmethod   IN    xxmx_core_parameters.parameter_value%TYPE,
        pt_i_filesetid             IN    xxmx_migration_headers.file_set_id%TYPE,
        pt_i_migrationsetid        IN    xxmx_migration_headers.migration_set_id%TYPE,
        pv_o_returnstatus          OUT   VARCHAR2
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

    /*    UPDATE XXMX_PPM_PRJ_TASKS_XFM x 
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
        DELETE FROM XXMX_PPM_PRJ_TASKS_XFM where task_number='N/A';
--
            UPDATE XXMX_PPM_PRJ_TASKS_XFM x 
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

        DELETE FROM XXMX_PPM_PRJ_TASKS_XFM where parent_task_number='N/A';

        DELETE FROM XXMX_PPM_PRJ_TASKS_XFM t
        where t.parent_task_number is not null
        and not exists 
            (select null from XXMX_PPM_PRJ_TASKS_XFM p 
             where p.project_number = t.project_number
               and p.task_number    = t.parent_task_number);


	*/	COMMIT;
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
    END transform_task_number;
-- 
--
   PROCEDURE transform_description (
        pt_i_applicationsuite      IN    xxmx_seeded_extensions.application_suite%TYPE,
        pt_i_application           IN    xxmx_seeded_extensions.application%TYPE,
        pt_i_businessentity        IN    xxmx_seeded_extensions.business_entity%TYPE,
--        pt_i_subentity             IN    xxmx_seeded_extensions.business_entity%TYPE,
        pt_i_stgpopulationmethod   IN    xxmx_core_parameters.parameter_value%TYPE,
        pt_i_filesetid             IN    xxmx_migration_headers.file_set_id%TYPE,
        pt_i_migrationsetid        IN    xxmx_migration_headers.migration_set_id%TYPE,
        pv_o_returnstatus          OUT   VARCHAR2
    ) IS

        v_select_sql            VARCHAR2(250);
        v_update_sql            VARCHAR2(250);
        v_rowid                 VARCHAR2(200);
        l_description           VARCHAR2(250);
        l_desc_from             VARCHAR2(250);
        v_table_name            VARCHAR2(250);
        TYPE v_projects_record IS RECORD (
		     rid                VARCHAR2(250),
             v_description      VARCHAR2(250)
                                             );
        TYPE v_projects_tbl IS
            TABLE OF v_projects_record INDEX BY BINARY_INTEGER;
        v_projects_tb           v_projects_tbl := v_projects_tbl();
    BEGIN
        BEGIN
            SELECT
                xfm_table
            INTO v_table_name
            FROM
                xxmx_migration_metadata
            WHERE
                business_entity = pt_i_businessentity
                AND sub_entity = 'PROJECTS';
--
        EXCEPTION
            WHEN OTHERS THEN
                v_table_name := NULL;
                dbms_output.put_line('Error in Procedure xxmx_ppm_ext_pkg.transform_description');
                dbms_output.put_line('Error Message :' || sqlerrm);
                dbms_output.put_line('Error text :' || dbms_utility.format_error_backtrace);
                raise_application_error(-20111, 'Error text :' || dbms_utility.format_error_backtrace);
        END;

        IF v_table_name IS NULL THEN
            dbms_output.put_line('Error in Procedure xxmx_ppm_ext_pkg.transform_description no table mapping exists');
        ELSE
            v_select_sql := 'SELECT rowid,description from '
                            || v_table_name
                            || ' WHERE migration_set_id = :PT_I_MIGRATIONSETID';
            EXECUTE IMMEDIATE v_select_sql BULK COLLECT
            INTO v_projects_tb
                USING pt_i_migrationsetid;
            FOR i IN 1..v_projects_tb.count LOOP
                BEGIN

                    l_description := null;
                    l_desc_from := null;

                    SELECT
                        substr(trim(xmm.output_code_1),1,6), substr(trim(xmm.input_code_1),1,6)
                    INTO
                        l_description, l_desc_from
                    FROM
                        xxmx_mapping_master xmm
                    WHERE
                        xmm.application         = 'PPM'
--                        AND xmm.business_entity = 'PROJECTS'
--                        AND xmm.sub_entity      = 'PROJECTS'
                        AND upper(xmm.input_code_1) != upper(xmm.output_code_1)
						AND xmm.category_code   = 'BUSINESS_UNIT'
                        AND upper(xmm.input_code_1) = upper(substr(v_projects_tb(i).v_description,1,6))
                        AND ROWNUM = 1;

                EXCEPTION
                WHEN NO_DATA_FOUND THEN
                     NULL;   
                WHEN OTHERS THEN
                        dbms_output.put_line(sqlerrm
                                             || '      '
                                             || v_projects_tb(i).v_description
                                             );

                        dbms_output.put_line('Error in getting values from mapping master v_projects_tb(i).rid: '
                                             || v_projects_tb(i).rid
                                             || ' description Name: '
                                             || l_description
                                            );

                END;

                IF l_description IS NOT NULL THEN
                    BEGIN
                        v_update_sql := 'UPDATE xxmx_xfm.'
                                        || v_table_name
                                        || ' SET description= nvl(replace(description, :l_desc_from,:l_description),description)' 
                                        || ' WHERE rowid = :v_rowid and MIGRATION_SET_ID= :PT_I_MIGRATIONSETID'
                                        ;
                        EXECUTE IMMEDIATE v_update_sql
                            USING l_desc_from, l_description, v_projects_tb(i).rid, pt_i_migrationsetid;

                        v_update_sql := 'UPDATE xxmx_xfm.'
                                        || v_table_name
                                        || ' SET project_name= nvl(replace(project_name, :l_desc_from,:l_description),project_name)' 
                                        || ' WHERE rowid = :v_rowid and MIGRATION_SET_ID= :PT_I_MIGRATIONSETID'
                                        ;
                        EXECUTE IMMEDIATE v_update_sql
                            USING l_desc_from, l_description, v_projects_tb(i).rid, pt_i_migrationsetid;

                        v_update_sql := 'UPDATE xxmx_xfm.'
                                        || v_table_name
                                        || ' SET source_template_number= nvl(replace(source_template_number, :l_desc_from,:l_description),source_template_number)' 
                                        || ' WHERE rowid = :v_rowid and MIGRATION_SET_ID= :PT_I_MIGRATIONSETID'
                                        ;
                        EXECUTE IMMEDIATE v_update_sql
                            USING l_desc_from, l_description, v_projects_tb(i).rid, pt_i_migrationsetid;

/*                     dbms_output.put_line('Test : '|| v_update_sql);
                        dbms_output.put_line('updated project Task Number values for v_projects_tb(i).rid: '
                                             || v_projects_tb(i).rid
                                             || ' description Name value: '
                                             || l_description
                                             ); */

                    EXCEPTION
                      WHEN NO_DATA_FOUND THEN
                           NULL;                      
--                        WHEN OTHERS THEN
--                            dbms_output.put_line('Error in updating values for v_projects_tb(i).rid: ' || v_projects_tb(i).rid
--                            );
                    END;

                ELSE
                BEGIN
				NULL;
/*                    dbms_output.put_line('description value not updated for v_projects_tb(i).rid: '
                                         || v_projects_tb(i).rid
                                         || ' description Name value: '
                                         || l_description
                                        ); */


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


--Handle mapped project_long_name in classifications and team members as well.

UPDATE XXMX_PPM_PRJ_CLASS_XFM x
set x.project_name = (select p.project_name  from XXMX_PPM_PROJECTS_XFM p
                    where  p.project_number = x.project_number)
   ,x.project_long_name = null
WHERE x.migration_set_id = pt_i_migrationsetid;

UPDATE XXMX_PPM_PRJ_TEAM_MEM_XFM x
set x.project_name = (select p.project_name  from XXMX_PPM_PROJECTS_XFM p
                    where  p.project_number = x.project_number)
   ,x.project_long_name = null
WHERE x.migration_set_id = pt_i_migrationsetid;

        COMMIT;
--
--		
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
         NULL;    
        WHEN OTHERS THEN

                --
            ROLLBACK;
            dbms_output.put_line('Error in Procedure xxmx_ppm_ext_pkg.transform_description');
            dbms_output.put_line('Error Message :' || sqlerrm);
            dbms_output.put_line('Error text :' || dbms_utility.format_error_backtrace);
            raise_application_error(-20111, 'Error text :' || dbms_utility.format_error_backtrace);
    END transform_description;	
-- 
--
   PROCEDURE transform_trx_control_task_num (
        pt_i_applicationsuite      IN    xxmx_seeded_extensions.application_suite%TYPE,
        pt_i_application           IN    xxmx_seeded_extensions.application%TYPE,
        pt_i_businessentity        IN    xxmx_seeded_extensions.business_entity%TYPE,
--        pt_i_subentity             IN    xxmx_seeded_extensions.business_entity%TYPE,
        pt_i_stgpopulationmethod   IN    xxmx_core_parameters.parameter_value%TYPE,
        pt_i_filesetid             IN    xxmx_migration_headers.file_set_id%TYPE,
        pt_i_migrationsetid        IN    xxmx_migration_headers.migration_set_id%TYPE,
        pv_o_returnstatus          OUT   VARCHAR2
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
                AND sub_entity = 'TRX_CONTROL';
--      dbms_output.put_line('v_table_name :' ||v_table_name);
        EXCEPTION
            WHEN OTHERS THEN
                v_table_name := NULL;
                dbms_output.put_line('Error in Procedure xxmx_ppm_ext_pkg.transform_trx_control_task_num');
                dbms_output.put_line('Error Message :' || sqlerrm);
                dbms_output.put_line('Error text :' || dbms_utility.format_error_backtrace);
                raise_application_error(-20111, 'Error text :' || dbms_utility.format_error_backtrace);
        END;

        IF v_table_name IS NULL THEN
            dbms_output.put_line('Error in Procedure xxmx_ppm_ext_pkg.transform_trx_control_task_num no table mapping exists');
        ELSE
            v_select_sql := 'SELECT rowid,task_number from xxmx_xfm.'
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
                        v_update_sql := 'UPDATE xxmx_xfm.'
                                        || v_table_name
                                        || ' SET task_number= nvl(:l_task_number,task_number) WHERE rowid = :v_rowid and MIGRATION_SET_ID= :pt_i_migrationsetid'
                                        ;
                        EXECUTE IMMEDIATE v_update_sql
                            USING l_task_number, v_rowid, pt_i_migrationsetid;

                    EXCEPTION
                      WHEN NO_DATA_FOUND THEN
                           NULL;
                          dbms_output.put_line('No Data Found in xfm table' );						   
--                        WHEN OTHERS THEN
--                            dbms_output.put_line('Error in updating values for v_projects_tb(i).rid: ' || v_projects_tb(i).rid
--                            );
                    END;

                END IF;
            END LOOP;
        --

        END IF;
*/


            UPDATE XXMX_PPM_PRJ_TRX_CONTROL_XFM x 
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
        DELETE FROM XXMX_PPM_PRJ_TRX_CONTROL_XFM where task_number='N/A';

        UPDATE  XXMX_PPM_PRJ_TRX_CONTROL_XFM set task_name = null, end_date_active = null;

        DELETE FROM XXMX_PPM_PRJ_TRX_CONTROL_XFM x  
        where x.task_number is not null
        and not  exists (select null from xxmx_ppm_prj_tasks_xfm t 
                         where t.task_number = x.task_number
                          and   t.project_number = x.project_number);


        DELETE FROM XXMX_PPM_PRJ_TRX_CONTROL_XFM x  
        where x.task_number is not null
        and x.rowid in (select max(t.rowid) from XXMX_PPM_PRJ_TRX_CONTROL_XFM t 
                     group by t.project_number,t.task_number,  t.expenditure_category_name, t.expenditure_type
                     having count(1) > 1);

--		
		COMMIT;
--		
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
         NULL;    
        WHEN OTHERS THEN

                --
            ROLLBACK;
            dbms_output.put_line('Error in Procedure xxmx_ppm_ext_pkg.transform_trx_control_task_num');
            dbms_output.put_line('Error Message :' || sqlerrm);
            dbms_output.put_line('Error text :' || dbms_utility.format_error_backtrace);
            raise_application_error(-20111, 'Error text :' || dbms_utility.format_error_backtrace);
    END transform_trx_control_task_num;
--
   PROCEDURE transform_team_member_role (
        pt_i_applicationsuite      IN    xxmx_seeded_extensions.application_suite%TYPE,
        pt_i_application           IN    xxmx_seeded_extensions.application%TYPE,
        pt_i_businessentity        IN    xxmx_seeded_extensions.business_entity%TYPE,
--        pt_i_subentity             IN    xxmx_seeded_extensions.business_entity%TYPE,
        pt_i_stgpopulationmethod   IN    xxmx_core_parameters.parameter_value%TYPE,
        pt_i_filesetid             IN    xxmx_migration_headers.file_set_id%TYPE,
        pt_i_migrationsetid        IN    xxmx_migration_headers.migration_set_id%TYPE,
        pv_o_returnstatus          OUT   VARCHAR2
    ) IS

 BEGIN

/*
            UPDATE xxmx_ppm_prj_team_mem_xfm x 
               set x.project_role = nvl((select xmm.output_code_1
                                    from xxmx_mapping_master xmm
                                     WHERE
                                           xmm.application     = 'PPM'
					                   AND xmm.category_code   = 'PROJECT_ROLE'
                                       AND upper(xmm.input_code_1) = upper(x.project_role) 
                                       AND ROWNUM = 1
                                       ),x.project_role)
                where  x.MIGRATION_SET_ID = pt_i_migrationsetid;
*/

            UPDATE xxmx_ppm_prj_team_mem_xfm x 
               set x.project_role = (select xmm.output_code_1
                                    from xxmx_mapping_master xmm
                                     WHERE
                                           xmm.application     = 'PPM'
					                   AND xmm.category_code   = 'PROJECT_ROLE'
                                       AND upper(xmm.input_code_1) = upper(x.project_role) 
                                       and xmm.output_code_1 is not null
                                       AND ROWNUM = 1
                                       )
                  ,x.project_long_name = null
                  ,x.organization_name = null
                where  x.MIGRATION_SET_ID = pt_i_migrationsetid;

           DELETE from  xxmx_ppm_prj_team_mem_xfm x
           WHERE  x.project_role is null
           and x.MIGRATION_SET_ID = pt_i_migrationsetid;


           UPDATE xxmx_ppm_prj_team_mem_xfm x
              set x.team_member_number = '50016'
           WHERE not exists (select null from xxmx_ppm_valid_persons v where v.person_number = x.team_member_number)
             and x.project_role in ('Project Manager', 'Managing Director')
           ;

           DELETE from  xxmx_ppm_prj_team_mem_xfm x
           WHERE not exists (select null from xxmx_ppm_valid_persons v where v.person_number = x.team_member_number)
             and x.project_role not in ('Project Manager', 'Managing Director')
           ;

--Handle missing PM and MD rows

insert into xxmx_ppm_prj_team_mem_xfm 
select 
 dr.FILE_SET_ID
,dr.MIGRATION_SET_ID
,dr.MIGRATION_SET_NAME
,dr.MIGRATION_STATUS
,p.PROJECT_NAME
,'50016' team_member_number
,dr.TEAM_MEMBER_NAME
,dr.TEAM_MEMBER_EMAIL
,dr.PROJECT_ROLE
,p.project_start_date start_date_active
,null END_DATE_ACTIVE
,ALLOCATION
,LABOUR_EFFORT
,COST_RATE
,BILL_RATE
,TRACK_TIME_FLAG
,ASSIGNMENT_TYPE_CODE
,BILLABLE_PERCENT
,BILLABLE_PERCENT_REASON_CODE
,dr.BATCH_ID
,dr.BATCH_NAME
,dr.LAST_UPDATED_BY
,dr.CREATED_BY
,dr.LAST_UPDATE_LOGIN
,dr.LAST_UPDATE_DATE
,dr.CREATION_DATE
,p.PROJECT_NUMBER
,null ORGANIZATION_NAME
,null PROJECT_LONG_NAME
from
(select 
 FILE_SET_ID
,MIGRATION_SET_ID
,MIGRATION_SET_NAME
,MIGRATION_STATUS
--,PROJECT_NAME
--,TEAM_MEMBER_NUMBER
,TEAM_MEMBER_NAME
,TEAM_MEMBER_EMAIL
,PROJECT_ROLE
--,START_DATE_ACTIVE
--,END_DATE_ACTIVE
,ALLOCATION
,LABOUR_EFFORT
,COST_RATE
,BILL_RATE
,TRACK_TIME_FLAG
,ASSIGNMENT_TYPE_CODE
,BILLABLE_PERCENT
,BILLABLE_PERCENT_REASON_CODE
,BATCH_ID
,BATCH_NAME
,LAST_UPDATED_BY
,CREATED_BY
,LAST_UPDATE_LOGIN
,LAST_UPDATE_DATE
,CREATION_DATE
--,PROJECT_NUMBER
,ORGANIZATION_NAME
,PROJECT_LONG_NAME
from xxmx_ppm_prj_team_mem_xfm
where project_role = 'Project Manager'
and rownum < 2) dr,
xxmx_ppm_projects_xfm p
where not exists (select null from xxmx_ppm_prj_team_mem_stg t 
                  where t.project_number = p.project_number
                  and t.project_role = 'Project Manager')
;


insert into xxmx_ppm_prj_team_mem_xfm 
select 
 dr.FILE_SET_ID
,dr.MIGRATION_SET_ID
,dr.MIGRATION_SET_NAME
,dr.MIGRATION_STATUS
,p.PROJECT_NAME
,'50016' team_member_number
,dr.TEAM_MEMBER_NAME
,dr.TEAM_MEMBER_EMAIL
,'Managing Director'  PROJECT_ROLE
,p.project_start_date start_date_active
,null END_DATE_ACTIVE
,ALLOCATION
,LABOUR_EFFORT
,COST_RATE
,BILL_RATE
,TRACK_TIME_FLAG
,ASSIGNMENT_TYPE_CODE
,BILLABLE_PERCENT
,BILLABLE_PERCENT_REASON_CODE
,dr.BATCH_ID
,dr.BATCH_NAME
,dr.LAST_UPDATED_BY
,dr.CREATED_BY
,dr.LAST_UPDATE_LOGIN
,dr.LAST_UPDATE_DATE
,dr.CREATION_DATE
,p.PROJECT_NUMBER
,null ORGANIZATION_NAME
,null PROJECT_LONG_NAME
from
(select 
 FILE_SET_ID
,MIGRATION_SET_ID
,MIGRATION_SET_NAME
,MIGRATION_STATUS
--,PROJECT_NAME
--,TEAM_MEMBER_NUMBER
,TEAM_MEMBER_NAME
,TEAM_MEMBER_EMAIL
--,PROJECT_ROLE
--,START_DATE_ACTIVE
--,END_DATE_ACTIVE
,ALLOCATION
,LABOUR_EFFORT
,COST_RATE
,BILL_RATE
,TRACK_TIME_FLAG
,ASSIGNMENT_TYPE_CODE
,BILLABLE_PERCENT
,BILLABLE_PERCENT_REASON_CODE
,BATCH_ID
,BATCH_NAME
,LAST_UPDATED_BY
,CREATED_BY
,LAST_UPDATE_LOGIN
,LAST_UPDATE_DATE
,CREATION_DATE
--,PROJECT_NUMBER
,ORGANIZATION_NAME
,PROJECT_LONG_NAME
from xxmx_ppm_prj_team_mem_xfm
where project_role = 'Project Manager'
and rownum < 2) dr,
xxmx_ppm_projects_xfm p
where not exists (select null from xxmx_ppm_prj_team_mem_stg t 
                  where t.project_number = p.project_number
                  and t.project_role = 'Managing Director')
;



        LOOP
           DELETE from  xxmx_ppm_prj_team_mem_xfm x
           WHERE x.rowid in (select max(d.rowid) 
                             from xxmx_ppm_prj_team_mem_xfm d                             
                             group by d.project_number, d.team_member_number, d.project_role
                             having count(1) > 1)
            AND x.project_role  not in ('Project Manager');
        EXIT WHEN sql%rowcount = 0;
        END LOOP;

/*
UPDATE xxmx_ppm_prj_team_mem_xfm x
set x.start_date_active = (select greatest(x.start_date_active,to_date(substr(h.hire_date,1,10),'YYYY-MM-DD'))
                           from   xxmx_ppm_valid_persons h
                           where  h.person_number = x.team_member_number
                           and rownum < 2)
;                         
*/

UPDATE xxmx_ppm_prj_team_mem_xfm x
set x.start_date_active = to_date('01-MAR-2024','DD-MON-YYYY')
where exists (select null
                           from   xxmx_ppm_valid_persons h
                           where  h.person_number = x.team_member_number
                           and x.start_date_active < to_date(substr(h.hire_date,1,10),'YYYY-MM-DD')
                           and rownum < 2)
; 

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
         NULL;    
        WHEN OTHERS THEN

                --
            ROLLBACK;
            dbms_output.put_line('Error in Procedure xxmx_ppm_ext_pkg.transform_team_member_role');
            dbms_output.put_line('Error Message :' || sqlerrm);
            dbms_output.put_line('Error text :' || dbms_utility.format_error_backtrace);
            raise_application_error(-20111, 'Error text :' || dbms_utility.format_error_backtrace); 

 END transform_team_member_role;    
--  
 PROCEDURE transform_proj_dff (
        pt_i_applicationsuite      IN    xxmx_seeded_extensions.application_suite%TYPE,
        pt_i_application           IN    xxmx_seeded_extensions.application%TYPE,
        pt_i_businessentity        IN    xxmx_seeded_extensions.business_entity%TYPE,
--        pt_i_subentity             IN    xxmx_seeded_extensions.business_entity%TYPE,
        pt_i_stgpopulationmethod   IN    xxmx_core_parameters.parameter_value%TYPE,
        pt_i_filesetid             IN    xxmx_migration_headers.file_set_id%TYPE,
        pt_i_migrationsetid        IN    xxmx_migration_headers.migration_set_id%TYPE,
        pv_o_returnstatus          OUT   VARCHAR2
    ) IS

 BEGIN

            UPDATE xxmx_ppm_projects_xfm x   
               SET x.project_start_date = (select min(m.start_date_active) from xxmx_ppm_prj_team_mem_stg m
                                              where m.project_number = x.project_number)
            where  x.MIGRATION_SET_ID = pt_i_migrationsetid 
              and  x.project_start_date is null;


            UPDATE xxmx_ppm_projects_xfm x
            set x.LEGAL_ENTITY_NAME = nvl((select xmm.output_code_1
                                                from xxmx_mapping_master xmm
                                                 WHERE
                                                       1=1 --xmm.application     = 'PPM'
                                                   AND xmm.category_code   = 'PPM_ORG'
                                                   AND upper(xmm.input_code_1) = upper(x.LEGAL_ENTITY_NAME) 
                                                   and xmm.output_code_1 is not null
                                                   AND ROWNUM = 1
                                                   ),x.LEGAL_ENTITY_NAME)
            WHERE x.migration_set_id = pt_i_migrationsetid
            ;


            UPDATE xxmx_ppm_projects_xfm x 
               set /* x.attribute4 = nvl((select max(t.name)
                                   from   pa_project_customers_v@xxmx_extract ppc,
                                          pa_agreements_all@xxmx_extract      a,
                                          pa_project_fundings@xxmx_extract    f,
                                          ra_terms@xxmx_extract               t
                                   where  a.agreement_id = f.agreement_id
                                   and    a.term_id = t.term_id
                                   and    f.project_id = ppc.project_id
                                   and    f.project_id = x.project_id),'30 NET')
                  ,x.attribute3 = (select max(ppc.customer_number)
                                   from   pa_project_customers_v@xxmx_extract ppc,
                                          pa_agreements_all@xxmx_extract      a,
                                          pa_project_fundings@xxmx_extract    f
                                   where  a.agreement_id = f.agreement_id
                                   and    f.project_id = ppc.project_id
                                   and    f.project_id = x.project_id) */
                    copy_tasks_flag      = 'Y'
                   ,COPY_TASK_ATTACHMENTS_FLAG = 'N'
                   ,copy_task_dff_flag = 'Y'
                   ,COPY_TASK_ASSIGNMENTS_FLAG = 'N'
                   ,copy_transaction_controls_flag = 'Y'
                   ,source_template_name = null
                  ,project_manager_number = null
                  ,project_manager_name   = null
                  ,project_manager_email  = null
                  ,CURRENCY_CONV_DATE_TYPE_CODE = 'T'
                  ,CINT_ELIGIBLE_FLAG = null
                 -- ,ALLOW_CROSS_CHARGE_FLAG = null
                  ,CC_PROCESS_LABOR_FLAG = null
                  ,CC_PROCESS_NL_FLAG = null
                  ,ORGANIZATION_NAME = LEGAL_ENTITY_NAME
                  ,x.attribute_category = null
                  ,x.attribute11 = null
                  ,x.attribute1 = nvl(x.attribute1,'999999')
                  ,x.attribute2 = nvl(x.attribute2,'30 NET')
                  --,x.project_start_date = nvl(x.project_start_date,to_date('01-JAN-2022','DD-MON-YYYY'))
                  ,x.project_finish_date = (select case when x.source_template_number like '%Contract%' then to_date('31-DEC-2050','DD-MON-YYYY')
                                                        when x.source_template_number like '%Mercator%' then to_date('31-DEC-2050','DD-MON-YYYY')
                                                        else nvl(x.project_finish_date,to_date('31-DEC-2050','DD-MON-YYYY'))
                                                   end case
                                            from dual)
                  ,x.attribute1_number = null
                  ,x.project_long_name = null
                  ,x.project_id = null
                  ,x.proj_owning_org = null
                  ,x.LIMIT_TO_TXN_CONTROLS_CODE = 'Y'
                  ,x.attribute3 = nvl(x.attribute3,'N')
     /*             ,x.attribute1_number = (select mt.CLOUD_MASTER_TEMPL_ID
                                          from   xxmx_ppm_mtmap_v  mt
                                          where  mt.ATTRIBUTE1_NUMBER = x.ATTRIBUTE1_NUMBER  
                                          and rownum < 2)   */
             /*     ,x.attribute4 = nvl((select xmm.output_code_1
                                    from xxmx_mapping_master xmm
                                     WHERE
                                           xmm.application     = 'PPM'
					                   AND xmm.category_code   = 'PAYMENT_TERM'
                                       AND upper(xmm.input_code_1) = upper(x.attribute4) 
                                       AND ROWNUM = 1
                                       ),x.attribute4) */
                where  x.MIGRATION_SET_ID = pt_i_migrationsetid;


          UPDATE xxmx_ppm_projects_xfm x 
          SET    ORGANIZATION_NAME = 'Citco Bank Canada'
                ,LEGAL_ENTITY_NAME = 'Citco Bank Canada'
          WHERE x.MIGRATION_SET_ID = pt_i_migrationsetid
          and ORGANIZATION_NAME = 'Citco Bank Canada - Custody';

          UPDATE xxmx_ppm_projects_xfm x 
          SET    ORGANIZATION_NAME = 'Citco Bank Nederland N.V. Dublin Branch'
                ,LEGAL_ENTITY_NAME = 'Citco Bank Nederland N.V. Dublin Branch'
          WHERE x.MIGRATION_SET_ID = pt_i_migrationsetid
          and ORGANIZATION_NAME = 'Citco Bank Nederland N.V. Dublin Branch - Depository';

          UPDATE xxmx_ppm_projects_xfm x 
          SET    ORGANIZATION_NAME = 'Citco Bank Nederland N.V. Luxembourg Branch'
                ,LEGAL_ENTITY_NAME = 'Citco Bank Nederland N.V. Luxembourg Branch'
          WHERE x.MIGRATION_SET_ID = pt_i_migrationsetid
          and ORGANIZATION_NAME = 'Citco Bank Nederland N.V. Luxembourg Branch - Depositary';


    EXCEPTION
        WHEN NO_DATA_FOUND THEN
         NULL;    
        WHEN OTHERS THEN

                --
            ROLLBACK;
            dbms_output.put_line('Error in Procedure xxmx_ppm_ext_pkg.transform_team_member_role');
            dbms_output.put_line('Error Message :' || sqlerrm);
            dbms_output.put_line('Error text :' || dbms_utility.format_error_backtrace);
            raise_application_error(-20111, 'Error text :' || dbms_utility.format_error_backtrace); 

 END transform_proj_dff; 
--  
 PROCEDURE transform_task_dff (
        pt_i_applicationsuite      IN    xxmx_seeded_extensions.application_suite%TYPE,
        pt_i_application           IN    xxmx_seeded_extensions.application%TYPE,
        pt_i_businessentity        IN    xxmx_seeded_extensions.business_entity%TYPE,
--        pt_i_subentity             IN    xxmx_seeded_extensions.business_entity%TYPE,
        pt_i_stgpopulationmethod   IN    xxmx_core_parameters.parameter_value%TYPE,
        pt_i_filesetid             IN    xxmx_migration_headers.file_set_id%TYPE,
        pt_i_migrationsetid        IN    xxmx_migration_headers.migration_set_id%TYPE,
        pv_o_returnstatus          OUT   VARCHAR2
    ) IS

 BEGIN


            UPDATE xxmx_ppm_prj_tasks_xfm x 
               set x.attribute1 = (select xmm.output_code_1
                                    from xxmx_mapping_master xmm
                                     WHERE
                                           xmm.application     = 'PPM'
					                   AND xmm.category_code   = 'TASK_NUMBER'
                                       AND upper(xmm.input_code_1) = upper(nvl(x.attribute1,'n')) 
                                       AND ROWNUM = 1
                                       )
                  ,x.attribute2 = 'Citco Rate-based Bill Plan'
                  ,x.attribute3 = 'Citco As Incurred Revenue Plan'
                  --,x.attribute2 = 'Bill'
                  --,x.attribute3 = 'Rev'
                  ,x.attribute1_number = 1
         /*         ,x.attribute1_number = (select  CASE
                                           WHEN x.TASK_NUMBER = 'AEOIOFFICER'  THEN 2
                                           WHEN x.TASK_NUMBER = 'AEOIREPORTING'  THEN 2
                                           WHEN x.TASK_NUMBER = 'CRSFORM'  THEN 2
                                           WHEN x.TASK_NUMBER = 'AMLOFFICERS'  THEN 3
                                           WHEN x.TASK_NUMBER = 'CCUSERS'  THEN 4
                                           WHEN x.TASK_NUMBER = 'API'  THEN 5
                                           WHEN x.TASK_NUMBER = 'SECURID'  THEN 5
                                           WHEN x.TASK_NUMBER = 'TFILEMAIN'  THEN 5
                                           WHEN x.TASK_NUMBER = 'VPN-ANNUAL'  THEN 5
                                           WHEN x.TASK_NUMBER = 'COMPLIANCE'  THEN 6
                                           WHEN x.TASK_NUMBER = 'CORPLEGAL'  THEN 6
                                           WHEN x.TASK_NUMBER = 'CORPSEC'  THEN 6
                                           WHEN x.TASK_NUMBER = 'DOM'  THEN 6
                                           WHEN x.TASK_NUMBER = 'DATASERVICES PLATFORM'  THEN 7
                                           WHEN x.TASK_NUMBER = 'DATASERVICES STORAGE'  THEN 7
                                           WHEN x.TASK_NUMBER = 'EUROTAX'  THEN 8
                                           WHEN x.TASK_NUMBER = 'FIN48'  THEN 9
                                           WHEN x.TASK_NUMBER = 'FINSTAT'  THEN 10
                                           WHEN x.TASK_NUMBER = 'GERMANTAX'  THEN 11
                                           WHEN x.TASK_NUMBER = 'AIFMD-REG'  THEN 12
                                           WHEN x.TASK_NUMBER = 'AIFMD-RISKREP'  THEN 12
                                           WHEN x.TASK_NUMBER = 'RISK-PF'  THEN 12
                                           WHEN x.TASK_NUMBER = 'RISK-PQR'  THEN 12
                                           WHEN x.TASK_NUMBER = 'RISKREP'  THEN 12
                                           WHEN x.TASK_NUMBER = 'RRR-FORM-ADV'  THEN 12
                                           WHEN x.TASK_NUMBER = 'RRR-FORM-PF'  THEN 12
                                           WHEN x.TASK_NUMBER = 'RRR-IR'  THEN 12
                                           WHEN x.TASK_NUMBER = 'RRR-MMIF'  THEN 12
                                           WHEN x.TASK_NUMBER = 'RRR-NPORT'  THEN 12
                                           WHEN x.TASK_NUMBER = 'RRR-PQR'  THEN 12
                                           WHEN x.TASK_NUMBER = 'RRR-SLT'  THEN 12
                                           WHEN x.TASK_NUMBER = 'RRR-TIC'  THEN 12
                                           WHEN x.TASK_NUMBER = 'SAASSWIFT_FEES'  THEN 13
                                           WHEN x.TASK_NUMBER = 'TAXPREP'  THEN 14
                                          ELSE 1
                                          END CASE from dual)   */
                  ,x.attribute4 = null
                  ,x.attribute5 = null       
                  ,x.attribute6 = null       
                where  x.MIGRATION_SET_ID = pt_i_migrationsetid;

            UPDATE xxmx_ppm_prj_tasks_xfm x
                set x.attribute1 = null                   
                where  x.MIGRATION_SET_ID = pt_i_migrationsetid
                  and  (x.attribute1 in ('CHANGEREGOFF','OFFICE','LEGALSERVICES')
                         or x.attribute1 like 'Test%');

/*                         
             UPDATE xxmx_ppm_prj_tasks_xfm x
              SET attribute2 = 'Bill_'||attribute1_number; 
*/

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
         NULL;    
        WHEN OTHERS THEN

                --
            ROLLBACK;
            dbms_output.put_line('Error in Procedure xxmx_ppm_ext_pkg.transform_team_member_role');
            dbms_output.put_line('Error Message :' || sqlerrm);
            dbms_output.put_line('Error text :' || dbms_utility.format_error_backtrace);
            raise_application_error(-20111, 'Error text :' || dbms_utility.format_error_backtrace); 

 END transform_task_dff; 
-- 
PROCEDURE copy_ppm_stg_to_xfm(
     --   pt_i_applicationsuite      IN    xxmx_seeded_extensions.application_suite%TYPE,
     --   pt_i_application           IN    xxmx_seeded_extensions.application%TYPE,
        pt_i_businessentity        IN    xxmx_seeded_extensions.business_entity%TYPE,
--        pt_i_subentity             IN    xxmx_seeded_extensions.business_entity%TYPE,
     --   pt_i_stgpopulationmethod   IN    xxmx_core_parameters.parameter_value%TYPE,
      --  pt_i_filesetid             IN    xxmx_migration_headers.file_set_id%TYPE,
        pt_i_migrationsetid        IN    xxmx_migration_headers.migration_set_id%TYPE
     --   pv_o_returnstatus          OUT   VARCHAR2
    )
is

BEGIN

DELETE FROM XXMX_PPM_PROJECTS_XFM; -- WHERE migration_set_id = pt_i_migrationsetid;

INSERT INTO XXMX_PPM_PROJECTS_XFM SELECT * FROM XXMX_PPM_PROJECTS_STG WHERE migration_set_id = pt_i_migrationsetid
and project_number not in ('4000001','4000002','4000003','4000004','4000103');

UPDATE XXMX_PPM_PROJECTS_XFM
set project_name = PROJECT_LONG_NAME
WHERE migration_set_id = pt_i_migrationsetid;

--Handling duplicate project_long_names

DELETE from xxmx_ppm_projects_xfm a
where substr(source_template_number,5,6) in ('CA4420') 
and  exists (select 1 from xxmx_ppm_projects_xfm b where upper(substr(a.project_long_name,7)) = upper(substr( b.projecT_long_name,7))  and substr(b.source_template_number,5,6) = 'CA4421')
and  migration_set_id = pt_i_migrationsetid;

DELETE from xxmx_ppm_projects_xfm a
where substr(source_template_number,5,6) in ('IE4350') 
and  exists (select 1 from xxmx_ppm_projects_xfm b where upper(substr(a.project_long_name,7)) = upper(substr( b.projecT_long_name,7))  and substr(b.source_template_number,5,6) = 'IE4351')
and  migration_set_id = pt_i_migrationsetid;

DELETE from xxmx_ppm_projects_xfm a
where substr(source_template_number,5,6) in ('LU4370') 
and  exists (select 1 from xxmx_ppm_projects_xfm b where upper(substr(a.project_long_name,7)) = upper(substr( b.projecT_long_name,7))  and substr(b.source_template_number,5,6) = 'LU4371')
and  migration_set_id = pt_i_migrationsetid;


UPDATE xxmx_ppm_projects_xfm t
set t.project_name = t.project_name || '-' || t.project_currency_code 
where upper(t.project_name) in (
select upper(project_name) from xxmx_ppm_projects_xfm
group by upper(project_name)
having count(1) > 1
);


UPDATE xxmx_ppm_projects_xfm t
set t.project_name = t.project_name || '-' || t.project_number 
where upper(t.project_name) in (
select upper(project_name) from xxmx_ppm_projects_xfm
group by upper(project_name)
having count(1) > 1
);


--
DELETE FROM XXMX_PPM_PRJ_TASKS_XFM; -- WHERE migration_set_id = pt_i_migrationsetid;

--INSERT INTO XXMX_PPM_PRJ_TASKS_XFM SELECT * FROM XXMX_PPM_PRJ_TASKS_STG WHERE migration_set_id = pt_i_migrationsetid;

--
DELETE FROM XXMX_PPM_PRJ_CLASS_XFM; -- WHERE migration_set_id = pt_i_migrationsetid;

INSERT INTO XXMX_PPM_PRJ_CLASS_XFM SELECT * FROM XXMX_PPM_PRJ_CLASS_STG WHERE migration_set_id = pt_i_migrationsetid
and project_number not in ('4000001','4000002','4000003','4000004','4000103');

/*
UPDATE XXMX_PPM_PRJ_CLASS_XFM x
set  x.project_number = (select p.project_number   from XXMX_PPM_PROJECTS_STG p
                    where  p.project_name = x.project_name)                 
WHERE x.migration_set_id = pt_i_migrationsetid;


UPDATE XXMX_PPM_PRJ_CLASS_XFM x
set x.project_name = (select p.project_long_name  from XXMX_PPM_PROJECTS_STG p
                    where  p.project_name = x.project_name)
WHERE x.migration_set_id = pt_i_migrationsetid;
*/

UPDATE XXMX_PPM_PRJ_CLASS_XFM x
set x.project_name = x.project_long_name
WHERE x.migration_set_id = pt_i_migrationsetid;

DELETE FROM XXMX_PPM_PRJ_CLASS_XFM x
WHERE x.migration_set_id = pt_i_migrationsetid
and   x.class_category = 'Type of Business';

UPDATE XXMX_PPM_PRJ_CLASS_XFM x
set x.class_category = (select xmm.output_code_1
                                    from xxmx_mapping_master xmm
                                     WHERE
                                           xmm.application     = 'PPM'
					                   AND xmm.category_code   = 'CLASS_CATEGORY'
                                       AND upper(xmm.input_code_1) = upper(x.class_category) 
                                       and xmm.output_code_1 is not null
                                       AND ROWNUM = 1
                                       )
WHERE x.migration_set_id = pt_i_migrationsetid
;

DELETE FROM XXMX_PPM_PRJ_CLASS_XFM x
WHERE x.migration_set_id = pt_i_migrationsetid
and   not exists (select null from xxmx_ppm_projects_xfm n
                  where n.project_number = x.project_number);

--
DELETE FROM XXMX_PPM_PRJ_TEAM_MEM_XFM; -- WHERE migration_set_id = pt_i_migrationsetid;

INSERT INTO XXMX_PPM_PRJ_TEAM_MEM_XFM SELECT * FROM XXMX_PPM_PRJ_TEAM_MEM_STG WHERE migration_set_id = pt_i_migrationsetid
and project_number not in ('4000001','4000002','4000003','4000004','4000103');

UPDATE XXMX_PPM_PRJ_TEAM_MEM_XFM
set project_name = project_long_name
WHERE migration_set_id = pt_i_migrationsetid;


DELETE FROM XXMX_PPM_PRJ_TEAM_MEM_XFM x
WHERE x.migration_set_id = pt_i_migrationsetid
and   not exists (select null from xxmx_ppm_projects_xfm n
                  where n.project_number = x.project_number);
--
DELETE FROM XXMX_PPM_PRJ_TRX_CONTROL_XFM; -- WHERE migration_set_id = pt_i_migrationsetid;

--INSERT INTO XXMX_PPM_PRJ_TRX_CONTROL_XFM SELECT * FROM XXMX_PPM_PRJ_TRX_CONTROL_STG WHERE migration_set_id = pt_i_migrationsetid;

--
DELETE FROM XXMX_PPM_RATE_OVERRIDES_XFM; -- WHERE migration_set_id = pt_i_migrationsetid;

INSERT INTO XXMX_PPM_RATE_OVERRIDES_XFM SELECT * FROM XXMX_PPM_RATE_OVERRIDES_STG WHERE migration_set_id = pt_i_migrationsetid
and project_number not in ('4000001','4000002','4000003','4000004','4000103');

UPDATE XXMX_PPM_RATE_OVERRIDES_XFM x 
               set x.task_number = nvl((select xmm.output_code_1
                                    from xxmx_mapping_master xmm
                                     WHERE
                                           xmm.application     = 'PPM'
					                   AND xmm.category_code   = 'TASK_NUMBER'
                                       AND upper(xmm.input_code_1) = upper(x.task_number) 
                                       AND ROWNUM = 1
                                       ),x.task_number)
                 ,x.contract_line_number = nvl((select xmm.output_code_1
                                    from xxmx_mapping_master xmm
                                     WHERE
                                           xmm.application     = 'PPM'
					                   AND xmm.category_code   = 'TASK_NUMBER'
                                       AND upper(xmm.input_code_1) = upper(x.task_number) 
                                       AND ROWNUM = 1
                                       ),x.task_number)
                where  x.MIGRATION_SET_ID = pt_i_migrationsetid
                  and  x.task_number is not null;


DELETE FROM XXMX_PPM_RATE_OVERRIDES_XFM x
WHERE not exists (select null from xxmx_ppm_valid_persons p where p.person_number = x.person_number)
and x.person_number is not null;


UPDATE XXMX_PPM_RATE_OVERRIDES_XFM x
set x.start_date_active = to_date('01-MAR-2024','DD-MON-YYYY')
where exists (select null
                           from   xxmx_ppm_valid_persons h
                           where  h.person_number = x.person_number
                           and x.start_date_active < to_date(substr(h.hire_date,1,10),'YYYY-MM-DD')
                           and rownum < 2)
and x.person_number is not null
; 

/* Put the following in an UPDATE 
(select  to_char(greatest(to_date(substr(h.hire_date,1,10),'YYYY-MM-DD') , x.start_date_active),'YYYY/MM/DD')
                           from   xxmx_ppm_valid_persons h
                           where  h.person_number = x.person_number) start_date_active,
*/

COMMIT;

EXCEPTION
WHEN OTHERS THEN

                --
            ROLLBACK;
            dbms_output.put_line('Error in Procedure xxmx_ppm_ext_pkg.copy_ppm_stg_to_xfm');
            dbms_output.put_line('Error Message :' || sqlerrm);
            dbms_output.put_line('Error text :' || dbms_utility.format_error_backtrace);
            raise_application_error(-20111, 'Error text :' || dbms_utility.format_error_backtrace);

END copy_ppm_stg_to_xfm;
--
PROCEDURE transform(
        pt_i_applicationsuite      IN    xxmx_seeded_extensions.application_suite%TYPE,
        pt_i_application           IN    xxmx_seeded_extensions.application%TYPE,
        pt_i_businessentity        IN    xxmx_seeded_extensions.business_entity%TYPE,
--        pt_i_subentity             IN    xxmx_seeded_extensions.business_entity%TYPE,
        pt_i_stgpopulationmethod   IN    xxmx_core_parameters.parameter_value%TYPE,
        pt_i_filesetid             IN    xxmx_migration_headers.file_set_id%TYPE,
        pt_i_migrationsetid        IN    xxmx_migration_headers.migration_set_id%TYPE,
        pv_o_returnstatus          OUT   VARCHAR2
    )
is
/*
pt_i_applicationsuite VARCHAR2(100) :='PPM';
pt_i_application VARCHAR2(100) :='PPM';
pt_i_subentity VARCHAR2(100);
pt_i_stgpopulationmethod VARCHAR2(100) := 'DBLINK';
pt_i_filesetid VARCHAR2(100);
pv_o_returnstatus VARCHAR2(4000); 
*/
BEGIN

IF pt_i_businessentity ='PROJECTS' THEN

copy_ppm_stg_to_xfm(
     --   pt_i_applicationsuite      IN    xxmx_seeded_extensions.application_suite%TYPE,
     --   pt_i_application           IN    xxmx_seeded_extensions.application%TYPE,
        pt_i_businessentity       ,
--        pt_i_subentity             IN    xxmx_seeded_extensions.business_entity%TYPE,
     --   pt_i_stgpopulationmethod   IN    xxmx_core_parameters.parameter_value%TYPE,
      --  pt_i_filesetid             IN    xxmx_migration_headers.file_set_id%TYPE,
        pt_i_migrationsetid       
     --   pv_o_returnstatus          OUT   VARCHAR2
    );

/* transform_task_number(
        pt_i_applicationsuite     ,
        pt_i_application          ,
        pt_i_businessentity       ,
        pt_i_stgpopulationmethod   ,
        pt_i_filesetid             ,
        pt_i_migrationsetid        ,
        pv_o_returnstatus          
    );
   */ 

/*   
transform_project_template(
        pt_i_applicationsuite     ,
        pt_i_application          ,
        pt_i_businessentity       ,
        pt_i_stgpopulationmethod   ,
        pt_i_filesetid             ,
        pt_i_migrationsetid        ,
        pv_o_returnstatus          
    );
*/

--Milind commented out the array method above and replaced with updates below for template mapping. Also handled template and currency combinations 9th Jan 2024.

            UPDATE XXMX_PPM_PROJECTS_XFM x 
               set x.load_status = 'T',
                   x.source_template_number = nvl((select xmm.output_code_1
                                    from xxmx_mapping_master xmm
                                     WHERE
                                           xmm.application     = 'PPM'
					                   AND xmm.category_code   = 'SOURCE_TEMPLATE_NUMBER'
                                       AND upper(xmm.input_code_1) = upper(x.source_template_number) 
                                       and upper(xmm.input_code_2) = upper(x.project_currency_code) 
                                       AND ROWNUM = 1
                                       ),x.source_template_number)
                where  x.MIGRATION_SET_ID = pt_i_migrationsetid
                  and  x.source_template_number is not null
                  and  exists       (select null 
                                     from xxmx_mapping_master xmm
                                     WHERE
                                           xmm.application     = 'PPM'
					                   AND xmm.category_code   = 'SOURCE_TEMPLATE_NUMBER'
                                       AND upper(xmm.input_code_1) = upper(x.source_template_number) 
                                       and upper(xmm.input_code_2) = upper(x.project_currency_code) 
                                       AND ROWNUM = 1
                                       ) ;


            UPDATE XXMX_PPM_PROJECTS_XFM x 
               set x.source_template_number = nvl((select xmm.output_code_1
                                    from xxmx_mapping_master xmm
                                     WHERE
                                           xmm.application     = 'PPM'
					                   AND xmm.category_code   = 'SOURCE_TEMPLATE_NUMBER'
                                       AND upper(xmm.input_code_1) = upper(x.source_template_number) 
                                       and xmm.input_code_2 is null
                                       AND ROWNUM = 1
                                       ),x.source_template_number)
                where  x.MIGRATION_SET_ID = pt_i_migrationsetid
                  and  x.source_template_number is not null
                  and  x.load_status is null;

/*
            UPDATE XXMX_PPM_PROJECTS_XFM x 
               set x.source_template_number = 'T - LU6350 - Contract-USD'
            WHERE  x.source_template_number = 'T - LU6350 - Contract'
            AND    x.project_currency_code = 'USD';

            UPDATE XXMX_PPM_PROJECTS_XFM x 
               set x.source_template_number = 'T - LU6350 - Contract-GBP'
            WHERE  x.source_template_number = 'T - LU6350 - Contract'
            AND    x.project_currency_code = 'GBP';            
*/


/*    
transform_poo(
        pt_i_applicationsuite     ,
        pt_i_application          ,
        pt_i_businessentity       ,
        pt_i_stgpopulationmethod   ,
        pt_i_filesetid             ,
        pt_i_migrationsetid        ,
        pv_o_returnstatus          
    );
*/   

transform_description(
        pt_i_applicationsuite     ,
        pt_i_application          ,
        pt_i_businessentity       ,
        pt_i_stgpopulationmethod   ,
        pt_i_filesetid             ,
        pt_i_migrationsetid        ,
        pv_o_returnstatus          
    );

  /* transform_task_poo(
        pt_i_applicationsuite     ,
        pt_i_application          ,
        pt_i_businessentity       ,
        pt_i_stgpopulationmethod   ,
        pt_i_filesetid             ,
        pt_i_migrationsetid        ,
        pv_o_returnstatus          
    );    

transform_trx_control_task_num( 
        pt_i_applicationsuite     ,
        pt_i_application          ,
        pt_i_businessentity       ,
        pt_i_stgpopulationmethod   ,
        pt_i_filesetid             ,
        pt_i_migrationsetid        ,
        pv_o_returnstatus          
    );
    */
transform_team_member_role( 
        pt_i_applicationsuite     ,
        pt_i_application          ,
        pt_i_businessentity       ,
        pt_i_stgpopulationmethod   ,
        pt_i_filesetid             ,
        pt_i_migrationsetid        ,
        pv_o_returnstatus          
    );

transform_proj_dff( 
        pt_i_applicationsuite     ,
        pt_i_application          ,
        pt_i_businessentity       ,
        pt_i_stgpopulationmethod   ,
        pt_i_filesetid             ,
        pt_i_migrationsetid        ,
        pv_o_returnstatus          
    );


  /* transform_task_dff( 
        pt_i_applicationsuite     ,
        pt_i_application          ,
        pt_i_businessentity       ,
        pt_i_stgpopulationmethod   ,
        pt_i_filesetid             ,
        pt_i_migrationsetid        ,
        pv_o_returnstatus          
    );
    */

END IF;
END transform;

END xxmx_ppm_ext_pkg;

/
