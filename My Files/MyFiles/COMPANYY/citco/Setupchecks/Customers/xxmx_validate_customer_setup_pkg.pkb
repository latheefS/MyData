create or replace PACKAGE BODY xxmx_validate_customer_setup_pkg AS

--
    /*
     ******************************************************************************
     **
     ** xxmx_validate_customer_setup_pkg.pkb HISTORY
     ** ------------------------------------
     **
     **   Vsn  Change Date  Changed By                Change Description
     ** -----  -----------  ------------------        -----------------------------
     **   1.0  15-MAR-2024  Meenakshi Rajendran       Initial implementation
     ******************************************************************************
     --
     --**********************
     --** Global Declarations
     --**********************
     --
     /*
     ** Maximise Integration Globals
     */
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
     ** PROCEDURE: insert_data
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
                    'CUSTOMER_CLASS_CODE' validation_type,
                    customer_class_code,
                    'N'         status,
                    NULL        error_message,
                    sysdate     current_date
                FROM
                    XXMX_HZ_CUST_ACCOUNTS_XFM
                WHERE
                    customer_class_code IS NOT NULL
                UNION
                SELECT DISTINCT
                    'STANDARD_TERM_NAME',
                    STANDARD_TERM_NAME,
                    'N',
                    NULL,
                    sysdate
                FROM
                    XXMX_HZ_CUST_PROFILES_XFM
                WHERE
                    STANDARD_TERM_NAME IS NOT NULL
                UNION
                SELECT DISTINCT
                    'TAX_REGIME_CODE',
                     TAX_REGIME_CODE ,
                    'N',
                    NULL,
                    sysdate
                FROM
                    XXMX_ZX_TAX_REGISTRATION_XFM
                WHERE
                    TAX_REGIME_CODE  IS NOT NULL
                UNION
                SELECT DISTINCT
                    'CLASS_CODE',
                    class_code,
                    'N',
                    NULL,
                    sysdate
                FROM
                    XXMX_ZX_PARTY_CLASSIFIC_XFM
                WHERE
                    class_code IS NOT NULL             

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
            TABLE OF xxmx_customer_validation%rowtype INDEX BY BINARY_INTEGER;
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
            DELETE FROM xxmx_customer_validation main
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
                INSERT INTO xxmx_customer_validation (
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

        CURSOR cust_class_code_cur IS
        SELECT
            *
        FROM
            xxmx_customer_validation a
        WHERE
            a.validation_type = 'CUSTOMER_CLASS_CODE'
            AND NOT EXISTS (
                SELECT
                    1
                FROM
                    xxmx_cust_class_code b
                WHERE
                    a.validation_value = b.customer_class_code
            )
            AND status = 'N';

        CURSOR payment_term_cur IS
        SELECT
            *
        FROM
            xxmx_customer_validation a
        WHERE
            a.validation_type = 'STANDARD_TERM_NAME'
            AND NOT EXISTS (
                SELECT
                    1
                FROM
                    xxmx_term_names b
                WHERE
                    a.validation_value = b.term_name
            )
            AND status = 'N';

        CURSOR tax_regime_cur IS
        SELECT
            *
        FROM
            xxmx_customer_validation a
        WHERE
            a.validation_type = 'TAX_REGIME_CODE'
            AND NOT EXISTS (
                SELECT
                    1
                FROM
                    xxmx_tax_regime_code b
                WHERE
                    a.validation_value = b.tax_regime_code
            )
            AND status = 'N';


		CURSOR class_code_cur IS
        SELECT
            *
        FROM
            xxmx_customer_validation a
        WHERE
            a.validation_type = 'CLASS_CODE'
            AND NOT EXISTS (
                SELECT
                    1
                FROM
                    xxmx_class_codes b
                WHERE
                    a.validation_value = b.class_code
            )
            AND status = 'N';

    BEGIN
        FOR i IN cust_class_code_cur LOOP
            BEGIN
                UPDATE xxmx_customer_validation
                SET
                    status = 'E',
                    last_update_date = sysdate
                WHERE
                    validation_type = 'CUSTOMER_CLASS_CODE'
                    AND validation_value = i.validation_value;

            EXCEPTION
                WHEN OTHERS THEN
                    x_status := 'ERROR: '
                                || sqlerrm
                                || ' '
                                || sqlcode;
            END;
        END LOOP;

        FOR i IN payment_term_cur LOOP
            BEGIN
                UPDATE xxmx_customer_validation
                SET
                    status = 'E',
                    last_update_date = sysdate
                WHERE
                    validation_type = 'STANDARD_TERM_NAME'
                    AND validation_value = i.validation_value;

            EXCEPTION
                WHEN OTHERS THEN
                    x_status := 'ERROR: '
                                || sqlerrm
                                || ' '
                                || sqlcode;
            END;
        END LOOP;


        FOR i IN tax_regime_cur LOOP
            BEGIN
                UPDATE xxmx_customer_validation
                SET
                    status = 'E',
                    last_update_date = sysdate
                WHERE
                    validation_type = 'TAX_REGIME_CODE'
                    AND validation_value = i.validation_value;

            EXCEPTION
                WHEN OTHERS THEN
                    x_status := 'ERROR: '
                                || sqlerrm
                                || ' '
                                || sqlcode;
            END;
        END LOOP;


		FOR i IN class_code_cur LOOP
            BEGIN
                UPDATE xxmx_customer_validation
                SET
                    status = 'E',
                    last_update_date = sysdate
                WHERE
                    validation_type = 'CLASS_CODE'
                    AND validation_value = i.validation_value;

            EXCEPTION
                WHEN OTHERS THEN
                    x_status := 'ERROR: '
                                || sqlerrm
                                || ' '
                                || sqlcode;
            END;
        END LOOP;

COMMIT;

    END validate_data;

     --
END xxmx_validate_customer_setup_pkg;