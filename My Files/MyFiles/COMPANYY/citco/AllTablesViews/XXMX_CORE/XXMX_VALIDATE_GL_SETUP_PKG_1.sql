--------------------------------------------------------
--  DDL for Package Body XXMX_VALIDATE_GL_SETUP_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "XXMX_CORE"."XXMX_VALIDATE_GL_SETUP_PKG" AS
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
                    'LEDGER'                 validation_type,
                    ledger_id || ledger_name validation_value,
                    'N'                      status,
                    NULL                     error_message,
                    sysdate                  current_date
                FROM
                    xxmx_gl_opening_balances_xfm
					where ledger_id is not null
					and ledger_name is not null
                UNION
                SELECT DISTINCT
                    'LEDGER' validation_type,
                    ledger_id || ledger_name,
                    'N'      status,
                    NULL     error_message,
                    sysdate  current_date
                FROM
                    xxmx_gl_summary_balances_xfm
					where ledger_id is not null
					and ledger_name is not null
                UNION
                SELECT DISTINCT
                    'LEDGER' validation_type,
                    ledger_id || ledger_name,
                    'N'      status,
                    NULL     error_message,
                    sysdate  current_date
                FROM
                    xxmx_gl_detail_balances_xfm
					where ledger_id is not null
					and ledger_name is not null
                UNION
                SELECT DISTINCT
                    'CATEGORY' validation_type,
                    user_je_category_name,
                    'N'        status,
                    NULL       error_message,
                    sysdate    current_date
                FROM
                    xxmx_gl_opening_balances_xfm
					where user_je_category_name is not null
                UNION
                SELECT DISTINCT
                    'CATEGORY' validation_type,
                    user_je_category_name,
                    'N'        status,
                    NULL       error_message,
                    sysdate    current_date
                FROM
                    xxmx_gl_summary_balances_xfm
					where user_je_category_name is not null
                UNION
                SELECT DISTINCT
                    'CATEGORY' validation_type,
                    user_je_category_name,
                    'N'        status,
                    NULL       error_message,
                    sysdate    current_date
                FROM
                    xxmx_gl_detail_balances_xfm
					where user_je_category_name is not null
                UNION
                SELECT DISTINCT
                    'SOURCE' validation_type,
                    user_je_source_name,
                    'N'      status,
                    NULL     error_message,
                    sysdate  current_date
                FROM
                    xxmx_gl_opening_balances_xfm
					where user_je_source_name is not null
                UNION
                SELECT DISTINCT
                    'SOURCE' validation_type,
                    user_je_source_name,
                    'N'      status,
                    NULL     error_message,
                    sysdate  current_date
                FROM
                    xxmx_gl_summary_balances_xfm
					where user_je_source_name is not null
                UNION
                SELECT DISTINCT
                    'SOURCE' validation_type,
                    user_je_source_name,
                    'N'      status,
                    NULL     error_message,
                    sysdate  current_date
                FROM
                    xxmx_gl_detail_balances_xfm
					where user_je_source_name is not null
                UNION
                SELECT DISTINCT
                    'PERIOD' validation_type,
                    ledger_name || period_name,
                    'N'      status,
                    NULL     error_message,
                    sysdate  current_date
                FROM
                    xxmx_gl_opening_balances_xfm
					where ledger_name is not null
					and period_name is not null
                UNION
                SELECT DISTINCT
                    'PERIOD' validation_type,
                    ledger_name || period_name,
                    'N'      status,
                    NULL     error_message,
                    sysdate  current_date
                FROM
                    xxmx_gl_summary_balances_xfm
					where ledger_name is not null
					and period_name is not null
                UNION
                SELECT DISTINCT
                    'PERIOD' validation_type,
                    ledger_name || period_name,
                    'N'      status,
                    NULL     error_message,
                    sysdate  current_date
                FROM
                    xxmx_gl_detail_balances_xfm
					where ledger_name is not null
					and period_name is not null
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
            DELETE FROM xxmx_gl_validation main
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
                INSERT INTO xxmx_gl_validation (
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

        CURSOR ledger_cur IS
        SELECT
            *
        FROM
            xxmx_gl_validation a
        WHERE
            a.validation_type = 'LEDGER'
            AND NOT EXISTS (
                SELECT
                    1
                FROM
                    xxmx_ledgers b
                WHERE
                    a.validation_value = b.ledger_id || b.ledger_name
            )
            AND status = 'N';

        CURSOR source_cur IS
        SELECT
            *
        FROM
            xxmx_gl_validation a
        WHERE
            a.validation_type = 'SOURCE'
            AND NOT EXISTS (
                SELECT
                    1
                FROM
                    xxmx_gl_sources b
                WHERE
                    a.validation_value = b.je_source_name
            )
            AND status = 'N';

        CURSOR category_cur IS
        SELECT
            *
        FROM
            xxmx_gl_validation a
        WHERE
            a.validation_type = 'CATEGORY'
            AND NOT EXISTS (
                SELECT
                    1
                FROM
                    xxmx_gl_category b
                WHERE
                    a.validation_value = b.category_name
            )
            AND status = 'N';

        CURSOR period_cur IS
        SELECT
            *
        FROM
            xxmx_gl_validation a
        WHERE
            a.validation_type = 'PERIOD'
            AND NOT EXISTS (
                SELECT
                    1
                FROM
                    xxmx_ledgers_period b
                WHERE
                    a.validation_value = b.ledger_name || b.period_name
            )
            AND status = 'N';

    BEGIN
        FOR i IN ledger_cur LOOP
            BEGIN
                UPDATE xxmx_gl_validation
                SET
                    status = 'E',
                    last_update_date = sysdate
                WHERE
                    validation_type = 'LEDGER'
                    AND validation_value = i.validation_value;

            EXCEPTION
                WHEN OTHERS THEN
                    x_status := 'ERROR: '
                                || sqlerrm
                                || ' '
                                || sqlcode;
            END;
        END LOOP;

        FOR i IN source_cur LOOP
            BEGIN
                UPDATE xxmx_gl_validation
                SET
                    status = 'E',
                    last_update_date = sysdate
                WHERE
                    validation_type = 'SOURCE'
                    AND validation_value = i.validation_value;

            EXCEPTION
                WHEN OTHERS THEN
                    x_status := 'ERROR: '
                                || sqlerrm
                                || ' '
                                || sqlcode;
            END;
        END LOOP;

        FOR i IN category_cur LOOP
            BEGIN
                UPDATE xxmx_gl_validation
                SET
                    status = 'E',
                    last_update_date = sysdate
                WHERE
                    validation_type = 'CATEGORY'
                    AND validation_value = i.validation_value;

            EXCEPTION
                WHEN OTHERS THEN
                    x_status := 'ERROR: '
                                || sqlerrm
                                || ' '
                                || sqlcode;
            END;
        END LOOP;

        FOR i IN period_cur LOOP
            BEGIN
                UPDATE xxmx_gl_validation
                SET
                    status = 'E',
                    last_update_date = sysdate
                WHERE
                    validation_type = 'PERIOD'
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
END xxmx_validate_gl_setup_pkg;

/
