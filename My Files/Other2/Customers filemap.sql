Insert into XXMX_DM_SUBENTITY_FILE_MAP (APPLICATION_SUITE,APPLICATION,BUSINESS_ENTITY,SUB_ENTITY,FILE_TYPE,FILE_EXTENSION,FILE_NAME,EXCEL_FILE_HEADER) values ('FIN','AR','CUSTOMERS','PARTIES','FBDI','csv','HzImpPartiesT  ',TO_CLOB(q'[MIGRATION_SET_ID,PARTY_ORIG_SYSTEM,PARTY_ORIG_SYSTEM_REFERENCE,INSERT_UPDATE_FLAG,PARTY_TYPE,PARTY_NUMBER,SALUTATION,PARTY_USAGE_CODE,JGZZ_FISCAL_CODE,ORGANIZATION_NAME,DUNS_NUMBER_C,PERSON_FIRST_NAME,PERSON_LAST_NAME,PERSON_LAST_NAME_PREFIX,PERSON_SECOND_LAST_NAME,PERSON_MIDDLE_NAME,PERSON_NAME_SUFFIX,PERSON_TITLE,ATTRIBUTE_CATEGORY,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10,ATTRIBUTE11,ATTRIBUTE12,ATTRIBUTE13,ATTRIBUTE14,ATTRI]')
|| TO_CLOB(q'[BUTE15,ATTRIBUTE16,ATTRIBUTE17,ATTRIBUTE18,ATTRIBUTE19,ATTRIBUTE20,ATTRIBUTE21,ATTRIBUTE22,ATTRIBUTE23,ATTRIBUTE24,ATTRIBUTE25,ATTRIBUTE26,ATTRIBUTE27,ATTRIBUTE28,ATTRIBUTE29,ATTRIBUTE30]'));
Insert into XXMX_DM_SUBENTITY_FILE_MAP (APPLICATION_SUITE,APPLICATION,BUSINESS_ENTITY,SUB_ENTITY,FILE_TYPE,FILE_EXTENSION,FILE_NAME,EXCEL_FILE_HEADER) values ('FIN','AR','CUSTOMERS','PARTY_SITES','FBDI','csv','HzImpPartySitesT',TO_CLOB(q'[MIGRATION_SET_ID,PARTY_ORIG_SYSTEM,PARTY_ORIG_SYSTEM_REFERENCE,SITE_ORIG_SYSTEM,SITE_ORIG_SYSTEM_REFERENCE,LOCATION_ORIG_SYSTEM,LOCATION_ORIG_SYSTEM_REFERENCE,INSERT_UPDATE_FLAG,PARTY_SITE_NAME,PARTY_SITE_NUMBER,START_DATE_ACTIVE,END_DATE_ACTIVE,MAILSTOP,IDENTIFYING_ADDRESS_FLAG,PARTY_SITE_LANGUAGE,ATTRIBUTE_CATEGORY,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10,ATTRIBUTE11,ATTRIBUTE12,ATTRIBUTE13,ATTRIBUTE14,ATTRIBUTE15,ATTRIBUTE1]')
|| TO_CLOB(q'[6,ATTRIBUTE17,ATTRIBUTE18,ATTRIBUTE19,ATTRIBUTE20,ATTRIBUTE21,ATTRIBUTE22,ATTRIBUTE23,ATTRIBUTE24,ATTRIBUTE25,ATTRIBUTE26,ATTRIBUTE27,ATTRIBUTE28,ATTRIBUTE29,ATTRIBUTE30,REL_ORIG_SYSTEM,REL_ORIG_SYSTEM_REFERENCE]'));
Insert into XXMX_DM_SUBENTITY_FILE_MAP (APPLICATION_SUITE,APPLICATION,BUSINESS_ENTITY,SUB_ENTITY,FILE_TYPE,FILE_EXTENSION,FILE_NAME,EXCEL_FILE_HEADER) values ('FIN','AR','CUSTOMERS','PARTY_SITES_USES','FBDI','csv','HzImpPartySiteUsesT',TO_CLOB(q'[MIGRATION_SET_ID,PARTY_ORIG_SYSTEM,PARTY_ORIG_SYSTEM_REFERENCE,SITE_ORIG_SYSTEM,SITE_ORIG_SYSTEM_REFERENCE,SITE_USE_TYPE,PRIMARY_FLAG,INSERT_UPDATE_FLAG,START_DATE,END_DATE,ATTRIBUTE_CATEGORY,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10,ATTRIBUTE11,ATTRIBUTE12,ATTRIBUTE13,ATTRIBUTE14,ATTRIBUTE15,ATTRIBUTE16,ATTRIBUTE17,ATTRIBUTE18,ATTRIBUTE19,ATTRIBUTE20,ATTRIBUTE21,ATTRIBUTE22,ATTRIBUTE23,ATTRIBUTE24,ATTRIBUTE25,ATTRIBUTE26,ATTRI]')
|| TO_CLOB(q'[BUTE27,ATTRIBUTE28,ATTRIBUTE29,ATTRIBUTE30,SITEUSE_ORIG_SYSTEM,SITEUSE_ORIG_SYSTEM_REF]'));
Insert into XXMX_DM_SUBENTITY_FILE_MAP (APPLICATION_SUITE,APPLICATION,BUSINESS_ENTITY,SUB_ENTITY,FILE_TYPE,FILE_EXTENSION,FILE_NAME,EXCEL_FILE_HEADER) values ('FIN','AR','CUSTOMERS','CUSTOMER_ACCOUNTS','FBDI','csv','HzImpAccountsT',TO_CLOB(q'[MIGRATION_SET_ID,CUST_ORIG_SYSTEM,CUST_ORIG_SYSTEM_REFERENCE,PARTY_ORIG_SYSTEM,PARTY_ORIG_SYSTEM_REFERENCE,ACCOUNT_NUMBER,INSERT_UPDATE_FLAG,CUSTOMER_TYPE,CUSTOMER_CLASS_CODE,ACCOUNT_NAME,ACCOUNT_ESTABLISHED_DATE,ATTRIBUTE_CATEGORY,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10,ATTRIBUTE11,ATTRIBUTE12,ATTRIBUTE13,ATTRIBUTE14,ATTRIBUTE15,ATTRIBUTE16,ATTRIBUTE17,ATTRIBUTE18,ATTRIBUTE19,ATTRIBUTE20,ATTRIBUTE21,ATTRIBUTE22,ATTRIBUTE23,A]')
|| TO_CLOB(q'[TTRIBUTE24,ATTRIBUTE25,ATTRIBUTE26,ATTRIBUTE27,ATTRIBUTE28,ATTRIBUTE29,ATTRIBUTE30,ACCOUNT_TERMINATION_DATE]'));
Insert into XXMX_DM_SUBENTITY_FILE_MAP (APPLICATION_SUITE,APPLICATION,BUSINESS_ENTITY,SUB_ENTITY,FILE_TYPE,FILE_EXTENSION,FILE_NAME,EXCEL_FILE_HEADER) values ('FIN','AR','CUSTOMERS','CUSTOMER_ACCOUNTS_SITES','FBDI','csv','HzImpAcctSitesT',TO_CLOB(q'[MIGRATION_SET_ID,CUST_ORIG_SYSTEM,CUST_ORIG_SYSTEM_REFERENCE,CUST_SITE_ORIG_SYSTEM,CUST_SITE_ORIG_SYS_REF,SITE_ORIG_SYSTEM,SITE_ORIG_SYSTEM_REFERENCE,ACCT_SITE_LANGUAGE,INSERT_UPDATE_FLAG,CUSTOMER_CATEGORY_CODE,TRANSLATED_CUSTOMER_NAME,SET_CODE,START_DATE,END_DATE,KEY_ACCOUNT_FLAG,ATTRIBUTE_CATEGORY,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10,ATTRIBUTE11,ATTRIBUTE12,ATTRIBUTE13,ATTRIBUTE14,ATTRIBUTE15,ATTRIBUTE16,ATTRIBUTE17,ATTR]')
|| TO_CLOB(q'[IBUTE18,ATTRIBUTE19,ATTRIBUTE20,ATTRIBUTE21,ATTRIBUTE22,ATTRIBUTE23,ATTRIBUTE24,ATTRIBUTE25,ATTRIBUTE26,ATTRIBUTE27,ATTRIBUTE28,ATTRIBUTE29,ATTRIBUTE30,ACCOUNT_NUMBER,PARTY_SITE_NUMBER]'));
Insert into XXMX_DM_SUBENTITY_FILE_MAP (APPLICATION_SUITE,APPLICATION,BUSINESS_ENTITY,SUB_ENTITY,FILE_TYPE,FILE_EXTENSION,FILE_NAME,EXCEL_FILE_HEADER) values ('FIN','AR','CUSTOMERS','ACCOUNT_SITES_USES','FBDI','csv','HzImpAcctSiteUsesT',TO_CLOB(q'[MIGRATION_SET_ID,CUST_SITE_ORIG_SYSTEM,CUST_SITE_ORIG_SYS_REF,CUST_SITEUSE_ORIG_SYSTEM,CUST_SITEUSE_ORIG_SYS_REF,SITE_USE_CODE,PRIMARY_FLAG,INSERT_UPDATE_FLAG,LOCATION,SET_CODE,START_DATE,END_DATE,ATTRIBUTE_CATEGORY,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10,ATTRIBUTE11,ATTRIBUTE12,ATTRIBUTE13,ATTRIBUTE14,ATTRIBUTE15,ATTRIBUTE16,ATTRIBUTE17,ATTRIBUTE18,ATTRIBUTE19,ATTRIBUTE20,ATTRIBUTE21,ATTRIBUTE22,ATTRIBUTE23,ATTRIBUTE24,ATTRI]')
|| TO_CLOB(q'[BUTE25,ATTRIBUTE26,ATTRIBUTE27,ATTRIBUTE28,ATTRIBUTE29,ATTRIBUTE30,ACCOUNT_NUMBER,PARTY_SITE_NUMBER]'));
Insert into XXMX_DM_SUBENTITY_FILE_MAP (APPLICATION_SUITE,APPLICATION,BUSINESS_ENTITY,SUB_ENTITY,FILE_TYPE,FILE_EXTENSION,FILE_NAME,EXCEL_FILE_HEADER) values ('FIN','AR','CUSTOMERS','CUSTOMER_PROFILES','FBDI','csv','RaCustomerProfilesIntAll',TO_CLOB(q'[MIGRATION_SET_ID,INSERT_UPDATE_FLAG,CUST_ORIG_SYSTEM,CUST_ORIG_SYSTEM_REFERENCE,CUST_SITE_ORIG_SYSTEM,CUST_SITE_ORIG_SYS_REF,CUSTOMER_PROFILE_CLASS_NAME,COLLECTOR_NAME,CREDIT_BALANCE_STATEMENTS,CREDIT_CHECKING,CREDIT_HOLD,DISCOUNT_TERMS,DUNNING_LETTERS,INTEREST_CHARGES,STATEMENTS,TOLERANCE,TAX_PRINTING_OPTION,ACCOUNT_STATUS,AUTOCASH_HIERARCHY_NAME,CREDIT_RATING,DISCOUNT_GRACE_DAYS,INTEREST_PERIOD_DAYS,OVERRIDE_TERMS,PAYMENT_GRACE_DAYS,PERCENT_COLLECTABLE,RISK_CODE,STANDARD_TERM_NAME,STATEMENT_CY]')
|| TO_CLOB(q'[CLE_NAME,CHARGE_ON_FINANCE_CHARGE_FLAG,GROUPING_RULE_NAME,CURRENCY_CODE,AUTO_REC_MIN_RECEIPT_AMOUNT,INTEREST_RATE,MAX_INTEREST_CHARGE,MIN_DUNNING_AMOUNT,MIN_DUNNING_INVOICE_AMOUNT,MIN_FC_BALANCE_AMOUNT,MIN_FC_INVOICE_AMOUNT,MIN_STATEMENT_AMOUNT,OVERALL_CREDIT_LIMIT,TRX_CREDIT_LIMIT,ATTRIBUTE_CATEGORY,ATTRIBUTE1,ATTRIBUTE10,ATTRIBUTE11,ATTRIBUTE12,ATTRIBUTE13,ATTRIBUTE14,ATTRIBUTE15,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,AMOUNT_ATTRIBUTE_CATEGORY,A]')
|| TO_CLOB(q'[MOUNT_ATTRIBUTE1,AMOUNT_ATTRIBUTE10,AMOUNT_ATTRIBUTE11,AMOUNT_ATTRIBUTE12,AMOUNT_ATTRIBUTE13,AMOUNT_ATTRIBUTE14,AMOUNT_ATTRIBUTE15,AMOUNT_ATTRIBUTE2,AMOUNT_ATTRIBUTE3,AMOUNT_ATTRIBUTE4,AMOUNT_ATTRIBUTE5,AMOUNT_ATTRIBUTE6,AMOUNT_ATTRIBUTE7,AMOUNT_ATTRIBUTE8,AMOUNT_ATTRIBUTE9,PARTY_ORIG_SYSTEM,PARTY_ORIG_SYSTEM_REFERENCE,AUTO_REC_INCL_DISPUTED_FLAG,CLEARING_DAYS,ORG_ID,CONS_INV_FLAG,CONS_INV_TYPE,LOCKBOX_MATCHING_OPTION,AUTOCASH_HIERARCHY_NAME_ADR,CREDIT_CLASSIFICATION,CONS_BILL_LEVEL,LATE_CHARGE_]')
|| TO_CLOB(q'[CALCULATION_TRX,CREDIT_ITEMS_FLAG,DISPUTED_TRANSACTIONS_FLAG,LATE_CHARGE_TYPE,INTEREST_CALCULATION_PERIOD,HOLD_CHARGED_INVOICES_FLAG,MULTIPLE_INTEREST_RATES_FLAG,CHARGE_BEGIN_DATE,EXCHANGE_RATE_TYPE,MIN_FC_INVOICE_OVERDUE_TYPE,MIN_FC_INVOICE_PERCENT,MIN_FC_BALANCE_OVERDUE_TYPE,MIN_FC_BALANCE_PERCENT,INTEREST_TYPE,INTEREST_FIXED_AMOUNT,PENALTY_TYPE,PENALTY_RATE,MIN_INTEREST_CHARGE,PENALTY_FIXED_AMOUNT,CREDIT_ANALYST_NAME,CREDIT_REVIEW_CYCLE,LAST_CREDIT_REVIEW_DATE,NEXT_CREDIT_REVIEW_DATE,AUTOMATC]')
|| TO_CLOB(q'[H_RULE_NAME,MATCH_BY_AUTOUPDATE_FLAG,PRINTING_OPTION_CODE,TXN_DELIVERY_METHOD,STMT_DELIVERY_METHOD,XML_INV_FLAG,XML_DM_FLAG,XML_CB_FLAG,XML_CM_FLAG,CMK_CONFIG_FLAG,SERVICE_PROVIDER_NAME,PARTNER_ID,PARTNER_ID_TYPE_CODE,AR_OUTBOUND_TRANSACTION_FLAG,AR_INBOUND_CONFIRM_BOD_FLAG,ACCOUNT_NUMBER,PARTY_NUMBER,PREF_CONTACT_METHOD,INTEREST_SCHEDULE_ID,PENALTY_SCHEDULE_ID]'));
Insert into XXMX_DM_SUBENTITY_FILE_MAP (APPLICATION_SUITE,APPLICATION,BUSINESS_ENTITY,SUB_ENTITY,FILE_TYPE,FILE_EXTENSION,FILE_NAME,EXCEL_FILE_HEADER) values ('FIN','AR','CUSTOMERS','LOCATIONS','FBDI','csv','HzImpLocationsT',TO_CLOB(q'[MIGRATION_SET_ID,LOCATION_ORIG_SYSTEM,LOCATION_ORIG_SYSTEM_REFERENCE,INSERT_UPDATE_FLAG,COUNTRY,ADDRESS1,ADDRESS2,ADDRESS3,ADDRESS4,CITY,STATE,PROVINCE,COUNTY,POSTAL_CODE,POSTAL_PLUS4_CODE,LOCATION_LANGUAGE,DESCRIPTION,SHORT_DESCRIPTION,SALES_TAX_GEOCODE,SALES_TAX_INSIDE_CITY_LIMITS,TIMEZONE_CODE,ADDRESS1_STD,ADAPTER_CONTENT_SOURCE,ADDR_VALID_STATUS_CODE,DATE_VALIDATED,ADDRESS_EFFECTIVE_DATE,ADDRESS_EXPIRATION_DATE,VALIDATED_FLAG,DO_NOT_VALIDATE_FLAG,INTERFACE_STATUS,ERROR_ID,ATTRIBUTE_CATEGORY,]')
|| TO_CLOB(q'[ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10,ATTRIBUTE11,ATTRIBUTE12,ATTRIBUTE13,ATTRIBUTE14,ATTRIBUTE15,ATTRIBUTE16,ATTRIBUTE17,ATTRIBUTE18,ATTRIBUTE19,ATTRIBUTE20,ATTRIBUTE21,ATTRIBUTE22,ATTRIBUTE23,ATTRIBUTE24,ATTRIBUTE25,ATTRIBUTE26,ATTRIBUTE27,ATTRIBUTE28,ATTRIBUTE29,ATTRIBUTE30,ATTRIBUTE_NUMBER1,ATTRIBUTE_NUMBER2,ATTRIBUTE_NUMBER3,ATTRIBUTE_NUMBER4,ATTRIBUTE_NUMBER5,ATTRIBUTE_NUMBER6,ATTRIBUTE_NUMBER7,ATTRIBUTE_NUMBER8,ATTRI]')
|| TO_CLOB(q'[BUTE_NUMBER9,ATTRIBUTE_NUMBER10,ATTRIBUTE_NUMBER11,ATTRIBUTE_NUMBER12,ATTRIBUTE_DATE1,ATTRIBUTE_DATE2,ATTRIBUTE_DATE3,ATTRIBUTE_DATE4,ATTRIBUTE_DATE5,ATTRIBUTE_DATE6,ATTRIBUTE_DATE7,ATTRIBUTE_DATE8,ATTRIBUTE_DATE9,ATTRIBUTE_DATE10,ATTRIBUTE_DATE11,ATTRIBUTE_DATE12,GNR_STATUS]'));
Insert into XXMX_DM_SUBENTITY_FILE_MAP (APPLICATION_SUITE,APPLICATION,BUSINESS_ENTITY,SUB_ENTITY,FILE_TYPE,FILE_EXTENSION,FILE_NAME,EXCEL_FILE_HEADER) values ('FIN','AR','CUSTOMERS','RELATIONSHIPS','FBDI','csv','HzImpRelshipsT',TO_CLOB(q'[MIGRATION_SET_ID,SUB_ORIG_SYSTEM,SUB_ORIG_SYSTEM_REFERENCE,OBJ_ORIG_SYSTEM,OBJ_ORIG_SYSTEM_REFERENCE,RELATIONSHIP_TYPE,RELATIONSHIP_CODE,START_DATE,INSERT_UPDATE_FLAG,END_DATE,ATTRIBUTE_CATEGORY,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10,ATTRIBUTE11,ATTRIBUTE12,ATTRIBUTE13,ATTRIBUTE14,ATTRIBUTE15,ATTRIBUTE16,ATTRIBUTE17,ATTRIBUTE18,ATTRIBUTE19,ATTRIBUTE20,ATTRIBUTE21,ATTRIBUTE22,ATTRIBUTE23,ATTRIBUTE24,ATTRIBUTE25,ATTRIBUTE26,AT]')
|| TO_CLOB(q'[TRIBUTE27,ATTRIBUTE28,ATTRIBUTE29,ATTRIBUTE30,ATTRIBUTE_NUMBER1,ATTRIBUTE_NUMBER2,ATTRIBUTE_NUMBER3,ATTRIBUTE_NUMBER4,ATTRIBUTE_NUMBER5,ATTRIBUTE_NUMBER6,ATTRIBUTE_NUMBER7,ATTRIBUTE_NUMBER8,ATTRIBUTE_NUMBER9,ATTRIBUTE_NUMBER10,ATTRIBUTE_NUMBER11,ATTRIBUTE_NUMBER12,ATTRIBUTE_DATE1,ATTRIBUTE_DATE2,ATTRIBUTE_DATE3,ATTRIBUTE_DATE4,ATTRIBUTE_DATE5,ATTRIBUTE_DATE6,ATTRIBUTE_DATE7,ATTRIBUTE_DATE8,ATTRIBUTE_DATE9,ATTRIBUTE_DATE10,ATTRIBUTE_DATE11,ATTRIBUTE_DATE12,SUBJECT_TYPE,OBJECT_TYPE,REL_ORIG_SYSTEM]')
|| TO_CLOB(q'[,REL_ORIG_SYSTEM_REFERENCE]'));
Insert into XXMX_DM_SUBENTITY_FILE_MAP (APPLICATION_SUITE,APPLICATION,BUSINESS_ENTITY,SUB_ENTITY,FILE_TYPE,FILE_EXTENSION,FILE_NAME,EXCEL_FILE_HEADER) values ('FIN','AR','CUSTOMERS','CUST_ACCT_CONTACT','FBDI','csv','HzImpAcctContactsT',TO_CLOB(q'[MIGRATION_SET_ID,CUST_ORIG_SYSTEM,CUST_ORIG_SYSTEM_REFERENCE,CUST_SITE_ORIG_SYSTEM,CUST_SITE_ORIG_SYS_REF,CUST_CONTACT_ORIG_SYSTEM,CUST_CONTACT_ORIG_SYS_REF,ROLE_TYPE,PRIMARY_FLAG,INSERT_UPDATE_FLAG,SOURCE_CODE,ATTRIBUTE_CATEGORY,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10,ATTRIBUTE11,ATTRIBUTE12,ATTRIBUTE13,ATTRIBUTE14,ATTRIBUTE15,ATTRIBUTE16,ATTRIBUTE17,ATTRIBUTE18,ATTRIBUTE19,ATTRIBUTE20,ATTRIBUTE21,ATTRIBUTE22,ATTRIBUTE23,ATT]')
|| TO_CLOB(q'[RIBUTE24,ATTRIBUTE25,ATTRIBUTE26,ATTRIBUTE27,ATTRIBUTE28,ATTRIBUTE29,ATTRIBUTE30,ATTRIBUTE_NUMBER1,ATTRIBUTE_NUMBER2,ATTRIBUTE_NUMBER3,ATTRIBUTE_NUMBER4,ATTRIBUTE_NUMBER5,ATTRIBUTE_NUMBER6,ATTRIBUTE_NUMBER7,ATTRIBUTE_NUMBER8,ATTRIBUTE_NUMBER9,ATTRIBUTE_NUMBER10,ATTRIBUTE_NUMBER11,ATTRIBUTE_NUMBER12,ATTRIBUTE_DATE1,ATTRIBUTE_DATE2,ATTRIBUTE_DATE3,ATTRIBUTE_DATE4,ATTRIBUTE_DATE5,ATTRIBUTE_DATE6,ATTRIBUTE_DATE7,ATTRIBUTE_DATE8,ATTRIBUTE_DATE9,ATTRIBUTE_DATE10,ATTRIBUTE_DATE11,ATTRIBUTE_DATE12,REL_O]')
|| TO_CLOB(q'[RIG_SYSTEM,REL_ORIG_SYSTEM_REFERENCE]'));
Insert into XXMX_DM_SUBENTITY_FILE_MAP (APPLICATION_SUITE,APPLICATION,BUSINESS_ENTITY,SUB_ENTITY,FILE_TYPE,FILE_EXTENSION,FILE_NAME,EXCEL_FILE_HEADER) values ('FIN','AR','CUSTOMERS','ORG_CONTACTS','FBDI','csv','HzImpContactsT',TO_CLOB(q'[MIGRATION_SET_ID,INSERT_UPDATE_FLAG,CONTACT_NUMBER,DEPARTMENT_CODE,DEPARTMENT,JOB_TITLE,JOB_TITLE_CODE,ATTRIBUTE_CATEGORY,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10,ATTRIBUTE11,ATTRIBUTE12,ATTRIBUTE13,ATTRIBUTE14,ATTRIBUTE15,ATTRIBUTE16,ATTRIBUTE17,ATTRIBUTE18,ATTRIBUTE19,ATTRIBUTE20,ATTRIBUTE21,ATTRIBUTE22,ATTRIBUTE23,ATTRIBUTE24,ATTRIBUTE25,ATTRIBUTE26,ATTRIBUTE27,ATTRIBUTE28,ATTRIBUTE29,ATTRIBUTE30,ATTRIBUTE_NUMBER1,ATTRIBUTE]')
|| TO_CLOB(q'[_NUMBER2,ATTRIBUTE_NUMBER3,ATTRIBUTE_NUMBER4,ATTRIBUTE_NUMBER5,ATTRIBUTE_NUMBER6,ATTRIBUTE_NUMBER7,ATTRIBUTE_NUMBER8,ATTRIBUTE_NUMBER9,ATTRIBUTE_NUMBER10,ATTRIBUTE_NUMBER11,ATTRIBUTE_NUMBER12,ATTRIBUTE_DATE1,ATTRIBUTE_DATE2,ATTRIBUTE_DATE3,ATTRIBUTE_DATE4,ATTRIBUTE_DATE5,ATTRIBUTE_DATE6,ATTRIBUTE_DATE7,ATTRIBUTE_DATE8,ATTRIBUTE_DATE9,ATTRIBUTE_DATE10,ATTRIBUTE_DATE11,ATTRIBUTE_DATE12,REL_ORIG_SYSTEM,REL_ORIG_SYSTEM_REFERENCE,PS_ORIG_SYSTEM,PS_ORIG_SYSTEM_REFERENCE]'));
Insert into XXMX_DM_SUBENTITY_FILE_MAP (APPLICATION_SUITE,APPLICATION,BUSINESS_ENTITY,SUB_ENTITY,FILE_TYPE,FILE_EXTENSION,FILE_NAME,EXCEL_FILE_HEADER) values ('FIN','AR','CUSTOMERS','CONTACT_ROLES','FBDI','csv','HzImpContactRoles',TO_CLOB(q'[MIGRATION_SET_ID,INTERFACE_ROW_ID,INSERT_UPDATE_CODE,INSERT_UPDATE_FLAG,CONTACT_ROLE_ORIG_SYSTEM,CONTACT_ROLE_ORIG_SYS_REF,REL_ORIG_SYSTEM,REL_ORIG_SYSTEM_REFERENCE,ROLE_TYPE,ROLE_LEVEL,PRIMARY_FLAG,PRIMARY_CONTACT_PER_ROLE_TYPE,ATTRIBUTE_CATEGORY,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10,ATTRIBUTE11,ATTRIBUTE12,ATTRIBUTE13,ATTRIBUTE14,ATTRIBUTE15,ATTRIBUTE16,ATTRIBUTE17,ATTRIBUTE18,ATTRIBUTE19,ATTRIBUTE20,ATTRIBUTE21,ATTRIBUTE]')
|| TO_CLOB(q'[22,ATTRIBUTE23,ATTRIBUTE24,ATTRIBUTE25,ATTRIBUTE26,ATTRIBUTE27,ATTRIBUTE28,ATTRIBUTE29,ATTRIBUTE30,ATTRIBUTE_NUMBER1,ATTRIBUTE_NUMBER2,ATTRIBUTE_NUMBER3,ATTRIBUTE_NUMBER4,ATTRIBUTE_NUMBER5,ATTRIBUTE_NUMBER6,ATTRIBUTE_NUMBER7,ATTRIBUTE_NUMBER8,ATTRIBUTE_NUMBER9,ATTRIBUTE_NUMBER10,ATTRIBUTE_NUMBER11,ATTRIBUTE_NUMBER12,ATTRIBUTE_DATE1,ATTRIBUTE_DATE2,ATTRIBUTE_DATE3,ATTRIBUTE_DATE4,ATTRIBUTE_DATE5,ATTRIBUTE_DATE6,ATTRIBUTE_DATE7,ATTRIBUTE_DATE8,ATTRIBUTE_DATE9,ATTRIBUTE_DATE10,ATTRIBUTE_DATE11,ATTR]')
|| TO_CLOB(q'[IBUTE_DATE12]'));
Insert into XXMX_DM_SUBENTITY_FILE_MAP (APPLICATION_SUITE,APPLICATION,BUSINESS_ENTITY,SUB_ENTITY,FILE_TYPE,FILE_EXTENSION,FILE_NAME,EXCEL_FILE_HEADER) values ('FIN','AR','CUSTOMERS','CONTACT_POINTS','FBDI','csv','HzImpContactPtsT',TO_CLOB(q'[MIGRATION_SET_ID,CP_ORIG_SYSTEM,CP_ORIG_SYSTEM_REFERENCE,PARTY_ORIG_SYSTEM,PARTY_ORIG_SYSTEM_REFERENCE,SITE_ORIG_SYSTEM,SITE_ORIG_SYSTEM_REFERENCE,PRIMARY_FLAG,INSERT_UPDATE_FLAG,CONTACT_POINT_TYPE,CONTACT_POINT_PURPOSE,EMAIL_ADDRESS,EMAIL_FORMAT,PHONE_AREA_CODE,PHONE_COUNTRY_CODE,PHONE_EXTENSION,PHONE_LINE_TYPE,PHONE_NUMBER,URL,PHONE_CALLING_CALENDAR,START_DATE,END_DATE,ATTRIBUTE_CATEGORY,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUT]')
|| TO_CLOB(q'[E10,ATTRIBUTE11,ATTRIBUTE12,ATTRIBUTE13,ATTRIBUTE14,ATTRIBUTE15,ATTRIBUTE16,ATTRIBUTE17,ATTRIBUTE18,ATTRIBUTE19,ATTRIBUTE20,ATTRIBUTE21,ATTRIBUTE22,ATTRIBUTE23,ATTRIBUTE24,ATTRIBUTE25,ATTRIBUTE26,ATTRIBUTE27,ATTRIBUTE28,ATTRIBUTE29,ATTRIBUTE30,ATTRIBUTE_NUMBER1,ATTRIBUTE_NUMBER2,ATTRIBUTE_NUMBER3,ATTRIBUTE_NUMBER4,ATTRIBUTE_NUMBER5,ATTRIBUTE_NUMBER6,ATTRIBUTE_NUMBER7,ATTRIBUTE_NUMBER8,ATTRIBUTE_NUMBER9,ATTRIBUTE_NUMBER10,ATTRIBUTE_NUMBER11,ATTRIBUTE_NUMBER12,ATTRIBUTE_DATE1,ATTRIBUTE_DATE2,ATTRI]')
|| TO_CLOB(q'[BUTE_DATE3,ATTRIBUTE_DATE4,ATTRIBUTE_DATE5,ATTRIBUTE_DATE6,ATTRIBUTE_DATE7,ATTRIBUTE_DATE8,ATTRIBUTE_DATE9,ATTRIBUTE_DATE10,ATTRIBUTE_DATE11,ATTRIBUTE_DATE12,REL_ORIG_SYSTEM,REL_ORIG_SYSTEM_REFERENCE]'));
Insert into XXMX_DM_SUBENTITY_FILE_MAP (APPLICATION_SUITE,APPLICATION,BUSINESS_ENTITY,SUB_ENTITY,FILE_TYPE,FILE_EXTENSION,FILE_NAME,EXCEL_FILE_HEADER) values ('FIN','AR','CUSTOMERS','PERSON_LANGUAGE','FBDI','csv','HzImpPersonLang','MIGRATION_SET_ID,PARTY_ORIG_SYSTEM,PARTY_ORIG_SYSTEM_REFERENCE,LANGUAGE_NAME,NATIVE_LANGUAGE_FLAG,PRIMARY_LANGUAGE_INDICATOR');
Insert into XXMX_DM_SUBENTITY_FILE_MAP (APPLICATION_SUITE,APPLICATION,BUSINESS_ENTITY,SUB_ENTITY,FILE_TYPE,FILE_EXTENSION,FILE_NAME,EXCEL_FILE_HEADER) values ('FIN','AR','CUSTOMERS','PARTY_CLASSIFICATIONS','FBDI','csv','HzImpClassificsT',TO_CLOB(q'[MIGRATION_SET_ID,PARTY_ORIG_SYSTEM,PARTY_ORIG_SYSTEM_REFERENCE,CLASSIFIC_ORIG_SYSTEM,CLASSIFIC_ORIG_SYSTEM_REF,CLASS_CATEGORY,CLASS_CODE,START_DATE_ACTIVE,INSERT_UPDATE_FLAG,PRIMARY_FLAG,END_DATE_ACTIVE,RANK,ATTRIBUTE_CATEGORY,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10,ATTRIBUTE11,ATTRIBUTE12,ATTRIBUTE13,ATTRIBUTE14,ATTRIBUTE15,ATTRIBUTE16,ATTRIBUTE17,ATTRIBUTE18,ATTRIBUTE19,ATTRIBUTE20,ATTRIBUTE21,ATTRIBUTE22,ATTRIBUTE23,ATTRIB]')
|| TO_CLOB(q'[UTE24,ATTRIBUTE25,ATTRIBUTE26,ATTRIBUTE27,ATTRIBUTE28,ATTRIBUTE29,ATTRIBUTE30,ATTRIBUTE_NUMBER1,ATTRIBUTE_NUMBER2,ATTRIBUTE_NUMBER3,ATTRIBUTE_NUMBER4,ATTRIBUTE_NUMBER5,ATTRIBUTE_NUMBER6,ATTRIBUTE_NUMBER7,ATTRIBUTE_NUMBER8,ATTRIBUTE_NUMBER9,ATTRIBUTE_NUMBER10,ATTRIBUTE_NUMBER11,ATTRIBUTE_NUMBER12,ATTRIBUTE_DATE1,ATTRIBUTE_DATE2,ATTRIBUTE_DATE3,ATTRIBUTE_DATE4,ATTRIBUTE_DATE5,ATTRIBUTE_DATE6,ATTRIBUTE_DATE7,ATTRIBUTE_DATE8,ATTRIBUTE_DATE9,ATTRIBUTE_DATE10,ATTRIBUTE_DATE11,ATTRIBUTE_DATE12]'));
Insert into XXMX_DM_SUBENTITY_FILE_MAP (APPLICATION_SUITE,APPLICATION,BUSINESS_ENTITY,SUB_ENTITY,FILE_TYPE,FILE_EXTENSION,FILE_NAME,EXCEL_FILE_HEADER) values ('FIN','AR','CUSTOMERS','ROLES_AND_RESPONSIBILITIES','FBDI','csv','HzImpRoleResp',TO_CLOB(q'[MIGRATION_SET_ID,INSERT_UPDATE_CODE,INSERT_UPDATE_FLAG,CUST_CONTACT_ORIG_SYSTEM,CUST_CONTACT_ORIG_SYS_REF,ROLE_RESP_ORIG_SYSTEM,ROLE_RESP_ORIG_SYS_REF,RESPONSIBILITY_TYPE,PRIMARY_FLAG,ATTRIBUTE_CATEGORY,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10,ATTRIBUTE11,ATTRIBUTE12,ATTRIBUTE13,ATTRIBUTE14,ATTRIBUTE15,ATTRIBUTE16,ATTRIBUTE17,ATTRIBUTE18,ATTRIBUTE19,ATTRIBUTE20,ATTRIBUTE21,ATTRIBUTE22,ATTRIBUTE23,ATTRIBUTE24,ATTRIBUTE25,ATTRIB]')
|| TO_CLOB(q'[UTE26,ATTRIBUTE27,ATTRIBUTE28,ATTRIBUTE29,ATTRIBUTE30,ATTRIBUTE_NUMBER1,ATTRIBUTE_NUMBER2,ATTRIBUTE_NUMBER3,ATTRIBUTE_NUMBER4,ATTRIBUTE_NUMBER5,ATTRIBUTE_NUMBER6,ATTRIBUTE_NUMBER7,ATTRIBUTE_NUMBER8,ATTRIBUTE_NUMBER9,ATTRIBUTE_NUMBER10,ATTRIBUTE_NUMBER11,ATTRIBUTE_NUMBER12,ATTRIBUTE_DATE1,ATTRIBUTE_DATE2,ATTRIBUTE_DATE3,ATTRIBUTE_DATE4,ATTRIBUTE_DATE5,ATTRIBUTE_DATE6,ATTRIBUTE_DATE7,ATTRIBUTE_DATE8,ATTRIBUTE_DATE9,ATTRIBUTE_DATE10,ATTRIBUTE_DATE11,ATTRIBUTE_DATE12]'));
Insert into XXMX_DM_SUBENTITY_FILE_MAP (APPLICATION_SUITE,APPLICATION,BUSINESS_ENTITY,SUB_ENTITY,FILE_TYPE,FILE_EXTENSION,FILE_NAME,EXCEL_FILE_HEADER) values ('FIN','AR','CUSTOMERS','CUST_ACCT_RELATIONSHIPS','FBDI','csv','HzImpAccountRels',TO_CLOB(q'[MIGRATION_SET_ID,INSERT_UPDATE_CODE,CUST_ACCT_REL_ORIG_SYSTEM,CUST_ACCT_REL_ORIG_SYS_REF,CUST_ORIG_SYSTEM,CUST_ORIG_SYSTEM_REFERENCE,RELATED_CUST_ORIG_SYSTEM,RELATED_CUST_ORIG_SYS_REF,RELATIONSHIP_TYPE,CUSTOMER_RECIPROCAL_FLAG,SET_CODE,START_DATE,END_DATE,ATTRIBUTE_CATEGORY,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10,ATTRIBUTE11,ATTRIBUTE12,ATTRIBUTE13,ATTRIBUTE14,ATTRIBUTE15,ATTRIBUTE16,ATTRIBUTE17,ATTRIBUTE18,ATTRIBUTE19,ATTRIB]')
|| TO_CLOB(q'[UTE20,ATTRIBUTE21,ATTRIBUTE22,ATTRIBUTE23,ATTRIBUTE24,ATTRIBUTE25,ATTRIBUTE26,ATTRIBUTE27,ATTRIBUTE28,ATTRIBUTE29,ATTRIBUTE30,BILL_TO_FLAG,SHIP_TO_FLAG]'));
Insert into XXMX_DM_SUBENTITY_FILE_MAP (APPLICATION_SUITE,APPLICATION,BUSINESS_ENTITY,SUB_ENTITY,FILE_TYPE,FILE_EXTENSION,FILE_NAME,EXCEL_FILE_HEADER) values ('FIN','AR','CUSTOMERS','CUST_RECEIPT_METHODS','FBDI','csv','RaCustPayMethodIntAll','CUST_ORIG_SYSTEM,CUST_ORIG_SYSTEM_REFERENCE,PAYMENT_METHOD_NAME,PRIMARY_FLAG,CUST_SITE_ORIG_SYSTEM,CUST_SITE_ORIG_SYS_REF,START_DATE,END_DATE,MIGRATION_SET_ID,ATTRIBUTE_CATEGORY,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10,ATTRIBUTE11,ATTRIBUTE12,ATTRIBUTE13,ATTRIBUTE14,ATTRIBUTE15,ORG_ID');
Insert into XXMX_DM_SUBENTITY_FILE_MAP (APPLICATION_SUITE,APPLICATION,BUSINESS_ENTITY,SUB_ENTITY,FILE_TYPE,FILE_EXTENSION,FILE_NAME,EXCEL_FILE_HEADER) values ('FIN','AR','CUSTOMERS','CUST_BANKS','FBDI','csv','RaCustomerBanksIntAll',TO_CLOB(q'[CUST_ORIG_SYSTEM,CUST_ORIG_SYSTEM_REFERENCE,CUST_SITE_ORIG_SYSTEM,CUST_SITE_ORIG_SYS_REF,MIGRATION_SET_ID,BANK_ACCOUNT_NAME,PRIMARY_FLAG,START_DATE,END_DATE,ATTRIBUTE_CATEGORY,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10,ATTRIBUTE11,ATTRIBUTE12,ATTRIBUTE13,ATTRIBUTE14,ATTRIBUTE15,BANK_ACCOUNT_NUM,BANK_ACCOUNT_CURRENCY_CODE,BANK_ACCOUNT_INACTIVE_DATE,BANK_ACCOUNT_DESCRIPTION,BANK_NAME,BANK_BRANCH_NAME,BANK_NUM,BANK_BRANCH_DESCRIPTI]')
|| TO_CLOB(q'[ON,BANK_BRANCH_ADDRESS1,BANK_BRANCH_ADDRESS2,BANK_BRANCH_ADDRESS3,BANK_BRANCH_CITY,BANK_BRANCH_STATE,BANK_BRANCH_ZIP,BANK_BRANCH_PROVINCE,BANK_BRANCH_COUNTRY,BANK_BRANCH_AREA_CODE,BANK_BRANCH_PHONE,BANK_ACCOUNT_ATT_CATEGORY,BANK_ACCOUNT_ATTRIBUTE1,BANK_ACCOUNT_ATTRIBUTE10,BANK_ACCOUNT_ATTRIBUTE11,BANK_ACCOUNT_ATTRIBUTE12,BANK_ACCOUNT_ATTRIBUTE13,BANK_ACCOUNT_ATTRIBUTE14,BANK_ACCOUNT_ATTRIBUTE15,BANK_ACCOUNT_ATTRIBUTE2,BANK_ACCOUNT_ATTRIBUTE3,BANK_ACCOUNT_ATTRIBUTE4,BANK_ACCOUNT_ATTRIBUTE5,BANK_A]')
|| TO_CLOB(q'[CCOUNT_ATTRIBUTE6,BANK_ACCOUNT_ATTRIBUTE7,BANK_ACCOUNT_ATTRIBUTE8,BANK_ACCOUNT_ATTRIBUTE9,BANK_BRANCH_ATT_CATEGORY,BANK_BRANCH_ATTRIBUTE1,BANK_BRANCH_ATTRIBUTE10,BANK_BRANCH_ATTRIBUTE11,BANK_BRANCH_ATTRIBUTE12,BANK_BRANCH_ATTRIBUTE13,BANK_BRANCH_ATTRIBUTE14,BANK_BRANCH_ATTRIBUTE15,BANK_BRANCH_ATTRIBUTE2,BANK_BRANCH_ATTRIBUTE3,BANK_BRANCH_ATTRIBUTE4,BANK_BRANCH_ATTRIBUTE5,BANK_BRANCH_ATTRIBUTE6,BANK_BRANCH_ATTRIBUTE7,BANK_BRANCH_ATTRIBUTE8,BANK_BRANCH_ATTRIBUTE9,BANK_NUMBER,BANK_BRANCH_ADDRESS4,B]')
|| TO_CLOB(q'[ANK_BRANCH_COUNTY,BANK_BRANCH_EFT_USER_NUMBER,BANK_ACCOUNT_CHECK_DIGITS,GLOBAL_ATTRIBUTE_CATEGORY,GLOBAL_ATTRIBUTE1,GLOBAL_ATTRIBUTE2,GLOBAL_ATTRIBUTE3,GLOBAL_ATTRIBUTE4,GLOBAL_ATTRIBUTE5,GLOBAL_ATTRIBUTE6,GLOBAL_ATTRIBUTE7,GLOBAL_ATTRIBUTE8,GLOBAL_ATTRIBUTE9,GLOBAL_ATTRIBUTE10,GLOBAL_ATTRIBUTE11,GLOBAL_ATTRIBUTE12,GLOBAL_ATTRIBUTE13,GLOBAL_ATTRIBUTE14,GLOBAL_ATTRIBUTE15,GLOBAL_ATTRIBUTE16,GLOBAL_ATTRIBUTE17,GLOBAL_ATTRIBUTE18,GLOBAL_ATTRIBUTE19,GLOBAL_ATTRIBUTE20,ORG_ID,BANK_HOME_COUNTRY,LOCALI]')
|| TO_CLOB(q'[NSTR,SERVICE_LEVEL,PURPOSE_CODE,BANK_CHARGE_BEARER_CODE,DEBIT_ADVICE_DELIVERY_METHOD,DEBIT_ADVICE_EMAIL,DEBIT_ADVICE_FAX,EFT_SWIFT_CODE,COUNTRY_CODE,FOREIGN_PAYMENT_USE_FLAG,PRIMARY_ACCT_OWNER_FLAG,BANK_ACCOUNT_NAME_ALT,BANK_ACCOUNT_TYPE,ACCOUNT_SUFFIX,AGENCY_LOCATION_CODE,IBAN]'));