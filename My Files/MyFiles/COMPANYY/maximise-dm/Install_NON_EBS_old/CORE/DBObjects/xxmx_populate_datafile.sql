--
--
--*****************************************************************************
--**
--**                 Copyright (c) 2021 Version 1
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
--** FILENAME  :  xxmx_populate_file_groups.sql
--**
--** FILEPATH  :  ????
--**
--** VERSION   :  1.0
--**
--** EXECUTE
--** IN SCHEMA :  APPS
--**
--** AUTHORS   :  Ian S. Vickerstaff
--**
--** PURPOSE   :  This script populates the XXMX_FILE_GROUP_PROPERTIES table.
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
--** 1.    None
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
--**   1.0  04-NOV-2020  Ian S. Vickerstaff  Created for Maximise.
--**
--**   1.1  14-JUL-2021  Ian S. Vickerstaff  Header comment updates.
--**
--******************************************************************************
--

Insert into XXMX_HCM_DATAFILE_XFM_MAP (DATAFILE_ID,APPLICATION_SUITE,APPLICATION,BUSINESS_ENTITY,SUB_ENTITY,DATA_FILE_NAME,FUSION_DATA_FILE_NAME) values (1,'HCM','HR','BANKS_AND_BRANCHES','BANK_BRANCHES','BankBranch','BankBranch.dat');
Insert into XXMX_HCM_DATAFILE_XFM_MAP (DATAFILE_ID,APPLICATION_SUITE,APPLICATION,BUSINESS_ENTITY,SUB_ENTITY,DATA_FILE_NAME,FUSION_DATA_FILE_NAME) values (2,'HCM','HR','BANKS_AND_BRANCHES','BANKS','Bank','Bank.dat');
Insert into XXMX_HCM_DATAFILE_XFM_MAP (DATAFILE_ID,APPLICATION_SUITE,APPLICATION,BUSINESS_ENTITY,SUB_ENTITY,DATA_FILE_NAME,FUSION_DATA_FILE_NAME) values (3,'HCM','HR','PERSON','PERSON','WorkerHire','Worker.dat');
Insert into XXMX_HCM_DATAFILE_XFM_MAP (DATAFILE_ID,APPLICATION_SUITE,APPLICATION,BUSINESS_ENTITY,SUB_ENTITY,DATA_FILE_NAME,FUSION_DATA_FILE_NAME) values (4,'HCM','HR','PERSON','PERSON_CONTACTS','Contacts','Contacts.dat');
Insert into XXMX_HCM_DATAFILE_XFM_MAP (DATAFILE_ID,APPLICATION_SUITE,APPLICATION,BUSINESS_ENTITY,SUB_ENTITY,DATA_FILE_NAME,FUSION_DATA_FILE_NAME) values (5,'HCM','HR','PERSON','PERSON_DISABILITY','PersonDisability','PersonDisability.dat');
Insert into XXMX_HCM_DATAFILE_XFM_MAP (DATAFILE_ID,APPLICATION_SUITE,APPLICATION,BUSINESS_ENTITY,SUB_ENTITY,DATA_FILE_NAME,FUSION_DATA_FILE_NAME) values (6,'HCM','HR','PERSON','PERSON_IMAGES','PersonImages','PersonImages.dat');
Insert into XXMX_HCM_DATAFILE_XFM_MAP (DATAFILE_ID,APPLICATION_SUITE,APPLICATION,BUSINESS_ENTITY,SUB_ENTITY,DATA_FILE_NAME,FUSION_DATA_FILE_NAME) values (7,'HCM','HR','PERSON','PERSON_ABSENCE','PersonAbsenceEntry','PersonAbsenceEntry.dat');
Insert into XXMX_HCM_DATAFILE_XFM_MAP (DATAFILE_ID,APPLICATION_SUITE,APPLICATION,BUSINESS_ENTITY,SUB_ENTITY,DATA_FILE_NAME,FUSION_DATA_FILE_NAME) values (8,'HCM','HR','WORKER','PERSON_POS','WorkerTermination','Worker.dat');
Insert into XXMX_HCM_DATAFILE_XFM_MAP (DATAFILE_ID,APPLICATION_SUITE,APPLICATION,BUSINESS_ENTITY,SUB_ENTITY,DATA_FILE_NAME,FUSION_DATA_FILE_NAME) values (9,'HCM','HR','WORKER','PERSON_ASSIGNMENTS','WorkerAddAsg','Worker.dat');
Insert into XXMX_HCM_DATAFILE_XFM_MAP (DATAFILE_ID,APPLICATION_SUITE,APPLICATION,BUSINESS_ENTITY,SUB_ENTITY,DATA_FILE_NAME,FUSION_DATA_FILE_NAME) values (10,'HCM','HR','WORKER','ASSGINMENT_PAYROLL','AssignedPayroll','AssignedPayroll.dat');
Insert into XXMX_HCM_DATAFILE_XFM_MAP (DATAFILE_ID,APPLICATION_SUITE,APPLICATION,BUSINESS_ENTITY,SUB_ENTITY,DATA_FILE_NAME,FUSION_DATA_FILE_NAME) values (11,'HCM','HR','WORKER','PERSON_PAYMENT_METHOD','PersonalPaymentMethod','PersonalPaymentMethod.dat');
Insert into XXMX_HCM_DATAFILE_XFM_MAP (DATAFILE_ID,APPLICATION_SUITE,APPLICATION,BUSINESS_ENTITY,SUB_ENTITY,DATA_FILE_NAME,FUSION_DATA_FILE_NAME) values (12,'HCM','HR','WORKER','PERSON_ASG_SUPERVISOR','WorkerSupervisor','Worker.dat');
Insert into XXMX_HCM_DATAFILE_XFM_MAP (DATAFILE_ID,APPLICATION_SUITE,APPLICATION,BUSINESS_ENTITY,SUB_ENTITY,DATA_FILE_NAME,FUSION_DATA_FILE_NAME) values (13,'HCM','HR','WORKER','ASG_SALARY','Salary','Salary.dat');
Insert into XXMX_HCM_DATAFILE_XFM_MAP (DATAFILE_ID,APPLICATION_SUITE,APPLICATION,BUSINESS_ENTITY,SUB_ENTITY,DATA_FILE_NAME,FUSION_DATA_FILE_NAME) values (14,'HCM','HR','WORKER','ASSIGNMENT_WRKMSURE','WorkerCurrent','Worker.dat');
Insert into XXMX_HCM_DATAFILE_XFM_MAP (DATAFILE_ID,APPLICATION_SUITE,APPLICATION,BUSINESS_ENTITY,SUB_ENTITY,DATA_FILE_NAME,FUSION_DATA_FILE_NAME) values (15,'HCM','HR','WORKER','EXTERNAL_BANK_ACCOUNTS','ExternalBankAccount','ExternalBankAccount.dat');
Insert into XXMX_HCM_DATAFILE_XFM_MAP (DATAFILE_ID,APPLICATION_SUITE,APPLICATION,BUSINESS_ENTITY,SUB_ENTITY,DATA_FILE_NAME,FUSION_DATA_FILE_NAME) values (16,'HCM','HR','TALENT','TALENT','TalentProfile','TalentProfile.dat');
commit;
/