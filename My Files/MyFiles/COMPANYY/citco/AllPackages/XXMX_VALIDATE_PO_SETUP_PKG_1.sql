--------------------------------------------------------
--  DDL for Package Body XXMX_VALIDATE_PO_SETUP_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "XXMX_CORE"."XXMX_VALIDATE_PO_SETUP_PKG" AS
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
                    'BUSINESS_UNIT' validation_type,
                    PRC_BU_NAME validation_value,
                    'N' status,
                    NULL error_message,
                    sysdate current_date
from xxmx_scm_po_headers_std_xfm
union
select distinct 'BUSINESS_UNIT',
                    REQ_BU_NAME,
                    'N',
                    NULL,
                    sysdate
from xxmx_scm_po_headers_std_xfm
where REQ_BU_NAME is not null
union
select distinct 'BUSINESS_UNIT',
                    BILLTO_BU_NAME,
                    'N',
                    NULL,
                    sysdate 
from xxmx_scm_po_headers_std_xfm
where BILLTO_BU_NAME is not null
union
select distinct 'LEGAL_ENTITY',
                    SOLDTO_LE_NAME,
                    'N',
                    NULL,
                    sysdate 
from xxmx_scm_po_headers_std_xfm
union
select distinct 'LOCATION',
                    BILL_TO_LOCATION,
                    'N',
                    NULL,
                    sysdate 
from xxmx_scm_po_headers_std_xfm
where BILL_TO_LOCATION is not null
union
select distinct 'LOCATION',
                    SHIP_TO_LOCATION,
                    'N',
                    NULL,
                    sysdate 
from xxmx_scm_po_headers_std_xfm
where SHIP_TO_LOCATION is not null
union
select distinct 'LOCATION',
                    SHIP_TO_LOCATION,
                    'N',
                    NULL,
                    sysdate 
from xxmx_scm_po_line_locations_std_xfm
where SHIP_TO_LOCATION is not null
union
select distinct 'LOCATION',
                    DELIVER_TO_LOCATION,
                    'N',
                    NULL,
                    sysdate 
from xxmx_scm_po_distributions_std_xfm
where DELIVER_TO_LOCATION is not null
union
select distinct 'PAYMENT_TERMS',
                    PAYMENT_TERMS,
                    'N',
                    NULL,
                    sysdate 
from xxmx_scm_po_headers_std_xfm
union
select distinct 'LINE_TYPE',
                    LINE_TYPE,
                    'N',
                    NULL,
                    sysdate 
from xxmx_scm_po_lines_std_xfm
where LINE_TYPE is not null
UNION
select distinct 'CATEGORY',
                    CATEGORY,
                    'N',
                    NULL,
                    sysdate 
from xxmx_scm_po_lines_std_xfm
where CATEGORY is not null
UNION
select distinct 'TASK',
                    task,
                    'N',
                    NULL,
                    sysdate
from xxmx_scm_po_distributions_std_xfm
where task is not null
union
select distinct 'EXPENDITURE_TYPE',
                    expenditure_type,
                    'N',
                    NULL,
                    sysdate 
from xxmx_scm_po_distributions_std_xfm
where expenditure_type is not null
union
select distinct 'EXPENDITURE_ORGANIZATION',
                    expenditure_organization,
                    'N',
                    NULL,
                    sysdate 
from xxmx_scm_po_distributions_std_xfm
where expenditure_organization is not null
union
select distinct 'AGENT_NAME',
                    AGENT_NAME,
                    'N',
                    NULL,
                    sysdate 
from xxmx_scm_po_headers_std_xfm
where AGENT_NAME is not null
UNION
select distinct 'REQUESTER', DELIVER_TO_PERSON_FULL_NAME,'N',
                    NULL,
                    sysdate
from xxmx_scm_po_distributions_std_xfm
where DELIVER_TO_PERSON_FULL_NAME is not null
UNION
select distinct 'AGENT_BU',
                    AGENT_NAME||PRC_BU_NAME,
                    'N',
                    NULL,
                    sysdate
from xxmx_scm_po_headers_std_xfm
where AGENT_NAME is not null
and PRC_BU_NAME is not null
union
select distinct 'UNIT_OF_MEASURE',
                    UNIT_OF_MEASURE,
                    'N',
                    NULL,
                    sysdate 
from xxmx_scm_po_lines_std_xfm
where UNIT_OF_MEASURE is not null
union
select distinct 'PROJ_TASK_EXP',
                    project||task||expenditure_type,
                    'N',
                    NULL,
                    sysdate 
from xxmx_scm_po_distributions_std_xfm
where 1=1
and task is not null
and project is not null
and expenditure_type is not null
union
select distinct 'PROJECT',
                    project,
                    'N',
                    NULL,
                    sysdate 
from xxmx_scm_po_distributions_std_xfm
where 1=1
and project is not null
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
            TABLE OF xxmx_po_validation%rowtype INDEX BY BINARY_INTEGER;
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
            DELETE FROM xxmx_po_validation main
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
                INSERT INTO xxmx_po_validation (
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

        CURSOR LEGAL_ENTITY_cur IS
        SELECT
            *
        FROM
            xxmx_po_validation a
        WHERE
            a.validation_type = 'LEGAL_ENTITY'
            AND NOT EXISTS (
                SELECT
                    1
                FROM
                    xxmx_legal_entities b
                WHERE
                    a.validation_value = b.le_name
            )
            AND status = 'N';

        CURSOR hr_location_cur IS
        SELECT
            *
        FROM
            xxmx_po_validation a
        WHERE
            a.validation_type = 'LOCATION'
            AND NOT EXISTS (
                SELECT
                    1
                FROM
                    xxmx_hr_location b
                WHERE
                    a.validation_value = b.location_name
            )
            AND status = 'N';

        CURSOR Line_type_cur IS
        SELECT
            *
        FROM
            xxmx_po_validation a
        WHERE
            a.validation_type = 'LINE_TYPE'
            AND NOT EXISTS (
                SELECT
                    1
                FROM
                    XXMX_PURCHASING_LINE_TYPES b
                WHERE
                    a.validation_value = b.line_type
            )
            AND status = 'N';

        CURSOR project_cur IS
        SELECT
            *
        FROM
            xxmx_po_validation a
        WHERE
            a.validation_type = 'PROJECT'
            AND NOT EXISTS (
                SELECT
                    1
                FROM
                    XXMX_PROJECTS b
                WHERE
                    a.validation_value = b.SEGMENT1
					and PROJECT_STATUS_CODE = 'ACTIVE'
            )
            AND status = 'N';

        CURSOR po_bu_cur IS
        SELECT
            *
        FROM
            xxmx_po_validation a
        WHERE
            a.validation_type = 'BUSINESS_UNIT'
            AND NOT EXISTS (
                SELECT
                    1
                FROM
                    xxmx_business_units b
                WHERE
                    a.validation_value = b.bu_name
            )
            AND status = 'N';

        CURSOR payment_terms_cur IS
        SELECT
            *
        FROM
            xxmx_po_validation a
        WHERE
            a.validation_type = 'PAYMENT_TERMS'
            AND NOT EXISTS (
                SELECT
                    1
                FROM
                    xxmx_payment_terms b
                WHERE
                    a.validation_value = b.name
            )
            AND status = 'N';

        CURSOR category_cur IS
        SELECT
            *
        FROM
            xxmx_po_validation a
        WHERE
            a.validation_type = 'CATEGORY'
            AND NOT EXISTS (
                SELECT
                    1
                FROM
                    xxmx_po_category_item b
                WHERE
                    a.validation_value = b.level_4_name
            )
            AND status = 'N';


			CURSOR EXPENDITURE_TYPE_cur IS
        SELECT
            *
        FROM
            xxmx_po_validation a
        WHERE
            a.validation_type = 'EXPENDITURE_TYPE'
            AND NOT EXISTS (
                SELECT
                    1
                FROM
                    XXMX_EXPENDITURE_TYPE b
                WHERE
                    a.validation_value = b.EXPENDITURE_TYPE_NAME
            )
            AND status = 'N';

			CURSOR EXPENDITURE_ORG_cur IS
        SELECT
            *
        FROM
            xxmx_po_validation a
        WHERE
            a.validation_type = 'EXPENDITURE_ORGANIZATION'
            AND NOT EXISTS (
                SELECT
                    1
                FROM
                    XXMX_EXPENDITURE_ORG b
                WHERE
                   a.validation_value = b.name
            )
            AND status = 'N';


			CURSOR PROJ_TASK_EXP_cur IS
        SELECT
            *
        FROM
            xxmx_po_validation a
        WHERE
            a.validation_type = 'PROJ_TASK_EXP'
            AND NOT EXISTS (
                SELECT
                    1
                FROM
                    xxmx_po_project_Combo b
                WHERE
                    a.validation_value = b.PROJECT_NUMBER||b.TASK_NUMBER||b.EXPENDITURE_TYPE
            )
            AND status = 'N';

			CURSOR PERSON_cur IS
        SELECT
            *
        FROM
            xxmx_po_validation a
        WHERE
            a.validation_type = 'AGENT_NAME'
            AND NOT EXISTS (
                SELECT
                    1
                FROM
                    xxmx_person b
                WHERE
                    a.validation_value = last_name||', '||b.first_name
            )
            AND status = 'N';

            CURSOR requester_cur IS
        SELECT
            *
        FROM
            xxmx_po_validation a
        WHERE
            a.validation_type = 'REQUESTER'
            AND NOT EXISTS (
                SELECT
                    1
                FROM
                    xxmx_person b
                WHERE
                    a.validation_value = last_name||', '||b.first_name
            )
            AND status = 'N';

			CURSOR UOM_cur IS
        SELECT
            *
        FROM
            xxmx_po_validation a
        WHERE
            a.validation_type = 'UNIT_OF_MEASURE'
            AND NOT EXISTS (
                SELECT
                    1
                FROM
                    xxmx_UOM b
                WHERE
                    a.validation_value = b.UNIT_OF_MEASURE
            )
            AND status = 'N';

			CURSOR AGENTBU_cur IS
        SELECT
            *
        FROM
            xxmx_po_validation a
        WHERE
            a.validation_type = 'AGENT_BU'
            AND NOT EXISTS (
                SELECT
                    1
                FROM
                    xxmx_AGENT_BU b
                WHERE
                    a.validation_value = b.FULL_NAME||b.BU
            )
            AND status = 'N';


    BEGIN
        FOR i IN LEGAL_ENTITY_cur LOOP
            BEGIN
                UPDATE xxmx_po_validation
                SET
                    status = 'E',
                    last_update_date = sysdate
                WHERE
                    validation_type = 'LEGAL_ENTITY'
                    AND validation_value = i.validation_value;

            EXCEPTION
                WHEN OTHERS THEN
                    x_status := 'ERROR: '
                                || sqlerrm
                                || ' '
                                || sqlcode;
            END;
        END LOOP;

        FOR i IN hr_location_cur LOOP
            BEGIN
                UPDATE xxmx_po_validation
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

        FOR i IN Line_type_cur LOOP
            BEGIN
                UPDATE xxmx_po_validation
                SET
                    status = 'E',
                    last_update_date = sysdate
                WHERE
                    validation_type = 'LINE_TYPE'
                    AND validation_value = i.validation_value;

            EXCEPTION
                WHEN OTHERS THEN
                    x_status := 'ERROR: '
                                || sqlerrm
                                || ' '
                                || sqlcode;
            END;
        END LOOP;

        FOR i IN project_cur LOOP
            BEGIN
                UPDATE xxmx_po_validation
                SET
                    status = 'E',
                    last_update_date = sysdate
                WHERE
                    validation_type = 'PROJECT'
                    AND validation_value = i.validation_value;

            EXCEPTION
                WHEN OTHERS THEN
                    x_status := 'ERROR: '
                                || sqlerrm
                                || ' '
                                || sqlcode;
            END;
        END LOOP;

        FOR i IN PO_bu_cur LOOP
            BEGIN
                UPDATE xxmx_po_validation
                SET
                    status = 'E',
                    last_update_date = sysdate
                WHERE
                    validation_type = 'BUSINESS_UNIT'
                    AND validation_value = i.validation_value;

            EXCEPTION
                WHEN OTHERS THEN
                    x_status := 'ERROR: '
                                || sqlerrm
                                || ' '
                                || sqlcode;
            END;
        END LOOP;

        FOR i IN payment_terms_cur LOOP
            BEGIN
                UPDATE xxmx_po_validation
                SET
                    status = 'E',
                    last_update_date = sysdate
                WHERE
                    validation_type = 'PAYMENT_TERMS'
                    AND validation_value = i.validation_value;

            EXCEPTION
                WHEN OTHERS THEN
                    x_status := 'ERROR: '
                                || sqlerrm
                                || ' '
                                || sqlcode;
            END;
        END LOOP;

        FOR i IN EXPENDITURE_ORG_cur LOOP
            BEGIN
                UPDATE xxmx_po_validation
                SET
                    status = 'E',
                    last_update_date = sysdate
                WHERE
                    validation_type = 'EXPENDITURE_ORGANIZATION'
                    AND validation_value = i.validation_value;

            EXCEPTION
                WHEN OTHERS THEN
                    x_status := 'ERROR: '
                                || sqlerrm
                                || ' '
                                || sqlcode;
            END;
        END LOOP;


		FOR i IN EXPENDITURE_TYPE_cur LOOP
            BEGIN
                UPDATE xxmx_po_validation
                SET
                    status = 'E',
                    last_update_date = sysdate
                WHERE
                    validation_type = 'EXPENDITURE_TYPE'
                    AND validation_value = i.validation_value;

            EXCEPTION
                WHEN OTHERS THEN
                    x_status := 'ERROR: '
                                || sqlerrm
                                || ' '
                                || sqlcode;
            END;
        END LOOP;



        FOR i IN PROJ_TASK_EXP_cur LOOP
            BEGIN
                UPDATE xxmx_po_validation
                SET
                    status = 'E',
                    last_update_date = sysdate
                WHERE
                    validation_type = 'PROJ_TASK_EXP'
                    AND validation_value = i.validation_value;

            EXCEPTION
                WHEN OTHERS THEN
                    x_status := 'ERROR: '
                                || sqlerrm
                                || ' '
                                || sqlcode;
            END;
        END LOOP;

		FOR i IN PERSON_cur LOOP
            BEGIN
                UPDATE xxmx_po_validation
                SET
                    status = 'E',
                    last_update_date = sysdate
                WHERE
                    validation_type = 'AGENT_NAME'
                    AND validation_value = i.validation_value;

            EXCEPTION
                WHEN OTHERS THEN
                    x_status := 'ERROR: '
                                || sqlerrm
                                || ' '
                                || sqlcode;
            END;
        END LOOP;


        FOR i IN REQUESTER_cur LOOP
            BEGIN
                UPDATE xxmx_po_validation
                SET
                    status = 'E',
                    last_update_date = sysdate
                WHERE
                    validation_type = 'REQUESTER'
                    AND validation_value = i.validation_value;

            EXCEPTION
                WHEN OTHERS THEN
                    x_status := 'ERROR: '
                                || sqlerrm
                                || ' '
                                || sqlcode;
            END;
        END LOOP;

		FOR i IN UOM_cur LOOP
            BEGIN
                UPDATE xxmx_po_validation
                SET
                    status = 'E',
                    last_update_date = sysdate
                WHERE
                    validation_type = 'UNIT_OF_MEASURE'
                    AND validation_value = i.validation_value;

            EXCEPTION
                WHEN OTHERS THEN
                    x_status := 'ERROR: '
                                || sqlerrm
                                || ' '
                                || sqlcode;
            END;
        END LOOP;

		FOR i IN AGENTBU_cur LOOP
            BEGIN
                UPDATE xxmx_po_validation
                SET
                    status = 'E',
                    last_update_date = sysdate
                WHERE
                    validation_type = 'AGENT_BU'
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
END xxmx_validate_po_setup_pkg;

/
