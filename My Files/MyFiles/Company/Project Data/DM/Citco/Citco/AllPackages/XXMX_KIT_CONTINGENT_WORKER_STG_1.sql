--------------------------------------------------------
--  DDL for Package Body XXMX_KIT_CONTINGENT_WORKER_STG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "XXMX_CORE"."XXMX_KIT_CONTINGENT_WORKER_STG" AS 

/*    gcv_PackageName                           CONSTANT  VARCHAR2(30)                                := 'xxmx_kit_ppm_worker_stg';
    gct_ApplicationSuite                      CONSTANT  xxmx_module_messages.application_suite%TYPE := 'HCM';
    gct_Application                           CONSTANT  xxmx_module_messages.application%TYPE       := 'PPM';
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
    gvv_migration_date_from                   VARCHAR2(30); 
    gvv_prev_tax_year_date                    VARCHAR2(30);         
    gvd_migration_date_to                     DATE;  
    gvd_migration_date_from                   DATE;
    gvd_prev_tax_year_date                    DATE;  */

-----------------------------------------------
/* Procedure to Generate HDL HIRE file for Contingent Workers ( Contingent Worker ) */
------------------------------------------
procedure generate_contingent_worker_hire_hdl
IS

    cwk_worker_header   VARCHAR2(10000) := 'METADATA|Worker|SourceSystemOwner|SourceSystemId|EffectiveStartDate|EffectiveEndDate|PersonNumber|StartDate|DateOfBirth|ActionCode';
	cwk_name_header     VARCHAR2(10000) := 'METADATA|PersonName|SourceSystemOwner|SourceSystemId|PersonId(SourceSystemId)|EffectiveStartDate|EffectiveEndDate|LegislationCode|NameType|FirstName|MiddleNames|LastName|Honors|KnownAs|PreNameAdjunct|MilitaryRank|PreviousLastName|Suffix|Title';
    cwk_leg_header   VARCHAR2(10000) := 'METADATA|PersonLegislativeData|SourceSystemOwner|SourceSystemId|PersonId(SourceSystemId)|EffectiveStartDate|EffectiveEndDate|PersonNumber|LegislationCode|HighestEducationLevel|MaritalStatus|MaritalStatusDate|Sex';
    cwk_cs_header   VARCHAR2(10000) := 'METADATA|PersonCitizenship|SourceSystemOwner|SourceSystemId|PersonId(SourceSystemId)|DateFrom|DateTo|LegislationCode|CitizenshipStatus';
	cwk_phone_header     VARCHAR2(10000) := 'METADATA|PersonPhone|SourceSystemOwner|SourceSystemId|PersonId(SourceSystemId)|PhoneType|DateFrom|DateTo|PersonNumber|LegislationCode|AreaCode|PhoneNumber|PrimaryFlag';
    cwk_wr_header   VARCHAR2(10000) := 'METADATA|WorkRelationship|SourceSystemOwner|SourceSystemId|PersonId(SourceSystemId)|PersonNumber|DateStart|WorkerType|LegalEmployerName|ActionCode|ReasonCode|PrimaryFlag|EnterpriseSeniorityDate';
	cwk_wt_header     VARCHAR2(10000) := 'METADATA|WorkTerms|AssignmentNumber|AssignmentName|SourceSystemOwner|SourceSystemId|PeriodOfServiceId(SourceSystemId)|PersonId(SourceSystemId)|EffectiveStartDate|EffectiveEndDate|PersonNumber|EffectiveSequence|EffectiveLatestChange|DateStart|ActionCode|ReasonCode|AssignmentStatusTypeCode|BusinessUnitShortCode|TaxReportingUnit';
    cwk_asg_header     VARCHAR2(10000) := 'METADATA|Assignment|AssignmentNumber|AssignmentName|WorkTermsNumber|SourceSystemOwner|SourceSystemId|WorkTermsAssignmentId(SourceSystemId)|PeriodOfServiceId(SourceSystemId)|PersonId(SourceSystemId)|EffectiveStartDate|EffectiveEndDate|PersonNumber|EffectiveSequence|EffectiveLatestChange|DateStart|ActionCode|ReasonCode|WorkerType|LegalEmployerName|PrimaryAssignmentFlag|AssignmentStatusTypeCode|BusinessUnitShortCode|AssignmentType|WorkerCategory|SystemPersonType|TaxReportingUnit|AssignmentCategory|DefaultExpenseAccount';
    pv_i_file_name VARCHAR2(100) := 'CWK_WorkerHire.dat';

BEGIN
	    DELETE FROM xxmx_hdl_file_temp WHERE FILE_NAME = pv_i_file_name;
		COMMIT;
  --Hire File
    -- Worker
	    INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          VALUES (pv_i_file_name,'File Header', cwk_worker_header);

        INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          SELECT UNIQUE pv_i_file_name
		       , 'CwkWorker_HireData'
			   , 'MERGE|Worker|EBS|Worker-'||PERSONNUMBER||'|'||TO_CHAR(START_DATE,'RRRR/MM/DD')
                ||'|4712/12/31|'||PERSONNUMBER||'|'||TO_CHAR(START_DATE,'RRRR/MM/DD')||'|1970/01/01|ADD_CWK'
			 from xxmx_per_persons_xfm
            WHERE PERSONNUMBER IN(SELECT UNIQUE PERSONNUMBER from XXMX_PER_ASSIGNMENTS_M_XFM
                            WHERE USER_PERSON_TYPE IN ('Contingent Worker'))
              AND personnumber not in(select unique person_number from xxmx_per_ppm_worker_stg);

    -- Person Name
       INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          VALUES (pv_i_file_name,'File Header', CWK_name_header);

        INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          SELECT UNIQUE pv_i_file_name
		       , 'CwkWorker_HireData'
			   , 'MERGE|PersonName|EBS|PersonName-'||nam.PERSONNUMBER||'|Worker-'||nam.PERSONNUMBER||'|'
               ||TO_CHAR(per.START_DATE,'RRRR/MM/DD')||'|4712/12/31|'
               ||LEGISLATION_CODE||'|GLOBAL|'||nam.FIRST_NAME||'|'||nam.MIDDLE_NAMES||'|'||nam.LAST_NAME||'|||||||'
            from xxmx_per_names_f_xfm nam,xxmx_per_persons_xfm per
           WHERE NAM.PERSONNUMBER = PER.PERSONNUMBER
           AND nam.PERSONNUMBER IN(SELECT UNIQUE PERSONNUMBER from XXMX_PER_ASSIGNMENTS_M_XFM
                       WHERE USER_PERSON_TYPE IN ('Contingent Worker'))
           AND NAM.personnumber not in(select unique person_number from xxmx_per_ppm_worker_stg);

    -- Person Legislative Data
       INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          VALUES (pv_i_file_name,'File Header', CWK_leg_header);

        INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          SELECT UNIQUE pv_i_file_name
		       , 'CwkWorker_HireData'
		       , 'MERGE|PersonLegislativeData|EBS|PersonLegislativeData-'||leg.PERSONNUMBER||'|Worker-'||leg.PERSONNUMBER||'|'||
               to_char(per.start_date,'RRRR/MM/DD')||'|4712/12/31|'||leg.PERSONNUMBER||'|'||leg.LEGISLATION_CODE
               ||'||'||leg.MARITAL_STATUS||'|'||TO_CHAR(leg.MARITAL_STATUS_DATE,'RRRR/MM/DD')||'|'||leg.SEX
       from xxmx_per_leg_f_xfm leg,xxmx_per_persons_xfm per
      WHERE leg.personnumber=per.personnumber
        and leg.PERSONNUMBER IN(SELECT UNIQUE PERSONNUMBER from XXMX_PER_ASSIGNMENTS_M_XFM
                       WHERE USER_PERSON_TYPE IN ('Contingent Worker'))
        AND LEG.personnumber not in(select unique person_number from xxmx_per_ppm_worker_stg);

-- Person Citizenship Data
       INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          VALUES (pv_i_file_name,'File Header', CWK_cs_header);

        INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          SELECT UNIQUE pv_i_file_name
		       , 'CwkWorker_HireData'
		       ,'MERGE|PersonCitizenship|EBS|PersonCitizenship-'||PERSONNUMBER||'|Worker-'||personnumber||'|'||TO_CHAR(DATE_FROM,'RRRR/MM/DD')
||'|'||TO_CHAR(DATE_TO,'RRRR/MM/DD')||'|'||LEGISLATION_CODE||'|'||CITIZENSHIP_STATUS
FROM xxmx_citizenships_xfm
        where PERSONNUMBER IN(SELECT UNIQUE PERSONNUMBER from XXMX_PER_ASSIGNMENTS_M_XFM
                       WHERE USER_PERSON_TYPE IN ('Contingent Worker'))
        AND personnumber not in(select unique person_number from xxmx_per_ppm_worker_stg);
        
    -- Person Phone
       INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          VALUES (pv_i_file_name,'File Header', CWK_phone_header);

        INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          SELECT UNIQUE pv_i_file_name
		       , 'CwkWorker_HireData'
		       , 'MERGE|PersonPhone|EBS|PersonPhone-'||PH.PERSONNUMBER||'-'||PH.PHONE_TYPE||'|Worker-'||PH.PERSONNUMBER||'|'||PH.PHONE_TYPE||
'|'||TO_CHAR(PER.START_DATE,'RRRR/MM/DD')||'|4712/12/31|'||PH.PERSONNUMBER||'|'||PH.LEGISLATION_CODE||'|'||PH.AREA_CODE||'|'||PH.PHONE_NUMBER||'|'||
PH.PRIMARY_FLAG
FROM XXMX_PER_PHONES_XFM PH,xxmx_per_persons_xfm per
WHERE PH.PERSONNUMBER = PER.PERSONNUMBER
AND PH.PERSONNUMBER IN(SELECT UNIQUE PERSONNUMBER from XXMX_PER_ASSIGNMENTS_M_XFM
                       WHERE USER_PERSON_TYPE IN ('Contingent Worker'))
AND PH.personnumber not in(select unique person_number from xxmx_per_ppm_worker_stg);

      -- Person WorkRelationship
       INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          VALUES (pv_i_file_name,'File Header', CWK_wr_header);

        INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          SELECT UNIQUE pv_i_file_name
		       , 'CwkWorker_HireData'
            ,'MERGE|WorkRelationship|EBS|WorkRelationship-'||POS.PERSON_NUMBER
            ||'|Worker-'||POS.PERSON_NUMBER||'|'||POS.PERSON_NUMBER
||'|'||TO_CHAR(PER.START_DATE,'RRRR/MM/DD')||'|Contingent worker|'||POS.LEGAL_EMPLOYER||'|ADD_CWK||'||'Y'||'|'
from XXMX_HCM_POSITION_LE_BU_TAB POS,xxmx_per_persons_xfm per
WHERE POS.PERSON_NUMBER = PER.PERSONNUMBER
AND POS.PERSON_NUMBER IN(SELECT UNIQUE PERSONNUMBER from XXMX_PER_ASSIGNMENTS_M_XFM
                       WHERE USER_PERSON_TYPE IN ('Contingent Worker'))
AND POS.person_number not in(select unique person_number from xxmx_per_ppm_worker_stg);

      -- Person WorkTerms
       INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          VALUES (pv_i_file_name,'File Header', CWK_wt_header);

        INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          SELECT UNIQUE pv_i_file_name
		       , 'CwkWorker_HireData'
            ,'MERGE|WorkTerms|CT'||ASG.PERSONNUMBER||'|CT'||ASG.PERSONNUMBER||'|EBS|Workterms-CT'||ASG.PERSONNUMBER||'|WorkRelationship-'||ASG.PERSONNUMBER
||'|'||'Worker-'||ASG.PERSONNUMBER||'|'||TO_CHAR(PER.START_DATE,'RRRR/MM/DD')||'|4712/12/31|'||ASG.PERSONNUMBER||'|1|'||ASG.EFFECTIVE_LATEST_CHANGE
||'|'||TO_CHAR(ASG.EFFECTIVE_START_DATE,'RRRR/MM/DD')||'|ADD_CWK||ACTIVE_PROCESS|'||ASG.BG_NAME||'|'
from XXMX_PER_ASSIGNMENTS_M_XFM ASG,xxmx_per_persons_xfm per
WHERE ASG.PERSONNUMBER =PER.PERSONNUMBER
AND ASG.ASSIGNMENT_STATUS_TYPE='ACTIVE_PROCESS'
AND ASG.ACTION_CODE = 'ADD_CWK'
AND ASG.USER_PERSON_TYPE IN ('Contingent Worker')
AND ASG.personnumber not in(select unique person_number from xxmx_per_ppm_worker_stg);

       -- Person Work Assignments
       INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          VALUES (pv_i_file_name,'File Header', CWK_asg_header);

        INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          SELECT UNIQUE pv_i_file_name
		       , 'CwkWorker_HireData'
            ,'MERGE|Assignment|C'||ASG.PERSONNUMBER||'|Position '||SUBSTR(ASG.position_code,13)||'|CT'||ASG.PERSONNUMBER||'|EBS|Assignment-C'||ASG.PERSONNUMBER||'|Workterms-CT'||
ASG.PERSONNUMBER||'|WorkRelationship-'||ASG.PERSONNUMBER||'|Worker-'||ASG.PERSONNUMBER||'|'||TO_CHAR(PER.START_DATE,'RRRR/MM/DD')||
'|4712/12/31|'||ASG.PERSONNUMBER||'|'||ASG.EFFECTIVE_SEQUENCE||'|'||ASG.EFFECTIVE_LATEST_CHANGE||'|'||TO_CHAR(ASG.EFFECTIVE_START_DATE,'RRRR/MM/DD')
||'|ADD_CWK||C|'||ASG.LEGAL_EMPLOYER_NAME||'|'||ASG.PRIMARY_ASSIGNMENT_FLAG||'|'||ASG.ASSIGNMENT_STATUS_TYPE||'|'||
ASG.BG_NAME||'|C||CWK|||'
from XXMX_PER_ASSIGNMENTS_M_XFM ASG,xxmx_per_persons_xfm per
WHERE ASG.PERSONNUMBER = PER.PERSONNUMBER
AND ASG.ASSIGNMENT_STATUS_TYPE='ACTIVE_PROCESS'
AND ASG.ACTION_CODE = 'ADD_CWK'
AND ASG.USER_PERSON_TYPE IN ('Contingent Worker')
AND ASG.personnumber not in(select unique person_number from xxmx_per_ppm_worker_stg);

end;
--------------------------------------
-----------------------------------------------
/* Procedure to Generate HDL Current file for Contingent Workers( Contingent Worker) */
------------------------------------------
procedure generate_contingent_worker_current_hdl
IS

    cwk_wt_header   VARCHAR2(10000) := 'METADATA|WorkTerms|AssignmentNumber|AssignmentName|SourceSystemOwner|SourceSystemId|PeriodOfServiceId(SourceSystemId)|PersonId(SourceSystemId)|EffectiveStartDate|EffectiveEndDate|PersonNumber|EffectiveSequence|EffectiveLatestChange|DateStart|ActionCode|ReasonCode|AssignmentStatusTypeCode|AssignmentType|BusinessUnitShortCode|TaxReportingUnit|PeopleGroup|GradeLadderPgmName';
	cwk_asg_header     VARCHAR2(10000) := 'METADATA|Assignment|AssignmentNumber|AssignmentName|WorkTermsNumber|SourceSystemOwner|SourceSystemId|WorkTermsAssignmentId(SourceSystemId)|PeriodOfServiceId(SourceSystemId)|PersonId(SourceSystemId)|EffectiveStartDate|EffectiveEndDate|PersonNumber|EffectiveSequence|EffectiveLatestChange|DateStart|ActionCode|ReasonCode|WorkerType|LegalEmployerName|PrimaryAssignmentFlag|AssignmentStatusTypeCode|BusinessUnitShortCode|AssignmentType|PersonTypeCode|WorkerCategory|AssignmentCategory|FullPartTime|DateProbationEnd|NormalHours|Frequency|PermanentTemporary|JobCode|LocationCode|NoticePeriod|NoticePeriodUOM|HourlySalariedCode|PositionCode|GradeCode|BargainingUnitCode|LabourUnionMemberFlag|ManagerFlag|SystemPersonType|TaxReportingUnit|PeopleGroup|GradeLadderPgmName|ReportingEstablishment|PositionOverrideFlag|DefaultExpenseAccount|FLEX:PER_ASG_DF|headCountClassification(PER_ASG_DF=Global Data Elements)|payrollProviderId(PER_ASG_DF=Global Data Elements)|companyRecharge_Display(PER_ASG_DF=Global Data Elements)';
    pv_i_file_name VARCHAR2(100) := 'CWK_WorkerCurrent.dat';

BEGIN
	    DELETE FROM xxmx_hdl_file_temp WHERE FILE_NAME = pv_i_file_name;
		COMMIT;
  --Current File
    -- WorkTerms
	    INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          VALUES (pv_i_file_name,'File Header', cwk_wt_header);

        INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          SELECT UNIQUE pv_i_file_name
		       , 'CwkWorker_CurrentData'
			   , 'MERGE|WorkTerms|CT'||AX.PERSONNUMBER||'|CT'
               ||AX.PERSONNUMBER||'|EBS|Workterms-CT'
               ||AX.PERSONNUMBER||'|WorkRelationship-'
               ||AX.PERSONNUMBER||'|'||'Worker-'||AX.PERSONNUMBER||'|'
               ||TO_CHAR(AX.EFFECTIVE_START_DATE,'RRRR/MM/DD')||'|'||TO_CHAR(AX.EFFECTIVE_END_DATE,'RRRR/MM/DD')||'|'
               ||AX.PERSONNUMBER||'|'||EFFECTIVE_SEQUENCE
               ||'|'||EFFECTIVE_LATEST_CHANGE||'|'
               ||TO_CHAR(AX.EFFECTIVE_START_DATE,'RRRR/MM/DD')||
               '|ASG_CHANGE||'||ASSIGNMENT_STATUS_TYPE
               ||'|CT|'||AX.BG_NAME||'|||'
          FROM XXMX_PER_ASSIGNMENTS_M_XFM AX,xxmx_per_persons_xfm per
           WHERE ax.PERSONNUMBER = PER.PERSONNUMBER
             AND ax.ASSIGNMENT_STATUS_TYPE='ACTIVE_PROCESS'
             AND ax.ACTION_CODE = 'CURRENT'
             AND USER_PERSON_TYPE IN ('Contingent Worker')
             AND AX.personnumber not in(select unique person_number from xxmx_per_ppm_worker_stg);

    -- Assignments
	    INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          VALUES (pv_i_file_name,'File Header', CWK_asg_header);

        INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          SELECT UNIQUE pv_i_file_name
		       , 'CwkWorker_CurrentData'
               , 'MERGE|Assignment|C'||ax.PERSONNUMBER
               ||'|Position '||SUBSTR(position_code,13)
               ||'|CT'||ax.PERSONNUMBER||'|EBS|Assignment-C'
               ||ax.PERSONNUMBER||'|Workterms-CT'
               ||ax.PERSONNUMBER||'|WorkRelationship-'
               ||ax.PERSONNUMBER||'|Worker-'
               ||ax.PERSONNUMBER||'|'
               ||TO_CHAR(AX.EFFECTIVE_START_DATE,'RRRR/MM/DD')||'|'||TO_CHAR(AX.EFFECTIVE_END_DATE,'RRRR/MM/DD')||'|'||ax.PERSONNUMBER||'|'||EFFECTIVE_SEQUENCE
               ||'|'||EFFECTIVE_LATEST_CHANGE||'|'
               ||TO_CHAR(AX.EFFECTIVE_START_DATE,'RRRR/MM/DD')||'|ASG_CHANGE||C|'
               ||LEGAL_EMPLOYER_NAME||'|'||PRIMARY_ASSIGNMENT_FLAG
               ||'|'||ASSIGNMENT_STATUS_TYPE||'|'
               ||ax.BG_NAME||'|C||||||'||
               ax.normal_hours ||
               '||T||'||LOCATION_CODE
               ||'||||'||POSITION_CODE||'|||||CWK|||||Y||Global Data Elements|'
               ||AX.ASS_ATTRIBUTE2||'|'||AX.ASS_ATTRIBUTE3||'|'||AX.ASS_ATTRIBUTE4
               from XXMX_PER_ASSIGNMENTS_M_XFM AX,xxmx_per_persons_xfm per
           WHERE ax.PERSONNUMBER = PER.PERSONNUMBER
           AND ax.ASSIGNMENT_STATUS_TYPE='ACTIVE_PROCESS'
          AND ax.ACTION_CODE = 'CURRENT'
          AND USER_PERSON_TYPE IN ('Contingent Worker')
          AND AX.personnumber not in(select unique person_number from xxmx_per_ppm_worker_stg);

end;

end xxmx_kit_contingent_worker_stg;

/
