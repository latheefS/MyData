LOAD DATA
append
 
Into TABLE fa_mc_mass_rates
fields terminated by ',' optionally enclosed by '"' trailing nullcols
(SET_OF_BOOKS_ID                expression "-1 * replace(substr(dump(:CURRENCY_CODE),instr(dump(:CURRENCY_CODE),': ')+2),',')"
,CREATION_DATE                  expression "systimestamp"
,LAST_UPDATE_DATE               expression "systimestamp"
,OBJECT_VERSION_NUMBER          constant 1
--,CREATED_BY                     constant 1
--,LAST_UPDATED_BY                constant 1
--,LAST_UPDATE_LOGIN              constant 1
--,LOAD_REQUEST_ID                constant 1
--,MASS_ADDITION_ID               "FA_INTERFACE_UTILS_PKG.get_parent_key1('MASSADD', :MASS_ADDITION_ID, 100)"
,CREATED_BY                     constant '#CREATEDBY#'
,LAST_UPDATED_BY                constant '#LASTUPDATEDBY#'
,LAST_UPDATE_LOGIN              constant '#LASTUPDATELOGIN#'
,LOAD_REQUEST_ID                constant '#LOADREQUESTID#'
,MASS_ADDITION_ID               "FA_INTERFACE_UTILS_PKG.get_parent_key1('MASSADD', :MASS_ADDITION_ID, '#LOADREQUESTID#')"
,CURRENCY_CODE                  
,FIXED_ASSETS_COST              "fun_load_interface_utils_pkg.replace_decimal_char(:FIXED_ASSETS_COST)"
,EXCHANGE_RATE                  "fun_load_interface_utils_pkg.replace_decimal_char(:EXCHANGE_RATE)"
)


