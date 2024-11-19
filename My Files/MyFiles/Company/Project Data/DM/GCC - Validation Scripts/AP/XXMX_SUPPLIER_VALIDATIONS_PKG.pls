create or replace PACKAGE           XXMX_SUPPLIER_VALIDATIONS_PKG
AS

     /*
	 ******************************************************************************
     ** FILENAME  :  XXMX_SUPPLIER_VALIDATIONS_PKG.pls
     **
     ** VERSION   :  1.0
     **
     ** EXECUTE
     ** IN SCHEMA :  APPS
     **
     ** AUTHORS   :  Raghu Chilukoori/Meenakshi Rajendran
     **
     ** PURPOSE   :  This script installs the package specification for the XXMX_SUPPLIER_VALIDATIONS_PKG custom Procedures.
     **
     ** NOTES     :

     **   Vsn  Change Date  Changed By          Change Description
     ** -----  -----------  ------------------  -----------------------------------
     ** [ 1.0  DD-Mon-YYYY  Change Author       Created.                          ]
     **
     ******************************************************************************
     **
     ** XXMX_SUPPLIER_VALIDATIONS_PKG HISTORY
     ** ------------------------------------
     **
     **   Vsn  Change Date  Changed By                             Change Description
     ** -----  -----------  ------------------                      -----------------------------------
     **   1.0  13-OCT-2023  Raghu Chilukoori/Meenakshi Rajendran    Initial implementation
     ******************************************************************************
     */
    --
    /*
    ******************************
    ** PROCEDURE: VALIDATE_SUPPLIERS
    ******************************
    */
    PROCEDURE VALIDATE_SUPPLIERS
                    (
                     pt_i_ApplicationSuite           IN      xxmx_module_messages.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_module_messages.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_module_messages.business_entity%TYPE
                    );	
    /*
    ******************************
    ** PROCEDURE: VALIDATE_SUPPLIER_PROFILES
    ******************************
    */
    PROCEDURE VALIDATE_SUPPLIER_PROFILES
                    (
                     pt_i_ApplicationSuite           IN      xxmx_module_messages.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_module_messages.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_module_messages.business_entity%TYPE
                    );
    /*
    ******************************
    ** PROCEDURE: VALIDATE_SUPPLIER_ADDRESSES
    ******************************
    */
    PROCEDURE VALIDATE_SUPPLIER_ADDRESSES
                    (
                     pt_i_ApplicationSuite           IN      xxmx_module_messages.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_module_messages.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_module_messages.business_entity%TYPE
                    );
    /*
    ******************************
    ** PROCEDURE: VALIDATE_SUPPLIER_CONTATCS
    ******************************
    */
    PROCEDURE VALIDATE_SUPPLIER_CONTATCS
                    (
                     pt_i_ApplicationSuite           IN      xxmx_module_messages.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_module_messages.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_module_messages.business_entity%TYPE
                    );
    /*
    ******************************
    ** PROCEDURE: VALIDATE_SUPPLIER_SITES
    ******************************
    */
    PROCEDURE VALIDATE_SUPPLIER_SITES
                    (
                     pt_i_ApplicationSuite           IN      xxmx_module_messages.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_module_messages.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_module_messages.business_entity%TYPE
                    );
    /*
    ******************************
    ** PROCEDURE: VALIDATE_SUPPLIER_SITE_ASSIG
    ******************************
    */
    PROCEDURE VALIDATE_SUPPLIER_SITE_ASSIGN
                    (
                     pt_i_ApplicationSuite           IN      xxmx_module_messages.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_module_messages.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_module_messages.business_entity%TYPE
                    );
    /*
    ******************************
    ** PROCEDURE: VALIDATE_SUPPLIER_BANK_ACCTS
    ******************************
    */
    PROCEDURE VALIDATE_SUPPLIER_BANK_ACCTS
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
END XXMX_SUPPLIER_VALIDATIONS_PKG;
/


create or replace PACKAGE BODY XXMX_SUPPLIER_VALIDATIONS_PKG
AS


     /*
	 ******************************************************************************
     ** FILENAME  :  XXMX_SUPPLIER_VALIDATIONS_PKG.pls
     **
     ** VERSION   :  1.0
     **
     ** EXECUTE
     ** IN SCHEMA :  APPS
     **
     ** AUTHORS   :  Raghu Chilukoori/Meenakshi Rajendran
     **
     ** PURPOSE   :  This script installs the package body for the XXMX_SUPPLIER_VALIDATIONS_PKG custom Procedures.
     **
     ** NOTES     :
	 
     **   Vsn  Change Date  Changed By          Change Description
     ** -----  -----------  ------------------  -----------------------------------
     ** [ 1.0  DD-Mon-YYYY  Change Author       Created.                          ]
     **
     ******************************************************************************
     **
     ** XXMX_SUPPLIER_VALIDATIONS_PKG HISTORY
     ** ------------------------------------
     **
     **   Vsn  Change Date  Changed By                             Change Description
     ** -----  -----------  ------------------                      -----------------------------------
     **   1.0  13-OCT-2023  Raghu Chilukoori/Meenakshi Rajendran    Initial implementation, 
	                                                                MR comments - Some Validation scripts are kept on hold and it will be added later in the future.
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
     gct_PackageName                           CONSTANT xxmx_module_messages.package_name%TYPE       := 'XXMX_SUPPLIER_VALIDATIONS_PKG';
     gct_ApplicationSuite                      CONSTANT xxmx_module_messages.application_suite%TYPE  := 'FIN';
     gct_Application                           CONSTANT xxmx_module_messages.application%TYPE        := 'AP';
     gct_BusinessEntity                        CONSTANT xxmx_migration_metadata.business_entity%TYPE := 'SUPPLIERS';
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
    ** PROCEDURE: VALIDATE_SUPPLIER_PROFILES
    ******************************
    */
    PROCEDURE VALIDATE_SUPPLIER_PROFILES
                    (
                     pt_i_ApplicationSuite           IN      xxmx_module_messages.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_module_messages.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_module_messages.business_entity%TYPE
                    )
    IS
     
        CURSOR supplier_profile_check(pt_i_MigrationSetID number)
        IS
	/*
     ** Validate Supplier Records getting duplicated
     */
          select stg1.validation_error_msg,stg.*
          FROM xxmx_ap_suppliers_stg stg,
          (SELECT   'Duplicate Supplier Records' as validation_error_msg, stg.supplier_number, stg.supplier_name
          FROM     xxmx_ap_suppliers_stg stg
          WHERE    1 = 1
          AND      migration_set_id = pt_i_MigrationSetID
          GROUP BY supplier_number, supplier_name
          HAVING   COUNT(1) > 1
          )stg1
          WHERE stg.supplier_number=stg1.supplier_number
          AND stg.supplier_name=stg1.supplier_name
     /*
     ** Validate Supplier name getting duplicated
     */
          UNION ALL
          SELECT   'Duplicate Supplier Name' as validation_error_msg, stg.*
          FROM     xxmx_ap_suppliers_stg stg
          WHERE    1 = 1
          AND      migration_set_id = pt_i_MigrationSetID
          AND      EXISTS ( SELECT 1
                            FROM   xxmx_ap_suppliers_stg stg1
                            WHERE  stg1.supplier_name != stg.supplier_name
                            AND    TRIM(UPPER(stg1.supplier_name)) = TRIM(UPPER(stg.supplier_name)))
     /*
     ** Validate Supplier TRN is duplicated
     */
      UNION ALL
         ( SELECT    'Duplicate Supplier TRN' as validation_error_msg,stg.*
          FROM     xxmx_ap_suppliers_stg stg
          WHERE    1 = 1
          AND      migration_set_id = pt_i_MigrationSetID
          AND      EXISTS ( SELECT taxpayer_country, taxpayer_id, tax_registration_number
                            FROM   xxmx_ap_suppliers_stg stg1
                            WHERE  stg1.migration_set_id = stg.migration_set_id
                            GROUP  BY  taxpayer_country, taxpayer_id, tax_registration_number
                            HAVING COUNT(1) > 1 )
          UNION
          SELECT    'Duplicate Supplier TRN' as validation_error_msg,stg.*
          FROM     xxmx_ap_suppliers_stg stg
          WHERE    1 = 1
          AND      migration_set_id = pt_i_MigrationSetID
          AND      EXISTS ( SELECT taxpayer_country, taxpayer_id
                            FROM   xxmx_ap_suppliers_stg stg1
                            WHERE  stg1.migration_set_id = stg.migration_set_id
                            GROUP  BY  taxpayer_country, taxpayer_id
                            HAVING COUNT(1) > 1 )
          UNION
          SELECT    'Duplicate Supplier TRN' as validation_error_msg,stg.*
          FROM     xxmx_ap_suppliers_stg stg
          WHERE    1 = 1
          AND      migration_set_id = pt_i_MigrationSetID
          AND      EXISTS ( SELECT tax_registration_number
                            FROM   xxmx_ap_suppliers_stg stg1
                            WHERE  stg1.migration_set_id = stg.migration_set_id
                            GROUP  BY  tax_registration_number
                            HAVING COUNT(1) > 1 )
                            )
		
     /*
     ** Validate Supplier Name having Junk / Invalid characters
     */		
		UNION ALL	
		SELECT 'Supplier name having Junk/Invalid characters' as validation_error_msg, stg.*  
        FROM xxmx_ap_suppliers_stg stg
        WHERE 1=1
		AND stg.migration_set_id= pt_i_MigrationSetID
        AND REGEXP_LIKE( supplier_name, '[^[:print:]]' )
		
     /*
     ** Validate Suppliers when Federal Reportable flag is Y/N
     */		
		UNION ALL 
		(SELECT 'Federeal Income Tax Type should not be null' as validation_error_msg,stg.*  
        FROM xxmx_ap_suppliers_stg stg
        WHERE 1=1
        AND stg.migration_set_id= pt_i_MigrationSetID
        AND federal_reportable = 'Y'
        AND federal_income_tax_type IS NULL
		UNION
		SELECT 'Taxpayer country should be null' as validation_error_msg,stg.*  
        FROM xxmx_ap_suppliers_stg stg
        WHERE 1=1
        AND stg.migration_set_id= pt_i_MigrationSetID
        AND NVL(federal_reportable,'X') <> 'Y'
        AND taxpayer_country IS NOT NULL
        );
		
		
        TYPE supprof_type IS TABLE OF supplier_profile_check%ROWTYPE INDEX BY BINARY_INTEGER;
		supprof_rec_tbl supprof_type;
	
	       --************************
          --** Constant Declarations
          --************************
          --
        ct_ProcOrFuncName CONSTANT xxmx_module_messages.proc_or_func_name%TYPE := 'VALIDATE_SUPPLIER_PROFILES';
		ct_CoreSchema                    CONSTANT VARCHAR2(10)                                := 'xxmx_core';
        ct_CoreTable                     CONSTANT xxmx_migration_metadata.stg_table%TYPE      := 'XXMX_AP_SUPPLIERS_VAL';
        ct_StgTable                     CONSTANT xxmx_migration_metadata.stg_table%TYPE      := 'XXMX_AP_SUPPLIERS_STG';
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
		
		OPEN supplier_profile_check(l_migration_set_id);

		LOOP
--		 
		 FETCH supplier_profile_check
		 BULK COLLECT INTO supprof_rec_tbl
		 LIMIT xxmx_utilities_pkg.gcn_BulkCollectLimit;
		 
		EXIT WHEN supprof_rec_tbl.COUNT=0  ;
		
		gvv_ProgressIndicator := '0060';
 
FORALL i in 1..supprof_rec_tbl.COUNT 

        INSERT INTO XXMX_AP_SUPPLIERS_VAL
        (
        VALIDATION_ERROR_MESSAGE,
		MIGRATION_SET_ID,
		MIGRATION_SET_NAME,
		MIGRATION_STATUS,
		IMPORT_ACTION,
		SUPPLIER_ID,
		SUPPLIER_NAME,
		SUPPLIER_NAME_NEW,
		SUPPLIER_NUMBER,
		ALTERNATE_NAME,
		TAX_ORGANIZATION_TYPE,
		SUPPLIER_TYPE,
		INACTIVE_DATE,
		BUSINESS_RELATIONSHIP,
		PARENT_SUPPLIER,
		ALIAS,
		DUNS_NUMBER,
		ONE_TIME_SUPPLIER,
		CUSTOMER_NUMBER,
		SIC,
		NATIONAL_INSURANCE_NUMBER,
		CORPORATE_WEB_SITE,
		CHIEF_EXECUTIVE_TITLE,
		CHIF_EXECUTIVE_NAME,
		BUSINESS_CLASSIFICATION,
		TAXPAYER_COUNTRY,
		TAXPAYER_ID,
		FEDERAL_REPORTABLE,
		FEDERAL_INCOME_TAX_TYPE,
		STATE_REPORTABLE,
		TAX_REPORTING_NAME,
		NAME_CONTROL,
		TAX_VERIFICATION_DATE,
		USE_WITHHOLDING_TAX,
		WITHHOLDING_TAX_GROUP,
		SUPPLIER_VAT_CODE,
		TAX_REGISTRATION_NUMBER
        )
        VALUES 
        (
        supprof_rec_tbl(i).validation_error_msg,
		supprof_rec_tbl(i).MIGRATION_SET_ID,
		supprof_rec_tbl(i).MIGRATION_SET_NAME,
		'VALIDATED',
		supprof_rec_tbl(i).IMPORT_ACTION,
		supprof_rec_tbl(i).SUPPLIER_ID,
		supprof_rec_tbl(i).SUPPLIER_NAME,
		supprof_rec_tbl(i).SUPPLIER_NAME_NEW,
		supprof_rec_tbl(i).SUPPLIER_NUMBER,
		supprof_rec_tbl(i).ALTERNATE_NAME,
		supprof_rec_tbl(i).TAX_ORGANIZATION_TYPE,
		supprof_rec_tbl(i).SUPPLIER_TYPE,
		supprof_rec_tbl(i).INACTIVE_DATE,
		supprof_rec_tbl(i).BUSINESS_RELATIONSHIP,
		supprof_rec_tbl(i).PARENT_SUPPLIER,
		supprof_rec_tbl(i).ALIAS,
		supprof_rec_tbl(i).DUNS_NUMBER,
		supprof_rec_tbl(i).ONE_TIME_SUPPLIER,
		supprof_rec_tbl(i).CUSTOMER_NUMBER,
		supprof_rec_tbl(i).SIC,
		supprof_rec_tbl(i).NATIONAL_INSURANCE_NUMBER,
		supprof_rec_tbl(i).CORPORATE_WEB_SITE,
		supprof_rec_tbl(i).CHIEF_EXECUTIVE_TITLE,
		supprof_rec_tbl(i).CHIF_EXECUTIVE_NAME,
		supprof_rec_tbl(i).BUSINESS_CLASSIFICATION,
		supprof_rec_tbl(i).TAXPAYER_COUNTRY,
		supprof_rec_tbl(i).TAXPAYER_ID,
		supprof_rec_tbl(i).FEDERAL_REPORTABLE,
		supprof_rec_tbl(i).FEDERAL_INCOME_TAX_TYPE,
		supprof_rec_tbl(i).STATE_REPORTABLE,
		supprof_rec_tbl(i).TAX_REPORTING_NAME,
		supprof_rec_tbl(i).NAME_CONTROL,
		supprof_rec_tbl(i).TAX_VERIFICATION_DATE,
		supprof_rec_tbl(i).USE_WITHHOLDING_TAX,
		supprof_rec_tbl(i).WITHHOLDING_TAX_GROUP,
		supprof_rec_tbl(i).SUPPLIER_VAT_CODE,
		supprof_rec_tbl(i).TAX_REGISTRATION_NUMBER
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
               CLOSE supplier_profile_check;
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
                    IF   supplier_profile_check%ISOPEN
                    THEN
                         --
                         CLOSE supplier_profile_check;
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
    END VALIDATE_SUPPLIER_PROFILES;
    /*
    ******************************
    ** PROCEDURE: VALIDATE_SUPPLIER_ADDRESSES
    ******************************
    */
    PROCEDURE VALIDATE_SUPPLIER_ADDRESSES
                    (
                     pt_i_ApplicationSuite           IN      xxmx_module_messages.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_module_messages.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_module_messages.business_entity%TYPE
                    )
    IS
	
	

        CURSOR supplier_addrs_check(pt_i_MigrationSetID NUMBER)
        IS
	 /*
     ** Validate Supplier Address Records getting duplicated
     */
         SELECT stg1.validation_error_msg,stg.*
		 FROM xxmx_ap_supp_addrs_stg stg,
		 (SELECT   'Duplicate Supplier Address Records' as validation_error_msg,  stg.supplier_name,stg.address_name
          FROM     xxmx_ap_supp_addrs_stg stg
          WHERE    1 = 1
          AND      migration_set_id = pt_i_MigrationSetID
          GROUP BY  stg.supplier_name,stg.address_name
          HAVING   COUNT(1) > 1
		  )stg1
		  WHERE stg.supplier_name=stg1.supplier_name
		  AND stg.address_name=stg1.address_name

     /*
     ** Validate Supplier Name having Junk / Invalid characters
     */		
		UNION ALL		
		SELECT 'Supplier Address having Junk/Invalid characters' as validation_error_msg, stg.*  
        FROM xxmx_ap_supp_addrs_stg stg
        WHERE 1=1
        AND  ((REGEXP_LIKE ( stg.address1,'[^[:print:]]' )) OR
			  (REGEXP_LIKE ( stg.address2,'[^[:print:]]' )) OR
			  (REGEXP_LIKE ( stg.address3,'[^[:print:]]' )) OR 
			  (REGEXP_LIKE ( stg.address4,'[^[:print:]]' )) OR 
			  (REGEXP_LIKE ( stg.city,'[^[:print:]]' )) OR 
			  (REGEXP_LIKE ( stg.postal_Code,'[^[:print:]]' )) OR 
			  (REGEXP_LIKE ( stg.state,'[^[:print:]]' )) OR 
			  (REGEXP_LIKE ( stg.province,'[^[:print:]]' )) OR 
			  ( REGEXP_LIKE ( stg.county,'[^[:print:]]' )) );

        TYPE suppaddrs_type IS TABLE OF supplier_addrs_check%ROWTYPE INDEX BY BINARY_INTEGER;
		suppaddrs_rec_tbl suppaddrs_type;
		
			
	       --************************
          --** Constant Declarations
          --************************
          --
        ct_ProcOrFuncName CONSTANT xxmx_module_messages.proc_or_func_name%TYPE := 'VALIDATE_SUPPLIER_ADDRESSES';
		ct_CoreSchema                    CONSTANT VARCHAR2(10)                                := 'xxmx_core';
        ct_CoreTable                     CONSTANT xxmx_migration_metadata.stg_table%TYPE      := 'XXMX_AP_SUPP_ADDRS_VAL';
        ct_StgTable                      CONSTANT xxmx_migration_metadata.stg_table%TYPE      := 'XXMX_AP_SUPP_ADDRS_STG';
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
		
		OPEN supplier_addrs_check(l_migration_set_id);

		LOOP
--		 
		 FETCH supplier_addrs_check 
		 BULK COLLECT INTO suppaddrs_rec_tbl
		 LIMIT xxmx_utilities_pkg.gcn_BulkCollectLimit;

		EXIT WHEN suppaddrs_rec_tbl.COUNT=0  ;
		
				gvv_ProgressIndicator := '0060';
 
FORALL i in 1..suppaddrs_rec_tbl.COUNT 

        INSERT INTO XXMX_AP_SUPP_ADDRS_VAL
        (
        VALIDATION_ERROR_MESSAGE,
		MIGRATION_SET_ID,
		MIGRATION_SET_NAME,
		MIGRATION_STATUS,
		LOCATION_ID,
		SUPPLIER_SITE_ID,
		PARTY_SITE_ID,
		IMPORT_ACTION,
		SUPPLIER_NAME,
		ADDRESS_NAME,
		ADDRESS_NAME_NEW,
		COUNTRY,
		ADDRESS1,
		ADDRESS2,
		ADDRESS3,
		ADDRESS4,
		PHONETIC_ADDRESS_LINE,
		ADDRESS_ELEMENT_ATTRIBUTE_1,
		ADDRESS_ELEMENT_ATTRIBUTE_2 ,
		ADDRESS_ELEMENT_ATTRIBUTE_3 ,
		ADDRESS_ELEMENT_ATTRIBUTE_4,
		ADDRESS_ELEMENT_ATTRIBUTE_5 ,
		BUILDING,
		FLOOR_NUMBER,
		CITY,
		STATE,
		PROVINCE,
		COUNTY,
		POSTAL_CODE,
		POSTAL_PLUS_4_CODE,
		ADDRESSEE,
		GLOBAL_LOCATION_NUMBER,
		LANGUAGE,
		INACTIVE_DATE,
		PHONE_COUNTRY_CODE,
		PHONE_AREA_CODE,
		PHONE,
		PHONE_EXTENSION,
		FAX_COUNTRY_CODE,
		FAX_AREA_CODE,
		FAX,
		RFQ_OR_BIDDING,
		ORDERING,
		PAY,
		EMAIL_ADDRESS,
		DELIVERY_CHANNEL,
		BANK_INSTRUCTION_1,
		BANK_INSTRUCTION_2,
		BANK_INSTRUCTION,
		SETTLEMENT_PRIORITY,
		PAYMENT_TEXT_MESSAGE_1,
		PAYMENT_TEXT_MESSAGE_2,
		PAYMENT_TEXT_MESSAGE_3,
		PAYEE_SERVICE_LEVEL,
		PAY_EACH_DOCUMENT_ALONE,
		BANK_CHARGE_BEARER,
		PAYMENT_REASON,
		PAYMENT_REASON_COMMENTS,
		DELIVERY_METHOD,
		REMITTANCE_E_MAIL,
		REMITTANCE_FAX
        )
        VALUES 
        (
		suppaddrs_rec_tbl(i).VALIDATION_ERROR_MSG,
		suppaddrs_rec_tbl(i).MIGRATION_SET_ID,
		suppaddrs_rec_tbl(i).MIGRATION_SET_NAME,
		'VALIDATED',
		suppaddrs_rec_tbl(i).LOCATION_ID,
		suppaddrs_rec_tbl(i).SUPPLIER_SITE_ID,
		suppaddrs_rec_tbl(i).PARTY_SITE_ID,
		suppaddrs_rec_tbl(i).IMPORT_ACTION,
		suppaddrs_rec_tbl(i).SUPPLIER_NAME,
		suppaddrs_rec_tbl(i).ADDRESS_NAME,
		suppaddrs_rec_tbl(i).ADDRESS_NAME_NEW,
		suppaddrs_rec_tbl(i).COUNTRY,
		suppaddrs_rec_tbl(i).ADDRESS1,
		suppaddrs_rec_tbl(i).ADDRESS2,
		suppaddrs_rec_tbl(i).ADDRESS3,
		suppaddrs_rec_tbl(i).ADDRESS4,
		suppaddrs_rec_tbl(i).PHONETIC_ADDRESS_LINE,
		suppaddrs_rec_tbl(i).ADDRESS_ELEMENT_ATTRIBUTE_1,
		suppaddrs_rec_tbl(i).ADDRESS_ELEMENT_ATTRIBUTE_2 ,
		suppaddrs_rec_tbl(i).ADDRESS_ELEMENT_ATTRIBUTE_3 ,
		suppaddrs_rec_tbl(i).ADDRESS_ELEMENT_ATTRIBUTE_4,
		suppaddrs_rec_tbl(i).ADDRESS_ELEMENT_ATTRIBUTE_5 ,
		suppaddrs_rec_tbl(i).BUILDING,
		suppaddrs_rec_tbl(i).FLOOR_NUMBER,
		suppaddrs_rec_tbl(i).CITY,
		suppaddrs_rec_tbl(i).STATE,
		suppaddrs_rec_tbl(i).PROVINCE,
		suppaddrs_rec_tbl(i).COUNTY,
		suppaddrs_rec_tbl(i).POSTAL_CODE,
		suppaddrs_rec_tbl(i).POSTAL_PLUS_4_CODE,
		suppaddrs_rec_tbl(i).ADDRESSEE,
		suppaddrs_rec_tbl(i).GLOBAL_LOCATION_NUMBER,
		suppaddrs_rec_tbl(i).LANGUAGE,
		suppaddrs_rec_tbl(i).INACTIVE_DATE,
		suppaddrs_rec_tbl(i).PHONE_COUNTRY_CODE,
		suppaddrs_rec_tbl(i).PHONE_AREA_CODE,
		suppaddrs_rec_tbl(i).PHONE,
		suppaddrs_rec_tbl(i).PHONE_EXTENSION,
		suppaddrs_rec_tbl(i).FAX_COUNTRY_CODE,
		suppaddrs_rec_tbl(i).FAX_AREA_CODE,
		suppaddrs_rec_tbl(i).FAX,
		suppaddrs_rec_tbl(i).RFQ_OR_BIDDING,
		suppaddrs_rec_tbl(i).ORDERING,
		suppaddrs_rec_tbl(i).PAY,
		suppaddrs_rec_tbl(i).EMAIL_ADDRESS,
		suppaddrs_rec_tbl(i).DELIVERY_CHANNEL,
		suppaddrs_rec_tbl(i).BANK_INSTRUCTION_1,
		suppaddrs_rec_tbl(i).BANK_INSTRUCTION_2,
		suppaddrs_rec_tbl(i).BANK_INSTRUCTION,
		suppaddrs_rec_tbl(i).SETTLEMENT_PRIORITY,
		suppaddrs_rec_tbl(i).PAYMENT_TEXT_MESSAGE_1,
		suppaddrs_rec_tbl(i).PAYMENT_TEXT_MESSAGE_2,
		suppaddrs_rec_tbl(i).PAYMENT_TEXT_MESSAGE_3,
		suppaddrs_rec_tbl(i).PAYEE_SERVICE_LEVEL,
		suppaddrs_rec_tbl(i).PAY_EACH_DOCUMENT_ALONE,
		suppaddrs_rec_tbl(i).BANK_CHARGE_BEARER,
		suppaddrs_rec_tbl(i).PAYMENT_REASON,
		suppaddrs_rec_tbl(i).PAYMENT_REASON_COMMENTS,
		suppaddrs_rec_tbl(i).DELIVERY_METHOD,
		suppaddrs_rec_tbl(i).REMITTANCE_E_MAIL,
		suppaddrs_rec_tbl(i).REMITTANCE_FAX

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

         CLOSE supplier_addrs_check; 
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
                    IF   supplier_addrs_check%ISOPEN
                    THEN
                         --
                         CLOSE supplier_addrs_check;
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
    END VALIDATE_SUPPLIER_ADDRESSES;
    /*
    ******************************
    ** PROCEDURE: VALIDATE_SUPPLIER_CONTATCS
    ******************************
    */
    PROCEDURE VALIDATE_SUPPLIER_CONTATCS
                    (
                     pt_i_ApplicationSuite           IN      xxmx_module_messages.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_module_messages.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_module_messages.business_entity%TYPE
                    )
    IS

        /*
		** Validate Supplier Contact with First Name null or Email Address null or Email address not having ‘@’
		*/
		  CURSOR supplier_contact_chk(pt_i_MigrationSetID NUMBER)
		  IS
	      SELECT   'Supplier Contact Detail First Name/Email Address is not valid. ' as validation_error_msg,  stg.*
          FROM     xxmx_ap_supp_contacts_stg stg
          WHERE    1 = 1
          AND      migration_set_id = pt_i_MigrationSetID
          AND    (stg.first_name is null
                    or stg.email_address is null
                    OR stg.email_address NOT LIKE '%@%'); 

        TYPE suppcont_type IS TABLE OF supplier_contact_chk%ROWTYPE INDEX BY BINARY_INTEGER;
		suppcont_rec_tbl suppcont_type;
		
		 --************************
          --** Constant Declarations
          --************************
          --
        ct_ProcOrFuncName CONSTANT xxmx_module_messages.proc_or_func_name%TYPE := 'VALIDATE_SUPPLIER_CONTATCS';
		ct_CoreSchema                    CONSTANT VARCHAR2(10)                                := 'xxmx_core';
        ct_CoreTable                     CONSTANT xxmx_migration_metadata.stg_table%TYPE      := 'XXMX_AP_SUPP_CONTACTS_VAL';
        ct_StgTable                      CONSTANT xxmx_migration_metadata.stg_table%TYPE      := 'XXMX_AP_SUPP_CONTACTS_STG';
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
                     pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                    ,pt_i_Application       => pt_i_Application
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
		
		OPEN supplier_contact_chk(l_migration_set_id);

		LOOP
	 
		 FETCH supplier_contact_chk 
		 BULK COLLECT INTO suppcont_rec_tbl
		 LIMIT xxmx_utilities_pkg.gcn_BulkCollectLimit;

		EXIT WHEN suppcont_rec_tbl.COUNT=0  ;
		
				gvv_ProgressIndicator := '0060';
 
FORALL i in 1..suppcont_rec_tbl.COUNT 

        INSERT INTO XXMX_AP_SUPP_CONTACTS_VAL
        (
        VALIDATION_ERROR_MESSAGE,
		MIGRATION_SET_ID,
		MIGRATION_SET_NAME,
		MIGRATION_STATUS,
		IMPORT_ACTION,
		SUPPLIER_CONTACT_ID,
		SUPPLIER_NAME,
		PREFIX,
		FIRST_NAME,
		FIRST_NAME_NEW,
		MIDDLE_NAME,
		LAST_NAME,
		LAST_NAME_NEW,
		JOB_TITLE,
		PRIMARY_ADMIN_CONTACT,
		EMAIL_ADDRESS,
		EMAIL_ADDRESS_NEW,
		PHONE_COUNTRY_CODE,
		AREA_CODE,
		PHONE,
		PHONE_EXTENSION,
		FAX_COUNTRY_CODE,
		FAX_AREA_CODE,
		FAX,
		MOBILE_COUNTRY_CODE,
		MOBILE_AREA_CODE,
		MOBILE,
		INACTIVE_DATE
        )
        VALUES 
        (
        suppcont_rec_tbl(i).VALIDATION_ERROR_MSG,
		suppcont_rec_tbl(i).MIGRATION_SET_ID,
		suppcont_rec_tbl(i).MIGRATION_SET_NAME,
		'VALIDATED',
		suppcont_rec_tbl(i).IMPORT_ACTION,
		suppcont_rec_tbl(i).SUPPLIER_CONTACT_ID,
		suppcont_rec_tbl(i).SUPPLIER_NAME,
		suppcont_rec_tbl(i).PREFIX,
		suppcont_rec_tbl(i).FIRST_NAME,
		suppcont_rec_tbl(i).FIRST_NAME_NEW,
		suppcont_rec_tbl(i).MIDDLE_NAME,
		suppcont_rec_tbl(i).LAST_NAME,
		suppcont_rec_tbl(i).LAST_NAME_NEW,
		suppcont_rec_tbl(i).JOB_TITLE,
		suppcont_rec_tbl(i).PRIMARY_ADMIN_CONTACT,
		suppcont_rec_tbl(i).EMAIL_ADDRESS,
		suppcont_rec_tbl(i).EMAIL_ADDRESS_NEW,
		suppcont_rec_tbl(i).PHONE_COUNTRY_CODE,
		suppcont_rec_tbl(i).AREA_CODE,
		suppcont_rec_tbl(i).PHONE,
		suppcont_rec_tbl(i).PHONE_EXTENSION,
		suppcont_rec_tbl(i).FAX_COUNTRY_CODE,
		suppcont_rec_tbl(i).FAX_AREA_CODE,
		suppcont_rec_tbl(i).FAX,
		suppcont_rec_tbl(i).MOBILE_COUNTRY_CODE,
		suppcont_rec_tbl(i).MOBILE_AREA_CODE,
		suppcont_rec_tbl(i).MOBILE,
		suppcont_rec_tbl(i).INACTIVE_DATE
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
               CLOSE supplier_contact_chk;
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
                    IF   supplier_contact_chk%ISOPEN
                    THEN
                         --
                         CLOSE supplier_contact_chk;
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
    END VALIDATE_SUPPLIER_CONTATCS;
    /*
    ******************************
    ** PROCEDURE: VALIDATE_SUPPLIER_SITES
    ******************************
    */
    PROCEDURE VALIDATE_SUPPLIER_SITES
                    (
                     pt_i_ApplicationSuite           IN      xxmx_module_messages.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_module_messages.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_module_messages.business_entity%TYPE
                    )
    IS


	
		CURSOR 	supplier_sites_check(pt_i_MigrationSetID NUMBER)		
        IS	
     /*
     ** Validate Supplier Site Name having Junk / Invalid characters
     */			
		SELECT 'Supplier site name having Junk/Invalid characters' as validation_error_msg, stg.*  
        FROM xxmx_ap_supplier_sites_stg stg
        WHERE 1=1
		AND stg.migration_set_id= pt_i_MigrationSetID
        AND REGEXP_LIKE( supplier_site, '[^[:print:]]' )
		
	 /*
     ** Validate Supplier Sites whose Remittance Advice Delivery Method is null however Remittance Email or Remittance Fax is not null
     */
		UNION ALL
		SELECT 'Supplier Site Remittance Advice Delivery Method is null' as validation_error_msg,stg.* 
        FROM xxmx_ap_supplier_sites_stg stg
		WHERE 1=1
		AND stg.migration_set_id= pt_i_MigrationSetID
		AND ((stg.remittance_e_mail IS NOT NULL OR stg.remittance_fax IS NOT NULL) 
              AND (stg.delivery_method IS NULL))
			  
	 /*
     ** Validate Supplier Sites where Hold Reason cannot be null when the supplier has been applied any of the three 'Hold from Payment' holds
     */	  
		UNION ALL
		SELECT 'Hold Reason is null' as validation_error_msg,stg.* 
		FROM xxmx_ap_supplier_sites_stg stg
		WHERE 1=1
		AND stg.migration_set_id= pt_i_MigrationSetID
		AND (stg.hold_all_invoices='Y' OR stg.hold_unmatched_invoices = 'Y' OR stg.hold_unvalidated_invoices = 'Y')
		AND  stg.hold_reason IS NULL
		
		
	 /*
     ** Validate Supplier Sites where Address Name is blank
     */		
		UNION ALL		
		SELECT 'Supplier site address name is null' as validation_error_msg, stg.*  
        FROM xxmx_ap_supplier_sites_stg stg
        WHERE 1=1
		AND stg.migration_set_id= pt_i_MigrationSetID
        AND stg.address_name IS NULL
		
	 /*
     ** Validate Supplier Sites where Pay Site Flag or Purchasing Site Flag is 'Y' and where RFQ Only Site Flag = 'Y'
     */	
		UNION ALL
		SELECT 'Pay Site or Purchasing Site Flag cannot be ''Y'' if RFQ Site Flag is ''Y'' ' as validation_error_msg,stg.* 
		FROM xxmx_ap_supplier_sites_stg stg
		WHERE 1=1
		AND stg.migration_set_id= pt_i_MigrationSetID
		AND   stg.sourcing_only  = 'Y'
		AND    (stg.purchasing= 'Y' or stg.pay = 'Y');
		
		TYPE suppsite_type IS TABLE OF supplier_sites_check%ROWTYPE INDEX BY BINARY_INTEGER;
		suppsite_rec_tbl suppsite_type;
		
		  --************************
          --** Constant Declarations
          --************************
          --
        ct_ProcOrFuncName CONSTANT xxmx_module_messages.proc_or_func_name%TYPE := 'VALIDATE_SUPPLIER_SITES';
		ct_CoreSchema                    CONSTANT VARCHAR2(10)                                := 'xxmx_core';
        ct_CoreTable                     CONSTANT xxmx_migration_metadata.stg_table%TYPE      := 'XXMX_AP_SUPPLIER_SITES_VAL';
        ct_StgTable                     CONSTANT xxmx_migration_metadata.stg_table%TYPE      := 'XXMX_AP_SUPPLIER_SITES_STG';
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
                     pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                    ,pt_i_Application       => pt_i_Application
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
		
		
		OPEN supplier_sites_check(l_migration_set_id);

		LOOP

--		 
		 FETCH supplier_sites_check 
		 BULK COLLECT INTO suppsite_rec_tbl
		  LIMIT xxmx_utilities_pkg.gcn_BulkCollectLimit;

		EXIT WHEN suppsite_rec_tbl.COUNT=0  ;
		
				gvv_ProgressIndicator := '0060';
 
FORALL i in 1..suppsite_rec_tbl.COUNT 

        INSERT INTO XXMX_AP_SUPPLIER_SITES_VAL
        (
        VALIDATION_ERROR_MESSAGE,
		FILE_SET_ID,
		MIGRATION_SET_ID,
		MIGRATION_SET_NAME,
		MIGRATION_STATUS,
		IMPORT_ACTION,
		SUPPLIER_ID,
		SUPPLIER_NAME,
		PROCUREMENT_BU,
		PARTY_SITE_ID,
		ADDRESS_NAME,
		SUPPLIER_SITE_ID,
		SUPPLIER_SITE,
		SUPPLIER_SITE_NEW,
		INACTIVE_DATE,
		SOURCING_ONLY,
		PURCHASING,
		PROCUREMENT_CARD,
		PAY,
		PRIMARY_PAY,
		INCOME_TAX_REPORTING_SITE,
		ALTERNATE_SITE_NAME,
		CUSTOMER_NUMBER,
		B2B_COMMUNICATION_METHOD,
		B2B_SUPPLIER_SITE_CODE,
		COMMUNICATION_METHOD,
		E_MAIL,
		FAX_COUNTRY_CODE,
		FAX_AREA_CODE,
		FAX,
		HOLD_PURCHASING_DOCUMENTS,
		HOLD_REASON,
		CARRIER,
		MODE_OF_TRANSPORT,
		SERVICE_LEVEL,
		FREIGHT_TERMS,
		PAY_ON_RECEIPT,
		FOB,
		COUNTRY_OF_ORIGIN,
		BUYER_MANAGED_TRANSPORTATION,
		PAY_ON_USE,
		AGING_ONSET_POINT,
		AGING_PERIOD_DAYS,
		CONSUMPTION_ADVICE_FREQUENCY  ,
		CONSUMPTION_ADVICE_SUMMARY,
		DEFAULT_PAY_SITE,
		INVOICE_SUMMARY_LEVEL,
		GAPLESS_INVOICE_NUMBERING,
		SELLING_COMPANY_IDENTIFIER,
		CREATE_DEBIT_MEMO_FROM_RETURN,
		SHIP_TO_EXCEPTION_ACTION,
		RECEIPT_ROUTING,
		OVER_RECEIPT_TOLERANCE,
		OVER_RECEIPT_ACTION,
		EARLY_RECEIPT_TOLERANCE,
		LATE_RECEIPT_TOLERANCE,
		ALLOW_SUBSTITUTE_RECEIPTS,
		ALLOW_UNORDERED_RECEIPTS,
		RECEIPT_DATE_EXCEPTION,
		INVOICE_CURRENCY,
		INVOICE_AMOUNT_LIMIT,
		INVOICE_MATCH_OPTION,
		MATCH_APPROVAL_LEVEL,
		PAYMENT_CURRENCY,
		PAYMENT_PRIORITY,
		PAY_GROUP,
		QUANTITY_TOLERANCES,
		AMOUNT_TOLERANCE,
		HOLD_ALL_INVOICES,
		HOLD_UNMATCHED_INVOICES,
		HOLD_UNVALIDATED_INVOICES,
		PAYMENT_HOLD_BY,
		PAYMENT_HOLD_DATE,
		PAYMENT_HOLD_REASON,
		PAYMENT_TERMS,
		TERMS_DATE_BASIS,
		PAY_DATE_BASIS,
		BANK_CHARGE_DEDUCTION_TYPE,
		ALWAYS_TAKE_DISCOUNT,
		EXCLUDE_FREIGHT_FROM_DISCOUNT,
		EXCLUDE_TAX_FROM_DISCOUNT,
		CREATE_INTEREST_INVOICES,
		VAT_CODE,
		TAX_REGISTRATION_NUMBER,
		PAYMENT_METHOD,
		DELIVERY_CHANNEL,
		BANK_INSTRUCTION_1,
		BANK_INSTRUCTION_2,
		BANK_INSTRUCTION,
		SETTLEMENT_PRIORITY,
		PAYMENT_TEXT_MESSAGE_1,
		PAYMENT_TEXT_MESSAGE_2,
		PAYMENT_TEXT_MESSAGE_3,
		BANK_CHARGE_BEARER,
		PAYMENT_REASON,
		PAYMENT_REASON_COMMENTS,
		DELIVERY_METHOD,
		REMITTANCE_E_MAIL,
		REMITTANCE_FAX,
		REQUIRED_ACKNOWLEDGEMENT,
		ACKNOWLEDGE_WITHIN_DAYS,
		INVOICE_CHANNEL,
		PAYEE_SERVICE_LEVEL_CODE,
		EXCLUSIVE_PAYMENT_FLAG
        )
        VALUES 
        (
        suppsite_rec_tbl(i).VALIDATION_ERROR_MSG,
		suppsite_rec_tbl(i).FILE_SET_ID,
		suppsite_rec_tbl(i).MIGRATION_SET_ID,
		suppsite_rec_tbl(i).MIGRATION_SET_NAME,
		'VALIDATED',
		suppsite_rec_tbl(i).IMPORT_ACTION,
		suppsite_rec_tbl(i).SUPPLIER_ID,
		suppsite_rec_tbl(i).SUPPLIER_NAME,
		suppsite_rec_tbl(i).PROCUREMENT_BU,
		suppsite_rec_tbl(i).PARTY_SITE_ID,
		suppsite_rec_tbl(i).ADDRESS_NAME,
		suppsite_rec_tbl(i).SUPPLIER_SITE_ID,
		suppsite_rec_tbl(i).SUPPLIER_SITE,
		suppsite_rec_tbl(i).SUPPLIER_SITE_NEW,
		suppsite_rec_tbl(i).INACTIVE_DATE,
		suppsite_rec_tbl(i).SOURCING_ONLY,
		suppsite_rec_tbl(i).PURCHASING,
		suppsite_rec_tbl(i).PROCUREMENT_CARD,
		suppsite_rec_tbl(i).PAY,
		suppsite_rec_tbl(i).PRIMARY_PAY,
		suppsite_rec_tbl(i).INCOME_TAX_REPORTING_SITE,
		suppsite_rec_tbl(i).ALTERNATE_SITE_NAME,
		suppsite_rec_tbl(i).CUSTOMER_NUMBER,
		suppsite_rec_tbl(i).B2B_COMMUNICATION_METHOD,
		suppsite_rec_tbl(i).B2B_SUPPLIER_SITE_CODE,
		suppsite_rec_tbl(i).COMMUNICATION_METHOD,
		suppsite_rec_tbl(i).E_MAIL,
		suppsite_rec_tbl(i).FAX_COUNTRY_CODE,
		suppsite_rec_tbl(i).FAX_AREA_CODE,
		suppsite_rec_tbl(i).FAX,
		suppsite_rec_tbl(i).HOLD_PURCHASING_DOCUMENTS,
		suppsite_rec_tbl(i).HOLD_REASON,
		suppsite_rec_tbl(i).CARRIER,
		suppsite_rec_tbl(i).MODE_OF_TRANSPORT,
		suppsite_rec_tbl(i).SERVICE_LEVEL,
		suppsite_rec_tbl(i).FREIGHT_TERMS,
		suppsite_rec_tbl(i).PAY_ON_RECEIPT,
		suppsite_rec_tbl(i).FOB,
		suppsite_rec_tbl(i).COUNTRY_OF_ORIGIN,
		suppsite_rec_tbl(i).BUYER_MANAGED_TRANSPORTATION,
		suppsite_rec_tbl(i).PAY_ON_USE,
		suppsite_rec_tbl(i).AGING_ONSET_POINT,
		suppsite_rec_tbl(i).AGING_PERIOD_DAYS,
		suppsite_rec_tbl(i).CONSUMPTION_ADVICE_FREQUENCY  ,
		suppsite_rec_tbl(i).CONSUMPTION_ADVICE_SUMMARY,
		suppsite_rec_tbl(i).DEFAULT_PAY_SITE,
		suppsite_rec_tbl(i).INVOICE_SUMMARY_LEVEL,
		suppsite_rec_tbl(i).GAPLESS_INVOICE_NUMBERING,
		suppsite_rec_tbl(i).SELLING_COMPANY_IDENTIFIER,
		suppsite_rec_tbl(i).CREATE_DEBIT_MEMO_FROM_RETURN,
		suppsite_rec_tbl(i).SHIP_TO_EXCEPTION_ACTION,
		suppsite_rec_tbl(i).RECEIPT_ROUTING,
		suppsite_rec_tbl(i).OVER_RECEIPT_TOLERANCE,
		suppsite_rec_tbl(i).OVER_RECEIPT_ACTION,
		suppsite_rec_tbl(i).EARLY_RECEIPT_TOLERANCE,
		suppsite_rec_tbl(i).LATE_RECEIPT_TOLERANCE,
		suppsite_rec_tbl(i).ALLOW_SUBSTITUTE_RECEIPTS,
		suppsite_rec_tbl(i).ALLOW_UNORDERED_RECEIPTS,
		suppsite_rec_tbl(i).RECEIPT_DATE_EXCEPTION,
		suppsite_rec_tbl(i).INVOICE_CURRENCY,
		suppsite_rec_tbl(i).INVOICE_AMOUNT_LIMIT,
		suppsite_rec_tbl(i).INVOICE_MATCH_OPTION,
		suppsite_rec_tbl(i).MATCH_APPROVAL_LEVEL,
		suppsite_rec_tbl(i).PAYMENT_CURRENCY,
		suppsite_rec_tbl(i).PAYMENT_PRIORITY,
		suppsite_rec_tbl(i).PAY_GROUP,
		suppsite_rec_tbl(i).QUANTITY_TOLERANCES,
		suppsite_rec_tbl(i).AMOUNT_TOLERANCE,
		suppsite_rec_tbl(i).HOLD_ALL_INVOICES,
		suppsite_rec_tbl(i).HOLD_UNMATCHED_INVOICES,
		suppsite_rec_tbl(i).HOLD_UNVALIDATED_INVOICES,
		suppsite_rec_tbl(i).PAYMENT_HOLD_BY,
		suppsite_rec_tbl(i).PAYMENT_HOLD_DATE,
		suppsite_rec_tbl(i).PAYMENT_HOLD_REASON,
		suppsite_rec_tbl(i).PAYMENT_TERMS,
		suppsite_rec_tbl(i).TERMS_DATE_BASIS,
		suppsite_rec_tbl(i).PAY_DATE_BASIS,
		suppsite_rec_tbl(i).BANK_CHARGE_DEDUCTION_TYPE,
		suppsite_rec_tbl(i).ALWAYS_TAKE_DISCOUNT,
		suppsite_rec_tbl(i).EXCLUDE_FREIGHT_FROM_DISCOUNT,
		suppsite_rec_tbl(i).EXCLUDE_TAX_FROM_DISCOUNT,
		suppsite_rec_tbl(i).CREATE_INTEREST_INVOICES,
		suppsite_rec_tbl(i).VAT_CODE,
		suppsite_rec_tbl(i).TAX_REGISTRATION_NUMBER,
		suppsite_rec_tbl(i).PAYMENT_METHOD,
		suppsite_rec_tbl(i).DELIVERY_CHANNEL,
		suppsite_rec_tbl(i).BANK_INSTRUCTION_1,
		suppsite_rec_tbl(i).BANK_INSTRUCTION_2,
		suppsite_rec_tbl(i).BANK_INSTRUCTION,
		suppsite_rec_tbl(i).SETTLEMENT_PRIORITY,
		suppsite_rec_tbl(i).PAYMENT_TEXT_MESSAGE_1,
		suppsite_rec_tbl(i).PAYMENT_TEXT_MESSAGE_2,
		suppsite_rec_tbl(i).PAYMENT_TEXT_MESSAGE_3,
		suppsite_rec_tbl(i).BANK_CHARGE_BEARER,
		suppsite_rec_tbl(i).PAYMENT_REASON,
		suppsite_rec_tbl(i).PAYMENT_REASON_COMMENTS,
		suppsite_rec_tbl(i).DELIVERY_METHOD,
		suppsite_rec_tbl(i).REMITTANCE_E_MAIL,
		suppsite_rec_tbl(i).REMITTANCE_FAX,
		suppsite_rec_tbl(i).REQUIRED_ACKNOWLEDGEMENT,
		suppsite_rec_tbl(i).ACKNOWLEDGE_WITHIN_DAYS,
		suppsite_rec_tbl(i).INVOICE_CHANNEL,
		suppsite_rec_tbl(i).PAYEE_SERVICE_LEVEL_CODE,
		suppsite_rec_tbl(i).EXCLUSIVE_PAYMENT_FLAG
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
               CLOSE supplier_sites_check;
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
                    IF   supplier_sites_check%ISOPEN
                    THEN
                         --
                         CLOSE supplier_sites_check;
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

    END VALIDATE_SUPPLIER_SITES;
	
	  /*
    ******************************
    ** PROCEDURE: VALIDATE_SUPPLIER_SITE_ASSIGN
    ******************************
    */
    PROCEDURE VALIDATE_SUPPLIER_SITE_ASSIGN
                    (
                     pt_i_ApplicationSuite           IN      xxmx_module_messages.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_module_messages.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_module_messages.business_entity%TYPE
                    )
    IS

    /*
     ** Validate Supplier Site match or not 
     */
	CURSOR supplier_site_assigns_check(pt_i_MigrationSetID NUMBER)
	IS 
	SELECT  'Supplier Site does not match' as validation_error_msg,stg.* 
	FROM xxmx_ap_supp_site_assigns_stg stg
    WHERE 1=1
	AND      migration_set_id = pt_i_MigrationSetID
    AND EXISTS ( SELECT 1 FROM xxmx_ap_suppliers_stg
                 WHERE supplier_id=stg.supplier_id
               )
    AND NOT EXISTS ( SELECT 1 FROM xxmx_ap_supplier_sites_stg
                     WHERE supplier_id=stg.supplier_id
                     AND supplier_site_id=stg.supplier_site_id
               );
	
        TYPE supsite_assn_type IS TABLE OF supplier_site_assigns_check%ROWTYPE INDEX BY BINARY_INTEGER;
		supsias_rec_tbl supsite_assn_type;
	
	       --************************
          --** Constant Declarations
          --************************
          --
        ct_ProcOrFuncName CONSTANT xxmx_module_messages.proc_or_func_name%TYPE := 'VALIDATE_SUPPLIER_SITE_ASSIGN';
		ct_CoreSchema                    CONSTANT VARCHAR2(10)                                := 'xxmx_core';
        ct_CoreTable                     CONSTANT xxmx_migration_metadata.stg_table%TYPE      := 'XXMX_AP_SUPP_SITE_ASSIGNS_VAL';
        ct_StgTable                      CONSTANT xxmx_migration_metadata.stg_table%TYPE      := 'XXMX_AP_SUPP_SITE_ASSIGNS_STG';
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
                     pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                    ,pt_i_Application       => pt_i_Application
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

	
		OPEN supplier_site_assigns_check(l_migration_set_id);

		LOOP
--		 
		 FETCH supplier_site_assigns_check 
		 BULK COLLECT INTO supsias_rec_tbl
		 LIMIT xxmx_utilities_pkg.gcn_BulkCollectLimit;
		 
		EXIT WHEN supsias_rec_tbl.COUNT=0  ;
		
		gvv_ProgressIndicator := '0060';
 
		FORALL i in 1..supsias_rec_tbl.COUNT 

				INSERT INTO XXMX_AP_SUPP_SITE_ASSIGNS_VAL
				(
				validation_error_message,
				migration_set_id,
				migration_set_name,
				migration_status,
				import_action,
				supplier_id,
				supplier_name,
				supplier_site_id,
				supplier_site,
				procurement_bu,
				client_bu,
				bill_to_bu,
				ship_to_location,
				bill_to_location,
				use_withholding_tax,
				withholding_tax_group,
				liability_distribution,
				prepayment_distribution,
				bills_payable_distribution,
				distribution_set,
				inactive_date
				)
				VALUES 
				(
				supsias_rec_tbl(i).validation_error_msg,
				supsias_rec_tbl(i).migration_set_id,
				supsias_rec_tbl(i).migration_set_name,
				'VALIDATED',
				supsias_rec_tbl(i).import_action,
				supsias_rec_tbl(i).supplier_id,
				supsias_rec_tbl(i).supplier_name,
				supsias_rec_tbl(i).supplier_site_id,
				supsias_rec_tbl(i).supplier_site,
				supsias_rec_tbl(i).procurement_bu,
				supsias_rec_tbl(i).client_bu,
				supsias_rec_tbl(i).bill_to_bu,
				supsias_rec_tbl(i).ship_to_location,
				supsias_rec_tbl(i).bill_to_location,
				supsias_rec_tbl(i).use_withholding_tax,
				supsias_rec_tbl(i).withholding_tax_group,
				supsias_rec_tbl(i).liability_distribution,
				supsias_rec_tbl(i).prepayment_distribution,
				supsias_rec_tbl(i).bills_payable_distribution,
				supsias_rec_tbl(i).distribution_set,
				supsias_rec_tbl(i).inactive_date
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
               CLOSE supplier_site_assigns_check;
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
                    ,pt_i_BusinessEntity          => gct_BusinessEntity
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
                    IF   supplier_site_assigns_check%ISOPEN
                    THEN
                         --
                         CLOSE supplier_site_assigns_check;
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

     END VALIDATE_SUPPLIER_SITE_ASSIGN;
	 
	     /*
    ******************************
    ** PROCEDURE: VALIDATE_SUPPLIER_BANK_ACCTS
    ******************************
    */
    PROCEDURE VALIDATE_SUPPLIER_BANK_ACCTS
                    (
                     pt_i_ApplicationSuite           IN      xxmx_module_messages.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_module_messages.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_module_messages.business_entity%TYPE
                    )
    IS


    CURSOR supp_bank_accts_check(pt_i_MigrationSetID NUMBER)
	IS 
	/*
     ** Validate Supplier Payee 
     */
	SELECT 'Payee is neither present at header nor site level' as validation_error_message,
        stg.migration_set_id,
		stg.migration_set_name,
		stg.migration_status,
		'' import_action,
		stg.temp_ext_payee_id,
		stg.vendor_code,
		stg.supplier_name,
		stg.vendor_site_code,
		stg.business_unit,
		stg.remit_advice_delivery_method,
		stg.remit_advice_email,
		stg.remit_advice_fax,
		stg1.temp_ext_bank_acct_id,
		stg1.bank_name,
		stg1.branch_name,
		stg1.xxmx_branch_number,
		stg1.country_code,
		stg1.bank_account_name,
		stg1.bank_account_num,
		stg1.currency_code,
		stg1.foreign_payment_use_flag,
		stg1.start_date,
		stg1.end_date,
		stg1.iban        
	FROM xxmx_ap_supp_payees_stg stg, 
         xxmx_ap_supp_bank_accts_stg stg1
	WHERE 1=1
	AND stg.migration_set_id= pt_i_MigrationSetID
    AND stg1.migration_set_id= pt_i_MigrationSetID
    AND stg.temp_ext_payee_id= stg1.temp_ext_party_id  
	AND NOT EXISTS ( SELECT 1 FROM xxmx_ap_suppliers_stg
				     WHERE supplier_number=stg.vendor_code
				   )  
	AND NOT EXISTS ( SELECT 1 FROM xxmx_ap_supplier_sites_stg
				     WHERE supplier_name=stg.supplier_name
                     AND supplier_site=stg.vendor_site_code
                   )
	/*
     ** Validate Supplier Bank Name having Junk / Invalid characters 
     */				   
	UNION ALL
	SELECT 'Bank Name having Junk/Invalid characters' as validation_error_message,
        stg.migration_set_id,
		stg.migration_set_name,
		stg.migration_status,
		'' import_action,
		stg.temp_ext_payee_id,
		stg.vendor_code,
		stg.supplier_name,
		stg.vendor_site_code,
		stg.business_unit,
		stg.remit_advice_delivery_method,
		stg.remit_advice_email,
		stg.remit_advice_fax,
		stg1.temp_ext_bank_acct_id,
		stg1.bank_name,
		stg1.branch_name,
		stg1.xxmx_branch_number,
		stg1.country_code,
		stg1.bank_account_name,
		stg1.bank_account_num,
		stg1.currency_code,
		stg1.foreign_payment_use_flag,
		stg1.start_date,
		stg1.end_date,
		stg1.iban        
    FROM xxmx_ap_supp_payees_stg stg, 
         xxmx_ap_supp_bank_accts_stg stg1
    WHERE 1=1
	AND stg.migration_set_id= pt_i_MigrationSetID
    AND stg1.migration_set_id= pt_i_MigrationSetID
    AND stg.temp_ext_payee_id= stg1.temp_ext_party_id    
    AND REGEXP_LIKE( bank_name, '[^[:print:]]' );
	
	    TYPE supbankact_type IS TABLE OF supp_bank_accts_check%ROWTYPE INDEX BY BINARY_INTEGER;
		supbankact_rec_tbl supbankact_type;
		
			
	       --************************
          --** Constant Declarations
          --************************
          --
        ct_ProcOrFuncName CONSTANT xxmx_module_messages.proc_or_func_name%TYPE := 'VALIDATE_SUPPLIER_BANK_ACCTS';
		ct_CoreSchema                    CONSTANT VARCHAR2(10)                                := 'xxmx_core';
        ct_CoreTable                     CONSTANT xxmx_migration_metadata.stg_table%TYPE      := 'XXMX_AP_SUPP_BANK_ACCTS_VAL';
        ct_StgTable                      CONSTANT xxmx_migration_metadata.stg_table%TYPE      := 'XXMX_AP_SUPP_BANK_ACCTS_STG';
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
                     pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                    ,pt_i_Application       => pt_i_Application
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
		
		OPEN supp_bank_accts_check(l_migration_set_id);

		LOOP
--		 
		 FETCH supp_bank_accts_check 
		 BULK COLLECT INTO supbankact_rec_tbl
		 LIMIT xxmx_utilities_pkg.gcn_BulkCollectLimit;
		 
		EXIT WHEN supbankact_rec_tbl.COUNT=0  ;
		
		gvv_ProgressIndicator := '0060';
 
		FORALL i in 1..supbankact_rec_tbl.COUNT 

				INSERT INTO XXMX_AP_SUPP_BANK_ACCTS_VAL
				(
				validation_error_message,
				migration_set_id,
				migration_set_name,
				migration_status,
				import_action,
				temp_ext_payee_id,
				vendor_code,
				supplier_name,
				vendor_site_code,
				business_unit,
				remit_advice_delivery_method,
				remit_advice_email,
				remit_advice_fax,
				temp_ext_bank_acct_id,
				bank_name,
				branch_name,
				xxmx_branch_number,
				country_code,
				bank_account_name,
				bank_account_num,
				currency_code,
				foreign_payment_use_flag,
				start_date,
				end_date,
				iban
				)
				VALUES 
				(
				supbankact_rec_tbl(i).validation_error_message,
				supbankact_rec_tbl(i).migration_set_id,
				supbankact_rec_tbl(i).migration_set_name,
				'VALIDATED',
				supbankact_rec_tbl(i).import_action,
				supbankact_rec_tbl(i).temp_ext_payee_id,
				supbankact_rec_tbl(i).vendor_code,
				supbankact_rec_tbl(i).supplier_name,
				supbankact_rec_tbl(i).vendor_site_code,
				supbankact_rec_tbl(i).business_unit,
				supbankact_rec_tbl(i).remit_advice_delivery_method,
				supbankact_rec_tbl(i).remit_advice_email,
				supbankact_rec_tbl(i).remit_advice_fax,
				supbankact_rec_tbl(i).temp_ext_bank_acct_id,
				supbankact_rec_tbl(i).bank_name,
				supbankact_rec_tbl(i).branch_name,
				supbankact_rec_tbl(i).xxmx_branch_number,
				supbankact_rec_tbl(i).country_code,
				supbankact_rec_tbl(i).bank_account_name,
				supbankact_rec_tbl(i).bank_account_num,
				supbankact_rec_tbl(i).currency_code,
				supbankact_rec_tbl(i).foreign_payment_use_flag,
				supbankact_rec_tbl(i).start_date,
				supbankact_rec_tbl(i).end_date,
				supbankact_rec_tbl(i).iban

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
               CLOSE supp_bank_accts_check;
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
                    IF   supp_bank_accts_check%ISOPEN
                    THEN
                         --
                         CLOSE supp_bank_accts_check;
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
    END VALIDATE_SUPPLIER_BANK_ACCTS;
    --
    --
    /*
    ******************************
    ** PROCEDURE: VALIDATE_SUPPLIERS
    ******************************
    */
    PROCEDURE VALIDATE_SUPPLIERS
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
                       LOWER(xmm.val_package_name)      AS val_package_name
                      ,LOWER(xmm.val_procedure_name)        AS val_procedure_name
               FROM    xxmx_migration_metadata  xmm
               WHERE   1 = 1
               AND     xmm.application_suite      = pt_ApplicationSuite
               AND     xmm.application            = pt_Application
               AND     xmm.business_entity        = pt_BusinessEntity
               AND     NVL(xmm.enabled_flag, 'N') = 'Y';
			   
		
gvv_SQLStatement        VARCHAR2(32000);
gcv_SQLSpace  CONSTANT  VARCHAR2(1) := ' ';	
gvt_Phase     VARCHAR2(15) := 'VALIDATE';	
	
    BEGIN
        ct_ProcOrFuncName := 'VALIDATE_SUPPLIERS';
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
    END VALIDATE_SUPPLIERS;
    --
    --
END XXMX_SUPPLIER_VALIDATIONS_PKG;
/