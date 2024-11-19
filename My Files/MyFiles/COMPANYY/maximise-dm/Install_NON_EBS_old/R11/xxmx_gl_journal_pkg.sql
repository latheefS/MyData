create or replace package xxmx_gl_journal_pkg as 

    /****************************************************************	
	----------------Export GL Journal--------------------------------
	*****************************************************************/
    PROCEDURE stg_main 
        (
         pt_i_ClientCode                    IN          xxmx_client_config_parameters.client_code%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) ;

    PROCEDURE export_gl_journal
        (
          pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
         ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE );  
 

end xxmx_gl_journal_pkg;

/

create or replace PACKAGE BODY xxmx_gl_journal_pkg AS 
--*****************************************************************************
--**
--**                 Copyright (c) 2020 Version 1
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
--** FILENAME  :  xxmx_po_pkg.pkb
--**
--** FILEPATH  :  $XXV1_TOP/install/sql
--**
--** VERSION   :  1.0
--**
--** EXECUTE
--** IN SCHEMA :  XXMX_STG
--**
--** AUTHORS   :  Shaik Latheef
--**
--** PURPOSE   :  This package contains procedures for extracting Purchase Order into Staging tables

	/****************************************************************	
	----------------Export GL Journal Information--------------------
	****************************************************************/
    gvv_ReturnStatus                          VARCHAR2(1); 
    gvt_ReturnMessage                         xxmx_module_messages.module_message%TYPE;
    gvv_ProgressIndicator                     VARCHAR2(100); 
    gcv_PackageName                           CONSTANT  VARCHAR2(30)                                := 'xxmx_gl_journal_pkg';
    gct_ApplicationSuite                      CONSTANT  xxmx_module_messages.application_suite%TYPE := 'FIN';
    gct_Application                           CONSTANT  xxmx_module_messages.application%TYPE       := 'GL';
    gv_i_BusinessEntity                       CONSTANT  VARCHAR2(100)                               := 'GENERAL_LEDGER';
    ct_Phase                                  CONSTANT  xxmx_module_messages.phase%TYPE             := 'EXTRACT';
    cv_i_BusinessEntityLevel                  CONSTANT  VARCHAR2(100)                               := 'ALL';
    gvt_MigrationSetName                                xxmx_migration_headers.migration_set_name%TYPE;
    gv_hr_date					              DATE                                                  := '31-DEC-4712';
    p_bg_name  								  VARCHAR2(100)                                         := 'TEST_BG'; 
    gvt_Severity                              xxmx_module_messages.severity%TYPE;
    gvt_ModuleMessage                         xxmx_module_messages.module_message%TYPE;
    gvt_OracleError                           xxmx_module_messages.oracle_error%TYPE;
    gvn_RowCount                                NUMBER;
    gct_StgSchema                                VARCHAR2(30)       := 'XXMX_STG';
    E_MODULEERROR                             EXCEPTION;
    e_DateError                               EXCEPTION;


PROCEDURE stg_main (pt_i_ClientCode                 IN      xxmx_client_config_parameters.client_code%TYPE
                   ,pt_i_MigrationSetName           IN      xxmx_migration_headers.migration_set_name%TYPE ) 
IS 

        CURSOR METADATA_CUR
        IS
            SELECT	Entity_package_name,Stg_procedure_name, BUSINESS_ENTITY,SUB_ENTITY_SEQ,sub_entity
			FROM	xxmx_migration_metadata a 
			WHERE	application_suite = gct_ApplicationSuite
            AND		Application = gct_Application
			AND 	BUSINESS_ENTITY = gv_i_BusinessEntity
			AND 	a.enabled_flag = 'Y'
            Order by Business_entity_seq, Sub_entity_seq;

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'stg_main'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'xxmx_gl_journal_stg';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'GENERAL_LEDGER';
        vt_MigrationSetID                               xxmx_migration_headers.migration_set_id%TYPE;
        lv_sql                                          VARCHAR2(32000);
BEGIN 

-- setup
        --
        gvv_ReturnStatus  := '';
        gvv_ProgressIndicator := '0000';
        xxmx_utilities_pkg.clear_messages
            (
             pt_i_ApplicationSuite    => gct_ApplicationSuite
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
                    ,pt_i_ModuleMessage       => 'Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'    
                    ,pt_i_OracleError         => gvt_ReturnMessage
                );
            --
            RAISE e_ModuleError;
            --
        END IF;
        --
        --
        gvv_ProgressIndicator := '0010';
        /* Migration Set ID Generation*/
        xxmx_utilities_pkg.init_migration_set
            (
             pt_i_ApplicationSuite  => gct_ApplicationSuite
            ,pt_i_Application       => gct_Application
            ,pt_i_BusinessEntity    => gv_i_BusinessEntity
            ,pt_i_MigrationSetName  => pt_i_MigrationSetName
            ,pt_o_MigrationSetID    => vt_MigrationSetID
            );

         --
         gvv_ProgressIndicator :='0015';
        xxmx_utilities_pkg.log_module_message(  
                         pt_i_ApplicationSuite    => gct_ApplicationSuite
                        ,pt_i_Application         => gct_Application
                        ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                        ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                        ,pt_i_migrationsetid      => vt_MigrationSetID
                        ,pt_i_Phase               => ct_Phase
                        ,pt_i_Severity            => 'NOTIFICATION'
                        ,pt_i_PackageName         => gcv_PackageName
                        ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                        ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                        ,pt_i_ModuleMessage       => 'Migration Set "'
                                    ||pt_i_MigrationSetName
                                    ||'" initialized (Generated Migration Set ID = '
                                    ||vt_MigrationSetID
                                    ||').  Processing extracts:'       
                        ,pt_i_OracleError         => NULL
            );
        --
        --
        --main

        gvv_ProgressIndicator := '0020';
        xxmx_utilities_pkg.log_module_message(  
             pt_i_ApplicationSuite    => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_migrationsetid      => vt_MigrationSetID
            ,pt_i_Phase               => ct_Phase
            ,pt_i_Severity            => 'NOTIFICATION'
            ,pt_i_PackageName         => gcv_PackageName
            ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
            ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
            ,pt_i_ModuleMessage       => 'Parameter for Irec Extract'
            ,pt_i_OracleError         => NULL
        );

      --


        gvv_ProgressIndicator := '0025';
        xxmx_utilities_pkg.log_module_message(  
             pt_i_ApplicationSuite    => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_migrationsetid      => vt_MigrationSetID
            ,pt_i_Phase               => ct_Phase
            ,pt_i_Severity            => 'NOTIFICATION'
            ,pt_i_PackageName         => gcv_PackageName
            ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
            ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
            ,pt_i_ModuleMessage       => 'Call to Irecruitment Extracts'
            ,pt_i_OracleError         => NULL
        );

        FOR METADATA_REC IN METADATA_CUR -- 2
        LOOP

--                dbms_output.put_line(' #' ||r_package_name.v_package ||' #'|| l_bg_name || '  #' || l_bg_id || '  #' || vt_MigrationSetID || '  #' || pt_i_MigrationSetName  );

                    lv_sql:= 'BEGIN '
                            ||METADATA_REC.Entity_package_name
                            ||'.'||METADATA_REC.Stg_procedure_name
                            ||'('
                            ||vt_MigrationSetID
                            ||','''
                            ||METADATA_REC.sub_entity
                            ||''''||'); END;'
                            ;

                    EXECUTE IMMEDIATE lv_sql ;

                    gvv_ProgressIndicator := '0030';
                    xxmx_utilities_pkg.log_module_message(  
                         pt_i_ApplicationSuite    => gct_ApplicationSuite
                        ,pt_i_Application         => gct_Application
                        ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                        ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                        ,pt_i_migrationsetid      => vt_MigrationSetID
                        ,pt_i_Phase               => ct_Phase
                        ,pt_i_Severity            => 'NOTIFICATION'
                        ,pt_i_PackageName         => gcv_PackageName
                        ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                        ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                        ,pt_i_ModuleMessage       => lv_sql 
                        ,pt_i_OracleError         => NULL
                     );
                    DBMS_OUTPUT.PUT_LINE(lv_sql);

        END LOOP; 

		COMMIT;

    EXCEPTION
        WHEN e_ModuleError THEN
                --
        xxmx_utilities_pkg.log_module_message(  
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                    ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                    ,pt_i_migrationsetid      => vt_MigrationSetID
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
                    ,pt_i_migrationsetid      => vt_MigrationSetID
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
                    ,pt_i_migrationsetid      => vt_MigrationSetID
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_Severity            => 'ERROR'
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => 'Oracle error encounted at after Progress Indicator.'  
                    ,pt_i_OracleError         => gvt_OracleError       );     
            --
            RAISE;
            -- Hr_Utility.raise_error@MXDM_NVIS_EXTRACT;

END stg_main;	


	/****************************************************************	
	----------------Export GL JOURNAL----------------------------
	****************************************************************/

    PROCEDURE export_gl_journal
          (
         pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
         ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE ) 
         IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_gl_journal'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'xxmx_gl_journal_stg';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'GENERAL_LEDGER';

        lvv_migration_date_to                           VARCHAR2(30); 
        lvv_migration_date_from                         VARCHAR2(30); 
        lvv_prev_tax_year_date                          VARCHAR2(30);         
        lvd_migration_date_to                           DATE;  
        lvd_migration_date_from                         DATE;
        lvd_prev_tax_year_date                          DATE;  

        e_DateError                         EXCEPTION;
    BEGIN
        --
        gvv_ReturnStatus  := '';
        gvt_ReturnMessage := '';
        gvv_ProgressIndicator := '0000';
        xxmx_utilities_pkg.clear_messages
            (pt_i_ApplicationSuite    => gct_ApplicationSuite
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
        FROM    xxmx_gl_journal_stg    
          ;

        COMMIT;
        --
        --

        gvv_ProgressIndicator := '0020';
        --
        gvt_MigrationSetName := xxmx_utilities_pkg.get_migration_set_name(pt_i_MigrationSetID);
        --
        /*
        ** If the Migration Set Name is NULL then the Migration has not been initialized.
        */
        --
        IF   gvt_MigrationSetName IS NOT NULL
        THEN
            --
            gvv_ProgressIndicator := '0030';
            --
            xxmx_utilities_pkg.log_module_message
                 (
                  pt_i_ApplicationSuite  => gct_ApplicationSuite
                 ,pt_i_Application       => gct_Application
                 ,pt_i_BusinessEntity    => gv_i_BusinessEntity
                 ,pt_i_SubEntity         => cv_i_BusinessEntityLevel
                 ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                 ,pt_i_Phase             => ct_Phase
                 ,pt_i_Severity          => 'NOTIFICATION'
                 ,pt_i_PackageName       => gcv_PackageName
                 ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                 ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                 ,pt_i_ModuleMessage     => '- Extracting "'
                                          ||pt_i_SubEntity
                                          ||'":'
                 ,pt_i_OracleError       => NULL
                 );
            --
            /*
            ** The Migration Set has been initialised, so now initialize the detail record
            ** for the current entity.
            */
            --
            --** ISV 21/10/2020 - Removed Sequence Number parameters as the procedure will now determine the correct values from the metadata
            --**                  table based on the Application Suite, Application and Business Entity parameters.
            --**
            --**                  Removed "entity" from procedure_name.
            --
            xxmx_utilities_pkg.init_migration_details
                 (
                  pt_i_ApplicationSuite => gct_ApplicationSuite
                 ,pt_i_Application      => gct_Application
                 ,pt_i_BusinessEntity   => gv_i_BusinessEntity
                 ,pt_i_SubEntity        => cv_i_BusinessEntityLevel
                 ,pt_i_MigrationSetID   => pt_i_MigrationSetID
                 ,pt_i_StagingTable     => cv_StagingTable
                 ,pt_i_ExtractStartDate => SYSDATE
                 );
            --
            --** ISV 21/10/2020 - "pt_i_StagingTable" no longer needs to be passed as a parameter from the STG_MAIN procedure
            --**                  as the table name will never change so replace with new constant "ct_StgTable".
            --
            --**                  We will still keep the table name in the Metadata table as that can be used for reporting
            --**                  purposes.
            --
            xxmx_utilities_pkg.log_module_message
                 (
                  pt_i_ApplicationSuite  => gct_ApplicationSuite
                 ,pt_i_Application       => gct_Application
                 ,pt_i_BusinessEntity    => gv_i_BusinessEntity
                 ,pt_i_SubEntity         => cv_i_BusinessEntityLevel
                 ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                 ,pt_i_Phase             => ct_Phase
                 ,pt_i_Severity          => 'NOTIFICATION'
                 ,pt_i_PackageName       => gcv_PackageName
                 ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                 ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                 ,pt_i_ModuleMessage     => '  - Staging Table "'
                                          ||cv_StagingTable
                                          ||'" reporting details initialised.'
                 ,pt_i_OracleError       => NULL
                 );
            --
            gvv_ProgressIndicator := '0040';
            --
            --** Extract the data and insert into the staging table.
            --
            xxmx_utilities_pkg.log_module_message
                 (
                  pt_i_ApplicationSuite  => gct_ApplicationSuite
                 ,pt_i_Application       => gct_Application
                 ,pt_i_BusinessEntity    => gv_i_BusinessEntity
                 ,pt_i_SubEntity         => cv_i_BusinessEntityLevel
                 ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                 ,pt_i_Phase             => ct_Phase
                 ,pt_i_Severity          => 'NOTIFICATION'
                 ,pt_i_PackageName       => gcv_PackageName
                 ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                 ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                 ,pt_i_ModuleMessage     => '  - Extracting data into "'
                                          ||cv_StagingTable
                                          ||'".'
                 ,pt_i_OracleError       => NULL
                 );
            --
            --** ISV 21/10/2020 - The staging table is in the xxmx_stg schema but should not need to be prefixed as there should
            --**                  by a Synonym in the xxmx_core schema to that table.
            --





           INSERT  
           INTO    xxmx_gl_journal_stg
                  (migration_set_id					,
               migration_set_name					,
               migration_status					,
               batch_id							,	
               status								,
               ledger_id                 		 	, 	 	
               accounting_date 					,
               user_je_source_name              	,		
               user_je_category_name           	,
               currency_code  						,
               date_created     					,
               actual_flag     					,
               segment1                        	,
               segment2                        	,
               segment3                        	,
               segment4                        	,
               segment5                        	,
               segment6                        	,
               segment7                        	,
               segment8                        	,
               segment9                        	,
               segment10                       	,
               segment11                       	,
               segment12                       	,
               segment13                       	,
               segment14                       	,
               segment15                       	,
               segment16                       	,
               segment17                       	,
               segment18                       	,
               segment19                       	,
               segment20                       	,
               segment21                       	,
               segment22                       	,
               segment23                       	,
               segment24                       	,
               segment25                       	,
               segment26                       	,
               segment27                       	,
               segment28                       	,
               segment29                       	,
               segment30                       	,
               entered_dr							,
               entered_cr							,
               accounted_dr						,
               accounted_cr 						,
               reference1    						,                  	
               reference2     						,                 	
               reference3      					,                	
               reference4       					,               	
               reference5        					,              	
               reference6         					,             	
               reference7          				,            	
               reference8           				,           	
               reference9            				,          	
               reference10            				,         	
               stat_amount    				 		,
               user_currency_conversion_type		,
               currency_conversion_date			,
               currency_conversion_rate			,
               group_id                        	,	
               attribute_category 					,
               attribute1							,
               attribute2							,
               attribute3							,
               attribute4							,
               attribute5							,
               attribute6							,
               attribute7							,
               attribute8							,
               attribute9							,
               attribute10							,
               attribute11							,
               attribute12							,
               attribute13							,
               attribute14							,
               attribute15							,
               attribute16							,
               attribute17							,
               attribute18							,
               attribute19							,
               attribute20							,
               attribute_category3					,
               originating_bal_seg_value       	,
               ledger_name							,
               encumbrance_type_id					,
               jgzz_recon_ref                  	,
               period_name 						,
               attribute_date1						,
               attribute_date2						,
               attribute_date3						,
               attribute_date4						,
               attribute_date5						,
               attribute_date6						,
               attribute_date7						,
               attribute_date8						,
               attribute_date9						,
               attribute_date10					,
               attribute_number1					,
               attribute_number2					,
               attribute_number3					,
               attribute_number4					,
               attribute_number5					,
               attribute_number6					,
               attribute_number7					,
               attribute_number8					,
               attribute_number9					,
               attribute_number10					,
               global_attribute_category			,
               global_attribute1					,
               global_attribute2					,
               global_attribute3					,
               global_attribute4					,
               global_attribute5					,
               global_attribute6					,
               global_attribute7					,
               global_attribute8					,
               global_attribute9					,
               global_attribute10					,
               global_attribute11					,
               global_attribute12					,
               global_attribute13					,
               global_attribute14					,
               global_attribute15					,
               global_attribute16					,
               global_attribute17					,
               global_attribute18					,
               global_attribute19					,
               global_attribute20					,
               global_attribute_date1				,
               global_attribute_date2				,
               global_attribute_date3				,
               global_attribute_date4				,
               global_attribute_date5				,
               global_attribute_number1			,
               global_attribute_number2			,
               global_attribute_number3			,
               global_attribute_number4			,
               global_attribute_number5
            )

                    SELECT  distinct pt_i_MigrationSetID      														--migration_set_id                         
                   ,gvt_MigrationSetName                               													--migration_set_name
                   ,'EXTRACTED'                               														--migration_status
               ,pt_i_MigrationSetID															--batch_id
               ,'NEW'																	--status
               ,jlh.ledger_id																--ledger_id
               ,gp.end_date																--accounting_date
   --xxsh comment out				,(
   --                        SELECT  xgss.gl_bal_fusion_jrnl_source
   --                        FROM    xxmx_gl_source_structures  xgss
   --                        WHERE   1 = 1
   --                        AND     xgss.source_ledger_name = gl.name
   --                       )																		--user_je_source_name
                   ,gjst.user_je_source_name                                                                                                                               --user_je_source_name  --xxsh BS want unmapped value
                   ,gjct.user_je_category_name                                                                                                                             --user_je_category_name  --xxsh BS want unmapped value

   --xxsh comment out				,(
   --                        SELECT  xgss.gl_bal_fusion_jrnl_category
   --                        FROM    xxmx_gl_source_structures  xgss
   --                        WHERE   1 = 1
   --                        AND     xgss.source_ledger_name = gl.name
   --                       )																		--user_je_category_name
               ,jlh.currency_code															--currency_code
               ,jlh.date_created															--date_created
               ,jlh.actual_flag															--actual_flag
               ,gcc.segment1																--segment1
               ,gcc.segment2																--segment2
               ,gcc.segment3																--segment3
               ,gcc.segment4																--segment4
               ,gcc.segment5																--segment5
               ,gcc.segment6																--segment6
               ,gcc.segment7																--segment7
               ,gcc.segment8																--segment8
               ,gcc.segment9																--segment9
               ,gcc.segment10																--segment10
               ,gcc.segment11																--segment11
               ,gcc.segment12																--segment12
               ,gcc.segment13																--segment13
               ,gcc.segment14																--segment14
               ,gcc.segment15																--segment15
               ,gcc.segment16																--segment16
               ,gcc.segment17																--segment17
               ,gcc.segment18																--segment18
               ,gcc.segment19																--segment19
               ,gcc.segment20																--segment20
               ,gcc.segment21																--segment21
               ,gcc.segment22																--segment22
               ,gcc.segment23																--segment23
               ,gcc.segment24																--segment24
               ,gcc.segment25																--segment25
               ,gcc.segment26																--segment26
               ,gcc.segment27																--segment27
               ,gcc.segment28																--segment28
               ,gcc.segment29																--segment29
               ,gcc.segment30																--segment30
               ,jll.entered_dr																--entered_dr
               ,jll.entered_cr																--entered_cr
               ,jll.accounted_dr															--accounted_dr
               ,jll.accounted_cr															--accounted_cr
               ,gjb.name																--reference1
               ,gjb.description															--reference2
               ,''																	--reference3
               ,jlh.name																--reference4
               ,jlh.description															--reference5
               ,jlh.external_reference															--reference6
               ,jlh.accrual_rev_flag															--reference7
               ,jlh.accrual_rev_period_name														--reference8
               ,jlh.accrual_rev_change_sign_flag													--reference9
               ,jll.description															--reference10
               ,jll.stat_amount															--stat_amount
               ,jlh.currency_conversion_type														--user_currency_conversion_type
               ,jlh.currency_conversion_date														--currency_conversion_date
               ,jlh.currency_conversion_rate														--currency_conversion_rate
               ,''																	--group_id
               ,jll.context																--attribute_category
               ,jll.attribute1																--attribute1
               ,jll.attribute2																--attribute2
               ,jll.attribute3																--attribute3
               ,jll.attribute4																--attribute4
               ,jll.attribute5																--attribute5
               ,jll.attribute6																--attribute6
               ,jll.attribute7																--attribute7
               ,jll.attribute8																--attribute8
               ,jll.attribute9																--attribute9
               ,jll.attribute10															--attribute10
               ,jll.attribute11															--attribute11
               ,jll.attribute12															--attribute12
               ,jll.attribute13															--attribute13
               ,jll.attribute14															--attribute14
               ,jll.attribute15															--attribute15
               ,jll.attribute16															--attribute16
               ,jll.attribute17															--attribute17
               ,jll.attribute18															--attribute18
               ,jll.attribute19															--attribute19
               ,jll.attribute20															--attribute20
               ,jll.context3																--attribute_category3
               ,jlh.originating_bal_seg_value														--originating_bal_seg_value
               ,gl.name																--ledger_name
               ,jlh.encumbrance_type_id														--encumbrance_type_id
               ,jlh.jgzz_recon_ref															--jgzz_recon_ref
               ,jlh.period_name															--period_name 
               ,''																	--attribute_date1
               ,''																	--attribute_date2
               ,''																	--attribute_date3
               ,''																	--attribute_date4
               ,''																	--attribute_date5
               ,''																	--attribute_date6
               ,''																	--attribute_date7
               ,''																	--attribute_date8
               ,''																	--attribute_date9
               ,''																	--attribute_date10
               ,''																	--attribute_number1
               ,''																	--attribute_number2
               ,''																	--attribute_number3
               ,''																	--attribute_number4
               ,''																	--attribute_number5
               ,''																	--attribute_number6
               ,''																	--attribute_number7
               ,''																	--attribute_number8
               ,''																	--attribute_number9
               ,''																	--attribute_number10
               ,''																	--global_attribute_category
               ,''																	--global_attribute1
               ,''																	--global_attribute2
               ,''																	--global_attribute3
               ,''																	--global_attribute4
               ,''																	--global_attribute5
               ,''																	--global_attribute6
               ,''																	--global_attribute7
               ,''																	--global_attribute8
               ,''																	--global_attribute9
               ,''																	--global_attribute10
               ,''																	--global_attribute11
               ,''																	--global_attribute12
               ,''																	--global_attribute13
               ,''																	--global_attribute14
               ,''																	--global_attribute15
               ,''																	--global_attribute16
               ,''																	--global_attribute17
               ,''																	--global_attribute18
               ,''																	--global_attribute19
               ,''																	--global_attribute20
               ,''																	--global_attribute_date1
               ,''																	--global_attribute_date2
               ,''																	--global_attribute_date3
               ,''																	--global_attribute_date4
               ,''																	--global_attribute_date5
               ,''																	--global_attribute_number1
               ,''																	--global_attribute_number2
               ,''																	--global_attribute_number3
               ,''																	--global_attribute_number4
               ,''																	--global_attribute_number5
         FROM
                gl_je_headers@MXDM_NVIS_EXTRACT					jlh
               ,gl_je_lines@MXDM_NVIS_EXTRACT   					jll
               ,gl_periods@MXDM_NVIS_EXTRACT   					gp
               ,gl_code_combinations@MXDM_NVIS_EXTRACT   			gcc
               ,gl_je_batches@MXDM_NVIS_EXTRACT   					gjb
               ,gl_sets_of_books@MXDM_NVIS_EXTRACT   					gl    --xxsh 11i table (r12 = gl_ledgers)
                                   ,gl_je_sources_tl@MXDM_NVIS_EXTRACT                                     gjst  --xxsh added
                                   ,gl_je_categories_tl@MXDM_NVIS_EXTRACT                                  gjct  --xxsh added

         WHERE  1                                 				= 1
           --
            AND 	gl.name                       IN(SELECT parameter_value
                                                      FROM XXMX_MIGRATION_PARAMETERS
                                                      WHERE APPLICATION = gct_Application
                                                      AND APPLICATION_SUITE = gct_ApplicationSuite
                                                      AND PARAMETER_CODE = 'LEDGER_NAME'
                                                      AND ENABLED_FLAG = 'Y')
           AND     gp.period_name              IN(SELECT parameter_value
                                                      FROM XXMX_MIGRATION_PARAMETERS
                                                      WHERE APPLICATION = gct_Application
                                                      AND APPLICATION_SUITE = gct_ApplicationSuite
                                                      AND PARAMETER_CODE = 'PERIOD_NAME'
                                                      AND ENABLED_FLAG = 'Y')
           AND     gp.period_set_name                              = gl.period_set_name
           AND     jlh.period_name									= gp.period_name
           AND     jlh.ledger_id                             	= gl.ledger_id
           AND     jlh.actual_flag                                 in ('A','B')       --xxsh BS want Budget txns also
           AND     jll.status                                      = 'P'
           AND 	jll.je_header_id                    	 	= jlh.je_header_id
           AND     gjb.je_batch_id                                 = jlh.je_batch_id
           AND     jll.code_combination_id                         = gcc.code_combination_id
           AND     gjst.je_source_name                             = jlh.je_source  --xxsh added
           AND     gjct.je_category_name                           = jlh.je_category  --xxsh added
           AND     jlh.currency_code                               <> 'STAT'   --xxsh BS don't want STAT journals
         ;

          /*
            ** Obtain the count of rows inserted.  We cannot use SQL$ROWCOUNT here because of the LIMIT
            ** clause on the BULK COLLECT statement.  The rowcount will be reset each time the limit
            ** is reached.
            */
            --
            --** ISV 21/10/2020 - Replace "pt_i_ClientSchemaName" (no longer passed into the extract procedures) with new constant "gct_StgSchema".
            --**                  Replace "pt_i_StagingTable" (no longer passed into the extract procedures) with new constant "ct_StgTable"
            --
            gvn_RowCount := xxmx_utilities_pkg.get_row_count
                                 (
                                  gct_StgSchema
                                 ,cv_StagingTable
                                 ,pt_i_MigrationSetID
                                 );
            --
            COMMIT;


            xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gv_i_BusinessEntity
                    ,pt_i_SubEntity         => cv_i_BusinessEntityLevel
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Extraction complete.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               --
               --** Update the migration details (Migration status will be automatically determined
               --** in the called procedure dependant on the Phase and if an Error Message has been
               --** passed).
               --
               gvv_ProgressIndicator := '0110';
               --
               --** ISV 21/10/2020 - Removed Sequence Number parameters as the procedure will now determine the correct values from the metadata
               --**                  table based on the Application Suite, Application, Business Entity and Sub-Entity parameters.
               --**
               --**                  Removed "entity" from procedure_name.
               --
               xxmx_utilities_pkg.upd_migration_details
                    (
                     pt_i_MigrationSetID          => pt_i_MigrationSetID
                    ,pt_i_BusinessEntity          => gv_i_BusinessEntity
                    ,pt_i_SubEntity               => cv_i_BusinessEntityLevel
                    ,pt_i_Phase                   => ct_Phase
                    ,pt_i_ExtractCompletionDate   => SYSDATE
                    ,pt_i_ExtractRowCount         => gvn_RowCount
                    ,pt_i_TransformTable          => NULL
                    ,pt_i_TransformStartDate      => NULL
                    ,pt_i_TransformCompletionDate => NULL
                    ,pt_i_ExportFileName          => NULL
                    ,pt_i_ExportStartDate         => NULL
                    ,pt_i_ExportCompletionDate    => NULL
                    ,pt_i_ExportRowCount          => NULL
                    ,pt_i_ErrorFlag               => NULL
                    );
               --
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gv_i_BusinessEntity
                    ,pt_i_SubEntity         => cv_i_BusinessEntityLevel
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Migration Table "'
                                             ||cv_StagingTable
                                             ||'" reporting details updated.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               --
          ELSE
               --
               --
               gvt_Severity      := 'ERROR';
               gvt_ModuleMessage := '- Migration Set not initialized.';
               --
               --
               RAISE e_ModuleError;
               --
               --
          END IF;
          --
          --



        --
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
            -- Hr_Utility.raise_error@MXDM_NVIS_EXTRACT;
    END export_gl_journal;		
END xxmx_gl_journal_pkg;

/