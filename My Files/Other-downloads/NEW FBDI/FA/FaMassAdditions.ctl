LOAD DATA
append
 
INTO TABLE fa_mass_additions
fields terminated by ',' optionally enclosed by '"' trailing nullcols
(CREATION_DATE                  expression "systimestamp"
,LAST_UPDATE_DATE               expression "systimestamp"
,OBJECT_VERSION_NUMBER          constant 1
--,CREATED_BY                     constant 1
--,LAST_UPDATED_BY                constant 1
--,LAST_UPDATE_LOGIN              constant 1
--,LOAD_REQUEST_ID                constant 1
,CREATED_BY                     constant '#CREATEDBY#'
,LAST_UPDATED_BY                constant '#LASTUPDATEDBY#'
,LAST_UPDATE_LOGIN              constant '#LASTUPDATELOGIN#'
,LOAD_REQUEST_ID                constant '#LOADREQUESTID#'
--,MASS_ADDITION_ID               "FA_INTERFACE_UTILS_PKG.create_parent_key1('MASSADD', :MASS_ADDITION_ID, '100')"
,MASS_ADDITION_ID               "FA_INTERFACE_UTILS_PKG.create_parent_key1('MASSADD', :MASS_ADDITION_ID, '#LOADREQUESTID#')"
,BOOK_TYPE_CODE
,TRANSACTION_NAME
,ASSET_NUMBER
,DESCRIPTION
,TAG_NUMBER
,MANUFACTURER_NAME CHAR(360)
,SERIAL_NUMBER
,MODEL_NUMBER
,ASSET_TYPE
,FIXED_ASSETS_COST              "fun_load_interface_utils_pkg.replace_decimal_char(:FIXED_ASSETS_COST)"
,DATE_PLACED_IN_SERVICE         "to_date(:DATE_PLACED_IN_SERVICE, 'YYYY/MM/DD')"
,PRORATE_CONVENTION_CODE
,FIXED_ASSETS_UNITS             "fun_load_interface_utils_pkg.replace_decimal_char(:FIXED_ASSETS_UNITS)"
,CATEGORY_SEGMENT1              "fa_util_pvt.faxtrim(:CATEGORY_SEGMENT1)"
,CATEGORY_SEGMENT2              "fa_util_pvt.faxtrim(:CATEGORY_SEGMENT2)"
,CATEGORY_SEGMENT3              "fa_util_pvt.faxtrim(:CATEGORY_SEGMENT3)"
,CATEGORY_SEGMENT4              "fa_util_pvt.faxtrim(:CATEGORY_SEGMENT4)"
,CATEGORY_SEGMENT5              "fa_util_pvt.faxtrim(:CATEGORY_SEGMENT5)"
,CATEGORY_SEGMENT6              "fa_util_pvt.faxtrim(:CATEGORY_SEGMENT6)"
,CATEGORY_SEGMENT7              "fa_util_pvt.faxtrim(:CATEGORY_SEGMENT7)"
,POSTING_STATUS
,QUEUE_NAME
,FEEDER_SYSTEM_NAME             "nvl(:FEEDER_SYSTEM_NAME, 'ORACLE FBDI')"
,PARENT_ASSET_NUMBER
,ADD_TO_ASSET_NUMBER
,ASSET_KEY_SEGMENT1             "fa_util_pvt.faxtrim(:ASSET_KEY_SEGMENT1)"              
,ASSET_KEY_SEGMENT2             "fa_util_pvt.faxtrim(:ASSET_KEY_SEGMENT2)"   
,ASSET_KEY_SEGMENT3             "fa_util_pvt.faxtrim(:ASSET_KEY_SEGMENT3)"   
,ASSET_KEY_SEGMENT4             "fa_util_pvt.faxtrim(:ASSET_KEY_SEGMENT4)"   
,ASSET_KEY_SEGMENT5             "fa_util_pvt.faxtrim(:ASSET_KEY_SEGMENT5)"   
,ASSET_KEY_SEGMENT6             "fa_util_pvt.faxtrim(:ASSET_KEY_SEGMENT6)"   
,ASSET_KEY_SEGMENT7             "fa_util_pvt.faxtrim(:ASSET_KEY_SEGMENT7)"   
,ASSET_KEY_SEGMENT8             "fa_util_pvt.faxtrim(:ASSET_KEY_SEGMENT8)"   
,ASSET_KEY_SEGMENT9             "fa_util_pvt.faxtrim(:ASSET_KEY_SEGMENT9)"   
,ASSET_KEY_SEGMENT10            "fa_util_pvt.faxtrim(:ASSET_KEY_SEGMENT10)"
,INVENTORIAL
,PROPERTY_TYPE_CODE
,PROPERTY_1245_1250_CODE
,IN_USE_FLAG
,OWNED_LEASED
,NEW_USED
,MATERIAL_INDICATOR_FLAG
,COMMITMENT
,INVESTMENT_LAW
,AMORTIZE_FLAG
,AMORTIZATION_START_DATE        "to_date(:AMORTIZATION_START_DATE, 'YYYY/MM/DD')"
,DEPRECIATE_FLAG
,SALVAGE_TYPE
,SALVAGE_VALUE                  "fun_load_interface_utils_pkg.replace_decimal_char(:SALVAGE_VALUE)"
,PERCENT_SALVAGE_VALUE          "fun_load_interface_utils_pkg.replace_decimal_char(:PERCENT_SALVAGE_VALUE)"
,YTD_DEPRN                      "fun_load_interface_utils_pkg.replace_decimal_char(:YTD_DEPRN)"
,DEPRN_RESERVE                  "fun_load_interface_utils_pkg.replace_decimal_char(:DEPRN_RESERVE)"
,BONUS_YTD_DEPRN                "fun_load_interface_utils_pkg.replace_decimal_char(:BONUS_YTD_DEPRN)"
,BONUS_DEPRN_RESERVE            "fun_load_interface_utils_pkg.replace_decimal_char(:BONUS_DEPRN_RESERVE)"
,YTD_IMPAIRMENT                 "fun_load_interface_utils_pkg.replace_decimal_char(:YTD_IMPAIRMENT)"
,IMPAIRMENT_RESERVE             "fun_load_interface_utils_pkg.replace_decimal_char(:IMPAIRMENT_RESERVE)"
,METHOD_CODE
,LIFE_IN_MONTHS
,BASIC_RATE
,ADJUSTED_RATE
,UNIT_OF_MEASURE
,PRODUCTION_CAPACITY             "fun_load_interface_utils_pkg.replace_decimal_char(:PRODUCTION_CAPACITY)"
,CEILING_NAME                    "fun_load_interface_utils_pkg.check_null_char(:CEILING_NAME)"
,BONUS_RULE                      "fun_load_interface_utils_pkg.check_null_char(:BONUS_RULE)"
,CASH_GENERATING_UNIT
,DEPRN_LIMIT_TYPE
,ALLOWED_DEPRN_LIMIT            "fun_load_interface_utils_pkg.replace_decimal_char(:ALLOWED_DEPRN_LIMIT)"
,ALLOWED_DEPRN_LIMIT_AMOUNT     "fun_load_interface_utils_pkg.replace_decimal_char(:ALLOWED_DEPRN_LIMIT_AMOUNT)"
,PAYABLES_COST                  "fun_load_interface_utils_pkg.replace_decimal_char(:PAYABLES_COST)"
,CLEARING_ACCT_SEGMENT1         "fa_util_pvt.faxtrim(:CLEARING_ACCT_SEGMENT1)"        
,CLEARING_ACCT_SEGMENT2         "fa_util_pvt.faxtrim(:CLEARING_ACCT_SEGMENT2)"
,CLEARING_ACCT_SEGMENT3         "fa_util_pvt.faxtrim(:CLEARING_ACCT_SEGMENT3)"
,CLEARING_ACCT_SEGMENT4         "fa_util_pvt.faxtrim(:CLEARING_ACCT_SEGMENT4)"
,CLEARING_ACCT_SEGMENT5         "fa_util_pvt.faxtrim(:CLEARING_ACCT_SEGMENT5)"
,CLEARING_ACCT_SEGMENT6         "fa_util_pvt.faxtrim(:CLEARING_ACCT_SEGMENT6)"
,CLEARING_ACCT_SEGMENT7         "fa_util_pvt.faxtrim(:CLEARING_ACCT_SEGMENT7)"
,CLEARING_ACCT_SEGMENT8         "fa_util_pvt.faxtrim(:CLEARING_ACCT_SEGMENT8)"
,CLEARING_ACCT_SEGMENT9         "fa_util_pvt.faxtrim(:CLEARING_ACCT_SEGMENT9)"
,CLEARING_ACCT_SEGMENT10        "fa_util_pvt.faxtrim(:CLEARING_ACCT_SEGMENT10)"        
,CLEARING_ACCT_SEGMENT11        "fa_util_pvt.faxtrim(:CLEARING_ACCT_SEGMENT11)"
,CLEARING_ACCT_SEGMENT12        "fa_util_pvt.faxtrim(:CLEARING_ACCT_SEGMENT12)"
,CLEARING_ACCT_SEGMENT13        "fa_util_pvt.faxtrim(:CLEARING_ACCT_SEGMENT13)"
,CLEARING_ACCT_SEGMENT14        "fa_util_pvt.faxtrim(:CLEARING_ACCT_SEGMENT14)"
,CLEARING_ACCT_SEGMENT15        "fa_util_pvt.faxtrim(:CLEARING_ACCT_SEGMENT15)"
,CLEARING_ACCT_SEGMENT16        "fa_util_pvt.faxtrim(:CLEARING_ACCT_SEGMENT16)"
,CLEARING_ACCT_SEGMENT17        "fa_util_pvt.faxtrim(:CLEARING_ACCT_SEGMENT17)"
,CLEARING_ACCT_SEGMENT18        "fa_util_pvt.faxtrim(:CLEARING_ACCT_SEGMENT18)"
,CLEARING_ACCT_SEGMENT19        "fa_util_pvt.faxtrim(:CLEARING_ACCT_SEGMENT19)"
,CLEARING_ACCT_SEGMENT20        "fa_util_pvt.faxtrim(:CLEARING_ACCT_SEGMENT20)"
,CLEARING_ACCT_SEGMENT21        "fa_util_pvt.faxtrim(:CLEARING_ACCT_SEGMENT21)"
,CLEARING_ACCT_SEGMENT22        "fa_util_pvt.faxtrim(:CLEARING_ACCT_SEGMENT22)"
,CLEARING_ACCT_SEGMENT23        "fa_util_pvt.faxtrim(:CLEARING_ACCT_SEGMENT23)"
,CLEARING_ACCT_SEGMENT24        "fa_util_pvt.faxtrim(:CLEARING_ACCT_SEGMENT24)"
,CLEARING_ACCT_SEGMENT25        "fa_util_pvt.faxtrim(:CLEARING_ACCT_SEGMENT25)"
,CLEARING_ACCT_SEGMENT26        "fa_util_pvt.faxtrim(:CLEARING_ACCT_SEGMENT26)"
,CLEARING_ACCT_SEGMENT27        "fa_util_pvt.faxtrim(:CLEARING_ACCT_SEGMENT27)"
,CLEARING_ACCT_SEGMENT28        "fa_util_pvt.faxtrim(:CLEARING_ACCT_SEGMENT28)"
,CLEARING_ACCT_SEGMENT29        "fa_util_pvt.faxtrim(:CLEARING_ACCT_SEGMENT29)"
,CLEARING_ACCT_SEGMENT30        "fa_util_pvt.faxtrim(:CLEARING_ACCT_SEGMENT30)"
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
,ATTRIBUTE16                    CHAR(600)
,ATTRIBUTE17                    CHAR(600)
,ATTRIBUTE18                    CHAR(600)
,ATTRIBUTE19                    CHAR(600)
,ATTRIBUTE20                    CHAR(600)
,ATTRIBUTE21                    CHAR(600)
,ATTRIBUTE22                    CHAR(600)
,ATTRIBUTE23                    CHAR(600)
,ATTRIBUTE24                    CHAR(600)
,ATTRIBUTE25                    CHAR(600)
,ATTRIBUTE26                    CHAR(600)
,ATTRIBUTE27                    CHAR(600)
,ATTRIBUTE28                    CHAR(600)
,ATTRIBUTE29                    CHAR(600)
,ATTRIBUTE30                    CHAR(600)
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
,ATTRIBUTE_CATEGORY_CODE
,CONTEXT
,TH_ATTRIBUTE1                  CHAR(600)
,TH_ATTRIBUTE2                  CHAR(600)                  
,TH_ATTRIBUTE3                  CHAR(600)                  
,TH_ATTRIBUTE4                  CHAR(600)
,TH_ATTRIBUTE5                  CHAR(600)
,TH_ATTRIBUTE6                  CHAR(600)
,TH_ATTRIBUTE7                  CHAR(600)
,TH_ATTRIBUTE8                  CHAR(600)
,TH_ATTRIBUTE9                  CHAR(600)
,TH_ATTRIBUTE10                 CHAR(600)
,TH_ATTRIBUTE11                 CHAR(600)
,TH_ATTRIBUTE12                 CHAR(600)
,TH_ATTRIBUTE13                 CHAR(600)
,TH_ATTRIBUTE14                 CHAR(600)
,TH_ATTRIBUTE15                 CHAR(600)
,TH_ATTRIBUTE_NUMBER1           "fun_load_interface_utils_pkg.replace_decimal_char(:TH_ATTRIBUTE_NUMBER1)"
,TH_ATTRIBUTE_NUMBER2           "fun_load_interface_utils_pkg.replace_decimal_char(:TH_ATTRIBUTE_NUMBER2)"
,TH_ATTRIBUTE_NUMBER3           "fun_load_interface_utils_pkg.replace_decimal_char(:TH_ATTRIBUTE_NUMBER3)"
,TH_ATTRIBUTE_NUMBER4           "fun_load_interface_utils_pkg.replace_decimal_char(:TH_ATTRIBUTE_NUMBER4)"
,TH_ATTRIBUTE_NUMBER5           "fun_load_interface_utils_pkg.replace_decimal_char(:TH_ATTRIBUTE_NUMBER5)"
,TH_ATTRIBUTE_DATE1             "to_date(:TH_ATTRIBUTE_DATE1, 'YYYY/MM/DD')"
,TH_ATTRIBUTE_DATE2             "to_date(:TH_ATTRIBUTE_DATE2, 'YYYY/MM/DD')"
,TH_ATTRIBUTE_DATE3             "to_date(:TH_ATTRIBUTE_DATE3, 'YYYY/MM/DD')"
,TH_ATTRIBUTE_DATE4             "to_date(:TH_ATTRIBUTE_DATE4, 'YYYY/MM/DD')"
,TH_ATTRIBUTE_DATE5             "to_date(:TH_ATTRIBUTE_DATE5, 'YYYY/MM/DD')"
,TH_ATTRIBUTE_CATEGORY_CODE
,TH2_ATTRIBUTE1                 CHAR(600)
,TH2_ATTRIBUTE2                 CHAR(600)
,TH2_ATTRIBUTE3                 CHAR(600)
,TH2_ATTRIBUTE4                 CHAR(600)
,TH2_ATTRIBUTE5                 CHAR(600)
,TH2_ATTRIBUTE6                 CHAR(600)
,TH2_ATTRIBUTE7                 CHAR(600)
,TH2_ATTRIBUTE8                 CHAR(600)
,TH2_ATTRIBUTE9                 CHAR(600)
,TH2_ATTRIBUTE10                CHAR(600)
,TH2_ATTRIBUTE11                CHAR(600)
,TH2_ATTRIBUTE12                CHAR(600)
,TH2_ATTRIBUTE13                CHAR(600)
,TH2_ATTRIBUTE14                CHAR(600)
,TH2_ATTRIBUTE15                CHAR(600)
,TH2_ATTRIBUTE_NUMBER1           "fun_load_interface_utils_pkg.replace_decimal_char(:TH_ATTRIBUTE_NUMBER1)"
,TH2_ATTRIBUTE_NUMBER2           "fun_load_interface_utils_pkg.replace_decimal_char(:TH_ATTRIBUTE_NUMBER2)"
,TH2_ATTRIBUTE_NUMBER3           "fun_load_interface_utils_pkg.replace_decimal_char(:TH_ATTRIBUTE_NUMBER3)"
,TH2_ATTRIBUTE_NUMBER4           "fun_load_interface_utils_pkg.replace_decimal_char(:TH_ATTRIBUTE_NUMBER4)"
,TH2_ATTRIBUTE_NUMBER5           "fun_load_interface_utils_pkg.replace_decimal_char(:TH_ATTRIBUTE_NUMBER5)"
,TH2_ATTRIBUTE_DATE1             "to_date(:TH2_ATTRIBUTE_DATE1, 'YYYY/MM/DD')"
,TH2_ATTRIBUTE_DATE2             "to_date(:TH2_ATTRIBUTE_DATE2, 'YYYY/MM/DD')"
,TH2_ATTRIBUTE_DATE3             "to_date(:TH2_ATTRIBUTE_DATE3, 'YYYY/MM/DD')"
,TH2_ATTRIBUTE_DATE4             "to_date(:TH2_ATTRIBUTE_DATE4, 'YYYY/MM/DD')"
,TH2_ATTRIBUTE_DATE5             "to_date(:TH2_ATTRIBUTE_DATE5, 'YYYY/MM/DD')"
,TH2_ATTRIBUTE_CATEGORY_CODE
,AI_ATTRIBUTE1                  CHAR(600)
,AI_ATTRIBUTE2                  CHAR(600)
,AI_ATTRIBUTE3                  CHAR(600)
,AI_ATTRIBUTE4                  CHAR(600)
,AI_ATTRIBUTE5                  CHAR(600)
,AI_ATTRIBUTE6                  CHAR(600)
,AI_ATTRIBUTE7                  CHAR(600)
,AI_ATTRIBUTE8                  CHAR(600)
,AI_ATTRIBUTE9                  CHAR(600)
,AI_ATTRIBUTE10                 CHAR(600)
,AI_ATTRIBUTE11                 CHAR(600)
,AI_ATTRIBUTE12                 CHAR(600)
,AI_ATTRIBUTE13                 CHAR(600)
,AI_ATTRIBUTE14                 CHAR(600)
,AI_ATTRIBUTE15                 CHAR(600)
,AI_ATTRIBUTE_NUMBER1           "fun_load_interface_utils_pkg.replace_decimal_char(:AI_ATTRIBUTE_NUMBER1)"
,AI_ATTRIBUTE_NUMBER2           "fun_load_interface_utils_pkg.replace_decimal_char(:AI_ATTRIBUTE_NUMBER2)"
,AI_ATTRIBUTE_NUMBER3           "fun_load_interface_utils_pkg.replace_decimal_char(:AI_ATTRIBUTE_NUMBER3)"
,AI_ATTRIBUTE_NUMBER4           "fun_load_interface_utils_pkg.replace_decimal_char(:AI_ATTRIBUTE_NUMBER4)"
,AI_ATTRIBUTE_NUMBER5           "fun_load_interface_utils_pkg.replace_decimal_char(:AI_ATTRIBUTE_NUMBER5)"
,AI_ATTRIBUTE_DATE1             "to_date(:AI_ATTRIBUTE_DATE1, 'YYYY/MM/DD')"
,AI_ATTRIBUTE_DATE2             "to_date(:AI_ATTRIBUTE_DATE2, 'YYYY/MM/DD')"
,AI_ATTRIBUTE_DATE3             "to_date(:AI_ATTRIBUTE_DATE3, 'YYYY/MM/DD')"
,AI_ATTRIBUTE_DATE4             "to_date(:AI_ATTRIBUTE_DATE4, 'YYYY/MM/DD')"
,AI_ATTRIBUTE_DATE5             "to_date(:AI_ATTRIBUTE_DATE5, 'YYYY/MM/DD')"
,AI_ATTRIBUTE_CATEGORY_CODE
,MASS_PROPERTY_FLAG
,GROUP_ASSET_NUMBER             "fun_load_interface_utils_pkg.check_null_char(:GROUP_ASSET_NUMBER)"
,REDUCTION_RATE                 "fun_load_interface_utils_pkg.replace_decimal_char(:REDUCTION_RATE)"
,REDUCE_ADDITION_FLAG
,REDUCE_ADJUSTMENT_FLAG
,REDUCE_RETIREMENT_FLAG
,RECOGNIZE_GAIN_LOSS
,RECAPTURE_RESERVE_FLAG
,LIMIT_PROCEEDS_FLAG
,TERMINAL_GAIN_LOSS
,TRACKING_METHOD
,EXCESS_ALLOCATION_OPTION
,DEPRECIATION_OPTION
,MEMBER_ROLLUP_FLAG
,ALLOCATE_TO_FULLY_RSV_FLAG
,OVER_DEPRECIATE_OPTION
,PREPARER_EMAIL_ADDRESS
,MERGED_CODE
--,PARENT_MASS_ADDITION_ID        "FA_INTERFACE_UTILS_PKG.get_parent_merged_key1('MASSADD', :PARENT_MASS_ADDITION_ID, :MERGED_CODE, '100')"
,PARENT_MASS_ADDITION_ID        "FA_INTERFACE_UTILS_PKG.get_parent_merged_key1('MASSADD', :PARENT_MASS_ADDITION_ID, :MERGED_CODE, '#LOADREQUESTID#')"
,SUM_UNITS
,NEW_MASTER_FLAG
,UNITS_TO_ADJUST
,SHORT_FISCAL_YEAR_FLAG
,CONVERSION_DATE                "to_date(:CONVERSION_DATE, 'YYYY/MM/DD')"
,ORIGINAL_DEPRN_START_DATE      "to_date(:ORIGINAL_DEPRN_START_DATE, 'YYYY/MM/DD')"
,GLOBAL_ATTRIBUTE1              CHAR(600)
,GLOBAL_ATTRIBUTE2              CHAR(600)
,GLOBAL_ATTRIBUTE3              CHAR(600)
,GLOBAL_ATTRIBUTE4              CHAR(600)
,GLOBAL_ATTRIBUTE5              CHAR(600)
,GLOBAL_ATTRIBUTE6              CHAR(600)
,GLOBAL_ATTRIBUTE7              CHAR(600)
,GLOBAL_ATTRIBUTE8              CHAR(600)
,GLOBAL_ATTRIBUTE9              CHAR(600)
,GLOBAL_ATTRIBUTE10             CHAR(600)
,GLOBAL_ATTRIBUTE11             CHAR(600)
,GLOBAL_ATTRIBUTE12             CHAR(600)
,GLOBAL_ATTRIBUTE13             CHAR(600)
,GLOBAL_ATTRIBUTE14             CHAR(600)
,GLOBAL_ATTRIBUTE15             CHAR(600)
,GLOBAL_ATTRIBUTE16             CHAR(600)
,GLOBAL_ATTRIBUTE17             CHAR(600)
,GLOBAL_ATTRIBUTE18             CHAR(600)
,GLOBAL_ATTRIBUTE19             CHAR(600)
,GLOBAL_ATTRIBUTE20             CHAR(600)
,GLOBAL_ATTRIBUTE_NUMBER1       "fun_load_interface_utils_pkg.replace_decimal_char(:GLOBAL_ATTRIBUTE_NUMBER1)"
,GLOBAL_ATTRIBUTE_NUMBER2       "fun_load_interface_utils_pkg.replace_decimal_char(:GLOBAL_ATTRIBUTE_NUMBER2)"
,GLOBAL_ATTRIBUTE_NUMBER3       "fun_load_interface_utils_pkg.replace_decimal_char(:GLOBAL_ATTRIBUTE_NUMBER3)"
,GLOBAL_ATTRIBUTE_NUMBER4       "fun_load_interface_utils_pkg.replace_decimal_char(:GLOBAL_ATTRIBUTE_NUMBER4)"
,GLOBAL_ATTRIBUTE_NUMBER5       "fun_load_interface_utils_pkg.replace_decimal_char(:GLOBAL_ATTRIBUTE_NUMBER5)"
,GLOBAL_ATTRIBUTE_DATE1         "to_date(:GLOBAL_ATTRIBUTE_DATE1, 'YYYY/MM/DD')"
,GLOBAL_ATTRIBUTE_DATE2         "to_date(:GLOBAL_ATTRIBUTE_DATE2, 'YYYY/MM/DD')"
,GLOBAL_ATTRIBUTE_DATE3         "to_date(:GLOBAL_ATTRIBUTE_DATE3, 'YYYY/MM/DD')"
,GLOBAL_ATTRIBUTE_DATE4         "to_date(:GLOBAL_ATTRIBUTE_DATE4, 'YYYY/MM/DD')"
,GLOBAL_ATTRIBUTE_DATE5         "to_date(:GLOBAL_ATTRIBUTE_DATE5, 'YYYY/MM/DD')"
,GLOBAL_ATTRIBUTE_CATEGORY
,NBV_AT_SWITCH                  "fun_load_interface_utils_pkg.replace_decimal_char(:NBV_AT_SWITCH)"
,PERIOD_NAME_FULLY_RESERVED
,PERIOD_NAME_EXTENDED
,PRIOR_DEPRN_LIMIT_TYPE
,PRIOR_DEPRN_LIMIT              "fun_load_interface_utils_pkg.replace_decimal_char(:PRIOR_DEPRN_LIMIT)"
,PRIOR_DEPRN_LIMIT_AMOUNT       "fun_load_interface_utils_pkg.replace_decimal_char(:PRIOR_DEPRN_LIMIT_AMOUNT)"
,PRIOR_METHOD_CODE
,PRIOR_LIFE_IN_MONTHS
,PRIOR_BASIC_RATE
,PRIOR_ADJUSTED_RATE
,ASSET_SCHEDULE_NUM      
,LEASE_NUMBER
,REVAL_RESERVE
,REVAL_LOSS_BALANCE
,REVAL_AMORTIZATION_BASIS
,IMPAIR_LOSS_BALANCE
,REVAL_CEILING
,FAIR_MARKET_VALUE
,LAST_PRICE_INDEX_VALUE
,GLOBAL_ATTRIBUTE_NUMBER6       "fun_load_interface_utils_pkg.replace_decimal_char(:GLOBAL_ATTRIBUTE_NUMBER6)"
,GLOBAL_ATTRIBUTE_NUMBER7       "fun_load_interface_utils_pkg.replace_decimal_char(:GLOBAL_ATTRIBUTE_NUMBER7)"
,GLOBAL_ATTRIBUTE_NUMBER8       "fun_load_interface_utils_pkg.replace_decimal_char(:GLOBAL_ATTRIBUTE_NUMBER8)"
,GLOBAL_ATTRIBUTE_NUMBER9       "fun_load_interface_utils_pkg.replace_decimal_char(:GLOBAL_ATTRIBUTE_NUMBER9)"
,GLOBAL_ATTRIBUTE_NUMBER10      "fun_load_interface_utils_pkg.replace_decimal_char(:GLOBAL_ATTRIBUTE_NUMBER10)"
,GLOBAL_ATTRIBUTE_DATE6         "to_date(:GLOBAL_ATTRIBUTE_DATE6, 'YYYY/MM/DD')"
,GLOBAL_ATTRIBUTE_DATE7         "to_date(:GLOBAL_ATTRIBUTE_DATE7, 'YYYY/MM/DD')"
,GLOBAL_ATTRIBUTE_DATE8         "to_date(:GLOBAL_ATTRIBUTE_DATE8, 'YYYY/MM/DD')"
,GLOBAL_ATTRIBUTE_DATE9         "to_date(:GLOBAL_ATTRIBUTE_DATE9, 'YYYY/MM/DD')"
,GLOBAL_ATTRIBUTE_DATE10        "to_date(:GLOBAL_ATTRIBUTE_DATE10, 'YYYY/MM/DD')"
,BK_GLOBAL_ATTRIBUTE1           CHAR(600)
,BK_GLOBAL_ATTRIBUTE2           CHAR(600)
,BK_GLOBAL_ATTRIBUTE3           CHAR(600)
,BK_GLOBAL_ATTRIBUTE4           CHAR(600)
,BK_GLOBAL_ATTRIBUTE5           CHAR(600)
,BK_GLOBAL_ATTRIBUTE6           CHAR(600)
,BK_GLOBAL_ATTRIBUTE7           CHAR(600)
,BK_GLOBAL_ATTRIBUTE8           CHAR(600)
,BK_GLOBAL_ATTRIBUTE9           CHAR(600)
,BK_GLOBAL_ATTRIBUTE10          CHAR(600)
,BK_GLOBAL_ATTRIBUTE11          CHAR(600)
,BK_GLOBAL_ATTRIBUTE12          CHAR(600)
,BK_GLOBAL_ATTRIBUTE13          CHAR(600)
,BK_GLOBAL_ATTRIBUTE14          CHAR(600)
,BK_GLOBAL_ATTRIBUTE15          CHAR(600)
,BK_GLOBAL_ATTRIBUTE16          CHAR(600)
,BK_GLOBAL_ATTRIBUTE17          CHAR(600)
,BK_GLOBAL_ATTRIBUTE18          CHAR(600)
,BK_GLOBAL_ATTRIBUTE19          CHAR(600)
,BK_GLOBAL_ATTRIBUTE20          CHAR(600)
,BK_GLOBAL_ATTRIBUTE_NUMBER1       "fun_load_interface_utils_pkg.replace_decimal_char(:BK_GLOBAL_ATTRIBUTE_NUMBER1)"
,BK_GLOBAL_ATTRIBUTE_NUMBER2       "fun_load_interface_utils_pkg.replace_decimal_char(:BK_GLOBAL_ATTRIBUTE_NUMBER2)"
,BK_GLOBAL_ATTRIBUTE_NUMBER3       "fun_load_interface_utils_pkg.replace_decimal_char(:BK_GLOBAL_ATTRIBUTE_NUMBER3)"
,BK_GLOBAL_ATTRIBUTE_NUMBER4       "fun_load_interface_utils_pkg.replace_decimal_char(:BK_GLOBAL_ATTRIBUTE_NUMBER4)"
,BK_GLOBAL_ATTRIBUTE_NUMBER5       "fun_load_interface_utils_pkg.replace_decimal_char(:BK_GLOBAL_ATTRIBUTE_NUMBER5)"
,BK_GLOBAL_ATTRIBUTE_DATE1         "to_date(:BK_GLOBAL_ATTRIBUTE_DATE1, 'YYYY/MM/DD')"
,BK_GLOBAL_ATTRIBUTE_DATE2         "to_date(:BK_GLOBAL_ATTRIBUTE_DATE2, 'YYYY/MM/DD')"
,BK_GLOBAL_ATTRIBUTE_DATE3         "to_date(:BK_GLOBAL_ATTRIBUTE_DATE3, 'YYYY/MM/DD')"
,BK_GLOBAL_ATTRIBUTE_DATE4         "to_date(:BK_GLOBAL_ATTRIBUTE_DATE4, 'YYYY/MM/DD')"
,BK_GLOBAL_ATTRIBUTE_DATE5         "to_date(:BK_GLOBAL_ATTRIBUTE_DATE5, 'YYYY/MM/DD')"
,BK_GLOBAL_ATTRIBUTE_CATEGORY
,TH_GLOBAL_ATTRIBUTE1          CHAR(600)
,TH_GLOBAL_ATTRIBUTE2          CHAR(600)
,TH_GLOBAL_ATTRIBUTE3          CHAR(600)
,TH_GLOBAL_ATTRIBUTE4          CHAR(600)
,TH_GLOBAL_ATTRIBUTE5          CHAR(600)
,TH_GLOBAL_ATTRIBUTE6          CHAR(600)
,TH_GLOBAL_ATTRIBUTE7          CHAR(600)
,TH_GLOBAL_ATTRIBUTE8          CHAR(600)
,TH_GLOBAL_ATTRIBUTE9          CHAR(600)
,TH_GLOBAL_ATTRIBUTE10         CHAR(600)
,TH_GLOBAL_ATTRIBUTE11         CHAR(600)
,TH_GLOBAL_ATTRIBUTE12         CHAR(600)
,TH_GLOBAL_ATTRIBUTE13         CHAR(600)
,TH_GLOBAL_ATTRIBUTE14         CHAR(600)
,TH_GLOBAL_ATTRIBUTE15         CHAR(600)
,TH_GLOBAL_ATTRIBUTE16         CHAR(600)
,TH_GLOBAL_ATTRIBUTE17         CHAR(600)
,TH_GLOBAL_ATTRIBUTE18         CHAR(600)
,TH_GLOBAL_ATTRIBUTE19         CHAR(600)
,TH_GLOBAL_ATTRIBUTE20         CHAR(600)
,TH_GLOBAL_ATTRIBUTE_NUMBER1       "fun_load_interface_utils_pkg.replace_decimal_char(:TH_GLOBAL_ATTRIBUTE_NUMBER1)"
,TH_GLOBAL_ATTRIBUTE_NUMBER2       "fun_load_interface_utils_pkg.replace_decimal_char(:TH_GLOBAL_ATTRIBUTE_NUMBER2)"
,TH_GLOBAL_ATTRIBUTE_NUMBER3       "fun_load_interface_utils_pkg.replace_decimal_char(:TH_GLOBAL_ATTRIBUTE_NUMBER3)"
,TH_GLOBAL_ATTRIBUTE_NUMBER4       "fun_load_interface_utils_pkg.replace_decimal_char(:TH_GLOBAL_ATTRIBUTE_NUMBER4)"
,TH_GLOBAL_ATTRIBUTE_NUMBER5       "fun_load_interface_utils_pkg.replace_decimal_char(:TH_GLOBAL_ATTRIBUTE_NUMBER5)"
,TH_GLOBAL_ATTRIBUTE_DATE1         "to_date(:TH_GLOBAL_ATTRIBUTE_DATE1, 'YYYY/MM/DD')"
,TH_GLOBAL_ATTRIBUTE_DATE2         "to_date(:TH_GLOBAL_ATTRIBUTE_DATE2, 'YYYY/MM/DD')"
,TH_GLOBAL_ATTRIBUTE_DATE3         "to_date(:TH_GLOBAL_ATTRIBUTE_DATE3, 'YYYY/MM/DD')"
,TH_GLOBAL_ATTRIBUTE_DATE4         "to_date(:TH_GLOBAL_ATTRIBUTE_DATE4, 'YYYY/MM/DD')"
,TH_GLOBAL_ATTRIBUTE_DATE5         "to_date(:TH_GLOBAL_ATTRIBUTE_DATE5, 'YYYY/MM/DD')"
,TH_GLOBAL_ATTRIBUTE_CATEGORY
,AI_GLOBAL_ATTRIBUTE1             CHAR(600)
,AI_GLOBAL_ATTRIBUTE2             CHAR(600)
,AI_GLOBAL_ATTRIBUTE3             CHAR(600)
,AI_GLOBAL_ATTRIBUTE4             CHAR(600)
,AI_GLOBAL_ATTRIBUTE5             CHAR(600)
,AI_GLOBAL_ATTRIBUTE6             CHAR(600)
,AI_GLOBAL_ATTRIBUTE7             CHAR(600)
,AI_GLOBAL_ATTRIBUTE8             CHAR(600)
,AI_GLOBAL_ATTRIBUTE9             CHAR(600)
,AI_GLOBAL_ATTRIBUTE10            CHAR(600)
,AI_GLOBAL_ATTRIBUTE11            CHAR(600)
,AI_GLOBAL_ATTRIBUTE12            CHAR(600)
,AI_GLOBAL_ATTRIBUTE13            CHAR(600)
,AI_GLOBAL_ATTRIBUTE14            CHAR(600)
,AI_GLOBAL_ATTRIBUTE15            CHAR(600)
,AI_GLOBAL_ATTRIBUTE16            CHAR(600)
,AI_GLOBAL_ATTRIBUTE17            CHAR(600)
,AI_GLOBAL_ATTRIBUTE18            CHAR(600)
,AI_GLOBAL_ATTRIBUTE19            CHAR(600)
,AI_GLOBAL_ATTRIBUTE20            CHAR(600)
,AI_GLOBAL_ATTRIBUTE_NUMBER1       "fun_load_interface_utils_pkg.replace_decimal_char(:AI_GLOBAL_ATTRIBUTE_NUMBER1)"
,AI_GLOBAL_ATTRIBUTE_NUMBER2       "fun_load_interface_utils_pkg.replace_decimal_char(:AI_GLOBAL_ATTRIBUTE_NUMBER2)"
,AI_GLOBAL_ATTRIBUTE_NUMBER3       "fun_load_interface_utils_pkg.replace_decimal_char(:AI_GLOBAL_ATTRIBUTE_NUMBER3)"
,AI_GLOBAL_ATTRIBUTE_NUMBER4       "fun_load_interface_utils_pkg.replace_decimal_char(:AI_GLOBAL_ATTRIBUTE_NUMBER4)"
,AI_GLOBAL_ATTRIBUTE_NUMBER5       "fun_load_interface_utils_pkg.replace_decimal_char(:AI_GLOBAL_ATTRIBUTE_NUMBER5)"
,AI_GLOBAL_ATTRIBUTE_DATE1         "to_date(:AI_GLOBAL_ATTRIBUTE_DATE1, 'YYYY/MM/DD')"
,AI_GLOBAL_ATTRIBUTE_DATE2         "to_date(:AI_GLOBAL_ATTRIBUTE_DATE2, 'YYYY/MM/DD')"
,AI_GLOBAL_ATTRIBUTE_DATE3         "to_date(:AI_GLOBAL_ATTRIBUTE_DATE3, 'YYYY/MM/DD')"
,AI_GLOBAL_ATTRIBUTE_DATE4         "to_date(:AI_GLOBAL_ATTRIBUTE_DATE4, 'YYYY/MM/DD')"
,AI_GLOBAL_ATTRIBUTE_DATE5         "to_date(:AI_GLOBAL_ATTRIBUTE_DATE5, 'YYYY/MM/DD')"
,AI_GLOBAL_ATTRIBUTE_CATEGORY
,VENDOR_NAME CHAR(360)
,VENDOR_NUMBER
,PO_NUMBER
,INVOICE_NUMBER
,INVOICE_VOUCHER_NUMBER
,INVOICE_DATE                     "to_date(:INVOICE_DATE, 'YYYY/MM/DD')"
,PAYABLES_UNITS                   "fun_load_interface_utils_pkg.replace_decimal_char(:PAYABLES_UNITS)"
,INVOICE_LINE_NUMBER              "fun_load_interface_utils_pkg.replace_decimal_char(:INVOICE_LINE_NUMBER)"
,INVOICE_LINE_TYPE 
,INVOICE_LINE_DESCRIPTION
,INVOICE_PAYMENT_NUMBER           "fun_load_interface_utils_pkg.replace_decimal_char(:INVOICE_PAYMENT_NUMBER)"
,PROJECT_NUMBER
,PROJECT_TASK_NUMBER
,FULLY_RESERVE_ON_ADD_FLAG
,DEPRN_ADJUSTMENT_FACTOR          "fun_load_interface_utils_pkg.replace_decimal_char(:DEPRN_ADJUSTMENT_FACTOR)"
,REVALUED_COST                    "fun_load_interface_utils_pkg.replace_decimal_char(:REVALUED_COST)"
,BACKLOG_DEPRN_RESERVE            "fun_load_interface_utils_pkg.replace_decimal_char(:BACKLOG_DEPRN_RESERVE)"
,YTD_BACKLOG_DEPRN                "fun_load_interface_utils_pkg.replace_decimal_char(:YTD_BACKLOG_DEPRN)"
,REVAL_AMORT_BALANCE              "fun_load_interface_utils_pkg.replace_decimal_char(:REVAL_AMORT_BALANCE)"
,YTD_REVAL_AMORTIZATION           "fun_load_interface_utils_pkg.replace_decimal_char(:YTD_REVAL_AMORTIZATION)"
,BATCH_NAME
,SPLIT_MERGED_CODE              ":MERGED_CODE"
,APPROVAL_TYPE_CODE             "nvl2(:BATCH_NAME, 'ORA_FA_MASS', NULL)"
--,MERGE_PARENT_MASS_ADDITIONS_ID "FA_INTERFACE_UTILS_PKG.get_parent_merged_key1('MASSADD', :PARENT_MASS_ADDITION_ID, :MERGED_CODE, '100')"
,MERGE_PARENT_MASS_ADDITIONS_ID "FA_INTERFACE_UTILS_PKG.get_parent_merged_key1('MASSADD', :PARENT_MASS_ADDITION_ID, :MERGED_CODE, '#LOADREQUESTID#')"
)

