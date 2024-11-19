CREATE OR REPLACE PACKAGE  XXMX_GL_OPEN_BAL_VAL_PKG  
AS
     /*
	 ******************************************************************************
     ** FILENAME  :  XXMX_GL_OPEN_BAL_VAL_PKG.pls
     **
     ** VERSION   :  1.0
     **
     ** EXECUTE
     ** IN SCHEMA :  APPS
     **
     ** AUTHORS   :   Shruti Choudhury
     **
     ** PURPOSE   :  This script installs the package specification for the XXMX_GL_OPEN_BAL_VAL_PKG custom Procedures.
     **
     ** NOTES     :

     **   Vsn  Change Date  Changed By          Change Description
     ** -----  -----------  ------------------  -----------------------------------
     ** [ 1.0  DD-Mon-YYYY  Change Author       Created.                          ]
     **
     ******************************************************************************
     **
     ** XXMX_GL_OPEN_BAL_VAL_PKG HISTORY
     ** ------------------------------------
     **
     **   Vsn  Change Date  Changed By                 Change Description
     ** -----  -----------  ------------------         -----------------------------------
     **   1.0  26-FEB-2024  Shruti Choudhury       Initial implementation
     ******************************************************************************
     */
    --
    /*
    ******************************
    ** PROCEDURE: VALIDATE_GL_OPEN_BALANCES 
    ******************************
    */
    PROCEDURE VALIDATE_GL_OPEN_BALANCES
                    (
                     pt_i_ApplicationSuite           IN      xxmx_module_messages.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_module_messages.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_module_messages.business_entity%TYPE
                    );
    --
	/*
    ******************************
    ** PROCEDURE: VALIDATE_OPEN_BALANCES
    ******************************
    */
    PROCEDURE VALIDATE_OPEN_BALANCES
                    (
                    pt_i_ApplicationSuite           IN      xxmx_module_messages.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_module_messages.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_module_messages.business_entity%TYPE
                    );
	FUNCTION get_migration_set_id
	                (
					pt_i_BusinessEntity             IN      xxmx_module_messages.business_entity%TYPE
					)
					RETURN NUMBER;
    FUNCTION get_subentity_name
	                (
					pt_i_BusinessEntity             IN      xxmx_module_messages.business_entity%TYPE
                   ,pt_i_table                      IN      xxmx_migration_metadata.stg_table%TYPE
					)
					RETURN VARCHAR2;
END XXMX_GL_OPEN_BAL_VAL_PKG;
/
     /*
    ******************************
    ** PACKAGE BODY
    ******************************
    */
CREATE OR REPLACE PACKAGE BODY XXMX_GL_OPEN_BAL_VAL_PKG 
AS
     /*
	 ******************************************************************************
     ** FILENAME  :  XXMX_GL_OPEN_BAL_VAL_PKG.pls
     **
     ** VERSION   :  1.0
     **
     ** EXECUTE
     ** IN SCHEMA :  APPS
     **
     ** AUTHORS   :  Shruti Choudhury
     **
     ** PURPOSE   :  This script installs the package body for the XXMX_GL_OPEN_BAL_VAL_PKG custom Procedures.
     **
     ** NOTES     :

     **   Vsn  Change Date  Changed By          Change Description
     ** -----  -----------  ------------------  -----------------------------------
     ** [ 1.0  DD-Mon-YYYY  Change Author       Created.                          ]
     **
     ******************************************************************************
     **
     ** XXMX_GL_OPEN_BAL_VAL_PKG HISTORY
     ** ------------------------------------
     **
     **   Vsn  Change Date  Changed By             Change Description
     ** -----  -----------  ------------------     -----------------------------------
     **   1.0  26-FEB-2024  Shruti Choudhury    Initial implementation
	                                              
     ******************************************************************************
     */
    --
     /*
     ** Maximise Integration
     */
     --
     /*
     ** Global Constants for use in all xxmx_utilities_pkg Procedure/Function Calls within this package
     */
     --
     gvv_ApplicationErrorMessage                        VARCHAR2(2048);
     gvt_Severity                                       xxmx_module_messages.severity%TYPE;
     gvt_ModuleMessage                                  xxmx_module_messages.module_message%TYPE;
     gvt_OracleError                                    xxmx_module_messages.oracle_error%TYPE;
     gvv_ProgressIndicator                              VARCHAR2(100);
     ct_ProcOrFuncName                                  xxmx_module_messages.proc_or_func_name%TYPE;
     gct_PackageName                           CONSTANT xxmx_module_messages.package_name%TYPE       := 'XXMX_GL_OPEN_BAL_VAL_PKG';
     gct_ApplicationSuite                      CONSTANT xxmx_module_messages.application_suite%TYPE  := 'FIN';
     gct_Application                           CONSTANT xxmx_module_messages.application%TYPE        := 'GL';
     gct_BusinessEntity                        CONSTANT xxmx_migration_metadata.business_entity%TYPE := 'OPEN_BAL';
     ct_Phase                                  CONSTANT xxmx_module_messages.phase%TYPE              := 'VALIDATE';
     ct_SubEntity                              CONSTANT xxmx_module_messages.sub_entity%TYPE         := 'ALL';
	 gct_CoreSchema                            CONSTANT VARCHAR2(10)                                 := 'xxmx_core';
    --
    --
     /*
     ** Global Variables for receiving Status/Messages from certain Procedure/Function Calls (e.g. xxmx_utilities_pkg.clear_messages
     */
     --
     gvv_ReturnStatus                                   VARCHAR2(1);
     gvt_ReturnMessage                                  xxmx_module_messages.module_message%TYPE;
     --
	 --
     gvt_MigrationSetName                               xxmx_migration_headers.migration_set_name%TYPE;
     --
	  /*
     ** Global variables for holding table row counts
     */
     --
     gvn_RowCount                                       NUMBER;
     --
     --			
FUNCTION get_migration_set_id 
                    (
                    pt_i_BusinessEntity             IN      xxmx_module_messages.business_entity%TYPE
                    )
   RETURN NUMBER IS 
   l_migration_set_id NUMBER:= 0;
   l_stg_table VARCHAR2(50);
   l_SQL VARCHAR2(500);
   BEGIN 
            SELECT stg_table
            INTO l_stg_table
            FROM xxmx_migration_metadata
            WHERE business_entity = pt_i_BusinessEntity
            AND sub_entity_seq IN( 
                                SELECT MIN(sub_entity_seq)
                                FROM xxmx_migration_metadata
                                WHERE business_entity = pt_i_BusinessEntity
                                AND enabled_flag = 'Y');

            l_sql := 'select MAX(migration_Set_id) from XXMX_STG.'||l_stg_table;
            EXECUTE IMMEDIATE l_sql INTO l_migration_Set_id; 
             IF(l_migration_Set_id IS NULL)
                THEN
                    BEGIN
                    Select distinct max(MIGRATION_SET_ID)
                    INTO l_migration_Set_id
                    from xxmx_migration_headers
                    where business_entity = pt_i_BusinessEntity;
            EXCEPTION
                WHEN OTHERS THEN
                    l_migration_Set_id := NULL;
                END;
               END IF;
				RETURN l_migration_Set_id;
   END;
    --
FUNCTION get_subentity_name 
                    (
                    pt_i_BusinessEntity             IN      xxmx_module_messages.business_entity%TYPE
				   ,pt_i_table                      IN      xxmx_migration_metadata.stg_table%TYPE
                    )
   RETURN VARCHAR2 IS 
   l_subentity_name VARCHAR2(120);
   l_SQL VARCHAR2(500);
   BEGIN 
            SELECT sub_entity
            INTO l_subentity_name
            FROM xxmx_migration_metadata
            WHERE business_entity = pt_i_BusinessEntity
            AND stg_table = pt_i_table;

				RETURN l_subentity_name;

            EXCEPTION
			    WHEN NO_DATA_FOUND THEN 
				    l_subentity_name := 'ALL';
                WHEN OTHERS THEN
                    l_subentity_name := 'ALL';
   END;
   
    /*
    ******************************
    ** PROCEDURE: VALIDATE_GL_OPEN_BALANCES 
    ******************************
    */
    PROCEDURE VALIDATE_GL_OPEN_BALANCES
                    (
                     pt_i_ApplicationSuite           IN      xxmx_module_messages.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_module_messages.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_module_messages.business_entity%TYPE
                    )
    IS
        CURSOR gl_open_bal_cursor(pt_i_MigrationSetID number)
        IS		 
	 /*
     ** Validate if entered credit and enetered debit is matching for summary balances: we have considered segment 1 as balancing segment
     */
		SELECT 'Sum of entered credit and debit does not match for balances' AS VALIDATION_ERROR_MESSAGE, stg.*
        FROM XXMX_GL_OPENING_BALANCES_STG stg
		where migration_set_id = pt_i_MigrationSetID
        AND  NOT EXISTS (SELECT 1 
		                   FROM (
                                 SELECT xspl.ledger_name,xspl.period_name,xspl.reference4,xspl.segment1,xspl.reference1
                                 FROM XXMX_GL_OPENING_BALANCES_STG xspl
                                 GROUP BY   xspl.ledger_name, xspl.period_name, xspl.reference4,xspl.segment1,xspl.reference1
                                 HAVING  SUM(xspl.entered_dr) = SUM(xspl.entered_cr) 
								 ) subquery      
                           WHERE 1=1
                           AND stg.ledger_name = subquery.ledger_name
                           AND stg.reference1 = subquery.reference1
                           AND stg.period_name = subquery.period_name
                           and stg.reference4 = subquery.reference4
                           and stg.segment1 = subquery.segment1
                           		              
						  )
						  
	 /*
     ** Validate if ACCOUTNED credit and enetered debit is matching for summary balances: we have considered segment 1 as balancing segment
     */ 
	    UNION ALL
		SELECT 'Sum of accounted credit and debit does not match for balances' AS VALIDATION_ERROR_MESSAGE, stg.*
        FROM XXMX_GL_OPENING_BALANCES_STG stg
		where migration_set_id = pt_i_MigrationSetID
        AND  NOT EXISTS (SELECT 1 
		                   FROM (
                                 SELECT xspl.ledger_name,xspl.period_name,xspl.reference4,xspl.segment1,xspl.reference1
                                 FROM XXMX_GL_OPENING_BALANCES_STG xspl
                                 GROUP BY   xspl.ledger_name, xspl.period_name, xspl.reference4,xspl.segment1,xspl.reference1
                                 HAVING  SUM(xspl.accounted_dr) = SUM(xspl.accounted_cr) 
								 ) subquery      
                           WHERE 1=1
                           AND stg.ledger_name = subquery.ledger_name
                           AND stg.reference1 = subquery.reference1
                           AND stg.period_name = subquery.period_name
                           and stg.reference4 = subquery.reference4
                           and stg.segment1 = subquery.segment1		              
						  )
	 /*
     ** Validate if entered cr has 0.
     */	
	 	UNION ALL 
	    SELECT 'Entered credit has 0' AS VALIDATION_ERROR_MESSAGE, gsbs.*
        FROM XXMX_GL_OPENING_BALANCES_STG gsbs
		WHERE 1=1
		AND  migration_set_id = pt_i_MigrationSetID
		AND entered_cr=0 
		
		
	 /*
     ** Validate if entered dr has 0.
     */	
	 	UNION ALL 
	    SELECT 'Entered debit has 0' AS VALIDATION_ERROR_MESSAGE, gsbs.*
        FROM XXMX_GL_OPENING_BALANCES_STG gsbs
		WHERE 1=1
		AND  migration_set_id = pt_i_MigrationSetID
		AND entered_dr=0 
		
	 /*
     ** Validate if entered dr has 0.
     */	
	 	UNION ALL 
	    SELECT 'Accounted debit has 0' AS VALIDATION_ERROR_MESSAGE, gsbs.*
        FROM XXMX_GL_OPENING_BALANCES_STG gsbs
		WHERE 1=1
		AND  migration_set_id = pt_i_MigrationSetID
		AND accounted_dr=0 
		
		
	 /*
     ** Validate if entered dr has 0.
     */	
	 	UNION ALL 
	    SELECT 'accounted_credit has 0' AS VALIDATION_ERROR_MESSAGE, gsbs.*
        FROM XXMX_GL_OPENING_BALANCES_STG gsbs
		WHERE 1=1
		AND  migration_set_id = pt_i_MigrationSetID
		AND accounted_cr=0 
	 /*
     ** Validate if period name.
     */					   
							   
		UNION ALL 
	    SELECT 'Period name is in wrong format' AS VALIDATION_ERROR_MESSAGE, gsbs.*
        FROM XXMX_GL_OPENING_BALANCES_STG gsbs
		WHERE 1=1
		AND  migration_set_id = pt_i_MigrationSetID
        AND  TO_CHAR(TO_DATE(gsbs.period_name, 'Mon-YY'), 'Mon-YY') != gsbs.period_name
      /*
      ** Validate if junk is present 
      */								   
     	UNION ALL	
		SELECT 'Batch Description has Junk/Invalid characters' as VALIDATION_ERROR_MESSAGE, stg.*  
		FROM XXMX_GL_OPENING_BALANCES_STG stg
		WHERE 1=1
		AND stg.migration_set_id= pt_i_MigrationSetID
		AND REGEXP_LIKE(reference2, '[^[:print:]]') 
	--	
		UNION ALL	
		SELECT 'Journal entry description has Junk/Invalid characters' as VALIDATION_ERROR_MESSAGE, stg.*  
		FROM XXMX_GL_OPENING_BALANCES_STG stg
		WHERE 1=1
		AND stg.migration_set_id= pt_i_MigrationSetID
		AND REGEXP_LIKE(REFERENCE5, '[^[:print:]]') 
	--	
		UNION ALL	
		SELECT 'Journal entry Line Description has Junk/Invalid characters' as VALIDATION_ERROR_MESSAGE, stg.*  
		FROM XXMX_GL_OPENING_BALANCES_STG stg
		WHERE 1=1
		AND stg.migration_set_id= pt_i_MigrationSetID
		AND REGEXP_LIKE(reference10, '[^[:print:]]') ;
     --
       TYPE gl_opening_balances_type IS TABLE OF gl_open_bal_cursor%ROWTYPE INDEX BY BINARY_INTEGER;
	   gl_open_bal_tbl gl_opening_balances_type;

	       --************************
          --** Constant Declarations
          --************************
        ct_ProcOrFuncName CONSTANT xxmx_module_messages.proc_or_func_name%TYPE := 'VALIDATE_GL_OPEN_BALANCES';
		ct_CoreSchema                    CONSTANT VARCHAR2(10)                                := 'xxmx_core';
        ct_CoreTable                     CONSTANT xxmx_migration_metadata.stg_table%TYPE      := 'XXMX_GL_SUMMARY_BALANCES_VAL';
		ct_StgTable                      CONSTANT xxmx_migration_metadata.stg_table%TYPE      := 'XXMX_GL_OPENING_BALANCES_STG';
		l_migration_set_id NUMBER;
		l_subentity VARCHAR2(360);
         --*************************
          --** Exception Declarations
          --*************************
          --
          --** Set gvt_Severity, gvv_ProgressIndicator and gvt_ModuleMessage
          --** before raising this exception.
          --
          e_ModuleError                   EXCEPTION;
          --
     --** END Declarations
    BEGIN

        l_subentity:= get_subentity_name(pt_i_BusinessEntity,ct_StgTable);

        gvv_ProgressIndicator := '0010';

		 --
          gvv_ReturnStatus  := '';
          gvt_ReturnMessage := '';
          --
          xxmx_utilities_pkg.clear_messages
               (
                pt_i_ApplicationSuite => gct_ApplicationSuite
               ,pt_i_Application      => gct_Application
               ,pt_i_BusinessEntity   => pt_i_BusinessEntity
               ,pt_i_SubEntity        => l_subentity
               ,pt_i_Phase            => ct_Phase
               ,pt_i_MessageType      => 'MODULE'
               ,pv_o_ReturnStatus     => gvv_ReturnStatus
               );
          --
          IF   gvv_ReturnStatus = 'F'
          THEN
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                    ,pt_i_SubEntity         => l_subentity
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'ERROR'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
                    ,pt_i_OracleError       => gvt_ReturnMessage
                    );
               --
               RAISE e_ModuleError;
               --
          END IF;
          --
          gvv_ProgressIndicator := '0020';
          --
          gvv_ReturnStatus  := '';
          gvt_ReturnMessage := '';
          --
          xxmx_utilities_pkg.clear_messages
               (
                pt_i_ApplicationSuite => gct_ApplicationSuite
               ,pt_i_Application      => gct_Application
               ,pt_i_BusinessEntity   => pt_i_BusinessEntity
               ,pt_i_SubEntity        => l_subentity
               ,pt_i_Phase            => ct_Phase
               ,pt_i_MessageType      => 'DATA'
               ,pv_o_ReturnStatus     => gvv_ReturnStatus
               );
          --
          IF   gvv_ReturnStatus = 'F'
          THEN
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                    ,pt_i_SubEntity         => l_subentity
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'ERROR'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
                    ,pt_i_OracleError       => gvt_ReturnMessage
                    );
               --
               RAISE e_ModuleError;
               --
          END IF;
          --
          gvv_ProgressIndicator := '0030';
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => pt_i_BusinessEntity
               ,pt_i_SubEntity         => l_subentity
               ,pt_i_Phase             => ct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gct_PackageName
               ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'Procedure "'
                                        ||gct_PackageName
                                        ||'.'
                                        ||ct_ProcOrFuncName
                                        ||'" initiated.'
               ,pt_i_OracleError       => NULL
               );
          --
          --** Retrieve the Migration Set Name
          --
          gvv_ProgressIndicator := '0040';

		  l_migration_set_id := get_migration_set_id(pt_i_BusinessEntity);
          --
          gvt_MigrationSetName := xxmx_utilities_pkg.get_migration_set_name(l_migration_set_id);
          --
          --** If the Migration Set Name is NULL then the Migration has not been initialized.
          --
          IF   gvt_MigrationSetName IS NOT NULL
          THEN
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                    ,pt_i_SubEntity         => l_subentity
                    ,pt_i_FileSetID         => NULL
                    ,pt_i_MigrationSetID    => l_migration_set_id                    
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Validating "'
                                             ||pt_i_BusinessEntity
                                             ||'":'
                    ,pt_i_OracleError       => NULL
                    );
               --
               --
               gvv_ProgressIndicator := '0050';
               --
               --** Extract the Sub-entity data and insert into the staging table.
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                    ,pt_i_SubEntity         => l_subentity
                    ,pt_i_FileSetID         => NULL
                    ,pt_i_MigrationSetID    => l_migration_set_id                    
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Inserting validated data into "'
                                             ||ct_CoreTable
                                             ||'" table.'
                    ,pt_i_OracleError       => NULL
                    );
               --
		BEGIN		
		EXECUTE IMMEDIATE 'TRUNCATE TABLE ' || ct_CoreTable;
		END;
		OPEN gl_open_bal_cursor(l_migration_set_id);
		LOOP	 
		 FETCH gl_open_bal_cursor 
		 BULK COLLECT INTO gl_open_bal_tbl
		 LIMIT xxmx_utilities_pkg.gcn_BulkCollectLimit;

		EXIT WHEN gl_open_bal_tbl.COUNT=0  ;

		gvv_ProgressIndicator := '0060';

FORALL I in 1..gl_open_bal_tbl.COUNT 

        INSERT INTO XXMX_GL_OPENING_BALANCES_VAL  
        (
		 VALIDATION_ERROR_MESSAGE        
         ,FILE_SET_ID                    
         ,MIGRATION_SET_ID               
         ,MIGRATION_SET_NAME             
         ,MIGRATION_STATUS               
         ,FUSION_STATUS_CODE             
         ,LEDGER_ID                      
         ,ACCOUNTING_DATE                
         ,USER_JE_SOURCE_NAME            
         ,USER_JE_CATEGORY_NAME          
         ,CURRENCY_CODE                  
         ,DATE_CREATED                   
         ,ACTUAL_FLAG                    
         ,SEGMENT1                       
         ,SEGMENT2                       
         ,SEGMENT3                       
         ,SEGMENT4                       
         ,SEGMENT5                       
         ,SEGMENT6                       
         ,SEGMENT7                       
         ,SEGMENT8                       
         ,SEGMENT9                       
         ,SEGMENT10                      
         ,SEGMENT11                      
         ,SEGMENT12                      
         ,SEGMENT13                      
         ,SEGMENT14                      
         ,SEGMENT15                      
         ,SEGMENT16                      
         ,SEGMENT17                      
         ,SEGMENT18                      
         ,SEGMENT19                      
         ,SEGMENT20                      
         ,SEGMENT21                      
         ,SEGMENT22                      
         ,SEGMENT23                      
         ,SEGMENT24                      
         ,SEGMENT25                      
         ,SEGMENT26                      
         ,SEGMENT27                      
         ,SEGMENT28                      
         ,SEGMENT29                      
         ,SEGMENT30                      
         ,ENTERED_DR                     
         ,ENTERED_CR                     
         ,ACCOUNTED_DR                   
         ,ACCOUNTED_CR                   
         ,REFERENCE1                     
         ,REFERENCE2                     
         ,REFERENCE3                     
         ,REFERENCE4                     
         ,REFERENCE5                     
         ,REFERENCE6                     
         ,REFERENCE7                     
         ,REFERENCE8                     
         ,REFERENCE9                     
         ,REFERENCE10                    
         ,STAT_AMOUNT                    
         ,USER_CURRENCY_CONVERSION_TYPE  
         ,CURRENCY_CONVERSION_DATE       
         ,CURRENCY_CONVERSION_RATE       
         ,GROUP_ID                       
         ,ORIGINATING_BAL_SEG_VALUE      
         ,LEDGER_NAME                    
         ,ENCUMBRANCE_TYPE_ID            
         ,JGZZ_RECON_REF                 
         ,PERIOD_NAME                    
         ,LOAD_BATCH                     
        )
        VALUES 
        (
		 gl_open_bal_tbl(I).VALIDATION_ERROR_MESSAGE
        ,gl_open_bal_tbl(I).FILE_SET_ID                      	
        ,gl_open_bal_tbl(I).MIGRATION_SET_ID                 
		,gl_open_bal_tbl(I).MIGRATION_SET_NAME                         
	    ,'VALIDATED'        
		, gl_open_bal_tbl(I).FUSION_STATUS_CODE             
         ,gl_open_bal_tbl(I).LEDGER_ID                      
         ,gl_open_bal_tbl(I).ACCOUNTING_DATE                
         ,gl_open_bal_tbl(I).USER_JE_SOURCE_NAME            
         ,gl_open_bal_tbl(I).USER_JE_CATEGORY_NAME          
         ,gl_open_bal_tbl(I).CURRENCY_CODE                  
         ,gl_open_bal_tbl(I).DATE_CREATED                   
         ,gl_open_bal_tbl(I).ACTUAL_FLAG                    
         ,gl_open_bal_tbl(I).SEGMENT1                       
         ,gl_open_bal_tbl(I).SEGMENT2                       
         ,gl_open_bal_tbl(I).SEGMENT3                       
         ,gl_open_bal_tbl(I).SEGMENT4                       
         ,gl_open_bal_tbl(I).SEGMENT5                       
         ,gl_open_bal_tbl(I).SEGMENT6                       
         ,gl_open_bal_tbl(I).SEGMENT7                       
         ,gl_open_bal_tbl(I).SEGMENT8                       
         ,gl_open_bal_tbl(I).SEGMENT9                       
         ,gl_open_bal_tbl(I).SEGMENT10                      
         ,gl_open_bal_tbl(I).SEGMENT11                      
         ,gl_open_bal_tbl(I).SEGMENT12                      
         ,gl_open_bal_tbl(I).SEGMENT13                      
         ,gl_open_bal_tbl(I).SEGMENT14                      
         ,gl_open_bal_tbl(I).SEGMENT15                      
         ,gl_open_bal_tbl(I).SEGMENT16                      
         ,gl_open_bal_tbl(I).SEGMENT17                      
         ,gl_open_bal_tbl(I).SEGMENT18                      
         ,gl_open_bal_tbl(I).SEGMENT19                      
         ,gl_open_bal_tbl(I).SEGMENT20                      
         ,gl_open_bal_tbl(I).SEGMENT21                      
         ,gl_open_bal_tbl(I).SEGMENT22                      
         ,gl_open_bal_tbl(I).SEGMENT23                      
         ,gl_open_bal_tbl(I).SEGMENT24                      
         ,gl_open_bal_tbl(I).SEGMENT25                      
         ,gl_open_bal_tbl(I).SEGMENT26                      
         ,gl_open_bal_tbl(I).SEGMENT27                      
         ,gl_open_bal_tbl(I).SEGMENT28                      
         ,gl_open_bal_tbl(I).SEGMENT29                      
         ,gl_open_bal_tbl(I).SEGMENT30                      
         ,gl_open_bal_tbl(I).ENTERED_DR                     
         ,gl_open_bal_tbl(I).ENTERED_CR                     
         ,gl_open_bal_tbl(I).ACCOUNTED_DR                   
         ,gl_open_bal_tbl(I).ACCOUNTED_CR                   
         ,gl_open_bal_tbl(I).REFERENCE1                     
         ,gl_open_bal_tbl(I).REFERENCE2                     
         ,gl_open_bal_tbl(I).REFERENCE3                     
         ,gl_open_bal_tbl(I).REFERENCE4                     
         ,gl_open_bal_tbl(I).REFERENCE5                     
         ,gl_open_bal_tbl(I).REFERENCE6                     
         ,gl_open_bal_tbl(I).REFERENCE7                     
         ,gl_open_bal_tbl(I).REFERENCE8                     
         ,gl_open_bal_tbl(I).REFERENCE9                     
         ,gl_open_bal_tbl(I).REFERENCE10                    
         ,gl_open_bal_tbl(I).STAT_AMOUNT                    
         ,gl_open_bal_tbl(I).USER_CURRENCY_CONVERSION_TYPE  
         ,gl_open_bal_tbl(I).CURRENCY_CONVERSION_DATE       
         ,gl_open_bal_tbl(I).CURRENCY_CONVERSION_RATE       
         ,gl_open_bal_tbl(I).GROUP_ID                       
         ,gl_open_bal_tbl(I).ORIGINATING_BAL_SEG_VALUE      
         ,gl_open_bal_tbl(I).LEDGER_NAME                    
         ,gl_open_bal_tbl(I).ENCUMBRANCE_TYPE_ID            
         ,gl_open_bal_tbl(I).JGZZ_RECON_REF                 
         ,gl_open_bal_tbl(I).PERIOD_NAME                    
         ,gl_open_bal_tbl(I).LOAD_BATCH    
        );	
END LOOP;
               --
               gvv_ProgressIndicator := '0070';
               --
               --** Obtain the count of rows inserted.  We cannot use SQL$ROWCOUNT here because of the LIMIT
               --** clause on the BULK COLLECT statement.  The rowcount will be reset each time the limit
               --** is reached.
               --
               gvn_RowCount := xxmx_utilities_pkg.get_row_count
                                    (
                                     ct_CoreSchema
                                    ,ct_CoreTable
                                    ,l_migration_set_id
                                    );
               --
		COMMIT;

               --
               gvv_ProgressIndicator := '0080';
               --
               CLOSE gl_open_bal_cursor;
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                    ,pt_i_SubEntity         => l_subentity
                    ,pt_i_FileSetID         => NULL
                    ,pt_i_MigrationSetID    => l_migration_set_id                    
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Validation complete.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               --
               --** Update the migration details (Migration status will be automatically determined
               --** in the called procedure dependant on the Phase and if an Error Message has been
               --** passed).
               --
               gvv_ProgressIndicator := '0090';
               --
               xxmx_utilities_pkg.upd_migration_details
                    (
                     pt_i_MigrationSetID          => l_migration_set_id
                    ,pt_i_BusinessEntity          => pt_i_BusinessEntity
                    ,pt_i_SubEntity               => l_subentity
                    ,pt_i_Phase                   => ct_Phase
                    ,pt_i_ExtractCompletionDate   => NULL
                    ,pt_i_ExtractRowCount         => NULL
                    ,pt_i_TransformTable          => NULL
                    ,pt_i_TransformStartDate      => NULL
                    ,pt_i_TransformCompletionDate => NULL
                    ,pt_i_ExportFileName          => NULL
                    ,pt_i_ExportStartDate         => NULL
                    ,pt_i_ExportCompletionDate    => NULL
                    ,pt_i_ExportRowCount          => NULL
					,pt_i_ValidateRowCount        => gvn_RowCount
					,pt_i_ValidateStartDate   	  => SYSDATE
                    ,pt_i_ValidateCompletionDate  => SYSDATE
                    ,pt_i_ErrorFlag               => NULL
                    );
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                    ,pt_i_SubEntity         => l_subentity
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Migration details for Table "'
                                             ||ct_CoreTable
                                             ||'" updated.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               --
          ELSE
               --
               gvt_Severity      := 'ERROR';
               gvt_ModuleMessage := '- Migration Set not initialized.';
               --
               RAISE e_ModuleError;
               --
          END IF;
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => pt_i_BusinessEntity
               ,pt_i_SubEntity         => l_subentity
               ,pt_i_Phase             => ct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gct_PackageName
               ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'Procedure "'
                                        ||gct_PackageName
                                        ||'.'
                                        ||ct_ProcOrFuncName
                                        ||'" completed.'
               ,pt_i_OracleError       => NULL
               );
          --
          EXCEPTION
               --
               WHEN e_ModuleError
               THEN
                    --
                    xxmx_utilities_pkg.log_module_message
                        (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                         ,pt_i_SubEntity         => ct_SubEntity
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => gvt_Severity
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => gvt_ModuleMessage
                         ,pt_i_OracleError       => NULL
                        );
                    --
                    gvv_ApplicationErrorMessage := SUBSTR('"e_ModuleError" Exception raised after Progress Indicator "'
                                                       ||gct_PackageName
                                                       ||'.'
                                                       ||ct_ProcOrFuncName
                                                       ||'-'
                                                       ||gvv_ProgressIndicator
                                                       ||'".  Please refer to XXMX_MODULE_MESSAGES table for further details.'
                                                        ,1
                                                        ,2048
                                                         );
                    --
                    RAISE_APPLICATION_ERROR(xxmx_utilities_pkg.gcn_ApplicationErrorNumber, gvv_ApplicationErrorMessage);
                    --
               --** END e_ModuleError Exception
               --
           WHEN OTHERS
               THEN
                    --
                    IF   gl_open_bal_cursor%ISOPEN
                    THEN
                         --
                         CLOSE gl_open_bal_cursor;
                         --
                    END IF;
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
                xxmx_utilities_pkg.log_module_message
                     (
                      pt_i_ApplicationSuite  => gct_ApplicationSuite
                     ,pt_i_Application       => gct_Application
                     ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                     ,pt_i_SubEntity         => ct_SubEntity
                     ,pt_i_Phase             => ct_Phase
                     ,pt_i_Severity          => 'ERROR'
                     ,pt_i_PackageName       => gct_PackageName
                     ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                     ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                     ,pt_i_ModuleMessage     => 'Oracle error encounted after Progress Indicator.'
                     ,pt_i_OracleError       => gvt_OracleError
                     );
                --
                gvv_ApplicationErrorMessage := SUBSTR('Unexpected Oracle Exception encountered after Progress Indicator "'
                                                   ||gct_PackageName
                                                   ||'.'
                                                   ||ct_ProcOrFuncName
                                                   ||'-'
                                                   ||gvv_ProgressIndicator
                                                   ||'".  Please refer to XXMX_MODULE_MESSAGES table for further details.'
                                                    ,1
                                                    ,2048
                                                     );
                --
                RAISE_APPLICATION_ERROR(xxmx_utilities_pkg.gcn_ApplicationErrorNumber, gvv_ApplicationErrorMessage);
                --
           --** END OTHERS Exception
           --
      --** END Exception Handler
      --
END VALIDATE_GL_OPEN_BALANCES;

    /*
    ******************************
    ** PROCEDURE: VALIDATE_OPEN_BALANCES
    ******************************
    */
    PROCEDURE VALIDATE_OPEN_BALANCES
                    (
                     pt_i_ApplicationSuite           IN      xxmx_module_messages.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_module_messages.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_module_messages.business_entity%TYPE
                    )
    IS
	CURSOR metadata_cur
                      (
                       pt_ApplicationSuite             xxmx_migration_metadata.application_suite%TYPE
                      ,pt_Application                  xxmx_migration_metadata.application%TYPE
                      ,pt_BusinessEntity               xxmx_migration_metadata.business_entity%TYPE
                      )
          IS
               --
               SELECT  
			           xmm.sub_entity_seq as sub_entity_seq
                      ,LOWER(xmm.val_package_name)      AS val_package_name
                      ,LOWER(xmm.val_procedure_name)        AS val_procedure_name
               FROM    xxmx_migration_metadata  xmm
               WHERE   1 = 1
               AND     xmm.application_suite      = pt_ApplicationSuite
               AND     xmm.application            = pt_Application
               AND     xmm.business_entity        = pt_BusinessEntity
               AND     NVL(xmm.enabled_flag, 'N') = 'Y'
			   AND     xmm.val_package_name IS NOT NULL
               ORDER BY sub_entity_seq;


gvv_SQLStatement        VARCHAR2(32000);
gcv_SQLSpace  CONSTANT  VARCHAR2(1) := ' ';	
gvt_Phase     VARCHAR2(15) := 'VALIDATE';	

    BEGIN
        ct_ProcOrFuncName := 'VALIDATE_OPEN_BALANCES';
        gvv_ProgressIndicator := '0010';


		FOR metadata_cur_rec 
		IN metadata_cur
		   (
		    pt_i_ApplicationSuite
		   ,pt_i_Application
		   ,pt_i_BusinessEntity
		   )
		 LOOP

               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                    ,pt_i_Application       => pt_i_Application
                    ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                    ,pt_i_SubEntity         => 'ALL'
                    ,pt_i_Phase             => gvt_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => metadata_cur_rec.val_package_name
                    ,pt_i_ProcOrFuncName    => metadata_cur_rec.val_procedure_name
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => 'Procedure "'
                                               ||metadata_cur_rec.val_package_name
                                               ||'.'
                                               ||metadata_cur_rec.val_procedure_name
                                               ||'" initiated.'
                    ,pt_i_OracleError       => NULL
                    );		

        gvv_ProgressIndicator := '0020';

                gvv_SQLStatement := 'BEGIN '
                                    ||metadata_cur_rec.val_package_name
                                    ||'.'
                                    ||metadata_cur_rec.val_procedure_name
                                    ||gcv_SQLSpace
                                    ||'('
                                    ||' pt_i_ApplicationSuite => '''
									||pt_i_ApplicationSuite
                                    ||''''
                                    ||',pt_i_Application => '''
									||pt_i_Application
                                    ||''''
                                    ||',pt_i_BusinessEntity =>  '''
									||pt_i_BusinessEntity
                                    ||''''
                                    ||'); END;';	

                xxmx_utilities_pkg.log_module_message
                                   (
                                    pt_i_ApplicationSuite    => pt_i_ApplicationSuite
                                   ,pt_i_Application         => pt_i_Application
                                   ,pt_i_BusinessEntity      => pt_i_BusinessEntity
                                   ,pt_i_SubEntity           => 'ALL'
                                   ,pt_i_Phase               => gvt_Phase
                                   ,pt_i_Severity            => 'NOTIFICATION'
                                   ,pt_i_PackageName         => metadata_cur_rec.val_package_name
                                   ,pt_i_ProcOrFuncName      => metadata_cur_rec.val_procedure_name
                                   ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                                   ,pt_i_ModuleMessage       => SUBSTR(
                                                                       '      - Generated SQL Statement: ' ||gvv_SQLStatement
                                                                      ,1
                                                                      ,4000
                                                                      )
                                   ,pt_i_OracleError         => NULL
                                   );
                              --
                              EXECUTE IMMEDIATE gvv_SQLStatement;	
		 END LOOP;
		--
    EXCEPTION
           WHEN OTHERS
               THEN
                gvt_OracleError := SUBSTR(
                                         SQLERRM
                                       ||'** ERROR_BACKTRACE: '
                                       ||dbms_utility.format_error_backtrace
                                        ,1
                                        ,4000
                                        );
                --
                xxmx_utilities_pkg.log_module_message
                     (
                      pt_i_ApplicationSuite  => gct_ApplicationSuite
                     ,pt_i_Application       => gct_Application
                     ,pt_i_BusinessEntity    => gct_BusinessEntity
                     ,pt_i_SubEntity         => ct_SubEntity
                     ,pt_i_Phase             => ct_Phase
                     ,pt_i_Severity          => 'ERROR'
                     ,pt_i_PackageName       => gct_PackageName
                     ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                     ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                     ,pt_i_ModuleMessage     => 'Oracle error encounted after Progress Indicator.'
                     ,pt_i_OracleError       => gvt_OracleError
                     );
                --
                gvv_ApplicationErrorMessage := SUBSTR('Unexpected Oracle Exception encountered after Progress Indicator "'
                                                   ||gct_PackageName
                                                   ||'.'
                                                   ||ct_ProcOrFuncName
                                                   ||'-'
                                                   ||gvv_ProgressIndicator
                                                   ||'".  Please refer to XXMX_MODULE_MESSAGES table for further details.'
                                                    ,1
                                                    ,2048
                                                     );
                --
                RAISE_APPLICATION_ERROR(xxmx_utilities_pkg.gcn_ApplicationErrorNumber, gvv_ApplicationErrorMessage);
                --
           --** END OTHERS Exception
           --
      --** END Exception Handler
      --    
    END VALIDATE_OPEN_BALANCES;
	--
END XXMX_GL_OPEN_BAL_VAL_PKG;
/