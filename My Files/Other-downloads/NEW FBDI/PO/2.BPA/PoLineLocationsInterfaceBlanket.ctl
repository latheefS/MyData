LOAD DATA
append

INTO TABLE PO_LINE_LOCATIONS_INTERFACE
fields terminated by ',' optionally enclosed by '"' trailing nullcols
(INTERFACE_LINE_LOCATION_ID 	expression "po_line_locations_interface_s.nextval"
,CREATION_DATE                  expression "current_timestamp(1)"
,LAST_UPDATE_DATE               expression "current_timestamp(1)"
,CREATED_BY                   	constant '#CREATEDBY#'
,LAST_UPDATED_BY               	constant '#LASTUPDATEDBY#'
,LAST_UPDATE_LOGIN             	constant '#LASTUPDATELOGIN#'
,LOAD_REQUEST_ID        	constant '#LOADREQUESTID#'
,OBJECT_VERSION_NUMBER    	constant 1
--,CREATED_BY                   constant 1
--,LAST_UPDATED_BY              constant 1
--,LAST_UPDATE_LOGIN            constant 1
--,LOAD_REQUEST_ID              constant 1
,INTERFACE_LINE_LOCATION_KEY
,INTERFACE_LINE_KEY
,SHIPMENT_NUM
,SHIP_TO_LOCATION
,SHIP_TO_ORGANIZATION_CODE
,QUANTITY			"fun_load_interface_utils_pkg.replace_decimal_char(:QUANTITY)"
,PRICE_OVERRIDE			"fun_load_interface_utils_pkg.replace_decimal_char(:PRICE_OVERRIDE)"
,PRICE_DISCOUNT			"fun_load_interface_utils_pkg.replace_decimal_char(:PRICE_DISCOUNT)"
,START_DATE			"to_date(:START_DATE, 'YYYY/MM/DD')"
,END_DATE			"to_date(:END_DATE, 'YYYY/MM/DD')"
,ATTRIBUTE_CATEGORY
,ATTRIBUTE1                                                                                                                                                                                                                                                                                                                                                      
,ATTRIBUTE2                                                                                                                                                                                                                                                                                                                                                       
,ATTRIBUTE3                                                                                                                                                                            
,ATTRIBUTE4                                                                                                                                                                            
,ATTRIBUTE5                                                                                                                                                                           
,ATTRIBUTE6
,ATTRIBUTE7                                                                                                                                                                           
,ATTRIBUTE8                                                                                                                                                                            
,ATTRIBUTE9  
,ATTRIBUTE10                                                                                                                                                                          
,ATTRIBUTE11                                                                                                                                                                         
,ATTRIBUTE12                                                                                                                                                                           
,ATTRIBUTE13                                                                                                                                                                            
,ATTRIBUTE14                                                                                                                                                                      
,ATTRIBUTE15                                                                                                                                                                          
,ATTRIBUTE16                                                                                                                                                                            
,ATTRIBUTE17                                                                                                                                                                            
,ATTRIBUTE18                                                                                                                                                                           
,ATTRIBUTE19 
,ATTRIBUTE20                                                                                                                                                                            
,ATTRIBUTE_DATE1		"to_date(:ATTRIBUTE_DATE1, 'YYYY/MM/DD')"
,ATTRIBUTE_DATE2		"to_date(:ATTRIBUTE_DATE2, 'YYYY/MM/DD')"
,ATTRIBUTE_DATE3		"to_date(:ATTRIBUTE_DATE3, 'YYYY/MM/DD')"
,ATTRIBUTE_DATE4		"to_date(:ATTRIBUTE_DATE4, 'YYYY/MM/DD')"
,ATTRIBUTE_DATE5		"to_date(:ATTRIBUTE_DATE5, 'YYYY/MM/DD')"
,ATTRIBUTE_DATE6		"to_date(:ATTRIBUTE_DATE6, 'YYYY/MM/DD')"
,ATTRIBUTE_DATE7		"to_date(:ATTRIBUTE_DATE7, 'YYYY/MM/DD')"
,ATTRIBUTE_DATE8		"to_date(:ATTRIBUTE_DATE8, 'YYYY/MM/DD')"
,ATTRIBUTE_DATE9		"to_date(:ATTRIBUTE_DATE9, 'YYYY/MM/DD')"
,ATTRIBUTE_DATE10		"to_date(:ATTRIBUTE_DATE10, 'YYYY/MM/DD')"
,ATTRIBUTE_NUMBER1		"fun_load_interface_utils_pkg.replace_decimal_char(:ATTRIBUTE_NUMBER1)"
,ATTRIBUTE_NUMBER2		"fun_load_interface_utils_pkg.replace_decimal_char(:ATTRIBUTE_NUMBER2)"
,ATTRIBUTE_NUMBER3		"fun_load_interface_utils_pkg.replace_decimal_char(:ATTRIBUTE_NUMBER3)"
,ATTRIBUTE_NUMBER4		"fun_load_interface_utils_pkg.replace_decimal_char(:ATTRIBUTE_NUMBER4)"
,ATTRIBUTE_NUMBER5		"fun_load_interface_utils_pkg.replace_decimal_char(:ATTRIBUTE_NUMBER5)"
,ATTRIBUTE_NUMBER6		"fun_load_interface_utils_pkg.replace_decimal_char(:ATTRIBUTE_NUMBER6)"
,ATTRIBUTE_NUMBER7		"fun_load_interface_utils_pkg.replace_decimal_char(:ATTRIBUTE_NUMBER7)"
,ATTRIBUTE_NUMBER8		"fun_load_interface_utils_pkg.replace_decimal_char(:ATTRIBUTE_NUMBER8)"
,ATTRIBUTE_NUMBER9		"fun_load_interface_utils_pkg.replace_decimal_char(:ATTRIBUTE_NUMBER9)"
,ATTRIBUTE_NUMBER10		"fun_load_interface_utils_pkg.replace_decimal_char(:ATTRIBUTE_NUMBER10)"
,ATTRIBUTE_TIMESTAMP1		"to_timestamp(:ATTRIBUTE_TIMESTAMP1, 'YYYY/MM/DD HH24:MI:SS:FF')"
,ATTRIBUTE_TIMESTAMP2		"to_timestamp(:ATTRIBUTE_TIMESTAMP2, 'YYYY/MM/DD HH24:MI:SS:FF')"
,ATTRIBUTE_TIMESTAMP3		"to_timestamp(:ATTRIBUTE_TIMESTAMP3, 'YYYY/MM/DD HH24:MI:SS:FF')"
,ATTRIBUTE_TIMESTAMP4		"to_timestamp(:ATTRIBUTE_TIMESTAMP4, 'YYYY/MM/DD HH24:MI:SS:FF')"
,ATTRIBUTE_TIMESTAMP5		"to_timestamp(:ATTRIBUTE_TIMESTAMP5, 'YYYY/MM/DD HH24:MI:SS:FF')"
,ATTRIBUTE_TIMESTAMP6		"to_timestamp(:ATTRIBUTE_TIMESTAMP6, 'YYYY/MM/DD HH24:MI:SS:FF')"
,ATTRIBUTE_TIMESTAMP7		"to_timestamp(:ATTRIBUTE_TIMESTAMP7, 'YYYY/MM/DD HH24:MI:SS:FF')"
,ATTRIBUTE_TIMESTAMP8		"to_timestamp(:ATTRIBUTE_TIMESTAMP8, 'YYYY/MM/DD HH24:MI:SS:FF')"
,ATTRIBUTE_TIMESTAMP9		"to_timestamp(:ATTRIBUTE_TIMESTAMP9, 'YYYY/MM/DD HH24:MI:SS:FF')"
,ATTRIBUTE_TIMESTAMP10		"to_timestamp(:ATTRIBUTE_TIMESTAMP10, 'YYYY/MM/DD HH24:MI:SS:FF')"
)
