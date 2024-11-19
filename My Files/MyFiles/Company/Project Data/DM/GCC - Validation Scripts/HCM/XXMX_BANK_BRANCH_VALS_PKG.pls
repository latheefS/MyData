create or replace PACKAGE  XXMX_CORE.XXMX_BANK_BRANCH_VALS_PKG
AS

     /*
	 ******************************************************************************
     ** FILENAME  :  XXMX_BANK_BRANCH_VALS_PKG.pls
     **
     ** VERSION   :  1.0
     **
     ** EXECUTE
     ** IN SCHEMA :  APPS
     **
     ** AUTHORS   :  Veda Poojitha
     **
     ** PURPOSE   :  This script installs the package specification for the XXMX_BANK_BRANCH_VALS_PKG custom Procedures.
     **
     ** NOTES     :

     **   Vsn  Change Date  Changed By          Change Description
     ** -----  -----------  ------------------  -----------------------------------
     ** [ 1.0  DD-Mon-YYYY  Change Author       Created.                          ]
     **
     ******************************************************************************
     **
     ** XXMX_BANK_BRANCH_VALS_PKG HISTORY
     ** ------------------------------------
     **
     **   Vsn  Change Date  Changed By                              Change Description
     ** -----  -----------  ------------------                      -----------------------------------
     **   1.0  05-FEB-2024  Veda Poojitha                           Initial implementation
     ******************************************************************************
     */
    --
	/*
	******************************
    ** PROCEDURE: VALIDATE_BANKS_AND_BRANCHES
    ******************************
    */
    PROCEDURE VALIDATE_BANKS_AND_BRANCHES
                    (
                     pt_i_ApplicationSuite           IN      xxmx_module_messages.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_module_messages.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_module_messages.business_entity%TYPE
                    );	
    /*

    /*
    ******************************
    ** PROCEDURE: VALIDATE_BANKS
    ******************************
    */
    PROCEDURE VALIDATE_BANKS
                    (
                     pt_i_ApplicationSuite           IN      xxmx_module_messages.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_module_messages.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_module_messages.business_entity%TYPE
                    );	
    /*
    ******************************
    ** PROCEDURE: VALIDATE_BANK_BRANCHES
    ******************************
    */
    PROCEDURE VALIDATE_BANK_BRANCHES
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
    --
END XXMX_BANK_BRANCH_VALS_PKG;
/



/* PACKAGE BODY */

create or replace PACKAGE BODY  XXMX_CORE.XXMX_BANK_BRANCH_VALS_PKG
AS


     /*
	 ******************************************************************************
     ** FILENAME  :  XXMX_BANK_BRANCH_VALS_PKG.pls
     **
     ** VERSION   :  1.0
     **
     ** EXECUTE
     ** IN SCHEMA :  APPS
     **
     ** AUTHORS   :  Veda Poojitha
     **
     ** PURPOSE   :  This script installs the package body for the XXMX_BANK_BRANCH_VALS_PKG custom Procedures.
     **
     ** NOTES     :

     **   Vsn  Change Date  Changed By          Change Description
     ** -----  -----------  ------------------  -----------------------------------
     ** [ 1.0  DD-Mon-YYYY  Change Author       Created.                          ]
     **
     ******************************************************************************
     **
     ** XXMX_BANK_BRANCH_VALS_PKG HISTORY
     ** ------------------------------------
     **
     **   Vsn  Change Date  Changed By                              Change Description
     ** -----  -----------  ------------------                      -----------------------------------
     **   1.0  05-FEB-2024  Veda Poojitha                           Initial implementation 

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
     gct_PackageName                           CONSTANT xxmx_module_messages.package_name%TYPE       := 'XXMX_BANK_BRANCH_VALS_PKG';
     gct_ApplicationSuite                      CONSTANT xxmx_module_messages.application_suite%TYPE  := 'HCM';
     gct_Application                           CONSTANT xxmx_module_messages.application%TYPE        := 'HR';
     gct_BusinessEntity                        CONSTANT xxmx_migration_metadata.business_entity%TYPE := 'BANKS_AND_BRANCHES';
     ct_Phase                                  CONSTANT xxmx_module_messages.phase%TYPE              := 'VALIDATE';
     ct_SubEntity                              CONSTANT xxmx_module_messages.sub_entity%TYPE         := 'ALL';
	 gct_CoreSchema                            CONSTANT VARCHAR2(10)                                 := 'xxmx_core';
    --
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
    ** PROCEDURE: VALIDATE_BANKS
    ******************************
    */
    PROCEDURE VALIDATE_BANKS
                    (
                     pt_i_ApplicationSuite           IN      xxmx_module_messages.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_module_messages.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_module_messages.business_entity%TYPE
                    )
    IS

        CURSOR Banks_check(pt_i_MigrationSetID number)
        IS
        /*
        ** Within same Country there cannot be a Bank name with same Bank numbers.
        */
        SELECT   'Within same Country there cannot be a Bank name with same Bank numbers' as VALIDATION_ERROR_MESSAGE, stg.*
        from xxmx_banks_stg stg
        where 1=1
        AND migration_set_id = pt_i_MigrationSetID
        AND exists (SELECT country, bank_name, bank_number
        FROM xxmx_banks_stg stg1
        WHERE stg.migration_set_id = stg1.migration_set_id
        AND stg.bank_id=stg1.bank_id
        GROUP BY country, bank_name, bank_number
        HAVING COUNT(*) > 1)

        /*
        ** Validate country column data as it should have 2 digit ISO code and not full country name.
        */
	  UNION ALL
         SELECT  'country name should not be more than 2 digits' as VALIDATION_ERROR_MESSAGE, stg.*
         FROM    xxmx_banks_stg stg
         where   1=1
         AND     stg.migration_set_id = pt_i_MigrationSetID
	     AND     LENGTH(country_code) > 2

        /*
        ** Validate if country column is null.
        */
      UNION ALL
          SELECT   'country should not be null' as VALIDATION_ERROR_MESSAGE, stg.*
          FROM     xxmx_banks_stg stg
          WHERE    1 = 1
          AND      stg.migration_set_id = pt_i_MigrationSetID
          AND      stg.COUNTRY IS NULL

        /*
        ** Validate bank_name having Junk / Invalid characters
        */	
	 UNION ALL
        SELECT 'Bank name having Junk/Invalid characters' as VALIDATION_ERROR_MESSAGE, stg.*  
        FROM xxmx_banks_stg stg
        WHERE 1=1
		AND stg.migration_set_id= pt_i_MigrationSetID
        AND REGEXP_LIKE( bank_name, '[^[:print:]]' )

       /*
       ** Validate alternate_bank_name having Junk / Invalid characters
       */		
     UNION ALL	 
	    SELECT 'Altername Bank name having Junk/Invalid characters' as VALIDATION_ERROR_MESSAGE, stg.*  
        FROM xxmx_banks_stg stg
        WHERE 1=1
		AND stg.migration_set_id= pt_i_MigrationSetID
        AND REGEXP_LIKE( alternate_bank_name, '[^[:print:]]' )

        /*
        ** Validate short_bank_name having Junk / Invalid characters
        */	
	 UNION ALL
        SELECT 'short Bank name having Junk/Invalid characters' as VALIDATION_ERROR_MESSAGE, stg.*  
        FROM xxmx_banks_stg stg
        WHERE 1=1
		AND stg.migration_set_id= pt_i_MigrationSetID
        AND REGEXP_LIKE( short_bank_name, '[^[:print:]]' );


        TYPE banks_checks_type IS TABLE OF banks_check%ROWTYPE INDEX BY BINARY_INTEGER;
		banks_rec_tbl banks_checks_type;



	      --************************
          --** Constant Declarations
          --************************
          --
        ct_ProcOrFuncName CONSTANT xxmx_module_messages.proc_or_func_name%TYPE := 'VALIDATE_BANKS';
		ct_CoreSchema                    CONSTANT VARCHAR2(10)                                := 'xxmx_core';
        ct_CoreTable                     CONSTANT xxmx_migration_metadata.stg_table%TYPE      := 'XXMX_BANKS_VAL';
        ct_StgTable                     CONSTANT xxmx_migration_metadata.stg_table%TYPE      := 'XXMX_BANKS_STG';
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
          --** Retrieve the Migration Set ID
          --
          gvv_ProgressIndicator := '0040';
          -- 
            l_migration_set_id := get_migration_set_id(pt_i_BusinessEntity);

          IF   l_migration_set_id IS NOT NULL
          THEN

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

		OPEN Banks_check(l_migration_set_id);

		LOOP
--		 
		 FETCH Banks_check
		 BULK COLLECT INTO banks_rec_tbl
		 LIMIT xxmx_utilities_pkg.gcn_BulkCollectLimit;

		EXIT WHEN banks_rec_tbl.COUNT=0  ;


		gvv_ProgressIndicator := '0060';

FORALL i in 1..banks_rec_tbl.COUNT 

        INSERT INTO XXMX_BANKS_VAL
        (
        VALIDATION_ERROR_MESSAGE,
        FILE_SET_ID,   
        MIGRATION_SET_ID,        
        MIGRATION_SET_NAME, 
        MIGRATION_STATUS,   
        MIGRATION_ACTION,  
        BG_NAME, 
        BG_ID,    
        METADATA, 
        OBJECTNAME, 
        INSTITUTION_LEVEL,  
        BANK_ID,       
        BANK_NAME,
        BANK_TYPE,  
        SHORT_BANK_NAME, 
        ALTERNATE_BANK_NAME,  
        COUNTRY,   
        COUNTRY_CODE,    
        BANK_NUMBER,   
        END_DATE,           
        END_EFFECTIVE_DATE,           
        SOURCE_SYSTEM_OWNER,  
        SOURCE_SYSTEM_ID         
        )
        VALUES 
        (
        banks_rec_tbl(i).VALIDATION_ERROR_MESSAGE,
		banks_rec_tbl(i).FILE_SET_ID,
		banks_rec_tbl(i).MIGRATION_SET_ID,
		banks_rec_tbl(i).MIGRATION_SET_NAME,
		'VALIDATED',
		banks_rec_tbl(i).MIGRATION_ACTION,
		banks_rec_tbl(i).BG_NAME,
		banks_rec_tbl(i).BG_ID,
		banks_rec_tbl(i).METADATA,
		banks_rec_tbl(i).OBJECTNAME,
		banks_rec_tbl(i).INSTITUTION_LEVEL,
		banks_rec_tbl(i).BANK_ID,
		banks_rec_tbl(i).BANK_NAME,
		banks_rec_tbl(i).BANK_TYPE,
		banks_rec_tbl(i).SHORT_BANK_NAME,
		banks_rec_tbl(i).ALTERNATE_BANK_NAME,
		banks_rec_tbl(i).COUNTRY,
		banks_rec_tbl(i).COUNTRY_CODE,
		banks_rec_tbl(i).BANK_NUMBER,
		banks_rec_tbl(i).END_DATE,
		banks_rec_tbl(i).END_EFFECTIVE_DATE,
		banks_rec_tbl(i).SOURCE_SYSTEM_OWNER,
		banks_rec_tbl(i).SOURCE_SYSTEM_ID

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
               CLOSE Banks_check;
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
               gvt_ModuleMessage := '- Migration Set ID is not found.';
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
                    IF   Banks_check%ISOPEN
                    THEN
                         --
                         CLOSE Banks_check;
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
    END VALIDATE_BANKS;
    /*
    ******************************
    ** PROCEDURE: VALIDATE_BANK_BRANCHES
    ******************************
    */
    PROCEDURE VALIDATE_BANK_BRANCHES
                    (
                     pt_i_ApplicationSuite           IN      xxmx_module_messages.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_module_messages.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_module_messages.business_entity%TYPE
                    )
    IS



        CURSOR BANK_BRANCHES_checks(pt_i_MigrationSetID NUMBER)
        IS

        /*
        ** Validate if data uses 2 digit ISO code and not full country name
       */

        SELECT   'country more should not be more than 2 digits' as VALIDATION_ERROR_MESSAGE, stg.*
        FROM     xxmx_bank_branches_stg stg
        where    1=1
        AND      stg.migration_set_id = pt_i_MigrationSetID
        AND      LENGTH(country) > 2

       /*
       **validate if country is null
       */
     UNION ALL
       SELECT   'country is null' as VALIDATION_ERROR_MESSAGE, stg.*
       FROM     xxmx_bank_branches_stg stg
       WHERE    1 = 1
       AND      stg.migration_set_id = pt_i_MigrationSetID
       AND stg.COUNTRY IS NULL

       /*
       **Within same Country there cannot be a Bank name, bank branch Name and same bank branch numbers
       */
      UNION ALL                         
       SELECT   'Within same Country there cannot be same Bank name, same bank branch Name and same bank branch numbers' as VALIDATION_ERROR_MESSAGE, stg.*
       from xxmx_bank_branches_stg stg
       where 1=1
       AND migration_set_id = pt_i_MigrationSetID
       and exists(SELECT country, bank_name, bank_number, bank_branch_name
       FROM xxmx_bank_branches_stg stg1
       WHERE stg.migration_set_id = stg1.migration_set_id
       AND stg.bank_id=stg1.bank_id
       GROUP BY country, bank_name, bank_number, bank_branch_name
       HAVING COUNT(*) > 1)

       /*
       ** Validate bank branch Name having Junk / Invalid characters
       */	
     UNION ALL
        SELECT 'Bank branch name having Junk/Invalid characters' as VALIDATION_ERROR_MESSAGE, stg.*  
        FROM xxmx_bank_branches_stg stg
        WHERE 1=1
		AND stg.migration_set_id= pt_i_MigrationSetID
        AND REGEXP_LIKE( bank_branch_name, '[^[:print:]]' )

       /*
       **validate if bank branch name is null in bank_branches
       */
     UNION ALL
        SELECT 'bank branch name is null' as VALIDATION_ERROR_MESSAGE, stg.*  
        FROM xxmx_bank_branches_stg stg
        WHERE 1=1
		AND stg.migration_set_id= pt_i_MigrationSetID
        and bank_branch_name is null

        /*
        ** Validate short_bank_name having Junk / Invalid characters
        */	
	 UNION ALL
        SELECT 'short Bank name having Junk/Invalid characters' as VALIDATION_ERROR_MESSAGE, stg.*  
        FROM xxmx_bank_branches_stg stg
        WHERE 1=1
		AND stg.migration_set_id= pt_i_MigrationSetID
        AND REGEXP_LIKE( short_bank_name, '[^[:print:]]' );

    TYPE bank_branch_type IS TABLE OF BANK_BRANCHES_checks%ROWTYPE INDEX BY BINARY_INTEGER;
		bank_branches_rec_tbl bank_branch_type;

	      --************************
          --** Constant Declarations
          --************************
          --
        ct_ProcOrFuncName CONSTANT xxmx_module_messages.proc_or_func_name%TYPE := 'VALIDATE_BANK_BRANCHES';
		ct_CoreSchema                    CONSTANT VARCHAR2(10)                                := 'xxmx_core';
        ct_CoreTable                     CONSTANT xxmx_migration_metadata.stg_table%TYPE      := 'XXMX_BANK_BRANCHES_VAL';
        ct_StgTable                      CONSTANT xxmx_migration_metadata.stg_table%TYPE      := 'XXMX_BANK_BRANCHES_STG';
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
          --** Retrieve the Migration Set ID
          --
          gvv_ProgressIndicator := '0040';
		  --
            l_migration_set_id := get_migration_set_id(pt_i_BusinessEntity);

          IF   l_migration_set_id IS NOT NULL
          THEN

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

		OPEN BANK_BRANCHES_checks(l_migration_set_id);

		LOOP
--		 
		 FETCH BANK_BRANCHES_checks 
		 BULK COLLECT INTO bank_branches_rec_tbl
		 LIMIT xxmx_utilities_pkg.gcn_BulkCollectLimit;

		EXIT WHEN bank_branches_rec_tbl.COUNT=0  ;

				gvv_ProgressIndicator := '0060';

FORALL i in 1..bank_branches_rec_tbl.COUNT 

        INSERT INTO XXMX_BANK_BRANCHES_VAL
        (
        VALIDATION_ERROR_MESSAGE,       
        FILE_SET_ID,                     
        MIGRATION_SET_ID,                 
        MIGRATION_SET_NAME,           
        MIGRATION_STATUS,   
        MIGRATION_ACTION,   
        BG_NAME,  
        BG_ID,     
        METADATA,  
        OBJECTNAME,  
        INSTITUTION_LEVEL,   
        BANK_NAME,  
        BANK_NUMBER,   
        BANK_TYPE,   
        SHORT_BANK_NAME,   
        COUNTRY,   
        COUNTRY_CODE,   
        BANK_BRANCH_ID,         
        BANK_BRANCH_NUMBER,   
        BANK_BRANCH_NAME,  
        BANK_BRANCH_TYPE,   
        ALTERNATE_BANK_BRANCH_NAME,  
        BANK_ID,         
        BRANCH_ID,   
        EFT_SWIFT_CODE,   
        EFT_USER_NUMBER,   
        RFC,   
        END_DATE,           
        END_EFFECTIVE_DATE,          
        SOURCE_SYSTEM_OWNER,  
        SOURCE_SYSTEM_ID      
        )
        VALUES 
        (
		bank_branches_rec_tbl(i).VALIDATION_ERROR_MESSAGE,
		bank_branches_rec_tbl(i).FILE_SET_ID,
		bank_branches_rec_tbl(i).MIGRATION_SET_ID,      
		bank_branches_rec_tbl(i).MIGRATION_SET_NAME,
		'VALIDATED',   
		bank_branches_rec_tbl(i).MIGRATION_ACTION,
		bank_branches_rec_tbl(i).BG_NAME,
		bank_branches_rec_tbl(i).BG_ID,
		bank_branches_rec_tbl(i).METADATA,
		bank_branches_rec_tbl(i).OBJECTNAME,
		bank_branches_rec_tbl(i).INSTITUTION_LEVEL,
		bank_branches_rec_tbl(i).BANK_NAME,
		bank_branches_rec_tbl(i).BANK_NUMBER,
		bank_branches_rec_tbl(i).BANK_TYPE,
		bank_branches_rec_tbl(i).SHORT_BANK_NAME,
		bank_branches_rec_tbl(i).COUNTRY,
		bank_branches_rec_tbl(i).country_code,
		bank_branches_rec_tbl(i).BANK_BRANCH_ID,
		bank_branches_rec_tbl(i).BANK_BRANCH_NUMBER ,
		bank_branches_rec_tbl(i).BANK_BRANCH_NAME,
		bank_branches_rec_tbl(i).BANK_BRANCH_TYPE ,
		bank_branches_rec_tbl(i).ALTERNATE_BANK_BRANCH_NAME,
		bank_branches_rec_tbl(i).BANK_ID,
		bank_branches_rec_tbl(i).BRANCH_ID,
		bank_branches_rec_tbl(i).EFT_SWIFT_CODE,
		bank_branches_rec_tbl(i).EFT_USER_NUMBER,
		bank_branches_rec_tbl(i).RFC,
		bank_branches_rec_tbl(i).END_DATE,
		bank_branches_rec_tbl(i).END_EFFECTIVE_DATE,
		bank_branches_rec_tbl(i).SOURCE_SYSTEM_OWNER,
		bank_branches_rec_tbl(i).SOURCE_SYSTEM_ID

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

         CLOSE BANK_BRANCHES_checks; 
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
               gvt_ModuleMessage := '- Migration Set ID is not found.';
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
                    IF   BANK_BRANCHES_checks%ISOPEN
                    THEN
                         --
                         CLOSE BANK_BRANCHES_checks;
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
      --
    END VALIDATE_BANK_BRANCHES;
    /*

    --
    /*
    ******************************
    ** PROCEDURE: VALIDATE_BANKS_AND_BRANCHES
    ******************************
    */
    PROCEDURE VALIDATE_BANKS_AND_BRANCHES
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
               SELECT  DISTINCT
                      xmm.sub_entity_seq as sub_entity_seq
                      ,LOWER(xmm.val_package_name)      AS val_package_name
                      ,LOWER(xmm.val_procedure_name)        AS val_procedure_name
               FROM    xxmx_migration_metadata  xmm
               WHERE   1 = 1
               AND     xmm.application_suite      = pt_ApplicationSuite
               AND     xmm.application            = pt_Application
               AND     xmm.business_entity        = pt_BusinessEntity
               AND     NVL(xmm.enabled_flag, 'N') = 'Y'
               AND xmm.val_package_name IS NOT NULL
               ORDER BY xmm.sub_entity_seq;


gvv_SQLStatement        VARCHAR2(32000);
gcv_SQLSpace  CONSTANT  VARCHAR2(1) := ' ';	
gvt_Phase     VARCHAR2(15) := 'VALIDATE';	

    BEGIN
        ct_ProcOrFuncName := 'VALIDATE_BANKS_AND_BRANCHES';
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
    END VALIDATE_BANKS_AND_BRANCHES;
    --
    --
END XXMX_BANK_BRANCH_VALS_PKG;