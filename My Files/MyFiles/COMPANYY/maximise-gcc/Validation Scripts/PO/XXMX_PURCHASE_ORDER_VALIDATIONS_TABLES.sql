  DROP TABLE XXMX_CORE.XXMX_SCM_PO_HEADERS_STD_VAL ;
  --
  CREATE TABLE XXMX_CORE.XXMX_SCM_PO_HEADERS_STD_VAL
   (VALIDATION_ERROR_MESSAGE     VARCHAR2(3000),
    FILE_SET_ID                  VARCHAR2(30),
    MIGRATION_SET_ID             NUMBER,
    MIGRATION_SET_NAME           VARCHAR2(100),
    MIGRATION_STATUS             VARCHAR2(50),
    INTERFACE_HEADER_KEY         VARCHAR2(50),
    ACTION                       VARCHAR2(25),
    BATCH_ID                     NUMBER,
    INTERFACE_SOURCE_CODE        VARCHAR2(25),
    APPROVAL_ACTION              VARCHAR2(25),
    DOCUMENT_NUM                 VARCHAR2(30),
    DOCUMENT_TYPE_CODE           VARCHAR2(25),
    STYLE_DISPLAY_NAME           VARCHAR2(240),
    PRC_BU_NAME                  VARCHAR2(240),
    REQ_BU_NAME                  VARCHAR2(240),
    SOLDTO_LE_NAME               VARCHAR2(240),
    BILLTO_BU_NAME               VARCHAR2(240),
    AGENT_NAME                   VARCHAR2(2000),
    CURRENCY_CODE                VARCHAR2(15),
    RATE                         NUMBER,
    RATE_TYPE                    VARCHAR2(30),
    RATE_DATE                    DATE,
    COMMENTS                     VARCHAR2(240),
    BILL_TO_LOCATION             VARCHAR2(60),
    SHIP_TO_LOCATION             VARCHAR2(60),
    VENDOR_NAME                  VARCHAR2(360),
    VENDOR_NUM                   VARCHAR2(30),
    VENDOR_SITE_CODE             VARCHAR2(15),
    VENDOR_CONTACT               VARCHAR2(360),
    VENDOR_DOC_NUM               VARCHAR2(25),
    FOB                          VARCHAR2(30),
    FREIGHT_CARRIER              VARCHAR2(360),
    FREIGHT_TERMS                VARCHAR2(30),
    PAY_ON_CODE                  VARCHAR2(25),
    PAYMENT_TERMS                VARCHAR2(50),
    ORIGINATOR_ROLE              VARCHAR2(25),
    CHANGE_ORDER_DESC            VARCHAR2(2000),
    ACCEPTANCE_REQUIRED_FLAG     VARCHAR2(1),
    ACCEPTANCE_WITHIN_DAYS       NUMBER,
    SUPPLIER_NOTIF_METHOD        VARCHAR2(25),
    FAX                          VARCHAR2(60),
    EMAIL_ADDRESS                VARCHAR2(2000),
    CONFIRMING_ORDER_FLAG        VARCHAR2(1),
    NOTE_TO_VENDOR               VARCHAR2(1000),
    NOTE_TO_RECEIVER             VARCHAR2(1000),
    DEFAULT_TAXATION_COUNTRY     VARCHAR2(2),
    TAX_DOCUMENT_SUBTYPE         VARCHAR2(240),
    AGENT_EMAIL_ADDRESS          VARCHAR2(240),
    PO_HEADER_ID                 VARCHAR2(30),
    LOAD_BATCH                   VARCHAR2(300)
    ) ;
  --
  DROP TABLE XXMX_CORE.XXMX_SCM_PO_LINES_STD_VAL ;
  --
  CREATE TABLE XXMX_CORE.XXMX_SCM_PO_LINES_STD_VAL
   (VALIDATION_ERROR_MESSAGE     VARCHAR2(3000),
    FILE_SET_ID                  VARCHAR2(30),
    MIGRATION_SET_ID             NUMBER,
    MIGRATION_SET_NAME           VARCHAR2(100),
    MIGRATION_STATUS             VARCHAR2(50),
    INTERFACE_LINE_KEY           VARCHAR2(50),
    INTERFACE_HEADER_KEY         VARCHAR2(50),
    ACTION                       VARCHAR2(25),
    LINE_NUM                     NUMBER,
    LINE_TYPE                    VARCHAR2(30),
    ITEM                         VARCHAR2(300),
    ITEM_DESCRIPTION             VARCHAR2(240),
    ITEM_REVISION                VARCHAR2(18),
    CATEGORY                     VARCHAR2(2000),
    AMOUNT                       NUMBER,
    QUANTITY                     NUMBER,
    UNIT_OF_MEASURE              VARCHAR2(25),
    UNIT_PRICE                   NUMBER,
    SECONDARY_QUANTITY           NUMBER,
    SECONDARY_UNIT_OF_MEASURE    VARCHAR2(18),
    VENDOR_PRODUCT_NUM           VARCHAR2(25),
    NEGOTIATED_BY_PREPARER_FLAG  VARCHAR2(1),
    HAZARD_CLASS                 VARCHAR2(40),
    UN_NUMBER                    VARCHAR2(25),
    NOTE_TO_VENDOR               VARCHAR2(1000),
    NOTE_TO_RECEIVER             VARCHAR2(1000),
    UNIT_WEIGHT                  NUMBER,
    WEIGHT_UOM_CODE              VARCHAR2(3),
    WEIGHT_UNIT_OF_MEASURE       VARCHAR2(25),
    UNIT_VOLUME                  NUMBER,
    VOLUME_UOM_CODE              VARCHAR2(3),
    VOLUME_UNIT_OF_MEASURE       VARCHAR2(25),
    TEMPLATE_NAME                VARCHAR2(30),
    SOURCE_AGREEMENT_PRC_BU_NAME VARCHAR2(240),
    SOURCE_AGREEMENT             VARCHAR2(30),
    SOURCE_AGREEMENT_LINE        NUMBER,
    DISCOUNT_TYPE                VARCHAR2(25),
    DISCOUNT                     NUMBER,
    DISCOUNT_REASON              VARCHAR2(240),
    MAX_RETAINAGE_AMOUNT         NUMBER,
    PO_HEADER_ID                 VARCHAR2(30),
    PO_LINE_ID                   VARCHAR2(30),
    LOAD_BATCH                   VARCHAR2(300)
   ) ;
  --
  DROP TABLE XXMX_CORE.XXMX_SCM_PO_LINE_LOCATIONS_STD_VAL ;
  --
  CREATE TABLE XXMX_CORE.XXMX_SCM_PO_LINE_LOCATIONS_STD_VAL
   (VALIDATION_ERROR_MESSAGE       VARCHAR2(3000),
    FILE_SET_ID                    VARCHAR2(30),
    MIGRATION_SET_ID               NUMBER,
    MIGRATION_SET_NAME             VARCHAR2(100),
    MIGRATION_STATUS               VARCHAR2(50),
    INTERFACE_LINE_LOCATION_KEY    VARCHAR2(50),
    INTERFACE_LINE_KEY             VARCHAR2(50),
    SHIPMENT_NUM                   NUMBER,
    SHIP_TO_LOCATION               VARCHAR2(60),
    SHIP_TO_ORGANIZATION_CODE      VARCHAR2(18),
    AMOUNT                         NUMBER,
    QUANTITY                       NUMBER,
    NEED_BY_DATE                   DATE,
    PROMISED_DATE                  DATE,
    SECONDARY_QUANTITY             NUMBER,
    SECONDARY_UNIT_OF_MEASURE      VARCHAR2(18),
    DESTINATION_TYPE_CODE          VARCHAR2(25),
    ACCRUE_ON_RECEIPT_FLAG         VARCHAR2(1),
    ALLOW_SUBSTITUTE_RECEIPTS_FLAG VARCHAR2(1),
    ASSESSABLE_VALUE               NUMBER,
    DAYS_EARLY_RECEIPT_ALLOWED     NUMBER,
    DAYS_LATE_RECEIPT_ALLOWED      NUMBER,
    ENFORCE_SHIP_TO_LOCATION_CODE  VARCHAR2(25),
    INSPECTION_REQUIRED_FLAG       VARCHAR2(1),
    RECEIPT_REQUIRED_FLAG          VARCHAR2(1),
    INVOICE_CLOSE_TOLERANCE        NUMBER,
    RECEIPT_CLOSE_TOLERANCE        NUMBER,
    QTY_RCV_TOLERANCE              NUMBER,
    QTY_RCV_EXCEPTION_CODE         VARCHAR2(25),
    RECEIPT_DAYS_EXCEPTION_CODE    VARCHAR2(25),
    RECEIVING_ROUTING              VARCHAR2(30),
    NOTE_TO_RECEIVER               VARCHAR2(1000),
    INPUT_TAX_CLASSIFICATION_CODE  VARCHAR2(30),
    LINE_INTENDED_USE              VARCHAR2(240),
    PRODUCT_CATEGORY               VARCHAR2(240),
    PRODUCT_FISC_CLASSIFICATION    VARCHAR2(240),
    PRODUCT_TYPE                   VARCHAR2(240),
    TRX_BUSINESS_CATEGORY_CODE     VARCHAR2(240),
    USER_DEFINED_FISC_CLASS        VARCHAR2(30),
    FREIGHT_CARRIER                VARCHAR2(360),
    MODE_OF_TRANSPORT              VARCHAR2(80),
    SERVICE_LEVEL                  VARCHAR2(80),
    FINAL_DISCHARGE_LOCATION_CODE  VARCHAR2(60),
    REQUESTED_SHIP_DATE            DATE,
    PROMISED_SHIP_DATE             DATE,
    REQUESTED_DELIVERY_DATE        DATE,
    PROMISED_DELIVERY_DATE         DATE,
    RETAINAGE_RATE                 NUMBER,
    INVOICE_MATCH_OPTION           VARCHAR2(25),
    PO_HEADER_ID                   VARCHAR2(30),
    PO_LINE_ID                     VARCHAR2(30),
    LINE_LOCATION_ID               VARCHAR2(30),
    LOAD_BATCH                     VARCHAR2(300)
   ) ;
   --
  DROP TABLE XXMX_CORE.XXMX_SCM_PO_DISTRIBUTIONS_STD_VAL ;
  --
  CREATE TABLE XXMX_CORE.XXMX_SCM_PO_DISTRIBUTIONS_STD_VAL
   (VALIDATION_ERROR_MESSAGE     VARCHAR2(3000),
    FILE_SET_ID                  VARCHAR2(30),
    MIGRATION_SET_ID             NUMBER,
    MIGRATION_SET_NAME           VARCHAR2(100),
    MIGRATION_STATUS             VARCHAR2(50),
    INTERFACE_DISTRIBUTION_KEY   VARCHAR2(50),
    INTERFACE_LINE_LOCATION_KEY  VARCHAR2(50),
    DISTRIBUTION_NUM             NUMBER,
    DELIVER_TO_LOCATION          VARCHAR2(60),
    DELIVER_TO_PERSON_FULL_NAME  VARCHAR2(2000),
    DESTINATION_SUBINVENTORY     VARCHAR2(10),
    AMOUNT_ORDERED               NUMBER,
    QUANTITY_ORDERED             NUMBER,
    CHARGE_ACCOUNT_SEGMENT1      VARCHAR2(25),
    CHARGE_ACCOUNT_SEGMENT2      VARCHAR2(25),
    CHARGE_ACCOUNT_SEGMENT3      VARCHAR2(25),
    CHARGE_ACCOUNT_SEGMENT4      VARCHAR2(25),
    CHARGE_ACCOUNT_SEGMENT5      VARCHAR2(25),
    CHARGE_ACCOUNT_SEGMENT6      VARCHAR2(25),
    CHARGE_ACCOUNT_SEGMENT7      VARCHAR2(25),
    CHARGE_ACCOUNT_SEGMENT8      VARCHAR2(25),
    CHARGE_ACCOUNT_SEGMENT9      VARCHAR2(25),
    CHARGE_ACCOUNT_SEGMENT10     VARCHAR2(25),
    DESTINATION_CONTEXT          VARCHAR2(30),
    PROJECT                      VARCHAR2(240),
    TASK                         VARCHAR2(100),
    PJC_EXPENDITURE_ITEM_DATE    DATE,
    EXPENDITURE_TYPE             VARCHAR2(240),
    EXPENDITURE_ORGANIZATION     VARCHAR2(240),
    PJC_BILLABLE_FLAG            VARCHAR2(1),
    PJC_CAPITALIZABLE_FLAG       VARCHAR2(1),
    PJC_WORK_TYPE                VARCHAR2(240),
    RATE                         NUMBER,
    RATE_DATE                    DATE,
    DELIVER_TO_PERSON_EMAIL_ADDR VARCHAR2(240),
    BUDGET_DATE                  DATE,
    PJC_CONTRACT_NUMBER          VARCHAR2(120),
    PJC_FUNDING_SOURCE           VARCHAR2(360),
    PO_HEADER_ID                 VARCHAR2(30),
    PO_LINE_ID                   VARCHAR2(30),
    LINE_LOCATION_ID             VARCHAR2(30),
    PO_DISTRIBUTION_ID           VARCHAR2(30),
    LOAD_BATCH                   VARCHAR2(300)
   ) ;
--