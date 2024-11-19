-- +=========================================================================+
-- | $Header: fusionapps/scm/rcv/bin/RcvHeadersInterface.ctl /st_fusionapps_pt-v2mib/12 2021/11/27 00:13:49 gaprasad Exp $ |
-- +=========================================================================+
-- | Copyright (c) 2012 Oracle Corporation Redwood City, California, USA |
-- | All rights reserved. |
-- |=========================================================================+
-- | |
-- | |
-- | FILENAME |
-- | |
-- | RcvHeadersInterface.ctl
-- | |
-- | DESCRIPTION
-- | Uploads CSV file data into RCV_HEADERS_INTERFACE
-- |
-- | Created by Anshuman 05/14/2012
-- |
-- | History
-- | Initial version source controled via bug 14019436

--OPTIONS (ROWS=1)
LOAD DATA                                                                                                                            
--INFILE 'rcvreceiptprocessor.csv'
--BADFILE 'rcvreceiptprocessor.bad'
--DISCARDFILE 'rcvreceiptprocessor.dsc' 

APPEND
INTO TABLE RCV_HEADERS_INTERFACE 
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' 
TRAILING NULLCOLS
(HEADER_INTERFACE_ID  EXPRESSION "RCV_HEADERS_INTERFACE_S.NEXTVAL",
--GROUP_ID             EXPRESSION "RCV_INTERFACE_GROUPS_S.NEXTVAL",
PROCESSING_STATUS_CODE       CONSTANT 'PENDING',
HEADER_INTERFACE_NUM         ,
RECEIPT_SOURCE_CODE          ,
ASN_TYPE                     ,
TRANSACTION_TYPE             ,
LAST_UPDATE_DATE             expression            "systimestamp",
LAST_UPDATED_BY              CONSTANT              '#LASTUPDATEDBY#',
LAST_UPDATE_LOGIN            CONSTANT              '#LASTUPDATELOGIN#',
CREATION_DATE                expression            "systimestamp",
CREATED_BY                   CONSTANT              '#CREATEDBY#',
NOTICE_CREATION_DATE         "to_date(:NOTICE_CREATION_DATE,'YYYY/MM/DD')",
SHIPMENT_NUM                 ,
RECEIPT_NUM                  ,
VENDOR_NAME                  ,
VENDOR_NUM                   ,
VENDOR_SITE_CODE             ,
FROM_ORGANIZATION_CODE       ,
SHIP_TO_ORGANIZATION_CODE    ,
LOCATION_CODE                ,
BILL_OF_LADING               ,
PACKING_SLIP                 ,
SHIPPED_DATE                 "to_date(:SHIPPED_DATE, 'YYYY/MM/DD HH24:MI:SS')",
FREIGHT_CARRIER_NAME CHAR(360)         ,
EXPECTED_RECEIPT_DATE        "to_date(:EXPECTED_RECEIPT_DATE, 'YYYY/MM/DD HH24:MI:SS')",
NUM_OF_CONTAINERS            ,
WAYBILL_AIRBILL_NUM          ,
COMMENTS                     "REPLACE(:COMMENTS,'\\n','\n')",
GROSS_WEIGHT                 "fun_load_interface_utils_pkg.replace_decimal_char(:GROSS_WEIGHT)",
GROSS_WEIGHT_UNIT_OF_MEASURE ,
NET_WEIGHT                   "fun_load_interface_utils_pkg.replace_decimal_char(:NET_WEIGHT)",
NET_WEIGHT_UNIT_OF_MEASURE   ,
TAR_WEIGHT                   "fun_load_interface_utils_pkg.replace_decimal_char(:TAR_WEIGHT)",
TAR_WEIGHT_UNIT_OF_MEASURE   ,
PACKAGING_CODE               ,
CARRIER_METHOD               ,
CARRIER_EQUIPMENT            ,
SPECIAL_HANDLING_CODE        ,
HAZARD_CODE                  ,
HAZARD_CLASS                 ,
HAZARD_DESCRIPTION           ,
FREIGHT_TERMS                ,
FREIGHT_BILL_NUMBER          ,
INVOICE_NUM                  ,
INVOICE_DATE                 "to_date(:INVOICE_DATE, 'YYYY/MM/DD')",
TOTAL_INVOICE_AMOUNT         "fun_load_interface_utils_pkg.replace_decimal_char(:TOTAL_INVOICE_AMOUNT)",
TAX_NAME                     ,
TAX_AMOUNT                   "fun_load_interface_utils_pkg.replace_decimal_char(:TAX_AMOUNT)",
FREIGHT_AMOUNT               "fun_load_interface_utils_pkg.replace_decimal_char(:FREIGHT_AMOUNT)",
CURRENCY_CODE                ,
CONVERSION_RATE_TYPE         ,
CONVERSION_RATE              "fun_load_interface_utils_pkg.replace_decimal_char(:CONVERSION_RATE)",
CONVERSION_RATE_DATE         "to_date(:CONVERSION_RATE_DATE, 'YYYY/MM/DD')",
PAYMENT_TERMS_NAME           ,
EMPLOYEE_NAME                ,
VALIDATION_FLAG              CONSTANT 'Y',
TRANSACTION_DATE             "to_date(:TRANSACTION_DATE, 'YYYY/MM/DD HH24:MI:SS')", 
CUSTOMER_ACCOUNT_NUMBER      ,
CUSTOMER_PARTY_NAME CHAR(360)          ,
CUSTOMER_PARTY_NUMBER        ,
BUSINESS_UNIT                ,
RA_OUTSOURCER_PARTY_NAME     ,
RECEIPT_ADVICE_NUMBER        ,
RA_DOCUMENT_CODE             ,
RA_DOCUMENT_NUMBER           ,
RA_DOC_REVISION_NUMBER       ,
RA_DOC_REVISION_DATE         "to_date(:RA_DOC_REVISION_DATE, 'YYYY/MM/DD HH24:MI:SS')",
RA_DOC_CREATION_DATE         "to_date(:RA_DOC_CREATION_DATE, 'YYYY/MM/DD HH24:MI:SS')",
RA_DOC_LAST_UPDATE_DATE      "to_date(:RA_DOC_LAST_UPDATE_DATE, 'YYYY/MM/DD HH24:MI:SS')",
RA_OUTSOURCER_CONTACT_NAME   ,
RA_VENDOR_SITE_NAME          ,
RA_NOTE_TO_RECEIVER CHAR(480)  "REPLACE(:RA_NOTE_TO_RECEIVER,'\\n','\n')",
RA_DOO_SOURCE_SYSTEM_NAME,
ATTRIBUTE_CATEGORY           ,
ATTRIBUTE1                   "REPLACE(:ATTRIBUTE1,'\\n','\n')",
ATTRIBUTE2                   "REPLACE(:ATTRIBUTE2,'\\n','\n')",
ATTRIBUTE3                   "REPLACE(:ATTRIBUTE3,'\\n','\n')",
ATTRIBUTE4                   "REPLACE(:ATTRIBUTE4,'\\n','\n')",
ATTRIBUTE5                   "REPLACE(:ATTRIBUTE5,'\\n','\n')",
ATTRIBUTE6                   "REPLACE(:ATTRIBUTE6,'\\n','\n')",
ATTRIBUTE7                   "REPLACE(:ATTRIBUTE7,'\\n','\n')",
ATTRIBUTE8                   "REPLACE(:ATTRIBUTE8,'\\n','\n')",
ATTRIBUTE9                   "REPLACE(:ATTRIBUTE9,'\\n','\n')",
ATTRIBUTE10                  "REPLACE(:ATTRIBUTE10,'\\n','\n')",
ATTRIBUTE11                  "REPLACE(:ATTRIBUTE11,'\\n','\n')",
ATTRIBUTE12                  "REPLACE(:ATTRIBUTE12,'\\n','\n')",
ATTRIBUTE13                  "REPLACE(:ATTRIBUTE13,'\\n','\n')",
ATTRIBUTE14                  "REPLACE(:ATTRIBUTE14,'\\n','\n')",
ATTRIBUTE15                  "REPLACE(:ATTRIBUTE15,'\\n','\n')",
ATTRIBUTE16                  "REPLACE(:ATTRIBUTE16,'\\n','\n')",
ATTRIBUTE17                  "REPLACE(:ATTRIBUTE17,'\\n','\n')",
ATTRIBUTE18                  "REPLACE(:ATTRIBUTE18,'\\n','\n')",
ATTRIBUTE19                  "REPLACE(:ATTRIBUTE19,'\\n','\n')",
ATTRIBUTE20                  "REPLACE(:ATTRIBUTE20,'\\n','\n')",
ATTRIBUTE_NUMBER1 "fun_load_interface_utils_pkg.replace_decimal_char(:ATTRIBUTE_NUMBER1)",
ATTRIBUTE_NUMBER2 "fun_load_interface_utils_pkg.replace_decimal_char(:ATTRIBUTE_NUMBER2)",
ATTRIBUTE_NUMBER3 "fun_load_interface_utils_pkg.replace_decimal_char(:ATTRIBUTE_NUMBER3)",
ATTRIBUTE_NUMBER4 "fun_load_interface_utils_pkg.replace_decimal_char(:ATTRIBUTE_NUMBER4)",
ATTRIBUTE_NUMBER5 "fun_load_interface_utils_pkg.replace_decimal_char(:ATTRIBUTE_NUMBER5)",
ATTRIBUTE_NUMBER6 "fun_load_interface_utils_pkg.replace_decimal_char(:ATTRIBUTE_NUMBER6)",
ATTRIBUTE_NUMBER7 "fun_load_interface_utils_pkg.replace_decimal_char(:ATTRIBUTE_NUMBER7)",
ATTRIBUTE_NUMBER8 "fun_load_interface_utils_pkg.replace_decimal_char(:ATTRIBUTE_NUMBER8)",
ATTRIBUTE_NUMBER9 "fun_load_interface_utils_pkg.replace_decimal_char(:ATTRIBUTE_NUMBER9)",
ATTRIBUTE_NUMBER10 "fun_load_interface_utils_pkg.replace_decimal_char(:ATTRIBUTE_NUMBER10)",
ATTRIBUTE_DATE1                "to_date(:ATTRIBUTE_DATE1, 'YYYY/MM/DD')",
ATTRIBUTE_DATE2                "to_date(:ATTRIBUTE_DATE2, 'YYYY/MM/DD')",
ATTRIBUTE_DATE3                "to_date(:ATTRIBUTE_DATE3, 'YYYY/MM/DD')",
ATTRIBUTE_DATE4                "to_date(:ATTRIBUTE_DATE4, 'YYYY/MM/DD')",
ATTRIBUTE_DATE5                "to_date(:ATTRIBUTE_DATE5, 'YYYY/MM/DD')",
ATTRIBUTE_TIMESTAMP1  "to_timestamp(:ATTRIBUTE_TIMESTAMP1, 'YYYY/MM/DD HH24:MI:SS:FF')",
ATTRIBUTE_TIMESTAMP2  "to_timestamp(:ATTRIBUTE_TIMESTAMP2, 'YYYY/MM/DD HH24:MI:SS:FF')",
ATTRIBUTE_TIMESTAMP3  "to_timestamp(:ATTRIBUTE_TIMESTAMP3, 'YYYY/MM/DD HH24:MI:SS:FF')",
ATTRIBUTE_TIMESTAMP4  "to_timestamp(:ATTRIBUTE_TIMESTAMP4, 'YYYY/MM/DD HH24:MI:SS:FF')",
ATTRIBUTE_TIMESTAMP5  "to_timestamp(:ATTRIBUTE_TIMESTAMP5, 'YYYY/MM/DD HH24:MI:SS:FF')",
GL_DATE               "to_date(:GL_DATE, 'YYYY/MM/DD HH24:MI:SS')",
RECEIPT_HEADER_ID,
OBJECT_VERSION_NUMBER CONSTANT 1,
--LOAD_REQUEST_ID constant '1'
LOAD_REQUEST_ID constant '#LOADREQUESTID#',
EXTERNAL_SYS_TXN_REFERENCE      char(300),
EMPLOYEE_ID
)
