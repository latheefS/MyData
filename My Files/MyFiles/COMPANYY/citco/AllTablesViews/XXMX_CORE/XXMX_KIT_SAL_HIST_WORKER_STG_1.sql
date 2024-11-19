--------------------------------------------------------
--  DDL for Package Body XXMX_KIT_SAL_HIST_WORKER_STG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "XXMX_CORE"."XXMX_KIT_SAL_HIST_WORKER_STG" AS 

    gcv_PackageName                           CONSTANT  VARCHAR2(100)                                := 'xxmx_kit_salary_hist_worker_stg';
    gct_ApplicationSuite                      CONSTANT  xxmx_module_messages.application_suite%TYPE := 'HCM';
    gct_Application                           CONSTANT  xxmx_module_messages.application%TYPE       := 'SAL';
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
PROCEDURE update_salary_assignment_hist
  IS
		cv_ProcOrFuncName                   CONSTANT    VARCHAR2(100) := 'UPDATE_SALARY_ASSIGNMENT_HIST'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'UPDATE';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_KIT_SALARY_HIST_WORKER_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'HCM';

        e_DateError                         EXCEPTION;

	BEGIN
dbms_output.put_line('start');
		 --
        gvv_ReturnStatus  := '';
        gvt_ReturnMessage := '';
        gvv_ProgressIndicator := '0000';
        xxmx_utilities_pkg.clear_messages
            (
            pt_i_ApplicationSuite     => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_Phase               => ct_Phase
            ,pt_i_MessageType         => 'MODULE'
            ,pv_o_ReturnStatus        => gvv_ReturnStatus
            );
        --
		IF   gvv_ReturnStatus = 'F'
        THEN
            /*xxmx_utilities_pkg.log_module_message(  
                 pt_i_ApplicationSuite    => gct_ApplicationSuite
                ,pt_i_Application         => gct_Application
                ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                ,pt_i_Phase               => ct_Phase
                ,pt_i_Severity            => 'ERROR'
                ,pt_i_PackageName         => gcv_PackageName
                ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                ,pt_i_ModuleMessage       => 'Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'    
                ,pt_i_OracleError         => gvt_ReturnMessage    );  */
            --
            RAISE e_ModuleError;
        END IF;
        --
        gvv_ReturnStatus  := '';
        gvt_ReturnMessage := '';
        gvv_ProgressIndicator := '0005';
        xxmx_utilities_pkg.clear_messages
            (pt_i_ApplicationSuite     => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_Phase               => ct_Phase
            ,pt_i_MessageType         => 'DATA'
            ,pv_o_ReturnStatus        => gvv_ReturnStatus
            );
        IF   gvv_ReturnStatus = 'F'
        THEN
            /*xxmx_utilities_pkg.log_module_message
                (pt_i_ApplicationSuite    => gct_ApplicationSuite
                ,pt_i_Application         => gct_Application
                ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                ,pt_i_Phase               => ct_Phase
                ,pt_i_Severity            => 'ERROR'
                ,pt_i_PackageName         => gcv_PackageName
                ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                ,pt_i_ModuleMessage       => 'Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'    
                ,pt_i_OracleError         => gvt_ReturnMessage
                );  */
            --
            RAISE e_ModuleError;
        END IF;
        --
        --        
        gvv_ProgressIndicator := '0010';
        /*xxmx_utilities_pkg.log_module_message(  
                 pt_i_ApplicationSuite    => gct_ApplicationSuite
                ,pt_i_Application         => gct_Application
                ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                ,pt_i_Phase               => ct_Phase
                ,pt_i_Severity            => 'NOTIFICATION'
                ,pt_i_PackageName         => gcv_PackageName
                ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                ,pt_i_ModuleMessage       => 'Deleting from "' || cv_StagingTable   || '".'
                ,pt_i_OracleError         => gvt_ReturnMessage  ); */
        --   
		UPDATE XXMX_PER_SAL_HIST_WORKER_STG stg
           SET BG_NAME = SUBSTR(POSITION_CODE,1,6)
             , LEGISLATION_CODE = SUBSTR(POSITION_CODE,1,2);
        COMMIT;

        /*UPDATE XXMX_PER_SAL_HIST_WORKER_STG stg
          set stg.location_code = (select unique LOCATION_CODE 
                                     FROM XX_POSITION_MAP_TEMP 
                                    where gen1 = stg.person_number); */
	    COMMIT;

    FOR J IN(SELECT STG.PERSON_NUMBER
                  , TO_CHAR(PAPF.ORIGINAL_DATE_OF_HIRE,'RRRR/MM/DD') ORIGINAL_DATE_OF_HIRE
                  , TO_CHAR(PAPF.EFFECTIVE_START_DATE,'RRRR/MM/DD') PERSON_START_DATE
                  , PAPF.FIRST_NAME,PAPF.LAST_NAME
                  , PAPF.SEX,PAPF.MARITAL_STATUS
                  , (SELECT max(TO_CHAR(ACTUAL_TERMINATION_DATE,'RRRR/MM/DD')) ACTUAL_TERMINATION_DATE
                       FROM PER_PERIODS_OF_SERVICE@XXMX_EXTRACT 
                      WHERE PERSON_ID = PAPF.PERSON_ID) TERMINATION_DATE
               FROM PER_ALL_PEOPLE_F@XXMX_EXTRACT PAPF
                  , XXMX_PER_SAL_HIST_WORKER_STG STG
              WHERE PAPF.EMPLOYEE_NUMBER = STG.PERSON_NUMBER
                AND person_number not in (select unique person_number 
                                            from XXMX_PER_PPM_WORKER_STG)  
                AND SYSDATE BETWEEN PAPF.EFFECTIVE_START_DATE AND PAPF.EFFECTIVE_END_DATE
             )
    LOOP 
              UPDATE XXMX_PER_SAL_HIST_WORKER_STG STG
                 SET ORIGINAL_DATE_OF_HIRE = J.ORIGINAL_DATE_OF_HIRE
                   , PERSON_START_DATE = J.PERSON_START_DATE
                   , FIRST_NAME = J.FIRST_NAME
                   , LAST_NAME = J.LAST_NAME
                   , GENDER  = J.SEX
                   , MARITAL_STATUS = J.MARITAL_STATUS
               WHERE STG.PERSON_NUMBER = J.PERSON_NUMBER;
    END LOOP;
COMMIT;

   FOR K IN (SELECT PERSONNUMBER,DEFAULT_EXPENSE_ACCOUNT,NORMAL_HOURS,EFFECTIVE_START_DATE,ASS_ATTRIBUTE2,ASS_ATTRIBUTE3,ASS_ATTRIBUTE4
               FROM XXMX_PER_ASSIGNMENTS_M_XFM
              WHERE ACTION_CODE = 'CURRENT'
                AND PERSONNUMBER IN(SELECT UNIQUE PERSON_NUMBER FROM XXMX_PER_SAL_HIST_WORKER_STG))
     LOOP
        UPDATE XXMX_PER_SAL_HIST_WORKER_STG ST
           SET DEFAULT_EXPENSE_ACCOUNT = K.DEFAULT_EXPENSE_ACCOUNT
             , NORMAL_HOURS = K.NORMAL_HOURS
             , ASS_ATTRIBUTE2 = K.ASS_ATTRIBUTE2
             , ASS_ATTRIBUTE3 = K.ASS_ATTRIBUTE3
             , ASS_ATTRIBUTE4 = K.ASS_ATTRIBUTE4
         WHERE PERSON_NUMBER = K.PERSONNUMBER
           AND TO_DATE(EFFECTIVE_START_DATE,'MM/DD/RRRR') = K.EFFECTIVE_START_DATE;
     END LOOP;
 COMMIT;
dbms_output.put_line('end of updating LE');

		 gvv_ProgressIndicator := '0030';
        /*xxmx_utilities_pkg.log_module_message(  
                        pt_i_ApplicationSuite    => gct_ApplicationSuite
                        ,pt_i_Application         => gct_Application
                        ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                        ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                        ,pt_i_Phase               => ct_Phase
                        ,pt_i_Severity            => 'NOTIFICATION'
                        ,pt_i_PackageName         => gcv_PackageName
                        ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                        ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                        ,pt_i_ModuleMessage       => 'End of Updation at ' || to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS.FF2') || '. Procedure completed'
                        ,pt_i_OracleError         => gvt_ReturnMessage       );     */

    EXCEPTION
        WHEN e_ModuleError THEN
                --
        /*xxmx_utilities_pkg.log_module_message(  
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                    ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_Severity            => 'ERROR'
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => gvt_ModuleMessage  
                    ,pt_i_OracleError         => gvt_ReturnMessage       );     */
            --
            RAISE;
            --** END e_ModuleError Exception
            --
        WHEN e_DateError THEN
                --
        /*xxmx_utilities_pkg.log_module_message(  
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                    ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_Severity            => 'ERROR'
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => 'Error while updating PPM Details'  
                    ,pt_i_OracleError         => gvt_ReturnMessage       );     */
            --
            RAISE;          

        WHEN OTHERS THEN
            --
            ROLLBACK;
            --
            gvt_OracleError := SUBSTR(
                                        SQLERRM
                                    ||'** ERROR_BACKTRACE: '
                                    ||dbms_utility.format_error_backtrace
                                    ,1
                                    ,4000
                                    );
            --
            /*xxmx_utilities_pkg.log_module_message(  
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                    ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_Severity            => 'ERROR'
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => 'Oracle error encounted at after Progress Indicator.'  
                    ,pt_i_OracleError         => gvt_OracleError       );     */
            --
            RAISE;
            -- Hr_Utility.raise_error@XXMX_EXTRACT;
 END update_salary_assignment_hist;
-------------------------------------------------------------------
procedure generate_worker_hire_hdl
IS

    nwh_worker_header   VARCHAR2(10000) := 'METADATA|Worker|SourceSystemOwner|SourceSystemId|EffectiveStartDate|EffectiveEndDate|PersonNumber|StartDate|DateOfBirth|ActionCode|ReasonCode';
	nwh_name_header     VARCHAR2(10000) := 'METADATA|PersonName|SourceSystemOwner|SourceSystemId|PersonId(SourceSystemId)|EffectiveStartDate|EffectiveEndDate|LegislationCode|NameType|FirstName|MiddleNames|LastName|Honors|KnownAs|PreNameAdjunct|MilitaryRank|PreviousLastName|Suffix|Title';
    nwh_leg_header   VARCHAR2(10000) := 'METADATA|PersonLegislativeData|SourceSystemOwner|SourceSystemId|PersonId(SourceSystemId)|EffectiveStartDate|EffectiveEndDate|PersonNumber|LegislationCode|HighestEducationLevel|MaritalStatus|MaritalStatusDate|Sex';
    nwh_cs_header   VARCHAR2(10000) := 'METADATA|PersonCitizenship|SourceSystemOwner|SourceSystemId|PersonId(SourceSystemId)|DateFrom|DateTo|LegislationCode|CitizenshipStatus';
	nwh_phone_header     VARCHAR2(10000) := 'METADATA|PersonPhone|SourceSystemOwner|SourceSystemId|PersonId(SourceSystemId)|PhoneType|DateFrom|DateTo|PersonNumber|LegislationCode|AreaCode|PhoneNumber|PrimaryFlag';
    nwh_wr_header   VARCHAR2(10000) := 'METADATA|WorkRelationship|SourceSystemOwner|SourceSystemId|PersonId(SourceSystemId)|PersonNumber|DateStart|WorkerType|LegalEmployerName|ActionCode|ReasonCode|PrimaryFlag|EnterpriseSeniorityDate';
	nwh_wt_header     VARCHAR2(10000) := 'METADATA|WorkTerms|AssignmentNumber|AssignmentName|SourceSystemOwner|SourceSystemId|PeriodOfServiceId(SourceSystemId)|PersonId(SourceSystemId)|EffectiveStartDate|EffectiveEndDate|PersonNumber|EffectiveSequence|EffectiveLatestChange|DateStart|ActionCode|ReasonCode|AssignmentStatusTypeCode|BusinessUnitShortCode|TaxReportingUnit';
    nwh_asg_header     VARCHAR2(10000) := 'METADATA|Assignment|AssignmentNumber|AssignmentName|WorkTermsNumber|SourceSystemOwner|SourceSystemId|WorkTermsAssignmentId(SourceSystemId)|PeriodOfServiceId(SourceSystemId)|PersonId(SourceSystemId)|EffectiveStartDate|EffectiveEndDate|PersonNumber|EffectiveSequence|EffectiveLatestChange|DateStart|ActionCode|ReasonCode|WorkerType|LegalEmployerName|PrimaryAssignmentFlag|AssignmentStatusTypeCode|BusinessUnitShortCode|AssignmentType|WorkerCategory|SystemPersonType|PersonTypeCode|TaxReportingUnit|AssignmentCategory|DefaultExpenseAccount';
    pv_i_file_name VARCHAR2(100) := 'SalaryHist_WorkerHire.dat';

BEGIN
	    DELETE FROM xxmx_hdl_file_temp 
        WHERE FILE_NAME = pv_i_file_name;
		COMMIT;
  --Hire File
    -- Worker
	    INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          VALUES (pv_i_file_name,'File Header', nwh_worker_header);

        INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
         SELECT UNIQUE pv_i_file_name
		       , 'SalWorker_HireData'
			   , 'MERGE|Worker|EBS|Worker-'||PERSON_NUMBER
               ||'|'||ORIGINAL_DATE_OF_HIRE||'|4712/12/31|'
               ||PERSON_NUMBER||'|'||ORIGINAL_DATE_OF_HIRE
			      ||'|1970/01/01|HIRE|'
			from XXMX_PER_SAL_HIST_WORKER_STG where record_type='HIRE'
            and person_number not in (select unique person_number 
            from XXMX_PER_PPM_WORKER_STG);

    -- Person Name
       INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          VALUES (pv_i_file_name,'File Header', nwh_name_header);

        INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          SELECT UNIQUE pv_i_file_name
		       , 'SalWorker_HireData'
			   , 'MERGE|PersonName|EBS|PersonName-'
                ||PERSON_NUMBER
                ||'|Worker-'||PERSON_NUMBER||'|'
                ||ORIGINAL_DATE_OF_HIRE||'|4712/12/31|'
			    ||LEGISLATION_CODE||'|GLOBAL|'
               ||FIRST_NAME||'||'||LAST_NAME
               ||'|||||||'
			from XXMX_PER_SAL_HIST_WORKER_STG
            where record_type='HIRE'
            and person_number not in (select unique person_number 
            from XXMX_PER_PPM_WORKER_STG);

    -- Person Legislative Data
       INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          VALUES (pv_i_file_name,'File Header', nwh_leg_header);

        INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
           SELECT UNIQUE pv_i_file_name
		       , 'SalWorker_HireData'
			   , 'MERGE|PersonLegislativeData|EBS|PersonLegislativeData-'
               ||PERSON_NUMBER||'|Worker-'||PERSON_NUMBER||'|'
               ||ORIGINAL_DATE_OF_HIRE||'|4712/12/31'
			   ||'|'||PERSON_NUMBER||'|'
               ||LEGISLATION_CODE||'||'||MARITAL_STATUS||'||'
               ||GENDER
			from XXMX_PER_SAL_HIST_WORKER_STG
            where record_type='HIRE'
            and person_number not in (select unique person_number 
            from XXMX_PER_PPM_WORKER_STG);

    -- Person Citizenship Data
       INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          VALUES (pv_i_file_name,'File Header', nwh_cs_header);

        INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
           SELECT UNIQUE pv_i_file_name
		       , 'SalWorker_HireData'
			   ,'MERGE|PersonCitizenship|EBS|PersonCitizenship-'||PERSONNUMBER||'|Worker-'||personnumber||'|'||TO_CHAR(DATE_FROM,'RRRR/MM/DD')
||'|'||TO_CHAR(DATE_TO,'RRRR/MM/DD')||'|'||LEGISLATION_CODE||'|'||CITIZENSHIP_STATUS
FROM xxmx_citizenshipS_xfm
  where personnumber in(select unique person_number
			from XXMX_PER_SAL_HIST_WORKER_STG
            where record_type='HIRE'
            and person_number not in (select unique person_number 
            from XXMX_PER_PPM_WORKER_STG));

    -- Person Phone
       INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          VALUES (pv_i_file_name,'File Header', nwh_phone_header);

        INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          SELECT UNIQUE pv_i_file_name
		       , 'SalWorker_HireData'
		       , 'MERGE|PersonPhone|EBS|PersonPhone-'
               ||PH.PERSONNUMBER||'-'||PH.PHONE_TYPE
               ||'|Worker-'||PH.PERSONNUMBER
               ||'|'||PH.PHONE_TYPE||'|'
               ||TO_CHAR(PER.START_DATE,'RRRR/MM/DD')
               ||'|4712/12/31|'||PH.PERSONNUMBER||'|'
               ||PH.LEGISLATION_CODE||'|'
               ||PH.AREA_CODE||'|'
               ||PH.PHONE_NUMBER||'|'
               ||PH.PRIMARY_FLAG
        FROM XXMX_PER_PHONES_XFM PH,xxmx_per_persons_xfm per
        WHERE PH.PERSONNUMBER = PER.PERSONNUMBER
          AND PH.PERSONNUMBER IN(SELECT UNIQUE PERSON_NUMBER 
                          from XXMX_PER_SAL_HIST_WORKER_STG
                             where record_type='HIRE'
                             and person_number not in (select unique person_number 
                             from XXMX_PER_PPM_WORKER_STG)); 

      -- Person WorkRelationship
       INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          VALUES (pv_i_file_name,'File Header', nwh_wr_header);

        INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
           SELECT UNIQUE pv_i_file_name
		       , 'SalWorker_HireData'
			   , 'MERGE|WorkRelationship|EBS|WorkRelationship-'
               ||PERSON_NUMBER||'|Worker-'
               ||PERSON_NUMBER||'|'
               ||PERSON_NUMBER||'|'
               ||ORIGINAL_DATE_OF_HIRE||'|Employee|'
               ||LEGAL_EMPLOYER_NAME||'|HIRE||Y|'
               ||ORIGINAL_DATE_OF_HIRE
          from XXMX_PER_SAL_HIST_WORKER_STG
         where record_type='HIRE'
         and person_number not in (select unique person_number 
            from XXMX_PER_PPM_WORKER_STG);			

      -- Person WorkTerms
       INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          VALUES (pv_i_file_name,'File Header', nwh_wt_header);

        INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          SELECT UNIQUE pv_i_file_name
		       , 'SalWorker_HireData'
           , 'MERGE|WorkTerms|ET'||PERSON_NUMBER
               ||'|ET'||PERSON_NUMBER||'|EBS|Workterms-ET'
               ||PERSON_NUMBER||
			   '|WorkRelationship-'||PERSON_NUMBER||'|Worker-'
               ||PERSON_NUMBER||'|'||ORIGINAL_DATE_OF_HIRE||'|4712/12/31|'
			   ||PERSON_NUMBER||'|1|Y|'||ORIGINAL_DATE_OF_HIRE
               ||'|HIRE||ACTIVE_PROCESS|'||bg_name||'|'
         from XXMX_PER_SAL_HIST_WORKER_STG 
         where record_type='HIRE'
         and person_number not in (select unique person_number 
            from XXMX_PER_PPM_WORKER_STG);

       -- Person Work Assignments
       INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          VALUES (pv_i_file_name,'File Header', nwh_asg_header);

        INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          SELECT UNIQUE pv_i_file_name
		       , 'SalWorker_HireData'
               , 'MERGE|Assignment|E'
               ||PERSON_NUMBER||'|E'||PERSON_NUMBER
               ||'|ET'||PERSON_NUMBER
               ||'|EBS|Assignment-E'||PERSON_NUMBER
               ||'|Workterms-ET'||PERSON_NUMBER
               ||'|WorkRelationship-'||PERSON_NUMBER
               ||'|Worker-'||PERSON_NUMBER
               ||'|'||ORIGINAL_DATE_OF_HIRE||'|4712/12/31|'
               ||PERSON_NUMBER||'|1|Y|'
               ||ORIGINAL_DATE_OF_HIRE||'|HIRE||E|'
               ||LEGAL_EMPLOYER_NAME||'|Y|ACTIVE_PROCESS|'
			   ||bg_name||'|E||EMP||||'
          from XXMX_PER_SAL_HIST_WORKER_STG
         where record_type='HIRE' 
         and person_number not in (select unique person_number 
            from XXMX_PER_PPM_WORKER_STG);
commit;

end generate_worker_hire_hdl;
-------------------------------------------------------
procedure generate_worker_gltransfer_hdl
IS

    nwh_wr_header   VARCHAR2(10000) :=
   	'METADATA|WorkRelationship|PersonNumber|DateStart|PrimaryFlag|LegalEmployerName|WorkerType|GlobalTransferFlag|ActionCode|SourceSystemOwner|SourceSystemId';
    nwh_wt_header     VARCHAR2(10000) := 
    'METADATA|WorkTerms|AssignmentNumber|PersonNumber|LegalEmployerName|DateStart|EffectiveStartDate|EffectiveSequence|EffectiveLatestChange|ActionCode|PersonTypeCode|JobCode|WorkerType|BusinessUnitShortCode|SystemPersonType|AssignmentName|AssignmentType|AssignmentStatusTypeCode|SourceSystemOwner|SourceSystemId|PeriodOfServiceId(SourceSystemId)';
    nwh_asg_header     VARCHAR2(10000) := 
    'METADATA|Assignment|AssignmentNumber|WorkTermsNumber|PersonNumber|LegalEmployerName|DateStart|EffectiveStartDate|EffectiveSequence|EffectiveLatestChange|ActionCode|PersonTypeCode|JobCode|BusinessUnitShortCode|WorkerType|SystemPersonType|AssignmentName|AssignmentType|AssignmentStatusTypeCode|PrimaryAssignmentFlag|SourceSystemOwner|SourceSystemId|PeriodOfServiceId(SourceSystemId)';
    pv_i_file_name VARCHAR2(100) := 'SalaryHist_GLBTrsferWorkerHire.dat';

BEGIN
	    DELETE FROM xxmx_hdl_file_temp 
        WHERE FILE_NAME = pv_i_file_name;
		COMMIT;
  --Hire File
      -- Person WorkRelationship
       INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          VALUES (pv_i_file_name,'File Header', nwh_wr_header);

        INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
           SELECT UNIQUE pv_i_file_name
		       , 'SalWorker_HireData'
			   , 'MERGE|WorkRelationship|'||PERSON_NUMBER||'|'
               ||TO_CHAR(TO_DATE(EFFECTIVE_START_DATE,'DD/MM/RRRR'),'RRRR/MM/DD')||'|'||'Y|'
               ||LEGAL_EMPLOYER_NAME
               ||'|E|Y|GLB_TRANSFER|EBS|WorkRelationship-'||ASSIGNMENT_NUMBER
            From XXMX_PER_SAL_HIST_WORKER_STG stg
         where record_type='GLB_TRANSFER3'  --IN('GLB_TRANSFER','GLB_TRANSFER2','GLB_TRANSFER3','GLB_TRANSFER4')
         and TO_DATE(STG.effective_start_date,'DD/MM/RRRR') in (select min(TO_DATE(effective_start_date,'DD/MM/RRRR')) from 
         XXMX_PER_SAL_HIST_WORKER_STG g where record_type='GLB_TRANSFER3' 
         AND stg.person_number=g.person_number)
         and person_number not in (select unique person_number 
            from XXMX_PER_PPM_WORKER_STG);

      -- Person WorkTerms
       INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          VALUES (pv_i_file_name,'File Header', nwh_wt_header);

        INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          SELECT UNIQUE pv_i_file_name
		       , 'SalWorker_HireData'
               , 'MERGE|WorkTerms|ET'||ASSIGNMENT_NUMBER||'|'
                   ||PERSON_NUMBER||'|'
                   ||LEGAL_EMPLOYER_NAME||'|'
                   ||TO_CHAR(TO_DATE(EFFECTIVE_START_DATE,'DD/MM/RRRR'),'RRRR/MM/DD')||'|'
                   ||TO_CHAR(TO_DATE(EFFECTIVE_START_DATE,'DD/MM/RRRR'),'RRRR/MM/DD')||
                   '|1|Y|GLB_TRANSFER|Employee||E|'
                   ||bg_name||'|EMP|ET'||ASSIGNMENT_NUMBER
                   ||'|ET|ACTIVE_PROCESS|EBS|'
                   ||'WorkTerms-ET'||ASSIGNMENT_NUMBER
                   ||'|WorkRelationship-'||ASSIGNMENT_NUMBER           
         from XXMX_PER_SAL_HIST_WORKER_STG stg
         where record_type='GLB_TRANSFER3'  --IN('GLB_TRANSFER','GLB_TRANSFER2','GLB_TRANSFER3','GLB_TRANSFER4')
         and TO_DATE(STG.effective_start_date,'DD/MM/RRRR') in (select min(TO_DATE(effective_start_date,'DD/MM/RRRR')) from 
         XXMX_PER_SAL_HIST_WORKER_STG g where record_type='GLB_TRANSFER3' 
         AND stg.person_number=g.person_number)
         and person_number not in (select unique person_number 
            from XXMX_PER_PPM_WORKER_STG);

       -- Person Work Assignments
       INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          VALUES (pv_i_file_name,'File Header', nwh_asg_header);

        INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          SELECT UNIQUE pv_i_file_name
		       , 'SalWorker_HireData'
               , 'MERGE|Assignment|E'||ASSIGNMENT_NUMBER||'|'
                   ||'ET'||ASSIGNMENT_NUMBER||'|'||PERSON_NUMBER||'|'
                   ||LEGAL_EMPLOYER_NAME||'|'
                   ||TO_CHAR(TO_DATE(EFFECTIVE_START_DATE,'DD/MM/RRRR'),'RRRR/MM/DD')||'|'
                   ||TO_CHAR(TO_DATE(EFFECTIVE_START_DATE,'DD/MM/RRRR'),'RRRR/MM/DD')||
                   '|1|Y|GLB_TRANSFER|Employee||'
                   ||bg_name||'|E|EMP|E'||ASSIGNMENT_NUMBER
                   ||'|E|ACTIVE_PROCESS|Y|EBS|Assignment-E'||ASSIGNMENT_NUMBER||'|'
                   ||'WorkRelationship-'||ASSIGNMENT_NUMBER               
          from XXMX_PER_SAL_HIST_WORKER_STG STG
         where record_type='GLB_TRANSFER3' --IN('GLB_TRANSFER','GLB_TRANSFER2','GLB_TRANSFER3','GLB_TRANSFER4')
         and TO_DATE(STG.effective_start_date,'DD/MM/RRRR') in (select min(TO_DATE(effective_start_date,'DD/MM/RRRR')) from 
         XXMX_PER_SAL_HIST_WORKER_STG g where record_type='GLB_TRANSFER3' 
         AND stg.person_number=g.person_number)
         and person_number not in (select unique person_number 
            from XXMX_PER_PPM_WORKER_STG);

end generate_worker_gltransfer_hdl;
--------------------------------------
 PROCEDURE generate_salary_assignment_hist_hdl
  IS

    wc_terms_header   VARCHAR2(10000) := 'METADATA|WorkTerms|AssignmentNumber|AssignmentName|SourceSystemOwner|SourceSystemId|PeriodOfServiceId(SourceSystemId)|PersonId(SourceSystemId)|EffectiveStartDate|EffectiveEndDate|PersonNumber|EffectiveSequence|EffectiveLatestChange|DateStart|ActionCode|ReasonCode|AssignmentStatusTypeCode|AssignmentType|BusinessUnitShortCode|TaxReportingUnit|PeopleGroup|GradeLadderPgmName';
	wc_asg_header     VARCHAR2(10000) := 'METADATA|Assignment|AssignmentNumber|AssignmentName|WorkTermsNumber|SourceSystemOwner|SourceSystemId|WorkTermsAssignmentId(SourceSystemId)|PeriodOfServiceId(SourceSystemId)|PersonId(SourceSystemId)|EffectiveStartDate|EffectiveEndDate|PersonNumber|EffectiveSequence|EffectiveLatestChange|DateStart|ActionCode|ReasonCode|WorkerType|LegalEmployerName|PrimaryAssignmentFlag|AssignmentStatusTypeCode|BusinessUnitShortCode|AssignmentType|PersonTypeCode|WorkerCategory|AssignmentCategory|FullPartTime|DateProbationEnd|NormalHours|Frequency|PermanentTemporary|JobCode|LocationCode|NoticePeriod|NoticePeriodUOM|HourlySalariedCode|PositionCode|GradeCode|BargainingUnitCode|LabourUnionMemberFlag|ManagerFlag|SystemPersonType|TaxReportingUnit|PeopleGroup|GradeLadderPgmName|ReportingEstablishment|PositionOverrideFlag|DefaultExpenseAccount|FLEX:PER_ASG_DF|headCountClassification(PER_ASG_DF=Global Data Elements)|payrollProviderId(PER_ASG_DF=Global Data Elements)|companyRecharge_Display(PER_ASG_DF=Global Data Elements)';
    pv_i_file_name VARCHAR2(100) := 'SalaryHist_WorkerCurrent.dat';

	BEGIN
	    DELETE FROM xxmx_hdl_file_temp WHERE FILE_NAME = pv_i_file_name;
		COMMIT;

	    INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          VALUES (pv_i_file_name,'File Header', wc_terms_header);

        INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          SELECT UNIQUE pv_i_file_name
		       , 'SalWorkCurrentData'
			   , 'MERGE|WorkTerms|ET'||ASSIGNMENT_NUMBER||
                  '|ET'||ASSIGNMENT_NUMBER||
                  '|EBS|Workterms-ET'||ASSIGNMENT_NUMBER||
                  '|WorkRelationship-'||ASSIGNMENT_NUMBER||
                  '|Worker-'||PERSON_NUMBER||
                  '|'||TO_CHAR(TO_DATE(EFFECTIVE_START_DATE,'DD/MM/RRRR'),'RRRR/MM/DD')||
                  '|'||TO_CHAR(TO_DATE(EFFECTIVE_END_DATE,'DD/MM/RRRR'),'RRRR/MM/DD')||
                  '|'||PERSON_NUMBER||
                  '|1|Y|'||ORIGINAL_DATE_OF_HIRE||
                  '|ASG_CHANGE||ACTIVE_PROCESS|ET|'||bg_name||'|||'
			FROM XXMX_PER_SAL_HIST_WORKER_STG STG
            WHERE 1=1
          --  AND PERSON_NUMBER IN('20152','27714')
            AND RECORD_TYPE IN ('ASG_CHANGE','GLB_TRANSFER','GLB_TRANSFER2','GLB_TRANSFER3','GLB_TRANSFER4')
            and person_number not in (select unique person_number 
            from XXMX_PER_PPM_WORKER_STG); --IN('GLB_TRANSFER','GLB_TRANSFER2','GLB_TRANSFER3','GLB_TRANSFER4')
       --ORDER BY TO_NUMBER(STG.PERSON_NUMBER),TO_DATE(STG.EFFECTIVE_START_DATE,'DD/MM/RRRR');

        INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          VALUES (pv_i_file_name,'File Header', wc_asg_header);

        INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          SELECT UNIQUE pv_i_file_name
		       , 'SalWorkCurrentData'
			   , 'MERGE|Assignment|E'||STG.ASSIGNMENT_NUMBER                   
                   ||'|Position '||SUBSTR(stg.POSITION_CODE,13)||
                   '|ET'||STG.ASSIGNMENT_NUMBER||
                   '|EBS|Assignment-E'||STG.ASSIGNMENT_NUMBER||
                   '|Workterms-ET'||STG.ASSIGNMENT_NUMBER||
                   '|WorkRelationship-'||STG.ASSIGNMENT_NUMBER||
                   '|Worker-'||STG.PERSON_NUMBER||
                   '|'||TO_CHAR(TO_DATE(STG.EFFECTIVE_START_DATE,'DD/MM/RRRR'),'RRRR/MM/DD')||
                   '|'||TO_CHAR(TO_DATE(STG.EFFECTIVE_END_DATE,'DD/MM/RRRR'),'RRRR/MM/DD')||
                   '|'||STG.PERSON_NUMBER||
                   '|1|Y|'||STG.ORIGINAL_DATE_OF_HIRE||
                   '|ASG_CHANGE||E|'||STG.LEGAL_EMPLOYER_NAME||
                   '|Y|ACTIVE_PROCESS|'||STG.bg_name||
                   '|E|||FR|||'||
                    xfm.normal_hours||
                   '|W|R||'||STG.LOCATION_CODE||
                   '||||'||STG.POSITION_CODE||
                   '|||N|Y|EMP|||||Y|'
				   ||stg.default_expense_account||
                    '|Global Data Elements|'
					||xfm.ass_attribute2||'|' --head_count_class
					||xfm.ass_attribute3||'|' -- payroll_providerid
                    ||xfm.ass_attribute4           -- companyofrecharge
			FROM   XXMX_PER_SAL_HIST_WORKER_STG STG
		         , XXMX_PER_ASSIGNMENTS_M_XFM XFM
		   WHERE 1=1
              and STG.PERSON_NUMBER = XFM.PERSONNUMBER(+)
		     AND TO_DATE(STG.EFFECTIVE_START_DATE,'DD/MM/RRRR') = TO_DATE(XFM.EFFECTIVE_START_DATE(+),'DD-MON-RR')             
		     AND RECORD_TYPE IN ('ASG_CHANGE','GLB_TRANSFER','GLB_TRANSFER2','GLB_TRANSFER3','GLB_TRANSFER4') --IN('GLB_TRANSFER','GLB_TRANSFER2','GLB_TRANSFER3','GLB_TRANSFER4')
            --AND PERSON_NUMBER IN('20152','27714')
            and person_number not in (select unique person_number 
            from XXMX_PER_PPM_WORKER_STG);
            --ORDER BY TO_NUMBER(STG.PERSON_NUMBER),TO_DATE(STG.EFFECTIVE_START_DATE,'DD/MM/RRRR');
     COMMIT;
END generate_salary_assignment_hist_hdl;
---------------------------------------------------------------------
PROCEDURE generate_salary_termination_hdl
  IS

    wt_header   VARCHAR2(10000) := 'METADATA|WorkRelationship|SourceSystemOwner|SourceSystemId|PersonId(SourceSystemId)|ActionCode|TerminateWorkRelationshipFlag|ActualTerminationDate|LastWorkingDate';
    pv_i_file_name VARCHAR2(100) := 'SalaryHist_Termination.dat';

	BEGIN
	    DELETE FROM xxmx_hdl_file_temp WHERE FILE_NAME = pv_i_file_name;
		COMMIT;

	    INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          VALUES (pv_i_file_name,'File Header', wt_header);

        INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          SELECT UNIQUE pv_i_file_name
		       , 'SalWorkTerminationData'
			   , 'MERGE|WorkRelationship|EBS|WorkRelationship-'||ASSIGNMENT_NUMBER||
                  '|Worker-'||PERSON_NUMBER||'|CITCO_VOLUNTARY_TERMINATION|Y|'||
                  TO_CHAR(TO_DATE(TERMINATION_DATE,'DD/MM/RRRR'),'RRRR/MM/DD')||
                  '|'||TO_CHAR(TO_DATE(TERMINATION_DATE,'DD/MM/RRRR'),'RRRR/MM/DD')
			FROM XXMX_PER_SAL_HIST_WORKER_STG STG
            WHERE 1=1
            AND RECORD_TYPE IN ('TERMINATION')
            and person_number not in (select unique person_number 
            from XXMX_PER_PPM_WORKER_STG);
   COMMIT;
END generate_salary_termination_hdl;
----------------------------------------------------------------------
PROCEDURE generate_salary_rehire_hdl
  IS

    wrh_wrk_header  VARCHAR2(10000) := 
    'METADATA|Worker|EffectiveStartDate|EffectiveEndDate|PersonNumber|ActionCode|StartDate';
    wrh_wr_header   VARCHAR2(10000) := 
    'METADATA|WorkRelationship|SourceSystemOwner|SourceSystemId|PersonNumber|LegalEmployerName|DateStart|EnterpriseSeniorityDate|LegalEmployerSeniorityDate|ActualTerminationDate|Comments|PrimaryFlag|WorkerType|RehireRecommendationFlag|ActionCode';
    wrh_wt_header   VARCHAR2(10000) := 
    'METADATA|WorkTerms|ActionCode|SourceSystemOwner|SourceSystemId|AssignmentName|AssignmentNumber|AssignmentStatusTypeCode|AssignmentType|EffectiveStartDate|EffectiveEndDate|EffectiveLatestChange|EffectiveSequence|PeriodOfServiceId(SourceSystemId)|PersonNumber|PrimaryWorkTermsFlag|SystemPersonType|BusinessUnitShortCode|LegalEmployerName|PositionOverrideFlag|FreezeStartDate|FreezeUntilDate|PositionCode';
    wrh_asg_header  VARCHAR2(10000) := 
    'METADATA|Assignment|ActionCode|SourceSystemOwner|SourceSystemId|EffectiveStartDate|EffectiveEndDate|EffectiveSequence|EffectiveLatestChange|AssignmentName|AssignmentNumber|AssignmentStatusTypeCode|AssignmentType|BusinessUnitShortCode|PositionOverrideFlag|PrimaryAssignmentFlag|PrimaryFlag|SystemPersonType|LegalEmployerName|PeriodOfServiceId(SourceSystemId)|PersonNumber|PersonTypeCode|ManagerFlag|WorkTermsAssignmentId(SourceSystemId)|AssignmentCategory|Frequency|NormalHours|ReasonCode|PositionCode';

    pv_i_file_name  VARCHAR2(100)   := 'SalaryHist_ReHire.dat';

	BEGIN
	    DELETE FROM xxmx_hdl_file_temp WHERE FILE_NAME = pv_i_file_name;
		COMMIT;

--Worker
	    INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          VALUES (pv_i_file_name,'File Header', wrh_wrk_header);

        INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          SELECT UNIQUE pv_i_file_name
		       , 'SalWorkerReHireData'
			   , 'MERGE|Worker|'
                  || TO_CHAR(TO_DATE(EFFECTIVE_START_DATE,'DD/MM/RRRR'),'RRRR/MM/DD')||
                  '|4712/12/31|'||PERSON_NUMBER||'|HIRE|'
                  ||TO_CHAR(TO_DATE(EFFECTIVE_START_DATE,'DD/MM/RRRR'),'RRRR/MM/DD')
			FROM XXMX_PER_SAL_HIST_WORKER_STG STG
            WHERE 1=1
            AND RECORD_TYPE = 'REHIRE'
            AND TO_DATE(EFFECTIVE_START_DATE,'DD/MM/RRRR') = (select min(TO_DATE(effective_start_date,'DD/MM/RRRR')) from 
         XXMX_PER_SAL_HIST_WORKER_STG g where record_type='REHIRE' 
         AND stg.person_number=g.person_number)
         and person_number not in (select unique person_number 
            from XXMX_PER_PPM_WORKER_STG);

--WorkRelationship
        INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          VALUES (pv_i_file_name,'File Header', wrh_wr_header);

        INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          SELECT UNIQUE pv_i_file_name
		       , 'SalWorkerReHireData'
			   , 'MERGE|WorkRelationship|EBS|WorkRelationship-'||ASSIGNMENT_NUMBER||
               '|'||PERSON_NUMBER||
               '|'||LEGAL_EMPLOYER_NAME||              
               '|'||TO_CHAR(TO_DATE(EFFECTIVE_START_DATE,'DD/MM/RRRR'),'RRRR/MM/DD')
               ||'|||||Y|E|Y|'
			FROM XXMX_PER_SAL_HIST_WORKER_STG STG
            WHERE 1=1
            AND RECORD_TYPE = 'REHIRE'
            AND TO_DATE(EFFECTIVE_START_DATE,'DD/MM/RRRR') = (select min(TO_DATE(effective_start_date,'DD/MM/RRRR')) from 
         XXMX_PER_SAL_HIST_WORKER_STG g where record_type='REHIRE' 
         AND stg.person_number=g.person_number)
         and person_number not in (select unique person_number 
            from XXMX_PER_PPM_WORKER_STG);

-- WorkTerms        
        INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          VALUES (pv_i_file_name,'File Header', wrh_wt_header);

        INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          SELECT UNIQUE pv_i_file_name
		       , 'SalWorkerReHireData'
			   , 'MERGE|WorkTerms|HIRE|EBS|WorkTerms-'||ASSIGNMENT_NUMBER||
                 '|ET'||ASSIGNMENT_NUMBER||'|ET'||ASSIGNMENT_NUMBER||
                 '|ACTIVE_PROCESS|ET|'||
                 TO_CHAR(TO_DATE(EFFECTIVE_START_DATE,'DD/MM/RRRR'),'RRRR/MM/DD')||
                 '|4712/12/31|Y|1|WorkRelationship-'||ASSIGNMENT_NUMBER||
                 '|'||PERSON_NUMBER||
                 '|Y|EMP|'||BG_NAME||
                 '|'||LEGAL_EMPLOYER_NAME||
                 '|Y|||'
			FROM XXMX_PER_SAL_HIST_WORKER_STG STG
            WHERE 1=1
            AND RECORD_TYPE = 'REHIRE'
            AND TO_DATE(EFFECTIVE_START_DATE,'DD/MM/RRRR') = (select min(TO_DATE(effective_start_date,'DD/MM/RRRR')) from 
         XXMX_PER_SAL_HIST_WORKER_STG g where record_type='REHIRE' 
         AND stg.person_number=g.person_number)
         and person_number not in (select unique person_number 
            from XXMX_PER_PPM_WORKER_STG);

 --Assignment
        INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          VALUES (pv_i_file_name,'File Header', wrh_asg_header);

        INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          SELECT UNIQUE pv_i_file_name
		       , 'SalWorkerReHireData'
			   , 'MERGE|Assignment|HIRE|EBS|Assignment-'||ASSIGNMENT_NUMBER||
               '|'||TO_CHAR(TO_DATE(EFFECTIVE_START_DATE,'DD/MM/RRRR'),'RRRR/MM/DD')||
               '|4712/12/31|1|Y|E'||ASSIGNMENT_NUMBER||
               '|E'||ASSIGNMENT_NUMBER||
               '|ACTIVE_PROCESS|E|'||BG_NAME||
               '|Y|Y|Y|EMP|'||LEGAL_EMPLOYER_NAME||
               '|WorkRelationship-'||ASSIGNMENT_NUMBER||
               '|'||PERSON_NUMBER||
               '|Employee|Y|WorkTerms-'||ASSIGNMENT_NUMBER||
               '|FR|W|40||'            
			FROM XXMX_PER_SAL_HIST_WORKER_STG STG
            WHERE 1=1
            AND RECORD_TYPE = 'REHIRE'
            AND TO_DATE(EFFECTIVE_START_DATE,'DD/MM/RRRR') = (select min(TO_DATE(effective_start_date,'DD/MM/RRRR')) from 
              XXMX_PER_SAL_HIST_WORKER_STG g where record_type='REHIRE' 
            AND stg.person_number=g.person_number)
           and person_number not in (select unique person_number 
            from XXMX_PER_PPM_WORKER_STG);
   COMMIT;
END generate_salary_rehire_hdl;
----------------------------------------------------------------------
procedure generate_salary_rehire_glbtrans_hdl
IS

    nwh_wr_header   VARCHAR2(10000) :=
   	'METADATA|WorkRelationship|PersonNumber|DateStart|PrimaryFlag|LegalEmployerName|WorkerType|GlobalTransferFlag|ActionCode|SourceSystemOwner|SourceSystemId';
    nwh_wt_header     VARCHAR2(10000) := 
    'METADATA|WorkTerms|AssignmentNumber|PersonNumber|LegalEmployerName|DateStart|EffectiveStartDate|EffectiveSequence|EffectiveLatestChange|ActionCode|PersonTypeCode|JobCode|WorkerType|BusinessUnitShortCode|SystemPersonType|AssignmentName|AssignmentType|AssignmentStatusTypeCode|SourceSystemOwner|SourceSystemId|PeriodOfServiceId(SourceSystemId)';
    nwh_asg_header     VARCHAR2(10000) := 
    'METADATA|Assignment|AssignmentNumber|WorkTermsNumber|PersonNumber|LegalEmployerName|DateStart|EffectiveStartDate|EffectiveSequence|EffectiveLatestChange|ActionCode|PersonTypeCode|JobCode|BusinessUnitShortCode|WorkerType|SystemPersonType|AssignmentName|AssignmentType|AssignmentStatusTypeCode|PrimaryAssignmentFlag|SourceSystemOwner|SourceSystemId|PeriodOfServiceId(SourceSystemId)';
    pv_i_file_name VARCHAR2(100) := 'SalaryHist_ReHireGLBTrsfer.dat';

BEGIN
	    DELETE FROM xxmx_hdl_file_temp 
        WHERE FILE_NAME = pv_i_file_name;
		COMMIT;
  --Hire File
      -- Person WorkRelationship
       INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          VALUES (pv_i_file_name,'File Header', nwh_wr_header);

        INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
           SELECT UNIQUE pv_i_file_name
		       , 'SalWorker_HireData'
			   , 'MERGE|WorkRelationship|'||PERSON_NUMBER||'|'
               ||TO_CHAR(TO_DATE(EFFECTIVE_START_DATE,'DD/MM/RRRR'),'RRRR/MM/DD')||'|'||'Y|'
               ||LEGAL_EMPLOYER_NAME
               ||'|E|Y|GLB_TRANSFER|EBS|WorkRelationship-'||ASSIGNMENT_NUMBER
            From XXMX_PER_SAL_HIST_WORKER_STG stg
         where record_type='REHIRE_GLB_TRANSFER'  --IN('GLB_TRANSFER','GLB_TRANSFER2','GLB_TRANSFER3','GLB_TRANSFER4')
         and TO_DATE(STG.effective_start_date,'DD/MM/RRRR') in (select min(TO_DATE(effective_start_date,'DD/MM/RRRR')) from 
         XXMX_PER_SAL_HIST_WORKER_STG g where record_type='REHIRE_GLB_TRANSFER' 
         AND stg.person_number=g.person_number)
         and person_number not in (select unique person_number 
            from XXMX_PER_PPM_WORKER_STG);

      -- Person WorkTerms
       INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          VALUES (pv_i_file_name,'File Header', nwh_wt_header);

        INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          SELECT UNIQUE pv_i_file_name
		       , 'SalWorker_HireData'
               , 'MERGE|WorkTerms|ET'||ASSIGNMENT_NUMBER||'|'
                   ||PERSON_NUMBER||'|'
                   ||LEGAL_EMPLOYER_NAME||'|'
                   ||TO_CHAR(TO_DATE(EFFECTIVE_START_DATE,'DD/MM/RRRR'),'RRRR/MM/DD')||'|'
                   ||TO_CHAR(TO_DATE(EFFECTIVE_START_DATE,'DD/MM/RRRR'),'RRRR/MM/DD')||
                   '|1|Y|GLB_TRANSFER|Employee||E|'
                   ||bg_name||'|EMP|ET'||ASSIGNMENT_NUMBER
                   ||'|ET|ACTIVE_PROCESS|EBS|'
                   ||'WorkTerms-ET'||ASSIGNMENT_NUMBER
                   ||'|WorkRelationship-'||ASSIGNMENT_NUMBER           
         from XXMX_PER_SAL_HIST_WORKER_STG stg
         where record_type='REHIRE_GLB_TRANSFER'  --IN('GLB_TRANSFER','GLB_TRANSFER2','GLB_TRANSFER3','GLB_TRANSFER4')
         and TO_DATE(STG.effective_start_date,'DD/MM/RRRR') in (select min(TO_DATE(effective_start_date,'DD/MM/RRRR')) from 
         XXMX_PER_SAL_HIST_WORKER_STG g where record_type='REHIRE_GLB_TRANSFER' 
         AND stg.person_number=g.person_number)
         and person_number not in (select unique person_number 
            from XXMX_PER_PPM_WORKER_STG);

       -- Person Work Assignments
       INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          VALUES (pv_i_file_name,'File Header', nwh_asg_header);

        INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          SELECT UNIQUE pv_i_file_name
		       , 'SalWorker_HireData'
               , 'MERGE|Assignment|E'||ASSIGNMENT_NUMBER||'|'
                   ||'ET'||ASSIGNMENT_NUMBER||'|'||PERSON_NUMBER||'|'
                   ||LEGAL_EMPLOYER_NAME||'|'
                   ||TO_CHAR(TO_DATE(EFFECTIVE_START_DATE,'DD/MM/RRRR'),'RRRR/MM/DD')||'|'
                   ||TO_CHAR(TO_DATE(EFFECTIVE_START_DATE,'DD/MM/RRRR'),'RRRR/MM/DD')||
                   '|1|Y|GLB_TRANSFER|Employee||'
                   ||bg_name||'|E|EMP|E'||ASSIGNMENT_NUMBER
                   ||'|E|ACTIVE_PROCESS|Y|EBS|Assignment-E'||ASSIGNMENT_NUMBER||'|'
                   ||'WorkRelationship-'||ASSIGNMENT_NUMBER               
          from XXMX_PER_SAL_HIST_WORKER_STG STG
         where record_type='REHIRE_GLB_TRANSFER' --IN('GLB_TRANSFER','GLB_TRANSFER2','GLB_TRANSFER3','GLB_TRANSFER4')
         and TO_DATE(STG.effective_start_date,'DD/MM/RRRR') in (select min(TO_DATE(effective_start_date,'DD/MM/RRRR')) from 
         XXMX_PER_SAL_HIST_WORKER_STG g where record_type='REHIRE_GLB_TRANSFER' 
         AND stg.person_number=g.person_number)
         and person_number not in (select unique person_number 
            from XXMX_PER_PPM_WORKER_STG);

end generate_salary_rehire_glbtrans_hdl;
--------------------------------------
 PROCEDURE generate_salary_rehire_asg_hist_hdl
  IS

    wc_terms_header   VARCHAR2(10000) := 'METADATA|WorkTerms|AssignmentNumber|AssignmentName|SourceSystemOwner|SourceSystemId|PeriodOfServiceId(SourceSystemId)|PersonId(SourceSystemId)|EffectiveStartDate|EffectiveEndDate|PersonNumber|EffectiveSequence|EffectiveLatestChange|DateStart|ActionCode|ReasonCode|AssignmentStatusTypeCode|AssignmentType|BusinessUnitShortCode|TaxReportingUnit|PeopleGroup|GradeLadderPgmName';
	wc_asg_header     VARCHAR2(10000) := 'METADATA|Assignment|AssignmentNumber|AssignmentName|WorkTermsNumber|SourceSystemOwner|SourceSystemId|WorkTermsAssignmentId(SourceSystemId)|PeriodOfServiceId(SourceSystemId)|PersonId(SourceSystemId)|EffectiveStartDate|EffectiveEndDate|PersonNumber|EffectiveSequence|EffectiveLatestChange|DateStart|ActionCode|ReasonCode|WorkerType|LegalEmployerName|PrimaryAssignmentFlag|AssignmentStatusTypeCode|BusinessUnitShortCode|AssignmentType|PersonTypeCode|WorkerCategory|AssignmentCategory|FullPartTime|DateProbationEnd|NormalHours|Frequency|PermanentTemporary|JobCode|LocationCode|NoticePeriod|NoticePeriodUOM|HourlySalariedCode|PositionCode|GradeCode|BargainingUnitCode|LabourUnionMemberFlag|ManagerFlag|SystemPersonType|TaxReportingUnit|PeopleGroup|GradeLadderPgmName|ReportingEstablishment|PositionOverrideFlag|DefaultExpenseAccount|FLEX:PER_ASG_DF|headCountClassification(PER_ASG_DF=Global Data Elements)|payrollProviderId(PER_ASG_DF=Global Data Elements)|companyRecharge_Display(PER_ASG_DF=Global Data Elements)';
    pv_i_file_name VARCHAR2(100) := 'SalaryHist_Rehire_Asg.dat';

	BEGIN
	    DELETE FROM xxmx_hdl_file_temp WHERE FILE_NAME = pv_i_file_name;
		COMMIT;

	    INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          VALUES (pv_i_file_name,'File Header', wc_terms_header);

        INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          SELECT UNIQUE pv_i_file_name
		       , 'SalWorkCurrentData'
			   , 'MERGE|WorkTerms|ET'||ASSIGNMENT_NUMBER||
                  '|ET'||ASSIGNMENT_NUMBER||
                  '|EBS|Workterms-ET'||ASSIGNMENT_NUMBER||
                  '|WorkRelationship-'||ASSIGNMENT_NUMBER||
                  '|Worker-'||PERSON_NUMBER||
                  '|'||TO_CHAR(TO_DATE(EFFECTIVE_START_DATE,'DD/MM/RRRR'),'RRRR/MM/DD')||
                  '|'||TO_CHAR(TO_DATE(EFFECTIVE_END_DATE,'DD/MM/RRRR'),'RRRR/MM/DD')||
                  '|'||PERSON_NUMBER||
                  '|1|Y|'||ORIGINAL_DATE_OF_HIRE||
                  '|ASG_CHANGE||ACTIVE_PROCESS|ET|'||bg_name||'|||'
			FROM XXMX_PER_SAL_HIST_WORKER_STG STG
            WHERE 1=1
            AND RECORD_TYPE IN ('REHIRE','REHIRE_GLB_TRANSFER')
            and person_number not in (select unique person_number 
            from XXMX_PER_PPM_WORKER_STG); --IN('GLB_TRANSFER','GLB_TRANSFER2','GLB_TRANSFER3','GLB_TRANSFER4')
       --ORDER BY TO_NUMBER(STG.PERSON_NUMBER),TO_DATE(STG.EFFECTIVE_START_DATE,'DD/MM/RRRR');

        INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          VALUES (pv_i_file_name,'File Header', wc_asg_header);

        INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          SELECT UNIQUE pv_i_file_name
		       , 'SalWorkCurrentData'
			   , 'MERGE|Assignment|E'||STG.ASSIGNMENT_NUMBER                   
                   ||'|Position '||SUBSTR(stg.POSITION_CODE,13)||
                   '|ET'||STG.ASSIGNMENT_NUMBER||
                   '|EBS|Assignment-E'||STG.ASSIGNMENT_NUMBER||
                   '|Workterms-ET'||STG.ASSIGNMENT_NUMBER||
                   '|WorkRelationship-'||STG.ASSIGNMENT_NUMBER||
                   '|Worker-'||STG.PERSON_NUMBER||
                   '|'||TO_CHAR(TO_DATE(STG.EFFECTIVE_START_DATE,'DD/MM/RRRR'),'RRRR/MM/DD')||
                   '|'||TO_CHAR(TO_DATE(STG.EFFECTIVE_END_DATE,'DD/MM/RRRR'),'RRRR/MM/DD')||
                   '|'||STG.PERSON_NUMBER||
                   '|1|Y|'||STG.ORIGINAL_DATE_OF_HIRE||
                   '|ASG_CHANGE||E|'||STG.LEGAL_EMPLOYER_NAME||
                   '|Y|ACTIVE_PROCESS|'||STG.bg_name||
                   '|E|||FR|||'||
                    xfm.normal_hours||
                   '|W|R||'||STG.LOCATION_CODE||
                   '||||'||STG.POSITION_CODE||
                   '|||N|Y|EMP|||||Y|'
				   ||XFM.default_expense_account||
                    '|Global Data Elements|'
					||XFM.ASS_ATTRIBUTE2||'|' --head_count_class
					||XFM.ASS_ATTRIBUTE3||'|' -- payroll_providerid
                    ||XFM.ASS_ATTRIBUTE4           -- companyofrecharge
			FROM XXMX_PER_SAL_HIST_WORKER_STG STG
			   , XXMX_PER_ASSIGNMENTS_M_XFM XFM
		   WHERE STG.PERSON_NUMBER = XFM.PERSONNUMBER(+)
		     AND TO_DATE(STG.EFFECTIVE_START_DATE,'DD/MM/RRRR') = TO_DATE(XFM.EFFECTIVE_START_DATE(+),'DD-MON-RR')
             AND RECORD_TYPE IN ('REHIRE','REHIRE_GLB_TRANSFER')
             and person_number not in (select unique person_number 
            from XXMX_PER_PPM_WORKER_STG);  --IN('GLB_TRANSFER','GLB_TRANSFER2','GLB_TRANSFER3','GLB_TRANSFER4')
            --ORDER BY TO_NUMBER(STG.PERSON_NUMBER),TO_DATE(STG.EFFECTIVE_START_DATE,'DD/MM/RRRR');
     COMMIT;
END generate_salary_rehire_asg_hist_hdl;
----------------------------------------------------------------------
PROCEDURE MAIN
AS
  BEGIN
     dbms_output.put_line('Calling..');
     update_salary_assignment_hist;
     dbms_output.put_line('Calling generate Worker Hire hdl');
     generate_worker_hire_hdl;
     dbms_output.put_line('Calling generate Worker Global Transfer hdl');
     generate_worker_gltransfer_hdl;
     dbms_output.put_line('Calling generate Worker Current hdl');
     generate_salary_assignment_hist_hdl;
     dbms_output.put_line('Calling generate Worker Termination hdl');
     generate_salary_termination_hdl;
     dbms_output.put_line('Calling generate Worker ReHire hdl');
     generate_salary_rehire_hdl;
     dbms_output.put_line('Calling generate Worker ReHire Global Transfer hdl');
     generate_salary_rehire_glbtrans_hdl;
     dbms_output.put_line('Calling generate Worker ReHire Assignment History hdl');
     generate_salary_rehire_asg_hist_hdl;
     dbms_output.put_line('End of Main Section');
  EXCEPTION WHEN OTHERS
  THEN
    dbms_output.put_line('In Exception Block -'||SQLERRM);
END ;

 END xxmx_kit_sal_hist_worker_stg;

/
