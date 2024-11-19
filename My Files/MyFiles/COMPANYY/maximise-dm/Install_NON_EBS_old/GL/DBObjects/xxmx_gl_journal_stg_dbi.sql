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
--** FILENAME  :  xmxx_gl_journal_stg_dbi.sql
--**
--** FILEPATH  :  $XXMX_TOP/install/sql
--**
--** VERSION   :  1.0
--**
--** EXECUTE
--** IN SCHEMA :  XXMX_STG
--**
--** AUTHORS   :  Shaik Latheef
--**
--** PURPOSE   :  This script installs the XXMX_STG DB Objects for the Maximise
--**              GL Journal Data Migration.
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
--** -----  -----------  ------------------  -------------------------------------------
--**   1.0  24-NOV-2021  Shaik Latheef  	 Created GL Journal STG tables for Maximise.
--**
--**************************************************************************************
--
--
PROMPT
PROMPT
PROMPT *****************************************************************************
PROMPT **
PROMPT ** Installing Extract Database Objects for Maximise GL Journal Data Migration
PROMPT **
PROMPT *****************************************************************************
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
PROMPT Dropping Table xxmx_gl_journal_stg
PROMPT
--
EXEC DropTable ('XXMX_GL_JOURNAL_STG')
--
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
PROMPT Creating Table xxmx_gl_journal_stg
PROMPT
--

--Migration_set_id is generated in the maximise Code
--File_set_id is mandatory for Data File (non-Ebs Source)

--
--
-- ******************
-- **GL JOURNAL Table
-- ******************
CREATE TABLE xxmx_gl_journal_stg
     (
	  file_set_id                       VARCHAR2(30)
     ,migration_set_id               	NUMBER
     ,migration_set_name             	VARCHAR2(100)
     ,migration_status               	VARCHAR2(50)
	 ,batch_id							NUMBER
     ,status               				VARCHAR2(50)
     ,ledger_id                    	 	NUMBER(18)
     ,accounting_date                 	DATE
     ,user_je_source_name              	VARCHAR2(25)
     ,user_je_category_name           	VARCHAR2(25)
     ,currency_code                   	VARCHAR2(15)
     ,date_created     					DATE
     ,actual_flag                     	VARCHAR2(1)
     ,segment1                        	VARCHAR2(25)
     ,segment2                        	VARCHAR2(25)
     ,segment3                        	VARCHAR2(25)
     ,segment4                        	VARCHAR2(25)
     ,segment5                        	VARCHAR2(25)
     ,segment6                        	VARCHAR2(25)
     ,segment7                        	VARCHAR2(25)
     ,segment8                        	VARCHAR2(25)
     ,segment9                        	VARCHAR2(25)
     ,segment10                       	VARCHAR2(25)
     ,segment11                       	VARCHAR2(25)
     ,segment12                       	VARCHAR2(25)
     ,segment13                       	VARCHAR2(25)
     ,segment14                       	VARCHAR2(25)
     ,segment15                       	VARCHAR2(25)
     ,segment16                       	VARCHAR2(25)
     ,segment17                       	VARCHAR2(25)
     ,segment18                       	VARCHAR2(25)
     ,segment19                       	VARCHAR2(25)
     ,segment20                       	VARCHAR2(25)
     ,segment21                       	VARCHAR2(25)
     ,segment22                       	VARCHAR2(25)
     ,segment23                       	VARCHAR2(25)
     ,segment24                       	VARCHAR2(25)
     ,segment25                       	VARCHAR2(25)
     ,segment26                       	VARCHAR2(25)
     ,segment27                       	VARCHAR2(25)
     ,segment28                       	VARCHAR2(25)
     ,segment29                       	VARCHAR2(25)
     ,segment30                       	VARCHAR2(25)
     ,entered_dr                      	NUMBER
     ,entered_cr                      	NUMBER
     ,accounted_dr                    	NUMBER
     ,accounted_cr                    	NUMBER
     ,reference1                      	VARCHAR2(100)
     ,reference2                      	VARCHAR2(240)
     ,reference3                      	VARCHAR2(100)
     ,reference4                      	VARCHAR2(100)
     ,reference5                      	VARCHAR2(240)
     ,reference6                      	VARCHAR2(100)
     ,reference7                      	VARCHAR2(100)
     ,reference8                      	VARCHAR2(100)
     ,reference9                      	VARCHAR2(100)
     ,reference10                     	VARCHAR2(240)
     ,stat_amount                     	NUMBER
     ,user_currency_conversion_type   	VARCHAR2(30)
     ,currency_conversion_date        	DATE
     ,currency_conversion_rate        	NUMBER
     ,group_id                        	NUMBER(18)
     ,attribute_category              	VARCHAR2(150)
     ,attribute1                      	VARCHAR2(150)
     ,attribute2                      	VARCHAR2(150)
     ,attribute3                      	VARCHAR2(150)
     ,attribute4                      	VARCHAR2(150)
     ,attribute5                      	VARCHAR2(150)
     ,attribute6                      	VARCHAR2(150)
     ,attribute7                      	VARCHAR2(150)
     ,attribute8                      	VARCHAR2(150)
     ,attribute9                      	VARCHAR2(150)
     ,attribute10                     	VARCHAR2(150)
     ,attribute11                     	VARCHAR2(150)
     ,attribute12                     	VARCHAR2(150)
     ,attribute13                     	VARCHAR2(150)
     ,attribute14                     	VARCHAR2(150)
     ,attribute15                     	VARCHAR2(150)
     ,attribute16                     	VARCHAR2(150)
     ,attribute17                     	VARCHAR2(150)
     ,attribute18                     	VARCHAR2(150)
     ,attribute19                     	VARCHAR2(150)
     ,attribute20                     	VARCHAR2(150)
     ,attribute_category3             	VARCHAR2(150)
     ,originating_bal_seg_value       	VARCHAR2(25)
	 ,ledger_name						VARCHAR2(30)
     ,encumbrance_type_id             	NUMBER
     ,jgzz_recon_ref                  	VARCHAR2(240)
     ,period_name                     	VARCHAR2(15)
	 ,attribute_date1					DATE
	 ,attribute_date2					DATE
	 ,attribute_date3					DATE
	 ,attribute_date4					DATE
	 ,attribute_date5					DATE
	 ,attribute_date6					DATE
	 ,attribute_date7					DATE
	 ,attribute_date8					DATE
	 ,attribute_date9					DATE
	 ,attribute_date10					DATE
	 ,attribute_number1					NUMBER
	 ,attribute_number2					NUMBER
	 ,attribute_number3					NUMBER
	 ,attribute_number4					NUMBER
	 ,attribute_number5					NUMBER
	 ,attribute_number6					NUMBER
	 ,attribute_number7					NUMBER
	 ,attribute_number8					NUMBER
	 ,attribute_number9					NUMBER
	 ,attribute_number10				NUMBER
	 ,global_attribute_category         VARCHAR2(30)
	 ,global_attribute1					VARCHAR2(150)
	 ,global_attribute2					VARCHAR2(150)
	 ,global_attribute3					VARCHAR2(150)
	 ,global_attribute4					VARCHAR2(150)
	 ,global_attribute5					VARCHAR2(150)
	 ,global_attribute6					VARCHAR2(150)
	 ,global_attribute7					VARCHAR2(150)
	 ,global_attribute8					VARCHAR2(150)
	 ,global_attribute9					VARCHAR2(150)
	 ,global_attribute10				VARCHAR2(150)
	 ,global_attribute11				VARCHAR2(150)
	 ,global_attribute12				VARCHAR2(150)
	 ,global_attribute13				VARCHAR2(150)
	 ,global_attribute14				VARCHAR2(150)
	 ,global_attribute15				VARCHAR2(150)
	 ,global_attribute16				VARCHAR2(150)
	 ,global_attribute17				VARCHAR2(150)
	 ,global_attribute18				VARCHAR2(150)
	 ,global_attribute19				VARCHAR2(150)
	 ,global_attribute20				VARCHAR2(150)
	 ,global_attribute_date1			DATE
	 ,global_attribute_date2			DATE
	 ,global_attribute_date3			DATE
	 ,global_attribute_date4			DATE
	 ,global_attribute_date5			DATE
	 ,global_attribute_number1			NUMBER
	 ,global_attribute_number2			NUMBER
	 ,global_attribute_number3			NUMBER
	 ,global_attribute_number4			NUMBER
	 ,global_attribute_number5			NUMBER
     );

--
--
PROMPT
PROMPT
PROMPT ********************
PROMPT ** Creating Synonyms
PROMPT ********************
--
--
CREATE OR replace public synonym xxmx_gl_journal_stg FOR xxmx_gl_journal_stg;
--
	 
--
--
PROMPT
PROMPT
PROMPT ***********************
PROMPT ** Granting Permissions
PROMPT ***********************
--
--
PROMPT
PROMPT Granting permissions on xxmx_gl_journal_stg to the XXMX_CORE Schema 
PROMPT
--
GRANT ALL ON  xxmx_gl_journal_stg TO XXMX_CORE;
--
--
--
PROMPT
PROMPT
PROMPT *******************************************************************************
PROMPT **                                
PROMPT ** Completed Installing Database Objects for Maximise GL Journal Data Migration
PROMPT **                                
PROMPT *******************************************************************************
PROMPT
PROMPT
--
