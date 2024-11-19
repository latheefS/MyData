CREATE OR REPLACE PROCEDURE xxmx_insertdoc_extract2 (
    documenttype VARCHAR2,
    p_filename   VARCHAR2
) AS
BEGIN
    COMMIT;
    BEGIN
        IF documenttype = 'INVOICE' THEN
            INSERT INTO xxmx_invoice_document_extraction (
                document_type,
                invoice_number,
                invoice_date,
                vendor_name,
                vendor_address,
                invoice_total,
                sub_total,
                filename
            )
                SELECT
                    (
                        SELECT DISTINCT
                            document_type
                        FROM
                            xxmx_invoices
                        WHERE
                            document_type = documenttype
                            AND ROWNUM = 1
                    ) AS document_type_column,
                    (
                        SELECT
                            field_value
                        FROM
                            xxmx_invoices
                        WHERE
                            field_label LIKE 'InvoiceId'
                            AND document_type = documenttype
                            AND ROWNUM = 1
                    ) AS invoice_number_column,
                    (
                        SELECT
                            COALESCE(
                                TO_DATE(field_value DEFAULT NULL ON CONVERSION ERROR, 'MM/DD/YYYY', 'NLS_DATE_LANGUAGE=AMERICAN'),
                                TO_DATE(field_value DEFAULT NULL ON CONVERSION ERROR, 'DD/MM/YYYY', 'NLS_DATE_LANGUAGE=AMERICAN'),
                                TO_DATE(field_value DEFAULT NULL ON CONVERSION ERROR, 'YYYY-MM-DD', 'NLS_DATE_LANGUAGE=AMERICAN')
                            ) AS invoice_date
                        FROM
                            xxmx_invoices
                        WHERE
                            field_label LIKE 'InvoiceDate'
                            AND document_type = 'INVOICE'
                            AND ROWNUM = 1
                    ) AS invoice_date,
                    (
                        SELECT
                            field_value
                        FROM
                            xxmx_invoices
                        WHERE
                            field_label LIKE 'VendorName'
                            AND document_type = documenttype
                            AND ROWNUM = 1
                    ) AS vendor_name_column,
                    (
                        SELECT
                            field_value
                        FROM
                            xxmx_invoices
                        WHERE
                            field_label LIKE 'VendorAddress'
                            AND document_type = documenttype
                            AND ROWNUM = 1
                    ) AS vendor_address_column,
                    (
                        SELECT
                            field_value
                        FROM
                            xxmx_invoices
                        WHERE
                            field_label LIKE 'InvoiceTotal'
                            AND document_type = documenttype
                            AND ROWNUM = 1
                    ) AS invoice_total_column,
                    (
                        SELECT
                            field_value
                        FROM
                            xxmx_invoices
                        WHERE
                            field_label LIKE 'SubTotal'
                            AND document_type = documenttype
                            AND ROWNUM = 1
                    ) AS sub_total_column,
                    p_filename
                FROM
                    dual;

        ELSIF documenttype = 'PASSPORT' THEN
            INSERT INTO xxmx_passport_document_extraction (
                document_type,
                first_name,
                last_name,
                country,
                birth_date,
                expiry_date,
                gender,
                passport_no,
                filename
            )
                SELECT
                    (
                        SELECT DISTINCT
                            document_type
                        FROM
                            xxmx_invoices
                        WHERE
                            document_type = documenttype
                            AND ROWNUM = 1
                    ) AS document_type_column,
                    (
                        SELECT
                            field_value
                        FROM
                            xxmx_invoices
                        WHERE
                            field_label LIKE 'FirstName'
                            AND document_type = documenttype
                            AND ROWNUM = 1
                    ) AS first_name,
                    (
                        SELECT
                            field_value
                        FROM
                            xxmx_invoices
                        WHERE
                            field_label LIKE 'LastName'
                            AND document_type = documenttype
                            AND ROWNUM = 1
                    ) AS last_name,
                    (
                        SELECT
                            field_value
                        FROM
                            xxmx_invoices
                        WHERE
                            field_label LIKE 'Country'
                            AND document_type = documenttype
                            AND ROWNUM = 1
                    ) AS country,
                    TO_DATE((
                        SELECT
                            field_value
                        FROM
                            xxmx_invoices
                        WHERE
                            field_label LIKE 'BirthDate'
                            AND document_type = 'PASSPORT'
                            AND ROWNUM = 1
                    ), 'YYYY/MM/DD') AS birth_date,
                    TO_DATE((
                        SELECT
                            field_value
                        FROM
                            xxmx_invoices
                        WHERE
                            field_label LIKE 'ExpiryDate'
                            AND document_type = documenttype
                            AND ROWNUM = 1
                    ), 'YYYY/MM/DD') AS expiry_date,
                    (
                        SELECT
                            field_value
                        FROM
                            xxmx_invoices
                        WHERE
                            field_label LIKE 'Gender'
                            AND document_type = documenttype
                            AND ROWNUM = 1
                    ) AS gender,
                    (
                        SELECT
                            field_value
                        FROM
                            xxmx_invoices
                        WHERE
                            field_label LIKE 'DocumentNumber'
                            AND document_type = documenttype
                            AND ROWNUM = 1
                    ) AS passport_no,
                    p_filename
                FROM
                    dual;

        ELSIF documenttype = 'RECEIPT' THEN
            INSERT INTO xxmx_receipt_document_extraction (
                document_type,
                merchant_name,
                merchant_address,
                total,
                filename
            )
                SELECT
                    (
                        SELECT DISTINCT
                            document_type
                        FROM
                            xxmx_invoices
                        WHERE
                            document_type = documenttype
                            AND ROWNUM = 1
                    ) AS document_type_column,
                    (
                        SELECT
                            field_value
                        FROM
                            xxmx_invoices
                        WHERE
                            field_label LIKE 'MerchantName'
                            AND document_type = documenttype
                            AND ROWNUM = 1
                    ) AS merchant_name,
                    (
                        SELECT
                            field_value
                        FROM
                            xxmx_invoices
                        WHERE
                            field_label LIKE 'MerchantAddress'
                            AND document_type = documenttype
                            AND ROWNUM = 1
                    ) AS merchant_address,
                    (
                        SELECT
                            field_value
                        FROM
                            xxmx_invoices
                        WHERE
                            field_label LIKE 'Total'
                            AND document_type = documenttype
                            AND ROWNUM = 1
                    ) AS subtotal,
                    p_filename
                FROM
                    dual;

        END IF;
        DELETE FROM XXMX_INVOICES;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            DELETE FROM XXMX_INVOICES;
            COMMIT;
            RAISE;
    END;
END;
