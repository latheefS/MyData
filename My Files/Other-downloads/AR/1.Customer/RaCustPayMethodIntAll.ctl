	 LOAD DATA
         APPEND
         INTO TABLE RA_CUST_PAY_METHOD_INT_ALL
         FIELDS TERMINATED BY ','
         OPTIONALLY ENCLOSED BY '"'
         TRAILING NULLCOLS
         ( 
		 
	CUST_ORIG_SYSTEM,
        CUST_ORIG_SYSTEM_REFERENCE,
        PAYMENT_METHOD_NAME,
        PRIMARY_FLAG,
        CUST_SITE_ORIG_SYSTEM,
        CUST_SITE_ORIG_SYS_REF,
        START_DATE                                        "to_date(:START_DATE,'YYYY/MM/DD')",
        END_DATE                                          "to_date(:END_DATE,'YYYY/MM/DD')",
        BATCH_ID,
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
        LAST_UPDATE_DATE                                  expression "systimestamp",
        LAST_UPDATED_BY                                  constant '#LASTUPDATEDBY#',
        CREATED_BY                                       constant  '#CREATEDBY#',
        CREATION_DATE                                    expression "systimestamp",
        LAST_UPDATE_LOGIN                                 constant  '#LASTUPDATELOGIN#' ,
        ORG_ID,
        OBJECT_VERSION_NUMBER                              constant 1 ,
        LOAD_REQUEST_ID                                    constant '#LOADREQUESTID#'
     
      )
