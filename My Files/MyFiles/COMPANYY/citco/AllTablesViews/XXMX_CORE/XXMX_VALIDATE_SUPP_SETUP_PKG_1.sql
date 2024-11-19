--------------------------------------------------------
--  DDL for Package Body XXMX_VALIDATE_SUPP_SETUP_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "XXMX_CORE"."XXMX_VALIDATE_SUPP_SETUP_PKG" AS
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
                    'PAY_GROUP' validation_type,
                    pay_group,
                    'N'         status,
                    NULL        error_message,
                    sysdate     current_date
                FROM
                    xxmx_ap_supplier_sites_xfm
                WHERE
                    pay_group IS NOT NULL
                UNION
                SELECT DISTINCT
                    'WITHHOLDING_TAX_GROUP',
                    withholding_tax_group,
                    'N',
                    NULL,
                    sysdate
                FROM
                    xxmx_ap_supp_site_assigns_xfm
                WHERE
                    withholding_tax_group IS NOT NULL
                UNION
                SELECT DISTINCT
                    'SUPPLIER_TYPE',
                    supplier_type,
                    'N',
                    NULL,
                    sysdate
                FROM
                    xxmx_ap_suppliers_xfm
                WHERE
                    supplier_type IS NOT NULL
                UNION
                SELECT DISTINCT
                    'LOCATION',
                    ship_to_location,
                    'N',
                    NULL,
                    sysdate
                FROM
                    xxmx_ap_supp_site_assigns_xfm
                WHERE
                    ship_to_location IS NOT NULL
                UNION
                SELECT DISTINCT
                    'LOCATION',
                    bill_to_location,
                    'N',
                    NULL,
                    sysdate
                FROM
                    xxmx_ap_supp_site_assigns_xfm
                WHERE
                    bill_to_location IS NOT NULL
                UNION
                SELECT DISTINCT
                    'PROCUREMENT_BU',
                    procurement_bu,
                    'N',
                    NULL,
                    sysdate
                FROM
                    xxmx_ap_supplier_sites_xfm
                WHERE
                    procurement_bu IS NOT NULL
                UNION
                SELECT DISTINCT
                    'PROCUREMENT_BU',
                    procurement_bu,
                    'N',
                    NULL,
                    sysdate
                FROM
                    xxmx_ap_supp_site_assigns_xfm
                WHERE
                    procurement_bu IS NOT NULL
                UNION
                SELECT DISTINCT
                    'PROCUREMENT_BU',
                    client_bu,
                    'N',
                    NULL,
                    sysdate
                FROM
                    xxmx_ap_supp_site_assigns_xfm
                WHERE
                    client_bu IS NOT NULL
                UNION
                SELECT DISTINCT
                    'PROCUREMENT_BU',
                    bill_to_bu,
                    'N',
                    NULL,
                    sysdate
                FROM
                    xxmx_ap_supp_site_assigns_xfm
                WHERE
                    bill_to_bu IS NOT NULL
                UNION
                SELECT DISTINCT
                    'PROCUREMENT_BU',
                    business_unit,
                    'N',
                    NULL,
                    sysdate
                FROM
                    xxmx_ap_supp_payees_xfm
                WHERE
                    business_unit IS NOT NULL
                UNION
                SELECT DISTINCT
                    'PROCUREMENT_BU',
                    ou_name,
                    'N',
                    NULL,
                    sysdate
                FROM
                    xxmx_ap_supp_bank_accts_xfm
                WHERE
                    ou_name IS NOT NULL
                UNION
                SELECT DISTINCT
                    'PROCUREMENT_BU',
                    ou_name,
                    'N',
                    NULL,
                    sysdate
                FROM
                    xxmx_ap_supp_pmt_instrs_xfm
                WHERE
                    ou_name IS NOT NULL
                UNION
                SELECT DISTINCT
                    'BROWSING_CATEGORY',
                    attribute2,
                    'N',
                    NULL,
                    sysdate
                FROM
                    xxmx_ap_suppliers_XFM
                WHERE
                    ( attribute2 IS NOT NULL )
                    AND ( attribute2 != '.' )
					union
				select distinct 'PAYMENT_TERMS',
									PAYMENT_TERMS,
									'N',
									NULL,
									sysdate 
				from xxmx_ap_supplier_sites_xfm
				UNION
                SELECT DISTINCT
                    'TAX_ORGANIZATION_TYPE',
                    TAX_ORGANIZATION_TYPE,
                    'N',
                    NULL,
                    sysdate
                FROM
                    xxmx_ap_suppliers_XFM
					where TAX_ORGANIZATION_TYPE is not null
					union
				select distinct 'BUSINESS_RELATIONSHIP',
									BUSINESS_RELATIONSHIP,
									'N',
									NULL,
									sysdate 
				from xxmx_ap_suppliers_xfm
				where BUSINESS_RELATIONSHIP is not  null
				union
				select distinct 'PAYMENT_METHOD',
									PAYMENT_METHOD,
									'N',
									NULL,
									sysdate 
				from xxmx_ap_supplier_sites_xfm
				where PAYMENT_METHOD is not null
				union 
				select distinct 'PAYMENT_METHOD', DEFAULT_PAYMENT_METHOD_CODE,'N',
									NULL,
									sysdate
				from xxmx_ap_supp_payees_xfm
				where DEFAULT_PAYMENT_METHOD_CODE is not null
				union
				select distinct 'TAX_TYPE',
									FEDERAL_INCOME_TAX_TYPE,
									'N',
									NULL,
									sysdate 
				from xxmx_ap_suppliers_xfm
				where FEDERAL_INCOME_TAX_TYPE is not null
				union
				select distinct 'QUANTITY_TOLERANCES',
									QUANTITY_TOLERANCES,
									'N',
									NULL,
									sysdate 
				from xxmx_ap_supplier_sites_xfm
				where QUANTITY_TOLERANCES is not null
                UNION
                SELECT DISTINCT
                    'CATEGORY_ITEM',
                    --decode(attribute2,'Office Expenses','Office Expenditure','Cloud Providers','CAPEX','Personnel','Personnel Costs',attribute2)
                    --|| '.'
                    --|| 
                    attribute3,
                    'N',
                    NULL,
                    sysdate
                FROM
                    xxmx_ap_suppliers_XFM
                WHERE
                    ( attribute2
                      || '.'
                      || attribute3 IS NOT NULL )
                    AND ( attribute2
                          || '.'
                          || attribute3 != '.' )

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
            DELETE FROM xxmx_supplier_validation main
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
                INSERT INTO xxmx_supplier_validation (
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

        CURSOR pay_group_cur IS
        SELECT
            *
        FROM
            xxmx_supplier_validation a
        WHERE
            a.validation_type = 'PAY_GROUP'
            AND NOT EXISTS (
                SELECT
                    1
                FROM
                    xxmx_pay_groups b
                WHERE
                    a.validation_value = b.lookup_code
            )
            AND status = 'N';

        CURSOR hr_location_cur IS
        SELECT
            *
        FROM
            xxmx_supplier_validation a
        WHERE
            a.validation_type = 'LOCATION'
            AND NOT EXISTS (
                SELECT
                    1
                FROM
                    xxmx_hr_location b
                WHERE
                    a.validation_value = b.internal_location_code
            )
            AND status = 'N';

        CURSOR supp_withhold_cur IS
        SELECT
            *
        FROM
            xxmx_supplier_validation a
        WHERE
            a.validation_type = 'WITHHOLDING_TAX_GROUP'
            AND NOT EXISTS (
                SELECT
                    1
                FROM
                    xxmx_supplier_withhold_tax b
                WHERE
                    a.validation_value = b.tax_rate_code
            )
            AND status = 'N';

        CURSOR supp_type_cur IS
        SELECT
            *
        FROM
            xxmx_supplier_validation a
        WHERE
            a.validation_type = 'SUPPLIER_TYPE'
            AND NOT EXISTS (
                SELECT
                    1
                FROM
                    xxmx_supplier_type b
                WHERE
                    a.validation_value = b.lookup_code
            )
            AND status = 'N';

        CURSOR supp_bu_cur IS
        SELECT
            *
        FROM
            xxmx_supplier_validation a
        WHERE
            a.validation_type = 'PROCUREMENT_BU'
            AND NOT EXISTS (
                SELECT
                    1
                FROM
                    xxmx_business_units b
                WHERE
                    a.validation_value = b.bu_name
            )
            AND status = 'N';

        CURSOR category_browsing_cur IS
        SELECT
            *
        FROM
            xxmx_supplier_validation a
        WHERE
            a.validation_type = 'BROWSING_CATEGORY'
            AND NOT EXISTS (
                SELECT
                    1
                FROM
                    xxmx_po_category_browsing b
                WHERE
                    a.validation_value = b.category
            )
            AND status = 'N';

        CURSOR category_item_cur IS
        SELECT
            *
        FROM
            xxmx_supplier_validation a
        WHERE
            a.validation_type = 'CATEGORY_ITEM'
            AND NOT EXISTS (
                SELECT
                    1
                FROM
                    xxmx_po_category_item b
                WHERE
                    a.validation_value = b.level_4_name
            )
            AND status = 'N';

			CURSOR payment_terms_cur IS
        SELECT
            *
        FROM
            xxmx_supplier_validation a
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


			CURSOR tax_organization_type_cur IS
        SELECT
            *
        FROM
            xxmx_supplier_validation a
        WHERE
            a.validation_type = 'TAX_ORGANIZATION_TYPE'
            AND NOT EXISTS (
                SELECT
                    1
                FROM
                    XXMX_TAX_ORGANIZATION_TYPE b
                WHERE
                    a.validation_value = b.lookup_code
            )
            AND status = 'N';

			CURSOR BUSINESS_RELATIONSHIP_cur IS
        SELECT
            *
        FROM
            xxmx_supplier_validation a
        WHERE
            a.validation_type = 'BUSINESS_RELATIONSHIP'
            AND NOT EXISTS (
                SELECT
                    1
                FROM
                    XXMX_BUSINESS_RELATIONSHIP b
                WHERE
                    a.validation_value = b.lookup_code
            )
            AND status = 'N';

			CURSOR PAYMENT_METHOD_cur IS
        SELECT
            *
        FROM
            xxmx_supplier_validation a
        WHERE
            a.validation_type = 'PAYMENT_METHOD'
            AND NOT EXISTS (
                SELECT
                    1
                FROM
                    XXMX_PAYMENT_METHOD b
                WHERE
                    a.validation_value = b.payment_method_code
            )
            AND status = 'N';

			CURSOR TAX_TYPE_cur IS
        SELECT
            *
        FROM
            xxmx_supplier_validation a
        WHERE
            a.validation_type = 'TAX_TYPE'
            AND NOT EXISTS (
                SELECT
                    1
                FROM
                    XXMX_TAX_TYPE b
                WHERE
                    a.validation_value = b.income_tax_type
            )
            AND status = 'N';

			CURSOR QUANTITY_TOLERANCES_cur IS
        SELECT
            *
        FROM
            xxmx_supplier_validation a
        WHERE
            a.validation_type = 'QUANTITY_TOLERANCES'
            AND NOT EXISTS (
                SELECT
                    1
                FROM
                    XXMX_QUANTITY_TOLERANCE b
                WHERE
                    a.validation_value = b.tolerance_name
            )
            AND status = 'N';

    BEGIN
        FOR i IN pay_group_cur LOOP
            BEGIN
                UPDATE xxmx_supplier_validation
                SET
                    status = 'E',
                    last_update_date = sysdate
                WHERE
                    validation_type = 'PAY_GROUP'
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
                UPDATE xxmx_supplier_validation
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

        FOR i IN supp_withhold_cur LOOP
            BEGIN
                UPDATE xxmx_supplier_validation
                SET
                    status = 'E',
                    last_update_date = sysdate
                WHERE
                    validation_type = 'WITHHOLDING_TAX_GROUP'
                    AND validation_value = i.validation_value;

            EXCEPTION
                WHEN OTHERS THEN
                    x_status := 'ERROR: '
                                || sqlerrm
                                || ' '
                                || sqlcode;
            END;
        END LOOP;

        FOR i IN supp_type_cur LOOP
            BEGIN
                UPDATE xxmx_supplier_validation
                SET
                    status = 'E',
                    last_update_date = sysdate
                WHERE
                    validation_type = 'SUPPLIER_TYPE'
                    AND validation_value = i.validation_value;

            EXCEPTION
                WHEN OTHERS THEN
                    x_status := 'ERROR: '
                                || sqlerrm
                                || ' '
                                || sqlcode;
            END;
        END LOOP;

        FOR i IN supp_bu_cur LOOP
            BEGIN
                UPDATE xxmx_supplier_validation
                SET
                    status = 'E',
                    last_update_date = sysdate
                WHERE
                    validation_type = 'PROCUREMENT_BU'
                    AND validation_value = i.validation_value;

            EXCEPTION
                WHEN OTHERS THEN
                    x_status := 'ERROR: '
                                || sqlerrm
                                || ' '
                                || sqlcode;
            END;
        END LOOP;

        FOR i IN category_browsing_cur LOOP
            BEGIN
                UPDATE xxmx_supplier_validation
                SET
                    status = 'E',
                    last_update_date = sysdate
                WHERE
                    validation_type = 'BROWSING_CATEGORY'
                    AND validation_value = i.validation_value;

            EXCEPTION
                WHEN OTHERS THEN
                    x_status := 'ERROR: '
                                || sqlerrm
                                || ' '
                                || sqlcode;
            END;
        END LOOP;

        FOR i IN category_item_cur LOOP
            BEGIN
                UPDATE xxmx_supplier_validation
                SET
                    status = 'E',
                    last_update_date = sysdate
                WHERE
                    validation_type = 'CATEGORY_ITEM'
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
                UPDATE xxmx_supplier_validation
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


		FOR i IN tax_organization_type_cur LOOP
            BEGIN
                UPDATE xxmx_supplier_validation
                SET
                    status = 'E',
                    last_update_date = sysdate
                WHERE
                    validation_type = 'TAX_ORGANIZATION_TYPE'
                    AND validation_value = i.validation_value;

            EXCEPTION
                WHEN OTHERS THEN
                    x_status := 'ERROR: '
                                || sqlerrm
                                || ' '
                                || sqlcode;
            END;
        END LOOP;

		FOR i IN BUSINESS_RELATIONSHIP_cur LOOP
            BEGIN
                UPDATE xxmx_supplier_validation
                SET
                    status = 'E',
                    last_update_date = sysdate
                WHERE
                    validation_type = 'BUSINESS_RELATIONSHIP'
                    AND validation_value = i.validation_value;

            EXCEPTION
                WHEN OTHERS THEN
                    x_status := 'ERROR: '
                                || sqlerrm
                                || ' '
                                || sqlcode;
            END;
        END LOOP;

		FOR i IN PAYMENT_METHOD_cur LOOP
            BEGIN
                UPDATE xxmx_supplier_validation
                SET
                    status = 'E',
                    last_update_date = sysdate
                WHERE
                    validation_type = 'PAYMENT_METHOD'
                    AND validation_value = i.validation_value;

            EXCEPTION
                WHEN OTHERS THEN
                    x_status := 'ERROR: '
                                || sqlerrm
                                || ' '
                                || sqlcode;
            END;
        END LOOP;

		FOR i IN TAX_TYPE_cur LOOP
            BEGIN
                UPDATE xxmx_supplier_validation
                SET
                    status = 'E',
                    last_update_date = sysdate
                WHERE
                    validation_type = 'TAX_TYPE'
                    AND validation_value = i.validation_value;

            EXCEPTION
                WHEN OTHERS THEN
                    x_status := 'ERROR: '
                                || sqlerrm
                                || ' '
                                || sqlcode;
            END;
        END LOOP;


		FOR i IN QUANTITY_TOLERANCES_cur LOOP
            BEGIN
                UPDATE xxmx_supplier_validation
                SET
                    status = 'E',
                    last_update_date = sysdate
                WHERE
                    validation_type = 'QUANTITY_TOLERANCES'
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
END xxmx_validate_supp_setup_pkg;

/
