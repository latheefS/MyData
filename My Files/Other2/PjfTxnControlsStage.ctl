      --  This is file is a duplicate of PjcTxnControlsStage.ctl that is in the prj/pjc/bin directory. Was duplicated to resolve the issue during Import as the program needs files from 2 different product families. Bug 17261527
      --  This control file loads third party project transaction controls. It populates into staging table PJC_TXN_CONTROLS_STAGE. 
      --  This table can be populated with named columns (Project Number, Task Number, etc) and / or with corresponding ID columns.
      --  Core processing tbale PJC_TRANSACTION_CONTROLS will be populated with all required ID columns after performing mapping of name to ID
      --  This control file can accept transaction controls data in sequence of columns in CSV is defined as per following order. 
     
     LOAD DATA
     INFILE *
     APPEND
     INTO TABLE PJC_TXN_CONTROLS_STAGE 
     FIELDS TERMINATED BY ','
     OPTIONALLY ENCLOSED BY '"'
     TRAILING NULLCOLS 
     (                                                                        
     TXN_CTRL_REFERENCE,
     PROJECT_NAME "TRIM(:PROJECT_NAME)",
     PROJECT_NUMBER "TRIM(:PROJECT_NUMBER)",

     TASK_NUMBER,
     TASK_NAME,     
     				           
     EXPENDITURE_CATEGORY_NAME,                                                                            
     EXPENDITURE_TYPE,
                                                                            
     NON_LABOR_RESOURCE,
      
     PERSON_NUMBER,
     PERSON_NAME        CHAR(2000),
     Person_EMAILID,
     PERSON_TYPE,
      
     JOB_NAME,
      
     ORGANIZATION_NAME,
      
     CHARGEABLE_FLAG,
     BILLABLE_FLAG "SUBSTR(:BILLABLE_FLAG, 0, 1)",

     CAPITALIZABLE_FLAG,
      
     START_DATE_ACTIVE "to_date(:START_DATE_ACTIVE, 'YYYY/MM/DD')" , 
     END_DATE_ACTIVE "to_date(:END_DATE_ACTIVE, 'YYYY/MM/DD')" , 
      
     TXN_CONTROL_ID expression "S_ROW_ID_SEQ.nextval",
     STATUS_CODE CONSTANT 'P',
      
     LOAD_REQUEST_ID CONSTANT  '#LOADREQUESTID#',
 --  LOAD_REQUEST_ID CONSTANT  '9999',
      
     OBJECT_VERSION_NUMBER CONSTANT  1,
     LAST_UPDATE_LOGIN CONSTANT  '#LASTUPDATELOGIN#',
     CREATED_BY CONSTANT  '#CREATEDBY#',
     CREATION_DATE EXPRESSION "systimestamp",
     LAST_UPDATED_BY CONSTANT  '#LASTUPDATEDBY#',
 --  LAST_UPDATE_DATE EXPRESSION "systimestamp",
 --  LAST_UPDATE_LOGIN CONSTANT 1,
 --  CREATED_BY CONSTANT 1,
 --  CREATION_DATE EXPRESSION "systimestamp",
 --  LAST_UPDATED_BY CONSTANT 1,
   LAST_UPDATE_DATE EXPRESSION "systimestamp"
)
