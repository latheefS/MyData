        LOAD DATA
        APPEND
        INTO TABLE RA_INTERFACE_SALESCREDITS_ALL
        FIELDS TERMINATED BY ','
        OPTIONALLY ENCLOSED BY '"'
        TRAILING NULLCOLS
         (
	ORG_ID,
        SALESREP_NUMBER,
        SALES_CREDIT_TYPE_NAME,
        SALES_CREDIT_AMOUNT_SPLIT                         "fun_load_interface_utils_pkg.replace_decimal_char(:SALES_CREDIT_AMOUNT_SPLIT)",
        SALES_CREDIT_PERCENT_SPLIT                        "fun_load_interface_utils_pkg.replace_decimal_char(:SALES_CREDIT_PERCENT_SPLIT)",
        INTERFACE_LINE_CONTEXT,
        INTERFACE_LINE_ATTRIBUTE1,
        INTERFACE_LINE_ATTRIBUTE2,
        INTERFACE_LINE_ATTRIBUTE3,
        INTERFACE_LINE_ATTRIBUTE4,
        INTERFACE_LINE_ATTRIBUTE5,
        INTERFACE_LINE_ATTRIBUTE6,
        INTERFACE_LINE_ATTRIBUTE7,
        INTERFACE_LINE_ATTRIBUTE8,
        INTERFACE_LINE_ATTRIBUTE9,
        INTERFACE_LINE_ATTRIBUTE10,
        INTERFACE_LINE_ATTRIBUTE11,
        INTERFACE_LINE_ATTRIBUTE12,
        INTERFACE_LINE_ATTRIBUTE13,
        INTERFACE_LINE_ATTRIBUTE14,
        INTERFACE_LINE_ATTRIBUTE15,
        ATTRIBUTE_CATEGORY,
        ATTRIBUTE1,
        ATTRIBUTE2,
        ATTRIBUTE3,
        ATTRIBUTE4,
        ATTRIBUTE5,
        ATTRIBUTE6,
        ATTRIBUTE7,
        ATTRIBUTE8,
        ATTRIBUTE9,
        ATTRIBUTE10,
        ATTRIBUTE11,
        ATTRIBUTE12,
        ATTRIBUTE13,
        ATTRIBUTE14,
        ATTRIBUTE15,
        BU_NAME,
        CREATED_BY                                        constant '#CREATEDBY#',
        CREATION_DATE                                     expression "systimestamp",
        LAST_UPDATED_BY                                   constant '#LASTUPDATEDBY#',
        LAST_UPDATE_DATE                                  expression "systimestamp",
        LAST_UPDATE_LOGIN                                  constant   '#LASTUPDATELOGIN#',
        OBJECT_VERSION_NUMBER                              constant 1 ,
        LOAD_REQUEST_ID                                    constant '#LOADREQUESTID#'
        
		)
