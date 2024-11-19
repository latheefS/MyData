CREATE OR REPLACE PACKAGE XXMX_CORE.XXMX_PO_RECEIPTS_PKG AUTHID CURRENT_USER
AS
--//===============================================================================
--// Version1
--// $Id:$
--//===============================================================================
--// Object Name         :: XXMX_PO_RECEIPTS_PKG.pkh
--//
--// Object Type         :: Package Specification
--//
--// Object Description  :: This package contains procedure for PO Receipts
--//                        data migration from R12 to Fusion
--//
--// Version Control
--//===============================================================================
--// Version      Author               Date               Description
--//-------------------------------------------------------------------------------
--// 1.0          Raghu Chilukoori     20-Sep-2022        Initial Build
--//===============================================================================
--
    --
    -- ----------------------------------------------------------------------------
    -- |---------------------< STG_PO_RECEIPT_HEADERS >---------------------------|
    -- ----------------------------------------------------------------------------
    PROCEDURE stg_po_receipt_headers;
    --
    -- ----------------------------------------------------------------------------
    -- |---------------------< XFM_PO_RECEIPT_HEADERS >---------------------------|
    -- ----------------------------------------------------------------------------
    PROCEDURE xfm_po_receipt_headers;
    --
    -- ----------------------------------------------------------------------------
    -- |-------------------< STG_PO_RCPT_TRX >------------------------------------|
    -- ----------------------------------------------------------------------------
    PROCEDURE stg_po_rcpt_trx;
    --
    -- ----------------------------------------------------------------------------
    -- |-------------------< XFM_PO_RCPT_TRX >------------------------------------|
    -- ----------------------------------------------------------------------------
    PROCEDURE xfm_po_rcpt_trx;
    --
    -- ----------------------------------------------------------------------------
    -- |---------------------------< MAIN >---------------------------------------|
    -- ----------------------------------------------------------------------------
    PROCEDURE main(p_stage IN VARCHAR2);
    --
END XXMX_PO_RECEIPTS_PKG;
/
CREATE OR REPLACE PACKAGE BODY XXMX_CORE.XXMX_PO_RECEIPTS_PKG
AS
--//============================================================================
--// Version1
--// $Id:$
--//============================================================================
--// Object Name         :: XXMX_PO_RECEIPTS_PKG.pkb
--//
--// Object Type         :: Package Body
--//
--// Object Description  :: This package contains procedure for Purchase Order
--//                        Receipts data migration from R12 to Fusion.
--//
--// Version Control
--//============================================================================
--// Version      Author               Date               Description
--//----------------------------------------------------------------------------
--// 1.0          Raghu Chilukoori     20-Sep-2022        Initial Build
--//============================================================================
--
  --// Package Type Variables
  TYPE type_fbdi_data IS TABLE OF VARCHAR2(30000) INDEX BY BINARY_INTEGER;
  g_fbdi_data         type_fbdi_data;
  g_batch_id          NUMBER         := TO_NUMBER(TO_CHAR(systimestamp,'YYYYMMDDHH24MM'));
  g_batch_name        VARCHAR2(240)  := TO_CHAR(systimestamp,'YYYYMMDDHH24MM');
  gv_location         VARCHAR2(500)  := NULL;
  g_module            VARCHAR2(20)   := 'PO';
  g_entity            VARCHAR2(20)   := 'PO_RECEIPTS';
  gc_error_id_s       VARCHAR2(500);
  --
  -- ----------------------------------------------------------------------------
  -- |---------------------< UPDATE_RECEIPTS_FROM_STG >---------------------------|
  -- ----------------------------------------------------------------------------
  --
  PROCEDURE update_receipts_from_stg
  IS
  BEGIN
    --
    --
    COMMIT;
    --
  END update_receipts_from_stg;
  --
  -- ----------------------------------------------------------------------------
  -- |---------------------< DELETE_RECEIPTS_FROM_STG >---------------------------|
  -- ----------------------------------------------------------------------------
  --
  PROCEDURE delete_receipts_from_stg
  IS
  BEGIN
    --
    dbms_output.put_line('xxmx_po_receipts_pkg.delete_receipts_from_stg - Delete the RCPT TRX from XXMX_PO_RCPT_TRX_STG records where Quantity/Amount is ZERO ');
    DELETE
    FROM   xxmx_po_rcpt_trx_stg rt
    WHERE  1 = 1
    AND    NVL(quantity, 0) <= 0
    AND    NVL(amount, 0) <= 0
    AND    batch_name = g_batch_name;
    dbms_output.put_line('xxmx_po_receipts_pkg.delete_receipts_from_stg - Deleted the RCPT TRX from XXMX_PO_RCPT_TRX_STG records where Quantity/Amount is ZERO: '||SQL%ROWCOUNT);
    --
    dbms_output.put_line('xxmx_po_receipts_pkg.delete_receipts_from_stg - Delete the RCPT TRX from XXMX_PO_RCPT_TRX_STG records where reference not exists in XXMX_PO_RCPT_HEADERS_STG ');
    DELETE
    FROM   xxmx_po_rcpt_trx_stg rt
    WHERE  1 = 1
    AND    batch_name = g_batch_name
    AND    NOT EXISTS ( SELECT 1
                        FROM   xxmx_po_rcpt_headers_stg rh
                        WHERE  1 = 1
                        AND    rh.batch_name = g_batch_name
                        AND    rh.header_interface_number = rt.header_interface_num);
    dbms_output.put_line('xxmx_po_receipts_pkg.delete_receipts_from_stg - Deleted the RCPT TRX from XXMX_PO_RCPT_TRX_STG records where reference not exists in XXMX_PO_RCPT_HEADERS_STG: '||SQL%ROWCOUNT);
    --
    dbms_output.put_line('xxmx_po_receipts_pkg.delete_receipts_from_stg - Delete the RCPT HEADERS from XXMX_PO_RCPT_HEADERS_STG records where reference not exists in XXMX_PO_RCPT_TRX_STG ');
    DELETE
    FROM   xxmx_po_rcpt_headers_stg rh
    WHERE  1 = 1
    AND    batch_name = g_batch_name
    AND    NOT EXISTS ( SELECT 1
                        FROM   xxmx_po_rcpt_trx_stg rt
                        WHERE  1 = 1
                        AND    rt.batch_name = g_batch_name
                        AND    rt.header_interface_num = rh.header_interface_number);
    dbms_output.put_line('xxmx_po_receipts_pkg.delete_receipts_from_stg - Deleted the RCPT HEADERS from XXMX_PO_RCPT_HEADERS_STG records where reference not exists in XXMX_PO_RCPT_TRX_STG: '||SQL%ROWCOUNT);
    --
    COMMIT;
    --
  END delete_receipts_from_stg;
  --
  -- ----------------------------------------------------------------------------
  -- |---------------------< STG_PO_RECEIPT_HEADERS >---------------------------|
  -- ----------------------------------------------------------------------------
  --
  PROCEDURE stg_po_receipt_headers
  IS
    -- local CURSOR
    -- Cursor to get all eligible PO Receipt Header records to be migrated
    CURSOR po_receipt_headers_cur
    IS
      SELECT header_interface_number
            ,receipt_source_code
            ,asn_type
            ,transaction_type
            ,notice_creation_date
            ,shipment_num
            ,receipt_num
            ,vendor_name
            ,vendor_num
            ,vendor_site_code
            ,from_organization_code
            ,ship_to_organization_code
            ,location_code
            ,bill_of_lading
            ,packing_slip
            ,shipped_date
            ,freight_carrier_name
            ,expected_receipt_date
            ,num_of_containers
            ,waybill_airbill_num
            ,comments
            ,gross_weight
            ,gross_weight_unit_of_measure
            ,net_weight
            ,net_weight_unit_of_measure
            ,tar_weight
            ,tar_weight_unit_of_measure
            ,packaging_code
            ,carrier_method
            ,carrier_equipment
            ,special_handling_code
            ,hazard_code
            ,hazard_class
            ,hazard_description
            ,freight_terms
            ,freight_bill_number
            ,invoice_num
            ,invoice_date
            ,total_invoice_amount
            ,tax_name
            ,tax_amount
            ,freight_amount
            ,currency_code
            ,conversion_rate_type
            ,conversion_rate
            ,conversion_rate_date
            ,payment_terms_name
            ,employee_name
            ,transaction_date
            ,customer_account_number
            ,customer_party_name
            ,customer_party_number
            ,business_unit
            ,ra_outsourcer_party_name
            ,receipt_advice_number
            ,ra_document_code
            ,ra_document_number
            ,ra_doc_revision_number
            ,ra_doc_revision_date
            ,ra_doc_creation_date
            ,ra_doc_last_update_date
            ,ra_outsourcer_contact_name
            ,ra_vendor_site_name
            ,ra_note_to_receiver
            ,ra_doo_source_system_name
            ,attribute_category
            ,attribute1
            ,attribute2
            ,attribute3
            ,attribute4
            ,attribute5
            ,attribute6
            ,attribute7
            ,attribute8
            ,attribute9
            ,attribute10
            ,attribute11
            ,attribute12
            ,attribute13
            ,attribute14
            ,attribute15
            ,attribute16
            ,attribute17
            ,attribute18
            ,attribute19
            ,attribute20
            ,attribute_number1
            ,attribute_number2
            ,attribute_number3
            ,attribute_number4
            ,attribute_number5
            ,attribute_number6
            ,attribute_number7
            ,attribute_number8
            ,attribute_number9
            ,attribute_number10
            ,attribute_date1
            ,attribute_date2
            ,attribute_date3
            ,attribute_date4
            ,attribute_date5
            ,attribute_timestamp1
            ,attribute_timestamp2
            ,attribute_timestamp3
            ,attribute_timestamp4
            ,attribute_timestamp5
            ,gl_date
            ,receipt_header_id
            ,batch_name
            ,last_update_date
            ,last_updated_by
            ,creation_date
            ,created_by
      FROM  (
    SELECT distinct
           rsh.shipment_header_id                                                      AS HEADER_INTERFACE_NUMBER
          ,rsh.receipt_source_code                                                     AS RECEIPT_SOURCE_CODE
          ,rsh.asn_type                                                                AS ASN_TYPE
          ,'NEW'                                                                       AS TRANSACTION_TYPE
          ,rsh.notice_creation_date                                                    AS NOTICE_CREATION_DATE
          ,rsh.shipment_num                                                            AS SHIPMENT_NUM
          ,rsh.receipt_num                                                             AS RECEIPT_NUM
          ,pv.vendor_name                                                              AS VENDOR_NAME
          ,pv.segment1                                                                 AS VENDOR_NUM
          ,pvs.vendor_site_code                                                        AS VENDOR_SITE_CODE
          ,null                                                                        AS FROM_ORGANIZATION_CODE
          ,null                                                                        AS SHIP_TO_ORGANIZATION_CODE
          ,null                                                                        AS LOCATION_CODE
          ,rsh.bill_of_lading                                                          AS BILL_OF_LADING
          ,rsh.packing_slip                                                            AS PACKING_SLIP
          ,rsh.shipped_date                                                            AS SHIPPED_DATE
          ,rsh.freight_carrier_code                                                    AS FREIGHT_CARRIER_NAME
          ,rsh.expected_receipt_date                                                   AS EXPECTED_RECEIPT_DATE
          ,rsh.num_of_containers                                                       AS NUM_OF_CONTAINERS
          ,rsh.waybill_airbill_num                                                     AS WAYBILL_AIRBILL_NUM
          ,replace(replace(replace(replace(rsh.comments , chr(13)), chr(10),',') ,'"','""'),'   ','')
                                                                                       AS COMMENTS
          ,rsh.gross_weight                                                            AS GROSS_WEIGHT
          ,rsh.gross_weight_uom_code                                                   AS GROSS_WEIGHT_UNIT_OF_MEASURE
          ,rsh.net_weight                                                              AS NET_WEIGHT
          ,rsh.net_weight_uom_code                                                     AS NET_WEIGHT_UNIT_OF_MEASURE
          ,rsh.tar_weight                                                              AS TAR_WEIGHT
          ,rsh.tar_weight_uom_code                                                     AS TAR_WEIGHT_UNIT_OF_MEASURE
          ,rsh.packaging_code                                                          AS PACKAGING_CODE
          ,rsh.carrier_method                                                          AS CARRIER_METHOD
          ,rsh.carrier_equipment                                                       AS CARRIER_EQUIPMENT
          ,rsh.special_handling_code                                                   AS SPECIAL_HANDLING_CODE
          ,rsh.hazard_code                                                             AS HAZARD_CODE
          ,rsh.hazard_class                                                            AS HAZARD_CLASS
          ,rsh.hazard_description                                                      AS HAZARD_DESCRIPTION
          ,rsh.freight_terms                                                           AS FREIGHT_TERMS
          ,rsh.freight_bill_number                                                     AS FREIGHT_BILL_NUMBER
          ,rsh.invoice_num                                                             AS INVOICE_NUM
          ,rsh.invoice_date                                                            AS INVOICE_DATE
          ,rsh.invoice_amount                                                          AS TOTAL_INVOICE_AMOUNT
          ,rsh.tax_name                                                                AS TAX_NAME
          ,rsh.tax_amount                                                              AS TAX_AMOUNT
          ,rsh.freight_amount                                                          AS FREIGHT_AMOUNT
          ,rsh.currency_code                                                           AS CURRENCY_CODE
          ,rsh.conversion_rate_type                                                    AS CONVERSION_RATE_TYPE
          ,rsh.conversion_rate                                                         AS CONVERSION_RATE
          ,rsh.conversion_date                                                         AS CONVERSION_RATE_DATE
          ,rsh.payment_terms_id                                                        AS PAYMENT_TERMS_NAME
          ,NULL                                                                        AS EMPLOYEE_NAME
          ,(SELECT MAX(rt.transaction_date)
            FROM  apps.rcv_transactions@MXDM_NVIS_EXTRACT rt
            WHERE rsh.shipment_header_id = rt.shipment_header_id)                      AS TRANSACTION_DATE
          ,NULL                                                                        AS CUSTOMER_ACCOUNT_NUMBER
          ,NULL                                                                        AS CUSTOMER_PARTY_NAME
          ,NULL                                                                        AS CUSTOMER_PARTY_NUMBER
          ,'PARATUS AMC'                                                               AS BUSINESS_UNIT
          ,NULL                                                                        AS RA_OUTSOURCER_PARTY_NAME
          ,NULL                                                                        AS RECEIPT_ADVICE_NUMBER
          ,NULL                                                                        AS RA_DOCUMENT_CODE
          ,NULL                                                                        AS RA_DOCUMENT_NUMBER
          ,NULL                                                                        AS RA_DOC_REVISION_NUMBER
          ,NULL                                                                        AS RA_DOC_REVISION_DATE
          ,NULL                                                                        AS RA_DOC_CREATION_DATE
          ,NULL                                                                        AS RA_DOC_LAST_UPDATE_DATE
          ,NULL                                                                        AS RA_OUTSOURCER_CONTACT_NAME
          ,NULL                                                                        AS RA_VENDOR_SITE_NAME
          ,NULL                                                                        AS RA_NOTE_TO_RECEIVER
          ,NULL                                                                        AS RA_DOO_SOURCE_SYSTEM_NAME
          /*
          ,rsh.attribute_category                                                      AS ATTRIBUTE_CATEGORY
          ,rsh.attribute1                                                              AS ATTRIBUTE1
          ,rsh.attribute2                                                              AS ATTRIBUTE2
          ,rsh.attribute3                                                              AS ATTRIBUTE3
          ,rsh.attribute4                                                              AS ATTRIBUTE4
          ,rsh.attribute5                                                              AS ATTRIBUTE5
          ,rsh.attribute6                                                              AS ATTRIBUTE6
          ,rsh.attribute7                                                              AS ATTRIBUTE7
          ,rsh.attribute8                                                              AS ATTRIBUTE8
          ,rsh.attribute9                                                              AS ATTRIBUTE9
          ,rsh.attribute10                                                             AS ATTRIBUTE10
          ,rsh.attribute11                                                             AS ATTRIBUTE11
          ,rsh.attribute12                                                             AS ATTRIBUTE12
          ,rsh.attribute13                                                             AS ATTRIBUTE13
          ,rsh.attribute14                                                             AS ATTRIBUTE14
          ,rsh.attribute15                                                             AS ATTRIBUTE15
          */
          ,NULL                                                                        AS ATTRIBUTE_CATEGORY
          ,NULL                                                                        AS ATTRIBUTE1
          ,NULL                                                                        AS ATTRIBUTE2
          ,NULL                                                                        AS ATTRIBUTE3
          ,NULL                                                                        AS ATTRIBUTE4
          ,NULL                                                                        AS ATTRIBUTE5
          ,NULL                                                                        AS ATTRIBUTE6
          ,NULL                                                                        AS ATTRIBUTE7
          ,NULL                                                                        AS ATTRIBUTE8
          ,NULL                                                                        AS ATTRIBUTE9
          ,NULL                                                                        AS ATTRIBUTE10
          ,NULL                                                                        AS ATTRIBUTE11
          ,NULL                                                                        AS ATTRIBUTE12
          ,NULL                                                                        AS ATTRIBUTE13
          ,NULL                                                                        AS ATTRIBUTE14
          ,NULL                                                                        AS ATTRIBUTE15
          ,NULL                                                                        AS ATTRIBUTE16
          ,NULL                                                                        AS ATTRIBUTE17
          ,NULL                                                                        AS ATTRIBUTE18
          ,NULL                                                                        AS ATTRIBUTE19
          ,NULL                                                                        AS ATTRIBUTE20
          ,NULL                                                                        AS ATTRIBUTE_NUMBER1
          ,NULL                                                                        AS ATTRIBUTE_NUMBER2
          ,NULL                                                                        AS ATTRIBUTE_NUMBER3
          ,NULL                                                                        AS ATTRIBUTE_NUMBER4
          ,NULL                                                                        AS ATTRIBUTE_NUMBER5
          ,NULL                                                                        AS ATTRIBUTE_NUMBER6
          ,NULL                                                                        AS ATTRIBUTE_NUMBER7
          ,NULL                                                                        AS ATTRIBUTE_NUMBER8
          ,NULL                                                                        AS ATTRIBUTE_NUMBER9
          ,NULL                                                                        AS ATTRIBUTE_NUMBER10
          ,NULL                                                                        AS ATTRIBUTE_DATE1
          ,NULL                                                                        AS ATTRIBUTE_DATE2
          ,NULL                                                                        AS ATTRIBUTE_DATE3
          ,NULL                                                                        AS ATTRIBUTE_DATE4
          ,NULL                                                                        AS ATTRIBUTE_DATE5
          ,NULL                                                                        AS ATTRIBUTE_TIMESTAMP1
          ,NULL                                                                        AS ATTRIBUTE_TIMESTAMP2
          ,NULL                                                                        AS ATTRIBUTE_TIMESTAMP3
          ,NULL                                                                        AS ATTRIBUTE_TIMESTAMP4
          ,NULL                                                                        AS ATTRIBUTE_TIMESTAMP5
          ,NULL                                                                        AS GL_DATE
         , NULL                                                                        AS RECEIPT_HEADER_ID
         , g_batch_name                                                                AS BATCH_NAME
         , TRUNC(SYSDATE)                                                              AS LAST_UPDATE_DATE
         , 'XXMX_CORE'                                                                 AS LAST_UPDATED_BY
         , TRUNC(SYSDATE)                                                              AS CREATION_DATE
         , 'XXMX_CORE'                                                                 AS CREATED_BY
      FROM  apps.rcv_shipment_headers@MXDM_NVIS_EXTRACT rsh,
            apps.po_vendors@MXDM_NVIS_EXTRACT pv,
            apps.po_vendor_sites_all@MXDM_NVIS_EXTRACT pvs
     WHERE  1 = 1
       AND  rsh.vendor_id = pv.vendor_id
       AND  rsh.vendor_site_id = pvs.vendor_site_id
       AND  pv.vendor_id = pvs.vendor_id
       AND  EXISTS ( SELECT 1
                       FROM apps.rcv_shipment_lines@MXDM_NVIS_EXTRACT rsl,
                            apps.rcv_transactions@MXDM_NVIS_EXTRACT rt,
                            (SELECT po_header_id,
                                    po_line_id,
                                    line_location_id,
                                    SUM(open_po) open_po,
                                    SUM(received) received,
                                    SUM(billed) billed
                               FROM xxmx_po_open_quantity_mv pov
                              WHERE    pov.open_po > 0
                                   AND pov.received > 0
                                   AND pov.billed >= 0
                                   AND (pov.received - pov.billed) > 0
                              GROUP BY po_header_id,
                                       po_line_id,
                                       line_location_id) po_v
                      WHERE     rsl.shipment_header_id = rsh.shipment_header_id
                           AND rsl.po_header_id = po_v.po_header_id
                           AND rsl.po_line_id = po_v.po_line_id
                           AND rsl.po_line_location_id = po_v.line_location_id
                           AND rsl.shipment_header_id = rt.shipment_header_id
                           AND rsl.shipment_line_id = rt.shipment_line_id
                           AND rt.transaction_type = 'RECEIVE'
                           AND (NVL(rt.amount_billed, 0) != NVL(rt.amount, 0) OR NVL(rt.quantity_billed, 0) != NVL(rt.quantity, 0))  )

      )
      WHERE  1 = 1;
--
-- local type variables
--
    TYPE po_receipt_headers_tbl IS TABLE OF po_receipt_headers_cur%ROWTYPE INDEX BY BINARY_INTEGER;
    po_receipt_headers_tb po_receipt_headers_tbl;
--
BEGIN
    gv_location := NULL;
    --
    dbms_output.put_line('xxmx_po_receipts_pkg.stg_po_receipt_headers - Data Insertion in STG Table Start ');
    gv_location := 'xxmx_po_receipts_pkg.stg_po_receipt_headers - Data Insertion in STG Table Start';
    --
    OPEN po_receipt_headers_cur;
    --
    gv_location := 'Cursor Open po_receipt_headers_cur';
    --
    LOOP
    --
        gv_location := 'Inside the Cursor loop';
        --
        FETCH   po_receipt_headers_cur
        BULK
        COLLECT
        INTO    po_receipt_headers_tb
        LIMIT   5000;
        --
        gv_location := 'Cursor po_receipt_headers_cur Fetch into po_receipt_headers_tb';
        --
        EXIT WHEN po_receipt_headers_tb.COUNT=0;
        --
        FOR i IN 1..po_receipt_headers_tb.COUNT
        LOOP
        --
            INSERT
            INTO xxmx_po_rcpt_headers_stg (
                 header_interface_number
                ,receipt_source_code
                ,asn_type
                ,transaction_type
                ,notice_creation_date
                ,shipment_num
                ,receipt_num
                ,vendor_name
                ,vendor_num
                ,vendor_site_code
                ,from_organization_code
                ,ship_to_organization_code
                ,location_code
                ,bill_of_lading
                ,packing_slip
                ,shipped_date
                ,freight_carrier_name
                ,expected_receipt_date
                ,num_of_containers
                ,waybill_airbill_num
                ,comments
                ,gross_weight
                ,gross_weight_unit_of_measure
                ,net_weight
                ,net_weight_unit_of_measure
                ,tar_weight
                ,tar_weight_unit_of_measure
                ,packaging_code
                ,carrier_method
                ,carrier_equipment
                ,special_handling_code
                ,hazard_code
                ,hazard_class
                ,hazard_description
                ,freight_terms
                ,freight_bill_number
                ,invoice_num
                ,invoice_date
                ,total_invoice_amount
                ,tax_name
                ,tax_amount
                ,freight_amount
                ,currency_code
                ,conversion_rate_type
                ,conversion_rate
                ,conversion_rate_date
                ,payment_terms_name
                ,employee_name
                ,transaction_date
                ,customer_account_number
                ,customer_party_name
                ,customer_party_number
                ,business_unit
                ,ra_outsourcer_party_name
                ,receipt_advice_number
                ,ra_document_code
                ,ra_document_number
                ,ra_doc_revision_number
                ,ra_doc_revision_date
                ,ra_doc_creation_date
                ,ra_doc_last_update_date
                ,ra_outsourcer_contact_name
                ,ra_vendor_site_name
                ,ra_note_to_receiver
                ,ra_doo_source_system_name
                ,attribute_category
                ,attribute1
                ,attribute2
                ,attribute3
                ,attribute4
                ,attribute5
                ,attribute6
                ,attribute7
                ,attribute8
                ,attribute9
                ,attribute10
                ,attribute11
                ,attribute12
                ,attribute13
                ,attribute14
                ,attribute15
                ,attribute16
                ,attribute17
                ,attribute18
                ,attribute19
                ,attribute20
                ,attribute_number1
                ,attribute_number2
                ,attribute_number3
                ,attribute_number4
                ,attribute_number5
                ,attribute_number6
                ,attribute_number7
                ,attribute_number8
                ,attribute_number9
                ,attribute_number10
                ,attribute_date1
                ,attribute_date2
                ,attribute_date3
                ,attribute_date4
                ,attribute_date5
                ,attribute_timestamp1
                ,attribute_timestamp2
                ,attribute_timestamp3
                ,attribute_timestamp4
                ,attribute_timestamp5
                ,gl_date
                ,receipt_header_id
                ,batch_name
                ,last_update_date
                ,last_updated_by
                ,creation_date
                ,created_by)
            VALUES  (
                 po_receipt_headers_tb(i).header_interface_number               -- header_interface_number
                ,po_receipt_headers_tb(i).receipt_source_code                   -- receipt_source_code
                ,po_receipt_headers_tb(i).asn_type                              -- asn_type
                ,po_receipt_headers_tb(i).transaction_type                      -- transaction_type
                ,po_receipt_headers_tb(i).notice_creation_date                  -- notice_creation_date
                ,po_receipt_headers_tb(i).shipment_num                          -- shipment_num
                ,po_receipt_headers_tb(i).receipt_num                           -- receipt_num
                ,po_receipt_headers_tb(i).vendor_name                           -- vendor_name
                ,po_receipt_headers_tb(i).vendor_num                            -- vendor_num
                ,po_receipt_headers_tb(i).vendor_site_code                      -- vendor_site_code
                ,po_receipt_headers_tb(i).from_organization_code                -- from_organization_code
                ,po_receipt_headers_tb(i).ship_to_organization_code             -- ship_to_organization_code
                ,po_receipt_headers_tb(i).location_code                         -- location_code
                ,po_receipt_headers_tb(i).bill_of_lading                        -- bill_of_lading
                ,po_receipt_headers_tb(i).packing_slip                          -- packing_slip
                ,po_receipt_headers_tb(i).shipped_date                          -- shipped_date
                ,po_receipt_headers_tb(i).freight_carrier_name                  -- freight_carrier_name
                ,po_receipt_headers_tb(i).expected_receipt_date                 -- expected_receipt_date
                ,po_receipt_headers_tb(i).num_of_containers                     -- num_of_containers
                ,po_receipt_headers_tb(i).waybill_airbill_num                   -- waybill_airbill_num
                ,po_receipt_headers_tb(i).comments                              -- comments
                ,po_receipt_headers_tb(i).gross_weight                          -- gross_weight
                ,po_receipt_headers_tb(i).gross_weight_unit_of_measure          -- gross_weight_unit_of_measure
                ,po_receipt_headers_tb(i).net_weight                            -- net_weight
                ,po_receipt_headers_tb(i).net_weight_unit_of_measure            -- net_weight_unit_of_measure
                ,po_receipt_headers_tb(i).tar_weight                            -- tar_weight
                ,po_receipt_headers_tb(i).tar_weight_unit_of_measure            -- tar_weight_unit_of_measure
                ,po_receipt_headers_tb(i).packaging_code                        -- packaging_code
                ,po_receipt_headers_tb(i).carrier_method                        -- carrier_method
                ,po_receipt_headers_tb(i).carrier_equipment                     -- carrier_equipment
                ,po_receipt_headers_tb(i).special_handling_code                 -- special_handling_code
                ,po_receipt_headers_tb(i).hazard_code                           -- hazard_code
                ,po_receipt_headers_tb(i).hazard_class                          -- hazard_class
                ,po_receipt_headers_tb(i).hazard_description                    -- hazard_description
                ,po_receipt_headers_tb(i).freight_terms                         -- freight_terms
                ,po_receipt_headers_tb(i).freight_bill_number                   -- freight_bill_number
                ,po_receipt_headers_tb(i).invoice_num                           -- invoice_num
                ,po_receipt_headers_tb(i).invoice_date                          -- invoice_date
                ,po_receipt_headers_tb(i).total_invoice_amount                  -- total_invoice_amount
                ,po_receipt_headers_tb(i).tax_name                              -- tax_name
                ,po_receipt_headers_tb(i).tax_amount                            -- tax_amount
                ,po_receipt_headers_tb(i).freight_amount                        -- freight_amount
                ,po_receipt_headers_tb(i).currency_code                         -- currency_code
                ,po_receipt_headers_tb(i).conversion_rate_type                  -- conversion_rate_type
                ,po_receipt_headers_tb(i).conversion_rate                       -- conversion_rate
                ,po_receipt_headers_tb(i).conversion_rate_date                  -- conversion_rate_date
                ,po_receipt_headers_tb(i).payment_terms_name                    -- payment_terms_name
                ,po_receipt_headers_tb(i).employee_name                         -- employee_name
                ,po_receipt_headers_tb(i).transaction_date                      -- transaction_date
                ,po_receipt_headers_tb(i).customer_account_number               -- customer_account_number
                ,po_receipt_headers_tb(i).customer_party_name                   -- customer_party_name
                ,po_receipt_headers_tb(i).customer_party_number                 -- customer_party_number
                ,po_receipt_headers_tb(i).business_unit                         -- business_unit
                ,po_receipt_headers_tb(i).ra_outsourcer_party_name              -- ra_outsourcer_party_name
                ,po_receipt_headers_tb(i).receipt_advice_number                 -- receipt_advice_number
                ,po_receipt_headers_tb(i).ra_document_code                      -- ra_document_code
                ,po_receipt_headers_tb(i).ra_document_number                    -- ra_document_number
                ,po_receipt_headers_tb(i).ra_doc_revision_number                -- ra_doc_revision_number
                ,po_receipt_headers_tb(i).ra_doc_revision_date                  -- ra_doc_revision_date
                ,po_receipt_headers_tb(i).ra_doc_creation_date                  -- ra_doc_creation_date
                ,po_receipt_headers_tb(i).ra_doc_last_update_date               -- ra_doc_last_update_date
                ,po_receipt_headers_tb(i).ra_outsourcer_contact_name            -- ra_outsourcer_contact_name
                ,po_receipt_headers_tb(i).ra_vendor_site_name                   -- ra_vendor_site_name
                ,po_receipt_headers_tb(i).ra_note_to_receiver                   -- ra_note_to_receiver
                ,po_receipt_headers_tb(i).ra_doo_source_system_name             -- ra_doo_source_system_name
                ,po_receipt_headers_tb(i).attribute_category                    -- attribute_category
                ,po_receipt_headers_tb(i).attribute1                            -- attribute1
                ,po_receipt_headers_tb(i).attribute2                            -- attribute2
                ,po_receipt_headers_tb(i).attribute3                            -- attribute3
                ,po_receipt_headers_tb(i).attribute4                            -- attribute4
                ,po_receipt_headers_tb(i).attribute5                            -- attribute5
                ,po_receipt_headers_tb(i).attribute6                            -- attribute6
                ,po_receipt_headers_tb(i).attribute7                            -- attribute7
                ,po_receipt_headers_tb(i).attribute8                            -- attribute8
                ,po_receipt_headers_tb(i).attribute9                            -- attribute9
                ,po_receipt_headers_tb(i).attribute10                           -- attribute10
                ,po_receipt_headers_tb(i).attribute11                           -- attribute11
                ,po_receipt_headers_tb(i).attribute12                           -- attribute12
                ,po_receipt_headers_tb(i).attribute13                           -- attribute13
                ,po_receipt_headers_tb(i).attribute14                           -- attribute14
                ,po_receipt_headers_tb(i).attribute15                           -- attribute15
                ,po_receipt_headers_tb(i).attribute16                           -- attribute16
                ,po_receipt_headers_tb(i).attribute17                           -- attribute17
                ,po_receipt_headers_tb(i).attribute18                           -- attribute18
                ,po_receipt_headers_tb(i).attribute19                           -- attribute19
                ,po_receipt_headers_tb(i).attribute20                           -- attribute20
                ,po_receipt_headers_tb(i).attribute_number1                     -- attribute_number1
                ,po_receipt_headers_tb(i).attribute_number2                     -- attribute_number2
                ,po_receipt_headers_tb(i).attribute_number3                     -- attribute_number3
                ,po_receipt_headers_tb(i).attribute_number4                     -- attribute_number4
                ,po_receipt_headers_tb(i).attribute_number5                     -- attribute_number5
                ,po_receipt_headers_tb(i).attribute_number6                     -- attribute_number6
                ,po_receipt_headers_tb(i).attribute_number7                     -- attribute_number7
                ,po_receipt_headers_tb(i).attribute_number8                     -- attribute_number8
                ,po_receipt_headers_tb(i).attribute_number9                     -- attribute_number9
                ,po_receipt_headers_tb(i).attribute_number10                    -- attribute_number10
                ,po_receipt_headers_tb(i).attribute_date1                       -- attribute_date1
                ,po_receipt_headers_tb(i).attribute_date2                       -- attribute_date2
                ,po_receipt_headers_tb(i).attribute_date3                       -- attribute_date3
                ,po_receipt_headers_tb(i).attribute_date4                       -- attribute_date4
                ,po_receipt_headers_tb(i).attribute_date5                       -- attribute_date5
                ,po_receipt_headers_tb(i).attribute_timestamp1                  -- attribute_timestamp1
                ,po_receipt_headers_tb(i).attribute_timestamp2                  -- attribute_timestamp2
                ,po_receipt_headers_tb(i).attribute_timestamp3                  -- attribute_timestamp3
                ,po_receipt_headers_tb(i).attribute_timestamp4                  -- attribute_timestamp4
                ,po_receipt_headers_tb(i).attribute_timestamp5                  -- attribute_timestamp5
                ,po_receipt_headers_tb(i).gl_date                               -- gl_date
                ,po_receipt_headers_tb(i).receipt_header_id                     -- receipt_header_id
                ,po_receipt_headers_tb(i).batch_name                            -- batch_name
                ,po_receipt_headers_tb(i).last_update_date                      -- last_update_date
                ,po_receipt_headers_tb(i).last_updated_by                       -- last_updated_by
                ,po_receipt_headers_tb(i).creation_date                         -- creation_date
                ,po_receipt_headers_tb(i).created_by                            -- created_by
                );
            --
        END LOOP;
    END LOOP;
    --
    gv_location := 'After insert into xxmx_po_rcpt_headers_stg';
    --
    COMMIT;
    --
    gv_location := 'xxmx_po_receipts_pkg.stg_po_receipt_headers - Data Insertion in STG Table End';
    --
    CLOSE po_receipt_headers_cur;
    --
    dbms_output.put_line('xxmx_po_receipts_pkg.stg_po_receipt_headers - Data Insertion in STG Table End ');
    --
    EXCEPTION
        WHEN OTHERS
        THEN
            --
            IF po_receipt_headers_cur%ISOPEN
            THEN
                --
                CLOSE po_receipt_headers_cur;
                --
            END IF;
            --
            ROLLBACK;
            --
            dbms_output.put_line('Error in Procedure xxmx_po_receipts_pkg.stg_po_receipt_headers');
            dbms_output.put_line('Error Message :'||SQLERRM);
            dbms_output.put_line('Error text :' ||dbms_utility.format_error_backtrace||CHR(13)||'Location: '||gv_location);
            raise_application_error(-20111, 'Error text :' ||dbms_utility.format_error_backtrace||CHR(13)||'Location: '||gv_location);
            --
  END  stg_po_receipt_headers ;
  --
  -- ----------------------------------------------------------------------------
  -- |-------------------------< STG_PO_RCPT_TRX >------------------------------|
  -- ----------------------------------------------------------------------------
  --
  PROCEDURE stg_po_rcpt_trx
  IS
    -- local CURSOR
    -- Cursor to get all eligible PO Receipt Transaction records to be migrated
    CURSOR po_receipt_trx_cur
    IS
      SELECT interface_line_num
            ,transaction_type
            ,auto_transact_code
            ,transaction_date
            ,source_document_code
            ,receipt_source_code
            ,header_interface_num
            ,parent_transaction_id
            ,parent_intf_line_num
            ,to_organization_code
            ,item_num
            ,item_description
            ,item_revision
            ,document_num
            ,document_line_num
            ,document_shipment_line_num
            ,document_distribution_num
            ,business_unit
            ,shipment_num
            ,expected_receipt_date
            ,subinventory
            ,locator
            ,quantity
            ,unit_of_measure
            ,primary_quantity
            ,primary_unit_of_measure
            ,secondary_quantity
            ,secondary_unit_of_measure
            ,vendor_name
            ,vendor_num
            ,vendor_site_code
            ,customer_party_name
            ,customer_party_number
            ,customer_account_number
            ,ship_to_location_code
            ,location_code
            ,reason_name
            ,deliver_to_person_name
            ,deliver_to_location_code
            ,receipt_exception_flag
            ,routing_header_id
            ,destination_type_code
            ,interface_source_code
            ,interface_source_line_id
            ,amount
            ,currency_code
            ,currency_conversion_type
            ,currency_conversion_rate
            ,currency_conversion_date
            ,inspection_status_code
            ,inspection_quality_code
            ,from_organization_code
            ,from_subinventory
            ,from_locator
            ,freight_carrier_name
            ,bill_of_lading
            ,packing_slip
            ,shipped_date
            ,num_of_containers
            ,waybill_airbill_num
            ,rma_reference
            ,comments
            ,truck_num
            ,container_num
            ,substitute_item_num
            ,notice_unit_price
            ,item_category
            ,intransit_owning_org_code
            ,routing_code
            ,barcode_label
            ,country_of_origin_code
            ,create_debit_memo_flag
            ,license_plate_number
            ,transfer_license_plate_number
            ,lpn_group_num
            ,asn_line_num
            ,employee_name
            ,source_transaction_num
            ,parent_source_transaction_num
            ,parent_interface_txn_id
            ,matching_basis
            ,ra_outsourcer_party_name
            ,ra_document_number
            ,ra_document_line_number
            ,ra_note_to_receiver
            ,ra_vendor_site_name
            ,attribute_category
            ,attribute1
            ,attribute2
            ,attribute3
            ,attribute4
            ,attribute5
            ,attribute6
            ,attribute7
            ,attribute8
            ,attribute9
            ,attribute10
            ,attribute11
            ,attribute12
            ,attribute13
            ,attribute14
            ,attribute15
            ,attribute16
            ,attribute17
            ,attribute18
            ,attribute19
            ,attribute20
            ,attribute_number1
            ,attribute_number2
            ,attribute_number3
            ,attribute_number4
            ,attribute_number5
            ,attribute_number6
            ,attribute_number7
            ,attribute_number8
            ,attribute_number9
            ,attribute_number10
            ,attribute_date1
            ,attribute_date2
            ,attribute_date3
            ,attribute_date4
            ,attribute_date5
            ,attribute_timestamp1
            ,attribute_timestamp2
            ,attribute_timestamp3
            ,attribute_timestamp4
            ,attribute_timestamp5
            ,consigned_flag
            ,soldto_legal_entity
            ,consumed_quantity
            ,default_taxation_country
            ,trx_business_category
            ,document_fiscal_classification
            ,user_defined_fisc_class
            ,product_fisc_class_name
            ,intended_use
            ,product_category
            ,tax_classification_code
            ,product_type
            ,first_pty_number
            ,third_pty_number
            ,tax_invoice_number
            ,tax_invoice_date
            ,final_discharge_loc_code
            ,assessable_value
            ,physical_return_reqd
            ,external_system_packing_unit
            ,eway_bill_number
            ,eway_bill_date
            ,batch_name
            ,last_update_date
            ,last_updated_by
            ,creation_date
            ,created_by
      FROM  (
    SELECT DISTINCT
           rsl.shipment_line_id                                                         AS  INTERFACE_LINE_NUM
         , rt.transaction_type                                                          AS  TRANSACTION_TYPE
         , NULL                                                                         AS  AUTO_TRANSACT_CODE
         , rt.transaction_date                                                          AS  TRANSACTION_DATE
         , rsl.source_document_code                                                     AS  SOURCE_DOCUMENT_CODE
         , rsh.receipt_source_code                                                      AS  RECEIPT_SOURCE_CODE
         , rsh.shipment_header_id                                                       AS  HEADER_INTERFACE_NUM
         , null                                                                         AS  PARENT_TRANSACTION_ID
         , null                                                                         AS  PARENT_INTF_LINE_NUM
         , null                                                                         AS  TO_ORGANIZATION_CODE
         , null                                                                         AS  ITEM_NUM
         , replace(replace(replace(rsl.item_description , chr(13)), chr(10),',') ,'"','')
                                                                                        AS  ITEM_DESCRIPTION
         , null                                                                         AS  ITEM_REVISION
         , pha.segment1                                                                 AS  DOCUMENT_NUM
         , pla.line_num                                                                 AS  DOCUMENT_LINE_NUM
         , pll.shipment_num                                                             AS  DOCUMENT_SHIPMENT_LINE_NUM
         , null                                                                         AS  DOCUMENT_DISTRIBUTION_NUM
         , 'PARATUS AMC'                                                                AS  BUSINESS_UNIT
         , rsh.shipment_num                                                             AS  SHIPMENT_NUM
         , rsh.expected_receipt_date                                                    AS  EXPECTED_RECEIPT_DATE
         , rt.subinventory                                                              AS  SUBINVENTORY
         , null                                                                         AS  LOCATOR
         , rt.quantity - NVL(
                                (SELECT   SUM(ABS(rt1.quantity))
                                 FROM     apps.rcv_transactions@MXDM_NVIS_EXTRACT rt1
                                 WHERE    rt1.transaction_type = 'RETURN TO VENDOR'
                                      AND rt1.parent_transaction_id = rt.transaction_id)
                            , 0)
                       + NVL(
                                (SELECT   SUM(rt1.quantity)
                                 FROM     apps.rcv_transactions@MXDM_NVIS_EXTRACT rt1
                                 WHERE    rt1.transaction_type  = 'CORRECT'
                                      AND rt1.parent_transaction_id = rt.transaction_id)
                            , 0)
					   - NVL(rt.quantity_billed, 0)
                                                                                        AS  QUANTITY
         , rt.unit_of_measure                                                           AS  UNIT_OF_MEASURE
         , null                                                                         AS  PRIMARY_QUANTITY
         , null                                                                         AS  PRIMARY_UNIT_OF_MEASURE
         , null                                                                         AS  SECONDARY_QUANTITY
         , null                                                                         AS  SECONDARY_UNIT_OF_MEASURE
         , pv.vendor_name                                                               AS  VENDOR_NAME
         , pv.segment1                                                                  AS  VENDOR_NUM
         , pvs.vendor_site_code                                                         AS  VENDOR_SITE_CODE
         , null                                                                         AS  CUSTOMER_PARTY_NAME
         , null                                                                         AS  CUSTOMER_PARTY_NUMBER
         , null                                                                         AS  CUSTOMER_ACCOUNT_NUMBER
         , null                                                                         AS  SHIP_TO_LOCATION_CODE
         , null                                                                         AS  LOCATION_CODE
         , null                                                                         AS  REASON_NAME
         , null                                                                         AS  DELIVER_TO_PERSON_NAME
         , null                                                                         AS  DELIVER_TO_LOCATION_CODE
         , null                                                                         AS  RECEIPT_EXCEPTION_FLAG
         , rsl.routing_header_id                                                        AS  ROUTING_HEADER_ID
         , rsl.destination_type_code                                                    AS  DESTINATION_TYPE_CODE
         , null                                                                         AS  INTERFACE_SOURCE_CODE
         , null                                                                         AS  INTERFACE_SOURCE_LINE_ID
         , rt.amount   - NVL(
                                (SELECT   SUM(ABS(rt1.amount))
                                 FROM     apps.rcv_transactions@MXDM_NVIS_EXTRACT rt1
                                 WHERE    rt1.transaction_type = 'RETURN TO VENDOR'
                                      AND rt1.parent_transaction_id = rt.transaction_id)
                            , 0)
                       + NVL(
                                (SELECT   SUM(rt1.amount)
                                 FROM     apps.rcv_transactions@MXDM_NVIS_EXTRACT rt1
                                 WHERE    rt1.transaction_type  = 'CORRECT'
                                      AND rt1.parent_transaction_id = rt.transaction_id)
                            , 0)
					   - NVL(rt.amount_billed, 0)							
		                                                                                AS  AMOUNT
         , rsh.currency_code                                                            AS  CURRENCY_CODE
         , 'User'                                                                       AS  CURRENCY_CONVERSION_TYPE
         , rsh.conversion_rate                                                          AS  CURRENCY_CONVERSION_RATE
         , rsh.conversion_date                                                          AS  CURRENCY_CONVERSION_DATE
         , rt.inspection_status_code                                                    AS  INSPECTION_STATUS_CODE
         , rt.inspection_quality_code                                                   AS  INSPECTION_QUALITY_CODE
         , null                                                                         AS  FROM_ORGANIZATION_CODE
         , null                                                                         AS  FROM_SUBINVENTORY
         , null                                                                         AS  FROM_LOCATOR
         , rsh.freight_carrier_code                                                     AS  FREIGHT_CARRIER_NAME
         , rsh.bill_of_lading                                                           AS  BILL_OF_LADING
         , rsl.packing_slip                                                             AS  PACKING_SLIP
         , rsh.shipped_date                                                             AS  SHIPPED_DATE
         , rsh.num_of_containers                                                        AS  NUM_OF_CONTAINERS
         , rsh.waybill_airbill_num                                                      AS  WAYBILL_AIRBILL_NUM
         , rt.rma_reference                                                             AS  RMA_REFERENCE
         , replace(replace(replace(replace(rsl.comments , chr(13)), chr(10),',') ,'"',''),'   ','')
                                                                                        AS  COMMENTS
         , rsl.truck_num                                                                AS  TRUCK_NUM
         , rsl.container_num                                                            AS  CONTAINER_NUM
         , null                                                                         AS  SUBSTITUTE_ITEM_NUM
         , rsl.notice_unit_price                                                        AS  NOTICE_UNIT_PRICE
         , null                                                                         AS  ITEM_CATEGORY
         , null                                                                         AS  INTRANSIT_OWNING_ORG_CODE
         , null                                                                         AS  ROUTING_CODE
         , null                                                                         AS  BARCODE_LABEL
         , rsl.country_of_origin_code                                                   AS  COUNTRY_OF_ORIGIN_CODE
         , null                                                                         AS  CREATE_DEBIT_MEMO_FLAG
         , null                                                                         AS  LICENSE_PLATE_NUMBER
         , null                                                                         AS  TRANSFER_LICENSE_PLATE_NUMBER
         , null                                                                         AS  LPN_GROUP_NUM
         , null                                                                         AS  ASN_LINE_NUM
         , null                                                                         AS  EMPLOYEE_NAME
         , rt.source_transaction_num                                                    AS  SOURCE_TRANSACTION_NUM
         , null                                                                         AS  PARENT_SOURCE_TRANSACTION_NUM
         , null                                                                         AS  PARENT_INTERFACE_TXN_ID
         , null                                                                         AS  MATCHING_BASIS
         , null                                                                         AS  RA_OUTSOURCER_PARTY_NAME
         , null                                                                         AS  RA_DOCUMENT_NUMBER
         , null                                                                         AS  RA_DOCUMENT_LINE_NUMBER
         , null                                                                         AS  RA_NOTE_TO_RECEIVER
         , null                                                                         AS  RA_VENDOR_SITE_NAME
         /*
         , rsl.attribute_category                                                       AS  ATTRIBUTE_CATEGORY
         , rsl.attribute1                                                               AS  ATTRIBUTE1
         , rsl.attribute2                                                               AS  ATTRIBUTE2
         , rsl.attribute3                                                               AS  ATTRIBUTE3
         , rsl.attribute4                                                               AS  ATTRIBUTE4
         , rsl.attribute5                                                               AS  ATTRIBUTE5
         , rsl.attribute6                                                               AS  ATTRIBUTE6
         , rsl.attribute7                                                               AS  ATTRIBUTE7
         , rsl.attribute8                                                               AS  ATTRIBUTE8
         , rsl.attribute9                                                               AS  ATTRIBUTE9
         , rsl.attribute10                                                              AS  ATTRIBUTE10
         , rsl.attribute11                                                              AS  ATTRIBUTE11
         , rsl.attribute12                                                              AS  ATTRIBUTE12
         , rsl.attribute13                                                              AS  ATTRIBUTE13
         , rsl.attribute14                                                              AS  ATTRIBUTE14
         , rsl.attribute15                                                              AS  ATTRIBUTE15
         */
         , NULL                                                                         AS  ATTRIBUTE_CATEGORY
         , NULL                                                                         AS  ATTRIBUTE1
         , NULL                                                                         AS  ATTRIBUTE2
         , NULL                                                                         AS  ATTRIBUTE3
         , NULL                                                                         AS  ATTRIBUTE4
         , NULL                                                                         AS  ATTRIBUTE5
         , NULL                                                                         AS  ATTRIBUTE6
         , NULL                                                                         AS  ATTRIBUTE7
         , NULL                                                                         AS  ATTRIBUTE8
         , NULL                                                                         AS  ATTRIBUTE9
         , NULL                                                                         AS  ATTRIBUTE10
         , NULL                                                                         AS  ATTRIBUTE11
         , NULL                                                                         AS  ATTRIBUTE12
         , NULL                                                                         AS  ATTRIBUTE13
         , NULL                                                                         AS  ATTRIBUTE14
         , NULL                                                                         AS  ATTRIBUTE15
         , NULL                                                                         AS  ATTRIBUTE16
         , NULL                                                                         AS  ATTRIBUTE17
         , NULL                                                                         AS  ATTRIBUTE18
         , NULL                                                                         AS  ATTRIBUTE19
         , NULL                                                                         AS  ATTRIBUTE20
         , NULL                                                                         AS  ATTRIBUTE_NUMBER1
         , NULL                                                                         AS  ATTRIBUTE_NUMBER2
         , NULL                                                                         AS  ATTRIBUTE_NUMBER3
         , NULL                                                                         AS  ATTRIBUTE_NUMBER4
         , NULL                                                                         AS  ATTRIBUTE_NUMBER5
         , NULL                                                                         AS  ATTRIBUTE_NUMBER6
         , NULL                                                                         AS  ATTRIBUTE_NUMBER7
         , NULL                                                                         AS  ATTRIBUTE_NUMBER8
         , NULL                                                                         AS  ATTRIBUTE_NUMBER9
         , NULL                                                                         AS  ATTRIBUTE_NUMBER10
         , NULL                                                                         AS  ATTRIBUTE_DATE1
         , NULL                                                                         AS  ATTRIBUTE_DATE2
         , NULL                                                                         AS  ATTRIBUTE_DATE3
         , NULL                                                                         AS  ATTRIBUTE_DATE4
         , NULL                                                                         AS  ATTRIBUTE_DATE5
         , NULL                                                                         AS  ATTRIBUTE_TIMESTAMP1
         , NULL                                                                         AS  ATTRIBUTE_TIMESTAMP2
         , NULL                                                                         AS  ATTRIBUTE_TIMESTAMP3
         , NULL                                                                         AS  ATTRIBUTE_TIMESTAMP4
         , NULL                                                                         AS  ATTRIBUTE_TIMESTAMP5
         , rt.consigned_flag                                                            AS  CONSIGNED_FLAG
         , NULL                                                                         AS  SOLDTO_LEGAL_ENTITY
         , NULL                                                                         AS  CONSUMED_QUANTITY
         , NULL                                                                         AS  DEFAULT_TAXATION_COUNTRY
         , NULL                                                                         AS  TRX_BUSINESS_CATEGORY
         , NULL                                                                         AS  DOCUMENT_FISCAL_CLASSIFICATION
         , NULL                                                                         AS  USER_DEFINED_FISC_CLASS
         , NULL                                                                         AS  PRODUCT_FISC_CLASS_NAME
         , NULL                                                                         AS  INTENDED_USE
         , NULL                                                                         AS  PRODUCT_CATEGORY
         , NULL                                                                         AS  TAX_CLASSIFICATION_CODE
         , NULL                                                                         AS  PRODUCT_TYPE
         , NULL                                                                         AS  FIRST_PTY_NUMBER
         , NULL                                                                         AS  THIRD_PTY_NUMBER
         , NULL                                                                         AS  TAX_INVOICE_NUMBER
         , NULL                                                                         AS  TAX_INVOICE_DATE
         , NULL                                                                         AS  FINAL_DISCHARGE_LOC_CODE
         , NULL                                                                         AS  ASSESSABLE_VALUE
         , NULL                                                                         AS  PHYSICAL_RETURN_REQD
         , NULL                                                                         AS  EXTERNAL_SYSTEM_PACKING_UNIT
         , NULL                                                                         AS  EWAY_BILL_NUMBER
         , NULL                                                                         AS  EWAY_BILL_DATE
         , g_batch_name                                                                 AS  BATCH_NAME
         , TRUNC(SYSDATE)                                                               AS  CREATION_DATE
         , 'XXMX_CORE'                                                                  AS  CREATED_BY
         , TRUNC(SYSDATE)                                                               AS  LAST_UPDATE_DATE
         , 'XXMX_CORE'                                                                  AS  LAST_UPDATED_BY
      from apps.rcv_shipment_headers@MXDM_NVIS_EXTRACT rsh
          ,apps.rcv_shipment_lines@MXDM_NVIS_EXTRACT rsl
          ,apps.po_headers_all@MXDM_NVIS_EXTRACT pha
          ,apps.po_lines_all@MXDM_NVIS_EXTRACT pla
          ,apps.po_line_locations_all@MXDM_NVIS_EXTRACT pll
          ,apps.po_vendors@MXDM_NVIS_EXTRACT pv
          ,apps.po_vendor_sites_all@MXDM_NVIS_EXTRACT pvs
          ,apps.rcv_transactions@MXDM_NVIS_EXTRACT rt
     WHERE rsl.shipment_header_id               = rsh.shipment_header_id
     AND   rsl.shipment_header_id               = rt.shipment_header_id
     AND   rsl.shipment_line_id                 = rt.shipment_line_id
     AND   rt.transaction_type                  = 'RECEIVE'
     AND   rsh.vendor_id                        = pv.vendor_id
     AND   rsh.vendor_site_id                   = pvs.vendor_site_id
     AND   pv.vendor_id                         = pvs.vendor_id
     AND   rsl.po_header_id                     = pha.po_header_id
     AND   rsl.po_line_id                       = pla.po_line_id
     AND   rsl.po_line_location_id              = pll.line_location_id
     AND   EXISTS  (SELECT 1
                      FROM xxmx_po_open_quantity_mv po_v
                     WHERE    1 = 1
                          AND po_v.po_header_id = rsl.po_header_id
                          AND po_v.po_line_id = rsl.po_line_id
                          AND po_v.line_location_id = rsl.po_line_location_id
                          AND po_v.po_distribution_id = NVL(rsl.po_distribution_id , po_v.po_distribution_id)
                          AND po_v.open_po > 0
                          AND po_v.received > 0
                          AND po_v.billed >= 0
                          AND (po_v.received - po_v.billed) > 0
						  AND (NVL(rt.amount_billed, 0) != NVL(rt.amount, 0) OR NVL(rt.quantity_billed, 0) != NVL(rt.quantity, 0)))

      )
    WHERE  1 = 1
	AND    (NVL(amount, 0) > 0 OR NVL(quantity, 0) > 0);
    --
    -- local type variables
    --
    TYPE po_receipt_trx_tbl IS TABLE OF po_receipt_trx_cur%ROWTYPE INDEX BY BINARY_INTEGER;
    po_receipt_trx_tb po_receipt_trx_tbl;
--
BEGIN
    gv_location := NULL;
    --
    dbms_output.put_line('xxmx_po_receipts_pkg.stg_po_rcpt_trx - Data Insertion in STG Table Start ');
    gv_location := 'xxmx_po_receipts_pkg.stg_po_rcpt_trx - Data Insertion in STG Table Start';
    --
    OPEN po_receipt_trx_cur;
    --
    gv_location := 'Cursor Open po_receipt_trx_cur';
    --
    LOOP
    --
        gv_location := 'Inside the Cursor loop';
        --
        FETCH   po_receipt_trx_cur
        BULK
        COLLECT
        INTO    po_receipt_trx_tb
        LIMIT   5000;
        --
        gv_location := 'Cursor po_receipt_trx_cur Fetch into po_receipt_trx_tb';
        --
        EXIT WHEN po_receipt_trx_tb.COUNT=0;
        --
        FOR i IN 1..po_receipt_trx_tb.COUNT
        LOOP
            INSERT
            INTO xxmx_po_rcpt_trx_stg (
                     interface_line_num
                    ,transaction_type
                    ,auto_transact_code
                    ,transaction_date
                    ,source_document_code
                    ,receipt_source_code
                    ,header_interface_num
                    ,parent_transaction_id
                    ,parent_intf_line_num
                    ,to_organization_code
                    ,item_num
                    ,item_description
                    ,item_revision
                    ,document_num
                    ,document_line_num
                    ,document_shipment_line_num
                    ,document_distribution_num
                    ,business_unit
                    ,shipment_num
                    ,expected_receipt_date
                    ,subinventory
                    ,locator
                    ,quantity
                    ,unit_of_measure
                    ,primary_quantity
                    ,primary_unit_of_measure
                    ,secondary_quantity
                    ,secondary_unit_of_measure
                    ,vendor_name
                    ,vendor_num
                    ,vendor_site_code
                    ,customer_party_name
                    ,customer_party_number
                    ,customer_account_number
                    ,ship_to_location_code
                    ,location_code
                    ,reason_name
                    ,deliver_to_person_name
                    ,deliver_to_location_code
                    ,receipt_exception_flag
                    ,routing_header_id
                    ,destination_type_code
                    ,interface_source_code
                    ,interface_source_line_id
                    ,amount
                    ,currency_code
                    ,currency_conversion_type
                    ,currency_conversion_rate
                    ,currency_conversion_date
                    ,inspection_status_code
                    ,inspection_quality_code
                    ,from_organization_code
                    ,from_subinventory
                    ,from_locator
                    ,freight_carrier_name
                    ,bill_of_lading
                    ,packing_slip
                    ,shipped_date
                    ,num_of_containers
                    ,waybill_airbill_num
                    ,rma_reference
                    ,comments
                    ,truck_num
                    ,container_num
                    ,substitute_item_num
                    ,notice_unit_price
                    ,item_category
                    ,intransit_owning_org_code
                    ,routing_code
                    ,barcode_label
                    ,country_of_origin_code
                    ,create_debit_memo_flag
                    ,license_plate_number
                    ,transfer_license_plate_number
                    ,lpn_group_num
                    ,asn_line_num
                    ,employee_name
                    ,source_transaction_num
                    ,parent_source_transaction_num
                    ,parent_interface_txn_id
                    ,matching_basis
                    ,ra_outsourcer_party_name
                    ,ra_document_number
                    ,ra_document_line_number
                    ,ra_note_to_receiver
                    ,ra_vendor_site_name
                    ,attribute_category
                    ,attribute1
                    ,attribute2
                    ,attribute3
                    ,attribute4
                    ,attribute5
                    ,attribute6
                    ,attribute7
                    ,attribute8
                    ,attribute9
                    ,attribute10
                    ,attribute11
                    ,attribute12
                    ,attribute13
                    ,attribute14
                    ,attribute15
                    ,attribute16
                    ,attribute17
                    ,attribute18
                    ,attribute19
                    ,attribute20
                    ,attribute_number1
                    ,attribute_number2
                    ,attribute_number3
                    ,attribute_number4
                    ,attribute_number5
                    ,attribute_number6
                    ,attribute_number7
                    ,attribute_number8
                    ,attribute_number9
                    ,attribute_number10
                    ,attribute_date1
                    ,attribute_date2
                    ,attribute_date3
                    ,attribute_date4
                    ,attribute_date5
                    ,attribute_timestamp1
                    ,attribute_timestamp2
                    ,attribute_timestamp3
                    ,attribute_timestamp4
                    ,attribute_timestamp5
                    ,consigned_flag
                    ,soldto_legal_entity
                    ,consumed_quantity
                    ,default_taxation_country
                    ,trx_business_category
                    ,document_fiscal_classification
                    ,user_defined_fisc_class
                    ,product_fisc_class_name
                    ,intended_use
                    ,product_category
                    ,tax_classification_code
                    ,product_type
                    ,first_pty_number
                    ,third_pty_number
                    ,tax_invoice_number
                    ,tax_invoice_date
                    ,final_discharge_loc_code
                    ,assessable_value
                    ,physical_return_reqd
                    ,external_system_packing_unit
                    ,eway_bill_number
                    ,eway_bill_date
                    ,batch_name
                    ,last_update_date
                    ,last_updated_by
                    ,creation_date
                    ,created_by)
                VALUES (
                     po_receipt_trx_tb(i).interface_line_num                    --interface_line_num
                    ,po_receipt_trx_tb(i).transaction_type                      --transaction_type
                    ,po_receipt_trx_tb(i).auto_transact_code                    --auto_transact_code
                    ,po_receipt_trx_tb(i).transaction_date                      --transaction_date
                    ,po_receipt_trx_tb(i).source_document_code                  --source_document_code
                    ,po_receipt_trx_tb(i).receipt_source_code                   --receipt_source_code
                    ,po_receipt_trx_tb(i).header_interface_num                  --header_interface_num
                    ,po_receipt_trx_tb(i).parent_transaction_id                 --parent_transaction_id
                    ,po_receipt_trx_tb(i).parent_intf_line_num                  --parent_intf_line_num
                    ,po_receipt_trx_tb(i).to_organization_code                  --to_organization_code
                    ,po_receipt_trx_tb(i).item_num                              --item_num
                    ,po_receipt_trx_tb(i).item_description                      --item_description
                    ,po_receipt_trx_tb(i).item_revision                         --item_revision
                    ,po_receipt_trx_tb(i).document_num                          --document_num
                    ,po_receipt_trx_tb(i).document_line_num                     --document_line_num
                    ,po_receipt_trx_tb(i).document_shipment_line_num            --document_shipment_line_num
                    ,po_receipt_trx_tb(i).document_distribution_num             --document_distribution_num
                    ,po_receipt_trx_tb(i).business_unit                         --business_unit
                    ,po_receipt_trx_tb(i).shipment_num                          --shipment_num
                    ,po_receipt_trx_tb(i).expected_receipt_date                 --expected_receipt_date
                    ,po_receipt_trx_tb(i).subinventory                          --subinventory
                    ,po_receipt_trx_tb(i).locator                               --locator
                    ,po_receipt_trx_tb(i).quantity                              --quantity
                    ,po_receipt_trx_tb(i).unit_of_measure                       --unit_of_measure
                    ,po_receipt_trx_tb(i).primary_quantity                      --primary_quantity
                    ,po_receipt_trx_tb(i).primary_unit_of_measure               --primary_unit_of_measure
                    ,po_receipt_trx_tb(i).secondary_quantity                    --secondary_quantity
                    ,po_receipt_trx_tb(i).secondary_unit_of_measure             --secondary_unit_of_measure
                    ,po_receipt_trx_tb(i).vendor_name                           --vendor_name
                    ,po_receipt_trx_tb(i).vendor_num                            --vendor_num
                    ,po_receipt_trx_tb(i).vendor_site_code                      --vendor_site_code
                    ,po_receipt_trx_tb(i).customer_party_name                   --customer_party_name
                    ,po_receipt_trx_tb(i).customer_party_number                 --customer_party_number
                    ,po_receipt_trx_tb(i).customer_account_number               --customer_account_number
                    ,po_receipt_trx_tb(i).ship_to_location_code                 --ship_to_location_code
                    ,po_receipt_trx_tb(i).location_code                         --location_code
                    ,po_receipt_trx_tb(i).reason_name                           --reason_name
                    ,po_receipt_trx_tb(i).deliver_to_person_name                --deliver_to_person_name
                    ,po_receipt_trx_tb(i).deliver_to_location_code              --deliver_to_location_code
                    ,po_receipt_trx_tb(i).receipt_exception_flag                --receipt_exception_flag
                    ,po_receipt_trx_tb(i).routing_header_id                     --routing_header_id
                    ,po_receipt_trx_tb(i).destination_type_code                 --destination_type_code
                    ,po_receipt_trx_tb(i).interface_source_code                 --interface_source_code
                    ,po_receipt_trx_tb(i).interface_source_line_id              --interface_source_line_id
                    ,po_receipt_trx_tb(i).amount                                --amount
                    ,po_receipt_trx_tb(i).currency_code                         --currency_code
                    ,po_receipt_trx_tb(i).currency_conversion_type              --currency_conversion_type
                    ,po_receipt_trx_tb(i).currency_conversion_rate              --currency_conversion_rate
                    ,po_receipt_trx_tb(i).currency_conversion_date              --currency_conversion_date
                    ,po_receipt_trx_tb(i).inspection_status_code                --inspection_status_code
                    ,po_receipt_trx_tb(i).inspection_quality_code               --inspection_quality_code
                    ,po_receipt_trx_tb(i).from_organization_code                --from_organization_code
                    ,po_receipt_trx_tb(i).from_subinventory                     --from_subinventory
                    ,po_receipt_trx_tb(i).from_locator                          --from_locator
                    ,po_receipt_trx_tb(i).freight_carrier_name                  --freight_carrier_name
                    ,po_receipt_trx_tb(i).bill_of_lading                        --bill_of_lading
                    ,po_receipt_trx_tb(i).packing_slip                          --packing_slip
                    ,po_receipt_trx_tb(i).shipped_date                          --shipped_date
                    ,po_receipt_trx_tb(i).num_of_containers                     --num_of_containers
                    ,po_receipt_trx_tb(i).waybill_airbill_num                   --waybill_airbill_num
                    ,po_receipt_trx_tb(i).rma_reference                         --rma_reference
                    ,po_receipt_trx_tb(i).comments                              --comments
                    ,po_receipt_trx_tb(i).truck_num                             --truck_num
                    ,po_receipt_trx_tb(i).container_num                         --container_num
                    ,po_receipt_trx_tb(i).substitute_item_num                   --substitute_item_num
                    ,po_receipt_trx_tb(i).notice_unit_price                     --notice_unit_price
                    ,po_receipt_trx_tb(i).item_category                         --item_category
                    ,po_receipt_trx_tb(i).intransit_owning_org_code             --intransit_owning_org_code
                    ,po_receipt_trx_tb(i).routing_code                          --routing_code
                    ,po_receipt_trx_tb(i).barcode_label                         --barcode_label
                    ,po_receipt_trx_tb(i).country_of_origin_code                --country_of_origin_code
                    ,po_receipt_trx_tb(i).create_debit_memo_flag                --create_debit_memo_flag
                    ,po_receipt_trx_tb(i).license_plate_number                  --license_plate_number
                    ,po_receipt_trx_tb(i).transfer_license_plate_number         --transfer_license_plate_number
                    ,po_receipt_trx_tb(i).lpn_group_num                         --lpn_group_num
                    ,po_receipt_trx_tb(i).asn_line_num                          --asn_line_num
                    ,po_receipt_trx_tb(i).employee_name                         --employee_name
                    ,po_receipt_trx_tb(i).source_transaction_num                --source_transaction_num
                    ,po_receipt_trx_tb(i).parent_source_transaction_num         --parent_source_transaction_num
                    ,po_receipt_trx_tb(i).parent_interface_txn_id               --parent_interface_txn_id
                    ,po_receipt_trx_tb(i).matching_basis                        --matching_basis
                    ,po_receipt_trx_tb(i).ra_outsourcer_party_name              --ra_outsourcer_party_name
                    ,po_receipt_trx_tb(i).ra_document_number                    --ra_document_number
                    ,po_receipt_trx_tb(i).ra_document_line_number               --ra_document_line_number
                    ,po_receipt_trx_tb(i).ra_note_to_receiver                   --ra_note_to_receiver
                    ,po_receipt_trx_tb(i).ra_vendor_site_name                   --ra_vendor_site_name
                    ,po_receipt_trx_tb(i).attribute_category                    --attribute_category
                    ,po_receipt_trx_tb(i).attribute1                            --attribute1
                    ,po_receipt_trx_tb(i).attribute2                            --attribute2
                    ,po_receipt_trx_tb(i).attribute3                            --attribute3
                    ,po_receipt_trx_tb(i).attribute4                            --attribute4
                    ,po_receipt_trx_tb(i).attribute5                            --attribute5
                    ,po_receipt_trx_tb(i).attribute6                            --attribute6
                    ,po_receipt_trx_tb(i).attribute7                            --attribute7
                    ,po_receipt_trx_tb(i).attribute8                            --attribute8
                    ,po_receipt_trx_tb(i).attribute9                            --attribute9
                    ,po_receipt_trx_tb(i).attribute10                           --attribute10
                    ,po_receipt_trx_tb(i).attribute11                           --attribute11
                    ,po_receipt_trx_tb(i).attribute12                           --attribute12
                    ,po_receipt_trx_tb(i).attribute13                           --attribute13
                    ,po_receipt_trx_tb(i).attribute14                           --attribute14
                    ,po_receipt_trx_tb(i).attribute15                           --attribute15
                    ,po_receipt_trx_tb(i).attribute16                           --attribute16
                    ,po_receipt_trx_tb(i).attribute17                           --attribute17
                    ,po_receipt_trx_tb(i).attribute18                           --attribute18
                    ,po_receipt_trx_tb(i).attribute19                           --attribute19
                    ,po_receipt_trx_tb(i).attribute20                           --attribute20
                    ,po_receipt_trx_tb(i).attribute_number1                     --attribute_number1
                    ,po_receipt_trx_tb(i).attribute_number2                     --attribute_number2
                    ,po_receipt_trx_tb(i).attribute_number3                     --attribute_number3
                    ,po_receipt_trx_tb(i).attribute_number4                     --attribute_number4
                    ,po_receipt_trx_tb(i).attribute_number5                     --attribute_number5
                    ,po_receipt_trx_tb(i).attribute_number6                     --attribute_number6
                    ,po_receipt_trx_tb(i).attribute_number7                     --attribute_number7
                    ,po_receipt_trx_tb(i).attribute_number8                     --attribute_number8
                    ,po_receipt_trx_tb(i).attribute_number9                     --attribute_number9
                    ,po_receipt_trx_tb(i).attribute_number10                    --attribute_number10
                    ,po_receipt_trx_tb(i).attribute_date1                       --attribute_date1
                    ,po_receipt_trx_tb(i).attribute_date2                       --attribute_date2
                    ,po_receipt_trx_tb(i).attribute_date3                       --attribute_date3
                    ,po_receipt_trx_tb(i).attribute_date4                       --attribute_date4
                    ,po_receipt_trx_tb(i).attribute_date5                       --attribute_date5
                    ,po_receipt_trx_tb(i).attribute_timestamp1                  --attribute_timestamp1
                    ,po_receipt_trx_tb(i).attribute_timestamp2                  --attribute_timestamp2
                    ,po_receipt_trx_tb(i).attribute_timestamp3                  --attribute_timestamp3
                    ,po_receipt_trx_tb(i).attribute_timestamp4                  --attribute_timestamp4
                    ,po_receipt_trx_tb(i).attribute_timestamp5                  --attribute_timestamp5
                    ,po_receipt_trx_tb(i).consigned_flag                        --consigned_flag
                    ,po_receipt_trx_tb(i).soldto_legal_entity                   --soldto_legal_entity
                    ,po_receipt_trx_tb(i).consumed_quantity                     --consumed_quantity
                    ,po_receipt_trx_tb(i).default_taxation_country              --default_taxation_country
                    ,po_receipt_trx_tb(i).trx_business_category                 --trx_business_category
                    ,po_receipt_trx_tb(i).document_fiscal_classification        --document_fiscal_classification
                    ,po_receipt_trx_tb(i).user_defined_fisc_class               --user_defined_fisc_class
                    ,po_receipt_trx_tb(i).product_fisc_class_name               --product_fisc_class_name
                    ,po_receipt_trx_tb(i).intended_use                          --intended_use
                    ,po_receipt_trx_tb(i).product_category                      --product_category
                    ,po_receipt_trx_tb(i).tax_classification_code               --tax_classification_code
                    ,po_receipt_trx_tb(i).product_type                          --product_type
                    ,po_receipt_trx_tb(i).first_pty_number                      --first_pty_number
                    ,po_receipt_trx_tb(i).third_pty_number                      --third_pty_number
                    ,po_receipt_trx_tb(i).tax_invoice_number                    --tax_invoice_number
                    ,po_receipt_trx_tb(i).tax_invoice_date                      --tax_invoice_date
                    ,po_receipt_trx_tb(i).final_discharge_loc_code              --final_discharge_loc_code
                    ,po_receipt_trx_tb(i).assessable_value                      --assessable_value
                    ,po_receipt_trx_tb(i).physical_return_reqd                  --physical_return_reqd
                    ,po_receipt_trx_tb(i).external_system_packing_unit          --external_system_packing_unit
                    ,po_receipt_trx_tb(i).eway_bill_number                      --eway_bill_number
                    ,po_receipt_trx_tb(i).eway_bill_date                        --eway_bill_date
                    ,po_receipt_trx_tb(i).batch_name                            --batch_name
                    ,po_receipt_trx_tb(i).last_update_date                      --last_update_date
                    ,po_receipt_trx_tb(i).last_updated_by                       --last_updated_by
                    ,po_receipt_trx_tb(i).creation_date                         --creation_date
                    ,po_receipt_trx_tb(i).created_by                            --created_by
                    );
            --
        END LOOP;
      --
    END LOOP;
    --
    gv_location := 'After insert into xxmx_po_rcpt_trx_stg';
    --
    COMMIT;
    --
    gv_location := 'xxmx_po_receipts_pkg.stg_po_rcpt_trx - Data Insertion in STG Table End';
    --
    CLOSE po_receipt_trx_cur;
    --
    dbms_output.put_line('xxmx_po_receipts_pkg.stg_po_rcpt_trx - Data Insertion in STG Table End ');
    --
    EXCEPTION
        WHEN OTHERS
        THEN
            --
            IF po_receipt_trx_cur%ISOPEN
            THEN
                --
                CLOSE po_receipt_trx_cur;
                --
            END IF;
            --
            ROLLBACK;
            --
            dbms_output.put_line('Error in Procedure xxmx_po_receipts_pkg.stg_po_rcpt_trx');
            dbms_output.put_line('Error Message :'||SQLERRM);
            dbms_output.put_line('Error text :' ||dbms_utility.format_error_backtrace||CHR(13)||'Location: '||gv_location);
            raise_application_error(-20111, 'Error text :' ||dbms_utility.format_error_backtrace||CHR(13)||'Location: '||gv_location);
            --
  END  stg_po_rcpt_trx ;
  --
  -- ----------------------------------------------------------------------------
  -- |--------------------< XFM_PO_RECEIPT_HEADERS >---------------------------|
  -- ----------------------------------------------------------------------------
  --
  PROCEDURE xfm_po_receipt_headers
  IS
    -- local CURSOR
    -- Cursor to get all eligible PO Receipt Header records to be migrated
    CURSOR po_receipt_headers_cur
    IS
      SELECT
             header_interface_number
            ,receipt_source_code
            ,asn_type
            ,transaction_type
            ,notice_creation_date
            ,shipment_num
            ,receipt_num
            ,vendor_name
            ,vendor_num
            ,vendor_site_code
            ,from_organization_code
            ,ship_to_organization_code
            ,location_code
            ,bill_of_lading
            ,packing_slip
            ,shipped_date
            ,freight_carrier_name
            ,expected_receipt_date
            ,num_of_containers
            ,waybill_airbill_num
            ,comments
            ,gross_weight
            ,gross_weight_unit_of_measure
            ,net_weight
            ,net_weight_unit_of_measure
            ,tar_weight
            ,tar_weight_unit_of_measure
            ,packaging_code
            ,carrier_method
            ,carrier_equipment
            ,special_handling_code
            ,hazard_code
            ,hazard_class
            ,hazard_description
            ,freight_terms
            ,freight_bill_number
            ,invoice_num
            ,invoice_date
            ,total_invoice_amount
            ,tax_name
            ,tax_amount
            ,freight_amount
            ,currency_code
            ,conversion_rate_type
            ,conversion_rate
            ,conversion_rate_date
            ,payment_terms_name
            ,employee_name
            ,transaction_date
            ,customer_account_number
            ,customer_party_name
            ,customer_party_number
            ,business_unit
            ,ra_outsourcer_party_name
            ,receipt_advice_number
            ,ra_document_code
            ,ra_document_number
            ,ra_doc_revision_number
            ,ra_doc_revision_date
            ,ra_doc_creation_date
            ,ra_doc_last_update_date
            ,ra_outsourcer_contact_name
            ,ra_vendor_site_name
            ,ra_note_to_receiver
            ,ra_doo_source_system_name
            ,attribute_category
            ,attribute1
            ,attribute2
            ,attribute3
            ,attribute4
            ,attribute5
            ,attribute6
            ,attribute7
            ,attribute8
            ,attribute9
            ,attribute10
            ,attribute11
            ,attribute12
            ,attribute13
            ,attribute14
            ,attribute15
            ,attribute16
            ,attribute17
            ,attribute18
            ,attribute19
            ,attribute20
            ,attribute_number1
            ,attribute_number2
            ,attribute_number3
            ,attribute_number4
            ,attribute_number5
            ,attribute_number6
            ,attribute_number7
            ,attribute_number8
            ,attribute_number9
            ,attribute_number10
            ,attribute_date1
            ,attribute_date2
            ,attribute_date3
            ,attribute_date4
            ,attribute_date5
            ,attribute_timestamp1
            ,attribute_timestamp2
            ,attribute_timestamp3
            ,attribute_timestamp4
            ,attribute_timestamp5
            ,gl_date
            ,receipt_header_id
            ,batch_name
            ,last_update_date
            ,last_updated_by
            ,creation_date
            ,created_by
      FROM  xxmx_po_rcpt_headers_stg
      WHERE  1                          = 1
      AND    batch_name                 = g_batch_name;
--
-- local type variables
--
    TYPE po_receipt_headers_tbl IS TABLE OF po_receipt_headers_cur%ROWTYPE INDEX BY BINARY_INTEGER;
    po_receipt_headers_tb po_receipt_headers_tbl;
--
BEGIN
    gv_location := NULL;
    --
    dbms_output.put_line('xxmx_po_receipts_pkg.xfm_po_receipt_headers - Data Insertion in XFM Table Start ');
    gv_location := 'xxmx_po_receipts_pkg.xfm_po_receipt_headers - Data Insertion in XFM Table Start';
    --
    OPEN po_receipt_headers_cur;
    --
    gv_location := 'Cursor Open po_receipt_headers_cur';
    --
    LOOP
        --
        gv_location := 'Inside the Cursor loop';
        --
        FETCH po_receipt_headers_cur
        BULK
        COLLECT
        INTO po_receipt_headers_tb
        LIMIT 5000;
        --
        gv_location := 'Cursor po_receipt_headers_cur Fetch into po_receipt_headers_tb';
        --
        EXIT WHEN po_receipt_headers_tb.COUNT=0;
        --
        FOR i IN 1..po_receipt_headers_tb.COUNT
        LOOP
        --
            INSERT
            INTO xxmx_po_rcpt_headers_xfm(
                 header_interface_number
                ,receipt_source_code
                ,asn_type
                ,transaction_type
                ,notice_creation_date
                ,shipment_num
                ,receipt_num
                ,vendor_name
                ,vendor_num
                ,vendor_site_code
                ,from_organization_code
                ,ship_to_organization_code
                ,location_code
                ,bill_of_lading
                ,packing_slip
                ,shipped_date
                ,freight_carrier_name
                ,expected_receipt_date
                ,num_of_containers
                ,waybill_airbill_num
                ,comments
                ,gross_weight
                ,gross_weight_unit_of_measure
                ,net_weight
                ,net_weight_unit_of_measure
                ,tar_weight
                ,tar_weight_unit_of_measure
                ,packaging_code
                ,carrier_method
                ,carrier_equipment
                ,special_handling_code
                ,hazard_code
                ,hazard_class
                ,hazard_description
                ,freight_terms
                ,freight_bill_number
                ,invoice_num
                ,invoice_date
                ,total_invoice_amount
                ,tax_name
                ,tax_amount
                ,freight_amount
                ,currency_code
                ,conversion_rate_type
                ,conversion_rate
                ,conversion_rate_date
                ,payment_terms_name
                ,employee_name
                ,transaction_date
                ,customer_account_number
                ,customer_party_name
                ,customer_party_number
                ,business_unit
                ,ra_outsourcer_party_name
                ,receipt_advice_number
                ,ra_document_code
                ,ra_document_number
                ,ra_doc_revision_number
                ,ra_doc_revision_date
                ,ra_doc_creation_date
                ,ra_doc_last_update_date
                ,ra_outsourcer_contact_name
                ,ra_vendor_site_name
                ,ra_note_to_receiver
                ,ra_doo_source_system_name
                ,attribute_category
                ,attribute1
                ,attribute2
                ,attribute3
                ,attribute4
                ,attribute5
                ,attribute6
                ,attribute7
                ,attribute8
                ,attribute9
                ,attribute10
                ,attribute11
                ,attribute12
                ,attribute13
                ,attribute14
                ,attribute15
                ,attribute16
                ,attribute17
                ,attribute18
                ,attribute19
                ,attribute20
                ,attribute_number1
                ,attribute_number2
                ,attribute_number3
                ,attribute_number4
                ,attribute_number5
                ,attribute_number6
                ,attribute_number7
                ,attribute_number8
                ,attribute_number9
                ,attribute_number10
                ,attribute_date1
                ,attribute_date2
                ,attribute_date3
                ,attribute_date4
                ,attribute_date5
                ,attribute_timestamp1
                ,attribute_timestamp2
                ,attribute_timestamp3
                ,attribute_timestamp4
                ,attribute_timestamp5
                ,gl_date
                ,receipt_header_id
                ,batch_name
                ,last_update_date
                ,last_updated_by
                ,creation_date
                ,created_by)
            VALUES(
                 po_receipt_headers_tb(i).header_interface_number             --header_interface_number
                ,po_receipt_headers_tb(i).receipt_source_code                 --receipt_source_code
                ,po_receipt_headers_tb(i).asn_type                            --asn_type
                ,po_receipt_headers_tb(i).transaction_type                    --transaction_type
                ,po_receipt_headers_tb(i).notice_creation_date                --notice_creation_date
                ,po_receipt_headers_tb(i).shipment_num                        --shipment_num
                ,po_receipt_headers_tb(i).receipt_num                         --receipt_num
                ,po_receipt_headers_tb(i).vendor_name                         --vendor_name
                ,po_receipt_headers_tb(i).vendor_num                          --vendor_num
                ,po_receipt_headers_tb(i).vendor_site_code                    --vendor_site_code
                ,po_receipt_headers_tb(i).from_organization_code              --from_organization_code
                ,po_receipt_headers_tb(i).ship_to_organization_code           --ship_to_organization_code
                ,po_receipt_headers_tb(i).location_code                       --location_code
                ,po_receipt_headers_tb(i).bill_of_lading                      --bill_of_lading
                ,po_receipt_headers_tb(i).packing_slip                        --packing_slip
                ,po_receipt_headers_tb(i).shipped_date                        --shipped_date
                ,po_receipt_headers_tb(i).freight_carrier_name                --freight_carrier_name
                ,po_receipt_headers_tb(i).expected_receipt_date               --expected_receipt_date
                ,po_receipt_headers_tb(i).num_of_containers                   --num_of_containers
                ,po_receipt_headers_tb(i).waybill_airbill_num                 --waybill_airbill_num
                ,po_receipt_headers_tb(i).comments                            --comments
                ,po_receipt_headers_tb(i).gross_weight                        --gross_weight
                ,po_receipt_headers_tb(i).gross_weight_unit_of_measure        --gross_weight_unit_of_measure
                ,po_receipt_headers_tb(i).net_weight                          --net_weight
                ,po_receipt_headers_tb(i).net_weight_unit_of_measure          --net_weight_unit_of_measure
                ,po_receipt_headers_tb(i).tar_weight                          --tar_weight
                ,po_receipt_headers_tb(i).tar_weight_unit_of_measure          --tar_weight_unit_of_measure
                ,po_receipt_headers_tb(i).packaging_code                      --packaging_code
                ,po_receipt_headers_tb(i).carrier_method                      --carrier_method
                ,po_receipt_headers_tb(i).carrier_equipment                   --carrier_equipment
                ,po_receipt_headers_tb(i).special_handling_code               --special_handling_code
                ,po_receipt_headers_tb(i).hazard_code                         --hazard_code
                ,po_receipt_headers_tb(i).hazard_class                        --hazard_class
                ,po_receipt_headers_tb(i).hazard_description                  --hazard_description
                ,po_receipt_headers_tb(i).freight_terms                       --freight_terms
                ,po_receipt_headers_tb(i).freight_bill_number                 --freight_bill_number
                ,po_receipt_headers_tb(i).invoice_num                         --invoice_num
                ,po_receipt_headers_tb(i).invoice_date                        --invoice_date
                ,po_receipt_headers_tb(i).total_invoice_amount                --total_invoice_amount
                ,po_receipt_headers_tb(i).tax_name                            --tax_name
                ,po_receipt_headers_tb(i).tax_amount                          --tax_amount
                ,po_receipt_headers_tb(i).freight_amount                      --freight_amount
                ,po_receipt_headers_tb(i).currency_code                       --currency_code
                ,po_receipt_headers_tb(i).conversion_rate_type                --conversion_rate_type
                ,po_receipt_headers_tb(i).conversion_rate                     --conversion_rate
                ,po_receipt_headers_tb(i).conversion_rate_date                --conversion_rate_date
                ,po_receipt_headers_tb(i).payment_terms_name                  --payment_terms_name
                ,po_receipt_headers_tb(i).employee_name                       --employee_name
                ,po_receipt_headers_tb(i).transaction_date                    --transaction_date
                ,po_receipt_headers_tb(i).customer_account_number             --customer_account_number
                ,po_receipt_headers_tb(i).customer_party_name                 --customer_party_name
                ,po_receipt_headers_tb(i).customer_party_number               --customer_party_number
                ,po_receipt_headers_tb(i).business_unit                       --business_unit
                ,po_receipt_headers_tb(i).ra_outsourcer_party_name            --ra_outsourcer_party_name
                ,po_receipt_headers_tb(i).receipt_advice_number               --receipt_advice_number
                ,po_receipt_headers_tb(i).ra_document_code                    --ra_document_code
                ,po_receipt_headers_tb(i).ra_document_number                  --ra_document_number
                ,po_receipt_headers_tb(i).ra_doc_revision_number              --ra_doc_revision_number
                ,po_receipt_headers_tb(i).ra_doc_revision_date                --ra_doc_revision_date
                ,po_receipt_headers_tb(i).ra_doc_creation_date                --ra_doc_creation_date
                ,po_receipt_headers_tb(i).ra_doc_last_update_date             --ra_doc_last_update_date
                ,po_receipt_headers_tb(i).ra_outsourcer_contact_name          --ra_outsourcer_contact_name
                ,po_receipt_headers_tb(i).ra_vendor_site_name                 --ra_vendor_site_name
                ,po_receipt_headers_tb(i).ra_note_to_receiver                 --ra_note_to_receiver
                ,po_receipt_headers_tb(i).ra_doo_source_system_name           --ra_doo_source_system_name
                ,po_receipt_headers_tb(i).attribute_category                  --attribute_category
                ,po_receipt_headers_tb(i).attribute1                          --attribute1
                ,po_receipt_headers_tb(i).attribute2                          --attribute2
                ,po_receipt_headers_tb(i).attribute3                          --attribute3
                ,po_receipt_headers_tb(i).attribute4                          --attribute4
                ,po_receipt_headers_tb(i).attribute5                          --attribute5
                ,po_receipt_headers_tb(i).attribute6                          --attribute6
                ,po_receipt_headers_tb(i).attribute7                          --attribute7
                ,po_receipt_headers_tb(i).attribute8                          --attribute8
                ,po_receipt_headers_tb(i).attribute9                          --attribute9
                ,po_receipt_headers_tb(i).attribute10                         --attribute10
                ,po_receipt_headers_tb(i).attribute11                         --attribute11
                ,po_receipt_headers_tb(i).attribute12                         --attribute12
                ,po_receipt_headers_tb(i).attribute13                         --attribute13
                ,po_receipt_headers_tb(i).attribute14                         --attribute14
                ,po_receipt_headers_tb(i).attribute15                         --attribute15
                ,po_receipt_headers_tb(i).attribute16                         --attribute16
                ,po_receipt_headers_tb(i).attribute17                         --attribute17
                ,po_receipt_headers_tb(i).attribute18                         --attribute18
                ,po_receipt_headers_tb(i).attribute19                         --attribute19
                ,po_receipt_headers_tb(i).attribute20                         --attribute20
                ,po_receipt_headers_tb(i).attribute_number1                   --attribute_number1
                ,po_receipt_headers_tb(i).attribute_number2                   --attribute_number2
                ,po_receipt_headers_tb(i).attribute_number3                   --attribute_number3
                ,po_receipt_headers_tb(i).attribute_number4                   --attribute_number4
                ,po_receipt_headers_tb(i).attribute_number5                   --attribute_number5
                ,po_receipt_headers_tb(i).attribute_number6                   --attribute_number6
                ,po_receipt_headers_tb(i).attribute_number7                   --attribute_number7
                ,po_receipt_headers_tb(i).attribute_number8                   --attribute_number8
                ,po_receipt_headers_tb(i).attribute_number9                   --attribute_number9
                ,po_receipt_headers_tb(i).attribute_number10                  --attribute_number10
                ,po_receipt_headers_tb(i).attribute_date1                     --attribute_date1
                ,po_receipt_headers_tb(i).attribute_date2                     --attribute_date2
                ,po_receipt_headers_tb(i).attribute_date3                     --attribute_date3
                ,po_receipt_headers_tb(i).attribute_date4                     --attribute_date4
                ,po_receipt_headers_tb(i).attribute_date5                     --attribute_date5
                ,po_receipt_headers_tb(i).attribute_timestamp1                --attribute_timestamp1
                ,po_receipt_headers_tb(i).attribute_timestamp2                --attribute_timestamp2
                ,po_receipt_headers_tb(i).attribute_timestamp3                --attribute_timestamp3
                ,po_receipt_headers_tb(i).attribute_timestamp4                --attribute_timestamp4
                ,po_receipt_headers_tb(i).attribute_timestamp5                --attribute_timestamp5
                ,po_receipt_headers_tb(i).gl_date                             --gl_date
                ,po_receipt_headers_tb(i).receipt_header_id                   --receipt_header_id
                ,po_receipt_headers_tb(i).batch_name                          --batch_name
                ,po_receipt_headers_tb(i).last_update_date                    --last_update_date
                ,po_receipt_headers_tb(i).last_updated_by                     --last_updated_by
                ,po_receipt_headers_tb(i).creation_date                       --creation_date
                ,po_receipt_headers_tb(i).created_by                          --created_by
                );
        END LOOP;
      --
    END LOOP;
    --
    gv_location := 'After insert into xxmx_po_rcpt_headers_xfm';
    --
    COMMIT;
    --
    gv_location := 'xxmx_po_receipts_pkg.xfm_po_receipt_headers - Data Insertion in XFM Table End';
    --
    CLOSE po_receipt_headers_cur;
    --
    dbms_output.put_line('xxmx_po_receipts_pkg.xfm_po_receipt_headers - Data Insertion in XFM Table End ');
    --
    EXCEPTION
        WHEN OTHERS
        THEN
            --
            IF po_receipt_headers_cur%ISOPEN
            THEN
                --
                CLOSE po_receipt_headers_cur;
                --
            END IF;
            --
            ROLLBACK;
            --
            dbms_output.put_line('Error in Procedure xxmx_po_receipts_pkg.xfm_po_receipt_headers');
            dbms_output.put_line('Error Message :'||SQLERRM);
            dbms_output.put_line('Error text :' ||dbms_utility.format_error_backtrace||CHR(13)||'Location: '||gv_location);
            raise_application_error(-20111, 'Error text :' ||dbms_utility.format_error_backtrace||CHR(13)||'Location: '||gv_location);
            --
  END  xfm_po_receipt_headers ;
  --
  -- ----------------------------------------------------------------------------
  -- |------------------------< XFM_PO_RCPT_TRX >------------------------------|
  -- ----------------------------------------------------------------------------
  --
  PROCEDURE xfm_po_rcpt_trx
  IS
    -- local CURSOR
    -- Cursor to get all eligible PO Line records to be migrated
    CURSOR po_receipt_trx_cur
    IS
      SELECT
             interface_line_num
            ,transaction_type
            ,auto_transact_code
            ,transaction_date
            ,source_document_code
            ,receipt_source_code
            ,header_interface_num
            ,parent_transaction_id
            ,parent_intf_line_num
            ,to_organization_code
            ,item_num
            ,item_description
            ,item_revision
            ,document_num
            ,document_line_num
            ,document_shipment_line_num
            ,document_distribution_num
            ,business_unit
            ,shipment_num
            ,expected_receipt_date
            ,subinventory
            ,locator
            ,quantity
            ,unit_of_measure
            ,primary_quantity
            ,primary_unit_of_measure
            ,secondary_quantity
            ,secondary_unit_of_measure
            ,vendor_name
            ,vendor_num
            ,vendor_site_code
            ,customer_party_name
            ,customer_party_number
            ,customer_account_number
            ,ship_to_location_code
            ,location_code
            ,reason_name
            ,deliver_to_person_name
            ,deliver_to_location_code
            ,receipt_exception_flag
            ,routing_header_id
            ,destination_type_code
            ,interface_source_code
            ,interface_source_line_id
            ,amount
            ,currency_code
            ,currency_conversion_type
            ,currency_conversion_rate
            ,currency_conversion_date
            ,inspection_status_code
            ,inspection_quality_code
            ,from_organization_code
            ,from_subinventory
            ,from_locator
            ,freight_carrier_name
            ,bill_of_lading
            ,packing_slip
            ,shipped_date
            ,num_of_containers
            ,waybill_airbill_num
            ,rma_reference
            ,comments
            ,truck_num
            ,container_num
            ,substitute_item_num
            ,notice_unit_price
            ,item_category
            ,intransit_owning_org_code
            ,routing_code
            ,barcode_label
            ,country_of_origin_code
            ,create_debit_memo_flag
            ,license_plate_number
            ,transfer_license_plate_number
            ,lpn_group_num
            ,asn_line_num
            ,employee_name
            ,source_transaction_num
            ,parent_source_transaction_num
            ,parent_interface_txn_id
            ,matching_basis
            ,ra_outsourcer_party_name
            ,ra_document_number
            ,ra_document_line_number
            ,ra_note_to_receiver
            ,ra_vendor_site_name
            ,attribute_category
            ,attribute1
            ,attribute2
            ,attribute3
            ,attribute4
            ,attribute5
            ,attribute6
            ,attribute7
            ,attribute8
            ,attribute9
            ,attribute10
            ,attribute11
            ,attribute12
            ,attribute13
            ,attribute14
            ,attribute15
            ,attribute16
            ,attribute17
            ,attribute18
            ,attribute19
            ,attribute20
            ,attribute_number1
            ,attribute_number2
            ,attribute_number3
            ,attribute_number4
            ,attribute_number5
            ,attribute_number6
            ,attribute_number7
            ,attribute_number8
            ,attribute_number9
            ,attribute_number10
            ,attribute_date1
            ,attribute_date2
            ,attribute_date3
            ,attribute_date4
            ,attribute_date5
            ,attribute_timestamp1
            ,attribute_timestamp2
            ,attribute_timestamp3
            ,attribute_timestamp4
            ,attribute_timestamp5
            ,consigned_flag
            ,soldto_legal_entity
            ,consumed_quantity
            ,default_taxation_country
            ,trx_business_category
            ,document_fiscal_classification
            ,user_defined_fisc_class
            ,product_fisc_class_name
            ,intended_use
            ,product_category
            ,tax_classification_code
            ,product_type
            ,first_pty_number
            ,third_pty_number
            ,tax_invoice_number
            ,tax_invoice_date
            ,final_discharge_loc_code
            ,assessable_value
            ,physical_return_reqd
            ,external_system_packing_unit
            ,eway_bill_number
            ,eway_bill_date
            ,batch_name
            ,last_update_date
            ,last_updated_by
            ,creation_date
            ,created_by
      FROM   xxmx_po_rcpt_trx_stg
      WHERE  1                          = 1
      AND    batch_name                 = g_batch_name
      order by  document_num, document_line_num;
--
-- local type variables
--
    TYPE po_receipt_trx_tbl IS TABLE OF po_receipt_trx_cur%ROWTYPE INDEX BY BINARY_INTEGER;
    po_receipt_trx_tb po_receipt_trx_tbl;
--
BEGIN
    gv_location := NULL;
    --
    dbms_output.put_line('xxmx_po_receipts_pkg.xfm_po_rcpt_trx - Data Insertion in XFM Table Start ');
    gv_location := 'xxmx_po_receipts_pkg.xfm_po_rcpt_trx - Data Insertion in XFM Table Start';
    --
    OPEN po_receipt_trx_cur;
    --
    gv_location := 'Cursor Open po_receipt_trx_cur';
    --
    LOOP
    --
    gv_location := 'Inside the Cursor loop';
    --
    FETCH po_receipt_trx_cur
    BULK
    COLLECT
    INTO po_receipt_trx_tb
    LIMIT 5000;
    --
    gv_location := 'Cursor po_receipt_trx_cur Fetch into po_receipt_trx_tb';
    --
    EXIT WHEN po_receipt_trx_tb.COUNT=0;
    --
    FOR i IN 1..po_receipt_trx_tb.COUNT
    LOOP
    --
        INSERT
        INTO xxmx_po_rcpt_trx_xfm (
               interface_line_num
              ,transaction_type
              ,auto_transact_code
              ,transaction_date
              ,source_document_code
              ,receipt_source_code
              ,header_interface_num
              ,parent_transaction_id
              ,parent_intf_line_num
              ,to_organization_code
              ,item_num
              ,item_description
              ,item_revision
              ,document_num
              ,document_line_num
              ,document_shipment_line_num
              ,document_distribution_num
              ,business_unit
              ,shipment_num
              ,expected_receipt_date
              ,subinventory
              ,locator
              ,quantity
              ,unit_of_measure
              ,primary_quantity
              ,primary_unit_of_measure
              ,secondary_quantity
              ,secondary_unit_of_measure
              ,vendor_name
              ,vendor_num
              ,vendor_site_code
              ,customer_party_name
              ,customer_party_number
              ,customer_account_number
              ,ship_to_location_code
              ,location_code
              ,reason_name
              ,deliver_to_person_name
              ,deliver_to_location_code
              ,receipt_exception_flag
              ,routing_header_id
              ,destination_type_code
              ,interface_source_code
              ,interface_source_line_id
              ,amount
              ,currency_code
              ,currency_conversion_type
              ,currency_conversion_rate
              ,currency_conversion_date
              ,inspection_status_code
              ,inspection_quality_code
              ,from_organization_code
              ,from_subinventory
              ,from_locator
              ,freight_carrier_name
              ,bill_of_lading
              ,packing_slip
              ,shipped_date
              ,num_of_containers
              ,waybill_airbill_num
              ,rma_reference
              ,comments
              ,truck_num
              ,container_num
              ,substitute_item_num
              ,notice_unit_price
              ,item_category
              ,intransit_owning_org_code
              ,routing_code
              ,barcode_label
              ,country_of_origin_code
              ,create_debit_memo_flag
              ,license_plate_number
              ,transfer_license_plate_number
              ,lpn_group_num
              ,asn_line_num
              ,employee_name
              ,source_transaction_num
              ,parent_source_transaction_num
              ,parent_interface_txn_id
              ,matching_basis
              ,ra_outsourcer_party_name
              ,ra_document_number
              ,ra_document_line_number
              ,ra_note_to_receiver
              ,ra_vendor_site_name
              ,attribute_category
              ,attribute1
              ,attribute2
              ,attribute3
              ,attribute4
              ,attribute5
              ,attribute6
              ,attribute7
              ,attribute8
              ,attribute9
              ,attribute10
              ,attribute11
              ,attribute12
              ,attribute13
              ,attribute14
              ,attribute15
              ,attribute16
              ,attribute17
              ,attribute18
              ,attribute19
              ,attribute20
              ,attribute_number1
              ,attribute_number2
              ,attribute_number3
              ,attribute_number4
              ,attribute_number5
              ,attribute_number6
              ,attribute_number7
              ,attribute_number8
              ,attribute_number9
              ,attribute_number10
              ,attribute_date1
              ,attribute_date2
              ,attribute_date3
              ,attribute_date4
              ,attribute_date5
              ,attribute_timestamp1
              ,attribute_timestamp2
              ,attribute_timestamp3
              ,attribute_timestamp4
              ,attribute_timestamp5
              ,consigned_flag
              ,soldto_legal_entity
              ,consumed_quantity
              ,default_taxation_country
              ,trx_business_category
              ,document_fiscal_classification
              ,user_defined_fisc_class
              ,product_fisc_class_name
              ,intended_use
              ,product_category
              ,tax_classification_code
              ,product_type
              ,first_pty_number
              ,third_pty_number
              ,tax_invoice_number
              ,tax_invoice_date
              ,final_discharge_loc_code
              ,assessable_value
              ,physical_return_reqd
              ,external_system_packing_unit
              ,eway_bill_number
              ,eway_bill_date
              ,batch_name
              ,last_update_date
              ,last_updated_by
              ,creation_date
              ,created_by)
            VALUES(
               po_receipt_trx_tb(i).interface_line_num                    --interface_line_num
              ,po_receipt_trx_tb(i).transaction_type                      --transaction_type
              ,po_receipt_trx_tb(i).auto_transact_code                    --auto_transact_code
              ,po_receipt_trx_tb(i).transaction_date                      --transaction_date
              ,po_receipt_trx_tb(i).source_document_code                  --source_document_code
              ,po_receipt_trx_tb(i).receipt_source_code                   --receipt_source_code
              ,po_receipt_trx_tb(i).header_interface_num                  --header_interface_num
              ,po_receipt_trx_tb(i).parent_transaction_id                 --parent_transaction_id
              ,po_receipt_trx_tb(i).parent_intf_line_num                  --parent_intf_line_num
              ,po_receipt_trx_tb(i).to_organization_code                  --to_organization_code
              ,po_receipt_trx_tb(i).item_num                              --item_num
              ,po_receipt_trx_tb(i).item_description                      --item_description
              ,po_receipt_trx_tb(i).item_revision                         --item_revision
              ,po_receipt_trx_tb(i).document_num                          --document_num
              ,po_receipt_trx_tb(i).document_line_num                     --document_line_num
              ,po_receipt_trx_tb(i).document_shipment_line_num            --document_shipment_line_num
              ,po_receipt_trx_tb(i).document_distribution_num             --document_distribution_num
              ,po_receipt_trx_tb(i).business_unit                         --business_unit
              ,po_receipt_trx_tb(i).shipment_num                          --shipment_num
              ,po_receipt_trx_tb(i).expected_receipt_date                 --expected_receipt_date
              ,po_receipt_trx_tb(i).subinventory                          --subinventory
              ,po_receipt_trx_tb(i).locator                               --locator
              ,po_receipt_trx_tb(i).quantity                              --quantity
              ,po_receipt_trx_tb(i).unit_of_measure                       --unit_of_measure
              ,po_receipt_trx_tb(i).primary_quantity                      --primary_quantity
              ,po_receipt_trx_tb(i).primary_unit_of_measure               --primary_unit_of_measure
              ,po_receipt_trx_tb(i).secondary_quantity                    --secondary_quantity
              ,po_receipt_trx_tb(i).secondary_unit_of_measure             --secondary_unit_of_measure
              ,po_receipt_trx_tb(i).vendor_name                           --vendor_name
              ,po_receipt_trx_tb(i).vendor_num                            --vendor_num
              ,po_receipt_trx_tb(i).vendor_site_code                      --vendor_site_code
              ,po_receipt_trx_tb(i).customer_party_name                   --customer_party_name
              ,po_receipt_trx_tb(i).customer_party_number                 --customer_party_number
              ,po_receipt_trx_tb(i).customer_account_number               --customer_account_number
              ,po_receipt_trx_tb(i).ship_to_location_code                 --ship_to_location_code
              ,po_receipt_trx_tb(i).location_code                         --location_code
              ,po_receipt_trx_tb(i).reason_name                           --reason_name
              ,po_receipt_trx_tb(i).deliver_to_person_name                --deliver_to_person_name
              ,po_receipt_trx_tb(i).deliver_to_location_code              --deliver_to_location_code
              ,po_receipt_trx_tb(i).receipt_exception_flag                --receipt_exception_flag
              ,po_receipt_trx_tb(i).routing_header_id                     --routing_header_id
              ,po_receipt_trx_tb(i).destination_type_code                 --destination_type_code
              ,po_receipt_trx_tb(i).interface_source_code                 --interface_source_code
              ,po_receipt_trx_tb(i).interface_source_line_id              --interface_source_line_id
              ,po_receipt_trx_tb(i).amount                                --amount
              ,po_receipt_trx_tb(i).currency_code                         --currency_code
              ,po_receipt_trx_tb(i).currency_conversion_type              --currency_conversion_type
              ,po_receipt_trx_tb(i).currency_conversion_rate              --currency_conversion_rate
              ,po_receipt_trx_tb(i).currency_conversion_date              --currency_conversion_date
              ,po_receipt_trx_tb(i).inspection_status_code                --inspection_status_code
              ,po_receipt_trx_tb(i).inspection_quality_code               --inspection_quality_code
              ,po_receipt_trx_tb(i).from_organization_code                --from_organization_code
              ,po_receipt_trx_tb(i).from_subinventory                     --from_subinventory
              ,po_receipt_trx_tb(i).from_locator                          --from_locator
              ,po_receipt_trx_tb(i).freight_carrier_name                  --freight_carrier_name
              ,po_receipt_trx_tb(i).bill_of_lading                        --bill_of_lading
              ,po_receipt_trx_tb(i).packing_slip                          --packing_slip
              ,po_receipt_trx_tb(i).shipped_date                          --shipped_date
              ,po_receipt_trx_tb(i).num_of_containers                     --num_of_containers
              ,po_receipt_trx_tb(i).waybill_airbill_num                   --waybill_airbill_num
              ,po_receipt_trx_tb(i).rma_reference                         --rma_reference
              ,po_receipt_trx_tb(i).comments                              --comments
              ,po_receipt_trx_tb(i).truck_num                             --truck_num
              ,po_receipt_trx_tb(i).container_num                         --container_num
              ,po_receipt_trx_tb(i).substitute_item_num                   --substitute_item_num
              ,po_receipt_trx_tb(i).notice_unit_price                     --notice_unit_price
              ,po_receipt_trx_tb(i).item_category                         --item_category
              ,po_receipt_trx_tb(i).intransit_owning_org_code             --intransit_owning_org_code
              ,po_receipt_trx_tb(i).routing_code                          --routing_code
              ,po_receipt_trx_tb(i).barcode_label                         --barcode_label
              ,po_receipt_trx_tb(i).country_of_origin_code                --country_of_origin_code
              ,po_receipt_trx_tb(i).create_debit_memo_flag                --create_debit_memo_flag
              ,po_receipt_trx_tb(i).license_plate_number                  --license_plate_number
              ,po_receipt_trx_tb(i).transfer_license_plate_number         --transfer_license_plate_number
              ,po_receipt_trx_tb(i).lpn_group_num                         --lpn_group_num
              ,po_receipt_trx_tb(i).asn_line_num                          --asn_line_num
              ,po_receipt_trx_tb(i).employee_name                         --employee_name
              ,po_receipt_trx_tb(i).source_transaction_num                --source_transaction_num
              ,po_receipt_trx_tb(i).parent_source_transaction_num         --parent_source_transaction_num
              ,po_receipt_trx_tb(i).parent_interface_txn_id               --parent_interface_txn_id
              ,po_receipt_trx_tb(i).matching_basis                        --matching_basis
              ,po_receipt_trx_tb(i).ra_outsourcer_party_name              --ra_outsourcer_party_name
              ,po_receipt_trx_tb(i).ra_document_number                    --ra_document_number
              ,po_receipt_trx_tb(i).ra_document_line_number               --ra_document_line_number
              ,po_receipt_trx_tb(i).ra_note_to_receiver                   --ra_note_to_receiver
              ,po_receipt_trx_tb(i).ra_vendor_site_name                   --ra_vendor_site_name
              ,po_receipt_trx_tb(i).attribute_category                    --attribute_category
              ,po_receipt_trx_tb(i).attribute1                            --attribute1
              ,po_receipt_trx_tb(i).attribute2                            --attribute2
              ,po_receipt_trx_tb(i).attribute3                            --attribute3
              ,po_receipt_trx_tb(i).attribute4                            --attribute4
              ,po_receipt_trx_tb(i).attribute5                            --attribute5
              ,po_receipt_trx_tb(i).attribute6                            --attribute6
              ,po_receipt_trx_tb(i).attribute7                            --attribute7
              ,po_receipt_trx_tb(i).attribute8                            --attribute8
              ,po_receipt_trx_tb(i).attribute9                            --attribute9
              ,po_receipt_trx_tb(i).attribute10                           --attribute10
              ,po_receipt_trx_tb(i).attribute11                           --attribute11
              ,po_receipt_trx_tb(i).attribute12                           --attribute12
              ,po_receipt_trx_tb(i).attribute13                           --attribute13
              ,po_receipt_trx_tb(i).attribute14                           --attribute14
              ,po_receipt_trx_tb(i).attribute15                           --attribute15
              ,po_receipt_trx_tb(i).attribute16                           --attribute16
              ,po_receipt_trx_tb(i).attribute17                           --attribute17
              ,po_receipt_trx_tb(i).attribute18                           --attribute18
              ,po_receipt_trx_tb(i).attribute19                           --attribute19
              ,po_receipt_trx_tb(i).attribute20                           --attribute20
              ,po_receipt_trx_tb(i).attribute_number1                     --attribute_number1
              ,po_receipt_trx_tb(i).attribute_number2                     --attribute_number2
              ,po_receipt_trx_tb(i).attribute_number3                     --attribute_number3
              ,po_receipt_trx_tb(i).attribute_number4                     --attribute_number4
              ,po_receipt_trx_tb(i).attribute_number5                     --attribute_number5
              ,po_receipt_trx_tb(i).attribute_number6                     --attribute_number6
              ,po_receipt_trx_tb(i).attribute_number7                     --attribute_number7
              ,po_receipt_trx_tb(i).attribute_number8                     --attribute_number8
              ,po_receipt_trx_tb(i).attribute_number9                     --attribute_number9
              ,po_receipt_trx_tb(i).attribute_number10                    --attribute_number10
              ,po_receipt_trx_tb(i).attribute_date1                       --attribute_date1
              ,po_receipt_trx_tb(i).attribute_date2                       --attribute_date2
              ,po_receipt_trx_tb(i).attribute_date3                       --attribute_date3
              ,po_receipt_trx_tb(i).attribute_date4                       --attribute_date4
              ,po_receipt_trx_tb(i).attribute_date5                       --attribute_date5
              ,po_receipt_trx_tb(i).attribute_timestamp1                  --attribute_timestamp1
              ,po_receipt_trx_tb(i).attribute_timestamp2                  --attribute_timestamp2
              ,po_receipt_trx_tb(i).attribute_timestamp3                  --attribute_timestamp3
              ,po_receipt_trx_tb(i).attribute_timestamp4                  --attribute_timestamp4
              ,po_receipt_trx_tb(i).attribute_timestamp5                  --attribute_timestamp5
              ,po_receipt_trx_tb(i).consigned_flag                        --consigned_flag
              ,po_receipt_trx_tb(i).soldto_legal_entity                   --soldto_legal_entity
              ,po_receipt_trx_tb(i).consumed_quantity                     --consumed_quantity
              ,po_receipt_trx_tb(i).default_taxation_country              --default_taxation_country
              ,po_receipt_trx_tb(i).trx_business_category                 --trx_business_category
              ,po_receipt_trx_tb(i).document_fiscal_classification        --document_fiscal_classification
              ,po_receipt_trx_tb(i).user_defined_fisc_class               --user_defined_fisc_class
              ,po_receipt_trx_tb(i).product_fisc_class_name               --product_fisc_class_name
              ,po_receipt_trx_tb(i).intended_use                          --intended_use
              ,po_receipt_trx_tb(i).product_category                      --product_category
              ,po_receipt_trx_tb(i).tax_classification_code               --tax_classification_code
              ,po_receipt_trx_tb(i).product_type                          --product_type
              ,po_receipt_trx_tb(i).first_pty_number                      --first_pty_number
              ,po_receipt_trx_tb(i).third_pty_number                      --third_pty_number
              ,po_receipt_trx_tb(i).tax_invoice_number                    --tax_invoice_number
              ,po_receipt_trx_tb(i).tax_invoice_date                      --tax_invoice_date
              ,po_receipt_trx_tb(i).final_discharge_loc_code              --final_discharge_loc_code
              ,po_receipt_trx_tb(i).assessable_value                      --assessable_value
              ,po_receipt_trx_tb(i).physical_return_reqd                  --physical_return_reqd
              ,po_receipt_trx_tb(i).external_system_packing_unit          --external_system_packing_unit
              ,po_receipt_trx_tb(i).eway_bill_number                      --eway_bill_number
              ,po_receipt_trx_tb(i).eway_bill_date                        --eway_bill_date
              ,po_receipt_trx_tb(i).batch_name                            --batch_name
              ,po_receipt_trx_tb(i).last_update_date                      --last_update_date
              ,po_receipt_trx_tb(i).last_updated_by                       --last_updated_by
              ,po_receipt_trx_tb(i).creation_date                         --creation_date
              ,po_receipt_trx_tb(i).created_by                            --created_by
              );
        END LOOP;
      --
      END LOOP;
      --
      gv_location := 'After insert into xxmx_po_rcpt_trx_xfm';
      --
      COMMIT;
      --
      gv_location := 'xxmx_po_receipts_pkg.xfm_po_rcpt_trx - Data Insertion in XFM Table End';
      --
    CLOSE po_receipt_trx_cur;
    --
    dbms_output.put_line('xxmx_po_receipts_pkg.xfm_po_rcpt_trx - Data Insertion in XFM Table End ');
    --
    EXCEPTION
        WHEN OTHERS
        THEN
            --
            IF po_receipt_trx_cur%ISOPEN
            THEN
                --
                CLOSE po_receipt_trx_cur;
                --
            END IF;
            --
            ROLLBACK;
            --
            dbms_output.put_line('Error in Procedure xxmx_po_receipts_pkg.xfm_po_rcpt_trx');
            dbms_output.put_line('Error Message :'||SQLERRM);
            dbms_output.put_line('Error text :' ||dbms_utility.format_error_backtrace||CHR(13)||'Location: '||gv_location);
            raise_application_error(-20111, 'Error text :' ||dbms_utility.format_error_backtrace||CHR(13)||'Location: '||gv_location);
            --
  END  xfm_po_rcpt_trx ;
  --
  -- ----------------------------------------------------------------------------
  -- |---------------------< GEN_PO_RECEIPT_HEADERS >---------------------------|
  -- ----------------------------------------------------------------------------
  PROCEDURE gen_po_receipt_headers  IS
  --
  -- local CURSOR
    CURSOR po_receipt_headers_cur
    IS
      SELECT
              '"'||  header_interface_number                      ||'"'||','
            ||'"'||  receipt_source_code                          ||'"'||','
            ||'"'||  asn_type                                     ||'"'||','
            ||'"'||  transaction_type                             ||'"'||','
            ||'"'||  notice_creation_date                         ||'"'||','
            ||'"'||  shipment_num                                 ||'"'||','
            ||'"'||  receipt_num                                  ||'"'||','
            ||'"'||  vendor_name                                  ||'"'||','
            ||'"'||  vendor_num                                   ||'"'||','
            ||'"'||  vendor_site_code                             ||'"'||','
            ||'"'||  from_organization_code                       ||'"'||','
            ||'"'||  ship_to_organization_code                    ||'"'||','
            ||'"'||  location_code                                ||'"'||','
            ||'"'||  bill_of_lading                               ||'"'||','
            ||'"'||  packing_slip                                 ||'"'||','
            ||'"'||  shipped_date                                 ||'"'||','
            ||'"'||  freight_carrier_name                         ||'"'||','
            ||'"'||  expected_receipt_date                        ||'"'||','
            ||'"'||  num_of_containers                            ||'"'||','
            ||'"'||  waybill_airbill_num                          ||'"'||','
            ||'"'||  comments                                     ||'"'||','
            ||'"'||  gross_weight                                 ||'"'||','
            ||'"'||  gross_weight_unit_of_measure                 ||'"'||','
            ||'"'||  net_weight                                   ||'"'||','
            ||'"'||  net_weight_unit_of_measure                   ||'"'||','
            ||'"'||  tar_weight                                   ||'"'||','
            ||'"'||  tar_weight_unit_of_measure                   ||'"'||','
            ||'"'||  packaging_code                               ||'"'||','
            ||'"'||  carrier_method                               ||'"'||','
            ||'"'||  carrier_equipment                            ||'"'||','
            ||'"'||  special_handling_code                        ||'"'||','
            ||'"'||  hazard_code                                  ||'"'||','
            ||'"'||  hazard_class                                 ||'"'||','
            ||'"'||  hazard_description                           ||'"'||','
            ||'"'||  freight_terms                                ||'"'||','
            ||'"'||  freight_bill_number                          ||'"'||','
            ||'"'||  invoice_num                                  ||'"'||','
            ||'"'||  invoice_date                                 ||'"'||','
            ||'"'||  total_invoice_amount                         ||'"'||','
            ||'"'||  tax_name                                     ||'"'||','
            ||'"'||  tax_amount                                   ||'"'||','
            ||'"'||  freight_amount                               ||'"'||','
            ||'"'||  currency_code                                ||'"'||','
            ||'"'||  conversion_rate_type                         ||'"'||','
            ||'"'||  conversion_rate                              ||'"'||','
            ||'"'||  conversion_rate_date                         ||'"'||','
            ||'"'||  payment_terms_name                           ||'"'||','
            ||'"'||  employee_name                                ||'"'||','
            ||'"'||  transaction_date                             ||'"'||','
            ||'"'||  customer_account_number                      ||'"'||','
            ||'"'||  customer_party_name                          ||'"'||','
            ||'"'||  customer_party_number                        ||'"'||','
            ||'"'||  business_unit                                ||'"'||','
            ||'"'||  ra_outsourcer_party_name                     ||'"'||','
            ||'"'||  receipt_advice_number                        ||'"'||','
            ||'"'||  ra_document_code                             ||'"'||','
            ||'"'||  ra_document_number                           ||'"'||','
            ||'"'||  ra_doc_revision_number                       ||'"'||','
            ||'"'||  ra_doc_revision_date                         ||'"'||','
            ||'"'||  ra_doc_creation_date                         ||'"'||','
            ||'"'||  ra_doc_last_update_date                      ||'"'||','
            ||'"'||  ra_outsourcer_contact_name                   ||'"'||','
            ||'"'||  ra_vendor_site_name                          ||'"'||','
            ||'"'||  ra_note_to_receiver                          ||'"'||','
            ||'"'||  ra_doo_source_system_name                    ||'"'||','
            ||'"'||  attribute_category                           ||'"'||','
            ||'"'||  attribute1                                   ||'"'||','
            ||'"'||  attribute2                                   ||'"'||','
            ||'"'||  attribute3                                   ||'"'||','
            ||'"'||  attribute4                                   ||'"'||','
            ||'"'||  attribute5                                   ||'"'||','
            ||'"'||  attribute6                                   ||'"'||','
            ||'"'||  attribute7                                   ||'"'||','
            ||'"'||  attribute8                                   ||'"'||','
            ||'"'||  attribute9                                   ||'"'||','
            ||'"'||  attribute10                                  ||'"'||','
            ||'"'||  attribute11                                  ||'"'||','
            ||'"'||  attribute12                                  ||'"'||','
            ||'"'||  attribute13                                  ||'"'||','
            ||'"'||  attribute14                                  ||'"'||','
            ||'"'||  attribute15                                  ||'"'||','
            ||'"'||  attribute16                                  ||'"'||','
            ||'"'||  attribute17                                  ||'"'||','
            ||'"'||  attribute18                                  ||'"'||','
            ||'"'||  attribute19                                  ||'"'||','
            ||'"'||  attribute20                                  ||'"'||','
            ||'"'||  attribute_number1                            ||'"'||','
            ||'"'||  attribute_number2                            ||'"'||','
            ||'"'||  attribute_number3                            ||'"'||','
            ||'"'||  attribute_number4                            ||'"'||','
            ||'"'||  attribute_number5                            ||'"'||','
            ||'"'||  attribute_number6                            ||'"'||','
            ||'"'||  attribute_number7                            ||'"'||','
            ||'"'||  attribute_number8                            ||'"'||','
            ||'"'||  attribute_number9                            ||'"'||','
            ||'"'||  attribute_number10                           ||'"'||','
            ||'"'||  attribute_date1                              ||'"'||','
            ||'"'||  attribute_date2                              ||'"'||','
            ||'"'||  attribute_date3                              ||'"'||','
            ||'"'||  attribute_date4                              ||'"'||','
            ||'"'||  attribute_date5                              ||'"'||','
            ||'"'||  attribute_timestamp1                         ||'"'||','
            ||'"'||  attribute_timestamp2                         ||'"'||','
            ||'"'||  attribute_timestamp3                         ||'"'||','
            ||'"'||  attribute_timestamp4                         ||'"'||','
            ||'"'||  attribute_timestamp5                         ||'"'||','
            ||'"'||  to_char(gl_date,'YYYY/MM/DD HH24:MI:SS')     ||'"'||','
            ||'"'||  receipt_header_id                            ||'"'
      AS rec
      FROM   xxmx_po_rcpt_headers_xfm
      WHERE  1                          = 1
      AND    batch_name                 = g_batch_name
      ;
  --
BEGIN
    gv_location := NULL;
    /*
    gv_location := NULL;
    fnd_file.put_line(fnd_file.LOG, 'xxmx_po_receipts_pkg.gen_po_receipt_headers - FBDI File Generation Start ');
    gv_location := 'xxmx_po_receipts_pkg.gen_po_receipt_headers - FBDI File Generation Start';
    -- start generating the data file
    -- OPEN the Merge file, main header will be automatically written
    XXMX_utilities_pkg.open_hdl ('PO_RECEIPT_HEADERS');
    --
    -- AR Invoice Distributions
    OPEN po_receipt_headers_cur;
    --
    FETCH po_receipt_headers_cur BULK COLLECT INTO g_fbdi_data;
    --
    CLOSE po_receipt_headers_cur;
    --
    FOR i IN 1..g_fbdi_data.COUNT
    LOOP
        --
        XXMX_utilities_pkg.write_hdl (g_fbdi_data(i));
        --
    END LOOP;
    --
    g_fbdi_data.DELETE;
    --
    -- Close the file Handler
    XXMX_utilities_pkg.close_hdl;
    --
    gv_location := 'Close File opened';
    --
    fnd_file.put_line(fnd_file.LOG, 'xxmx_po_receipts_pkg.gen_po_receipt_headers - FBDI File Generation End ');
    --
    */
    EXCEPTION
        WHEN OTHERS
        THEN
            --
            IF po_receipt_headers_cur%ISOPEN
            THEN
                --
                CLOSE po_receipt_headers_cur;
                --
            END IF;
            --
            ROLLBACK;
            --
            dbms_output.put_line('Error in Procedure XXMX_po_receipts_pkg.gen_po_receipt_headers');
            dbms_output.put_line('Error Message :'||SQLERRM);
            dbms_output.put_line('Error text :' ||dbms_utility.format_error_backtrace||CHR(13)||'Location: '||gv_location);
            raise_application_error(-20111, 'Error text :' ||dbms_utility.format_error_backtrace||CHR(13)||'Location: '||gv_location);
    --
END gen_po_receipt_headers;
  --
  -- ----------------------------------------------------------------------------
  -- |-------------------------< GEN_PO_RCPT_TRX >---------------------------------|
  -- ----------------------------------------------------------------------------
  PROCEDURE gen_po_rcpt_trx  IS
  --
  -- local CURSOR
    CURSOR po_receipt_trx_cur
    IS
      SELECT
              '"'||  interface_line_num                       ||'"'||','
            ||'"'||  transaction_type                         ||'"'||','
            ||'"'||  auto_transact_code                       ||'"'||','
            ||'"'||  transaction_date                         ||'"'||','
            ||'"'||  source_document_code                     ||'"'||','
            ||'"'||  receipt_source_code                      ||'"'||','
            ||'"'||  header_interface_num                     ||'"'||','
            ||'"'||  parent_transaction_id                    ||'"'||','
            ||'"'||  parent_intf_line_num                     ||'"'||','
            ||'"'||  to_organization_code                     ||'"'||','
            ||'"'||  item_num                                 ||'"'||','
            ||'"'||  item_description                         ||'"'||','
            ||'"'||  item_revision                            ||'"'||','
            ||'"'||  document_num                             ||'"'||','
            ||'"'||  document_line_num                        ||'"'||','
            ||'"'||  document_shipment_line_num               ||'"'||','
            ||'"'||  document_distribution_num                ||'"'||','
            ||'"'||  business_unit                            ||'"'||','
            ||'"'||  shipment_num                             ||'"'||','
            ||'"'||  expected_receipt_date                    ||'"'||','
            ||'"'||  subinventory                             ||'"'||','
            ||'"'||  locator                                  ||'"'||','
            ||'"'||  quantity                                 ||'"'||','
            ||'"'||  unit_of_measure                          ||'"'||','
            ||'"'||  primary_quantity                         ||'"'||','
            ||'"'||  primary_unit_of_measure                  ||'"'||','
            ||'"'||  secondary_quantity                       ||'"'||','
            ||'"'||  secondary_unit_of_measure                ||'"'||','
            ||'"'||  vendor_name                              ||'"'||','
            ||'"'||  vendor_num                               ||'"'||','
            ||'"'||  vendor_site_code                         ||'"'||','
            ||'"'||  customer_party_name                      ||'"'||','
            ||'"'||  customer_party_number                    ||'"'||','
            ||'"'||  customer_account_number                  ||'"'||','
            ||'"'||  ship_to_location_code                    ||'"'||','
            ||'"'||  location_code                            ||'"'||','
            ||'"'||  reason_name                              ||'"'||','
            ||'"'||  deliver_to_person_name                   ||'"'||','
            ||'"'||  deliver_to_location_code                 ||'"'||','
            ||'"'||  receipt_exception_flag                   ||'"'||','
            ||'"'||  routing_header_id                        ||'"'||','
            ||'"'||  destination_type_code                    ||'"'||','
            ||'"'||  interface_source_code                    ||'"'||','
            ||'"'||  interface_source_line_id                 ||'"'||','
            ||'"'||  amount                                   ||'"'||','
            ||'"'||  currency_code                            ||'"'||','
            ||'"'||  currency_conversion_type                 ||'"'||','
            ||'"'||  currency_conversion_rate                 ||'"'||','
            ||'"'||  currency_conversion_date                 ||'"'||','
            ||'"'||  inspection_status_code                   ||'"'||','
            ||'"'||  inspection_quality_code                  ||'"'||','
            ||'"'||  from_organization_code                   ||'"'||','
            ||'"'||  from_subinventory                        ||'"'||','
            ||'"'||  from_locator                             ||'"'||','
            ||'"'||  freight_carrier_name                     ||'"'||','
            ||'"'||  bill_of_lading                           ||'"'||','
            ||'"'||  packing_slip                             ||'"'||','
            ||'"'||  shipped_date                             ||'"'||','
            ||'"'||  num_of_containers                        ||'"'||','
            ||'"'||  waybill_airbill_num                      ||'"'||','
            ||'"'||  rma_reference                            ||'"'||','
            ||'"'||  comments                                 ||'"'||','
            ||'"'||  truck_num                                ||'"'||','
            ||'"'||  container_num                            ||'"'||','
            ||'"'||  substitute_item_num                      ||'"'||','
            ||'"'||  notice_unit_price                        ||'"'||','
            ||'"'||  item_category                            ||'"'||','
            ||'"'||  intransit_owning_org_code                ||'"'||','
            ||'"'||  routing_code                             ||'"'||','
            ||'"'||  barcode_label                            ||'"'||','
            ||'"'||  country_of_origin_code                   ||'"'||','
            ||'"'||  create_debit_memo_flag                   ||'"'||','
            ||'"'||  license_plate_number                     ||'"'||','
            ||'"'||  transfer_license_plate_number            ||'"'||','
            ||'"'||  lpn_group_num                            ||'"'||','
            ||'"'||  asn_line_num                             ||'"'||','
            ||'"'||  employee_name                            ||'"'||','
            ||'"'||  source_transaction_num                   ||'"'||','
            ||'"'||  parent_source_transaction_num            ||'"'||','
            ||'"'||  parent_interface_txn_id                  ||'"'||','
            ||'"'||  matching_basis                           ||'"'||','
            ||'"'||  ra_outsourcer_party_name                 ||'"'||','
            ||'"'||  ra_document_number                       ||'"'||','
            ||'"'||  ra_document_line_number                  ||'"'||','
            ||'"'||  ra_note_to_receiver                      ||'"'||','
            ||'"'||  ra_vendor_site_name                      ||'"'||','
            ||'"'||  attribute_category                       ||'"'||','
            ||'"'||  attribute1                               ||'"'||','
            ||'"'||  attribute2                               ||'"'||','
            ||'"'||  attribute3                               ||'"'||','
            ||'"'||  attribute4                               ||'"'||','
            ||'"'||  attribute5                               ||'"'||','
            ||'"'||  attribute6                               ||'"'||','
            ||'"'||  attribute7                               ||'"'||','
            ||'"'||  attribute8                               ||'"'||','
            ||'"'||  attribute9                               ||'"'||','
            ||'"'||  attribute10                              ||'"'||','
            ||'"'||  attribute11                              ||'"'||','
            ||'"'||  attribute12                              ||'"'||','
            ||'"'||  attribute13                              ||'"'||','
            ||'"'||  attribute14                              ||'"'||','
            ||'"'||  attribute15                              ||'"'||','
            ||'"'||  attribute16                              ||'"'||','
            ||'"'||  attribute17                              ||'"'||','
            ||'"'||  attribute18                              ||'"'||','
            ||'"'||  attribute19                              ||'"'||','
            ||'"'||  attribute20                              ||'"'||','
            ||'"'||  attribute_number1                        ||'"'||','
            ||'"'||  attribute_number2                        ||'"'||','
            ||'"'||  attribute_number3                        ||'"'||','
            ||'"'||  attribute_number4                        ||'"'||','
            ||'"'||  attribute_number5                        ||'"'||','
            ||'"'||  attribute_number6                        ||'"'||','
            ||'"'||  attribute_number7                        ||'"'||','
            ||'"'||  attribute_number8                        ||'"'||','
            ||'"'||  attribute_number9                        ||'"'||','
            ||'"'||  attribute_number10                       ||'"'||','
            ||'"'||  attribute_date1                          ||'"'||','
            ||'"'||  attribute_date2                          ||'"'||','
            ||'"'||  attribute_date3                          ||'"'||','
            ||'"'||  attribute_date4                          ||'"'||','
            ||'"'||  attribute_date5                          ||'"'||','
            ||'"'||  attribute_timestamp1                     ||'"'||','
            ||'"'||  attribute_timestamp2                     ||'"'||','
            ||'"'||  attribute_timestamp3                     ||'"'||','
            ||'"'||  attribute_timestamp4                     ||'"'||','
            ||'"'||  attribute_timestamp5                     ||'"'||','
            ||'"'||  consigned_flag                           ||'"'||','
            ||'"'||  soldto_legal_entity                      ||'"'||','
            ||'"'||  consumed_quantity                        ||'"'||','
            ||'"'||  default_taxation_country                 ||'"'||','
            ||'"'||  trx_business_category                    ||'"'||','
            ||'"'||  document_fiscal_classification           ||'"'||','
            ||'"'||  user_defined_fisc_class                  ||'"'||','
            ||'"'||  product_fisc_class_name                  ||'"'||','
            ||'"'||  intended_use                             ||'"'||','
            ||'"'||  product_category                         ||'"'||','
            ||'"'||  tax_classification_code                  ||'"'||','
            ||'"'||  product_type                             ||'"'||','
            ||'"'||  first_pty_number                         ||'"'||','
            ||'"'||  third_pty_number                         ||'"'||','
            ||'"'||  tax_invoice_number                       ||'"'||','
            ||'"'||  tax_invoice_date                         ||'"'||','
            ||'"'||  final_discharge_loc_code                 ||'"'||','
            ||'"'||  assessable_value                         ||'"'||','
            ||'"'||  physical_return_reqd                     ||'"'||','
            ||'"'||  external_system_packing_unit             ||'"'||','
            ||'"'||  eway_bill_number                         ||'"'||','
            ||'"'||  eway_bill_date                           ||'"'
    AS  rec
    FROM   xxmx_po_rcpt_trx_xfm
    WHERE  1                          = 1
    AND    batch_name                 = g_batch_name
    ;
  --
BEGIN
    gv_location := NULL;
    /*
    fnd_file.put_line(fnd_file.LOG, 'xxmx_po_receipts_pkg.gen_po_rcpt_trx - FBDI File Generation Start ');
    gv_location := 'xxmx_po_receipts_pkg.gen_po_rcpt_trx - FBDI File Generation Start';
    -- start generating the data file
    -- OPEN the Merge file, main header will be automatically written
    XXMX_utilities_pkg.open_hdl ('PO_RECEIPT_TRANSACTIONS');
    --
    -- AR Invoice Distributions
    OPEN po_receipt_trx_cur;
    --
    FETCH po_receipt_trx_cur BULK COLLECT INTO g_fbdi_data;
    --
    CLOSE po_receipt_trx_cur;
    --
    FOR i IN 1..g_fbdi_data.COUNT
    LOOP
        --
        XXMX_utilities_pkg.write_hdl (g_fbdi_data(i));
        --
    END LOOP;
    --
    g_fbdi_data.DELETE;
    --
    -- Close the file Handler
    XXMX_utilities_pkg.close_hdl;
    --
    gv_location := 'Close File opened';
    --
    fnd_file.put_line(fnd_file.LOG, 'xxmx_po_receipts_pkg.gen_po_rcpt_trx - FBDI File Generation End ');
    --
    */
    EXCEPTION
        WHEN OTHERS
        THEN
            --
            IF po_receipt_trx_cur%ISOPEN
            THEN
                --
                CLOSE po_receipt_trx_cur;
                --
            END IF;
            --
            ROLLBACK;
            --
            dbms_output.put_line('Error in Procedure xxmx_po_receipts_pkg.gen_po_rcpt_trx');
            dbms_output.put_line('Error Message :'||SQLERRM);
            dbms_output.put_line('Error text :' ||dbms_utility.format_error_backtrace||CHR(13)||'Location: '||gv_location);
            raise_application_error(-20111, 'Error text :' ||dbms_utility.format_error_backtrace||CHR(13)||'Location: '||gv_location);
    --
END gen_po_rcpt_trx;
--
-- ----------------------------------------------------------------------------
-- |------------------------------< PURGE >------------------------------------|
-- ----------------------------------------------------------------------------
--
PROCEDURE PURGE(p_stage IN VARCHAR2)
IS
BEGIN
    --
    IF p_stage = 'TG1'
    THEN
        --
        INSERT INTO XXMX_STG.XXMX_PO_RCPT_HEADERS_STG_ARCH
        SELECT * FROM XXMX_STG.XXMX_PO_RCPT_HEADERS_STG;
        --
        DELETE FROM XXMX_STG.XXMX_PO_RCPT_HEADERS_STG;
        --
        INSERT INTO XXMX_STG.XXMX_PO_RCPT_TRX_STG_ARCH
        SELECT * FROM XXMX_STG.XXMX_PO_RCPT_TRX_STG;
        --
        DELETE FROM XXMX_STG.XXMX_PO_RCPT_TRX_STG;
        --
    ELSIF p_stage = 'TG2'
    THEN
        --
        INSERT INTO XXMX_XFM.XXMX_PO_RCPT_HEADERS_XFM_ARCH
        SELECT * FROM XXMX_XFM.XXMX_PO_RCPT_HEADERS_XFM;
        --
        DELETE FROM XXMX_XFM.XXMX_PO_RCPT_HEADERS_XFM;
        --
        INSERT INTO XXMX_XFM.XXMX_PO_RCPT_TRX_XFM_ARCH
        SELECT * FROM XXMX_XFM.XXMX_PO_RCPT_TRX_XFM;
        --
        DELETE FROM XXMX_XFM.XXMX_PO_RCPT_TRX_XFM;
        --
    END IF;
    --
    COMMIT;
    --
END PURGE;
--
-- ----------------------------------------------------------------------------
-- |------------------------------< MAIN >------------------------------------|
-- ----------------------------------------------------------------------------
--
PROCEDURE main(p_stage IN VARCHAR2)
IS
BEGIN
    IF p_stage IS NULL THEN
        dbms_output.put_line('Please enter a value for Stage');
        RAISE_APPLICATION_ERROR(-20000, 'Please enter a value for Stage');
    END IF;
    dbms_output.put_line('Stage Name '||p_stage);
    ------------------------------------------------------------------------------
    IF p_stage = 'TG1'
    THEN
        -- ----------------------------------------------------------------------------
        dbms_output.put_line('Calling PURGE_STG');
        -- ----------------------------------------------------------------------------
        PURGE('TG1');
        -- ----------------------------------------------------------------------------
        dbms_output.put_line('Calling STG_PO_RECEIPT_HEADERS');
        -- ----------------------------------------------------------------------------
        stg_po_receipt_headers;
        -- ----------------------------------------------------------------------------
        dbms_output.put_line('Calling STG_PO_RCPT_TRX');
        -- ----------------------------------------------------------------------------
        stg_po_rcpt_trx;
        -- ----------------------------------------------------------------------------
        dbms_output.put_line('Calling UPDATE_RECEIPTS_FROM_STG');
        -- ----------------------------------------------------------------------------
        update_receipts_from_stg;
        -- ----------------------------------------------------------------------------
        dbms_output.put_line('Calling DELETE_RECEIPTS_FROM_STG');
        -- ----------------------------------------------------------------------------
        delete_receipts_from_stg;
        -- ----------------------------------------------------------------------------
    ELSIF p_stage = 'TG2'
    THEN
        -- ----------------------------------------------------------------------------
        dbms_output.put_line('Calling PURGE_XFM');
        -- ----------------------------------------------------------------------------
        PURGE('TG2');
        -- ----------------------------------------------------------------------------
        dbms_output.put_line('Calling XFM_PO_RECEIPT_HEADERS');
        -- ----------------------------------------------------------------------------
        xfm_po_receipt_headers;
        -- ----------------------------------------------------------------------------
        dbms_output.put_line('Calling XFM_PO_RCPT_TRX');
        -- ----------------------------------------------------------------------------
        xfm_po_rcpt_trx;
        -- ----------------------------------------------------------------------------
    END IF;
    --
    COMMIT;
    --
END main;
--
END XXMX_PO_RECEIPTS_PKG;