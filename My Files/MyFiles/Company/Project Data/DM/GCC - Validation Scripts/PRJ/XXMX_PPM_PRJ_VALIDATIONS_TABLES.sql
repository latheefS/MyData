 /*
	 ******************************************************************************
     ** FILENAME  :  XXMX_PPM_PRJ_VALIDATIONS_TABLES.SQL
     **
     ** VERSION   :  1.0
     **
     ** EXECUTE
     ** IN SCHEMA :  APPS
     **
     ** AUTHORS   :  Sushma Chowdary Kotapati/Veda Poojitha
     **
     ** PURPOSE   :  This script installs the validation tables for Projects.
     **
     ** NOTES     :

     **   Vsn  Change Date  Changed By          Change Description
     ** -----  -----------  ------------------  -----------------------------------
     ** [ 1.0  DD-Mon-YYYY  Change Author       Created.                          ]
     **
     ******************************************************************************
     **
     ** XXMX_PPM_PRJ_VALIDATIONS_TABLES HISTORY
     ** ------------------------------------
     **
     **   Vsn  Change Date  Changed By                                                    Change Description
     ** -----  -----------  ------------------                                            -----------------------------------
     **   1.0  15-MAR-2024  Sushma Chowdary Kotapati/Veda Poojitha                        Initial implementation
     ******************************************************************************
     */
    -- 
  
  DROP TABLE XXMX_CORE.XXMX_PPM_PROJECTS_VAL;
  --
  CREATE TABLE XXMX_CORE.XXMX_PPM_PROJECTS_VAL
 (
  VALIDATION_ERROR_MESSAGE             VARCHAR2(3000),
  FILE_SET_ID                         VARCHAR2(30),   
  MIGRATION_SET_ID                     NUMBER,         
  MIGRATION_SET_NAME                   VARCHAR2(100),  
  MIGRATION_STATUS                     VARCHAR2(50),   
  LOAD_BATCH                           VARCHAR2(300),  
  PROJECT_NAME                         VARCHAR2(240),  
  PROJECT_NUMBER                       VARCHAR2(25),   
  SOURCE_TEMPLATE_NUMBER               NUMBER(18),     
  SOURCE_TEMPLATE_NAME                 VARCHAR2(240),  
  SOURCE_APPLICATION_CODE              VARCHAR2(30),   
  SOURCE_PROJECT_REFERENCE             VARCHAR2(25),   
  SCHEDULE_NAME                        VARCHAR2(200),  
  EPS_NAME                             VARCHAR2(200),  
  PROJECT_PLAN_VIEW_ACCESS             VARCHAR2(30),   
  SCHEDULE_TYPE                        VARCHAR2(30),   
  ORGANIZATION_NAME                    VARCHAR2(240),  
  LEGAL_ENTITY_NAME                    VARCHAR2(240),  
  DESCRIPTION                          VARCHAR2(2000), 
  PROJECT_MANAGER_NUMBER               VARCHAR2(30),   
  PROJECT_MANAGER_NAME                 VARCHAR2(240),  
  PROJECT_MANAGER_EMAIL                VARCHAR2(240), 
  PROJECT_START_DATE                   DATE,           
  PROJECT_FINISH_DATE                  DATE,           
  CLOSED_DATE                          DATE,           
  PRJ_PLAN_BASELINE_NAME               VARCHAR2(100),  
  PRJ_PLAN_BASELINE_DESC               VARCHAR2(1000), 
  PRJ_PLAN_BASELINE_DATE               DATE,           
  PROJECT_STATUS_NAME                  VARCHAR2(80),   
  PROJECT_PRIORITY_CODE                VARCHAR2(30),   
  OUTLINE_DISPLAY_LEVEL                NUMBER(18),     
  PLANNING_PROJECT_FLAG                VARCHAR2(1),    
  SERVICE_TYPE_CODE                    VARCHAR2(30),   
  WORK_TYPE_NAME                       VARCHAR2(240),  
  LIMIT_TO_TXN_CONTROLS_CODE           VARCHAR2(30),   
  BUDGETARY_CONTROL_FLAG               VARCHAR2(1),    
  PROJECT_CURRENCY_CODE                VARCHAR2(15),   
  CURRENCY_CONV_RATE_TYPE              VARCHAR2(15),   
  CURRENCY_CONV_DATE_TYPE_CODE         VARCHAR2(1),    
  CURRENCY_CONV_DATE                   DATE,           
  CINT_ELIGIBLE_FLAG                   VARCHAR2(1),    
  CINT_RATE_SCH_NAME                   VARCHAR2(30),   
  CINT_STOP_DATE                       DATE,           
  ASSET_ALLOCATION_METHOD_CODE         VARCHAR2(30),   
  CAPITAL_EVENT_PROCESSING_CODE        VARCHAR2(30),   
  ALLOW_CROSS_CHARGE_FLAG              VARCHAR2(1),    
  CC_PROCESS_LABOR_FLAG                VARCHAR2(1),    
  LABOR_TP_SCHEDULE_NAME               VARCHAR2(50),   
  LABOR_TP_FIXED_DATE                  DATE,           
  CC_PROCESS_NL_FLAG                   VARCHAR2(1),    
  NL_TP_SCHEDULE_NAME                  VARCHAR2(50),   
  NL_TP_FIXED_DATE                     DATE,           
  BURDEN_SCHEDULE_NAME                 VARCHAR2(30),   
  BURDEN_SCH_FIXED_DATED               DATE,           
  KPI_NOTIFICATION_ENABLED             VARCHAR2(5),    
  KPI_NOTIFICATION_RECIPIENTS          VARCHAR2(30),   
  KPI_NOTIFICATION_INCLUDE_NOTES       VARCHAR2(5),    
  COPY_TEAM_MEMBERS_FLAG               VARCHAR2(1),    
  COPY_CLASSIFICATIONS_FLAG            VARCHAR2(1),    
  COPY_ATTACHMENTS_FLAG                VARCHAR2(1),    
  COPY_DFF_FLAG                        VARCHAR2(1),    
  COPY_TASKS_FLAG                      VARCHAR2(1),    
  COPY_TASK_ATTACHMENTS_FLAG           VARCHAR2(1),    
  COPY_TASK_DFF_FLAG                   VARCHAR2(1),    
  COPY_TASK_ASSIGNMENTS_FLAG           VARCHAR2(1),    
  COPY_TRANSACTION_CONTROLS_FLAG       VARCHAR2(1),    
  COPY_ASSETS_FLAG                     VARCHAR2(1),    
  COPY_ASSET_ASSIGNMENTS_FLAG          VARCHAR2(1),    
  COPY_COST_OVERRIDES_FLAG             VARCHAR2(1),    
  OPPORTUNITY_ID                       NUMBER(18),     
  OPPORTUNITY_NUMBER                   VARCHAR2(240),  
  OPPORTUNITY_CUSTOMER_NUMBER          VARCHAR2(240),  
  OPPORTUNITY_CUSTOMER_ID              NUMBER(18),     
  OPPORTUNITY_AMT                      NUMBER,         
  OPPORTUNITY_CURRCODE                 VARCHAR2(15),   
  OPPORTUNITY_WIN_CONF_PERCENT         NUMBER,         
  OPPORTUNITY_NAME                     VARCHAR2(240),  
  OPPORTUNITY_DESC                     VARCHAR2(1000), 
  OPPORTUNITY_CUSTOMER_NAME            VARCHAR2(900),  
  OPPORTUNITY_STATUS                   VARCHAR2(240),             
  XFACE_REC_ID                         NUMBER(18),     
  ORG_ID                               NUMBER(18),     
  COPY_GROUP_SPACE_FLAG                VARCHAR2(1),    
  PROJECT_ID                           VARCHAR2(30),   
  PROJ_OWNING_ORG                      VARCHAR2(240),  
  BATCH_ID                             VARCHAR2(80),   
  BATCH_NAME                           VARCHAR2(240),  
  CREATED_BY                           VARCHAR2(64),   
  CREATION_DATE                        TIMESTAMP(6),   
  LAST_UPDATE_LOGIN                    VARCHAR2(64),   
  LAST_UPDATED_BY                      VARCHAR2(64),   
  LAST_UPDATE_DATE                     TIMESTAMP(6),  
  LOAD_STATUS                          VARCHAR2(10),  
  IMPORT_STATUS                        VARCHAR2(10),   
  LOAD_REQUEST_ID                      NUMBER(18),    
  REQUEST_ID                           NUMBER(18),     
  OBJECT_VERSION_NUMBER                NUMBER(9)
 );  
  --
  DROP TABLE XXMX_CORE.XXMX_PPM_PRJ_TASKS_VAL;
  --
  CREATE TABLE XXMX_CORE.XXMX_PPM_PRJ_TASKS_VAL 
 (
  VALIDATION_ERROR_MESSAGE           VARCHAR2(3000),
  FILE_SET_ID                        VARCHAR2(30),   
  MIGRATION_SET_ID                   NUMBER,         
  MIGRATION_SET_NAME                 VARCHAR2(100),  
  MIGRATION_STATUS                   VARCHAR2(50),   
  LOAD_BATCH                         VARCHAR2(300),  
  PROJECT_NAME                       VARCHAR2(240),  
  PROJECT_NUMBER                     VARCHAR2(25),   
  TASK_NAME                          VARCHAR2(255),  
  TASK_NUMBER                        VARCHAR2(100),  
  SOURCE_TASK_REFERENCE              VARCHAR2(25),   
  FINANCIAL_TASK                     VARCHAR2(1),    
  TASK_DESCRIPTION                   VARCHAR2(2000), 
  PARENT_TASK_NUMBER                 VARCHAR2(100),  
  PLANNING_START_DATE                DATE,           
  PLANNING_END_DATE                  DATE,           
  PLANNED_EFFORT                     NUMBER,         
  PLANNED_DURATION                   NUMBER,         
  MILESTONE_FLAG                     VARCHAR2(1),    
  CRITICAL_FLAG                      VARCHAR2(1),    
  CHARGEABLE_FLAG                    VARCHAR2(1),    
  BILLABLE_FLAG                      VARCHAR2(1),    
  CAPITALIZABLE_FLAG                 VARCHAR2(1),    
  LIMIT_TO_TXN_CONTROLS_FLAG         VARCHAR2(1),    
  SERVICE_TYPE_CODE                  VARCHAR2(30),   
  WORK_TYPE_ID                       NUMBER(18),     
  MANAGER_PERSON_ID                  NUMBER(18),     
  ALLOW_CROSS_CHARGE_FLAG            VARCHAR2(1),    
  CC_PROCESS_LABOR_FLAG              VARCHAR2(1),    
  CC_PROCESS_NL_FLAG                 VARCHAR2(1),    
  RECEIVE_PROJECT_INVOICE_FLAG       VARCHAR2(1),    
  ORGANIZATION_NAME                  VARCHAR2(240),  
  REQMNT_CODE                        VARCHAR2(30),   
  SPRINT                             VARCHAR2(30),   
  PRIORITY                           NUMBER(18),     
  SCHEDULE_MODE                      VARCHAR2(240),  
  BASELINE_START_DATE                DATE,           
  BASELINE_FINISH_DATE               DATE,           
  BASELINE_EFFORT                    NUMBER,         
  BASELINE_DURATION                  NUMBER,         
  BASELINE_ALLOCATION                NUMBER,         
  BASELINE_LABOR_COST_AMOUNT         NUMBER,         
  BASELINE_LABOR_BILLED_AMOUNT       NUMBER,        
  BASELINE_EXPENSE_COST_AMOUNT       NUMBER,        
  CONSTRAINT_TYPE_CODE               VARCHAR2(240),  
  CONSTRAINT_DATE                    DATE,                     
  SOURCE_APPLICATION_CODE            VARCHAR2(240),  
  OPERATING_UNIT                     VARCHAR2(240),  
  LEDGER_NAME                        VARCHAR2(30),   
  BATCH_ID                           VARCHAR2(80),   
  BATCH_NAME                         VARCHAR2(240),  
  CREATED_BY                         VARCHAR2(64),   
  CREATION_DATE                      TIMESTAMP(6),   
  LAST_UPDATE_LOGIN                  VARCHAR2(64),   
  LAST_UPDATED_BY                    VARCHAR2(64),   
  LAST_UPDATE_DATE                   TIMESTAMP(6),   
  LOAD_STATUS                        VARCHAR2(10),   
  IMPORT_STATUS                      VARCHAR2(10)   
 );
 --
 DROP TABLE xxmx_core.XXMX_PPM_PRJ_TRX_CONTROL_VAL;
 --
 CREATE table xxmx_core.XXMX_PPM_PRJ_TRX_CONTROL_VAL
 (
  VALIDATION_ERROR_MESSAGE        VARCHAR2(3000),
  FILE_SET_ID                     VARCHAR2(30),   
  MIGRATION_SET_ID                NUMBER,         
  MIGRATION_SET_NAME              VARCHAR2(100),  
  MIGRATION_STATUS                VARCHAR2(50),   
  LOAD_BATCH                      VARCHAR2(300),  
  TXN_CTRL_REFERENCE              VARCHAR2(240),  
  PROJECT_NAME                    VARCHAR2(240),  
  PROJECT_NUMBER                  VARCHAR2(25),   
  TASK_NUMBER                     VARCHAR2(100),  
  TASK_NAME                       VARCHAR2(255),  
  EXPENDITURE_CATEGORY_NAME       VARCHAR2(240),  
  EXPENDITURE_TYPE                VARCHAR2(240),  
  NON_LABOR_RESOURCE              VARCHAR2(240),  
  PERSON_NUMBER                   VARCHAR2(30),   
  PERSON_NAME                     VARCHAR2(2000), 
  PERSON_EMAIL                    VARCHAR2(360),  
  PERSON_TYPE                     VARCHAR2(20),   
  JOB_NAME                        VARCHAR2(240),  
  ORGANIZATION_NAME               VARCHAR2(240),  
  CHARGEABLE_FLAG                 VARCHAR2(1),    
  BILLABLE_FLAG                   VARCHAR2(1),    
  CAPITALIZABLE_FLAG              VARCHAR2(1),    
  START_DATE_ACTIVE               DATE,           
  END_DATE_ACTIVE                 DATE,           
  BATCH_ID                        VARCHAR2(80),   
  BATCH_NAME                      VARCHAR2(240),  
  CREATED_BY                      VARCHAR2(64),   
  CREATION_DATE                   TIMESTAMP(6),   
  LAST_UPDATE_LOGIN               VARCHAR2(64),   
  LAST_UPDATED_BY                 VARCHAR2(64),   
  LAST_UPDATE_DATE                TIMESTAMP(6)   
 );
 --
 DROP TABLE xxmx_core.XXMX_PPM_PRJ_TEAM_MEM_VAL;
 --
 CREATE TABLE xxmx_core.XXMX_PPM_PRJ_TEAM_MEM_VAL
 (
  VALIDATION_ERROR_MESSAGE           VARCHAR2(3000),
  FILE_SET_ID                        VARCHAR2(30),  
  MIGRATION_SET_ID                   NUMBER,        
  MIGRATION_SET_NAME                 VARCHAR2(100), 
  MIGRATION_STATUS                   VARCHAR2(50),  
  LOAD_BATCH                         VARCHAR2(300), 
  PROJECT_NAME                       VARCHAR2(240), 
  TEAM_MEMBER_NUMBER                 NUMBER(30),    
  TEAM_MEMBER_NAME                   VARCHAR2(240), 
  TEAM_MEMBER_EMAIL                  VARCHAR2(240), 
  PROJECT_ROLE                       VARCHAR2(240), 
  START_DATE_ACTIVE                  DATE,          
  END_DATE_ACTIVE                    DATE,          
  ALLOCATION                         NUMBER,        
  LABOR_EFFORT                       NUMBER,        
  COST_RATE                          NUMBER,        
  BILL_RATE                          NUMBER,        
  TRACK_TIME                         VARCHAR2(1),   
  ASSIGNMENT_TYPE_CODE               VARCHAR2(30),  
  BILLABLE_PERCENT                   NUMBER,        
  BILLABLE_PERCENT_REASON_CODE       VARCHAR2(30),  
  BATCH_ID                           VARCHAR2(80),  
  BATCH_NAME                         VARCHAR2(240), 
  PROJECT_NUMBER                     VARCHAR2(25),  
  ORGANIZATION_NAME                  VARCHAR2(240), 
  CREATED_BY                         VARCHAR2(64),  
  CREATION_DATE                      TIMESTAMP(6),  
  LAST_UPDATE_LOGIN                  VARCHAR2(64),  
  LAST_UPDATED_BY                    VARCHAR2(64),  
  LAST_UPDATE_DATE                   TIMESTAMP(6)
 ); 
 --
 DROP TABLE xxmx_core.XXMX_PPM_PRJ_CLASS_VAL;
 --
 CREATE TABLE xxmx_core.XXMX_PPM_PRJ_CLASS_VAL
 (
  VALIDATION_ERROR_MESSAGE VARCHAR2(3000),
  FILE_SET_ID              VARCHAR2(30), 
  MIGRATION_SET_ID         NUMBER,        
  MIGRATION_SET_NAME       VARCHAR2(100), 
  MIGRATION_STATUS         VARCHAR2(50),  
  LOAD_BATCH               VARCHAR2(300), 
  PROJECT_NAME             VARCHAR2(240), 
  CLASS_CATEGORY           VARCHAR2(240), 
  CLASS_CODE               VARCHAR2(240), 
  CODE_PERCENTAGE          NUMBER,        
  PROJECT_NUMBER           VARCHAR2(25),  
  ORGANIZATION_NAME        VARCHAR2(240), 
  BATCH_ID                 VARCHAR2(80),  
  BATCH_NAME               VARCHAR2(240), 
  CREATED_BY               VARCHAR2(64),  
  CREATION_DATE            TIMESTAMP(6),  
  LAST_UPDATE_LOGIN        VARCHAR2(64),  
  LAST_UPDATED_BY          VARCHAR2(64),  
  LAST_UPDATE_DATE         TIMESTAMP(6) 
); 












