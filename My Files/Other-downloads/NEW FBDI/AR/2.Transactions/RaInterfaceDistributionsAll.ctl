        LOAD DATA
        APPEND
        INTO TABLE RA_INTERFACE_DISTRIBUTIONS_ALL
        FIELDS TERMINATED BY ','
        OPTIONALLY ENCLOSED BY '"'
        TRAILING NULLCOLS
         (
        ORG_ID,
        ACCOUNT_CLASS,
        AMOUNT           "fun_load_interface_utils_pkg.replace_decimal_char(:AMOUNT)",
        PERCENT          "fun_load_interface_utils_pkg.replace_decimal_char(:PERCENT)",
        ACCTD_AMOUNT     "fun_load_interface_utils_pkg.replace_decimal_char(:ACCTD_AMOUNT)",
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
        SEGMENT1,
        SEGMENT2,
        SEGMENT3,
        SEGMENT4,
        SEGMENT5,
        SEGMENT6,
        SEGMENT7,
        SEGMENT8,
        SEGMENT9,
        SEGMENT10,
        SEGMENT11,
        SEGMENT12,
        SEGMENT13,
        SEGMENT14,
        SEGMENT15,
        SEGMENT16,
        SEGMENT17,
        SEGMENT18,
        SEGMENT19,
        SEGMENT20,
        SEGMENT21,
        SEGMENT22,
        SEGMENT23,
        SEGMENT24,
        SEGMENT25,
        SEGMENT26,
        SEGMENT27,
        SEGMENT28,
        SEGMENT29,
        SEGMENT30,
        COMMENTS,
        INTERIM_TAX_SEGMENT1,
        INTERIM_TAX_SEGMENT2,
        INTERIM_TAX_SEGMENT3,
        INTERIM_TAX_SEGMENT4,
        INTERIM_TAX_SEGMENT5,
        INTERIM_TAX_SEGMENT6,
        INTERIM_TAX_SEGMENT7,
        INTERIM_TAX_SEGMENT8,
        INTERIM_TAX_SEGMENT9,
        INTERIM_TAX_SEGMENT10,
        INTERIM_TAX_SEGMENT11,
        INTERIM_TAX_SEGMENT12,
        INTERIM_TAX_SEGMENT13,
        INTERIM_TAX_SEGMENT14,
        INTERIM_TAX_SEGMENT15,
        INTERIM_TAX_SEGMENT16,
        INTERIM_TAX_SEGMENT17,
        INTERIM_TAX_SEGMENT18,
        INTERIM_TAX_SEGMENT19,
        INTERIM_TAX_SEGMENT20,
        INTERIM_TAX_SEGMENT21,
        INTERIM_TAX_SEGMENT22,
        INTERIM_TAX_SEGMENT23,
        INTERIM_TAX_SEGMENT24,
        INTERIM_TAX_SEGMENT25,
        INTERIM_TAX_SEGMENT26,
        INTERIM_TAX_SEGMENT27,
        INTERIM_TAX_SEGMENT28,
        INTERIM_TAX_SEGMENT29,
        INTERIM_TAX_SEGMENT30,
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
        CREATED_BY                                        constant  '#CREATEDBY#',
        CREATION_DATE                                     expression "systimestamp",
        LAST_UPDATED_BY                                   constant  '#LASTUPDATEDBY#',
        LAST_UPDATE_LOGIN                                 constant '#LASTUPDATELOGIN#',
        LAST_UPDATE_DATE                                  expression "systimestamp",
        OBJECT_VERSION_NUMBER                             constant 1 ,
        LOAD_REQUEST_ID                                   constant '#LOADREQUESTID#'
		)