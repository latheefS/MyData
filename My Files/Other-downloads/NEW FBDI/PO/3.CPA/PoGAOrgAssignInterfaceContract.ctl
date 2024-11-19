LOAD DATA
append

INTO TABLE po_ga_org_assign_interface 
fields terminated by ',' optionally enclosed by '"' trailing nullcols
(INTERFACE_ASSIGNMENT_ID 	expression "po_ga_org_assign_interface_s.nextval"
,CREATION_DATE                  expression "current_timestamp(1)"
,LAST_UPDATE_DATE               expression "current_timestamp(1)"
,CREATED_BY                   	constant '#CREATEDBY#'
,LAST_UPDATED_BY               	constant '#LASTUPDATEDBY#'
,LAST_UPDATE_LOGIN             	constant '#LASTUPDATELOGIN#'
,LOAD_REQUEST_ID        	constant '#LOADREQUESTID#'
,OBJECT_VERSION_NUMBER    	constant 1
--,CREATED_BY                     constant 1
--,LAST_UPDATED_BY                constant 1
--,LAST_UPDATE_LOGIN              constant 1
--,LOAD_REQUEST_ID                constant 1
,INTERFACE_BU_ASSIGNMENT_KEY
,INTERFACE_HEADER_KEY
,REQ_BU_NAME
,ORDERED_LOCALLY_FLAG
,VENDOR_SITE_CODE                 char(240)                 
,SHIP_TO_LOCATION
,BILL_TO_BU_NAME
,BILL_TO_LOCATION
,ENABLED_FLAG
)
