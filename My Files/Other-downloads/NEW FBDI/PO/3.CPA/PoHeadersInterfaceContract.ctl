LOAD DATA
CHARACTERSET UTF8
LENGTH SEMANTICS CHAR
append
 
INTO TABLE po_headers_interface  
fields terminated by ',' optionally enclosed by '"' trailing nullcols
(INTERFACE_HEADER_ID 		expression "po_headers_interface_s.nextval"
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
,INTERFACE_HEADER_KEY          char(50)
,ACTION                       char(25)
,BATCH_ID
,INTERFACE_SOURCE_CODE        char(25)
,APPROVAL_ACTION              char(25)
,DOCUMENT_NUM                 char(30)
,DOCUMENT_TYPE_CODE           char(25)
,STYLE_DISPLAY_NAME           char(240)
,PRC_BU_NAME                  char(240)
,AGENT_NAME                   char(2000)
,CURRENCY_CODE                char(15)
,COMMENTS                     char(240)
,VENDOR_NAME                  char(360)
,VENDOR_NUM                    char(30)
,VENDOR_SITE_CODE              char(240)
,VENDOR_CONTACT                char(360)
,VENDOR_DOC_NUM                char(25)
,FOB                           char(30)
,FREIGHT_CARRIER               char(360)
,FREIGHT_TERMS                 char(30)
,PAY_ON_CODE                   char(25)
,PAYMENT_TERMS                 char(50)
,ORIGINATOR_ROLE               char(25)
,CHANGE_ORDER_DESC              char(2000)
,ACCEPTANCE_REQUIRED_FLAG      char(1)
,ACCEPTANCE_WITHIN_DAYS
,SUPPLIER_NOTIF_METHOD         char(25)
,FAX                           char(60)
,EMAIL_ADDRESS                  char(2000)
,CONFIRMING_ORDER_FLAG         char(1)
,AMOUNT_AGREED			"fun_load_interface_utils_pkg.replace_decimal_char(:AMOUNT_AGREED)"
,AMOUNT_LIMIT			"fun_load_interface_utils_pkg.replace_decimal_char(:AMOUNT_LIMIT)"
,MIN_RELEASE_AMOUNT		"fun_load_interface_utils_pkg.replace_decimal_char(:MIN_RELEASE_AMOUNT)"
,EFFECTIVE_DATE			"to_date(:EFFECTIVE_DATE, 'YYYY/MM/DD')"
,EXPIRATION_DATE		"to_date(:EXPIRATION_DATE, 'YYYY/MM/DD')"
,NOTE_TO_VENDOR                 char(1000)
,NOTE_TO_RECEIVER               char(1000)
,GENERATE_ORDERS_AUTOMATIC      char(1)                                                                                                                                 
,SUBMIT_APPROVAL_AUTOMATIC      char(1) 
,GROUP_REQUISITIONS             char(1)                                                                                                                         
,GROUP_REQUISITION_LINES        char(1)                                                                                                                            
,USE_SHIP_TO                    char(1)  
,USE_NEED_BY_DATE               char(1)                                                                                                             
,ATTRIBUTE_CATEGORY             char(30)
,ATTRIBUTE1                     char(150)
,ATTRIBUTE2                     char(150)                    
,ATTRIBUTE3                     char(150)
,ATTRIBUTE4                     char(150)                                                                                                                                           
,ATTRIBUTE5                     char(150)                                                                                                                                          
,ATTRIBUTE6                     char(150)                                                                                                                                         
,ATTRIBUTE7                     char(150)                                                                                                                                        
,ATTRIBUTE8                     char(150)                                                                                                                                       
,ATTRIBUTE9                     char(150)
,ATTRIBUTE10                     char(150)                                                                                                                                                                                                                                                                                                                       
,ATTRIBUTE11                     char(150)                                                                                                                                
,ATTRIBUTE12                     char(150)                                                                                                                               
,ATTRIBUTE13                     char(150)                                                                                                                             
,ATTRIBUTE14                     char(150)
,ATTRIBUTE15                     char(150)                                                                                                                                                  
,ATTRIBUTE16                     char(150)                                                                                                                                                 
,ATTRIBUTE17                     char(150)                                                                                                                                                
,ATTRIBUTE18                     char(150)                                                                                                                                               
,ATTRIBUTE19                     char(150)
,ATTRIBUTE20                     char(150)
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
,AGENT_EMAIL_ADDRESS            char(240)
,MODE_OF_TRANSPORT              char(80)
,SERVICE_LEVEL                  char(80)
,USE_SALES_ORDER_NUMBER_FLAG    char(1)
,BUYER_MANAGED_TRANSPORT_FLAG   char(1)
,CONFIGURED_ITEM_FLAG            char(1)
,ALLOW_MULTIPLE_SITES_FLAG      "decode(:ALLOW_MULTIPLE_SITES_FLAG, 'Y','Y','N')"
,OUTSIDE_PROCESS_ENABLED_FLAG   "decode(:OUTSIDE_PROCESS_ENABLED_FLAG, 'Y','Y','N')"
,DISABLE_AUTOSOURCING_FLAG      "decode(:DISABLE_AUTOSOURCING_FLAG, null, 'X', 'Y', null, 'N', 'Y', 'PUNCHOUT REQUESTS ONLY', 'P', 'Y')"
,MASTER_CONTRACT_NUMBER         char(120)
,MASTER_CONTRACT_TYPE           char(150)
,CHECKLIST_TITLE                char(80)
,CHECKLIST_NUM                  char(30)
)