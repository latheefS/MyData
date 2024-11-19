/*
	 ******************************************************************************
     ** FILENAME  :  XXMX_FA_MASS_ADDITIONS_VALIDATION_TABLES.pls
     **
     ** VERSION   :  1.0
     **
     ** EXECUTE
     ** IN SCHEMA :  APPS
     **
     ** AUTHORS   :  Sushma Chowdary kotapati
     **
     ** PURPOSE   :  This script installs the validation tables for Fixed Assets.
     **
     ** NOTES     :
     **   Vsn  Change Date  Changed By          Change Description
     ** -----  -----------  ------------------  -----------------------------------
     ** [ 1.0  DD-Mon-YYYY  Change Author       Created.                          ]
     **
     ******************************************************************************
     **
     ** XXMX_FA_VALIDATIONS_PKG HISTORY
     ** ------------------------------------
     **
     **   Vsn  Change Date  Changed By                 Change Description
     ** -----  -----------  ------------------         -----------------------------------
     **   1.0  23-FEB-2024  Sushma Chowdary Kotapati        Initial implementation
     ******************************************************************************
     */
DROP TABLE XXMX_CORE.XXMX_FA_MASS_ADDITIONS_VAL ;
--
CREATE TABLE XXMX_CORE.XXMX_FA_MASS_ADDITIONS_VAL
(VALIDATION_ERROR_MESSAGE     VARCHAR2(3000)
 ,FILE_SET_ID                          VARCHAR2(20)   
 ,MIGRATION_SET_ID                     NUMBER         
 ,MIGRATION_SET_NAME                   VARCHAR2(100)  
 ,MIGRATION_STATUS                     VARCHAR2(50)   
 ,OPERATING_UNIT                       VARCHAR2(240)  
 ,LEDGER_NAME                          VARCHAR2(30)   
 ,MASS_ADDITION_ID                     NUMBER(18)     
 ,ASSET_CATEGORY_ID                    NUMBER(18)     
 ,PREPARER_ID                          NUMBER(18)     
 ,CREATE_BATCH_ID                      NUMBER(18)     
 ,CASH_GENERATING_UNIT_ID              NUMBER(18)     
 ,PO_VENDOR_ID                         NUMBER(18)     
 ,INVOICE_ID                           NUMBER(18)     
 ,PARENT_MASS_ADDITION_ID              NUMBER(18)     
 ,PARENT_ASSET_ID                      NUMBER(18)     
 ,AP_DISTRIBUTION_LINE_NUMBER          NUMBER(18)     
 ,POST_BATCH_ID                        NUMBER(18)     
 ,ADD_TO_ASSET_ID                      NUMBER(18)     
 ,ASSET_KEY_CCID                       NUMBER(18)     
 ,LOAD_REQUEST_ID                      NUMBER(18)     
 ,MERGE_PARENT_MASS_ADDITIONS_ID       NUMBER(18)     
 ,SPLIT_PARENT_MASS_ADDITIONS_ID       NUMBER(18)     
 ,PROJECT_ASSET_LINE_ID                NUMBER(18)     
 ,PROJECT_ID                           NUMBER(18)     
 ,TASK_ID                              NUMBER(18)     
 ,ASSET_ID                             NUMBER(18)     
 ,INVOICE_DISTRIBUTION_ID              NUMBER(18)     
 ,PO_DISTRIBUTION_ID                   NUMBER(18)     
 ,REQUEST_ID                           NUMBER(18)     
 ,WORKER_ID                            NUMBER(18)     
 ,PROCESS_ORDER                        NUMBER(18)     
 ,INVOICE_PAYMENT_ID                   NUMBER(18)     
 ,OBJECT_VERSION_NUMBER                NUMBER(9)      
 ,METHOD_ID                            NUMBER(18)     
 ,FLAT_RATE_ID                         NUMBER(18)     
 ,CONVENTION_TYPE_ID                   NUMBER(18)     
 ,BONUS_RULE_ID                        NUMBER(18)     
 ,CEILING_TYPE_ID                      NUMBER(18)     
 ,PRIOR_METHOD_ID                      NUMBER(18)     
 ,PRIOR_FLAT_RATE_ID                   NUMBER(18)     
 ,WARRANTY_ID                          NUMBER(18)     
 ,ITC_AMOUNT_ID                        NUMBER(18)     
 ,LEASE_ID                             NUMBER(18)     
 ,LESSOR_ID                            NUMBER(18)     
 ,PERIOD_COUNTER_FULLY_RESERVED        NUMBER(18)     
 ,PERIOD_COUNTER_EXTENDED              NUMBER(18)     
 ,PROJECT_ORGANIZATION_ID              NUMBER(18)     
 ,TASK_ORGANIZATION_ID                 NUMBER(18)     
 ,EXPENDITURE_ORGANIZATION_ID          NUMBER(18)     
 ,PROJECT_TXN_DOC_ENTRY_ID             NUMBER(18)     
 ,EXPENDITURE_TYPE_ID                  NUMBER(18)     
 ,LEASE_SCHEDULE_ID                    NUMBER(18)     
 ,SHIP_TO_CUST_LOCATION_ID             NUMBER(18)     
 ,SHIP_TO_LOCATION_ID                  NUMBER(18)     
 ,INTERFACE_LINE_NUM                   NUMBER         
 ,BOOK_TYPE_CODE                       VARCHAR2(30)   
 ,TRANSACTION_NAME                     VARCHAR2(240)  
 ,ASSET_NUMBER                         VARCHAR2(30)   
 ,DESCRIPTION                          VARCHAR2(80)   
 ,TAG_NUMBER                           VARCHAR2(15)   
 ,MANUFACTURER_NAME                    VARCHAR2(360)  
 ,SERIAL_NUMBER                        VARCHAR2(35)   
 ,MODEL_NUMBER                         VARCHAR2(40)   
 ,ASSET_TYPE                           VARCHAR2(11)   
 ,FIXED_ASSETS_COST                    NUMBER         
 ,DATE_PLACED_IN_SERVICE               DATE           
 ,PRORATE_CONVENTION_CODE              VARCHAR2(10)   
 ,FIXED_ASSETS_UNITS                   NUMBER         
 ,CATEGORY_SEGMENT1                    VARCHAR2(30)   
 ,CATEGORY_SEGMENT2                    VARCHAR2(30)   
 ,CATEGORY_SEGMENT3                    VARCHAR2(30)   
 ,CATEGORY_SEGMENT4                    VARCHAR2(30)   
 ,CATEGORY_SEGMENT5                    VARCHAR2(30)   
 ,CATEGORY_SEGMENT6                    VARCHAR2(30)   
 ,CATEGORY_SEGMENT7                    VARCHAR2(30)   
 ,POSTING_STATUS                       VARCHAR2(15)   
 ,QUEUE_NAME                           VARCHAR2(30)   
 ,FEEDER_SYSTEM_NAME                   VARCHAR2(40)   
 ,PARENT_ASSET_NUMBER                  VARCHAR2(30)   
 ,ADD_TO_ASSET_NUMBER                  VARCHAR2(30)    
 ,INVENTORIAL                          VARCHAR2(3)    
 ,PROPERTY_TYPE_CODE                   VARCHAR2(30)   
 ,PROPERTY_1245_1250_CODE              VARCHAR2(4)    
 ,IN_USE_FLAG                          VARCHAR2(3)    
 ,OWNED_LEASED                         VARCHAR2(15)   
 ,NEW_USED                             VARCHAR2(4)    
 ,MATERIAL_INDICATOR_FLAG              VARCHAR2(1)    
 ,COMMITMENT                           VARCHAR2(30)   
 ,INVESTMENT_LAW                       VARCHAR2(30)   
 ,AMORTIZE_FLAG                        VARCHAR2(3)    
 ,AMORTIZATION_START_DATE              DATE           
 ,DEPRECIATE_FLAG                      VARCHAR2(3)    
 ,SALVAGE_TYPE                         VARCHAR2(30)   
 ,SALVAGE_VALUE                        NUMBER         
 ,PERCENT_SALVAGE_VALUE                NUMBER         
 ,YTD_DEPRN                            NUMBER         
 ,DEPRN_RESERVE                        NUMBER         
 ,BONUS_YTD_DEPRN                      NUMBER         
 ,BONUS_DEPRN_RESERVE                  NUMBER         
 ,YTD_IMPAIRMENT                       NUMBER         
 ,IMPAIRMENT_RESERVE                   NUMBER         
 ,METHOD_CODE                          VARCHAR2(12)   
 ,LIFE_IN_MONTHS                       NUMBER(4)      
 ,BASIC_RATE                           NUMBER         
 ,ADJUSTED_RATE                        NUMBER         
 ,UNIT_OF_MEASURE                      VARCHAR2(25)   
 ,PRODUCTION_CAPACITY                  NUMBER         
 ,CEILING_NAME                         VARCHAR2(30)   
 ,BONUS_RULE                           VARCHAR2(30)   
 ,CASH_GENERATING_UNIT                 VARCHAR2(30)   
 ,DEPRN_LIMIT_TYPE                     VARCHAR2(30)   
 ,ALLOWED_DEPRN_LIMIT                  NUMBER         
 ,ALLOWED_DEPRN_LIMIT_AMOUNT           NUMBER         
 ,PAYABLES_COST                        NUMBER         
 ,PAYABLES_CODE_COMBINATION_ID         NUMBER(18)     
 ,CLEARING_ACCT_SEGMENT1               VARCHAR2(25)   
 ,CLEARING_ACCT_SEGMENT2               VARCHAR2(25)   
 ,CLEARING_ACCT_SEGMENT3               VARCHAR2(25)   
 ,CLEARING_ACCT_SEGMENT4               VARCHAR2(25)   
 ,CLEARING_ACCT_SEGMENT5               VARCHAR2(25)   
 ,CLEARING_ACCT_SEGMENT6               VARCHAR2(25)    
 ,MASS_PROPERTY_FLAG                   VARCHAR2(1)    
 ,GROUP_ASSET_NUMBER                   VARCHAR2(30)   
 ,REDUCTION_RATE                       NUMBER         
 ,REDUCE_ADDITION_FLAG                 VARCHAR2(1)    
 ,REDUCE_ADJUSTMENT_FLAG               VARCHAR2(1)    
 ,REDUCE_RETIREMENT_FLAG               VARCHAR2(1)    
 ,RECOGNIZE_GAIN_LOSS                  VARCHAR2(30)   
 ,RECAPTURE_RESERVE_FLAG               VARCHAR2(1)    
 ,LIMIT_PROCEEDS_FLAG                  VARCHAR2(1)    
 ,TERMINAL_GAIN_LOSS                   VARCHAR2(30)   
 ,TRACKING_METHOD                      VARCHAR2(30)   
 ,EXCESS_ALLOCATION_OPTION             VARCHAR2(30)   
 ,DEPRECIATION_OPTION                  VARCHAR2(30)   
 ,MEMBER_ROLLUP_FLAG                   VARCHAR2(1)    
 ,ALLOCATE_TO_FULLY_RSV_FLAG           VARCHAR2(1)    
 ,OVER_DEPRECIATE_OPTION               VARCHAR2(30)   
 ,PREPARER_EMAIL_ADDRESS               VARCHAR2(240)  
 ,MERGED_CODE                          VARCHAR2(3)    
 ,PARENT_INT_LINE_NUM                  NUMBER         
 ,SUM_UNITS                            VARCHAR2(3)    
 ,NEW_MASTER_FLAG                      VARCHAR2(3)    
 ,UNITS_TO_ADJUST                      NUMBER(18)     
 ,SHORT_FISCAL_YEAR_FLAG               VARCHAR2(3)    
 ,CONVERSION_DATE                      DATE           
 ,ORIGINAL_DEPRN_START_DATE            DATE              
 ,NBV_AT_SWITCH                        NUMBER         
 ,PERIOD_NAME_FULLY_RESERVED           VARCHAR2(15)   
 ,PERIOD_NAME_EXTENDED                 VARCHAR2(15)   
 ,PRIOR_DEPRN_LIMIT_TYPE               VARCHAR2(30)   
 ,PRIOR_DEPRN_LIMIT                    NUMBER         
 ,PRIOR_DEPRN_LIMIT_AMOUNT             NUMBER         
 ,PRIOR_METHOD_CODE                    VARCHAR2(12)   
 ,PRIOR_LIFE_IN_MONTHS                 NUMBER(18)     
 ,PRIOR_BASIC_RATE                     NUMBER         
 ,PRIOR_ADJUSTED_RATE                  NUMBER         
 ,ASSET_SCHEDULE_NUM                   NUMBER(18)     
 ,LEASE_NUMBER                         VARCHAR2(30)   
 ,REVAL_RESERVE                        NUMBER         
 ,REVAL_LOSS_BALANCE                   NUMBER         
 ,REVAL_AMORTIZATION_BASIS             NUMBER         
 ,IMPAIR_LOSS_BALANCE                  NUMBER         
 ,REVAL_CEILING                        NUMBER         
 ,FAIR_MARKET_VALUE                    NUMBER         
 ,LAST_PRICE_INDEX_VALUE               NUMBER         
 ,VENDOR_NAME                          VARCHAR2(360)  
 ,VENDOR_NUMBER                        VARCHAR2(30)   
 ,PO_NUMBER                            VARCHAR2(30)   
 ,INVOICE_NUMBER                       VARCHAR2(50)   
 ,INVOICE_VOUCHER_NUMBER               VARCHAR2(50)   
 ,INVOICE_DATE                         DATE           
 ,PAYABLES_UNITS                       NUMBER         
 ,INVOICE_LINE_NUMBER                  NUMBER         
 ,INVOICE_LINE_TYPE                    VARCHAR2(30)   
 ,INVOICE_LINE_DESCRIPTION             VARCHAR2(240)  
 ,INVOICE_PAYMENT_NUMBER               NUMBER(18)     
 ,PROJECT_NUMBER                       VARCHAR2(25)   
 ,PROJECT_TASK_NUMBER                  VARCHAR2(100)  
 ,FULLY_RESERVE_ON_ADD_FLAG            VARCHAR2(1)    
 ,DEPRN_ADJUSTMENT_FACTOR              NUMBER         
 ,REVALUED_COST                        NUMBER         
 ,BACKLOG_DEPRN_RESERVE                NUMBER         
 ,YTD_BACKLOG_DEPRN                    NUMBER         
 ,REVAL_AMORT_BALANCE                  NUMBER         
 ,YTD_REVAL_AMORTIZATION               NUMBER         
 ,ADJUSTED_COST                        NUMBER         
 ,LAST_UPDATED_BY                      VARCHAR2(64)   
 ,REVIEWER_COMMENTS                    VARCHAR2(60)   
 ,INVOICE_CREATED_BY                   VARCHAR2(64)   
 ,INVOICE_UPDATED_BY                   VARCHAR2(64)   
 ,PAYABLES_BATCH_NAME                  VARCHAR2(50)   
 ,SPLIT_MERGED_CODE                    VARCHAR2(3)    
 ,SPLIT_CODE                           VARCHAR2(3)    
 ,DIST_NAME                            VARCHAR2(25)   
 ,CREATED_BY                           VARCHAR2(64)   
 ,LAST_UPDATE_LOGIN                    VARCHAR2(32)   
 ,MERGE_INVOICE_NUMBER                 VARCHAR2(50)   
 ,MERGE_VENDOR_NUMBER                  VARCHAR2(30)   
 ,PREPARER_NAME                        VARCHAR2(240)  
 ,PREPARER_NUMBER                      VARCHAR2(30)   
 ,PERIOD_FULL_RESERVE                  VARCHAR2(30)   
 ,PERIOD_EXTD_DEPRN                    VARCHAR2(30)   
 ,WARRANTY_NUMBER                      VARCHAR2(15)   
 ,ATTACHMENT_FLAG                      VARCHAR2(1)    
 ,ERROR_MSG                            VARCHAR2(2000) 
 ,LOW_VALUE_ASSET_FLAG                 VARCHAR2(1)    
 ,CREATE_EXPENSED_ASSET_FLAG           VARCHAR2(1)    
 ,CAP_THRESHOLD_CHECK_FLAG             VARCHAR2(1)    
 ,LINE_TYPE_LOOKUP_CODE                VARCHAR2(25)   
 ,INTANGIBLE_ASSET_FLAG                VARCHAR2(1)    
 ,CREATE_BATCH_DATE                    DATE           
 ,LAST_UPDATE_DATE                     TIMESTAMP(6)   
 ,CREATION_DATE                        TIMESTAMP(6)   
 ,ACCOUNTING_DATE                      DATE           
 ,GROUP_ASSET_ID                       NUMBER         
 ,YTD_REVAL_DEPRN_EXPENSE              NUMBER         
 ,UNREVALUED_COST                      NUMBER         
 ,FULLY_RSVD_REVALS_COUNTER            NUMBER         
 ,DEPRN_EXPENSE_SEGMENT6               VARCHAR2(25)   
 );
 -- 
 DROP TABLE XXMX_CORE.XXMX_FA_MASS_ADDITION_DIST_VAL ;
--
CREATE TABLE XXMX_CORE.XXMX_FA_MASS_ADDITION_DIST_VAL
(VALIDATION_ERROR_MESSAGE     VARCHAR2(3000) 
,FILE_SET_ID                   VARCHAR2(20)  
,MIGRATION_SET_ID              NUMBER        
,MIGRATION_SET_NAME            VARCHAR2(100) 
,MIGRATION_STATUS              VARCHAR2(50)  
,OPERATING_UNIT                VARCHAR2(240) 
,LEDGER_NAME                   VARCHAR2(30)  
,MASSADD_DIST_ID               NUMBER        
,MASS_ADDITION_ID              NUMBER        
,INTERFACE_LINE_NUM            NUMBER        
,UNITS                         NUMBER        
,EMPLOYEE_EMAIL_ADDRESS        VARCHAR2(240) 
,LOCATION_SEGMENT1             VARCHAR2(30)  
,LOCATION_SEGMENT2             VARCHAR2(30)  
,LOCATION_SEGMENT3             VARCHAR2(30)  
,LOCATION_SEGMENT4             VARCHAR2(30)  
,LOCATION_SEGMENT5             VARCHAR2(30)  
,LOCATION_SEGMENT6             VARCHAR2(30)  
,LOCATION_SEGMENT7             VARCHAR2(30)  
,DEPRN_EXPENSE_CCID            NUMBER        
,LOCATION_ID                   NUMBER        
,EMPLOYEE_ID                   NUMBER        
,LOAD_REQUEST_ID               NUMBER(18)    
,CREATION_DATE                 TIMESTAMP(6)  
,CREATED_BY                    VARCHAR2(64)  
,LAST_UPDATE_DATE              TIMESTAMP(6)  
,LAST_UPDATED_BY               VARCHAR2(64)  
,LAST_UPDATE_LOGIN             VARCHAR2(32)  
,OBJECT_VERSION_NUMBER         NUMBER(9)     
,DEPRN_EXPENSE_SEGMENT1        VARCHAR2(25)  
,DEPRN_EXPENSE_SEGMENT2        VARCHAR2(25)  
,DEPRN_EXPENSE_SEGMENT3        VARCHAR2(25)  
,DEPRN_EXPENSE_SEGMENT4        VARCHAR2(25)  
,DEPRN_EXPENSE_SEGMENT5        VARCHAR2(25)  
,DEPRN_EXPENSE_SEGMENT6        VARCHAR2(25)  
,DEPRN_SOURCE_CODE             VARCHAR2(300) 
);
--
DROP TABLE XXMX_CORE.XXMX_FA_MASS_RATES_VAL ;
--
CREATE TABLE XXMX_CORE.XXMX_FA_MASS_RATES_VAL
(
 VALIDATION_ERROR_MESSAGE     VARCHAR2(3000) 
 ,FILE_SET_ID                   VARCHAR2(20)  
 ,MIGRATION_SET_ID              NUMBER        
 ,MIGRATION_SET_NAME            VARCHAR2(100) 
 ,MIGRATION_STATUS              VARCHAR2(50)  
 ,OPERATING_UNIT                VARCHAR2(240) 
 ,LEDGER_NAME                   VARCHAR2(30)  
 ,SET_OF_BOOKS_ID               NUMBER(18)    
 ,INTERFACE_LINE_NUM            NUMBER        
 ,MASS_ADDITION_ID              NUMBER(18)    
 ,PARENT_MASS_ADDITION_ID       NUMBER(18)    
 ,CURRENCY_CODE                 VARCHAR2(15)  
 ,FIXED_ASSETS_COST             NUMBER        
 ,EXCHANGE_RATE                 NUMBER        
 ,LOAD_REQUEST_ID               NUMBER(18)    
 ,CREATED_BY                    VARCHAR2(64)  
 ,CREATION_DATE                 TIMESTAMP(6)  
 ,LAST_UPDATED_BY               VARCHAR2(64)  
 ,LAST_UPDATE_DATE              TIMESTAMP(6)  
 ,LAST_UPDATE_LOGIN             VARCHAR2(32)  
 ,OBJECT_VERSION_NUMBER         NUMBER(9)  
 );