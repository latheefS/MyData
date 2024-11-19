--------------------------------------------------------
--  DDL for View XXMX_HR_HCM_NID_HDL_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_CORE"."XXMX_HR_HCM_NID_HDL_V" ("METADATA") AS 
  SELECT 'METADATA|PersonNationalIdentifier|SourceSystemOwner|SourceSystemId|PersonId(SourceSystemId)|PersonNumber|LegislationCode|IssueDate|ExpirationDate|PlaceOfIssue|NationalIdentifierType|NationalIdentifierNumber|PrimaryFlag' METADATA FROM DUAL
UNION ALL
/*INSERT INTO XXMX_PER_NID_F_STG(PERSONNUMBER,NATIONAL_IDENTIFIER_TYPE,NATIONAL_IDENTIFIER_NUMBER) VALUES('1216','Personal Public Service (PPS)','5812509L');

UPDATE xxmx_per_nid_f_xfm SET ATTRIBUTE1 ='ORA_HRX_PERS_CODE' WHERE NATIONAL_IDENTIFIER_TYPE='Personal code';
UPDATE xxmx_per_nid_f_xfm SET ATTRIBUTE1 ='NID' WHERE NATIONAL_IDENTIFIER_TYPE='National Identifier';
UPDATE xxmx_per_nid_f_xfm SET ATTRIBUTE1 ='PPS' WHERE NATIONAL_IDENTIFIER_TYPE='Personal Public Service (PPS)';
UPDATE xxmx_per_nid_f_xfm SET ATTRIBUTE1 ='SSN' WHERE NATIONAL_IDENTIFIER_TYPE='Social Security Number';
UPDATE xxmx_per_nid_f_xfm SET ATTRIBUTE1 ='BSN_SOFI_NUMBER' WHERE NATIONAL_IDENTIFIER_TYPE='BSN';
UPDATE xxmx_per_nid_f_xfm SET ATTRIBUTE1 ='HKID' WHERE NATIONAL_IDENTIFIER_TYPE='Hongkong Identity Card (HKID)';
UPDATE xxmx_per_nid_f_xfm SET ATTRIBUTE1 ='SSN' WHERE NATIONAL_IDENTIFIER_TYPE='Social security number';
UPDATE xxmx_per_nid_f_xfm SET ATTRIBUTE1 ='ORA_HRX_SSS' WHERE NATIONAL_IDENTIFIER_TYPE='Social Security System (SSS)';
UPDATE xxmx_per_nid_f_xfm SET ATTRIBUTE1 ='ORA_HRX_IN_AADHAR_NUM' WHERE NATIONAL_IDENTIFIER_TYPE='Aadhaar Card Number';
UPDATE xxmx_per_nid_f_xfm SET ATTRIBUTE1 ='SIN' WHERE NATIONAL_IDENTIFIER_TYPE='Social Insurance Number';
UPDATE xxmx_per_nid_f_xfm SET ATTRIBUTE1 ='NRIC_FIN' WHERE NATIONAL_IDENTIFIER_TYPE='National Registration Identity Card (NRIC)';
-- To remove space between Aadhar Card Number
update xxmx_per_nid_f_xfm SET national_identifier_number=replace(national_identifier_number,' ','') where national_identifier_type = 'Aadhaar Card Number';
update xxmx_per_nid_f_xfm SET national_identifier_number=replace(national_identifier_number,'-','') where national_identifier_type = 'Aadhaar Card Number'; */

SELECT 'MERGE|PersonNationalIdentifier|EBS|PersonNationalIdentifier-'||PERSONNUMBER||'|Worker-'||PERSONNUMBER||'|'||PERSONNUMBER||'|'||LEGISLATION_CODE||'||||'||ATTRIBUTE1||'|'||NATIONAL_IDENTIFIER_NUMBER||'|'
FROM xxmx_per_nid_f_XFM
;
