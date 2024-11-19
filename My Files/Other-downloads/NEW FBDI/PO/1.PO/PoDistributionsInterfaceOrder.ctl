LOAD DATA
append

INTO TABLE PO_DISTRIBUTIONS_INTERFACE
fields terminated by ',' optionally enclosed by '"' trailing nullcols
(INTERFACE_DISTRIBUTION_ID 	expression "po_distributions_interface_s.nextval"
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
,INTERFACE_DISTRIBUTION_KEY
,INTERFACE_LINE_LOCATION_KEY
,DISTRIBUTION_NUM
,DELIVER_TO_LOCATION                                                                                                                                                                          
,DELIVER_TO_PERSON_FULL_NAME    char(2000)            
,DESTINATION_SUBINVENTORY
,AMOUNT_ORDERED			"fun_load_interface_utils_pkg.replace_decimal_char(:AMOUNT_ORDERED)"
,SHIPPING_UOM_QUANTITY		"fun_load_interface_utils_pkg.replace_decimal_char(:SHIPPING_UOM_QUANTITY)"
,CHARGE_ACCOUNT_SEGMENT1                                                                                                                                                                                                                                                                                                                                                        
,CHARGE_ACCOUNT_SEGMENT2                                                                                                                                                                                                                                                                                                                                                         
,CHARGE_ACCOUNT_SEGMENT3                                                                                                                                                                                                                                                                                                                                                       
,CHARGE_ACCOUNT_SEGMENT4                                                                                                                                                                          
,CHARGE_ACCOUNT_SEGMENT5                                                                                                                                                                   
,CHARGE_ACCOUNT_SEGMENT6                                                                                                                                                                      
,CHARGE_ACCOUNT_SEGMENT7                                                                                                                                                                           
,CHARGE_ACCOUNT_SEGMENT8                                                                                                                                                                           
,CHARGE_ACCOUNT_SEGMENT9
,CHARGE_ACCOUNT_SEGMENT10                                                                                                                                                                            
,CHARGE_ACCOUNT_SEGMENT11
,CHARGE_ACCOUNT_SEGMENT12                                                                                                                                                                             
,CHARGE_ACCOUNT_SEGMENT13
,CHARGE_ACCOUNT_SEGMENT14                                                                                                                                                                          
,CHARGE_ACCOUNT_SEGMENT15                                                                                                                                                                          
,CHARGE_ACCOUNT_SEGMENT16
,CHARGE_ACCOUNT_SEGMENT17                                                                                                                                                                           
,CHARGE_ACCOUNT_SEGMENT18                                                                                                                                                                             
,CHARGE_ACCOUNT_SEGMENT19
,CHARGE_ACCOUNT_SEGMENT20
,CHARGE_ACCOUNT_SEGMENT21                                                                                                                                                                           
,CHARGE_ACCOUNT_SEGMENT22                                                                                                                                                                          
,CHARGE_ACCOUNT_SEGMENT23                                                                                                                                                                            
,CHARGE_ACCOUNT_SEGMENT24                                                                                                                                                                             
,CHARGE_ACCOUNT_SEGMENT25                                                                                                                                                                     
,CHARGE_ACCOUNT_SEGMENT26                                                                                                                                                                         
,CHARGE_ACCOUNT_SEGMENT27                                                                                                                                                                            
,CHARGE_ACCOUNT_SEGMENT28                                                                                                                                                                          
,CHARGE_ACCOUNT_SEGMENT29
,CHARGE_ACCOUNT_SEGMENT30
,DESTINATION_CONTEXT                                                                                                                                                                                                                                                                                                                                                       
,PROJECT 
,TASK 
,PJC_EXPENDITURE_ITEM_DATE	"to_date(:PJC_EXPENDITURE_ITEM_DATE, 'YYYY/MM/DD')"
,EXPENDITURE                                                                                                                                                                           
,EXPENDITURE_ORGANIZATION                                                                                                                                                                          
,PJC_BILLABLE_FLAG                                                                                                                                                                           
,PJC_CAPITALIZABLE_FLAG
,PJC_WORK_TYPE                                                                                                                                                                              
,PJC_RESERVED_ATTRIBUTE1                                                                                                                                                                            
,PJC_RESERVED_ATTRIBUTE2                                                                                                                                                                           
,PJC_RESERVED_ATTRIBUTE3                                                                                                                                                                          
,PJC_RESERVED_ATTRIBUTE4                                                                                                                                                                           
,PJC_RESERVED_ATTRIBUTE5                                                                                                                                                                         
,PJC_RESERVED_ATTRIBUTE6                                                                                                                                                                        
,PJC_RESERVED_ATTRIBUTE7                                                                                                                                                                     
,PJC_RESERVED_ATTRIBUTE8                                                                                                                                                                           
,PJC_RESERVED_ATTRIBUTE9
,PJC_RESERVED_ATTRIBUTE10                                                                                                                                                                           
,PJC_USER_DEF_ATTRIBUTE1                                                                                                                                                                          
,PJC_USER_DEF_ATTRIBUTE2                                                                                                                                                                         
,PJC_USER_DEF_ATTRIBUTE3
,PJC_USER_DEF_ATTRIBUTE4
,PJC_USER_DEF_ATTRIBUTE5
,PJC_USER_DEF_ATTRIBUTE6
,PJC_USER_DEF_ATTRIBUTE7                                                                                                                                                                         
,PJC_USER_DEF_ATTRIBUTE8                                                                                                                                                                     
,PJC_USER_DEF_ATTRIBUTE9
,PJC_USER_DEF_ATTRIBUTE10                                                                                                                                                                     
,RATE				"fun_load_interface_utils_pkg.replace_decimal_char(:RATE)"
,RATE_DATE			"to_date(:RATE_DATE, 'YYYY/MM/DD')"
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
,DELIVER_TO_PERSON_EMAIL_ADDR
,BUDGET_DATE			"to_date(:BUDGET_DATE, 'YYYY/MM/DD')"
,PJC_CONTRACT_NUMBER
,PJC_FUNDING_SOURCE             char(360)
,GLOBAL_ATTRIBUTE1              char(150)
)
