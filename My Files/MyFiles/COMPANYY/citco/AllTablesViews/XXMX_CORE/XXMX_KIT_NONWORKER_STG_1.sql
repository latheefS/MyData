--------------------------------------------------------
--  DDL for Package Body XXMX_KIT_NONWORKER_STG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "XXMX_CORE"."XXMX_KIT_NONWORKER_STG" AS 

    gcv_PackageName                           CONSTANT  VARCHAR2(30)                                := 'xxmx_kit_nonworker_stg';
    gct_ApplicationSuite                      CONSTANT  xxmx_module_messages.application_suite%TYPE := 'HCM';
    gct_Application                           CONSTANT  xxmx_module_messages.application%TYPE       := 'NONW';
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
    gvd_prev_tax_year_date                    DATE;

------------------------------------------------------------

------------------------------------------------------------------------------------

/* 
--After Assignment HDL, Run below Query for Termination HDL file for LEAVERs
  SELECT 'METADATA|WorkRelationship|SourceSystemOwner|SourceSystemId|PersonId(SourceSystemId)|ActionCode|TerminateWorkRelationshipFlag|ActualTerminationDate|LastWorkingDate' METADATA FROM DUAL
UNION ALL
SELECT UNIQUE 'MERGE|WorkRelationship|EBS|WorkRelationship-'||PERSON_NUMBER||'|Worker-'||PERSON_NUMBER||'|TERMINATION|Y|'||TERMINATION_DATE||'|'||TERMINATION_DATE
FROM XXMX_PER_PPM_WORKER_STG WHERE EMPLOYEE_STATUS='LEAVER';
*/
-----------------------------------------------
/* Procedure to Generate HDL HIRE file for Non Workers ( External Prefessional, Unpaid Intern, Board Member) */
------------------------------------------
procedure generate_non_worker_hire_hdl
IS

    nwh_worker_header   VARCHAR2(10000) := 'METADATA|Worker|SourceSystemOwner|SourceSystemId|EffectiveStartDate|EffectiveEndDate|PersonNumber|StartDate|DateOfBirth|ActionCode';
	nwh_name_header     VARCHAR2(10000) := 'METADATA|PersonName|SourceSystemOwner|SourceSystemId|PersonId(SourceSystemId)|EffectiveStartDate|EffectiveEndDate|LegislationCode|NameType|FirstName|MiddleNames|LastName|Honors|KnownAs|PreNameAdjunct|MilitaryRank|PreviousLastName|Suffix|Title';
    nwh_leg_header   VARCHAR2(10000) := 'METADATA|PersonLegislativeData|SourceSystemOwner|SourceSystemId|PersonId(SourceSystemId)|EffectiveStartDate|EffectiveEndDate|PersonNumber|LegislationCode|HighestEducationLevel|MaritalStatus|MaritalStatusDate|Sex';
    nwh_cs_header   VARCHAR2(10000) := 'METADATA|PersonCitizenship|SourceSystemOwner|SourceSystemId|PersonId(SourceSystemId)|DateFrom|DateTo|LegislationCode|CitizenshipStatus';
	nwh_phone_header     VARCHAR2(10000) := 'METADATA|PersonPhone|SourceSystemOwner|SourceSystemId|PersonId(SourceSystemId)|PhoneType|DateFrom|DateTo|PersonNumber|LegislationCode|AreaCode|PhoneNumber|PrimaryFlag';
    nwh_wr_header   VARCHAR2(10000) := 'METADATA|WorkRelationship|SourceSystemOwner|SourceSystemId|PersonId(SourceSystemId)|PersonNumber|DateStart|WorkerType|LegalEmployerName|ActionCode|ReasonCode|PrimaryFlag|EnterpriseSeniorityDate';
	nwh_wt_header     VARCHAR2(10000) := 'METADATA|WorkTerms|AssignmentNumber|AssignmentName|SourceSystemOwner|SourceSystemId|PeriodOfServiceId(SourceSystemId)|PersonId(SourceSystemId)|EffectiveStartDate|EffectiveEndDate|PersonNumber|EffectiveSequence|EffectiveLatestChange|DateStart|ActionCode|ReasonCode|AssignmentStatusTypeCode|BusinessUnitShortCode|TaxReportingUnit';
    nwh_asg_header     VARCHAR2(10000) := 'METADATA|Assignment|AssignmentNumber|AssignmentName|WorkTermsNumber|SourceSystemOwner|SourceSystemId|WorkTermsAssignmentId(SourceSystemId)|PeriodOfServiceId(SourceSystemId)|PersonId(SourceSystemId)|EffectiveStartDate|EffectiveEndDate|PersonNumber|EffectiveSequence|EffectiveLatestChange|DateStart|ActionCode|ReasonCode|WorkerType|LegalEmployerName|PrimaryAssignmentFlag|AssignmentStatusTypeCode|BusinessUnitShortCode|AssignmentType|WorkerCategory|SystemPersonType|PersonTypeCode|TaxReportingUnit|AssignmentCategory|DefaultExpenseAccount';
    pv_i_file_name VARCHAR2(100) := 'Non_WorkerHire.dat';

BEGIN
	    DELETE FROM xxmx_hdl_file_temp WHERE FILE_NAME = pv_i_file_name;
		COMMIT;
  --Hire File
    -- Worker
	    INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          VALUES (pv_i_file_name,'File Header', nwh_worker_header);

        INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          SELECT UNIQUE pv_i_file_name
		       , 'NonWorker_HireData'
			   , 'MERGE|Worker|EBS|Worker-'||PERSONNUMBER||'|'||TO_CHAR(START_DATE,'RRRR/MM/DD')
                ||'|4712/12/31|'||PERSONNUMBER||'|'||TO_CHAR(START_DATE,'RRRR/MM/DD')||'|1970/01/01|ADD_NON_WKR'
			 from xxmx_per_persons_xfm
            WHERE PERSONNUMBER IN(SELECT UNIQUE PERSONNUMBER from XXMX_PER_ASSIGNMENTS_M_XFM
                            WHERE USER_PERSON_TYPE IN ('External Professional','Board Member','Unpaid Intern'))
              AND personnumber not in(select unique person_number from xxmx_per_ppm_worker_stg);

    -- Person Name
       INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          VALUES (pv_i_file_name,'File Header', nwh_name_header);

        INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          SELECT UNIQUE pv_i_file_name
		       , 'NonWorker_HireData'
			   , 'MERGE|PersonName|EBS|PersonName-'||nam.PERSONNUMBER||'|Worker-'||nam.PERSONNUMBER||'|'
               ||TO_CHAR(per.START_DATE,'RRRR/MM/DD')||'|4712/12/31|'
               ||LEGISLATION_CODE||'|GLOBAL|'||nam.FIRST_NAME||'|'||nam.MIDDLE_NAMES||'|'||nam.LAST_NAME||'|||||||'
            from xxmx_per_names_f_xfm nam,xxmx_per_persons_xfm per
           WHERE NAM.PERSONNUMBER = PER.PERSONNUMBER
           AND nam.PERSONNUMBER IN(SELECT UNIQUE PERSONNUMBER from XXMX_PER_ASSIGNMENTS_M_XFM
                       WHERE USER_PERSON_TYPE IN ('External Professional','Board Member','Unpaid Intern'))
           AND NAM.personnumber not in(select unique person_number from xxmx_per_ppm_worker_stg);

    -- Person Legislative Data
       INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          VALUES (pv_i_file_name,'File Header', nwh_leg_header);

        INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          SELECT UNIQUE pv_i_file_name
		       , 'NonWorker_HireData'
		       , 'MERGE|PersonLegislativeData|EBS|PersonLegislativeData-'||leg.PERSONNUMBER||'|Worker-'||leg.PERSONNUMBER||'|'||
               to_char(per.start_date,'RRRR/MM/DD')||'|4712/12/31|'||leg.PERSONNUMBER||'|'||leg.LEGISLATION_CODE
               ||'||'||leg.MARITAL_STATUS||'|'||TO_CHAR(leg.MARITAL_STATUS_DATE,'RRRR/MM/DD')||'|'||leg.SEX
       from xxmx_per_leg_f_xfm leg,xxmx_per_persons_xfm per
      WHERE leg.personnumber=per.personnumber
        and leg.PERSONNUMBER IN(SELECT UNIQUE PERSONNUMBER from XXMX_PER_ASSIGNMENTS_M_XFM
                       WHERE USER_PERSON_TYPE IN ('External Professional','Board Member','Unpaid Intern'))
        AND LEG.personnumber not in(select unique person_number from xxmx_per_ppm_worker_stg);

    -- Person Citizenship Data
       INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          VALUES (pv_i_file_name,'File Header', nwh_cs_header);

        INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          SELECT UNIQUE pv_i_file_name
		       , 'NonWorker_HireData'
		       ,'MERGE|PersonCitizenship|EBS|PersonCitizenship-'||PERSONNUMBER||'|Worker-'||personnumber||'|'||TO_CHAR(DATE_FROM,'RRRR/MM/DD')
||'|'||TO_CHAR(DATE_TO,'RRRR/MM/DD')||'|'||LEGISLATION_CODE||'|'||CITIZENSHIP_STATUS
FROM xxmx_citizenships_xfm
        where PERSONNUMBER IN(SELECT UNIQUE PERSONNUMBER from XXMX_PER_ASSIGNMENTS_M_XFM
                       WHERE USER_PERSON_TYPE IN ('External Professional','Board Member','Unpaid Intern'))
        AND personnumber not in(select unique person_number from xxmx_per_ppm_worker_stg);
        
    -- Person Phone
       INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          VALUES (pv_i_file_name,'File Header', nwh_phone_header);

        INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          SELECT UNIQUE pv_i_file_name
		       , 'NonWorker_HireData'
		       , 'MERGE|PersonPhone|EBS|PersonPhone-'||PH.PERSONNUMBER||'-'||PH.PHONE_TYPE||'|Worker-'||PH.PERSONNUMBER||'|'||PH.PHONE_TYPE||
'|'||TO_CHAR(PER.START_DATE,'RRRR/MM/DD')||'|4712/12/31|'||PH.PERSONNUMBER||'|'||PH.LEGISLATION_CODE||'|'||PH.AREA_CODE||'|'||PH.PHONE_NUMBER||'|'||
PH.PRIMARY_FLAG
FROM XXMX_PER_PHONES_XFM PH,xxmx_per_persons_xfm per
WHERE PH.PERSONNUMBER = PER.PERSONNUMBER
AND PH.PERSONNUMBER IN(SELECT UNIQUE PERSONNUMBER from XXMX_PER_ASSIGNMENTS_M_XFM
                       WHERE USER_PERSON_TYPE IN ('External Professional','Board Member','Unpaid Intern'))
AND PH.personnumber not in(select unique person_number from xxmx_per_ppm_worker_stg);

      -- Person WorkRelationship
       INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          VALUES (pv_i_file_name,'File Header', nwh_wr_header);

        INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          SELECT UNIQUE pv_i_file_name
		       , 'NonWorker_HireData'
            ,'MERGE|WorkRelationship|EBS|WorkRelationship-'||POS.PERSON_NUMBER
            ||'|Worker-'||POS.PERSON_NUMBER||'|'||POS.PERSON_NUMBER
||'|'||TO_CHAR(PER.START_DATE,'RRRR/MM/DD')||'|N|'||POS.LEGAL_EMPLOYER||'|ADD_NON_WKR||'||'Y'||'|'
from XXMX_HCM_POSITION_LE_BU_TAB POS,xxmx_per_persons_xfm per
WHERE POS.PERSON_NUMBER = PER.PERSONNUMBER
AND POS.PERSON_NUMBER IN(SELECT UNIQUE PERSONNUMBER from XXMX_PER_ASSIGNMENTS_M_XFM
                       WHERE USER_PERSON_TYPE IN ('External Professional','Board Member','Unpaid Intern'))
AND POS.person_number not in(select unique person_number from xxmx_per_ppm_worker_stg);

      -- Person WorkTerms
       INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          VALUES (pv_i_file_name,'File Header', nwh_wt_header);

        INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          SELECT UNIQUE pv_i_file_name
		       , 'NonWorker_HireData'
            ,'MERGE|WorkTerms|NT'||ASG.PERSONNUMBER||'|NT'||ASG.PERSONNUMBER||'|EBS|Workterms-NT'||ASG.PERSONNUMBER||'|WorkRelationship-'||ASG.PERSONNUMBER
||'|'||'Worker-'||ASG.PERSONNUMBER||'|'||TO_CHAR(PER.START_DATE,'RRRR/MM/DD')||'|4712/12/31|'||ASG.PERSONNUMBER||'|1|'||ASG.EFFECTIVE_LATEST_CHANGE
||'|'||TO_CHAR(ASG.EFFECTIVE_START_DATE,'RRRR/MM/DD')||'|ADD_NON_WKR||ACTIVE_PROCESS|'||ASG.BG_NAME||'|'
from XXMX_PER_ASSIGNMENTS_M_XFM ASG,xxmx_per_persons_xfm per
WHERE ASG.PERSONNUMBER =PER.PERSONNUMBER
AND ASG.ASSIGNMENT_STATUS_TYPE='ACTIVE_PROCESS'
AND ASG.ACTION_CODE = 'ADD_CWK'
AND ASG.USER_PERSON_TYPE IN ('External Professional','Board Member','Unpaid Intern')
AND ASG.personnumber not in(select unique person_number from xxmx_per_ppm_worker_stg);

       -- Person Work Assignments
       INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          VALUES (pv_i_file_name,'File Header', nwh_asg_header);

        INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          SELECT UNIQUE pv_i_file_name
		       , 'NonWorker_HireData'
               ,'MERGE|Assignment|N'
                ||ASG.PERSONNUMBER||'|Position '
                ||SUBSTR(ASG.position_code,13)||'|NT'
                ||ASG.PERSONNUMBER||'|EBS|Assignment-N'
                ||ASG.PERSONNUMBER||'|Workterms-NT'
                ||ASG.PERSONNUMBER||'|WorkRelationship-'
                ||ASG.PERSONNUMBER||'|Worker-'
                ||ASG.PERSONNUMBER||'|'||TO_CHAR(PER.START_DATE,'RRRR/MM/DD')
                ||'|4712/12/31|'||ASG.PERSONNUMBER||'|'
                ||ASG.EFFECTIVE_SEQUENCE||'|'
                ||ASG.EFFECTIVE_LATEST_CHANGE
                ||'|'||TO_CHAR(ASG.EFFECTIVE_START_DATE,'RRRR/MM/DD')
                ||'|ADD_NON_WKR||N|'||ASG.LEGAL_EMPLOYER_NAME||'|'
                ||ASG.PRIMARY_ASSIGNMENT_FLAG||'|'||ASG.ASSIGNMENT_STATUS_TYPE
                ||'|'||ASG.BG_NAME||'|N||ORA_PER_NOT_MANAGED_BY_HR|'
                ||ASG.USER_PERSON_TYPE||'|||'
from XXMX_PER_ASSIGNMENTS_M_XFM ASG,xxmx_per_persons_xfm per
WHERE ASG.PERSONNUMBER = PER.PERSONNUMBER
AND ASG.ASSIGNMENT_STATUS_TYPE='ACTIVE_PROCESS'
AND ASG.ACTION_CODE = 'ADD_CWK'
AND ASG.USER_PERSON_TYPE IN ('External Professional','Board Member','Unpaid Intern')
AND ASG.personnumber not in(select unique person_number from xxmx_per_ppm_worker_stg);

end;
--------------------------------------
-----------------------------------------------
/* Procedure to Generate HDL Current file for Non Workers( External Prefessional, Unpaid Intern, Board Member) */
------------------------------------------
procedure generate_non_worker_current_hdl
IS

    nwc_wt_header   VARCHAR2(10000) := 'METADATA|WorkTerms|AssignmentNumber|AssignmentName|SourceSystemOwner|SourceSystemId|PeriodOfServiceId(SourceSystemId)|PersonId(SourceSystemId)|EffectiveStartDate|EffectiveEndDate|PersonNumber|EffectiveSequence|EffectiveLatestChange|DateStart|ActionCode|ReasonCode|AssignmentStatusTypeCode|AssignmentType|BusinessUnitShortCode|TaxReportingUnit|PeopleGroup|GradeLadderPgmName';
	nwc_asg_header     VARCHAR2(10000) := 'METADATA|Assignment|AssignmentNumber|AssignmentName|WorkTermsNumber|SourceSystemOwner|SourceSystemId|WorkTermsAssignmentId(SourceSystemId)|PeriodOfServiceId(SourceSystemId)|PersonId(SourceSystemId)|EffectiveStartDate|EffectiveEndDate|PersonNumber|EffectiveSequence|EffectiveLatestChange|DateStart|ActionCode|ReasonCode|WorkerType|LegalEmployerName|PrimaryAssignmentFlag|AssignmentStatusTypeCode|BusinessUnitShortCode|AssignmentType|PersonTypeCode|WorkerCategory|AssignmentCategory|FullPartTime|DateProbationEnd|NormalHours|Frequency|PermanentTemporary|JobCode|LocationCode|NoticePeriod|NoticePeriodUOM|HourlySalariedCode|PositionCode|GradeCode|BargainingUnitCode|LabourUnionMemberFlag|ManagerFlag|SystemPersonType|TaxReportingUnit|PeopleGroup|GradeLadderPgmName|ReportingEstablishment|PositionOverrideFlag|DefaultExpenseAccount|FLEX:PER_ASG_DF|headCountClassification(PER_ASG_DF=Global Data Elements)|payrollProviderId(PER_ASG_DF=Global Data Elements)|companyRecharge_Display(PER_ASG_DF=Global Data Elements)';
    pv_i_file_name VARCHAR2(100) := 'Non_WorkerCurrent.dat';

BEGIN
	    DELETE FROM xxmx_hdl_file_temp WHERE FILE_NAME = pv_i_file_name;
		COMMIT;
  --Current File
    -- WorkTerms
	    INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          VALUES (pv_i_file_name,'File Header', nwc_wt_header);

        INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          SELECT UNIQUE pv_i_file_name
		       , 'NonWorker_CurrentData'
			   , 'MERGE|WorkTerms|NT'||AX.PERSONNUMBER||'|NT'
               ||AX.PERSONNUMBER||'|EBS|Workterms-NT'
               ||AX.PERSONNUMBER||'|WorkRelationship-'
               ||AX.PERSONNUMBER||'|'||'Worker-'||AX.PERSONNUMBER||'|'
               ||TO_CHAR(AX.EFFECTIVE_START_DATE,'RRRR/MM/DD')||'|'||TO_CHAR(AX.EFFECTIVE_END_DATE,'RRRR/MM/DD')||'|'
               ||AX.PERSONNUMBER||'|'||EFFECTIVE_SEQUENCE
               ||'|'||EFFECTIVE_LATEST_CHANGE||'|'
               ||TO_CHAR(AX.EFFECTIVE_START_DATE,'RRRR/MM/DD')||
               '|ASG_CHANGE||'||ASSIGNMENT_STATUS_TYPE
               ||'|NT|'||AX.BG_NAME||'|||'
          FROM XXMX_PER_ASSIGNMENTS_M_XFM AX,xxmx_per_persons_xfm per
           WHERE ax.PERSONNUMBER = PER.PERSONNUMBER
             AND ax.ASSIGNMENT_STATUS_TYPE='ACTIVE_PROCESS'
             AND ax.ACTION_CODE = 'CURRENT'
             AND USER_PERSON_TYPE IN ('External Professional','Board Member','Unpaid Intern')
             AND AX.personnumber not in(select unique person_number from xxmx_per_ppm_worker_stg);

    -- Assignmentsa
	    INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          VALUES (pv_i_file_name,'File Header', nwc_asg_header);

        INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          SELECT UNIQUE pv_i_file_name
		       , 'NonWorker_CurrentData'
			   , 'MERGE|Assignment|N'||ax.PERSONNUMBER
               ||'|Position '||SUBSTR(position_code,13)
               ||'|NT'||ax.PERSONNUMBER||'|EBS|Assignment-N'
               ||ax.PERSONNUMBER||'|Workterms-NT'
               ||ax.PERSONNUMBER||'|WorkRelationship-'
               ||ax.PERSONNUMBER||'|Worker-'
               ||ax.PERSONNUMBER||'|'
               ||TO_CHAR(AX.EFFECTIVE_START_DATE,'RRRR/MM/DD')||'|'||TO_CHAR(AX.EFFECTIVE_END_DATE,'RRRR/MM/DD')||'|'
               ||ax.PERSONNUMBER||'|'||EFFECTIVE_SEQUENCE
               ||'|'||EFFECTIVE_LATEST_CHANGE
               ||'|'||TO_CHAR(AX.EFFECTIVE_START_DATE,'RRRR/MM/DD')
               ||'|ASG_CHANGE||N|'
               ||LEGAL_EMPLOYER_NAME||'|'||PRIMARY_ASSIGNMENT_FLAG
               ||'|'||ASSIGNMENT_STATUS_TYPE||'|'
               ||ax.BG_NAME||'|N||||||'||normal_hours||'||T||'||LOCATION_CODE
               ||'||||'||POSITION_CODE||'|||||ORA_PER_NOT_MANAGED_BY_HR|||||Y||Global Data Elements|'
               ||ASS_ATTRIBUTE2||'|'||ASS_ATTRIBUTE3||'|'||ASS_ATTRIBUTE4
               from 
               XXMX_PER_ASSIGNMENTS_M_XFM AX,xxmx_per_persons_xfm per
           WHERE ax.PERSONNUMBER = PER.PERSONNUMBER
           AND ax.ASSIGNMENT_STATUS_TYPE='ACTIVE_PROCESS'
          AND ax.ACTION_CODE = 'CURRENT'
          AND USER_PERSON_TYPE IN ('External Professional','Board Member','Unpaid Intern')
          AND AX.personnumber not in(select unique person_number from xxmx_per_ppm_worker_stg);

end;

end xxmx_kit_nonworker_stg;

/
