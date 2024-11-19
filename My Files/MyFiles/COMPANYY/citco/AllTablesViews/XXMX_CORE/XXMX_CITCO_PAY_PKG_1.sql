--------------------------------------------------------
--  DDL for Package Body XXMX_CITCO_PAY_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "XXMX_CORE"."XXMX_CITCO_PAY_PKG" AS 

    gcv_PackageName                           CONSTANT  VARCHAR2(30)                                := 'XXMX_CITCO_PAY_PKG';
    gct_ApplicationSuite                      CONSTANT  xxmx_module_messages.application_suite%TYPE := 'HCM';
    gct_Application                           CONSTANT  xxmx_module_messages.application%TYPE       := 'PAY';
    gv_i_BusinessEntity                       CONSTANT  VARCHAR2(100)                               := 'PAYROLL';
    ct_Phase                                  CONSTANT  xxmx_module_messages.phase%TYPE             := 'EXTRACT';
    cv_i_BusinessEntityLevel                  CONSTANT  VARCHAR2(100)                               := 'ALL';
    gv_hr_date					              DATE                                                  := '31-DEC-4712';

    gvv_ReturnStatus                          VARCHAR2(1); 
    gvv_ProgressIndicator                     VARCHAR2(100); 
    gvn_RowCount                              NUMBER;
    gvt_ReturnMessage                         xxmx_module_messages .module_message%TYPE;
    gvt_Severity                              xxmx_module_messages .severity%TYPE;
    gvt_OracleError                           xxmx_module_messages .oracle_error%TYPE;
    gvt_ModuleMessage                         xxmx_module_messages .module_message%TYPE;
    e_ModuleError                             EXCEPTION;

	 gvv_migration_date_to                     VARCHAR2(30); 
    gvv_migration_date_from                   VARCHAR2(30); 
    gvv_prev_tax_year_date                    VARCHAR2(30);         
    gvd_migration_date_to                     DATE;  
    gvd_migration_date_from                   DATE;
    gvd_prev_tax_year_date                    DATE;



 PROCEDURE export_PAY_ELEM_ENTRIES
   (p_bg_name                      IN      varchar2
    ,p_bg_id                        IN      number
    ,pt_i_MigrationSetID            IN      xxmx_migration_headers.migration_set_id%TYPE
    ,pt_i_MigrationSetName          IN      xxmx_migration_headers.migration_set_name%TYPE )
	IS
		cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'XXMX_CITCO_PAY_PKG'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_PAY_ELE_ENTRY_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'ELEMENT_ENTRIES';

        e_DateError                         EXCEPTION;

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
            xxmx_utilities_pkg.log_module_message(  
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
                ,pt_i_OracleError         => gvt_ReturnMessage    );
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
            xxmx_utilities_pkg.log_module_message
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
                );
            --
            RAISE e_ModuleError;
        END IF;
        --
        --        
        gvv_ProgressIndicator := '0010';
        xxmx_utilities_pkg.log_module_message(  
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
                ,pt_i_OracleError         => gvt_ReturnMessage  );
        --   
        DELETE 
        FROM    XXMX_PAY_ELE_ENTRY_STG    
        WHERE   bg_id    = p_bg_id    ;

        COMMIT;
        --


        INSERT INTO XXMX_PAY_ELE_ENTRY_STG
		(migration_set_id  ,
		migration_set_name,                   
		migration_status  ,
		bg_name           ,
		bg_id,
		ELEMENT_NAME,
		EFFECTIVE_START_DATE,
		EFFECTIVE_END_DATE,
		ASSIGNMENT_NUMBER,
        IV_NAME,
        ENTRY_TYPE,
        EMPLOYEE_NUMBER,
		SCREEN_ENTRY_VALUE,
        DISPLAY_SEQUENCE)
        SELECT 
		pt_i_MigrationSetID  ,                             
		pt_i_MigrationSetName,                              
		'EXTRACTED'          ,
		p_bg_name            ,
		p_bg_id              ,
		ELEMENT_NAME,
		EFFECTIVE_START_DATE,
		EFFECTIVE_END_DATE,
		ASSIGNMENT_NUMBER,
        iv_name as IV_name,
        'E',
        EMPLOYEE_NUMBER,
		SCREEN_ENTRY_VALUE,
        DISPLAY_SEQUENCE
		from  
		xxmx_pay_ele_vals_mv
        where lower(iv_name) like '%amount%'
		and ELEMENT_NAME not LIKE 'CITCO BEN%';

        COMMIT;

		 gvv_ProgressIndicator := '0030';
        xxmx_utilities_pkg.log_module_message(  
                        pt_i_ApplicationSuite    => gct_ApplicationSuite
                        ,pt_i_Application         => gct_Application
                        ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                        ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                        ,pt_i_Phase               => ct_Phase
                        ,pt_i_Severity            => 'NOTIFICATION'
                        ,pt_i_PackageName         => gcv_PackageName
                        ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                        ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                        ,pt_i_ModuleMessage       => 'End of extraction at ' || to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS.FF2') || '. Procedure completed'
                        ,pt_i_OracleError         => gvt_ReturnMessage       );     

    EXCEPTION
        WHEN e_ModuleError THEN
                --
        xxmx_utilities_pkg.log_module_message(  
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
                    ,pt_i_OracleError         => gvt_ReturnMessage       );     
            --
            RAISE;
            --** END e_ModuleError Exception
            --
        WHEN e_DateError THEN
                --
        xxmx_utilities_pkg.log_module_message(  
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                    ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_Severity            => 'ERROR'
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => 'From, to or Prev Tax Year variable not populated'  
                    ,pt_i_OracleError         => gvt_ReturnMessage       );     
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
            xxmx_utilities_pkg.log_module_message(  
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
                    ,pt_i_OracleError         => gvt_OracleError       );     
            --
            RAISE;
            -- Hr_Utility.raise_error@XXMX_EXTRACT;
       END export_PAY_ELEM_ENTRIES;
--
    PROCEDURE generate_pay_ee_hdl 
    IS
    ee_header     VARCHAR2(10000) := 'METADATA|ElementEntry|EffectiveStartDate|EffectiveEndDate|ElementName|LegislativeDataGroupName|EntryType|CreatorType|AssignmentNumber|SourceSystemOwner|SourceSystemId';
    eev_header      VARCHAR2(10000) := 'METADATA|ElementEntryValue|EffectiveStartDate|EffectiveEndDate|InputValueName|ScreenEntryValue|AssignmentNumber|ElementName|LegislativeDataGroupName|ElementEntryId(SourceSystemId)|SourceSystemOwner|SourceSystemId';
    pv_i_file_name VARCHAR2(100) := 'ElementEntry.dat';

    BEGIN

DELETE FROM  xxmx_hdl_file_temp WHERE FILE_NAME = 'ElementEntry.dat';


     INSERT INTO  xxmx_hdl_file_temp (file_name,line_type,line_content)
           VALUES (pv_i_file_name,'File Header', ee_header);



    insert INTO xxmx_hdl_file_temp(file_name,line_type,line_content)
       SELECT
        'ElementEntry.dat'  file_name,
        'Element Entry' line_type,
        'MERGE'
        || '|'
        ||
        'ElementEntry'
        || '|'
        || TO_CHAR(stg.effective_start_date,'YYYY/MM/DD')
        || '|'
        || TO_CHAR(stg.effective_end_date,'YYYY/MM/DD')
        || '|'||
        CASE WHEN ELEMENT_NAME LIKE 'CITCO%'
                           THEN CASE WHEN ELEMENT_NAME LIKE 'CITCO BEN EE Allowance%'
                                     THEN REPLACE(ELEMENT_NAME,'CITCO BEN EE Allowance ','CITCO BEN EE Allowance - ')
                                     WHEN ELEMENT_NAME LIKE 'CITCO BEN ER Reimbursement%'
                                     THEN REPLACE(ELEMENT_NAME,'CITCO BEN ER Reimbursement ','CITCO BEN ER Reimbursement - ')
                                     ELSE ELEMENT_NAME
                                     END
                           ELSE 'CITCO '||decode(element_name,'Annual Bonus USA','Annual Bonus United States'
                                                             , 'Annual Bonus UK','Annual Bonus Guernsey'
                                                             ,'Annual Bonus BVI','CITCO Annual Bonus British Virgin Islands'
                                                             ,element_name)
                           END
        || '|' 
        || substr(STG.bg_name,1,2)||' Legislative Data Group'
        || '|'
        || entry_type
        || '|'
        || 'H|E'
        || STG.assignment_number 
        || '|'
        || 'EBS'--SourceSystemOwner
        || '|'
        || 'ElementEntry-E' || STG.assignment_number||'-CITCO '||element_name||'-'||stg.effective_start_date
    FROM
        xxmx_pay_ele_entry_stg stg,  XXMX_XFM.xxmx_per_assignments_m_xfm asg        
        where asg.assignment_number in (select assignment_number from XXMX_HR_HCM_FILE_SET_V1 where action_code = 'CURRENT')
        and asg.personnumber  = stg.employee_number 
        and asg.action_code = 'CURRENT';
      --  WHERE element_name IN ('Annual Bonus India') 
        --and employee_number = '20408'
       /* and stg.assignment_number in (
        select assignment_number from (
            select count(*), assignment_number
             FROM
                    xxmx_pay_ele_entry_stg
                    WHERE element_name IN ('Annual Bonus India')
                    group by assignment_number
                    having count( *) > 1 )
        )*/



     INSERT INTO  xxmx_hdl_file_temp (file_name,line_type,line_content)
           VALUES (pv_i_file_name,'File Header', eev_header);    

    insert INTO xxmx_hdl_file_temp(file_name,line_type,line_content)
    SELECT
        'ElementEntry.dat'  file_name,
        'Element Entry Value' line_type,
        'MERGE'
        || '|'
        || 'ElementEntryValue'
        || '|'
        || TO_CHAR(stg.effective_start_date,'YYYY/MM/DD')
        || '|'
        || TO_CHAR(stg.effective_start_date,'YYYY/MM/DD')
        || '|'
        || iv_name
        || '|' 
        ||screen_entry_value
        || '|E'
        || STG.assignment_number
        || '|'||
        CASE WHEN ELEMENT_NAME LIKE 'CITCO%'
                           THEN CASE WHEN ELEMENT_NAME LIKE 'CITCO BEN EE Allowance%'
                                     THEN REPLACE(ELEMENT_NAME,'CITCO BEN EE Allowance ','CITCO BEN EE Allowance - ')
                                     WHEN ELEMENT_NAME LIKE 'CITCO BEN ER Reimbursement%'
                                     THEN REPLACE(ELEMENT_NAME,'CITCO BEN ER Reimbursement ','CITCO BEN ER Reimbursement - ')
                                     ELSE ELEMENT_NAME
                                     END
                           ELSE 'CITCO '||decode(element_name,'Annual Bonus USA','Annual Bonus United States'
                                                             ,'Annual Bonus UK','Annual Bonus Guernsey'
                                                             ,'Annual Bonus BVI','CITCO Annual Bonus British Virgin Islands'
                                                             ,element_name)
                           END
        || '|' 
        || substr(STG.bg_name,1,2)||' Legislative Data Group'
        || '|'
        || 'ElementEntry-E' || STG.assignment_number||'-CITCO '||element_name||'-'||stg.effective_start_date
        || '|'
        || 'EBS'
        || '|'
        || 'ElementEntryValue-E' || STG.assignment_number||'-CITCO '||element_name||'-'||'-'||iv_name||'-'||stg.effective_start_date
   FROM
        xxmx_pay_ele_entry_stg stg,  XXMX_XFM.xxmx_per_assignments_m_xfm asg        
        where asg.assignment_number in (select assignment_number from XXMX_HR_HCM_FILE_SET_V1 where action_code = 'CURRENT')
        and asg.personnumber  = stg.employee_number 
        and asg.action_code = 'CURRENT';
             --  WHERE element_name IN ('Annual Bonus India')
               --and employee_number = '20408'
        /*and stg.assignment_number in ( 
        select assignment_number from (
            select count(*), assignment_number 
             FROM
                    xxmx_pay_ele_entry_stg
                    WHERE element_name IN ('Annual Bonus India')
                    group by assignment_number
                    having count( *) > 1 )
        )*/


    --METADATA|ElementEntry|EffectiveEndDate|EffectiveStartDate|ElementName|LegislativeDataGroupName|MultipleEntryCount|EntryType|AssignmentNumber|SourceSystemOwner|SourceSystemId|ReplaceLastEffectiveEndDate

    --MERGE|ElementEntry|4712/12/31|2021/04/06|Housing Allowance Expat|US Legislative Data Group||E|XXTEST_ASSIGN1|XXTEST|XXTEST_ENTRY2|

    --METADATA|ElementEntryValue|EffectiveEndDate|EffectiveStartDate|InputValueName|ScreenEntryValue|AssignmentNumber|ElementName|LegislativeDataGroupName|ElementEntryId(SourceSystemId)|SourceSystemOwner|SourceSystemId|ReplaceLastEffectiveEndDate

    --MERGE|ElementEntryValue|4712/12/31|2021/04/06|Periodicity|PRD|XXTEST_ASSIGN1|Housing Allowance Expat|US Legislative Data Group|XXTEST_ENTRY2|XXTEST|XXTEST_ENTRYVALUE4|


    Commit;
    END generate_pay_ee_hdl;
--



END XXMX_CITCO_PAY_PKG;

/
