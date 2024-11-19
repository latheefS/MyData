--------------------------------------------------------
--  DDL for Package Body XXMX_KIT_NATIONAL_IDENTIFIER_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "XXMX_CORE"."XXMX_KIT_NATIONAL_IDENTIFIER_PKG" AS 

    gvv_leg_code         VARCHAR2(10) := 'AZ';
------------------------------------------------------------

/* Procedure to Update NID Extracted data */
------------------------------------------
PROCEDURE update_nid_extract_data
IS 
 -- This Procedure will update Migration Set ID and Name Etc., details from PERSONS_STG table.
       pt_i_MigrationSetID   NUMBER;
       pt_i_MigrationSetName VARCHAR2(50);
	   p_migration_status  VARCHAR2(50);
       p_bg_name VARCHAR2(50);
       p_bg_id  NUMBER;

    BEGIN

	  BEGIN
	    SELECT unique MIGRATION_SET_ID, MIGRATION_SET_NAME, MIGRATION_STATUS, BG_NAME, BG_ID 
	      INTO pt_i_MigrationSetID, pt_i_MigrationSetName, p_migration_status, p_bg_name, p_bg_id
	      FROM xxmx_per_PERSONS_STG;
	  EXCEPTION
	     WHEN OTHERS THEN
		    DBMS_OUTPUT.PUT_LINE('Exception while selecting data from PERSONS table-'||SQLERRM);
	  END;

	  BEGIN
	    UPDATE XXMX_PER_NID_F_STG
		   SET MIGRATION_SET_ID = pt_i_MigrationSetID
		     , MIGRATION_SET_NAME = pt_i_MigrationSetName
			 , MIGRATION_STATUS = P_BG_NAME
			 , BG_ID = P_BG_ID
			 , LEGISLATION_CODE = gvv_leg_code;
	  EXCEPTION
	     WHEN OTHERS THEN
		    DBMS_OUTPUT.PUT_LINE('Exception while Updating data in NID table-'||SQLERRM);
	  END;
      
      BEGIN
	    UPDATE XXMX_PER_NID_F_STG STG
		   SET PERSON_ID = (SELECT PERSON_ID FROM XXMX_PER_PERSONS_STG
                             WHERE PERSONNUMBER = STG.PERSONNUMBER);
	  EXCEPTION
	     WHEN OTHERS THEN
		    DBMS_OUTPUT.PUT_LINE('Exception while Updating PERSON_ID in NID table-'||SQLERRM);
	  END;
      
      BEGIN	  
	  -- To remove space between Aadhar Card Number
         update XXMX_PER_NID_F_stg set national_identifier_number=replace(national_identifier_number,' ','') where national_identifier_type = 'Aadhaar Card Number';
         update XXMX_PER_NID_F_stg set national_identifier_number=replace(national_identifier_number,'-','') where national_identifier_type = 'Aadhaar Card Number';
       EXCEPTION
	     WHEN OTHERS THEN
		    DBMS_OUTPUT.PUT_LINE('Exception while Updating Aadhar Value-'||SQLERRM);
	  END;

	END update_nid_extract_data;
---------------------------------------------------
procedure transform_nid_details
IS
-- This Procedure will update NID Type and Legislation Code in XFM table.
BEGIN
-- Insert STG data into XFM
   BEGIN
      INSERT INTO XXMX_PER_NID_F_XFM SELECT * FROM XXMX_PER_NID_F_STG;
   EXCEPTION
	     WHEN OTHERS THEN
		    DBMS_OUTPUT.PUT_LINE('Exception while Inserting data into NID_XFM table-'||SQLERRM);
   END;

-- Updating XFM table data
   
      --LEGISLATION_CODE
     BEGIN
	   UPDATE XXMX_PER_NID_F_XFM NID
	      SET LEGISLATION_CODE = (SELECT UNIQUE LEGISLATION_CODE 
		                            FROM XXMX_PER_LEG_F_XFM 
								   WHERE PERSONNUMBER = NID.PERSONNUMBER)
            , BG_NAME = (SELECT UNIQUE BG_NAME
		                            FROM XXMX_PER_LEG_F_XFM 
								   WHERE PERSONNUMBER = NID.PERSONNUMBER);
     EXCEPTION
	     WHEN OTHERS THEN
		    DBMS_OUTPUT.PUT_LINE('Exception while Updating data in NID table-'||SQLERRM);
	  END;
   
	  -- National_Identifier_Type
	 BEGIN
	   UPDATE XXMX_PER_NID_F_XFM
	      SET NATIONAL_IDENTIFIER_TYPE = CASE
		                                   WHEN NATIONAL_IDENTIFIER_TYPE='Personal code'
										   THEN 'ORA_HRX_PERS_CODE'
		                                   WHEN NATIONAL_IDENTIFIER_TYPE='National Identifier'
										   THEN 'NID'
		                                   WHEN NATIONAL_IDENTIFIER_TYPE='Personal Public Service (PPS)'
										   THEN 'PPS'
		                                   WHEN NATIONAL_IDENTIFIER_TYPE='Social Security Number'
										   THEN 'SSN'
										   WHEN NATIONAL_IDENTIFIER_TYPE='BSN'
										   THEN 'BSN_SOFI_NUMBER'
										   WHEN NATIONAL_IDENTIFIER_TYPE='Hongkong Identity Card (HKID)'
										   THEN 'HKID'
		                                   WHEN NATIONAL_IDENTIFIER_TYPE='Social security number'
										   THEN 'SSN'
										   WHEN NATIONAL_IDENTIFIER_TYPE='Social Security System (SSS)'
										   THEN 'ORA_HRX_SSS'
										   WHEN NATIONAL_IDENTIFIER_TYPE='Aadhaar Card Number'
										   THEN 'ORA_HRX_IN_AADHAR_NUM'
										   WHEN NATIONAL_IDENTIFIER_TYPE='Social Insurance Number'
										   THEN 'SIN'
										   WHEN NATIONAL_IDENTIFIER_TYPE= 'National Registration Identity Card (NRIC)'
										   THEN 'NRIC_FIN'
										   ELSE NULL
										 END;
	 EXCEPTION
	     WHEN OTHERS THEN
		    DBMS_OUTPUT.PUT_LINE('Exception while Updating NID Type in NID table-'||SQLERRM);
	  END;									   
    
   
END transform_nid_details;

-----------------------------------------------
/* Procedure to Generate HDL for National Identifier */
------------------------------------------
procedure generate_nid_hdl
IS

    nid_hdl_header   VARCHAR2(10000) := 'METADATA|PersonNationalIdentifier|SourceSystemOwner|SourceSystemId|PersonId(SourceSystemId)|PersonNumber|LegislationCode|IssueDate|ExpirationDate|PlaceOfIssue|NationalIdentifierType|NationalIdentifierNumber|PrimaryFlag';
    pv_i_file_name VARCHAR2(100) := 'NationalIdentifier.dat';

BEGIN
	    DELETE FROM xxmx_hdl_file_temp 
        WHERE FILE_NAME = pv_i_file_name;
		
        COMMIT;
  --Hire File
    -- Worker
	    INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          VALUES (pv_i_file_name,'File Header', nid_hdl_header);

        INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          SELECT UNIQUE pv_i_file_name
		       , 'NationalIdentifier_Data'
			   , 'MERGE|PersonNationalIdentifier|EBS|PersonNationalIdentifier-'
                 ||PERSONNUMBER||'|Worker-'
                 ||PERSONNUMBER||'|'
                 ||PERSONNUMBER||'|'
                 ||LEGISLATION_CODE||'||||'
                 ||NATIONAL_IDENTIFIER_TYPE||'|'
                 ||NATIONAL_IDENTIFIER_NUMBER||'|'
			 from XXMX_PER_NID_F_XFM
              WHERE NATIONAL_IDENTIFIER_NUMBER NOT IN ('N/A','0','TBC')
              AND BG_NAME IS NOT NULL;

end generate_nid_hdl;
--------------------------------------
end xxmx_kit_national_identifier_pkg;

/
