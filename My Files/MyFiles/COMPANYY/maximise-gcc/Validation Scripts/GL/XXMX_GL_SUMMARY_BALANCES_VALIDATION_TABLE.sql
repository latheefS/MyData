/*
--------------------------------------------------------------------------
CREATION OF THE VALIDATION TABLE FOR XXMX_GL_SUMMARY_BALANCES_VAL 
(VALIDATION_ERROR_MESSAGE: New Column added as per the package) 
--------------------------------------------------------------------------
*/
--
CREATE TABLE XXMX_GL_SUMMARY_BALANCES_VAL (
VALIDATION_ERROR_MESSAGE            VARCHAR2(500)
,FILE_SET_ID                         VARCHAR2(30)  
,MIGRATION_SET_ID                    NUMBER        
,MIGRATION_SET_NAME                  VARCHAR2(100) 
,MIGRATION_STATUS                    VARCHAR2(50)  
,FUSION_STATUS_CODE                  VARCHAR2(50)  
,LEDGER_ID                           NUMBER(18)    
,ACCOUNTING_DATE                     DATE          
,USER_JE_SOURCE_NAME                 VARCHAR2(25)  
,USER_JE_CATEGORY_NAME               VARCHAR2(25)  
,CURRENCY_CODE                       VARCHAR2(15)  
,DATE_CREATED                        DATE          
,ACTUAL_FLAG                         VARCHAR2(1)   
,SEGMENT1                            VARCHAR2(25)  
,SEGMENT2                            VARCHAR2(25)  
,SEGMENT3                            VARCHAR2(25)  
,SEGMENT4                            VARCHAR2(25)  
,SEGMENT5                            VARCHAR2(25)  
,SEGMENT6                            VARCHAR2(25)  
,SEGMENT7                            VARCHAR2(25)  
,SEGMENT8                            VARCHAR2(25)  
,SEGMENT9                            VARCHAR2(25)  
,SEGMENT10                           VARCHAR2(25)  
,SEGMENT11                           VARCHAR2(25)  
,SEGMENT12                           VARCHAR2(25)  
,SEGMENT13                           VARCHAR2(25)  
,SEGMENT14                           VARCHAR2(25)  
,SEGMENT15                           VARCHAR2(25)  
,SEGMENT16                           VARCHAR2(25)  
,SEGMENT17                           VARCHAR2(25)  
,SEGMENT18                           VARCHAR2(25)  
,SEGMENT19                           VARCHAR2(25)  
,SEGMENT20                           VARCHAR2(25)  
,SEGMENT21                           VARCHAR2(25)  
,SEGMENT22                           VARCHAR2(25)  
,SEGMENT23                           VARCHAR2(25)  
,SEGMENT24                           VARCHAR2(25)  
,SEGMENT25                           VARCHAR2(25)  
,SEGMENT26                           VARCHAR2(25)  
,SEGMENT27                           VARCHAR2(25)  
,SEGMENT28                           VARCHAR2(25)  
,SEGMENT29                           VARCHAR2(25)  
,SEGMENT30                           VARCHAR2(25)  
,ENTERED_DR                          NUMBER        
,ENTERED_CR                          NUMBER        
,ACCOUNTED_DR                        NUMBER        
,ACCOUNTED_CR                        NUMBER        
,REFERENCE1                          VARCHAR2(100) 
,REFERENCE2                          VARCHAR2(240) 
,REFERENCE3                          VARCHAR2(100) 
,REFERENCE4                          VARCHAR2(100) 
,REFERENCE5                          VARCHAR2(240) 
,REFERENCE6                          VARCHAR2(100) 
,REFERENCE7                          VARCHAR2(100) 
,REFERENCE8                          VARCHAR2(100) 
,REFERENCE9                          VARCHAR2(100) 
,REFERENCE10                         VARCHAR2(240) 
,STAT_AMOUNT                         NUMBER        
,USER_CURRENCY_CONVERSION_TYPE       VARCHAR2(30)  
,CURRENCY_CONVERSION_DATE            DATE          
,CURRENCY_CONVERSION_RATE            NUMBER        
,GROUP_ID                            NUMBER(18)    
,ORIGINATING_BAL_SEG_VALUE           VARCHAR2(25)  
,LEDGER_NAME                         VARCHAR2(30)  
,ENCUMBRANCE_TYPE_ID                 NUMBER        
,JGZZ_RECON_REF                      VARCHAR2(240) 
,PERIOD_NAME                         VARCHAR2(15)      
,LOAD_BATCH                          VARCHAR2(300) 
);