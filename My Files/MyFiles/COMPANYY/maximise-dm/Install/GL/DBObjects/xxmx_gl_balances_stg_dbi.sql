--ALTER SESSION SET CONTAINER = MXDM_PDB1;
--
--
--CONNECT xxmx_stg/&xxmx_stg_pwd
--
--
--*****************************************************************************
--**
--**                 Copyright (c) 2022 Version 1
--**
--**                           Millennium House,
--**                           Millennium Walkway,
--**                           Dublin 1
--**                           D01 F5P8
--**
--**                           All rights reserved.
--**
--*****************************************************************************
--**
--**
--** FILENAME  :  xmxx_gl_balances_stg_dbi.sql
--**
--** FILEPATH  :  $XXMX_TOP/install/sql
--**
--** VERSION   :  1.0
--**
--** EXECUTE
--** IN SCHEMA :  APPS
--**
--** AUTHORS   :  Ian S. Vickerstaff
--**
--** PURPOSE   :  This script installs the package specification for the Patech
--**              common Procedures and Functions package.
--**
--** NOTES     :
--**
--******************************************************************************
--**
--** PRE-REQUISITIES
--** ---------------
--**
--** If this script is to be executed as part of an installation script, ensure
--** that the installation script performs the following tasks prior to calling
--** this script.
--**
--** Task  Description
--** ----  ---------------------------------------------------------------------
--** 1.    Run the installation script to create all necessary database objects
--**       and Concurrent definitions:
--**
--**            $XXV1_TOP/install/sql/xxv1_mxdm_utilities_1_dbi.sql
--**
--** If this script is not to be executed as part of an installation script,
--** ensure that the tasks above are, or have been, performed prior to executing
--** this script.
--**
--******************************************************************************
--**
--** CALLING INSTALLATION SCRIPTS
--** ----------------------------
--**
--** The following installation scripts call this script:
--**
--** File Path                                     File Name
--** --------------------------------------------  ------------------------------
--** N/A                                           N/A
--**
--******************************************************************************
--**
--** CALLED INSTALLATION SCRIPTS
--** ---------------------------
--**
--** The following installation scripts are called by this script:
--**
--** File Path                                    File Name
--** -------------------------------------------  ------------------------------
--** N/A                                          N/A
--**
--******************************************************************************
--**
--** PARAMETERS
--** ----------
--**
--** Parameter                       IN OUT  Type
--** -----------------------------  ------  ------------------------------------
--** [parameter_name]                IN OUT
--**
--******************************************************************************
--**
--** [previous_filename] HISTORY
--** -----------------------------
--**
--**   Vsn  Change Date  Changed By          Change Description
--** -----  -----------  ------------------  -----------------------------------
--** [ 1.0  DD-Mon-YYYY  Change Author       Created.                          ]
--**
--******************************************************************************
--**
--** xxcust_common_pkg.sql HISTORY
--** ------------------------------------
--**
--**   Vsn  Change Date  Changed By          Change Description
--** -----  -----------  ------------------  -----------------------------------
--**   1.0  16-DEC-2020  Ian S. Vickerstaff  Created for Maximise.
--**
--**   1.1  05-JAN-2021  Ian S. Vickerstaff  Minor column changes.
--**
--**   1.2  22-JAN-2021  Ian S. Vickerstaff  Column Name changes ot more closely
--**                                         match FBDI template.
--**
--**   1.3  14-JUL-2021  Ian S. Vickerstaff  Header comment updates.
--**   1.4  30-JUN-2021  Pallavi             Added New Balance Tables 
--******************************************************************************
--
--
PROMPT
PROMPT
PROMPT *********************************************************************
PROMPT **
PROMPT ** Installing Extract Database Objects for Maximise GL Data Migration
PROMPT **
PROMPT *********************************************************************
PROMPT
PROMPT
--
--
PROMPT
PROMPT
PROMPT ******************
PROMPT ** Dropping Tables
PROMPT ******************
--
--
PROMPT
PROMPT Dropping Table xxmx_gl_balances_stg
PROMPT
--
EXEC DropTable ('XXMX_GL_BALANCES_STG')
--
--
--
--
PROMPT
PROMPT Dropping Table XXMX_GL_OPENING_BALANCES_STG
PROMPT
--
EXEC DropTable ('XXMX_GL_OPENING_BALANCES_STG')
--
--
--
PROMPT
PROMPT Dropping Table XXMX_GL_SUMMARY_BALANCES_STG
PROMPT
--
EXEC DropTable ('XXMX_GL_SUMMARY_BALANCES_STG')
--
--
--
PROMPT
PROMPT Dropping Table XXMX_GL_DETAIL_BALANCES_STG
PROMPT
--
EXEC DropTable ('XXMX_GL_DETAIL_BALANCES_STG')
--
--
PROMPT
PROMPT
PROMPT ******************
PROMPT ** Creating Tables
PROMPT ******************
--
--
PROMPT
PROMPT Creating Table xxmx_gl_balances_stg
PROMPT
--

--Migration_set_id is generated in the maximise Code
--File_set_id is mandatory for Data File (non-Ebs Source)

CREATE TABLE xxmx_stg.xxmx_gl_balances_stg
     (
	  file_set_id                     VARCHAR2(30),
     migration_set_id                NUMBER,
     migration_set_name              VARCHAR2(100),
     migration_status                VARCHAR2(50),
     fusion_status_code              VARCHAR2(50),
     LEDGER_ID                       NUMBER(18),
     accounting_date                 DATE,
     user_je_source_name             VARCHAR2(25),
     user_je_category_name           VARCHAR2(25),
     currency_code                   VARCHAR2(15),
     journal_entry_creation_date     DATE,
     actual_flag                     VARCHAR2(1),
     segment1                        VARCHAR2(25),
     segment2                        VARCHAR2(25),
     segment3                        VARCHAR2(25),
     segment4                        VARCHAR2(25),
     segment5                        VARCHAR2(25),
     segment6                        VARCHAR2(25),
     segment7                        VARCHAR2(25),
     segment8                        VARCHAR2(25),
     segment9                        VARCHAR2(25),
     segment10                       VARCHAR2(25),
     segment11                       VARCHAR2(25),
     segment12                       VARCHAR2(25),
     segment13                       VARCHAR2(25),
     segment14                       VARCHAR2(25),
     segment15                       VARCHAR2(25),
     segment16                       VARCHAR2(25),
     segment17                       VARCHAR2(25),
     segment18                       VARCHAR2(25),
     segment19                       VARCHAR2(25),
     segment20                       VARCHAR2(25),
     segment21                       VARCHAR2(25),
     segment22                       VARCHAR2(25),
     segment23                       VARCHAR2(25),
     segment24                       VARCHAR2(25),
     segment25                       VARCHAR2(25),
     segment26                       VARCHAR2(25),
     segment27                       VARCHAR2(25),
     segment28                       VARCHAR2(25),
     segment29                       VARCHAR2(25),
     segment30                       VARCHAR2(25),
     entered_dr                      NUMBER,
     entered_cr                      NUMBER,
     accounted_dr                    NUMBER,
     accounted_cr                    NUMBER,
     reference1                      VARCHAR2(100),
     reference2                      VARCHAR2(240),
     reference3                      VARCHAR2(100),
     reference4                      VARCHAR2(100),
     reference5                      VARCHAR2(240),
     reference6                      VARCHAR2(100),
     reference7                      VARCHAR2(100),
     reference8                      VARCHAR2(100),
     reference9                      VARCHAR2(100),
     reference10                     VARCHAR2(240),
     reference21                     VARCHAR2(240),
     reference22                     VARCHAR2(240),
     reference23                     VARCHAR2(240),
     reference24                     VARCHAR2(240),
     reference25                     VARCHAR2(240),
     reference26                     VARCHAR2(240),
     reference27                     VARCHAR2(240),
     reference28                     VARCHAR2(240),
     reference29                     VARCHAR2(240),
     reference30                     VARCHAR2(240),
     stat_amount                     NUMBER,
     user_currency_conversion_type   VARCHAR2(30),
     currency_conversion_date        DATE,
     currency_conversion_rate        NUMBER,
     group_id                        NUMBER,
     attribute_category              VARCHAR2(150),
     attribute1                      VARCHAR2(150),
     attribute2                      VARCHAR2(150),
     attribute3                      VARCHAR2(150),
     attribute4                      VARCHAR2(150),
     attribute5                      VARCHAR2(150),
     attribute6                      VARCHAR2(150),
     attribute7                      VARCHAR2(150),
     attribute8                      VARCHAR2(150),
     attribute9                      VARCHAR2(150),
     attribute10                     VARCHAR2(150),
     attribute11                     VARCHAR2(150),
     attribute12                     VARCHAR2(150),
     attribute13                     VARCHAR2(150),
     attribute14                     VARCHAR2(150),
     attribute15                     VARCHAR2(150),
     attribute16                     VARCHAR2(150),
     attribute17                     VARCHAR2(150),
     attribute18                     VARCHAR2(150),
     attribute19                     VARCHAR2(150),
     attribute20                     VARCHAR2(150),
     attribute_category3             VARCHAR2(150),  
     average_journal_flag            VARCHAR2(1),
     originating_bal_seg_value       VARCHAR2(25),
     ledger_name                     VARCHAR2(30),
     encumbrance_type_id             NUMBER,
     jgzz_recon_ref                  VARCHAR2(240),
     period_name                     VARCHAR2(15),
      ATTRIBUTE_DATE1                     DATE,          
      ATTRIBUTE_DATE2                     DATE,          
      ATTRIBUTE_DATE3                     DATE,          
      ATTRIBUTE_DATE4                     DATE,          
      ATTRIBUTE_DATE5                     DATE,          
      ATTRIBUTE_DATE6                     DATE,          
      ATTRIBUTE_DATE7                     DATE,          
      ATTRIBUTE_DATE8                     DATE,          
      ATTRIBUTE_DATE9                     DATE,          
      ATTRIBUTE_DATE10                    DATE,          
      ATTRIBUTE_NUMBER1                   NUMBER,        
      ATTRIBUTE_NUMBER2                   NUMBER,        
      ATTRIBUTE_NUMBER3                   NUMBER,        
      ATTRIBUTE_NUMBER4                   NUMBER,        
      ATTRIBUTE_NUMBER5                   NUMBER,        
      ATTRIBUTE_NUMBER6                   NUMBER,        
      ATTRIBUTE_NUMBER7                   NUMBER,        
      ATTRIBUTE_NUMBER8                   NUMBER,        
      ATTRIBUTE_NUMBER9                   NUMBER,        
      ATTRIBUTE_NUMBER10                  NUMBER,        
      GLOBAL_ATTRIBUTE_CATEGORY           VARCHAR2(30),  
      GLOBAL_ATTRIBUTE1                   VARCHAR2(150), 
      GLOBAL_ATTRIBUTE2                   VARCHAR2(150), 
      GLOBAL_ATTRIBUTE3                   VARCHAR2(150), 
      GLOBAL_ATTRIBUTE4                   VARCHAR2(150), 
      GLOBAL_ATTRIBUTE5                   VARCHAR2(150), 
      GLOBAL_ATTRIBUTE6                   VARCHAR2(150), 
      GLOBAL_ATTRIBUTE7                   VARCHAR2(150), 
      GLOBAL_ATTRIBUTE8                   VARCHAR2(150), 
      GLOBAL_ATTRIBUTE9                   VARCHAR2(150), 
      GLOBAL_ATTRIBUTE10                  VARCHAR2(150), 
      GLOBAL_ATTRIBUTE11                  VARCHAR2(150), 
      GLOBAL_ATTRIBUTE12                  VARCHAR2(150), 
      GLOBAL_ATTRIBUTE13                  VARCHAR2(150), 
      GLOBAL_ATTRIBUTE14                  VARCHAR2(150), 
      GLOBAL_ATTRIBUTE15                  VARCHAR2(150), 
      GLOBAL_ATTRIBUTE16                  VARCHAR2(150), 
      GLOBAL_ATTRIBUTE17                  VARCHAR2(150), 
      GLOBAL_ATTRIBUTE18                  VARCHAR2(150), 
      GLOBAL_ATTRIBUTE19                  VARCHAR2(150), 
      GLOBAL_ATTRIBUTE20                  VARCHAR2(150), 
      GLOBAL_ATTRIBUTE_DATE1              DATE,          
      GLOBAL_ATTRIBUTE_DATE2              DATE,          
      GLOBAL_ATTRIBUTE_DATE3              DATE,          
      GLOBAL_ATTRIBUTE_DATE4              DATE,          
      GLOBAL_ATTRIBUTE_DATE5              DATE,          
      GLOBAL_ATTRIBUTE_NUMBER1            NUMBER,        
      GLOBAL_ATTRIBUTE_NUMBER2            NUMBER,        
      GLOBAL_ATTRIBUTE_NUMBER3            NUMBER,        
      GLOBAL_ATTRIBUTE_NUMBER4            NUMBER,        
      GLOBAL_ATTRIBUTE_NUMBER5            NUMBER,
      LOAD_BATCH                          VARCHAR2(300)	  
      );
      


  CREATE TABLE "XXMX_STG"."XXMX_GL_OPENING_BALANCES_STG" 
   (	"FILE_SET_ID" VARCHAR2(30 BYTE), 
	"MIGRATION_SET_ID" NUMBER, 
	"MIGRATION_SET_NAME" VARCHAR2(100 BYTE), 
	"MIGRATION_STATUS" VARCHAR2(50 BYTE), 
	"FUSION_STATUS_CODE" VARCHAR2(50 BYTE), 
	"LEDGER_ID" NUMBER(18,0), 
	"ACCOUNTING_DATE" DATE, 
	"USER_JE_SOURCE_NAME" VARCHAR2(25 BYTE), 
	"USER_JE_CATEGORY_NAME" VARCHAR2(25 BYTE), 
	"CURRENCY_CODE" VARCHAR2(15 BYTE), 
	"DATE_CREATED" DATE, 
	"ACTUAL_FLAG" VARCHAR2(1 BYTE), 
	"SEGMENT1" VARCHAR2(25 BYTE), 
	"SEGMENT2" VARCHAR2(25 BYTE), 
	"SEGMENT3" VARCHAR2(25 BYTE), 
	"SEGMENT4" VARCHAR2(25 BYTE), 
	"SEGMENT5" VARCHAR2(25 BYTE), 
	"SEGMENT6" VARCHAR2(25 BYTE), 
	"SEGMENT7" VARCHAR2(25 BYTE), 
	"SEGMENT8" VARCHAR2(25 BYTE), 
	"SEGMENT9" VARCHAR2(25 BYTE), 
	"SEGMENT10" VARCHAR2(25 BYTE), 
	"SEGMENT11" VARCHAR2(25 BYTE), 
	"SEGMENT12" VARCHAR2(25 BYTE), 
	"SEGMENT13" VARCHAR2(25 BYTE), 
	"SEGMENT14" VARCHAR2(25 BYTE), 
	"SEGMENT15" VARCHAR2(25 BYTE), 
	"SEGMENT16" VARCHAR2(25 BYTE), 
	"SEGMENT17" VARCHAR2(25 BYTE), 
	"SEGMENT18" VARCHAR2(25 BYTE), 
	"SEGMENT19" VARCHAR2(25 BYTE), 
	"SEGMENT20" VARCHAR2(25 BYTE), 
	"SEGMENT21" VARCHAR2(25 BYTE), 
	"SEGMENT22" VARCHAR2(25 BYTE), 
	"SEGMENT23" VARCHAR2(25 BYTE), 
	"SEGMENT24" VARCHAR2(25 BYTE), 
	"SEGMENT25" VARCHAR2(25 BYTE), 
	"SEGMENT26" VARCHAR2(25 BYTE), 
	"SEGMENT27" VARCHAR2(25 BYTE), 
	"SEGMENT28" VARCHAR2(25 BYTE), 
	"SEGMENT29" VARCHAR2(25 BYTE), 
	"SEGMENT30" VARCHAR2(25 BYTE), 
	"ENTERED_DR" NUMBER, 
	"ENTERED_CR" NUMBER, 
	"ACCOUNTED_DR" NUMBER, 
	"ACCOUNTED_CR" NUMBER, 
	"REFERENCE1" VARCHAR2(100 BYTE), 
	"REFERENCE2" VARCHAR2(240 BYTE), 
	"REFERENCE3" VARCHAR2(100 BYTE), 
	"REFERENCE4" VARCHAR2(100 BYTE), 
	"REFERENCE5" VARCHAR2(240 BYTE), 
	"REFERENCE6" VARCHAR2(100 BYTE), 
	"REFERENCE7" VARCHAR2(100 BYTE), 
	"REFERENCE8" VARCHAR2(100 BYTE), 
	"REFERENCE9" VARCHAR2(100 BYTE), 
	"REFERENCE10" VARCHAR2(240 BYTE), 
	"REFERENCE21" VARCHAR2(960 BYTE),
	"REFERENCE22" VARCHAR2(960 BYTE),
	"REFERENCE23" VARCHAR2(960 BYTE),
	"REFERENCE24" VARCHAR2(960 BYTE),
	"REFERENCE25" VARCHAR2(960 BYTE),
	"REFERENCE26" VARCHAR2(960 BYTE),
	"REFERENCE27" VARCHAR2(960 BYTE),
	"REFERENCE28" VARCHAR2(960 BYTE),
	"REFERENCE29" VARCHAR2(960 BYTE),
	"REFERENCE30" VARCHAR2(960 BYTE),
	"STAT_AMOUNT" NUMBER, 
	"USER_CURRENCY_CONVERSION_TYPE" VARCHAR2(30 BYTE), 
	"CURRENCY_CONVERSION_DATE" DATE, 
	"CURRENCY_CONVERSION_RATE" NUMBER, 
	"GROUP_ID" NUMBER(18,0), 
	"ATTRIBUTE_CATEGORY" VARCHAR2(150 BYTE), 
	"ATTRIBUTE1" VARCHAR2(150 BYTE), 
	"ATTRIBUTE2" VARCHAR2(150 BYTE), 
	"ATTRIBUTE3" VARCHAR2(150 BYTE), 
	"ATTRIBUTE4" VARCHAR2(150 BYTE), 
	"ATTRIBUTE5" VARCHAR2(150 BYTE), 
	"ATTRIBUTE6" VARCHAR2(150 BYTE), 
	"ATTRIBUTE7" VARCHAR2(150 BYTE), 
	"ATTRIBUTE8" VARCHAR2(150 BYTE), 
	"ATTRIBUTE9" VARCHAR2(150 BYTE), 
	"ATTRIBUTE10" VARCHAR2(150 BYTE), 
	"ATTRIBUTE11" VARCHAR2(150 BYTE), 
	"ATTRIBUTE12" VARCHAR2(150 BYTE), 
	"ATTRIBUTE13" VARCHAR2(150 BYTE), 
	"ATTRIBUTE14" VARCHAR2(150 BYTE), 
	"ATTRIBUTE15" VARCHAR2(150 BYTE), 
	"ATTRIBUTE16" VARCHAR2(150 BYTE), 
	"ATTRIBUTE17" VARCHAR2(150 BYTE), 
	"ATTRIBUTE18" VARCHAR2(150 BYTE), 
	"ATTRIBUTE19" VARCHAR2(150 BYTE), 
	"ATTRIBUTE20" VARCHAR2(150 BYTE), 
	"ATTRIBUTE_CATEGORY3" VARCHAR2(150 BYTE), 
         AVERAGE_JOURNAL_FLAG                VARCHAR2(1),
	"ORIGINATING_BAL_SEG_VALUE" VARCHAR2(25 BYTE), 
	"LEDGER_NAME" VARCHAR2(30 BYTE), 
	"ENCUMBRANCE_TYPE_ID" NUMBER, 
	"JGZZ_RECON_REF" VARCHAR2(240 BYTE), 
	"PERIOD_NAME" VARCHAR2(15 BYTE), 
	REFERENCE18  VARCHAR(400),
	REFERENCE19  VARCHAR(400),
        REFERENCE20  VARCHAR(400),
	"ATTRIBUTE_DATE1" DATE, 
	"ATTRIBUTE_DATE2" DATE, 
	"ATTRIBUTE_DATE3" DATE, 
	"ATTRIBUTE_DATE4" DATE, 
	"ATTRIBUTE_DATE5" DATE, 
	"ATTRIBUTE_DATE6" DATE, 
	"ATTRIBUTE_DATE7" DATE, 
	"ATTRIBUTE_DATE8" DATE, 
	"ATTRIBUTE_DATE9" DATE, 
	"ATTRIBUTE_DATE10" DATE, 
	"ATTRIBUTE_NUMBER1" NUMBER, 
	"ATTRIBUTE_NUMBER2" NUMBER, 
	"ATTRIBUTE_NUMBER3" NUMBER, 
	"ATTRIBUTE_NUMBER4" NUMBER, 
	"ATTRIBUTE_NUMBER5" NUMBER, 
	"ATTRIBUTE_NUMBER6" NUMBER, 
	"ATTRIBUTE_NUMBER7" NUMBER, 
	"ATTRIBUTE_NUMBER8" NUMBER, 
	"ATTRIBUTE_NUMBER9" NUMBER, 
	"ATTRIBUTE_NUMBER10" NUMBER, 
	"GLOBAL_ATTRIBUTE_CATEGORY" VARCHAR2(30 BYTE), 
	"GLOBAL_ATTRIBUTE1" VARCHAR2(150 BYTE), 
	"GLOBAL_ATTRIBUTE2" VARCHAR2(150 BYTE), 
	"GLOBAL_ATTRIBUTE3" VARCHAR2(150 BYTE), 
	"GLOBAL_ATTRIBUTE4" VARCHAR2(150 BYTE), 
	"GLOBAL_ATTRIBUTE5" VARCHAR2(150 BYTE), 
	"GLOBAL_ATTRIBUTE6" VARCHAR2(150 BYTE), 
	"GLOBAL_ATTRIBUTE7" VARCHAR2(150 BYTE), 
	"GLOBAL_ATTRIBUTE8" VARCHAR2(150 BYTE), 
	"GLOBAL_ATTRIBUTE9" VARCHAR2(150 BYTE), 
	"GLOBAL_ATTRIBUTE10" VARCHAR2(150 BYTE), 
	"GLOBAL_ATTRIBUTE11" VARCHAR2(150 BYTE), 
	"GLOBAL_ATTRIBUTE12" VARCHAR2(150 BYTE), 
	"GLOBAL_ATTRIBUTE13" VARCHAR2(150 BYTE), 
	"GLOBAL_ATTRIBUTE14" VARCHAR2(150 BYTE), 
	"GLOBAL_ATTRIBUTE15" VARCHAR2(150 BYTE), 
	"GLOBAL_ATTRIBUTE16" VARCHAR2(150 BYTE), 
	"GLOBAL_ATTRIBUTE17" VARCHAR2(150 BYTE), 
	"GLOBAL_ATTRIBUTE18" VARCHAR2(150 BYTE), 
	"GLOBAL_ATTRIBUTE19" VARCHAR2(150 BYTE), 
	"GLOBAL_ATTRIBUTE20" VARCHAR2(150 BYTE), 
	"GLOBAL_ATTRIBUTE_DATE1" DATE, 
	"GLOBAL_ATTRIBUTE_DATE2" DATE, 
	"GLOBAL_ATTRIBUTE_DATE3" DATE, 
	"GLOBAL_ATTRIBUTE_DATE4" DATE, 
	"GLOBAL_ATTRIBUTE_DATE5" DATE, 
	"GLOBAL_ATTRIBUTE_NUMBER1" NUMBER, 
	"GLOBAL_ATTRIBUTE_NUMBER2" NUMBER, 
	"GLOBAL_ATTRIBUTE_NUMBER3" NUMBER, 
	"GLOBAL_ATTRIBUTE_NUMBER4" NUMBER, 
	"GLOBAL_ATTRIBUTE_NUMBER5" NUMBER,
	LOAD_BATCH                 VARCHAR2(300)	  
   )  ;



  CREATE TABLE "XXMX_STG"."XXMX_GL_DETAIL_BALANCES_STG" 
   (	"FILE_SET_ID" VARCHAR2(30 BYTE), 
	"MIGRATION_SET_ID" NUMBER, 
	"MIGRATION_SET_NAME" VARCHAR2(100 BYTE), 
	"MIGRATION_STATUS" VARCHAR2(50 BYTE), 
	"FUSION_STATUS_CODE" VARCHAR2(50 BYTE), 
	"LEDGER_ID" NUMBER(18,0), 
	"ACCOUNTING_DATE" DATE, 
	"USER_JE_SOURCE_NAME" VARCHAR2(25 BYTE), 
	"USER_JE_CATEGORY_NAME" VARCHAR2(25 BYTE), 
	"CURRENCY_CODE" VARCHAR2(15 BYTE), 
	"DATE_CREATED" DATE, 
	"ACTUAL_FLAG" VARCHAR2(1 BYTE), 
	"SEGMENT1" VARCHAR2(25 BYTE), 
	"SEGMENT2" VARCHAR2(25 BYTE), 
	"SEGMENT3" VARCHAR2(25 BYTE), 
	"SEGMENT4" VARCHAR2(25 BYTE), 
	"SEGMENT5" VARCHAR2(25 BYTE), 
	"SEGMENT6" VARCHAR2(25 BYTE), 
	"SEGMENT7" VARCHAR2(25 BYTE), 
	"SEGMENT8" VARCHAR2(25 BYTE), 
	"SEGMENT9" VARCHAR2(25 BYTE), 
	"SEGMENT10" VARCHAR2(25 BYTE), 
	"SEGMENT11" VARCHAR2(25 BYTE), 
	"SEGMENT12" VARCHAR2(25 BYTE), 
	"SEGMENT13" VARCHAR2(25 BYTE), 
	"SEGMENT14" VARCHAR2(25 BYTE), 
	"SEGMENT15" VARCHAR2(25 BYTE), 
	"SEGMENT16" VARCHAR2(25 BYTE), 
	"SEGMENT17" VARCHAR2(25 BYTE), 
	"SEGMENT18" VARCHAR2(25 BYTE), 
	"SEGMENT19" VARCHAR2(25 BYTE), 
	"SEGMENT20" VARCHAR2(25 BYTE), 
	"SEGMENT21" VARCHAR2(25 BYTE), 
	"SEGMENT22" VARCHAR2(25 BYTE), 
	"SEGMENT23" VARCHAR2(25 BYTE), 
	"SEGMENT24" VARCHAR2(25 BYTE), 
	"SEGMENT25" VARCHAR2(25 BYTE), 
	"SEGMENT26" VARCHAR2(25 BYTE), 
	"SEGMENT27" VARCHAR2(25 BYTE), 
	"SEGMENT28" VARCHAR2(25 BYTE), 
	"SEGMENT29" VARCHAR2(25 BYTE), 
	"SEGMENT30" VARCHAR2(25 BYTE), 
	"ENTERED_DR" NUMBER, 
	"ENTERED_CR" NUMBER, 
	"ACCOUNTED_DR" NUMBER, 
	"ACCOUNTED_CR" NUMBER, 
	"REFERENCE1" VARCHAR2(100 BYTE), 
	"REFERENCE2" VARCHAR2(240 BYTE), 
	"REFERENCE3" VARCHAR2(100 BYTE), 
	"REFERENCE4" VARCHAR2(100 BYTE), 
	"REFERENCE5" VARCHAR2(240 BYTE), 
	"REFERENCE6" VARCHAR2(100 BYTE), 
	"REFERENCE7" VARCHAR2(100 BYTE), 
	"REFERENCE8" VARCHAR2(100 BYTE), 
	"REFERENCE9" VARCHAR2(100 BYTE), 
	"REFERENCE10" VARCHAR2(240 BYTE), 
	"REFERENCE21" VARCHAR2(960 BYTE),
	"REFERENCE22" VARCHAR2(960 BYTE),
	"REFERENCE23" VARCHAR2(960 BYTE),
	"REFERENCE24" VARCHAR2(960 BYTE),
	"REFERENCE25" VARCHAR2(960 BYTE),
	"REFERENCE26" VARCHAR2(960 BYTE),
	"REFERENCE27" VARCHAR2(960 BYTE),
	"REFERENCE28" VARCHAR2(960 BYTE),
	"REFERENCE29" VARCHAR2(960 BYTE),
	"REFERENCE30" VARCHAR2(960 BYTE),
	"STAT_AMOUNT" NUMBER, 
	"USER_CURRENCY_CONVERSION_TYPE" VARCHAR2(30 BYTE), 
	"CURRENCY_CONVERSION_DATE" DATE, 
	"CURRENCY_CONVERSION_RATE" NUMBER, 
	"GROUP_ID" NUMBER(18,0), 
	"ATTRIBUTE_CATEGORY" VARCHAR2(150 BYTE), 
	"ATTRIBUTE1" VARCHAR2(150 BYTE), 
	"ATTRIBUTE2" VARCHAR2(150 BYTE), 
	"ATTRIBUTE3" VARCHAR2(150 BYTE), 
	"ATTRIBUTE4" VARCHAR2(150 BYTE), 
	"ATTRIBUTE5" VARCHAR2(150 BYTE), 
	"ATTRIBUTE6" VARCHAR2(150 BYTE), 
	"ATTRIBUTE7" VARCHAR2(150 BYTE), 
	"ATTRIBUTE8" VARCHAR2(150 BYTE), 
	"ATTRIBUTE9" VARCHAR2(150 BYTE), 
	"ATTRIBUTE10" VARCHAR2(150 BYTE), 
	"ATTRIBUTE11" VARCHAR2(150 BYTE), 
	"ATTRIBUTE12" VARCHAR2(150 BYTE), 
	"ATTRIBUTE13" VARCHAR2(150 BYTE), 
	"ATTRIBUTE14" VARCHAR2(150 BYTE), 
	"ATTRIBUTE15" VARCHAR2(150 BYTE), 
	"ATTRIBUTE16" VARCHAR2(150 BYTE), 
	"ATTRIBUTE17" VARCHAR2(150 BYTE), 
	"ATTRIBUTE18" VARCHAR2(150 BYTE), 
	"ATTRIBUTE19" VARCHAR2(150 BYTE), 
	"ATTRIBUTE20" VARCHAR2(150 BYTE), 
	"ATTRIBUTE_CATEGORY3" VARCHAR2(150 BYTE), 
  	 AVERAGE_JOURNAL_FLAG                VARCHAR2(1),
	"ORIGINATING_BAL_SEG_VALUE" VARCHAR2(25 BYTE), 
	"LEDGER_NAME" VARCHAR2(30 BYTE), 
	"ENCUMBRANCE_TYPE_ID" NUMBER, 
	"JGZZ_RECON_REF" VARCHAR2(240 BYTE), 
	"PERIOD_NAME" VARCHAR2(15 BYTE), 
	REFERENCE18  VARCHAR(400),
	REFERENCE19  VARCHAR(400),
        REFERENCE20  VARCHAR(400),
	"ATTRIBUTE_DATE1" DATE, 
	"ATTRIBUTE_DATE2" DATE, 
	"ATTRIBUTE_DATE3" DATE, 
	"ATTRIBUTE_DATE4" DATE, 
	"ATTRIBUTE_DATE5" DATE, 
	"ATTRIBUTE_DATE6" DATE, 
	"ATTRIBUTE_DATE7" DATE, 
	"ATTRIBUTE_DATE8" DATE, 
	"ATTRIBUTE_DATE9" DATE, 
	"ATTRIBUTE_DATE10" DATE, 
	"ATTRIBUTE_NUMBER1" NUMBER, 
	"ATTRIBUTE_NUMBER2" NUMBER, 
	"ATTRIBUTE_NUMBER3" NUMBER, 
	"ATTRIBUTE_NUMBER4" NUMBER, 
	"ATTRIBUTE_NUMBER5" NUMBER, 
	"ATTRIBUTE_NUMBER6" NUMBER, 
	"ATTRIBUTE_NUMBER7" NUMBER, 
	"ATTRIBUTE_NUMBER8" NUMBER, 
	"ATTRIBUTE_NUMBER9" NUMBER, 
	"ATTRIBUTE_NUMBER10" NUMBER, 
	"GLOBAL_ATTRIBUTE_CATEGORY" VARCHAR2(30 BYTE), 
	"GLOBAL_ATTRIBUTE1" VARCHAR2(150 BYTE), 
	"GLOBAL_ATTRIBUTE2" VARCHAR2(150 BYTE), 
	"GLOBAL_ATTRIBUTE3" VARCHAR2(150 BYTE), 
	"GLOBAL_ATTRIBUTE4" VARCHAR2(150 BYTE), 
	"GLOBAL_ATTRIBUTE5" VARCHAR2(150 BYTE), 
	"GLOBAL_ATTRIBUTE6" VARCHAR2(150 BYTE), 
	"GLOBAL_ATTRIBUTE7" VARCHAR2(150 BYTE), 
	"GLOBAL_ATTRIBUTE8" VARCHAR2(150 BYTE), 
	"GLOBAL_ATTRIBUTE9" VARCHAR2(150 BYTE), 
	"GLOBAL_ATTRIBUTE10" VARCHAR2(150 BYTE), 
	"GLOBAL_ATTRIBUTE11" VARCHAR2(150 BYTE), 
	"GLOBAL_ATTRIBUTE12" VARCHAR2(150 BYTE), 
	"GLOBAL_ATTRIBUTE13" VARCHAR2(150 BYTE), 
	"GLOBAL_ATTRIBUTE14" VARCHAR2(150 BYTE), 
	"GLOBAL_ATTRIBUTE15" VARCHAR2(150 BYTE), 
	"GLOBAL_ATTRIBUTE16" VARCHAR2(150 BYTE), 
	"GLOBAL_ATTRIBUTE17" VARCHAR2(150 BYTE), 
	"GLOBAL_ATTRIBUTE18" VARCHAR2(150 BYTE), 
	"GLOBAL_ATTRIBUTE19" VARCHAR2(150 BYTE), 
	"GLOBAL_ATTRIBUTE20" VARCHAR2(150 BYTE), 
	"GLOBAL_ATTRIBUTE_DATE1" DATE, 
	"GLOBAL_ATTRIBUTE_DATE2" DATE, 
	"GLOBAL_ATTRIBUTE_DATE3" DATE, 
	"GLOBAL_ATTRIBUTE_DATE4" DATE, 
	"GLOBAL_ATTRIBUTE_DATE5" DATE, 
	"GLOBAL_ATTRIBUTE_NUMBER1" NUMBER, 
	"GLOBAL_ATTRIBUTE_NUMBER2" NUMBER, 
	"GLOBAL_ATTRIBUTE_NUMBER3" NUMBER, 
	"GLOBAL_ATTRIBUTE_NUMBER4" NUMBER, 
	"GLOBAL_ATTRIBUTE_NUMBER5" NUMBER,
	LOAD_BATCH                 VARCHAR2(300)	  
   ) ;



  CREATE TABLE "XXMX_STG"."XXMX_GL_SUMMARY_BALANCES_STG" 
   (	"FILE_SET_ID" VARCHAR2(30 BYTE), 
	"MIGRATION_SET_ID" NUMBER, 
	"MIGRATION_SET_NAME" VARCHAR2(100 BYTE), 
	"MIGRATION_STATUS" VARCHAR2(50 BYTE), 
	"FUSION_STATUS_CODE" VARCHAR2(50 BYTE), 
	"LEDGER_ID" NUMBER(18,0), 
	"ACCOUNTING_DATE" DATE, 
	"USER_JE_SOURCE_NAME" VARCHAR2(25 BYTE), 
	"USER_JE_CATEGORY_NAME" VARCHAR2(25 BYTE), 
	"CURRENCY_CODE" VARCHAR2(15 BYTE), 
	"DATE_CREATED" DATE, 
	"ACTUAL_FLAG" VARCHAR2(1 BYTE), 
	"SEGMENT1" VARCHAR2(25 BYTE), 
	"SEGMENT2" VARCHAR2(25 BYTE), 
	"SEGMENT3" VARCHAR2(25 BYTE), 
	"SEGMENT4" VARCHAR2(25 BYTE), 
	"SEGMENT5" VARCHAR2(25 BYTE), 
	"SEGMENT6" VARCHAR2(25 BYTE), 
	"SEGMENT7" VARCHAR2(25 BYTE), 
	"SEGMENT8" VARCHAR2(25 BYTE), 
	"SEGMENT9" VARCHAR2(25 BYTE), 
	"SEGMENT10" VARCHAR2(25 BYTE), 
	"SEGMENT11" VARCHAR2(25 BYTE), 
	"SEGMENT12" VARCHAR2(25 BYTE), 
	"SEGMENT13" VARCHAR2(25 BYTE), 
	"SEGMENT14" VARCHAR2(25 BYTE), 
	"SEGMENT15" VARCHAR2(25 BYTE), 
	"SEGMENT16" VARCHAR2(25 BYTE), 
	"SEGMENT17" VARCHAR2(25 BYTE), 
	"SEGMENT18" VARCHAR2(25 BYTE), 
	"SEGMENT19" VARCHAR2(25 BYTE), 
	"SEGMENT20" VARCHAR2(25 BYTE), 
	"SEGMENT21" VARCHAR2(25 BYTE), 
	"SEGMENT22" VARCHAR2(25 BYTE), 
	"SEGMENT23" VARCHAR2(25 BYTE), 
	"SEGMENT24" VARCHAR2(25 BYTE), 
	"SEGMENT25" VARCHAR2(25 BYTE), 
	"SEGMENT26" VARCHAR2(25 BYTE), 
	"SEGMENT27" VARCHAR2(25 BYTE), 
	"SEGMENT28" VARCHAR2(25 BYTE), 
	"SEGMENT29" VARCHAR2(25 BYTE), 
	"SEGMENT30" VARCHAR2(25 BYTE), 
	"ENTERED_DR" NUMBER, 
	"ENTERED_CR" NUMBER, 
	"ACCOUNTED_DR" NUMBER, 
	"ACCOUNTED_CR" NUMBER, 
	"REFERENCE1" VARCHAR2(100 BYTE), 
	"REFERENCE2" VARCHAR2(240 BYTE), 
	"REFERENCE3" VARCHAR2(100 BYTE), 
	"REFERENCE4" VARCHAR2(100 BYTE), 
	"REFERENCE5" VARCHAR2(240 BYTE), 
	"REFERENCE6" VARCHAR2(100 BYTE), 
	"REFERENCE7" VARCHAR2(100 BYTE), 
	"REFERENCE8" VARCHAR2(100 BYTE), 
	"REFERENCE9" VARCHAR2(100 BYTE), 
	"REFERENCE10" VARCHAR2(240 BYTE), 
	"REFERENCE21" VARCHAR2(960 BYTE),
	"REFERENCE22" VARCHAR2(960 BYTE),
	"REFERENCE23" VARCHAR2(960 BYTE),
	"REFERENCE24" VARCHAR2(960 BYTE),
	"REFERENCE25" VARCHAR2(960 BYTE),
	"REFERENCE26" VARCHAR2(960 BYTE),
	"REFERENCE27" VARCHAR2(960 BYTE),
	"REFERENCE28" VARCHAR2(960 BYTE),
	"REFERENCE29" VARCHAR2(960 BYTE),
	"REFERENCE30" VARCHAR2(960 BYTE),
	"STAT_AMOUNT" NUMBER, 
	"USER_CURRENCY_CONVERSION_TYPE" VARCHAR2(30 BYTE), 
	"CURRENCY_CONVERSION_DATE" DATE, 
	"CURRENCY_CONVERSION_RATE" NUMBER, 
	"GROUP_ID" NUMBER(18,0), 
	"ATTRIBUTE_CATEGORY" VARCHAR2(150 BYTE), 
	"ATTRIBUTE1" VARCHAR2(150 BYTE), 
	"ATTRIBUTE2" VARCHAR2(150 BYTE), 
	"ATTRIBUTE3" VARCHAR2(150 BYTE), 
	"ATTRIBUTE4" VARCHAR2(150 BYTE), 
	"ATTRIBUTE5" VARCHAR2(150 BYTE), 
	"ATTRIBUTE6" VARCHAR2(150 BYTE), 
	"ATTRIBUTE7" VARCHAR2(150 BYTE), 
	"ATTRIBUTE8" VARCHAR2(150 BYTE), 
	"ATTRIBUTE9" VARCHAR2(150 BYTE), 
	"ATTRIBUTE10" VARCHAR2(150 BYTE), 
	"ATTRIBUTE11" VARCHAR2(150 BYTE), 
	"ATTRIBUTE12" VARCHAR2(150 BYTE), 
	"ATTRIBUTE13" VARCHAR2(150 BYTE), 
	"ATTRIBUTE14" VARCHAR2(150 BYTE), 
	"ATTRIBUTE15" VARCHAR2(150 BYTE), 
	"ATTRIBUTE16" VARCHAR2(150 BYTE), 
	"ATTRIBUTE17" VARCHAR2(150 BYTE), 
	"ATTRIBUTE18" VARCHAR2(150 BYTE), 
	"ATTRIBUTE19" VARCHAR2(150 BYTE), 
	"ATTRIBUTE20" VARCHAR2(150 BYTE), 
	"ATTRIBUTE_CATEGORY3" VARCHAR2(150 BYTE), 
	 AVERAGE_JOURNAL_FLAG    VARCHAR2(1),
	"ORIGINATING_BAL_SEG_VALUE" VARCHAR2(25 BYTE), 
	"LEDGER_NAME" VARCHAR2(30 BYTE), 
	"ENCUMBRANCE_TYPE_ID" NUMBER, 
	"JGZZ_RECON_REF" VARCHAR2(240 BYTE), 
	"PERIOD_NAME" VARCHAR2(15 BYTE), 
	REFERENCE18  VARCHAR(400),
	REFERENCE19  VARCHAR(400),
        REFERENCE20  VARCHAR(400),
	"ATTRIBUTE_DATE1" DATE, 
	"ATTRIBUTE_DATE2" DATE, 
	"ATTRIBUTE_DATE3" DATE, 
	"ATTRIBUTE_DATE4" DATE, 
	"ATTRIBUTE_DATE5" DATE, 
	"ATTRIBUTE_DATE6" DATE, 
	"ATTRIBUTE_DATE7" DATE, 
	"ATTRIBUTE_DATE8" DATE, 
	"ATTRIBUTE_DATE9" DATE, 
	"ATTRIBUTE_DATE10" DATE, 
	"ATTRIBUTE_NUMBER1" NUMBER, 
	"ATTRIBUTE_NUMBER2" NUMBER, 
	"ATTRIBUTE_NUMBER3" NUMBER, 
	"ATTRIBUTE_NUMBER4" NUMBER, 
	"ATTRIBUTE_NUMBER5" NUMBER, 
	"ATTRIBUTE_NUMBER6" NUMBER, 
	"ATTRIBUTE_NUMBER7" NUMBER, 
	"ATTRIBUTE_NUMBER8" NUMBER, 
	"ATTRIBUTE_NUMBER9" NUMBER, 
	"ATTRIBUTE_NUMBER10" NUMBER, 
	"GLOBAL_ATTRIBUTE_CATEGORY" VARCHAR2(30 BYTE), 
	"GLOBAL_ATTRIBUTE1" VARCHAR2(150 BYTE), 
	"GLOBAL_ATTRIBUTE2" VARCHAR2(150 BYTE), 
	"GLOBAL_ATTRIBUTE3" VARCHAR2(150 BYTE), 
	"GLOBAL_ATTRIBUTE4" VARCHAR2(150 BYTE), 
	"GLOBAL_ATTRIBUTE5" VARCHAR2(150 BYTE), 
	"GLOBAL_ATTRIBUTE6" VARCHAR2(150 BYTE), 
	"GLOBAL_ATTRIBUTE7" VARCHAR2(150 BYTE), 
	"GLOBAL_ATTRIBUTE8" VARCHAR2(150 BYTE), 
	"GLOBAL_ATTRIBUTE9" VARCHAR2(150 BYTE), 
	"GLOBAL_ATTRIBUTE10" VARCHAR2(150 BYTE), 
	"GLOBAL_ATTRIBUTE11" VARCHAR2(150 BYTE), 
	"GLOBAL_ATTRIBUTE12" VARCHAR2(150 BYTE), 
	"GLOBAL_ATTRIBUTE13" VARCHAR2(150 BYTE), 
	"GLOBAL_ATTRIBUTE14" VARCHAR2(150 BYTE), 
	"GLOBAL_ATTRIBUTE15" VARCHAR2(150 BYTE), 
	"GLOBAL_ATTRIBUTE16" VARCHAR2(150 BYTE), 
	"GLOBAL_ATTRIBUTE17" VARCHAR2(150 BYTE), 
	"GLOBAL_ATTRIBUTE18" VARCHAR2(150 BYTE), 
	"GLOBAL_ATTRIBUTE19" VARCHAR2(150 BYTE), 
	"GLOBAL_ATTRIBUTE20" VARCHAR2(150 BYTE), 
	"GLOBAL_ATTRIBUTE_DATE1" DATE, 
	"GLOBAL_ATTRIBUTE_DATE2" DATE, 
	"GLOBAL_ATTRIBUTE_DATE3" DATE, 
	"GLOBAL_ATTRIBUTE_DATE4" DATE, 
	"GLOBAL_ATTRIBUTE_DATE5" DATE, 
	"GLOBAL_ATTRIBUTE_NUMBER1" NUMBER, 
	"GLOBAL_ATTRIBUTE_NUMBER2" NUMBER, 
	"GLOBAL_ATTRIBUTE_NUMBER3" NUMBER, 
	"GLOBAL_ATTRIBUTE_NUMBER4" NUMBER, 
	"GLOBAL_ATTRIBUTE_NUMBER5" NUMBER,
	 LOAD_BATCH                VARCHAR2(300)	  
   ) ;
      
--
--
PROMPT
PROMPT
PROMPT ***********************
PROMPT ** Granting permissions
PROMPT ***********************
--
--
PROMPT
PROMPT Granting permissions on xxmx_gl_balances_stg to the XXMX_CORE Schema 
PROMPT
--
GRANT ALL ON xxmx_stg.XXMX_GL_SUMMARY_BALANCES_STG     TO XXMX_CORE;
GRANT ALL ON xxmx_stg.XXMX_GL_DETAIL_BALANCES_STG     TO XXMX_CORE;
GRANT ALL ON xxmx_stg.XXMX_GL_OPENING_BALANCES_STG     TO XXMX_CORE;
GRANT ALL ON xxmx_stg.xxmx_gl_balances_stg     TO XXMX_CORE;

--
--
--
PROMPT
PROMPT
PROMPT **********************************
PROMPT **                                
PROMPT ** End of Database Object Creation
PROMPT **                                
PROMPT **********************************
PROMPT
PROMPT
--
