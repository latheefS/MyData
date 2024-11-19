create or replace PROCEDURE xxmx_special_character (
    spcl_char         VARCHAR2,
    application_suite xxmx_migration_parameters.application_suite%TYPE
) AS

    object_count     NUMBER;
    column_count     NUMBER;
    column_name      VARCHAR(30000);
    printdata        VARCHAR(30000);
    CURSOR objectname IS
    SELECT
        owner,
        object_name
    FROM
        all_objects
    WHERE
        object_name LIKE 'XXMX%STG'
        AND object_type = 'TABLE'
        AND owner = 'XXMX_STG';

    CURSOR columnname (
        p_objectname VARCHAR2
    ) IS
    SELECT
        column_name
    FROM
        all_tab_columns
    WHERE
            table_name = p_objectname
        AND data_type IN ( 'VARCHAR2', 'CHAR' )
        AND owner = 'XXMX_STG';

    lv_sql           VARCHAR(30000) := NULL;
    obj_name         objectname%rowtype;
    TYPE v_columnname IS
        TABLE OF columnname%rowtype INDEX BY BINARY_INTEGER;
    v_columnname_tab v_columnname;
    v_escape_char    VARCHAR2(10);
BEGIN
    v_escape_char := xxmx_utilities_pkg.get_single_parameter_value(pt_i_applicationsuite => 'XXMX', pt_i_application => 'XXMX', pt_i_businessentity => 'ALL'
    , pt_i_subentity => 'ALL', pt_i_parametercode => 'DEBUG');

    IF ( v_escape_char = 'Y' ) THEN
        DELETE FROM xxmx_special_char;

        OPEN objectname;
        LOOP
            FETCH objectname INTO obj_name;
            EXIT WHEN objectname%notfound;
			--	dbms_output.put_line('object name is:' ||obj_name || '!' || objectName%rowcount);

            OPEN columnname(obj_name.object_name);
            LOOP
                FETCH columnname INTO column_name;
                EXIT WHEN columnname%notfound;
                BEGIN
                    lv_sql := 'SELECT '
                              || column_name
                              || ' from '
                              || obj_name.object_name
                              || ' where '
                              || ' INSTR('
                              || column_name
                              || ','
                              || ''''
                              || spcl_char
                              || ''''
                              || ',1'
                              || ')>0';
		--                    dbms_output.put_line(lv_sql);
                    EXECUTE IMMEDIATE lv_sql BULK COLLECT
                    INTO v_columnname_tab;
                    for i in 1.. v_columnname_tab.count
                loop
                INSERT INTO xxmx_special_char VALUES (
                        obj_name.owner,
                        application_suite,
                        obj_name.object_name,
                        column_name,
                        spcl_char,
                        v_columnname_tab(i).column_name);
                        end loop;    


                    COMMIT;
                EXCEPTION
                    WHEN no_data_found THEN
                        NULL;
                    WHEN OTHERS THEN
                        dbms_output.put_line(sqlerrm);
                END;

            END LOOP;

            CLOSE columnname;
        END LOOP;

        CLOSE objectname;
    END IF;

END xxmx_special_character;