create or replace PACKAGE BODY xxmx_validate_fa_setup_pkg AS
     --
     --**********************
     --** Global Declarations
     --**********************
     --
     /*
     ** Maximise Integration Globals
     */
     --
     /*
     ** Global Constants for use in all xxmx_utilities_pkg Procedure/Function Calls within this package
     */
     --
                -- Added for SMBC flexibility, could move to migration parameter table
     --
     --
    gvv_progressindicator       VARCHAR2(100);
     --
     /*
     ** Global Variables for receiving Status/Messages from certain Procedure/Function Calls (e.g. xxmx_utilities_pkg.clear_messages
     */
     --
    gvv_returnstatus            VARCHAR2(1);
    gvt_returnmessage           xxmx_module_messages.module_message%TYPE;
     --
     /*
     ** Global Variables for Exception Handlers
     */
     --
    gvv_applicationerrormessage VARCHAR2(2048);
    gvt_severity                xxmx_module_messages.severity%TYPE;
    gvt_modulemessage           xxmx_module_messages.module_message%TYPE;
    gvt_oracleerror             xxmx_module_messages.oracle_error%TYPE;
     --
     /*
     ** Global Variables for Exception Handlers
     */
     --
    gvt_migrationsetname        xxmx_migration_headers.migration_set_name%TYPE;
     --
     /*
     ** Global constants and variables for dynamic SQL usage
     */
     --
    gcv_sqlspace                CONSTANT VARCHAR2(1) := ' ';
    gvv_sqlaction               VARCHAR2(20);
    gvv_sqltableclause          VARCHAR2(100);
    gvv_sqlcolumnlist           VARCHAR2(4000);
    gvv_sqlvalueslist           VARCHAR2(4000);
    gvv_sqlwhereclause          VARCHAR2(4000);
    gvv_sqlstatement            VARCHAR2(32000);
    gvv_sqlresult               VARCHAR2(4000);
     --
     /*
     ** Global variables for holding table row counts
     */
     --
    gvn_rowcount                NUMBER;
     --
     --
     /*
     ******************************
     ** PROCEDURE: <Procedure Name>
     ** keep parameters as is
     ******************************
     */
     --
    PROCEDURE insert_data (
        p_valid_type IN VARCHAR2,
        x_status     OUT VARCHAR2
    ) IS
          --
          --
          --**********************
          --** CURSOR Declarations
          --**********************
          --
          --<<Cursor to get the detail ??>>
          --
        CURSOR get_data_cur IS
        SELECT
            *
        FROM
            (
                SELECT DISTINCT
                    'BOOK_CATEGORY' validation_type,
                    book_type_code||category_segment1||category_segment2,
                    'N'         status,
                    NULL        error_message,
                    sysdate     current_date

                FROM
                    xxmx_fa_mass_additions_xfm
                WHERE
                    book_type_code IS NOT NULL
					and category_segment1 is not NULL
					and category_segment2 is not null


                UNION
                SELECT DISTINCT
                    'LOCATION',
                    location_segment1||location_segment2||location_segment3||location_segment4,
                    'N',
                    NULL,
                    sysdate
                FROM
                    xxmx_fa_mass_addition_dist_xfm
					where location_segment1 is not null
					and location_segment2 is not null
					and location_segment3 is not null
					and location_segment4 is not null
                UNION
                SELECT DISTINCT
                    'DEPRN_METHOD',
                    METHOD_CODE||LIFE_IN_MONTHS,
                    'N',
                    NULL,
                    sysdate
                FROM
                    xxmx_fa_mass_additions_xfm
					where METHOD_CODE is not null
					and LIFE_IN_MONTHS is not null

            ) main
        WHERE
            validation_type IN (
                SELECT
                    regexp_substr(
                        upper(p_valid_type), '[^,]+', 1, level
                    )
                FROM
                    dual
                CONNECT BY
                    regexp_substr(
                        upper(p_valid_type), '[^,]+', 1, level
                    ) IS NOT NULL
            )
            OR least(p_valid_type) IS NULL;
               ----
               ----
               ----
               ----
          --** END CURSOR **
          --
          --
          --********************
          --** Type Declarations
          --********************
          --
        TYPE get_data_tt IS
            TABLE OF xxmx_supplier_validation%rowtype INDEX BY BINARY_INTEGER;
          --
          --
          --************************
          --** Constant Declarations
          --************************
          --

          --
          --
          --************************
          --** Variable Declarations
          --************************
          --
          --
          --
          --****************************
          --** Record Table Declarations
          --****************************
          --
          --
          --
          --****************************
          --** PL/SQL Table Declarations
          --****************************
          --
        get_data_tbl get_data_tt;
          --
          --
          --*************************
          --** Exception Declarations
          --*************************
          --
          --** Set gvt_Severity, gvv_ProgressIndicator and gvt_ModuleMessage
          --** before raising this exception.
          --
        e_moduleerror EXCEPTION;
          --
     --** END Declarations
     --
    BEGIN
          --

          --
        gvv_returnstatus := '';
        gvt_returnmessage := '';
        BEGIN
            DELETE FROM xxmx_fa_validation main
            WHERE
                validation_type IN (
                    SELECT
                        regexp_substr(
                            upper(p_valid_type), '[^,]+', 1, level
                        )
                    FROM
                        dual
                    CONNECT BY
                        regexp_substr(
                            upper(p_valid_type), '[^,]+', 1, level
                        ) IS NOT NULL
                )
                OR least(p_valid_type) IS NULL;

        EXCEPTION
            WHEN OTHERS THEN
                NULL;
        END;

          --

               --
        OPEN get_data_cur;
               --
        gvv_progressindicator := '0060';
               --
        LOOP
                    --
            FETCH get_data_cur
            BULK COLLECT INTO get_data_tbl LIMIT xxmx_utilities_pkg.gcn_bulkcollectlimit;
                    --
            EXIT WHEN get_data_tbl.count = 0;
                    --
            gvv_progressindicator := '0070';
                    --
            FORALL i IN 1..get_data_tbl.count
                         --
                INSERT INTO xxmx_fa_validation (
                    validation_type,
                    validation_value,
                    status,
                    error_message,
                    last_update_date
                ) VALUES (
                    get_data_tbl(i).validation_type,
                    get_data_tbl(i).validation_value,
                    get_data_tbl(i).status,
                    get_data_tbl(i).error_message,
                    sysdate
                );
                         --
                    --** END FORALL
                    --
        END LOOP;
               --

               --
        COMMIT;
               --

               --
        CLOSE get_data_cur;
        x_status := 'SUCCESS';
               --

          --
    EXCEPTION
               --

        WHEN OTHERS THEN
                    --
            IF get_data_cur%isopen THEN
                         --
                CLOSE get_data_cur;
                         --
            END IF;
                    --
            ROLLBACK;
            x_status := 'ERROR: '
                        || sqlerrm
                        || ' '
                        || sqlcode;
                    --

                    --
               --** END OTHERS Exception
               --
          --** END Exception Handler
          --
    END insert_data;
     --
    PROCEDURE validate_data (
        p_valid_type IN VARCHAR2,
        x_status     OUT VARCHAR2
    ) IS

        CURSOR BOOK_CATEGORY_cur IS
        SELECT
            *
        FROM
            xxmx_fa_validation a
        WHERE
            a.validation_type = 'BOOK_CATEGORY'
            AND NOT EXISTS (
                SELECT
                    1
                FROM
                    xxmx_FA_CATEGORY_BOOKS b
                WHERE
                    a.validation_value = b.book_type_code||b.segment1||b.segment2
            )
            AND status = 'N';

        CURSOR location_cur IS
        SELECT
            *
        FROM
            xxmx_fa_validation a
        WHERE
            a.validation_type = 'LOCATION'
            AND NOT EXISTS (
                SELECT
                    1
                FROM
                    xxmx_fa_locations b
                WHERE
                    a.validation_value = b.country||b.state||b.region||b.city
            )
            AND status = 'N';

CURSOR deprn_method_cur IS
        SELECT
            *
        FROM
            xxmx_fa_validation a
        WHERE
            a.validation_type = 'DEPRN_METHOD'
            AND NOT EXISTS (
                SELECT
                    1
                FROM
                    xxmx_fa_deprn_methods b
                WHERE
                    a.validation_value = b.METHOD_CODE||b.LIFE_IN_MONTHS
            )
            AND status = 'N';

    BEGIN
        FOR i IN BOOK_CATEGORY_cur LOOP
            BEGIN
                UPDATE xxmx_fa_validation
                SET
                    status = 'E',
                    last_update_date = sysdate
                WHERE
                    validation_type = 'BOOK_CATEGORY'
                    AND validation_value = i.validation_value;

            EXCEPTION
                WHEN OTHERS THEN
                    x_status := 'ERROR: '
                                || sqlerrm
                                || ' '
                                || sqlcode;
            END;
        END LOOP;

        FOR i IN location_cur LOOP
            BEGIN
                UPDATE xxmx_fa_validation
                SET
                    status = 'E',
                    last_update_date = sysdate
                WHERE
                    validation_type = 'LOCATION'
                    AND validation_value = i.validation_value;

            EXCEPTION
                WHEN OTHERS THEN
                    x_status := 'ERROR: '
                                || sqlerrm
                                || ' '
                                || sqlcode;
            END;
        END LOOP;

FOR i IN deprn_method_cur LOOP
            BEGIN
                UPDATE xxmx_fa_validation
                SET
                    status = 'E',
                    last_update_date = sysdate
                WHERE
                    validation_type = 'DEPRN_METHOD'
                    AND validation_value = i.validation_value;

            EXCEPTION
                WHEN OTHERS THEN
                    x_status := 'ERROR: '
                                || sqlerrm
                                || ' '
                                || sqlcode;
            END;
        END LOOP;

    EXCEPTION
        WHEN OTHERS THEN
            x_status := 'ERROR: '
                        || sqlerrm
                        || ' '
                        || sqlcode;
    END validate_data;

     --
END xxmx_validate_fa_setup_pkg;