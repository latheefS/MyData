         LOAD DATA
         APPEND
         INTO TABLE HZ_IMP_PERSONLANG
         FIELDS TERMINATED BY ','
         OPTIONALLY ENCLOSED BY '"'
         TRAILING NULLCOLS
         ( 
	BATCH_ID,
        INTERFACE_ROW_ID                                   expression "s_row_id_seq.NEXTVAL",
        PARTY_ORIG_SYSTEM,
        PARTY_ORIG_SYSTEM_REFERENCE,
        LANGUAGE_NAME,
        NATIVE_LANGUAGE_FLAG,
        PRIMARY_LANGUAGE_INDICATOR,
        LOAD_REQUEST_ID                  constant '#LOADREQUESTID#',
CREATED_BY                    constant '#CREATEDBY#',
CREATION_DATE                 expression "systimestamp",
LAST_UPDATED_BY               constant '#LASTUPDATEDBY#',
LAST_UPDATE_DATE              expression "systimestamp",
LAST_UPDATE_LOGIN             constant '#LASTUPDATELOGIN#'	
		)
