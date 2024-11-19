--ALTER SESSION SET CONTAINER = MXDM_PDB1;
--
--
--CONNECT xxmx_xfm/&xxmx_xfm_pwd
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
--** FILENAME  :  xmxx_gl_balances_xfm_dbi.sql
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
--**
--******************************************************************************
--
--
PROMPT
PROMPT
PROMPT ***********************************************************************
PROMPT **
PROMPT ** Installing Transform Database Objects for Maximise GL Data Migration
PROMPT **
PROMPT ***********************************************************************
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
PROMPT Dropping Table xxmx_gl_balances_xfm
PROMPT
--
EXEC DropTable ('XXMX_GL_BALANCES_XFM')
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
PROMPT Creating Table xxmx_gl_balances_xfm
PROMPT
--
CREATE TABLE xxmx_gl_balances_xfm
     (
	  file_set_id                     VARCHAR2(30)
     ,migration_set_id                NUMBER	  
     ,migration_set_name              VARCHAR2(100)
     ,migration_status                VARCHAR2(50)
     ,fusion_status_code              VARCHAR2(50)
     ,source_ledger_name              VARCHAR2(30)
     ,fusion_ledger_id                NUMBER
     ,fusion_ledger_name              VARCHAR2(30)
     ,accounting_date                 DATE
     ,user_je_source_name             VARCHAR2(25)
     ,user_je_category_name           VARCHAR2(25)
     ,currency_code                   VARCHAR2(15)
     ,journal_entry_creation_date     DATE
     ,actual_flag                     VARCHAR2(1)
     ,segment1                        VARCHAR2(25)
     ,segment2                        VARCHAR2(25)
     ,segment3                        VARCHAR2(25)
     ,segment4                        VARCHAR2(25)
     ,segment5                        VARCHAR2(25)
     ,segment6                        VARCHAR2(25)
     ,segment7                        VARCHAR2(25)
     ,segment8                        VARCHAR2(25)
     ,segment9                        VARCHAR2(25)
     ,segment10                       VARCHAR2(25)
     ,segment11                       VARCHAR2(25)
     ,segment12                       VARCHAR2(25)
     ,segment13                       VARCHAR2(25)
     ,segment14                       VARCHAR2(25)
     ,segment15                       VARCHAR2(25)
     ,segment16                       VARCHAR2(25)
     ,segment17                       VARCHAR2(25)
     ,segment18                       VARCHAR2(25)
     ,segment19                       VARCHAR2(25)
     ,segment20                       VARCHAR2(25)
     ,segment21                       VARCHAR2(25)
     ,segment22                       VARCHAR2(25)
     ,segment23                       VARCHAR2(25)
     ,segment24                       VARCHAR2(25)
     ,segment25                       VARCHAR2(25)
     ,segment26                       VARCHAR2(25)
     ,segment27                       VARCHAR2(25)
     ,segment28                       VARCHAR2(25)
     ,segment29                       VARCHAR2(25)
     ,segment30                       VARCHAR2(25)
     ,entered_dr                      NUMBER
     ,entered_cr                      NUMBER
     ,accounted_dr                    NUMBER
     ,accounted_cr                    NUMBER
     ,reference1                      VARCHAR2(100)
     ,reference2                      VARCHAR2(240)
     ,reference3                      VARCHAR2(100)
     ,reference4                      VARCHAR2(100)
     ,reference5                      VARCHAR2(240)
     ,reference6                      VARCHAR2(100)
     ,reference7                      VARCHAR2(100)
     ,reference8                      VARCHAR2(100)
     ,reference9                      VARCHAR2(100)
     ,reference10                     VARCHAR2(240)
     ,reference21                     VARCHAR2(240)
     ,reference22                     VARCHAR2(240)
     ,reference23                     VARCHAR2(240)
     ,reference24                     VARCHAR2(240)
     ,reference25                     VARCHAR2(240)
     ,reference26                     VARCHAR2(240)
     ,reference27                     VARCHAR2(240)
     ,reference28                     VARCHAR2(240)
     ,reference29                     VARCHAR2(240)
     ,reference30                     VARCHAR2(240)
     ,stat_amount                     NUMBER
     ,user_currency_conversion_type   VARCHAR2(30)
     ,currency_conversion_date        DATE
     ,currency_conversion_rate        NUMBER
     ,group_id                        NUMBER
     ,attribute_category              VARCHAR2(150)
     ,attribute1                      VARCHAR2(150)
     ,attribute2                      VARCHAR2(150)
     ,attribute3                      VARCHAR2(150)
     ,attribute4                      VARCHAR2(150)
     ,attribute5                      VARCHAR2(150)
     ,attribute6                      VARCHAR2(150)
     ,attribute7                      VARCHAR2(150)
     ,attribute8                      VARCHAR2(150)
     ,attribute9                      VARCHAR2(150)
     ,attribute10                     VARCHAR2(150)
     ,attribute11                     VARCHAR2(150)
     ,attribute12                     VARCHAR2(150)
     ,attribute13                     VARCHAR2(150)
     ,attribute14                     VARCHAR2(150)
     ,attribute15                     VARCHAR2(150)
     ,attribute16                     VARCHAR2(150)
     ,attribute17                     VARCHAR2(150)
     ,attribute18                     VARCHAR2(150)
     ,attribute19                     VARCHAR2(150)
     ,attribute20                     VARCHAR2(150)
     ,attribute_category3             VARCHAR2(150)
     ,average_journal_flag            VARCHAR2(1)
     ,originating_bal_seg_value       VARCHAR2(25)
     ,encumbrance_type_id             NUMBER
     ,jgzz_recon_ref                  VARCHAR2(240)
     ,period_name                     VARCHAR2(15)
     );
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
PROMPT Granting permissions on xxmx_gl_balances_xfm to the XXMX_CORE Schema 
PROMPT
--
GRANT ALL ON xxmx_gl_balances_xfm
          TO XXMX_CORE;
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
