LOAD DATA
append
 
INTO TABLE po_attr_values_tlp_interface
fields terminated by ',' optionally enclosed by '"' trailing nullcols
(INTERFACE_ATTR_VALUES_TLP_ID 	expression "PO_ATTR_VALUES_TLP_INTERFACE_S.nextval"
,CREATION_DATE                  expression "current_timestamp(1)"
,LAST_UPDATE_DATE               expression "current_timestamp(1)"
,CREATED_BY                   	constant '#CREATEDBY#'
,LAST_UPDATED_BY               	constant '#LASTUPDATEDBY#'
,LAST_UPDATE_LOGIN             	constant '#LASTUPDATELOGIN#'
,LOAD_REQUEST_ID        		    constant '#LOADREQUESTID#'
,OBJECT_VERSION_NUMBER    		  constant 1
,INTERFACE_ATTRIBUTE_TLP_KEY
,INTERFACE_LINE_KEY
,DESCRIPTION					          char(240)
,MANUFACTURER					          char(700)
,ALIAS							            char(700)
,COMMENTS						            char(700)
,LONG_DESCRIPTION			        	char(4000)
,LANGUAGE						            char(10)
)
