        LOAD DATA
        APPEND
        INTO TABLE HZ_IMP_CONTACTROLES
        FIELDS TERMINATED BY ','
         OPTIONALLY ENCLOSED BY '"'
         TRAILING NULLCOLS
         ( 
	BATCH_ID,
        INTERFACE_ROW_ID                                   "s_row_id_seq.NEXTVAL" ,
        OBJECT_VERSION_NUMBER                              constant 1 ,
        INSERT_UPDATE_CODE,
        INSERT_UPDATE_FLAG,
        CONTACT_ROLE_ORIG_SYSTEM,
        CONTACT_ROLE_ORIG_SYS_REF,
        REL_ORIG_SYSTEM,
        REL_ORIG_SYSTEM_REFERENCE,
        ROLE_TYPE,
        ROLE_LEVEL,
        PRIMARY_FLAG,
        PRIMARY_CONTACT_PER_ROLE_TYPE,
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
        ATTRIBUTE16,
        ATTRIBUTE17,
        ATTRIBUTE18,
        ATTRIBUTE19,
        ATTRIBUTE20,
        ATTRIBUTE21,
        ATTRIBUTE22,
        ATTRIBUTE23,
        ATTRIBUTE24,
        ATTRIBUTE25,
        ATTRIBUTE26,
        ATTRIBUTE27,
        ATTRIBUTE28,
        ATTRIBUTE29,
        ATTRIBUTE30,
        ATTRIBUTE_NUMBER1                                 "fun_load_interface_utils_pkg.replace_decimal_char(:ATTRIBUTE_NUMBER1)",
        ATTRIBUTE_NUMBER2                                 "fun_load_interface_utils_pkg.replace_decimal_char(:ATTRIBUTE_NUMBER2)",
        ATTRIBUTE_NUMBER3                                 "fun_load_interface_utils_pkg.replace_decimal_char(:ATTRIBUTE_NUMBER3)",
        ATTRIBUTE_NUMBER4                                 "fun_load_interface_utils_pkg.replace_decimal_char(:ATTRIBUTE_NUMBER4)",
        ATTRIBUTE_NUMBER5                                 "fun_load_interface_utils_pkg.replace_decimal_char(:ATTRIBUTE_NUMBER5)",
        ATTRIBUTE_NUMBER6                                 "fun_load_interface_utils_pkg.replace_decimal_char(:ATTRIBUTE_NUMBER6)",
        ATTRIBUTE_NUMBER7                                 "fun_load_interface_utils_pkg.replace_decimal_char(:ATTRIBUTE_NUMBER7)",
        ATTRIBUTE_NUMBER8                                 "fun_load_interface_utils_pkg.replace_decimal_char(:ATTRIBUTE_NUMBER8)",
        ATTRIBUTE_NUMBER9                                 "fun_load_interface_utils_pkg.replace_decimal_char(:ATTRIBUTE_NUMBER9)",
        ATTRIBUTE_NUMBER10                                "fun_load_interface_utils_pkg.replace_decimal_char(:ATTRIBUTE_NUMBER10)",
        ATTRIBUTE_NUMBER11                                "fun_load_interface_utils_pkg.replace_decimal_char(:ATTRIBUTE_NUMBER11)",
        ATTRIBUTE_NUMBER12                                "fun_load_interface_utils_pkg.replace_decimal_char(:ATTRIBUTE_NUMBER12)",
        ATTRIBUTE_DATE1                                   "to_date(:ATTRIBUTE_DATE1,'YYYY/MM/DD')",
        ATTRIBUTE_DATE2                                   "to_date(:ATTRIBUTE_DATE2,'YYYY/MM/DD')",
        ATTRIBUTE_DATE3                                   "to_date(:ATTRIBUTE_DATE3,'YYYY/MM/DD')",
        ATTRIBUTE_DATE4                                   "to_date(:ATTRIBUTE_DATE4,'YYYY/MM/DD')",
        ATTRIBUTE_DATE5                                   "to_date(:ATTRIBUTE_DATE5,'YYYY/MM/DD')",
        ATTRIBUTE_DATE6                                   "to_date(:ATTRIBUTE_DATE6,'YYYY/MM/DD')",
        ATTRIBUTE_DATE7                                   "to_date(:ATTRIBUTE_DATE7,'YYYY/MM/DD')",
        ATTRIBUTE_DATE8                                   "to_date(:ATTRIBUTE_DATE8,'YYYY/MM/DD')",
        ATTRIBUTE_DATE9                                   "to_date(:ATTRIBUTE_DATE9,'YYYY/MM/DD')",
        ATTRIBUTE_DATE10                                  "to_date(:ATTRIBUTE_DATE10,'YYYY/MM/DD')",
        ATTRIBUTE_DATE11                                  "to_date(:ATTRIBUTE_DATE11,'YYYY/MM/DD')",
        ATTRIBUTE_DATE12                                  "to_date(:ATTRIBUTE_DATE12,'YYYY/MM/DD')",
        LOAD_REQUEST_ID                constant '#LOADREQUESTID#',
CREATED_BY                    constant '#CREATEDBY#',
CREATION_DATE                 expression "systimestamp",
LAST_UPDATED_BY               constant '#LASTUPDATEDBY#',
LAST_UPDATE_DATE              expression "systimestamp",
LAST_UPDATE_LOGIN             constant '#LASTUPDATELOGIN#'
		)
