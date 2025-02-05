--------------------------------------------------------
--  DDL for Package Body XXMX_KIT_PPM_WORKER_STG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "XXMX_CORE"."XXMX_KIT_PPM_WORKER_STG" AS 

    gcv_PackageName                           CONSTANT  VARCHAR2(30)                                := 'xxmx_kit_ppm_worker_stg';
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
    gvd_prev_tax_year_date                    DATE;

------------------------------------------------------------
 PROCEDURE update_ppm_worker_details
  IS
		cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'UPDATE_PPM_WORKER_DETAILS'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'UPDATE';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_PER_PPM_WORKER_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'PPM';

        e_DateError                         EXCEPTION;
        pv_o_returnstatus                   VARCHAR2(2000);

	BEGIN

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
		 /*FOR I IN (SELECT UNIQUE STG.POSITION_CODE,TAB.BU,TAB.LEG_CODE,TAB.LEGAL_EMPLOYER
		               , (SELECT distinct LOCATION_CODE FROM XX_POSITION_MAP_TEMP 
                           WHERE POSITION_CODE = STG.POSITION_CODE
                             and gen1=stg.person_number) LOCATION_CODE
		            FROM XXMX_PER_PPM_WORKER_STG STG
					   , XXMX_HCM_POSITION_LE_BU_TAB TAB
				   WHERE STG.POSITION_CODE = TAB.POSITION_CODE )
                   /*AND STG.EFFECTIVE_START_DATE = (SELECT MAX(EFFECTIVE_START_DATE) 
                                                     FROM XXMX_PER_PPM_WORKER_STG
                                                    WHERE PERSON_NUMBER = STG.PERSON_NUMBER )) */
		/*LOOP
		UPDATE XXMX_PER_PPM_WORKER_STG STG
		   SET BG_NAME = I.BU
		     , LEGISLATION_CODE = I.LEG_CODE
			 --, LEGAL_EMPLOYER_NAME = I.LEGAL_EMPLOYER
			 --, LOCATION_CODE = I.LOCATION_CODE
		 WHERE STG.POSITION_CODE = I.POSITION_CODE;
		END LOOP;
	  COMMIT; */

	  FOR J IN(SELECT STG.PERSON_NUMBER,TO_CHAR(PAPF.ORIGINAL_DATE_OF_HIRE,'RRRR/MM/DD') ORIGINAL_DATE_OF_HIRE
	                , TO_CHAR(PAPF.EFFECTIVE_START_DATE,'RRRR/MM/DD') PERSON_START_DATE,PAPF.FIRST_NAME,PAPF.LAST_NAME
					, PAPF.SEX,PAPF.MARITAL_STATUS
                    ,(SELECT ASSIGNMENT_NUMBER FROM PER_ALL_ASSIGNMENTS_F@XXMX_EXTRACT 
                       WHERE PERSON_ID=PAPF.PERSON_ID
                         AND TO_DATE(STG.EFFECTIVE_START_DATE,'MM/DD/RRRR') = EFFECTIVE_START_DATE 
                         AND TO_DATE(STG.EFFECTIVE_END_DATE,'MM/DD/RRRR') = EFFECTIVE_END_DATE
                         AND ASSIGNMENT_STATUS_TYPE_ID=1) ASSIGNMENT_NUMBER
	                , (SELECT max(TO_CHAR(ACTUAL_TERMINATION_DATE,'RRRR/MM/DD')) ACTUAL_TERMINATION_DATE FROM PER_PERIODS_OF_SERVICE@XXMX_EXTRACT WHERE PERSON_ID = PAPF.PERSON_ID) TERMINATION_DATE
                    , (SELECT UNIQUE default_code_comb_id FROM PER_ALL_ASSIGNMENTS_F@XXMX_EXTRACT 
                       WHERE PERSON_ID=PAPF.PERSON_ID
                         AND TO_DATE(STG.EFFECTIVE_START_DATE,'MM/DD/RRRR') = EFFECTIVE_START_DATE 
                         AND TO_DATE(STG.EFFECTIVE_END_DATE,'MM/DD/RRRR') = EFFECTIVE_END_DATE 
                         AND ASSIGNMENT_STATUS_TYPE_ID=1) CODE_COMBINATION_ID
                    , (SELECT UNIQUE NORMAL_HOURS FROM PER_ALL_ASSIGNMENTS_F@XXMX_EXTRACT 
                       WHERE PERSON_ID=PAPF.PERSON_ID
                         AND TO_DATE(STG.EFFECTIVE_START_DATE,'MM/DD/RRRR') = EFFECTIVE_START_DATE 
                         AND TO_DATE(STG.EFFECTIVE_END_DATE,'MM/DD/RRRR') = EFFECTIVE_END_DATE 
                         AND ASSIGNMENT_STATUS_TYPE_ID=1) NORMAL_HOURS
                    , STG.EFFECTIVE_START_DATE
	             FROM PER_ALL_PEOPLE_F@XXMX_EXTRACT PAPF,XXMX_PER_PPM_WORKER_STG STG
				WHERE PAPF.EMPLOYEE_NUMBER = STG.PERSON_NUMBER
				  AND SYSDATE BETWEEN PAPF.EFFECTIVE_START_DATE AND PAPF.EFFECTIVE_END_DATE
				  )
        LOOP 
		  UPDATE XXMX_PER_PPM_WORKER_STG STG
		     SET ORIGINAL_DATE_OF_HIRE = J.ORIGINAL_DATE_OF_HIRE
			   , PERSON_START_DATE = J.PERSON_START_DATE
			   , FIRST_NAME = J.FIRST_NAME
			   , LAST_NAME = J.LAST_NAME
			   , GENDER  = J.SEX
			   , MARITAL_STATUS = J.MARITAL_STATUS
               , BG_NAME = SUBSTR(POSITION_CODE,1,6)
               , LEGISLATION_CODE = SUBSTR(POSITION_CODE,1,2)
               --, LOCATION_CODE = SUBSTR(POSITION_CODE,8,4)||'.1'
               , NORMAL_HOURS = J.NORMAL_HOURS
               , DEFAULT_EXPENSE_ACCOUNT = (select concatenated_segments 
                                              from gl_code_combinations_extract 
                                             where CODE_COMBINATION_ID = J.CODE_COMBINATION_ID )
           WHERE STG.PERSON_NUMBER = J.PERSON_NUMBER
             AND STG.EFFECTIVE_START_DATE = J.EFFECTIVE_START_DATE;
		END LOOP;
	  COMMIT;

/* Inserting Default_Expense_Account rows into XXMX_PER_ASSIGNMENTS_M_XFM - for Transforming Expense Account*/
       INSERT INTO XXMX_PER_ASSIGNMENTS_M_XFM(MIGRATION_SET_ID
                                            , MIGRATION_SET_NAME
                                            , DEFAULT_EXPENSE_ACCOUNT
                                            , PERSONNUMBER
                                            , EFFECTIVE_START_DATE
                                            , EFFECTIVE_END_DATE
                                            , ASSIGNMENT_NUMBER
                                            , PRIMARY_WORK_TERMS_FLAG
                                            , PRIMARY_ASSIGNMENT_FLAG )
                SELECT '99','PPM_99_EXPENSE',DEFAULT_EXPENSE_ACCOUNT,PERSON_NUMBER
                     , TO_DATE(EFFECTIVE_START_DATE,'MM/DD/RRRR'),TO_DATE(EFFECTIVE_END_DATE,'MM/DD/RRRR')
                     , ASSIGNMENT_NUMBER,'Y','Y'
                  FROM XXMX_PER_PPM_WORKER_STG
                 WHERE DEFAULT_EXPENSE_ACCOUNT IS NOT NULL
                 AND RECORD_TYPE not in ('HIRE','TERMINATION');
  COMMIT;

/*Transforming Expense Account */
BEGIN
xxmx_citco_fin_ext_pkg.transform_code_combo (
        'HCM',
        'HR',
        'WORKER',
        'DB_LINK',
        NULL,
        99,
        pv_o_returnstatus 
);
END;

/*Updating Transformed data back to XXMX_PER_PPM_WORKER_STG table */
UPDATE XXMX_PER_PPM_WORKER_STG STG
   SET DEFAULT_EXPENSE_ACCOUNT = (SELECT UNIQUE DEFAULT_EXPENSE_ACCOUNT
                                    FROM XXMX_PER_ASSIGNMENTS_M_XFM
                                   WHERE PERSONNUMBER = STG.PERSON_NUMBER
                                     AND ASSIGNMENT_NUMBER = STG.ASSIGNMENT_NUMBER
                                     AND EFFECTIVE_START_DATE = TO_DATE(STG.EFFECTIVE_START_DATE,'MM/DD/RRRR')
                                     AND EFFECTIVE_END_DATE = TO_DATE(STG.EFFECTIVE_END_DATE,'MM/DD/RRRR')
                                     AND MIGRATION_SET_ID=99
                                     )
 WHERE DEFAULT_EXPENSE_ACCOUNT IS NOT NULL;
COMMIT; 

/*Deleting PPM Records from XXMX_PER_ASSIGNMENTS_M_XFM Inserted as 99*/
DELETE FROM XXMX_PER_ASSIGNMENTS_M_XFM
 WHERE MIGRATION_SET_ID = 99
   AND MIGRATION_SET_NAME = 'PPM_99_EXPENSE';
COMMIT;

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
       END update_ppm_worker_details;
-------------------------------------------------------------------------
PROCEDURE generate_ppm_worker_hire_hdl
  IS

    worker_header     VARCHAR2(10000) := 'METADATA|Worker|SourceSystemOwner|SourceSystemId|EffectiveStartDate|EffectiveEndDate|PersonNumber|StartDate|DateOfBirth|ActionCode|ReasonCode';
    workername_header      VARCHAR2(10000) := 'METADATA|PersonName|SourceSystemOwner|SourceSystemId|PersonId(SourceSystemId)|EffectiveStartDate|EffectiveEndDate|LegislationCode|NameType|FirstName|MiddleNames|LastName|Honors|KnownAs|PreNameAdjunct|MilitaryRank|PreviousLastName|Suffix|Title';
	workerldg_header      VARCHAR2(10000) := 'METADATA|PersonLegislativeData|SourceSystemOwner|SourceSystemId|PersonId(SourceSystemId)|EffectiveStartDate|EffectiveEndDate|PersonNumber|LegislationCode|HighestEducationLevel|MaritalStatus|MaritalStatusDate|Sex';
    workercs_header   VARCHAR2(10000) := 'METADATA|PersonCitizenship|SourceSystemOwner|SourceSystemId|PersonId(SourceSystemId)|DateFrom|DateTo|LegislationCode|CitizenshipStatus';
	workrelation_header      VARCHAR2(10000) := 'METADATA|WorkRelationship|SourceSystemOwner|SourceSystemId|PersonId(SourceSystemId)|PersonNumber|DateStart|WorkerType|LegalEmployerName|ActionCode|ReasonCode|PrimaryFlag|EnterpriseSeniorityDate';
	workterms_header      VARCHAR2(10000) := 'METADATA|WorkTerms|AssignmentNumber|AssignmentName|SourceSystemOwner|SourceSystemId|PeriodOfServiceId(SourceSystemId)|PersonId(SourceSystemId)|EffectiveStartDate|EffectiveEndDate|PersonNumber|EffectiveSequence|EffectiveLatestChange|DateStart|ActionCode|ReasonCode|AssignmentStatusTypeCode|BusinessUnitShortCode|TaxReportingUnit';
	workasg_header      VARCHAR2(10000) := 'METADATA|Assignment|AssignmentNumber|AssignmentName|WorkTermsNumber|SourceSystemOwner|SourceSystemId|WorkTermsAssignmentId(SourceSystemId)|PeriodOfServiceId(SourceSystemId)|PersonId(SourceSystemId)|EffectiveStartDate|EffectiveEndDate|PersonNumber|EffectiveSequence|EffectiveLatestChange|DateStart|ActionCode|ReasonCode|WorkerType|LegalEmployerName|PrimaryAssignmentFlag|AssignmentStatusTypeCode|BusinessUnitShortCode|AssignmentType|WorkerCategory|SystemPersonType|TaxReportingUnit|AssignmentCategory|DefaultExpenseAccount|PositionCode';
    pv_i_file_name VARCHAR2(100) := 'PPM_WorkerHire1.dat';

	BEGIN
	    DELETE FROM xxmx_hdl_file_temp WHERE FILE_NAME = pv_i_file_name;
		COMMIT;

	    INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          VALUES (pv_i_file_name,'File Header', worker_header);

        INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          SELECT UNIQUE pv_i_file_name
		       , 'PPMWorkerData'
			   , 'MERGE|Worker|EBS|Worker-'||PERSON_NUMBER||'|'||ORIGINAL_DATE_OF_HIRE||'|4712/12/31|'||PERSON_NUMBER||'|'||ORIGINAL_DATE_OF_HIRE
			      ||'|1970/01/01|HIRE|'
			FROM XXMX_PER_PPM_WORKER_STG T
           WHERE RECORD_TYPE='HIRE'
          and person_number in ('29930');


        INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          VALUES (pv_i_file_name,'File Header', workername_header);

        INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          SELECT UNIQUE pv_i_file_name
		       , 'PPMWorkerData'
			   , 'MERGE|PersonName|EBS|PersonName-'||PERSON_NUMBER||'|Worker-'||PERSON_NUMBER||'|'||ORIGINAL_DATE_OF_HIRE||'|4712/12/31|'
			   ||LEGISLATION_CODE||'|GLOBAL|'||FIRST_NAME||'||'||LAST_NAME||'|||||||'
			FROM XXMX_PER_PPM_WORKER_STG T 
           WHERE RECORD_TYPE='HIRE'
           and person_number in ('29930');

        INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          VALUES (pv_i_file_name,'File Header', workerldg_header);

        INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          SELECT UNIQUE pv_i_file_name
		       , 'PPMWorkerData'
			   , 'MERGE|PersonLegislativeData|EBS|PersonLegislativeData-'||PERSON_NUMBER||'|Worker-'||PERSON_NUMBER||'|'||ORIGINAL_DATE_OF_HIRE||'|4712/12/31'
			   ||'|'||PERSON_NUMBER||'|'||LEGISLATION_CODE||'||'||MARITAL_STATUS||'||'||GENDER
			FROM XXMX_PER_PPM_WORKER_STG T 
           WHERE RECORD_TYPE='HIRE'
           and person_number in ('29930');
  --Person Citizenship Data
        INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          VALUES (pv_i_file_name,'File Header', workercs_header);

        INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          SELECT UNIQUE pv_i_file_name
		       , 'PPMWorkerData'
			   ,'MERGE|PersonCitizenship|EBS|PersonCitizenship-'||PERSONNUMBER||'|Worker-'||personnumber||'|'||TO_CHAR(DATE_FROM,'RRRR/MM/DD')
||'|'||TO_CHAR(DATE_TO,'RRRR/MM/DD')||'|'||LEGISLATION_CODE||'|'||CITIZENSHIP_STATUS
            FROM xxmx_citizenships_xfm
           WHERE personnumber in(select person_number from xxmx_per_ppm_worker_stg where RECORD_TYPE='HIRE'
           and person_number in ('29930'));

		INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          VALUES (pv_i_file_name,'File Header', workrelation_header);

        INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          SELECT UNIQUE pv_i_file_name
		       , 'PPMWorkerData'
			   , 'MERGE|WorkRelationship|EBS|WorkRelationship-'||PERSON_NUMBER||'|Worker-'||PERSON_NUMBER||'|'||PERSON_NUMBER||'|'||
			   ORIGINAL_DATE_OF_HIRE||'|Employee|'||LEGAL_EMPLOYER_NAME||'|HIRE||Y|'||ORIGINAL_DATE_OF_HIRE
			FROM XXMX_PER_PPM_WORKER_STG T
           WHERE RECORD_TYPE='HIRE' and person_number in ('29930');

		INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          VALUES (pv_i_file_name,'File Header', workterms_header);

        INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          SELECT UNIQUE pv_i_file_name
		       , 'PPMWorkerData'
			   , 'MERGE|WorkTerms|ET'||PERSON_NUMBER||'|ET'||PERSON_NUMBER||'|EBS|Workterms-ET'||PERSON_NUMBER||
			   '|WorkRelationship-'||PERSON_NUMBER||'|Worker-'||PERSON_NUMBER||'|'||ORIGINAL_DATE_OF_HIRE||'|4712/12/31|'
			   ||PERSON_NUMBER||'|1|Y|'||ORIGINAL_DATE_OF_HIRE||'|HIRE||ACTIVE_PROCESS|'||bg_name||'|'
			FROM XXMX_PER_PPM_WORKER_STG T
           WHERE RECORD_TYPE='HIRE' and person_number in ('29930');

		INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          VALUES (pv_i_file_name,'File Header', workasg_header);

        INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          SELECT UNIQUE pv_i_file_name
		       , 'PPMWorkerData'
			   , 'MERGE|Assignment|E'||PERSON_NUMBER||'|Position '||SUBSTR(POSITION_CODE,13)||'|ET'||PERSON_NUMBER||'|EBS|Assignment-E'||PERSON_NUMBER||
			   '|Workterms-ET'||PERSON_NUMBER||'|WorkRelationship-'||PERSON_NUMBER||'|Worker-'||PERSON_NUMBER||'|'||ORIGINAL_DATE_OF_HIRE
			   ||'|4712/12/31|'||PERSON_NUMBER||'|1|Y|'||ORIGINAL_DATE_OF_HIRE||'|HIRE||E|'||LEGAL_EMPLOYER_NAME||'|Y|ACTIVE_PROCESS|'
			   ||bg_name||'|E||EMP||||'||POSITION_CODE
			FROM XXMX_PER_PPM_WORKER_STG T
           WHERE RECORD_TYPE='HIRE'
           and person_number in ('29930');

     COMMIT;
    END generate_ppm_worker_hire_hdl;
---------------------------------------------------------------------------
procedure generate_ppm_worker_glbtransfer_hdl
IS

    nwh_wr_header   VARCHAR2(10000) :=
   	'METADATA|WorkRelationship|PersonNumber|DateStart|PrimaryFlag|LegalEmployerName|WorkerType|GlobalTransferFlag|ActionCode|SourceSystemOwner|SourceSystemId';
    nwh_wt_header     VARCHAR2(10000) := 
    'METADATA|WorkTerms|AssignmentNumber|PersonNumber|LegalEmployerName|DateStart|EffectiveStartDate|EffectiveSequence|EffectiveLatestChange|ActionCode|PersonTypeCode|JobCode|WorkerType|BusinessUnitShortCode|SystemPersonType|AssignmentName|AssignmentType|AssignmentStatusTypeCode|SourceSystemOwner|SourceSystemId|PeriodOfServiceId(SourceSystemId)';
    nwh_asg_header     VARCHAR2(10000) := 
    'METADATA|Assignment|AssignmentNumber|WorkTermsNumber|PersonNumber|LegalEmployerName|DateStart|EffectiveStartDate|EffectiveSequence|EffectiveLatestChange|ActionCode|PersonTypeCode|JobCode|BusinessUnitShortCode|WorkerType|SystemPersonType|AssignmentName|AssignmentType|AssignmentStatusTypeCode|PrimaryAssignmentFlag|SourceSystemOwner|SourceSystemId|PeriodOfServiceId(SourceSystemId)';
    pv_i_file_name VARCHAR2(100) := 'PPM_GLBTrsferWorkerHire.dat';

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
		       , 'PPM_GLB_HireData'
			   , 'MERGE|WorkRelationship|'||PERSON_NUMBER||'|'
               ||TO_CHAR(TO_DATE(EFFECTIVE_START_DATE,'DD/MM/RRRR'),'RRRR/MM/DD')||'|'||'Y|'
               ||LEGAL_EMPLOYER_NAME
               ||'|E|Y|GLB_TRANSFER|EBS|WorkRelationship-'||ASSIGNMENT_NUMBER
            From XXMX_PER_PPM_WORKER_STG stg
         where record_type='GLB_TRANSFER3'  --IN('GLB_TRANSFER','GLB_TRANSFER2','GLB_TRANSFER3','GLB_TRANSFER4')
         and TO_DATE(STG.effective_start_date,'MM/DD/RRRR') in (select min(TO_DATE(effective_start_date,'DD/MM/RRRR')) from 
         XXMX_PER_PPM_WORKER_STG g where record_type='GLB_TRANSFER' 
         AND stg.person_number=g.person_number);

      -- Person WorkTerms
       INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          VALUES (pv_i_file_name,'File Header', nwh_wt_header);

        INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          SELECT UNIQUE pv_i_file_name
		       , 'PPM_GLB_HireData'
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
         from XXMX_PER_PPM_WORKER_STG stg
         where record_type='GLB_TRANSFER3'  --IN('GLB_TRANSFER','GLB_TRANSFER2','GLB_TRANSFER3','GLB_TRANSFER4')
         and TO_DATE(STG.effective_start_date,'MM/DD/RRRR') in (select min(TO_DATE(effective_start_date,'DD/MM/RRRR')) from 
         XXMX_PER_PPM_WORKER_STG g where record_type='GLB_TRANSFER3' 
         AND stg.person_number=g.person_number);

       -- Person Work Assignments
       INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          VALUES (pv_i_file_name,'File Header', nwh_asg_header);

        INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          SELECT UNIQUE pv_i_file_name
		       , 'PPM_GLB_HireData'
               , 'MERGE|Assignment|E'||ASSIGNMENT_NUMBER||'|'
                   ||'ET'||ASSIGNMENT_NUMBER||'|'||PERSON_NUMBER||'|'
                   ||LEGAL_EMPLOYER_NAME||'|'
                   ||TO_CHAR(TO_DATE(EFFECTIVE_START_DATE,'DD/MM/RRRR'),'RRRR/MM/DD')||'|'
                   ||TO_CHAR(TO_DATE(EFFECTIVE_START_DATE,'DD/MM/RRRR'),'RRRR/MM/DD')||
                   '|1|Y|GLB_TRANSFER|Employee||'
                   ||bg_name||'|E|EMP|E'||ASSIGNMENT_NUMBER
                   ||'|E|ACTIVE_PROCESS|Y|EBS|Assignment-E'||ASSIGNMENT_NUMBER||'|'
                   ||'WorkRelationship-'||ASSIGNMENT_NUMBER               
          from XXMX_PER_PPM_WORKER_STG STG
         where record_type='GLB_TRANSFER3' --IN('GLB_TRANSFER','GLB_TRANSFER2','GLB_TRANSFER3','GLB_TRANSFER4')
         and TO_DATE(STG.effective_start_date,'MM/DD/RRRR') in (select min(TO_DATE(effective_start_date,'DD/MM/RRRR')) from 
         XXMX_PER_PPM_WORKER_STG g where record_type='GLB_TRANSFER3' 
         AND stg.person_number=g.person_number);

end generate_ppm_worker_glbtransfer_hdl;
---------------------------------------------------------------------------
PROCEDURE generate_ppm_worker_assignment_hdl
  IS

    wc_terms_header   VARCHAR2(10000) := 'METADATA|WorkTerms|AssignmentNumber|AssignmentName|SourceSystemOwner|SourceSystemId|PeriodOfServiceId(SourceSystemId)|PersonId(SourceSystemId)|EffectiveStartDate|EffectiveEndDate|PersonNumber|EffectiveSequence|EffectiveLatestChange|DateStart|ActionCode|ReasonCode|AssignmentStatusTypeCode|AssignmentType|BusinessUnitShortCode|TaxReportingUnit|PeopleGroup|GradeLadderPgmName';
	wc_asg_header     VARCHAR2(10000) := 'METADATA|Assignment|AssignmentNumber|AssignmentName|WorkTermsNumber|SourceSystemOwner|SourceSystemId|WorkTermsAssignmentId(SourceSystemId)|PeriodOfServiceId(SourceSystemId)|PersonId(SourceSystemId)|EffectiveStartDate|EffectiveEndDate|PersonNumber|EffectiveSequence|EffectiveLatestChange|DateStart|ActionCode|ReasonCode|WorkerType|LegalEmployerName|PrimaryAssignmentFlag|AssignmentStatusTypeCode|BusinessUnitShortCode|AssignmentType|PersonTypeCode|WorkerCategory|AssignmentCategory|FullPartTime|DateProbationEnd|NormalHours|Frequency|PermanentTemporary|JobCode|LocationCode|NoticePeriod|NoticePeriodUOM|HourlySalariedCode|PositionCode|GradeCode|BargainingUnitCode|LabourUnionMemberFlag|ManagerFlag|SystemPersonType|TaxReportingUnit|PeopleGroup|GradeLadderPgmName|ReportingEstablishment|PositionOverrideFlag|DefaultExpenseAccount|FLEX:PER_ASG_DF|headCountClassification(PER_ASG_DF=Global Data Elements)|payrollProviderId(PER_ASG_DF=Global Data Elements)|companyRecharge_Display(PER_ASG_DF=Global Data Elements)';
    pv_i_file_name VARCHAR2(100) := 'PPM_WorkerCurrent.dat';

	BEGIN
	    DELETE FROM xxmx_hdl_file_temp WHERE FILE_NAME = pv_i_file_name;
		COMMIT;

	    INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          VALUES (pv_i_file_name,'File Header', wc_terms_header);

        INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          SELECT UNIQUE pv_i_file_name
		       , 'PPMWorkCurrentData'
			   , 'MERGE|WorkTerms|ET'||ASSIGNMENT_NUMBER||'|ET'||ASSIGNMENT_NUMBER||'|EBS|Workterms-ET'||ASSIGNMENT_NUMBER||
			   '|WorkRelationship-'||ASSIGNMENT_NUMBER||'|Worker-'||PERSON_NUMBER||'|'||TO_CHAR(TO_DATE(EFFECTIVE_START_DATE,'DD/MM/RRRR'),'RRRR/MM/DD')||'|'||
			   TO_CHAR(TO_DATE(EFFECTIVE_END_DATE,'DD/MM/RRRR'),'RRRR/MM/DD')||'|'||PERSON_NUMBER||'|1|Y|'||ORIGINAL_DATE_OF_HIRE||
			   '|ASG_CHANGE||ACTIVE_PROCESS|ET|'||bg_name||'|||'
			FROM XXMX_PER_PPM_WORKER_STG STG
           WHERE RECORD_TYPE IN ('ASG_CHANGE','GLB_TRANSFER','GLB_TRANSFER2','GLB_TRANSFER3');
        --ORDER BY TO_NUMBER(STG.PERSON_NUMBER),TO_DATE(STG.EFFECTIVE_START_DATE,'DD/MM/RRRR');

        INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          VALUES (pv_i_file_name,'File Header', wc_asg_header);

        INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          SELECT UNIQUE pv_i_file_name
		       , 'PPMWorkCurrentData'
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
                   '|E|||FR|||'||NORMAL_HOURS||'|W|R||'||STG.LOCATION_CODE||
                   '||||'||STG.POSITION_CODE||
                   '|||N|Y|EMP|||||Y|'
				   ||default_expense_account||
                    '|Global Data Elements|'
					||ASS_ATTRIBUTE2||'|' --head_count_class
					||ASS_ATTRIBUTE3||'|' -- payroll_providerid
                    ||ASS_ATTRIBUTE4           -- companyofrecharge
			FROM XXMX_PER_PPM_WORKER_STG STG
           WHERE RECORD_TYPE IN ('ASG_CHANGE','GLB_TRANSFER','GLB_TRANSFER2','GLB_TRANSFER3');
        --ORDER BY TO_NUMBER(STG.PERSON_NUMBER),TO_DATE(STG.EFFECTIVE_START_DATE,'DD/MM/RRRR');

     COMMIT;
    END generate_ppm_worker_assignment_hdl;
---------------------------------------------------------------------
PROCEDURE generate_ppm_worker_termination_hdl
  IS

    wt_header   VARCHAR2(10000) := 'METADATA|WorkRelationship|SourceSystemOwner|SourceSystemId|PersonId(SourceSystemId)|ActionCode|TerminateWorkRelationshipFlag|ActualTerminationDate|LastWorkingDate';
    pv_i_file_name VARCHAR2(100) := 'PPM_Worker_Termination.dat';

	BEGIN
	    DELETE FROM xxmx_hdl_file_temp WHERE FILE_NAME = pv_i_file_name;
		COMMIT;

	    INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          VALUES (pv_i_file_name,'File Header', wt_header);

        INSERT INTO xxmx_hdl_file_temp (file_name,line_type,line_content)
          SELECT UNIQUE pv_i_file_name
		       , 'PPMWorkTerminationData'
			   , 'MERGE|WorkRelationship|EBS|WorkRelationship-'||PERSON_NUMBER||
                  '|Worker-'||PERSON_NUMBER||'|CITCO_VOLUNTARY_TERMINATION|Y|'||
                  TO_CHAR(TO_DATE(TERMINATION_DATE,'MM/DD/RRRR'),'RRRR/MM/DD')||
                  '|'||TO_CHAR(TO_DATE(TERMINATION_DATE,'MM/DD/RRRR'),'RRRR/MM/DD')
			FROM XXMX_PER_PPM_WORKER_STG STG
            WHERE 1=1
            AND RECORD_TYPE IN ('TERMINATION');
   COMMIT;
END generate_ppm_worker_termination_hdl;
----------------------------------------------------------------------
 END xxmx_kit_ppm_worker_stg;

/
