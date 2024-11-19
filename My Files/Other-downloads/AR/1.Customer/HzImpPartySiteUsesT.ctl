    LOAD DATA
    APPEND
    INTO TABLE HZ_IMP_PARTYSITEUSES_T
    FIELDS TERMINATED BY ','
    OPTIONALLY ENCLOSED BY '"'
    TRAILING NULLCOLS
    (   
        BATCH_ID,
        PARTY_ORIG_SYSTEM,
        PARTY_ORIG_SYSTEM_REFERENCE,
        SITE_ORIG_SYSTEM,
        SITE_ORIG_SYSTEM_REFERENCE,
        SITE_USE_TYPE,
        PRIMARY_FLAG,
        INSERT_UPDATE_FLAG,
        START_DATE                                        "to_date(:START_DATE,'YYYY/MM/DD')",
        END_DATE                                          "to_date(:END_DATE,'YYYY/MM/DD')",
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
        SITEUSE_ORIG_SYSTEM,
        SITEUSE_ORIG_SYSTEM_REF,
        LOAD_REQUEST_ID                  constant '#LOADREQUESTID#'
       
      )
