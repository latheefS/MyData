LOAD DATA
append

INTO TABLE PO_LINES_INTERFACE
fields terminated by ',' optionally enclosed by '"' trailing nullcols
(INTERFACE_LINE_ID 		expression "po_lines_interface_s.nextval"
,CREATION_DATE                  expression "current_timestamp(1)"
,LAST_UPDATE_DATE               expression "current_timestamp(1)"
,CREATED_BY                   	constant '#CREATEDBY#'
,LAST_UPDATED_BY               	constant '#LASTUPDATEDBY#'
,LAST_UPDATE_LOGIN             	constant '#LASTUPDATELOGIN#'
,LOAD_REQUEST_ID        	CONSTANT '#LOADREQUESTID#'
,OBJECT_VERSION_NUMBER    	constant 1
--,CREATED_BY                   constant 1
--,LAST_UPDATED_BY              constant 1
--,LAST_UPDATE_LOGIN            constant 1
--,LOAD_REQUEST_ID              constant 1
,INTERFACE_LINE_KEY
,INTERFACE_HEADER_KEY
,ACTION
,LINE_NUM
,LINE_TYPE
,ITEM                           char(300)
,ITEM_DESCRIPTION		char(1000)
,ITEM_REVISION
,CATEGORY                       char(2000)
,COMMITTED_AMOUNT		"fun_load_interface_utils_pkg.replace_decimal_char(:COMMITTED_AMOUNT)"
,UNIT_OF_MEASURE
,UNIT_PRICE			"fun_load_interface_utils_pkg.replace_decimal_char(:UNIT_PRICE)"
,ALLOW_PRICE_OVERRIDE_FLAG
,NOT_TO_EXCEED_PRICE		"fun_load_interface_utils_pkg.replace_decimal_char(:NOT_TO_EXCEED_PRICE)"
,VENDOR_PRODUCT_NUM             char(300)
,NEGOTIATED_BY_PREPARER_FLAG
,NOTE_TO_VENDOR                 char(1000)
,NOTE_TO_RECEIVER               char(1000)
,MIN_RELEASE_AMOUNT		"fun_load_interface_utils_pkg.replace_decimal_char(:MIN_RELEASE_AMOUNT)"
,EXPIRATION_DATE		"to_date(:EXPIRATION_DATE, 'YYYY/MM/DD')"
,SUPPLIER_PART_AUXID                                                                                                                                                                      
,SUPPLIER_REF_NUMBER
,LINE_ATTRIBUTE_CATEGORY_LINES                                                                                                                                                   
,LINE_ATTRIBUTE1                                                                                                                                                                                                                                                                                                                                                    
,LINE_ATTRIBUTE2                                                                                                                                                                     
,LINE_ATTRIBUTE3                                                                                                                                                                       
,LINE_ATTRIBUTE4                                                                                                                                                                   
,LINE_ATTRIBUTE5                                                                                                                                                                      
,LINE_ATTRIBUTE6                                                                                                                                                                            
,LINE_ATTRIBUTE7                                                                                                                                                                           
,LINE_ATTRIBUTE8                                                                                                                                                                          
,LINE_ATTRIBUTE9
,LINE_ATTRIBUTE10                                                                                                                                                                       
,LINE_ATTRIBUTE11                                                                                                                                                                      
,LINE_ATTRIBUTE12                                                                                                                                                                        
,LINE_ATTRIBUTE13                                                                                                                                                                         
,LINE_ATTRIBUTE14                                                                                                                                                                          
,LINE_ATTRIBUTE15
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
,AGING_PERIOD_DAYS
,CONSIGNMENT_LINE_FLAG
,UNIT_WEIGHT
,WEIGHT_UOM_CODE
,WEIGHT_UNIT_OF_MEASURE
,UNIT_VOLUME
,VOLUME_UOM_CODE
,VOLUME_UNIT_OF_MEASURE
,TEMPLATE_NAME
,ITEM_ATTRIBUTE_CATEGORY
,ITEM_ATTRIBUTE1
,ITEM_ATTRIBUTE2
,ITEM_ATTRIBUTE3
,ITEM_ATTRIBUTE4
,ITEM_ATTRIBUTE5
,ITEM_ATTRIBUTE6
,ITEM_ATTRIBUTE7
,ITEM_ATTRIBUTE8
,ITEM_ATTRIBUTE9
,ITEM_ATTRIBUTE10
,ITEM_ATTRIBUTE11
,ITEM_ATTRIBUTE12
,ITEM_ATTRIBUTE13
,ITEM_ATTRIBUTE14
,ITEM_ATTRIBUTE15
,PARENT_ITEM                    char(300)
,TOP_MODEL                      char(300)
,SUPPLIER_PARENT_ITEM           char(300)
,SUPPLIER_TOP_MODEL             char(300)
,AMOUNT                         "fun_load_interface_utils_pkg.replace_decimal_char(:AMOUNT)"
,PRICE_BREAK_LOOKUP_CODE
,QUANTITY_COMMITTED 		
,ALLOW_DESCRIPTION_UPDATE_FLAG	char(4)
)     
