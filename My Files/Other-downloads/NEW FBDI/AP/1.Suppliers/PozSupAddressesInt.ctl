LOAD DATA
CHARACTERSET UTF8
LENGTH SEMANTICS CHAR
append
  
INTO TABLE POZ_SUP_ADDRESSES_INT
fields terminated by ',' optionally enclosed by '"' trailing nullcols
(ADDRESS_INTERFACE_ID		expression "POZ_SUP_ADDRESSES_INT_S.nextval"
,LAST_UPDATE_DATE               expression "current_timestamp(1)"
,CREATION_DATE                  expression "current_timestamp(1)"
,CREATED_BY                     constant '#CREATEDBY#'
,LAST_UPDATED_BY                constant '#LASTUPDATEDBY#'
,LAST_UPDATE_LOGIN              constant '#LASTUPDATELOGIN#'
,LOAD_REQUEST_ID                constant '#LOADREQUESTID#'
,OBJECT_VERSION_NUMBER          constant 1
,IMPORT_STATUS			constant "NEW"
,IMPORT_ACTION			"decode(:IMPORT_ACTION, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), :IMPORT_ACTION)"
,VENDOR_NAME	char(360)	"decode(:VENDOR_NAME, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), :VENDOR_NAME)"
,PARTY_SITE_NAME char(240)	"decode(:PARTY_SITE_NAME, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), :PARTY_SITE_NAME)"
,PARTY_SITE_NAME_NEW char(240)  "decode(:PARTY_SITE_NAME_NEW, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), :PARTY_SITE_NAME_NEW)"
,COUNTRY	char(60)     	"decode(:COUNTRY, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), :COUNTRY)"
,ADDRESS_LINE1	char(240)	"decode(:ADDRESS_LINE1, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), :ADDRESS_LINE1)"
,ADDRESS_LINE2	char(240)	"decode(:ADDRESS_LINE2, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), :ADDRESS_LINE2)"
,ADDRESS_LINE3	char(240)	"decode(:ADDRESS_LINE3, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), :ADDRESS_LINE3)"
,ADDRESS_LINE4	char(240)	"decode(:ADDRESS_LINE4, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), :ADDRESS_LINE4)"
,ADDRESS_LINES_PHONETIC	char(560)	"decode(:ADDRESS_LINES_PHONETIC,  '#NULL', POZ_UTIL.get_G_NULL_CHAR(), :ADDRESS_LINES_PHONETIC)"
,ADDR_ELEMENT_ATTRIBUTE1 char(150)	"decode(:ADDR_ELEMENT_ATTRIBUTE1, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), :ADDR_ELEMENT_ATTRIBUTE1)"
,ADDR_ELEMENT_ATTRIBUTE2 char(150)	"decode(:ADDR_ELEMENT_ATTRIBUTE2, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), :ADDR_ELEMENT_ATTRIBUTE2)"
,ADDR_ELEMENT_ATTRIBUTE3 char(150)	"decode(:ADDR_ELEMENT_ATTRIBUTE3, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), :ADDR_ELEMENT_ATTRIBUTE3)"
,ADDR_ELEMENT_ATTRIBUTE4 char(150)	"decode(:ADDR_ELEMENT_ATTRIBUTE4, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), :ADDR_ELEMENT_ATTRIBUTE4)"
,ADDR_ELEMENT_ATTRIBUTE5 char(150)	"decode(:ADDR_ELEMENT_ATTRIBUTE5, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), :ADDR_ELEMENT_ATTRIBUTE5)"
,BUILDING    char(240)	        "decode(:BUILDING, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), :BUILDING)"
,FLOOR_NUMBER	char(40)        "decode(:FLOOR_NUMBER, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), :FLOOR_NUMBER)"
,CITY		 char(60)       "decode(:CITY, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), :CITY)"
,STATE	char(60)                "decode(:STATE, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), :STATE)"
,PROVINCE  char(60)	        "decode(:PROVINCE, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), :PROVINCE)"
,COUNTY	  char(60)              "decode(:COUNTY, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), :COUNTY)"
,POSTAL_CODE	char(60)        "decode(:POSTAL_CODE, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), :POSTAL_CODE)"
,POSTAL_PLUS4_CODE  char(10)	"decode(:POSTAL_PLUS4_CODE, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), :POSTAL_PLUS4_CODE)"
,ADDRESSEE	char(360)       "decode(:ADDRESSEE, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), :ADDRESSEE)"
,GLOBAL_LOCATION_NUMBER	 char(40) "decode(:GLOBAL_LOCATION_NUMBER, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), :GLOBAL_LOCATION_NUMBER)"
,PARTY_SITE_LANGUAGE  char(4)	"decode(:PARTY_SITE_LANGUAGE, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), :PARTY_SITE_LANGUAGE)"
,INACTIVE_DATE			"decode(:INACTIVE_DATE, '#NULL', POZ_UTIL.get_G_NULL_DATE(), to_date(:INACTIVE_DATE, 'YYYY/MM/DD'))"
,PHONE_COUNTRY_CODE char(10)	"decode(:PHONE_COUNTRY_CODE, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), :PHONE_COUNTRY_CODE)"
,PHONE_AREA_CODE char(10)	"decode(:PHONE_AREA_CODE, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), :PHONE_AREA_CODE)"
,PHONE		char(40)	"decode(:PHONE, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), :PHONE)"
,PHONE_EXTENSION char(20)	"decode(:PHONE_EXTENSION, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), :PHONE_EXTENSION)"
,FAX_COUNTRY_CODE  char(10)	"decode(:FAX_COUNTRY_CODE, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), :FAX_COUNTRY_CODE)"
,FAX_AREA_CODE	char(10)	"decode(:FAX_AREA_CODE, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), :FAX_AREA_CODE)"
,FAX		char(40) 	"decode(:FAX, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), :FAX)"
,RFQ_OR_BIDDING_PURPOSE_FLAG  char(1)  "decode(:RFQ_OR_BIDDING_PURPOSE_FLAG, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), :RFQ_OR_BIDDING_PURPOSE_FLAG)"
,ORDERING_PURPOSE_FLAG	char(1)	"decode(:ORDERING_PURPOSE_FLAG, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), :ORDERING_PURPOSE_FLAG)"
,REMIT_TO_PURPOSE_FLAG	char(1)	"decode(:REMIT_TO_PURPOSE_FLAG, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), :REMIT_TO_PURPOSE_FLAG)"
,ATTRIBUTE_CATEGORY char(30)	"decode(:ATTRIBUTE_CATEGORY, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), :ATTRIBUTE_CATEGORY)"
,ATTRIBUTE1		char(150)	"decode(:ATTRIBUTE1, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), (:ATTRIBUTE1))"
,ATTRIBUTE2 		char(150)	"decode(:ATTRIBUTE2, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), (:ATTRIBUTE2))"
,ATTRIBUTE3 		char(150)	"decode(:ATTRIBUTE3, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), (:ATTRIBUTE3))"
,ATTRIBUTE4		char(150)	"decode(:ATTRIBUTE4, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), (:ATTRIBUTE4))"
,ATTRIBUTE5		char(150)	"decode(:ATTRIBUTE5, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), (:ATTRIBUTE5))"
,ATTRIBUTE6		char(150)	"decode(:ATTRIBUTE6, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), (:ATTRIBUTE6))"
,ATTRIBUTE7		char(150)	"decode(:ATTRIBUTE7, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), (:ATTRIBUTE7))"
,ATTRIBUTE8		char(150)	"decode(:ATTRIBUTE8, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), (:ATTRIBUTE8))"
,ATTRIBUTE9		char(150)	"decode(:ATTRIBUTE9, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), (:ATTRIBUTE9))"
,ATTRIBUTE10		char(150)	"decode(:ATTRIBUTE10, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), (:ATTRIBUTE10))"
,ATTRIBUTE11		char(150)	"decode(:ATTRIBUTE11, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), (:ATTRIBUTE11))"
,ATTRIBUTE12		char(150)	"decode(:ATTRIBUTE12, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), (:ATTRIBUTE12))"
,ATTRIBUTE13		char(150)	"decode(:ATTRIBUTE13, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), (:ATTRIBUTE13))"
,ATTRIBUTE14		char(150)	"decode(:ATTRIBUTE14, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), (:ATTRIBUTE14))"
,ATTRIBUTE15		char(150)	"decode(:ATTRIBUTE15, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), (:ATTRIBUTE15))"
,ATTRIBUTE16		char(150)	"decode(:ATTRIBUTE16, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), (:ATTRIBUTE16))"
,ATTRIBUTE17		char(150)	"decode(:ATTRIBUTE17, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), (:ATTRIBUTE17))"
,ATTRIBUTE18		char(150)	"decode(:ATTRIBUTE18, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), (:ATTRIBUTE18))"
,ATTRIBUTE19		char(150)	"decode(:ATTRIBUTE19, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), (:ATTRIBUTE19))"
,ATTRIBUTE20		char(150)	"decode(:ATTRIBUTE20, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), (:ATTRIBUTE20))"
,ATTRIBUTE21		char(150)	"decode(:ATTRIBUTE21, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), (:ATTRIBUTE21))"
,ATTRIBUTE22		char(150)	"decode(:ATTRIBUTE22, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), (:ATTRIBUTE22))"
,ATTRIBUTE23		char(150)	"decode(:ATTRIBUTE23, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), (:ATTRIBUTE23))"
,ATTRIBUTE24		char(150)	"decode(:ATTRIBUTE24, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), (:ATTRIBUTE24))"
,ATTRIBUTE25		char(150)	"decode(:ATTRIBUTE25, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), (:ATTRIBUTE25))"
,ATTRIBUTE26		char(150)	"decode(:ATTRIBUTE26, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), (:ATTRIBUTE26))"
,ATTRIBUTE27		char(150)	"decode(:ATTRIBUTE27, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), (:ATTRIBUTE27))"
,ATTRIBUTE28		char(150)	"decode(:ATTRIBUTE28, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), (:ATTRIBUTE28))"
,ATTRIBUTE29		char(150)	"decode(:ATTRIBUTE29, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), (:ATTRIBUTE29))"
,ATTRIBUTE30		char(255)	"decode(:ATTRIBUTE30, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), (:ATTRIBUTE30))"
,ATTRIBUTE_NUMBER1		"decode(:ATTRIBUTE_NUMBER1, '#NULL', POZ_UTIL.get_G_NULL_NUM9(), :ATTRIBUTE_NUMBER1)"
,ATTRIBUTE_NUMBER2  		"decode(:ATTRIBUTE_NUMBER2, '#NULL', POZ_UTIL.get_G_NULL_NUM9(), :ATTRIBUTE_NUMBER2)"
,ATTRIBUTE_NUMBER3		"decode(:ATTRIBUTE_NUMBER3, '#NULL', POZ_UTIL.get_G_NULL_NUM9(), :ATTRIBUTE_NUMBER3)"
,ATTRIBUTE_NUMBER4		"decode(:ATTRIBUTE_NUMBER4, '#NULL', POZ_UTIL.get_G_NULL_NUM9(), :ATTRIBUTE_NUMBER4)"
,ATTRIBUTE_NUMBER5		"decode(:ATTRIBUTE_NUMBER5, '#NULL', POZ_UTIL.get_G_NULL_NUM9(), :ATTRIBUTE_NUMBER5)"
,ATTRIBUTE_NUMBER6		"decode(:ATTRIBUTE_NUMBER6, '#NULL', POZ_UTIL.get_G_NULL_NUM9(), :ATTRIBUTE_NUMBER6)"
,ATTRIBUTE_NUMBER7		"decode(:ATTRIBUTE_NUMBER7, '#NULL', POZ_UTIL.get_G_NULL_NUM9(), :ATTRIBUTE_NUMBER7)"
,ATTRIBUTE_NUMBER8		"decode(:ATTRIBUTE_NUMBER8, '#NULL', POZ_UTIL.get_G_NULL_NUM9(), :ATTRIBUTE_NUMBER8)"
,ATTRIBUTE_NUMBER9		"decode(:ATTRIBUTE_NUMBER9, '#NULL', POZ_UTIL.get_G_NULL_NUM9(), :ATTRIBUTE_NUMBER9)"
,ATTRIBUTE_NUMBER10		"decode(:ATTRIBUTE_NUMBER10, '#NULL', POZ_UTIL.get_G_NULL_NUM9(), :ATTRIBUTE_NUMBER10)"
,ATTRIBUTE_NUMBER11		"decode(:ATTRIBUTE_NUMBER11, '#NULL', POZ_UTIL.get_G_NULL_NUM9(), :ATTRIBUTE_NUMBER11)"
,ATTRIBUTE_NUMBER12		"decode(:ATTRIBUTE_NUMBER12, '#NULL', POZ_UTIL.get_G_NULL_NUM9(), :ATTRIBUTE_NUMBER12)"
,ATTRIBUTE_DATE1                "decode(:ATTRIBUTE_DATE1, '#NULL', POZ_UTIL.get_G_NULL_DATE(), to_date(:ATTRIBUTE_DATE1, 'YYYY/MM/DD'))"
,ATTRIBUTE_DATE2		"decode(:ATTRIBUTE_DATE2, '#NULL', POZ_UTIL.get_G_NULL_DATE(), to_date(:ATTRIBUTE_DATE2, 'YYYY/MM/DD'))"
,ATTRIBUTE_DATE3		"decode(:ATTRIBUTE_DATE3, '#NULL', POZ_UTIL.get_G_NULL_DATE(), to_date(:ATTRIBUTE_DATE3, 'YYYY/MM/DD'))"
,ATTRIBUTE_DATE4		"decode(:ATTRIBUTE_DATE4, '#NULL', POZ_UTIL.get_G_NULL_DATE(), to_date(:ATTRIBUTE_DATE4, 'YYYY/MM/DD'))"
,ATTRIBUTE_DATE5		"decode(:ATTRIBUTE_DATE5, '#NULL', POZ_UTIL.get_G_NULL_DATE(), to_date(:ATTRIBUTE_DATE5, 'YYYY/MM/DD'))"
,ATTRIBUTE_DATE6		"decode(:ATTRIBUTE_DATE6, '#NULL', POZ_UTIL.get_G_NULL_DATE(), to_date(:ATTRIBUTE_DATE6, 'YYYY/MM/DD'))"
,ATTRIBUTE_DATE7		"decode(:ATTRIBUTE_DATE7, '#NULL', POZ_UTIL.get_G_NULL_DATE(), to_date(:ATTRIBUTE_DATE7, 'YYYY/MM/DD'))"
,ATTRIBUTE_DATE8		"decode(:ATTRIBUTE_DATE8, '#NULL', POZ_UTIL.get_G_NULL_DATE(), to_date(:ATTRIBUTE_DATE8, 'YYYY/MM/DD'))"
,ATTRIBUTE_DATE9		"decode(:ATTRIBUTE_DATE9, '#NULL', POZ_UTIL.get_G_NULL_DATE(), to_date(:ATTRIBUTE_DATE9, 'YYYY/MM/DD'))"
,ATTRIBUTE_DATE10		"decode(:ATTRIBUTE_DATE10, '#NULL', POZ_UTIL.get_G_NULL_DATE(),to_date(:ATTRIBUTE_DATE10, 'YYYY/MM/DD'))"
,ATTRIBUTE_DATE11		"decode(:ATTRIBUTE_DATE11, '#NULL', POZ_UTIL.get_G_NULL_DATE(),to_date(:ATTRIBUTE_DATE11, 'YYYY/MM/DD'))"
,ATTRIBUTE_DATE12		"decode(:ATTRIBUTE_DATE12, '#NULL', POZ_UTIL.get_G_NULL_DATE(),to_date(:ATTRIBUTE_DATE12, 'YYYY/MM/DD'))"
,EMAIL_ADDRESS    char(320)     "decode(:EMAIL_ADDRESS , '#NULL', POZ_UTIL.get_G_NULL_CHAR(), :EMAIL_ADDRESS)"				
,BATCH_ID	char(200)		"trim(:BATCH_ID)"
,DELIVERY_CHANNEL_CODE	char(30)      "decode(:DELIVERY_CHANNEL_CODE, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), :DELIVERY_CHANNEL_CODE)"
,BANK_INSTRUCTION1_CODE	  char(30)     "decode(:BANK_INSTRUCTION1_CODE, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), :BANK_INSTRUCTION1_CODE)"
,BANK_INSTRUCTION2_CODE	  char(30)    "decode(:BANK_INSTRUCTION2_CODE, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), :BANK_INSTRUCTION2_CODE)"
,BANK_INSTRUCTION_DETAILS   char(255)   "decode(:BANK_INSTRUCTION_DETAILS, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), :BANK_INSTRUCTION_DETAILS)"	 
,SETTLEMENT_PRIORITY	char(30)      "decode(:SETTLEMENT_PRIORITY, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), :SETTLEMENT_PRIORITY)"
,PAYMENT_TEXT_MESSAGE1   char(256)      "decode(:PAYMENT_TEXT_MESSAGE1, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), :PAYMENT_TEXT_MESSAGE1)"    
,PAYMENT_TEXT_MESSAGE2	 char(256)      "decode(:PAYMENT_TEXT_MESSAGE2, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), :PAYMENT_TEXT_MESSAGE2)"
,PAYMENT_TEXT_MESSAGE3	 char(256)      "decode(:PAYMENT_TEXT_MESSAGE3, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), :PAYMENT_TEXT_MESSAGE3)"
,SERVICE_LEVEL_CODE   char(30)     "decode(:SERVICE_LEVEL_CODE, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), :SERVICE_LEVEL_CODE)"
,EXCLUSIVE_PAYMENT_FLAG  char(1)   "decode(:EXCLUSIVE_PAYMENT_FLAG, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), :EXCLUSIVE_PAYMENT_FLAG)" 
,IBY_BANK_CHARGE_BEARER   char(30)    "decode(:IBY_BANK_CHARGE_BEARER, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), :IBY_BANK_CHARGE_BEARER)" 	
,PAYMENT_REASON_CODE	  char(30)    "decode(:PAYMENT_REASON_CODE, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), :PAYMENT_REASON_CODE)" 
,PAYMENT_REASON_COMMENTS  char(240)    "decode(:PAYMENT_REASON_COMMENTS, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), :PAYMENT_REASON_COMMENTS)"
,REMIT_ADVICE_DELIVERY_METHOD  char(30) "decode(:REMIT_ADVICE_DELIVERY_METHOD, '#NULL', POZ_UTIL.get_G_NULL_CHAR(),:REMIT_ADVICE_DELIVERY_METHOD)"
,REMIT_ADVICE_EMAIL  char(255)      "decode(:REMIT_ADVICE_EMAIL, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), :REMIT_ADVICE_EMAIL)"
,REMIT_ADVICE_FAX    char(100)      "decode(:REMIT_ADVICE_FAX, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), :REMIT_ADVICE_FAX)"
)