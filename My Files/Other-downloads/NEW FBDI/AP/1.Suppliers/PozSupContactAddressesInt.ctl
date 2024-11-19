LOAD DATA
CHARACTERSET UTF8
LENGTH SEMANTICS CHAR
append
  
INTO TABLE POZ_SUP_CONTACT_ADDRESSES_INT
fields terminated by ',' optionally enclosed by '"' trailing nullcols
(CONTACT_ADDRESS_INTERFACE_ID  	expression "POZ_SUP_CONTACT_ADDRESS_INT_S.nextval" 
,LAST_UPDATE_DATE               expression "current_timestamp(1)"
,CREATION_DATE                  expression "current_timestamp(1)"
,CREATED_BY                     constant '#CREATEDBY#'
,LAST_UPDATED_BY                constant '#LASTUPDATEDBY#'
,LAST_UPDATE_LOGIN              constant '#LASTUPDATELOGIN#'
,LOAD_REQUEST_ID                constant '#LOADREQUESTID#'
,OBJECT_VERSION_NUMBER          constant 1
,IMPORT_STATUS                  constant NEW
,IMPORT_ACTION       char(10)    	"decode(:IMPORT_ACTION, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), :IMPORT_ACTION)"      
,VENDOR_NAME      char(360)              "decode(:VENDOR_NAME, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), :VENDOR_NAME)" 
,PARTY_SITE_NAME    char(240)            "decode(:PARTY_SITE_NAME, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), :PARTY_SITE_NAME)"
,FIRST_NAME       char(150)              "decode(:FIRST_NAME, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), :FIRST_NAME)"
,LAST_NAME         char(150)             "decode(:LAST_NAME, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), :LAST_NAME)"
,EMAIL_ADDRESS   char(320)               "decode(:EMAIL_ADDRESS, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), :EMAIL_ADDRESS)"
,BATCH_ID         char(200)              "trim(:BATCH_ID)"

)
