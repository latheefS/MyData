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
--** FILENAME  :  xxmx_hcm_comp_ssid_transform.sql
--**
--** FILEPATH  :  /home/oracle/MXDM/install/xxmx_core
--**
--** VERSION   :  1.0
--**
--** EXECUTE
--** IN SCHEMA :  XXMX_STG
--**
--** AUTHORS   :  Pallavi Kanajar
--**
--** PURPOSE   :  This script populates the SSID Mapping Tables 
--**
--** NOTES     :
--**
--**
--******************************************************************************

SET DEFINE OFF;

DELETE
FROM   xxmx_core.xxmx_hcm_comp_ssid_transform;
/

Insert into xxmx_hcm_comp_ssid_transform
 (application,xfm_table,transform_code,COLUMN_NAME) 
 values
 ('HR','XXMX_PER_PEOPLE_F_XFM','PERSONNUMBER','SOURCESYSTEMID');
 
Insert into xxmx_hcm_comp_ssid_transform
 (application,xfm_table,transform_code,COLUMN_NAME) 
 values
 ('HR','XXMX_PER_EMAIL_F_XFM','PERSONNUMBER||''-''||EMAIL_TYPE','SOURCESYSTEMID'); 

Insert into xxmx_hcm_comp_ssid_transform
 (application,xfm_table,transform_code,COLUMN_NAME) 
 values 
 ('HR','XXMX_PER_ADDRESS_F_XFM','PERSONNUMBER||''-''||ADDRESS_TYPE','SOURCESYSTEMID'); 

Insert into xxmx_hcm_comp_ssid_transform
 (application,xfm_table,transform_code,COLUMN_NAME) 
 values
 ('HR','XXMX_PER_NID_F_XFM','PERSONNUMBER','SOURCESYSTEMID'); 

Insert into xxmx_hcm_comp_ssid_transform
 (application,xfm_table,transform_code,COLUMN_NAME) 
 values
 ('HR','XXMX_PER_PASSPORT_XFM','PERSONNUMBER','SOURCESYSTEMID'); 
 
Insert into xxmx_hcm_comp_ssid_transform 
(application,xfm_table,transform_code,COLUMN_NAME) 
values 
('HR','XXMX_PER_SENIORITYDT_XFM','PERSONNUMBER','SOURCESYSTEMID'); 

Insert into xxmx_hcm_comp_ssid_transform 
(application,xfm_table,transform_code,COLUMN_NAME) 
 values
 ('HR','XXMX_PER_NAMES_F_XFM','PERSONNUMBER','SOURCESYSTEMID'); 

Insert into xxmx_hcm_comp_ssid_transform
 (application,xfm_table,transform_code,COLUMN_NAME) 
 values 
 ('HR','XXMX_PER_ETHNICITIES_XFM','PERSONNUMBER','SOURCESYSTEMID'); 
 
Insert into xxmx_hcm_comp_ssid_transform
 (application,xfm_table,transform_code,COLUMN_NAME) 
 values ('HR','XXMX_CITIZENSHIPS_XFM','PERSONNUMBER','SOURCESYSTEMID'); 
 
Insert into xxmx_hcm_comp_ssid_transform 
(application,xfm_table,transform_code,COLUMN_NAME) 
 values 
('HR','XXMX_PER_ASSIGNMENTS_M_XFM','ASSIGNMENT_NUMBER','SOURCESYSTEMID'); 

Insert into xxmx_hcm_comp_ssid_transform 
(application,xfm_table,transform_code,COLUMN_NAME) 
 values
 ('HR','XXMX_PER_PHONES_XFM','PERSONNUMBER||''-''||PHONE_TYPE','SOURCESYSTEMID'); 

Insert into xxmx_hcm_comp_ssid_transform 
(application,xfm_table,transform_code,COLUMN_NAME) 
 values
 ('HR','XXMX_PER_LEG_F_XFM','PERSONNUMBER','SOURCESYSTEMID'); 

Insert into xxmx_hcm_comp_ssid_transform
 (application,xfm_table,transform_code,COLUMN_NAME) 
 values
 ('HR','XXMX_PER_RELIGION_XFM','PERSONNUMBER','SOURCESYSTEMID'); 
 
Insert into xxmx_hcm_comp_ssid_transform 
(application,xfm_table,transform_code,COLUMN_NAME) 
values
 ('HR','XXMX_PER_VISA_F_XFM','PERSONNUMBER','SOURCESYSTEMID'); 

Insert into xxmx_hcm_comp_ssid_transform
 (application,xfm_table,transform_code,COLUMN_NAME) 
 values
 ('HR','XXMX_ASG_GRADESTEP_XFM','ASSIGNMENT_NUMBER','SOURCESYSTEMID'); 
 
Insert into xxmx_hcm_comp_ssid_transform 
(application,xfm_table,transform_code,COLUMN_NAME) 
 values
 ('HR','XXMX_ASG_WORKMSURE_XFM','ASSIGNMENT_NUMBER','SOURCESYSTEMID'); 

Insert into xxmx_hcm_comp_ssid_transform 
(application,xfm_table,transform_code,COLUMN_NAME) 
 values 
 ('HR','XXMX_BANKS_XFM','BANK_NAME','SOURCESYSTEMID'); 

Insert into xxmx_hcm_comp_ssid_transform 
(application,xfm_table,transform_code,COLUMN_NAME) 
values 
('HR','XXMX_BANK_BRANCHES_XFM','BANK_BRANCH_NUMBER','SOURCESYSTEMID'); 

Insert into xxmx_hcm_comp_ssid_transform 
(application,xfm_table,transform_code,COLUMN_NAME) 
values 
('HR','XXMX_PER_ASG_SUP_F_XFM','ASSIGNMENT_NUMBER','SOURCESYSTEMID'); 

Insert into xxmx_hcm_comp_ssid_transform
 (application,xfm_table,transform_code,COLUMN_NAME) 
 values 
 ('HR','XXMX_EXT_BANK_ACC_XFM','PERSONNUMBER ||''_''|| BANK_ACCOUNT_NUMBER ||''_''|| BRANCH_NAME','SOURCESYSTEMID'); 

Insert into xxmx_hcm_comp_ssid_transform 
(application,xfm_table,transform_code,COLUMN_NAME) 
values 
('HR','XXMX_PER_PAY_METHOD_XFM','ASSIGNMENT_NUMBER','SOURCESYSTEMID'); 

Insert into xxmx_hcm_comp_ssid_transform
 (application,xfm_table,transform_code,COLUMN_NAME) 
 values
 ('HR','XXMX_PER_ASG_SALARY_XFM','ASSIGNMENT_NUMBER||''-''||TO_CHAR(EFFECTIVE_START_DATE,''RRRRMMDD'')','SOURCESYSTEMID'); 
 
 
Insert into xxmx_hcm_comp_ssid_transform
 (application,xfm_table,transform_code,COLUMN_NAME) 
 values
 ('HR','XXMX_ASG_PAYROLL_XFM','ASSIGNMENT_NUMBER||''-''||TO_CHAR(EFFECTIVE_START_DATE,''RRRRMMDD'')','SOURCESYSTEMID');  
 
Insert into xxmx_hcm_comp_ssid_transform
 (application,xfm_table,transform_code,COLUMN_NAME) 
 values
 ('HR','XXMX_HCM_IREC_CAN_XFM','CANDIDATE_NUMBER','SOURCE_SYSTEM_ID');  
 
 
 Insert into xxmx_hcm_comp_ssid_transform
 (application,xfm_table,transform_code,COLUMN_NAME) 
 values
 ('HR','XXMX_HCM_IREC_CAN_ADDRESS_XFM','CANDIDATE_NUMBER||''-''||ADDRESS_TYPE','SOURCE_SYSTEM_ID'); 
 
 Insert into xxmx_hcm_comp_ssid_transform
 (application,xfm_table,transform_code,COLUMN_NAME) 
 values
 ('HR','XXMX_HCM_IREC_CAN_ADDRESS_XFM','''Candidate''||''-''||CANDIDATE_NUMBER','PERSONID_SOURCESYTEMID'); 
 
 Insert into xxmx_hcm_comp_ssid_transform
 (application,xfm_table,transform_code,COLUMN_NAME) 
 values
 ('HR','XXMX_HCM_IREC_CAN_EMAIL_XFM','CANDIDATE_NUMBER||''-''||EMAIL_TYPE','SOURCE_SYSTEM_ID'); 
 
 Insert into xxmx_hcm_comp_ssid_transform
 (application,xfm_table,transform_code,COLUMN_NAME) 
 values
 ('HR','XXMX_HCM_IREC_CAN_EMAIL_XFM','''Candidate''||''-''||CANDIDATE_NUMBER','PERSONID_SOURCESYTEMID'); 
  
  
  Insert into xxmx_hcm_comp_ssid_transform
 (application,xfm_table,transform_code,COLUMN_NAME) 
 values
 ('HR','XXMX_HCM_IREC_CAN_PHONE_XFM','CANDIDATE_NUMBER||''-''||PHONE_TYPE','SOURCE_SYSTEM_ID'); 
 
 Insert into xxmx_hcm_comp_ssid_transform
 (application,xfm_table,transform_code,COLUMN_NAME) 
 values
 ('HR','XXMX_HCM_IREC_CAN_PHONE_XFM','''Candidate''||''-''||CANDIDATE_NUMBER','PERSONID_SOURCESYTEMID'); 
 
 
 Insert into xxmx_hcm_comp_ssid_transform
 (application,xfm_table,transform_code,COLUMN_NAME) 
 values
 ('HR','XXMX_HCM_IREC_CAN_ATTMT_XFM','''Candidate''||''-''||CANDIDATE_NUMBER','PERSONID_SOURCESYTEMID'); 
 
COMMIT;
--
--