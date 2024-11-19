
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_CORE"."XXMX_HR_HCM_NID_HDL_V" ("METADATA") AS 
  SELECT 'METADATA|PersonNationalIdentifier|SourceSystemOwner|SourceSystemId|PersonId(SourceSystemId)|PersonNumber|LegislationCode|IssueDate|ExpirationDate|PlaceOfIssue|NationalIdentifierType|NationalIdentifierNumber|PrimaryFlag' METADATA FROM DUAL
UNION ALL
SELECT 'MERGE|PersonNationalIdentifier|EBS|PersonNID-'||PERSONNUMBER||'-'||NATIONAL_IDENTIFIER_NUMBER||'|Worker-'||PERSONNUMBER||'|'||PERSONNUMBER||'|'||LEGISLATION_CODE||'||||'||ATTRIBUTE1||'|'||NATIONAL_IDENTIFIER_NUMBER||'|'
FROM xxmx_per_nid_f_XFM;

