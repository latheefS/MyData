LOAD DATA
CHARACTERSET UTF8
LENGTH SEMANTICS CHAR
append
 
INTO TABLE POZ_SITE_ASSIGNMENTS_INT
fields terminated by ',' optionally enclosed by '"' trailing nullcols
(ASSIGNMENT_INTERFACE_ID     expression "POZ_SITE_ASSIGNMENTS_INT_S.nextval" 
,LAST_UPDATE_DATE   expression "current_timestamp(1)"
,CREATION_DATE      expression "current_timestamp(1)"
,CREATED_BY                     constant '#CREATEDBY#'
,LAST_UPDATED_BY                constant '#LASTUPDATEDBY#'
,LAST_UPDATE_LOGIN              constant '#LASTUPDATELOGIN#'
,LOAD_REQUEST_ID                constant '#LOADREQUESTID#'
,OBJECT_VERSION_NUMBER          constant 1        
,STATUS                         constant "NEW" 
,IMPORT_ACTION        char(10)          "trim(decode(:IMPORT_ACTION, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), :IMPORT_ACTION))" 
,VENDOR_NAME      char(360)     "trim(decode(:VENDOR_NAME, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), :VENDOR_NAME))"
,VENDOR_SITE_CODE      char(240)         "trim(decode(:VENDOR_SITE_CODE, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), :VENDOR_SITE_CODE))"
,PROCUREMENT_BUSINESS_UNIT_NAME  char(240) "trim(decode(:PROCUREMENT_BUSINESS_UNIT_NAME, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), :PROCUREMENT_BUSINESS_UNIT_NAME))"
,BUSINESS_UNIT_NAME   char(240)          "trim(decode(:BUSINESS_UNIT_NAME, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), :BUSINESS_UNIT_NAME))"
,BILL_TO_BU_NAME    char(240)            "trim(decode(:BILL_TO_BU_NAME, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), :BILL_TO_BU_NAME))"
,SHIP_TO_LOCATION_CODE   char(60)       "trim(decode(:SHIP_TO_LOCATION_CODE, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), :SHIP_TO_LOCATION_CODE))"
,BILL_TO_LOCATION_CODE   char(60)       "trim(decode(:BILL_TO_LOCATION_CODE, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), :BILL_TO_LOCATION_CODE))"
,ALLOW_AWT_FLAG     char(1)            "trim(decode(:ALLOW_AWT_FLAG, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), :ALLOW_AWT_FLAG))"   
,AWT_GROUP_NAME       char(30)          "trim(decode(:AWT_GROUP_NAME, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), :AWT_GROUP_NAME))"
,ACCTS_PAY_CONCAT_SEGMENTS char(800)    "trim(decode(:ACCTS_PAY_CONCAT_SEGMENTS, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), :ACCTS_PAY_CONCAT_SEGMENTS))"       
,PREPAY_CONCAT_SEGMENTS    char(800)      "trim(decode(:PREPAY_CONCAT_SEGMENTS, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), :PREPAY_CONCAT_SEGMENTS))"
,FUTURE_DATED_CONCAT_SEGMENTS char(800)  "trim(decode(:FUTURE_DATED_CONCAT_SEGMENTS, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), :FUTURE_DATED_CONCAT_SEGMENTS))"
,DISTRIBUTION_SET_NAME     char(50)     "trim(decode(:DISTRIBUTION_SET_NAME, '#NULL', POZ_UTIL.get_G_NULL_CHAR(), :DISTRIBUTION_SET_NAME))"
,INACTIVE_DATE                  "decode(:INACTIVE_DATE, '#NULL', POZ_UTIL.get_G_NULL_DATE(), to_date(:INACTIVE_DATE, 'YYYY/MM/DD'))"
,BATCH_ID	char(200)		"trim(:BATCH_ID)"
)
