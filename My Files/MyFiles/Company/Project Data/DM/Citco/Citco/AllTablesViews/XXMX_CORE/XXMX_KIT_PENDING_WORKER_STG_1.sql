--------------------------------------------------------
--  DDL for Package Body XXMX_KIT_PENDING_WORKER_STG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "XXMX_CORE"."XXMX_KIT_PENDING_WORKER_STG" AS 

/*    gcv_PackageName                           CONSTANT  VARCHAR2(30)                                := 'xxmx_kit_pending_worker_stg';
    gct_ApplicationSuite                      CONSTANT  xxmx_module_messages.application_suite%TYPE := 'HCM';
    gct_Application                           CONSTANT  xxmx_module_messages.application%TYPE       := 'PER';
    gv_i_BusinessEntity                       CONSTANT  VARCHAR2(100)                               := 'WORKER';
    ct_Phase                                  CONSTANT  xxmx_module_messages.phase%TYPE             := 'UPDATE';
    cv_i_BusinessEntityLevel                  CONSTANT  VARCHAR2(100)                               := 'ALL';
    gv_hr_date					              DATE                                                  := '31-DEC-4712';

    gvv_ReturnStatus                          VARCHAR2(1); 
    gvv_ProgressIndicator                     VARCHAR2(100); 
    gvn_RowCount                              NUMBER;
    gvt_ReturnMessage                         xxmx_module_messages.module_message%TYPE;
    gvt_Severity                              xxmx_module_messages.severity%TYPE;
    gvt_OracleError                           xxmx_module_messages.oracle_error%TYPE;
    gvt_ModuleMessage                         xxmx_module_messages.module_message%TYPE;
    e_ModuleError                             EXCEPTION;

	 gvv_migration_date_to                     VARCHAR2(30);  
    gvv_prev_tax_year_date                    VARCHAR2(30);         
    gvd_migration_date_to                     DATE;  
    gvd_migration_date_from                   DATE;
    gvd_prev_tax_year_date                    DATE;   */

    gvv_migration_date_from      DATE := TO_DATE('06/OCT/2023','DD/MON/RRRR');
    gvv_leg_code         VARCHAR2(10) := 'AZ';
    gvd_migration_date_from DATE := TO_DATE('06-OCT-2023','DD-MON-RRRR');
------------------------------------------------------------

/* Procedure to Insert Pending Workers Data into APL Tables*/
------------------------------------------
procedure insert_pendingworker_data(p_bg_name                      IN      VARCHAR2  ,
                                    p_bg_id                        IN      NUMBER    ,
                                    pt_i_MigrationSetID            IN      xxmx_migration_headers.migration_set_id%TYPE    ,
                                    pt_i_MigrationSetName          IN      xxmx_migration_headers.migration_set_name%TYPE )
IS
     --  pt_i_MigrationSetID   NUMBER := 111;
     --  pt_i_MigrationSetName VARCHAR2(50) := 'HCM_HR_APL_PERSON_111_'||TO_CHAR(SYSDATE,'RRRRMMDDHH24MISS');
       --p_bg_name VARCHAR2(50) := 'Citco Group Business Group';
      -- p_bg_id  NUMBER := 81;
	
  BEGIN
      --   XXMX_PER_APL_PERSONS_STG
        DELETE 
        FROM    XXMX_PER_APL_PERSONS_STG
        WHERE   bg_id    = p_bg_id    ;

        COMMIT;
	BEGIN
        INSERT  
        INTO    XXMX_PER_APL_PERSONS_STG
                (migration_set_id
                ,migration_set_name                   
                ,migration_status
                ,bg_name
                ,bg_id
                ,start_date
                ,party_id
                ,correspondence_language
                ,blood_type
                ,date_of_birth
                ,date_of_death
                ,country_of_birth
                ,region_of_birth
                ,town_of_birth
                ,person_id
                ,PERSON_TYPE
				,PERSONNUMBER
				)
        SELECT  distinct pt_i_MigrationSetID                               
                ,pt_i_MigrationSetName                               
                ,'EXTRACTED'  
                ,p_bg_name
                ,p_bg_id
                ,NVL(xpmsd.original_date_of_hire , xpmsd.start_date)
                ,xpmsd.party_id party_id
                ,xpmsd.correspondence_language correspondence_language
                ,xpmsd.blood_type blood_type
				--DOB is Null in test instance. so defaulted to run the extract		
                ,NVL(xpmsd.date_of_birth ,to_date ('01-01-1980','DD-MM-YYYY')) date_of_birth
                ,xpmsd.date_of_death date_of_death
                ,xpmsd.country_of_birth country_of_birth
                ,xpmsd.region_of_birth region_of_birth
                ,xpmsd.town_of_birth town_of_birth
                ,xpmsd.person_id
                --,ppt.SYSTEM_PERSON_TYPE 
                ,xpmsd.system_person_type 
				--,NVL(xpmsd.employee_number, xpmsd.npw_number)
				,xpmsd.applicant_number
        FROM XXMX_HCM_CURRENT_PERSON_MV xpmsd
       WHERE 1=1
         AND xpmsd.system_person_type in ( 'APL')
         AND xpmsd.business_group_id =  p_bg_id ;
    EXCEPTION
	   WHEN OTHERS THEN
	        DBMS_OUTPUT.PUT_LINE('Exception while loading data into XXMX_PER_APL_PERSONS_STG-'||SQLERRM);
	END;

commit;

 --   XXMX_PER_APL_NAMES_F_STG
	  DELETE 
        FROM    XXMX_PER_APL_NAMES_F_STG
        WHERE   bg_id    = p_bg_id    ;

        COMMIT;         

    BEGIN
        INSERT  
        INTO    XXMX_PER_APL_NAMES_F_STG
                (migration_set_id
                ,migration_set_name                   
                ,migration_status
                ,bg_name
                ,bg_id
                ,person_name_id
                ,effective_start_date
                ,effective_end_date
                ,person_id
                ,legislation_code
                ,last_name
                ,first_name
                ,middle_names
                ,title
                ,pre_name_adjunct
                ,suffix
                ,known_as
                ,previous_last_name
                ,honors
                ,full_name
                ,order_name
                ,name_type
				,personnumber)
				--Changed Done to remove Dependencies
		SELECT distinct  pt_i_MigrationSetID                               
                ,pt_i_MigrationSetName                               
                ,'EXTRACTED'  
                ,p_bg_name
                ,p_bg_id
                , person_id
                    || '_NAME' person_name_id
                ,per_all_people_f.effective_start_date
                ,per_all_people_f.effective_end_date c8_effective_end_date
                ,per_all_people_f.person_id person_id
                ,gvv_leg_code legislation_code
                ,TRIM(per_all_people_f.last_name)
                ,TRIM(per_all_people_f.first_name)
                ,TRIM(per_all_people_f.middle_names)
                ,per_all_people_f.title     title
                ,per_all_people_f.pre_name_adjunct 
                ,per_all_people_f.suffix
                ,per_all_people_f.known_as
                ,per_all_people_f.previous_last_name
                ,per_all_people_f.honors  
                ,per_all_people_f.full_name  
                ,NULL  
                ,'GLOBAL' name_type
				,per_all_people_f.applicant_number
        FROM    XXMX_HCM_CURRENT_PERSON_MV per_all_people_f 
		WHERE  per_all_people_f.business_Group_id = p_bg_id
		AND per_all_people_f.system_person_type = 'APL';
	EXCEPTION
	   WHEN OTHERS THEN
	        DBMS_OUTPUT.PUT_LINE('Exception while loading data into XXMX_PER_APL_NAMES_F_STG-'||SQLERRM);
	END;
COMMIT;

-- XXMX_PER_APL_LEG_F_STG

	DELETE 
        FROM    XXMX_PER_APL_LEG_F_STG
        WHERE   bg_id    = p_bg_id    ;

        COMMIT;        

	BEGIN
        INSERT  
        INTO    XXMX_PER_APL_LEG_F_STG
                (migration_set_id
                ,migration_set_name                   
                ,migration_status
                ,bg_name
                ,bg_id
                ,person_legislative_id
                ,effective_start_date
                ,effective_end_date
                ,person_id
                ,legislation_code
                ,sex
                ,marital_status
				,marital_status_Date
                ,per_information_category
                ,per_information1
                ,per_information2
                ,per_information3
                ,per_information4
                ,per_information5
                ,per_information6
                ,per_information7
                ,per_information8
                ,per_information9
                ,per_information10
				,   per_information11   
				,   per_information12   
				,   per_information13   
				,   per_information14   
				,   per_information15   
				,   per_information16   
				,   per_information17   
				,   per_information18   
				,   per_information19   
				,   per_information20   
				,   per_information21   
				,   per_information22   
				,   per_information23   
				,   per_information24   
				,   per_information25   
				,   per_information26   
				,   per_information27   
				,   per_information28   
				,   per_information29   
				,   per_information30 
				,personnumber)
        SELECT   pt_i_MigrationSetID                               
                ,pt_i_MigrationSetName                               
                ,'EXTRACTED'  
                ,p_bg_name
                ,p_bg_id
                , person_id
                    || '_LEGISLATIVE' person_legislative_id
                ,c5_effective_start_date effective_start_date
                ,c4_effective_end_date effective_end_date
                ,xxmx_per_persons_stg.person_id person_id
                ,gvv_leg_code legislation_code
                ,c24_sex            sex
                ,c21_marital_status marital_status
				,DECODE(c21_marital_status,NULL,NULL,
					                      'S', NULL,
										  c5_effective_start_date)
				,c3_per_information_category
				,c16_per_information1
                ,c22_per_information2
				,c13_per_information3
				,c11_per_information4
				,c12_per_information5
				,c15_per_information6
				,c23_per_information7
				,c17_per_information8
				,c14_per_information9
				,c18_per_information10
				,   per_information11   
				,   per_information12   
				,   per_information13   
				,   per_information14   
				,   per_information15   
				,   per_information16   
				,   per_information17   
				,   per_information18   
				,   per_information19   
				,   per_information20   
				,   per_information21   
				,   per_information22   
				,   per_information23   
				,   per_information24   
				,   per_information25   
				,   per_information26   
				,   per_information27   
				,   per_information28   
				,   per_information29   
				,   per_information30 
				,  NVL( employee_number,'NO_EMP_NUMBER')
        FROM    xxmx_per_APL_persons_stg xxmx_per_persons_stg
            ,
                (
                SELECT  decode (per_all_people_f.per_information25
                            ,'NOTVET'
                            ,'Y'
                            ,'N') c1_per_information10
                    ,per_all_people_f.per_information_category c3_per_information_category
                    ,per_all_people_f.effective_end_date c4_effective_end_date
                    ,per_all_people_f.effective_start_date c5_effective_start_date
                    ,per_all_people_f.per_information8 c7_per_information8
                    ,per_all_people_f.per_information4 c11_per_information4
                    ,per_all_people_f.per_information5 c12_per_information5
                    ,per_all_people_f.per_information3 c13_per_information3
                    ,per_all_people_f.per_information9 c14_per_information9
                    ,per_all_people_f.per_information6 c15_per_information6
                    ,per_all_people_f.per_information1 c16_per_information1
                    ,per_all_people_f.person_id c19_person_id
                    ,per_all_people_f.marital_status c21_marital_status
                    ,per_all_people_f.sex c24_sex
                    ,per_all_people_f.per_information2 c22_per_information2
                    ,per_all_people_f.per_information8 c17_per_information8
                    ,per_all_people_f.per_information7 c23_per_information7
                    ,per_all_people_f.per_information10 c18_per_information10
					,per_all_people_f.per_information11   
                    ,per_all_people_f.per_information12   
                    ,per_all_people_f.per_information13   
                    ,per_all_people_f.per_information14   
                    ,per_all_people_f.per_information15   
                    ,per_all_people_f.per_information16    
                    ,per_all_people_f.per_information17   
                    ,per_all_people_f.per_information18   
                    ,per_all_people_f.per_information19   
                    ,per_all_people_f.per_information20   
                    ,per_all_people_f.per_information21   
                    ,per_all_people_f.per_information22   
                    ,per_all_people_f.per_information23   
                    ,per_all_people_f.per_information24   
                    ,per_all_people_f.per_information25   
                    ,per_all_people_f.per_information26   
                    ,per_all_people_f.per_information27    
                    ,per_all_people_f.per_information28   
                    ,per_all_people_f.per_information29   
                    ,per_all_people_f.per_information30 
					,per_all_people_f.applicant_number employee_number
                FROM  XXMX_HCM_CURRENT_PERSON_MV per_all_people_f
                --per_all_people_f@XXMX_EXTRACT per_all_people_f
                    ,hr_all_organization_units@XXMX_EXTRACT horg
                WHERE  1=1
				AND    horg.organization_id = per_all_people_f.business_group_id
                AND    horg.name = p_bg_name
                AND per_all_people_f.system_person_type = 'APL'
                ) c_per_people_leg_us
        WHERE   (
                        xxmx_per_persons_stg.person_id = c19_person_id

                );

	EXCEPTION
	   WHEN OTHERS THEN
	        DBMS_OUTPUT.PUT_LINE('Exception while loading data into XXMX_PER_APL_LEG_F_STG-'||SQLERRM);
	END;
COMMIT;

-- XXMX_PER_APL_PHONES_STG

	DELETE 
        FROM    XXMX_PER_APL_PHONES_STG
        WHERE   bg_id    = p_bg_id    ;

        COMMIT;

BEGIN
  INSERT  
        INTO    XXMX_PER_APL_PHONES_STG
                (migration_set_id
                ,migration_set_name                   
                ,migration_status
                ,bg_name
                ,bg_id
                ,date_from
                ,date_to
                ,phone_type
                ,phone_number
                ,primary_flag
                ,validity
                ,person_id
                ,legislation_code
                ,phone_id
				,meaning
				,personnumber)
        SELECT   distinct pt_i_MigrationSetID                               
                ,pt_i_MigrationSetName                               
                ,'EXTRACTED'  
                ,p_bg_name
                ,p_bg_id
				,date_from
				,NVL(PP.date_to, '31-DEC-4712')
				,phone_type
				,phone_number
				,'Y' primary_flag
				,validity
				,parent_id person_id
				,gvv_leg_code legislation_code
				,phone_id|| '_PHONE'||'_'||phone_type
				,lkp.meaning 
                ,papf.applicant_number
		FROM XXMX_HCM_CURRENT_PERSON_MV papf,
			 per_phones@XXMX_EXTRACT PP,
			 fnd_lookup_values@XXMX_EXTRACT lkp     
		WHERE PAPF.business_group_id = p_bg_id
		AND PAPF.person_id = PP.parent_id
		and lkp.lookup_type(+) = 'PHONE_TYPE'
		And lkp.lookup_code(+) = PP.phone_type
		AND papf.system_person_type ='APL';

    EXCEPTION
	   WHEN OTHERS THEN
	        DBMS_OUTPUT.PUT_LINE('Exception while loading data into XXMX_PER_APL_PHONES_STG-'||SQLERRM);
	END;

-- XXMX_PER_APL_PEOPLE_F_STG
   DELETE 
        FROM    XXMX_PER_APL_PEOPLE_F_STG
        WHERE   bg_id    = p_bg_id    ;

        COMMIT;

BEGIN
INSERT  INTO  XXMX_PER_APL_PEOPLE_F_STG
                (migration_set_id
                ,migration_set_name                   
                ,migration_status
                ,bg_name
                ,bg_id
                ,person_id
                ,effective_start_date
                ,effective_end_date
                ,start_date
                ,applicant_number
                ,personnumber
                ,waive_data_protect)
        SELECT   pt_i_MigrationSetID                               
                ,pt_i_MigrationSetName                               
                ,'EXTRACTED'  
                ,p_bg_name
                ,p_bg_id
                ,papf.person_id person_id
                ,papf.effective_start_date
                ,NVL(papf.effective_end_Date,'31-DEC-4712') effective_end_date
                ,NVL(papf.original_date_of_hire , papf.start_date)
                ,papf.applicant_number applicant_number
                ,papf.applicant_number person_number
				,'N' waive_data_protect
         FROM   XXMX_HCM_CURRENT_PERSON_MV papf -- Per_all_people_f@XXMX_EXTRACT papf
                ,xxmx_per_APL_persons_stg per
        WHERE      papf.business_group_id = p_bg_id
        and per.person_id = papf.person_id
		AND papf.system_person_type IN ('APL');

EXCEPTION
	   WHEN OTHERS THEN
	        DBMS_OUTPUT.PUT_LINE('Exception while loading data into XXMX_PER_APL_PEOPLE_F_STG-'||SQLERRM);
	END;
END insert_pendingworker_data;
---------------------------------------------------
procedure UPDATE_PENDINGWORKER_PESONNUMBERS
IS
   V_COUNT NUMBER;  

   CURSOR C1 IS 
    SELECT PERSONNUMBER FROM XXMX_PER_APL_PERSONS_STG;

   CURSOR C2 IS
      SELECT ATTRIBUTE1,PERSONNUMBER FROM XXMX_PER_APL_PERSONS_STG;

BEGIN

  SELECT MAX(TO_NUMBER(PERSONNUMBER))+1000   --Max Emp Number in XXMX_PER_PERSONS_STG
    INTO V_COUNT
    FROM XXMX_PER_PERSONS_STG;

-- XXMX_PER_APL_PERSONS_STG
  FOR per IN C1
  LOOP
     V_COUNT := V_COUNT + 1;
    BEGIN 
      UPDATE XXMX_PER_APL_PERSONS_STG
         SET ATTRIBUTE1 = per.PERSONNUMBER
           , PERSONNUMBER= V_COUNT
       WHERE PERSON_TYPE='APL'
         AND PERSONNUMBER = per.PERSONNUMBER;
	EXCEPTION
	   WHEN OTHERS THEN 
	      DBMS_OUTPUT.PUT_LINE('Exception while updating data in XXMX_PER_APL_PERSONS_STG-'||SQLERRM);
	END;
  END LOOP;
COMMIT;

-- XXMX_PER_APL_NAMES_F_STG
   FOR nam IN C2
     LOOP
	   BEGIN
         UPDATE XXMX_PER_APL_NAMES_F_STG
		    SET ATTRIBUTE1 = nam.ATTRIBUTE1
			  , PERSONNUMBER = nam.PERSONNUMBER
		  WHERE PERSONNUMBER = nam.ATTRIBUTE1;
       EXCEPTION
	   WHEN OTHERS THEN 
	      DBMS_OUTPUT.PUT_LINE('Exception while updating data in XXMX_PER_APL_NAMES_F_STG-'||SQLERRM);
	END;
  END LOOP;

-- XXMX_PER_APL_LEG_F_STG
  FOR leg IN C2
     LOOP
	   BEGIN
         UPDATE XXMX_PER_APL_LEG_F_STG
		    SET ATTRIBUTE1 = leg.ATTRIBUTE1
			  , PERSONNUMBER = leg.PERSONNUMBER
		  WHERE PERSONNUMBER = leg.ATTRIBUTE1;
       EXCEPTION
	   WHEN OTHERS THEN 
	      DBMS_OUTPUT.PUT_LINE('Exception while updating data in XXMX_PER_APL_LEG_F_STG-'||SQLERRM);
	END;
  END LOOP;

-- XXMX_PER_APL_PHONES_STG
  FOR phn IN C2
     LOOP
	   BEGIN
         UPDATE XXMX_PER_APL_PHONES_STG
		    SET ATTRIBUTE1 = phn.ATTRIBUTE1
			  , PERSONNUMBER = phn.PERSONNUMBER
		  WHERE PERSONNUMBER = phn.ATTRIBUTE1;
       EXCEPTION
	   WHEN OTHERS THEN 
	      DBMS_OUTPUT.PUT_LINE('Exception while updating data in XXMX_PER_APL_PHONES_STG-'||SQLERRM);
	END;
  END LOOP;

-- XXMX_PER_APL_PEOPLE_F_STG
  FOR ppl IN C2
     LOOP
	   BEGIN
         UPDATE XXMX_PER_APL_PEOPLE_F_STG
		    SET ATTRIBUTE1 = ppl.ATTRIBUTE1
			  , PERSONNUMBER = ppl.PERSONNUMBER
		  WHERE PERSONNUMBER = ppl.ATTRIBUTE1;
       EXCEPTION
	   WHEN OTHERS THEN 
	      DBMS_OUTPUT.PUT_LINE('Exception while updating data in XXMX_PER_APL_PEOPLE_F_STG-'||SQLERRM);
	END;
  END LOOP;
END UPDATE_PENDINGWORKER_PESONNUMBERS;

-----------------------------------------------
/* Procedure to Generate HDL HIRE file for Pending Workers */
------------------------------------------
procedure generate_pendingworker_hire_hdl
IS

    nwh_worker_header   VARCHAR2(10000) := 'METADATA|Worker|SourceSystemOwner|SourceSystemId|EffectiveStartDate|EffectiveEndDate|PersonNumber|StartDate|DateOfBirth|ActionCode';
	nwh_name_header     VARCHAR2(10000) := 'METADATA|PersonName|SourceSystemOwner|SourceSystemId|PersonId(SourceSystemId)|EffectiveStartDate|EffectiveEndDate|LegislationCode|NameType|FirstName|MiddleNames|LastName|Honors|KnownAs|PreNameAdjunct|MilitaryRank|PreviousLastName|Suffix|Title';
    nwh_leg_header   VARCHAR2(10000) := 'METADATA|PersonLegislativeData|SourceSystemOwner|SourceSystemId|PersonId(SourceSystemId)|EffectiveStartDate|EffectiveEndDate|PersonNumber|LegislationCode|HighestEducationLevel|MaritalStatus|MaritalStatusDate|Sex';
	nwh_phone_header     VARCHAR2(10000) := 'METADATA|PersonPhone|SourceSystemOwner|SourceSystemId|PersonId(SourceSystemId)|PhoneType|DateFrom|DateTo|PersonNumber|LegislationCode|AreaCode|PhoneNumber|PrimaryFlag';
    nwh_wr_header   VARCHAR2(10000) := 'METADATA|WorkRelationship|SourceSystemOwner|SourceSystemId|PersonId(SourceSystemId)|LegalEmployerName|ActionCode|DateStart|WorkerType|PrimaryFlag';
	nwh_wt_header     VARCHAR2(10000) := 'METADATA|WorkTerms|PersonId(SourceSystemId)|PeriodOfServiceId(SourceSystemId)|ActionCode|ProjectedStartDate|EffectiveStartDate|EffectiveEndDate|EffectiveSequence|EffectiveLatestChange|AssignmentType|PrimaryWorkTermsFlag|PersonTypeCode|SystemPersonType|ProposedUserPersonType|LegalEmployerName|SourceSystemOwner|SourceSystemId';                                          
    nwh_asg_header     VARCHAR2(10000) := 'METADATA|Assignment|AssignmentNumber|AssignmentName|WorkTermsNumber|SourceSystemOwner|SourceSystemId|WorkTermsAssignmentId(SourceSystemId)|PeriodOfServiceId(SourceSystemId)|PersonId(SourceSystemId)|EffectiveStartDate|EffectiveEndDate|PersonNumber|EffectiveSequence|EffectiveLatestChange|DateStart|ActionCode|ReasonCode|WorkerType|LegalEmployerName|PrimaryAssignmentFlag|AssignmentStatusTypeCode|BusinessUnitShortCode|AssignmentType|WorkerCategory|SystemPersonType|TaxReportingUnit|AssignmentCategory|DefaultExpenseAccount|ProposedUserPersonType|ProjectedStartDate';
    pv_i_file_name VARCHAR2(100) := 'Pending_Worker.dat';

BEGIN
	    DELETE FROM xxmx_hdl_file_temp WHERE FILE_NAME = pv_i_file_name;
		COMMIT;
  --Hire File
    -- Worker
	    INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          VALUES (pv_i_file_name,'File Header', nwh_worker_header);

        INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          SELECT UNIQUE pv_i_file_name
		       , 'PendingWorker_HireData'
			   , 'MERGE|Worker|EBS|Worker-'
                 ||PERSONNUMBER||'|'
                 ||TO_CHAR(START_DATE,'RRRR/MM/DD')
                 ||'|4712/12/31|'
                 ||PERSONNUMBER||'|'
                 ||TO_CHAR(START_DATE,'RRRR/MM/DD')
                 ||'|1970/01/01|ADD_PEN_WKR'
			 from xxmx_per_APL_persons_STG
            WHERE person_type ='APL'
              AND BG_NAME IS NOT NULL;

    -- Person Name
       INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          VALUES (pv_i_file_name,'File Header', nwh_name_header);

        INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          SELECT UNIQUE pv_i_file_name
		       , 'NonWorker_HireData'
               , 'MERGE|PersonName|EBS|PersonName-'
                 ||nam.PERSONNUMBER||'|Worker-'
                 ||nam.PERSONNUMBER||'|'
                 ||TO_CHAR(per.START_DATE,'RRRR/MM/DD')||'|4712/12/31|'
                 ||substr(apl_le.bu_code,1,2)
                 ||'|GLOBAL|'||nam.FIRST_NAME
                 ||'|'||nam.MIDDLE_NAMES||'|'
                 ||nam.LAST_NAME||'|||||||'
            from xxmx_per_apl_names_f_stg nam,
                 xxmx_per_apl_persons_stg per,
                 xxmx_per_apl_le_dtl apl_le
           where NAM.PERSONNUMBER = PER.PERSONNUMBER
             and apl_le.applicant_number = nam.attribute1
             and per.person_type ='APL'
             and PER.BG_NAME IS NOT NULL;


    -- Person Legislative Data
       INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          VALUES (pv_i_file_name,'File Header', nwh_leg_header);

        INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          SELECT UNIQUE pv_i_file_name
		       , 'NonWorker_HireData'
		       ,'MERGE|PersonLegislativeData|EBS|PersonLegislativeData-'
                 ||leg.PERSONNUMBER||'|Worker-'||leg.PERSONNUMBER||'|'||
                 to_char(per.start_date,'RRRR/MM/DD')
                 ||'|4712/12/31|'||leg.PERSONNUMBER
                 ||'|'||substr(apl_le.bu_code,1,2)
                 ||'||'||leg.MARITAL_STATUS
                 ||'|'||TO_CHAR(leg.MARITAL_STATUS_DATE,'RRRR/MM/DD')
                 ||'|'||leg.SEX
           from xxmx_per_apl_leg_f_stg leg,
                xxmx_per_apl_persons_stg per,
                 xxmx_per_apl_le_dtl apl_le
          WHERE leg.personnumber=per.personnumber
          AND per.person_type ='APL'
          and apl_le.applicant_number = per.attribute1
          AND PER.BG_NAME IS NOT NULL;

    -- Person Phone
       INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          VALUES (pv_i_file_name,'File Header', nwh_phone_header);

        INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          SELECT UNIQUE pv_i_file_name
		       , 'NonWorker_HireData'
		       , 'MERGE|PersonPhone|EBS|PersonPhone-'||PH.PERSONNUMBER||'-'
               ||PH.PHONE_TYPE
               ||'|Worker-'||PH.PERSONNUMBER
               ||'|'||decode(PH.PHONE_TYPE,'M','HM',PH.PHONE_TYPE)
               ||'|'||TO_CHAR(PER.START_DATE,'RRRR/MM/DD')
               ||'|4712/12/31|'||PH.PERSONNUMBER
               ||'|'||substr(apl_le.bu_code,1,2)||'|'
               ||PH.AREA_CODE||'|'||PH.PHONE_NUMBER||'|'
               ||PH.PRIMARY_FLAG
         FROM xxmx_per_apl_phones_stg PH,
              xxmx_per_apl_persons_stg per,
               xxmx_per_apl_le_dtl apl_le
       WHERE PH.PERSONNUMBER = PER.PERSONNUMBER
         AND per.person_type ='APL'
         AND PER.BG_NAME IS NOT NULL
         AND apl_le.APPLICANT_NUMBER = PER.ATTRIBUTE1;


      -- Person WorkRelationship
       INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          VALUES (pv_i_file_name,'File Header', nwh_wr_header);

        INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          select UNIQUE pv_i_file_name
		       , 'NonWorker_HireData'
               ,'MERGE|WorkRelationship|EBS|WorkRelationship-'
               ||PER.PERSONNUMBER||'|Worker-'||PER.PERSONNUMBER
               ||'|'||POS.LEGAL_EMPLOYER_NAME||'|ADD_PEN_WKR|'
               ||TO_CHAR(PER.START_DATE,'RRRR/MM/DD')||'|P|Y'
          from xxmx_per_apl_le_dtl POS,
               xxmx_per_apl_persons_stg per
        WHERE POS.APPLICANT_NUMBER = PER.ATTRIBUTE1
        AND per.person_type ='APL'
        and per.bg_name is not null;

      -- Person WorkTerms
       INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          VALUES (pv_i_file_name,'File Header', nwh_wt_header);

        INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          SELECT UNIQUE pv_i_file_name
		       , 'NonWorker_HireData'
                    ,'MERGE|WorkTerms|Worker-'
                    ||PERSONNUMBER||'|WorkRelationship-'
                    ||PERSONNUMBER||'|ADD_PEN_WKR|'||
                    TO_CHAR(ADD_MONTHS(PER.START_DATE,5),'RRRR/MM/DD')||'|'
                    ||TO_CHAR(PER.START_DATE,'RRRR/MM/DD')
                    ||'|4712/12/31|1|Y|PT|Y|Pending Worker|PWK|Employee|'
                    ||pos.legal_employer_name
                    ||'|EBS|Workterms-PT'
                    ||PER.PERSONNUMBER
            from xxmx_per_apl_le_dtl POS,
                 xxmx_per_apl_persons_stg per
            WHERE POS.APPLICANT_NUMBER = PER.ATTRIBUTE1
            AND per.person_type ='APL'
            and per.bg_name is not null;

       -- Person Work Assignments
       INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          VALUES (pv_i_file_name,'File Header', nwh_asg_header);

        INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          SELECT UNIQUE pv_i_file_name
		       , 'NonWorker_HireData'
                , 'MERGE|Assignment|P'||PER.PERSONNUMBER
                ||'|P'||PER.PERSONNUMBER||'|PT'||PER.PERSONNUMBER
                ||'|EBS|Assignment-P'||PER.PERSONNUMBER
                ||'|Workterms-PT'||PER.PERSONNUMBER||'|WorkRelationship-'
                ||PER.PERSONNUMBER||'|Worker-'||PER.PERSONNUMBER||'|'
                ||TO_CHAR(PER.START_DATE,'RRRR/MM/DD')||'|4712/12/31|'
                ||per.personnumber||'|1|Y|'
                ||TO_CHAR(PER.START_DATE,'RRRR/MM/DD')||'|ADD_PEN_WKR||P|'
                ||POS.LEGAL_EMPLOYER_NAME||'|Y|ACTIVE_PROCESS|'
                ||POS.BU_CODE||'|P||PWK||||Employee|'
                ||TO_CHAR(ADD_MONTHS(PER.START_DATE,5),'RRRR/MM/DD')
       from xxmx_per_apl_le_dtl POS,
            xxmx_per_apl_persons_stg per
      where POS.APPLICANT_NUMBER = PER.ATTRIBUTE1
      and per.person_type ='APL'
      and per.bg_name is not null;

end;
--------------------------------------
end xxmx_kit_pending_worker_stg;

/
