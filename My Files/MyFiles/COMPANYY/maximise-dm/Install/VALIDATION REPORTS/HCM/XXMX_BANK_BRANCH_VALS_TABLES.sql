 /*
	 ******************************************************************************
     ** FILENAME  :  XXMX_BANK_BRANCH_VALS_TABLES.sql
     **
     ** VERSION   :  1.0
     **
     ** EXECUTE
     ** IN SCHEMA :  APPS
     **
     ** AUTHORS   :  Veda Poojitha
     **
     ** PURPOSE   :  This script installs the validation tables for Banks and Branches.
     **
     ** NOTES     :

     **   Vsn  Change Date  Changed By          Change Description
     ** -----  -----------  ------------------  -----------------------------------
     ** [ 1.0  DD-Mon-YYYY  Change Author       Created.                          ]
     **
     ******************************************************************************
     **
     ** XXMX_BANKS_BRANCHES_VALS_TABLES HISTORY
     ** ------------------------------------
     **
     **   Vsn  Change Date  Changed By                              Change Description
     ** -----  -----------  ------------------                      -----------------------------------
     **   1.0  05-FEB-2024  Veda Poojitha                           Initial implementation
     ******************************************************************************
     */
    -- 
PROMPT
PROMPT
PROMPT **************************************************************
PROMPT **
PROMPT ** Installing validation tables for Banks and Branches.
PROMPT **
PROMPT **************************************************************
PROMPT
PROMPT
--
--
PROMPT
PROMPT
PROMPT *********************
PROMPT ** Dropping Tables
PROMPT *********************
--
--
PROMPT
PROMPT Dropping Table XXMX_BANKS_VAL
PROMPT
--
EXEC DropTable ('XXMX_BANKS_VAL')
--
--
PROMPT
PROMPT Dropping Table XXMX_BANK_BRANCHES_VAL
PROMPT
--
EXEC DropTable ('XXMX_BANK_BRANCHES_VAL')
--	
--
PROMPT
PROMPT
PROMPT ******************
PROMPT ** Creating Tables
PROMPT ******************
--	
--
  CREATE TABLE XXMX_CORE.XXMX_BANKS_VAL
 (
  VALIDATION_ERROR_MESSAGE  VARCHAR2(3000),
  FILE_SET_ID               VARCHAR2(30),   
  MIGRATION_SET_ID          NUMBER,        
  MIGRATION_SET_NAME        VARCHAR2(150), 
  MIGRATION_STATUS          VARCHAR2(50),   
  MIGRATION_ACTION          VARCHAR2(10),  
  BG_NAME                   VARCHAR2(240), 
  BG_ID                     NUMBER(15),    
  METADATA                  VARCHAR2(150), 
  OBJECTNAME                VARCHAR2(150), 
  INSTITUTION_LEVEL         VARCHAR2(20),  
  BANK_ID                   NUMBER,       
  BANK_NAME                 VARCHAR2(360),
  BANK_TYPE                 VARCHAR2(30),  
  SHORT_BANK_NAME           VARCHAR2(320), 
  ALTERNATE_BANK_NAME       VARCHAR2(40),  
  COUNTRY                   VARCHAR2(60),   
  COUNTRY_CODE              VARCHAR2(2),    
  BANK_NUMBER               VARCHAR2(30),   
  END_DATE                  DATE,           
  END_EFFECTIVE_DATE        DATE,           
  SOURCE_SYSTEM_OWNER       VARCHAR2(256),  
  SOURCE_SYSTEM_ID          VARCHAR2(2000)
 );  
  --
  --
  CREATE TABLE XXMX_CORE.XXMX_BANK_BRANCHES_VAL
 (
  VALIDATION_ERROR_MESSAGE         VARCHAR2(3000),
  FILE_SET_ID                      VARCHAR2(30),   
  MIGRATION_SET_ID                 NUMBER,  
  MIGRATION_SET_NAME               VARCHAR2(150),  
  MIGRATION_STATUS                 VARCHAR2(50),   
  MIGRATION_ACTION                 VARCHAR2(10),   
  BG_NAME                          VARCHAR2(240),  
  BG_ID                            NUMBER(15),     
  METADATA                         VARCHAR2(150),  
  OBJECTNAME                       VARCHAR2(150),  
  INSTITUTION_LEVEL                VARCHAR2(20),   
  BANK_NAME                        VARCHAR2(360),  
  BANK_NUMBER                      VARCHAR2(30),   
  BANK_TYPE                        VARCHAR2(30),   
  SHORT_BANK_NAME                  VARCHAR2(40),   
  COUNTRY                          VARCHAR2(60),   
  COUNTRY_CODE                     VARCHAR2(2),   
  BANK_BRANCH_ID                   NUMBER,         
  BANK_BRANCH_NUMBER               VARCHAR2(30),   
  BANK_BRANCH_NAME                 VARCHAR2(360),  
  BANK_BRANCH_TYPE                 VARCHAR2(30),   
  ALTERNATE_BANK_BRANCH_NAME       VARCHAR2(320),  
  BANK_ID                          NUMBER,         
  BRANCH_ID                        VARCHAR2(10),   
  EFT_SWIFT_CODE                   VARCHAR2(30),   
  EFT_USER_NUMBER                  VARCHAR2(30),   
  RFC                              VARCHAR2(30),   
  END_DATE                         DATE,           
  END_EFFECTIVE_DATE               DATE,          
  SOURCE_SYSTEM_OWNER              VARCHAR2(256),  
  SOURCE_SYSTEM_ID                 VARCHAR2(2000)
 );
  --