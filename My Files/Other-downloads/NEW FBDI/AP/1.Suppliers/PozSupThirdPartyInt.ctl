LOAD DATA
CHARACTERSET UTF8
LENGTH SEMANTICS CHAR
append

INTO TABLE POZ_SUP_THIRDPARTY_INT
fields terminated by ',' optionally enclosed by '"' trailing nullcols
(THIRDPARTY_REL_INTERFACE_ID   		expression "POZ_SUP_THIRDPARTY_INT_S.nextval"
,LOAD_REQUEST_ID                	constant  '#LOADREQUESTID#'
,CREATION_DATE                  	expression "current_timestamp(1)"
,CREATED_BY                     	constant '#CREATEDBY#'
,LAST_UPDATE_DATE               	expression "current_timestamp(1)"
,LAST_UPDATED_BY                	constant '#LASTUPDATEDBY#'
,LAST_UPDATE_LOGIN              	constant '#LASTUPDATELOGIN#'
,OBJECT_VERSION_NUMBER          	constant 1
,IMPORT_STATUS                  	constant "NEW"
,BATCH_ID            char(200)           	"decode(:BATCH_ID,'#NULL',null,trim(:BATCH_ID))"
,IMPORT_ACTION      char(10)          		"decode(:IMPORT_ACTION, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), :IMPORT_ACTION)"
,VENDOR_NAME        char(360)          	"decode(:VENDOR_NAME, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), :VENDOR_NAME)"
,VENDOR_SITE_CODE    char(240)         		"decode(:VENDOR_SITE_CODE, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), :VENDOR_SITE_CODE)"
,PROCUREMENT_BUSINESS_UNIT_NAME  char(240)	"decode(:PROCUREMENT_BUSINESS_UNIT_NAME, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), :PROCUREMENT_BUSINESS_UNIT_NAME)"
,DEFAULT_RELATIONSHIP_FLAG  	char(1)	"decode(:DEFAULT_RELATIONSHIP_FLAG, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), :DEFAULT_RELATIONSHIP_FLAG)"
,REMIT_TO_SUPPLIER  	char(360)	"decode(:REMIT_TO_SUPPLIER, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), :REMIT_TO_SUPPLIER)"
,REMIT_TO_ADDRESS  	char(240)		"decode(:REMIT_TO_ADDRESS, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), :REMIT_TO_ADDRESS)"
,FROM_DATE  				"decode(:FROM_DATE, '#NULL', POZ_UTIL.get_G_NULL_DATE(), to_date(:FROM_DATE, 'YYYY/MM/DD'))"
,TO_DATE  				"decode(:TO_DATE, '#NULL', POZ_UTIL.get_G_NULL_DATE(), to_date(:TO_DATE, 'YYYY/MM/DD'))"
,DESCRIPTION         char(1000)          "decode(:DESCRIPTION, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), :DESCRIPTION)"
)

