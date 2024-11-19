LOAD DATA
append
 
Into TABLE fa_massadd_distributions
fields terminated by ',' optionally enclosed by '"' trailing nullcols
(MASSADD_DIST_ID                expression "fa_massadd_distributions_s.nextval"
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
,UNITS                          "fun_load_interface_utils_pkg.replace_decimal_char(:UNITS)"
,EMPLOYEE_EMAIL_ADDRESS
,LOCATION_SEGMENT1              "fa_util_pvt.faxtrim(:LOCATION_SEGMENT1)"
,LOCATION_SEGMENT2              "fa_util_pvt.faxtrim(:LOCATION_SEGMENT2)"
,LOCATION_SEGMENT3              "fa_util_pvt.faxtrim(:LOCATION_SEGMENT3)"
,LOCATION_SEGMENT4              "fa_util_pvt.faxtrim(:LOCATION_SEGMENT4)"
,LOCATION_SEGMENT5              "fa_util_pvt.faxtrim(:LOCATION_SEGMENT5)"
,LOCATION_SEGMENT6              "fa_util_pvt.faxtrim(:LOCATION_SEGMENT6)"
,LOCATION_SEGMENT7              "fa_util_pvt.faxtrim(:LOCATION_SEGMENT7)"
,DEPRN_EXPENSE_SEGMENT1         "fa_util_pvt.faxtrim(:DEPRN_EXPENSE_SEGMENT1)"        
,DEPRN_EXPENSE_SEGMENT2         "fa_util_pvt.faxtrim(:DEPRN_EXPENSE_SEGMENT2)"
,DEPRN_EXPENSE_SEGMENT3         "fa_util_pvt.faxtrim(:DEPRN_EXPENSE_SEGMENT3)"
,DEPRN_EXPENSE_SEGMENT4         "fa_util_pvt.faxtrim(:DEPRN_EXPENSE_SEGMENT4)"
,DEPRN_EXPENSE_SEGMENT5         "fa_util_pvt.faxtrim(:DEPRN_EXPENSE_SEGMENT5)"
,DEPRN_EXPENSE_SEGMENT6         "fa_util_pvt.faxtrim(:DEPRN_EXPENSE_SEGMENT6)"
,DEPRN_EXPENSE_SEGMENT7         "fa_util_pvt.faxtrim(:DEPRN_EXPENSE_SEGMENT7)"
,DEPRN_EXPENSE_SEGMENT8         "fa_util_pvt.faxtrim(:DEPRN_EXPENSE_SEGMENT8)"
,DEPRN_EXPENSE_SEGMENT9         "fa_util_pvt.faxtrim(:DEPRN_EXPENSE_SEGMENT9)"
,DEPRN_EXPENSE_SEGMENT10        "fa_util_pvt.faxtrim(:DEPRN_EXPENSE_SEGMENT10)"        
,DEPRN_EXPENSE_SEGMENT11        "fa_util_pvt.faxtrim(:DEPRN_EXPENSE_SEGMENT11)"
,DEPRN_EXPENSE_SEGMENT12        "fa_util_pvt.faxtrim(:DEPRN_EXPENSE_SEGMENT12)"
,DEPRN_EXPENSE_SEGMENT13        "fa_util_pvt.faxtrim(:DEPRN_EXPENSE_SEGMENT13)"
,DEPRN_EXPENSE_SEGMENT14        "fa_util_pvt.faxtrim(:DEPRN_EXPENSE_SEGMENT14)"
,DEPRN_EXPENSE_SEGMENT15        "fa_util_pvt.faxtrim(:DEPRN_EXPENSE_SEGMENT15)"
,DEPRN_EXPENSE_SEGMENT16        "fa_util_pvt.faxtrim(:DEPRN_EXPENSE_SEGMENT16)"
,DEPRN_EXPENSE_SEGMENT17        "fa_util_pvt.faxtrim(:DEPRN_EXPENSE_SEGMENT17)"
,DEPRN_EXPENSE_SEGMENT18        "fa_util_pvt.faxtrim(:DEPRN_EXPENSE_SEGMENT18)"
,DEPRN_EXPENSE_SEGMENT19        "fa_util_pvt.faxtrim(:DEPRN_EXPENSE_SEGMENT19)"
,DEPRN_EXPENSE_SEGMENT20        "fa_util_pvt.faxtrim(:DEPRN_EXPENSE_SEGMENT20)"
,DEPRN_EXPENSE_SEGMENT21        "fa_util_pvt.faxtrim(:DEPRN_EXPENSE_SEGMENT21)"
,DEPRN_EXPENSE_SEGMENT22        "fa_util_pvt.faxtrim(:DEPRN_EXPENSE_SEGMENT22)"
,DEPRN_EXPENSE_SEGMENT23        "fa_util_pvt.faxtrim(:DEPRN_EXPENSE_SEGMENT23)"
,DEPRN_EXPENSE_SEGMENT24        "fa_util_pvt.faxtrim(:DEPRN_EXPENSE_SEGMENT24)"
,DEPRN_EXPENSE_SEGMENT25        "fa_util_pvt.faxtrim(:DEPRN_EXPENSE_SEGMENT25)"
,DEPRN_EXPENSE_SEGMENT26        "fa_util_pvt.faxtrim(:DEPRN_EXPENSE_SEGMENT26)"
,DEPRN_EXPENSE_SEGMENT27        "fa_util_pvt.faxtrim(:DEPRN_EXPENSE_SEGMENT27)"
,DEPRN_EXPENSE_SEGMENT28        "fa_util_pvt.faxtrim(:DEPRN_EXPENSE_SEGMENT28)"
,DEPRN_EXPENSE_SEGMENT29        "fa_util_pvt.faxtrim(:DEPRN_EXPENSE_SEGMENT29)"
,DEPRN_EXPENSE_SEGMENT30        "fa_util_pvt.faxtrim(:DEPRN_EXPENSE_SEGMENT30)"
,ATTRIBUTE1                     CHAR(600)
,ATTRIBUTE2                     CHAR(600)
,ATTRIBUTE3                     CHAR(600)
,ATTRIBUTE4                     CHAR(600)
,ATTRIBUTE5                     CHAR(600)
,ATTRIBUTE6                     CHAR(600)
,ATTRIBUTE7                     CHAR(600)
,ATTRIBUTE8                     CHAR(600)
,ATTRIBUTE9                     CHAR(600)
,ATTRIBUTE10                    CHAR(600)
,ATTRIBUTE11                    CHAR(600)
,ATTRIBUTE12                    CHAR(600)
,ATTRIBUTE13                    CHAR(600)
,ATTRIBUTE14                    CHAR(600)
,ATTRIBUTE15                    CHAR(600)
,ATTRIBUTE_NUMBER1              "fun_load_interface_utils_pkg.replace_decimal_char(:ATTRIBUTE_NUMBER1)"
,ATTRIBUTE_NUMBER2              "fun_load_interface_utils_pkg.replace_decimal_char(:ATTRIBUTE_NUMBER2)"
,ATTRIBUTE_NUMBER3              "fun_load_interface_utils_pkg.replace_decimal_char(:ATTRIBUTE_NUMBER3)"
,ATTRIBUTE_NUMBER4              "fun_load_interface_utils_pkg.replace_decimal_char(:ATTRIBUTE_NUMBER4)"
,ATTRIBUTE_NUMBER5              "fun_load_interface_utils_pkg.replace_decimal_char(:ATTRIBUTE_NUMBER5)"
,ATTRIBUTE_DATE1                "to_date(:ATTRIBUTE_DATE1, 'YYYY/MM/DD')"
,ATTRIBUTE_DATE2                "to_date(:ATTRIBUTE_DATE2, 'YYYY/MM/DD')"
,ATTRIBUTE_DATE3                "to_date(:ATTRIBUTE_DATE3, 'YYYY/MM/DD')"
,ATTRIBUTE_DATE4                "to_date(:ATTRIBUTE_DATE4, 'YYYY/MM/DD')"
,ATTRIBUTE_DATE5                "to_date(:ATTRIBUTE_DATE5, 'YYYY/MM/DD')"
,ATTRIBUTE_CATEGORY
)


