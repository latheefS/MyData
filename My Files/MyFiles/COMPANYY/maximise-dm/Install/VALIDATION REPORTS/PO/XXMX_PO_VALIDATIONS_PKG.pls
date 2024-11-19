create or replace PACKAGE           XXMX_PO_VALIDATIONS_PKG
AS

     /*
	 ******************************************************************************
     ** FILENAME  :  XXMX_PO_VALIDATIONS_PKG.pls
     **
     ** VERSION   :  1.0
     **
     ** EXECUTE
     ** IN SCHEMA :  APPS
     **
     ** AUTHORS   :  Meenakshi Rajendran
     **
     ** PURPOSE   :  This script installs the package specification for the XXMX_PO_VALIDATIONS_PKG custom Procedures.
     **
     ** NOTES     :

     **   Vsn  Change Date  Changed By          Change Description
     ** -----  -----------  ------------------  -----------------------------------
     ** [ 1.0  DD-Mon-YYYY  Change Author       Created.                          ]
     **
     ******************************************************************************
     **
     ** XXMX_PO_VALIDATIONS_PKG HISTORY
     ** ------------------------------------
     **
     **   Vsn  Change Date  Changed By                 Change Description
     ** -----  -----------  ------------------         -----------------------------------
     **   1.0  16-OCT-2023  Meenakshi Rajendran        Initial implementation
     ******************************************************************************
     */
    --
    /*
    ******************************
    ** PROCEDURE: VALIDATE_PO_HEADERS
    ******************************
    */
    PROCEDURE VALIDATE_PO_HEADERS
                    (
                     pt_i_ApplicationSuite           IN      xxmx_module_messages.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_module_messages.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_module_messages.business_entity%TYPE
                    );

    --
    /*
    ******************************
    ** PROCEDURE: VALIDATE_PO_LINES
    ******************************
    */
    PROCEDURE VALIDATE_PO_LINES
                    (
                     pt_i_ApplicationSuite           IN      xxmx_module_messages.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_module_messages.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_module_messages.business_entity%TYPE
                    );						

    --
	/*
    ******************************
    ** PROCEDURE: VALIDATE_PO_LINE_LOCATIONS
    ******************************
    */
    PROCEDURE VALIDATE_PO_LINE_LOCATIONS
                    (
                     pt_i_ApplicationSuite           IN      xxmx_module_messages.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_module_messages.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_module_messages.business_entity%TYPE
                    );	
    /*
    ******************************
    ** PROCEDURE: VALIDATE_PO_DISTRIBUTIONS
    ******************************
    */
    PROCEDURE VALIDATE_PO_DISTRIBUTIONS
                    (
                     pt_i_ApplicationSuite           IN      xxmx_module_messages.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_module_messages.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_module_messages.business_entity%TYPE
                    );	

    /*
    ******************************
    ** PROCEDURE: VALIDATE_PURCHASE_ORDERS
    ******************************
    */
    PROCEDURE VALIDATE_PURCHASE_ORDERS
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

END XXMX_PO_VALIDATIONS_PKG;
/

create or replace PACKAGE BODY XXMX_PO_VALIDATIONS_PKG
AS


     /*
	 ******************************************************************************
     ** FILENAME  :  XXMX_PO_VALIDATIONS_PKG.pls
     **
     ** VERSION   :  1.0
     **
     ** EXECUTE
     ** IN SCHEMA :  APPS
     **
     ** AUTHORS   :  Meenakshi Rajendran
     **
     ** PURPOSE   :  This script installs the package body for the XXMX_PO_VALIDATIONS_PKG custom Procedures.
     **
     ** NOTES     :

     **   Vsn  Change Date  Changed By          Change Description
     ** -----  -----------  ------------------  -----------------------------------
     ** [ 1.0  DD-Mon-YYYY  Change Author       Created.                          ]
     **
     ******************************************************************************
     **
     ** XXMX_PO_VALIDATIONS_PKG HISTORY
     ** ------------------------------------
     **
     **   Vsn  Change Date  Changed By             Change Description
     ** -----  -----------  ------------------     -----------------------------------
     **   1.0  16-OCT-2023  Meenakshi Rajendran    Initial implementation, 
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
     gct_PackageName                           CONSTANT xxmx_module_messages.package_name%TYPE       := 'XXMX_PO_VALIDATIONS_PKG';
     gct_ApplicationSuite                      CONSTANT xxmx_module_messages.application_suite%TYPE  := 'FIN';
     gct_Application                           CONSTANT xxmx_module_messages.application%TYPE        := 'AP';
     gct_BusinessEntity                        CONSTANT xxmx_migration_metadata.business_entity%TYPE := 'PURCHASE_ORDERS';
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
    ** PROCEDURE: VALIDATE_PO_HEADERS
    ******************************
    */
    PROCEDURE VALIDATE_PO_HEADERS
                    (
                     pt_i_ApplicationSuite           IN      xxmx_module_messages.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_module_messages.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_module_messages.business_entity%TYPE
                    )
    IS

        CURSOR po_header_validations(pt_i_MigrationSetID number)
        IS
	 /*
     ** Validate if PO is open but Vendor/Vendor Site is inactive
     */
            SELECT 'Vendor/Vendor Site is inactive' as validation_error_message,xsph.*
            FROM XXMX_SCM_PO_HEADERS_STD_STG xsph
            WHERE  1=1
			AND  migration_set_id = pt_i_MigrationSetID
            AND NOT EXISTS (SELECT 1 FROM xxmx_ap_suppliers_stg aps
                            WHERE aps.supplier_number=xsph.vendor_num
                           )
			UNION ALL
			SELECT 'Vendor Site is inactive' as validation_error_message,xsph.*
            FROM XXMX_SCM_PO_HEADERS_STD_STG xsph
            WHERE  1=1
			AND  migration_set_id = pt_i_MigrationSetID
            AND   NOT EXISTS (SELECT 1 FROM xxmx_ap_supplier_sites_stg aps
                            WHERE aps.supplier_name=xsph.vendor_name
                            and aps.procurement_bu=xsph.prc_bu_name
                            and aps.supplier_site=xsph.vendor_site_code
                           )
			UNION ALL
	 /*
     ** Validate if Buyer is an active employee 
     */
			SELECT 'Buyer is not an active employee' as validation_error_message,xsph.*
			FROM XXMX_SCM_PO_HEADERS_STD_STG xsph
            WHERE  1=1
			AND  migration_set_id = pt_i_MigrationSetID
            AND NOT EXISTS (SELECT 1 FROM XXMX_PER_NAMES_F_STG
                            WHERE last_name ||', '||first_name = xsph.agent_name)
			UNION ALL
	 /*
     ** Validate Supplier Sites whose Remittance Advice Delivery Method is null however Remittance Email or Remittance Fax is not null
     */
			SELECT 'Supplier''s Site Remittance Advice Delivery Method is null' as validation_error_message,xsph.*
            FROM XXMX_SCM_PO_HEADERS_STD_STG xsph
            WHERE  1=1
			AND  migration_set_id = pt_i_MigrationSetID
			 AND  EXISTS (SELECT 1 FROM xxmx_ap_supplier_sites_stg aps
                           WHERE aps.supplier_name=xsph.vendor_name
                           AND aps.supplier_site=xsph.vendor_site_code
                          AND ((aps.remittance_e_mail IS NOT NULL OR aps.remittance_fax IS NOT NULL) 
                          AND (aps.delivery_method IS NULL))
                           )
			UNION ALL
	 /*
     ** Validate if PO Header has at least one PO Line
     */			
			SELECT 'PO Header should have at least one PO Line' as validation_error_message,xsph.*
			FROM xxmx_scm_po_headers_std_stg xsph
            WHERE 1=1
            AND  migration_set_id = pt_i_MigrationSetID
            AND NOT EXISTS (SELECT interface_header_key,interface_line_key,line_num
							 FROM xxmx_scm_po_lines_std_stg
							 WHERE po_header_id=xsph.po_header_id
							 GROUP BY interface_header_key,interface_line_key,line_num
							 HAVING COUNT(1) >= 1);


       TYPE po_header_type IS TABLE OF po_header_validations%ROWTYPE INDEX BY BINARY_INTEGER;
	   po_header_tbl po_header_type;

	       --************************
          --** Constant Declarations
          --************************
          --
        ct_ProcOrFuncName CONSTANT xxmx_module_messages.proc_or_func_name%TYPE := 'VALIDATE_PO_HEADERS';
		ct_CoreSchema                    CONSTANT VARCHAR2(10)                                := 'xxmx_core';
        ct_CoreTable                     CONSTANT xxmx_migration_metadata.stg_table%TYPE      := 'XXMX_SCM_PO_HEADERS_STD_VAL';
		ct_StgTable                      CONSTANT xxmx_migration_metadata.stg_table%TYPE      := 'XXMX_SCM_PO_HEADERS_STD_STG';
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

		OPEN po_header_validations(l_migration_set_id);

		LOOP
--		 
		 FETCH po_header_validations 
		 BULK COLLECT INTO po_header_tbl
		 LIMIT xxmx_utilities_pkg.gcn_BulkCollectLimit;

		EXIT WHEN po_header_tbl.COUNT=0  ;

		gvv_ProgressIndicator := '0060';

FORALL i in 1..po_header_tbl.COUNT 

        INSERT INTO XXMX_SCM_PO_HEADERS_STD_VAL
        (
		VALIDATION_ERROR_MESSAGE,
		FILE_SET_ID,
		MIGRATION_SET_ID,
		MIGRATION_SET_NAME,
		MIGRATION_STATUS,
		INTERFACE_HEADER_KEY,
		ACTION,
		BATCH_ID,
		INTERFACE_SOURCE_CODE,
		APPROVAL_ACTION,
		DOCUMENT_NUM,
		DOCUMENT_TYPE_CODE,
		STYLE_DISPLAY_NAME,
		PRC_BU_NAME,
		REQ_BU_NAME,
		SOLDTO_LE_NAME,
		BILLTO_BU_NAME,
		AGENT_NAME,
		CURRENCY_CODE,
		RATE,
		RATE_TYPE,
		RATE_DATE,
		COMMENTS,
		BILL_TO_LOCATION,
		SHIP_TO_LOCATION,
		VENDOR_NAME,
		VENDOR_NUM,
		VENDOR_SITE_CODE,
		VENDOR_CONTACT,
		VENDOR_DOC_NUM,
		FOB,
		FREIGHT_CARRIER,
		FREIGHT_TERMS,
		PAY_ON_CODE,
		PAYMENT_TERMS,
		ORIGINATOR_ROLE,
		CHANGE_ORDER_DESC,
		ACCEPTANCE_REQUIRED_FLAG,
		ACCEPTANCE_WITHIN_DAYS,
		SUPPLIER_NOTIF_METHOD,
		FAX,
		EMAIL_ADDRESS,
		CONFIRMING_ORDER_FLAG,
		NOTE_TO_VENDOR,
		NOTE_TO_RECEIVER,
		DEFAULT_TAXATION_COUNTRY,
		TAX_DOCUMENT_SUBTYPE,
		AGENT_EMAIL_ADDRESS,
		PO_HEADER_ID,
		LOAD_BATCH
        )
        VALUES 
        (
        po_header_tbl(i).VALIDATION_ERROR_MESSAGE,
		po_header_tbl(i).FILE_SET_ID,
		po_header_tbl(i).MIGRATION_SET_ID,
		po_header_tbl(i).MIGRATION_SET_NAME,
		'VALIDATED',
		po_header_tbl(i).INTERFACE_HEADER_KEY,
		po_header_tbl(i).ACTION,
		po_header_tbl(i).BATCH_ID,
		po_header_tbl(i).INTERFACE_SOURCE_CODE,
		po_header_tbl(i).APPROVAL_ACTION,
		po_header_tbl(i).DOCUMENT_NUM,
		po_header_tbl(i).DOCUMENT_TYPE_CODE,
		po_header_tbl(i).STYLE_DISPLAY_NAME,
		po_header_tbl(i).PRC_BU_NAME,
		po_header_tbl(i).REQ_BU_NAME,
		po_header_tbl(i).SOLDTO_LE_NAME,
		po_header_tbl(i).BILLTO_BU_NAME,
		po_header_tbl(i).AGENT_NAME,
		po_header_tbl(i).CURRENCY_CODE,
		po_header_tbl(i).RATE,
		po_header_tbl(i).RATE_TYPE,
		po_header_tbl(i).RATE_DATE,
		po_header_tbl(i).COMMENTS,
		po_header_tbl(i).BILL_TO_LOCATION,
		po_header_tbl(i).SHIP_TO_LOCATION,
		po_header_tbl(i).VENDOR_NAME,
		po_header_tbl(i).VENDOR_NUM,
		po_header_tbl(i).VENDOR_SITE_CODE,
		po_header_tbl(i).VENDOR_CONTACT,
		po_header_tbl(i).VENDOR_DOC_NUM,
		po_header_tbl(i).FOB,
		po_header_tbl(i).FREIGHT_CARRIER,
		po_header_tbl(i).FREIGHT_TERMS,
		po_header_tbl(i).PAY_ON_CODE,
		po_header_tbl(i).PAYMENT_TERMS,
		po_header_tbl(i).ORIGINATOR_ROLE,
		po_header_tbl(i).CHANGE_ORDER_DESC,
		po_header_tbl(i).ACCEPTANCE_REQUIRED_FLAG,
		po_header_tbl(i).ACCEPTANCE_WITHIN_DAYS,
		po_header_tbl(i).SUPPLIER_NOTIF_METHOD,
		po_header_tbl(i).FAX,
		po_header_tbl(i).EMAIL_ADDRESS,
		po_header_tbl(i).CONFIRMING_ORDER_FLAG,
		po_header_tbl(i).NOTE_TO_VENDOR,
		po_header_tbl(i).NOTE_TO_RECEIVER,
		po_header_tbl(i).DEFAULT_TAXATION_COUNTRY,
		po_header_tbl(i).TAX_DOCUMENT_SUBTYPE,
		po_header_tbl(i).AGENT_EMAIL_ADDRESS,
		po_header_tbl(i).PO_HEADER_ID,
		po_header_tbl(i).LOAD_BATCH
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
               CLOSE po_header_validations;
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
                    IF   po_header_validations%ISOPEN
                    THEN
                         --
                         CLOSE po_header_validations;
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
END VALIDATE_PO_HEADERS;


   /*
    ******************************
    ** PROCEDURE: VALIDATE_PO_LINES
    ******************************
    */
    PROCEDURE VALIDATE_PO_LINES
                    (
                     pt_i_ApplicationSuite           IN      xxmx_module_messages.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_module_messages.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_module_messages.business_entity%TYPE
                    )
    IS

        CURSOR po_line_validations(pt_i_MigrationSetID NUMBER)
        IS
	 /*
     ** Validate if unit price value exceeds 10 decimal places
     */
            SELECT 'The price can''t exceed 10 decimal places' as validation_error_message,xspl.*
            FROM XXMX_SCM_PO_LINES_STD_STG xspl
            WHERE  1=1
			AND  migration_set_id = pt_i_MigrationSetID
            AND SUBSTR(xspl.unit_price,INSTR(xspl.unit_price,'.')+11) IS NOT NULL
			UNION ALL
	 /*
     ** Validate if PO Line has at least one PO header
     */			
			SELECT 'PO Line should have a valid PO header' as validation_error_message,xspl.*
			FROM xxmx_scm_po_lines_std_stg xspl
			WHERE 1=1
			AND  migration_set_id = pt_i_MigrationSetID
			AND NOT EXISTS (SELECT interface_header_key,document_num,prc_bu_name
							 FROM xxmx_scm_po_headers_std_stg
							 WHERE 1=1
							 AND po_header_id=xspl.po_header_id
							 GROUP BY interface_header_key,document_num,prc_bu_name
							 HAVING COUNT(1)>=1
						    )
			UNION ALL
	 /*
     ** Validate if PO Line Line has at least one PO Line Location 
     */	
			SELECT 'PO Line should have at least one PO Line Location' as validation_error_message,xspl.*
			FROM xxmx_scm_po_lines_std_stg xspl
            WHERE 1=1
			AND  migration_set_id = pt_i_MigrationSetID
			AND NOT EXISTS (SELECT interface_line_key,interface_line_location_key
							 FROM xxmx_scm_po_line_locations_std_stg
							 WHERE po_header_id=xspl.po_header_id
							 AND po_line_id=xspl.po_line_id
							 GROUP BY interface_line_key,interface_line_location_key
							 HAVING COUNT(1) >= 1);



       TYPE po_line_type IS TABLE OF po_line_validations%ROWTYPE INDEX BY BINARY_INTEGER;
	   po_line_tbl po_line_type;

	       --************************
          --** Constant Declarations
          --************************
          --
        ct_ProcOrFuncName CONSTANT xxmx_module_messages.proc_or_func_name%TYPE := 'VALIDATE_PO_LINES';
		ct_CoreSchema                    CONSTANT VARCHAR2(10)                                := 'xxmx_core';
        ct_CoreTable                     CONSTANT xxmx_migration_metadata.stg_table%TYPE      := 'XXMX_SCM_PO_LINES_STD_VAL';
		ct_StgTable                      CONSTANT xxmx_migration_metadata.stg_table%TYPE      := 'XXMX_SCM_PO_LINES_STD_STG';
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
                    ,pt_i_SubEntity         => ct_SubEntity
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
                    ,pt_i_SubEntity         => ct_SubEntity
                    ,pt_i_FileSetID         => NULL
                    ,pt_i_MigrationSetID    => l_migration_set_id                   
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Inserting Validated data into "'
                                             ||ct_CoreTable
                                             ||'" table.'
                    ,pt_i_OracleError       => NULL
                    );
         		 --

		BEGIN		

		EXECUTE IMMEDIATE 'TRUNCATE TABLE ' || ct_CoreTable;

		END;

		OPEN po_line_validations(l_migration_set_id);

		LOOP
--		 
		 FETCH po_line_validations 
		 BULK COLLECT INTO po_line_tbl
		 LIMIT xxmx_utilities_pkg.gcn_BulkCollectLimit;

		EXIT WHEN po_line_tbl.COUNT=0  ;

		gvv_ProgressIndicator := '0060';

FORALL i in 1..po_line_tbl.COUNT 

        INSERT INTO XXMX_SCM_PO_LINES_STD_VAL
        (
        VALIDATION_ERROR_MESSAGE,
		FILE_SET_ID,
		MIGRATION_SET_ID,
		MIGRATION_SET_NAME,
		MIGRATION_STATUS,
		INTERFACE_LINE_KEY,
		INTERFACE_HEADER_KEY,
		ACTION,
		LINE_NUM,
		LINE_TYPE,
		ITEM,
		ITEM_DESCRIPTION,
		ITEM_REVISION,
		CATEGORY,
		AMOUNT,
		QUANTITY,
		UNIT_OF_MEASURE,
		UNIT_PRICE,
		SECONDARY_QUANTITY,
		SECONDARY_UNIT_OF_MEASURE,
		VENDOR_PRODUCT_NUM,
		NEGOTIATED_BY_PREPARER_FLAG,
		HAZARD_CLASS,
		UN_NUMBER,
		NOTE_TO_VENDOR,
		NOTE_TO_RECEIVER,
		UNIT_WEIGHT,
		WEIGHT_UOM_CODE,
		WEIGHT_UNIT_OF_MEASURE,
		UNIT_VOLUME,
		VOLUME_UOM_CODE,
		VOLUME_UNIT_OF_MEASURE,
		TEMPLATE_NAME,
		SOURCE_AGREEMENT_PRC_BU_NAME,
		SOURCE_AGREEMENT,
		SOURCE_AGREEMENT_LINE,
		DISCOUNT_TYPE,
		DISCOUNT,
		DISCOUNT_REASON,
		MAX_RETAINAGE_AMOUNT,
		PO_HEADER_ID,
		PO_LINE_ID,
		LOAD_BATCH
        )
        VALUES 
        (
        po_line_tbl(i).VALIDATION_ERROR_MESSAGE,
		po_line_tbl(i).FILE_SET_ID,
		po_line_tbl(i).MIGRATION_SET_ID,
		po_line_tbl(i).MIGRATION_SET_NAME,
		'VALIDATED',
		po_line_tbl(i).INTERFACE_LINE_KEY,
		po_line_tbl(i).INTERFACE_HEADER_KEY,
		po_line_tbl(i).ACTION,
		po_line_tbl(i).LINE_NUM,
		po_line_tbl(i).LINE_TYPE,
		po_line_tbl(i).ITEM,
		po_line_tbl(i).ITEM_DESCRIPTION,
		po_line_tbl(i).ITEM_REVISION,
		po_line_tbl(i).CATEGORY,
		po_line_tbl(i).AMOUNT,
		po_line_tbl(i).QUANTITY,
		po_line_tbl(i).UNIT_OF_MEASURE,
		po_line_tbl(i).UNIT_PRICE,
		po_line_tbl(i).SECONDARY_QUANTITY,
		po_line_tbl(i).SECONDARY_UNIT_OF_MEASURE,
		po_line_tbl(i).VENDOR_PRODUCT_NUM,
		po_line_tbl(i).NEGOTIATED_BY_PREPARER_FLAG,
		po_line_tbl(i).HAZARD_CLASS,
		po_line_tbl(i).UN_NUMBER,
		po_line_tbl(i).NOTE_TO_VENDOR,
		po_line_tbl(i).NOTE_TO_RECEIVER,
		po_line_tbl(i).UNIT_WEIGHT,
		po_line_tbl(i).WEIGHT_UOM_CODE,
		po_line_tbl(i).WEIGHT_UNIT_OF_MEASURE,
		po_line_tbl(i).UNIT_VOLUME,
		po_line_tbl(i).VOLUME_UOM_CODE,
		po_line_tbl(i).VOLUME_UNIT_OF_MEASURE,
		po_line_tbl(i).TEMPLATE_NAME,
		po_line_tbl(i).SOURCE_AGREEMENT_PRC_BU_NAME,
		po_line_tbl(i).SOURCE_AGREEMENT,
		po_line_tbl(i).SOURCE_AGREEMENT_LINE,
		po_line_tbl(i).DISCOUNT_TYPE,
		po_line_tbl(i).DISCOUNT,
		po_line_tbl(i).DISCOUNT_REASON,
		po_line_tbl(i).MAX_RETAINAGE_AMOUNT,
		po_line_tbl(i).PO_HEADER_ID,
		po_line_tbl(i).PO_LINE_ID,
		po_line_tbl(i).LOAD_BATCH
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
               CLOSE po_line_validations;
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
                    IF   po_line_validations%ISOPEN
                    THEN
                         --
                         CLOSE po_line_validations;
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
END VALIDATE_PO_LINES;

  /*
    ******************************
    ** PROCEDURE: VALIDATE_PO_LINE_LOCATIONS
    ******************************
    */
    PROCEDURE VALIDATE_PO_LINE_LOCATIONS
                    (
                     pt_i_ApplicationSuite           IN      xxmx_module_messages.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_module_messages.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_module_messages.business_entity%TYPE
                    )
    IS

        CURSOR po_line_loc_validations(pt_i_MigrationSetID NUMBER)
        IS

	 /*
     ** Validate if PO Line Location has at least one PO Line
     */			
			SELECT 'PO Line Location should have at least one PO Line' as validation_error_message,xspll.* 
			FROM xxmx_scm_po_line_locations_std_stg xspll
			WHERE 1=1
			AND  migration_set_id = pt_i_MigrationSetID
			AND NOT EXISTS (SELECT interface_header_key,interface_line_key,line_num
							 FROM xxmx_scm_po_lines_std_stg
							 WHERE po_header_id=xspll.po_header_id
							 AND po_line_id=xspll.po_line_id
							 GROUP BY interface_header_key,interface_line_key,line_num
							 HAVING COUNT(1) >= 1)
			UNION ALL
	 /*
     ** Validate if PO Line Location has at least one PO Distribution
     */	
			SELECT 'PO Line Location should have at least one PO Distribution' as validation_error_message,xspll.*
			FROM xxmx_scm_po_line_locations_std_stg xspll
			WHERE 1=1
			AND  migration_set_id = pt_i_MigrationSetID
			AND NOT EXISTS (SELECT interface_distribution_key,interface_line_location_key
							FROM xxmx_scm_po_distributions_std_stg
							WHERE po_header_id=xspll.po_header_id
							GROUP BY interface_distribution_key,interface_line_location_key
							HAVING COUNT(1) >= 1)
			UNION ALL
	 /*
     ** Validate if PO Line Quantity matches with PO Line Location Quantity
     */	
			SELECT 'PO Line Quantity does not match with Line Location Quantity' as validation_error_message,stg.*
            FROM  xxmx_scm_po_line_locations_std_stg stg
				,(SELECT SUM(xspl.quantity) qty,xspl.po_header_id
				  FROM xxmx_scm_po_lines_std_stg xspl,xxmx_scm_po_headers_std_stg xsph
				  WHERE xspl.po_header_id=xsph.po_header_id
				  GROUP BY xspl.po_header_id)xspl
				,(SELECT SUM(xspll.quantity) qty,xspll.po_header_id
				  FROM xxmx_scm_po_line_locations_std_stg xspll,xxmx_scm_po_headers_std_stg xsph
				  WHERE xspll.po_header_id=xsph.po_header_id
				  GROUP BY xspll.po_header_id)xspll
			WHERE 1=1
			AND  migration_set_id = pt_i_MigrationSetID
			AND stg.po_header_id=xspl.po_header_id
			AND stg.po_header_id=xspll.po_header_id
			AND xspl.qty != xspll.qty

			UNION ALL
	 /*
     ** Validate if PO Line Amount matches with PO Line Location Amount
     */	
			SELECT 'PO Line Amount does not match with Line Location Amount' as validation_error_message,stg.*
            FROM  xxmx_scm_po_line_locations_std_stg stg
				,(SELECT SUM(xspl.amount) amount,xspl.po_header_id
				  FROM xxmx_scm_po_lines_std_stg xspl,xxmx_scm_po_headers_std_stg xsph
				  WHERE xspl.po_header_id=xsph.po_header_id
				  GROUP BY xspl.po_header_id)xspl
				,(SELECT SUM(xspll.amount) amount,xspll.po_header_id
				  FROM xxmx_scm_po_line_locations_std_stg xspll,xxmx_scm_po_headers_std_stg xsph
				  WHERE xspll.po_header_id=xsph.po_header_id
				  GROUP BY xspll.po_header_id)xspll
			WHERE 1=1
			AND  migration_set_id = pt_i_MigrationSetID
			AND stg.po_header_id=xspl.po_header_id
			AND stg.po_header_id=xspll.po_header_id
			AND xspl.amount != xspll.amount;



       TYPE po_line_loc_type IS TABLE OF po_line_loc_validations%ROWTYPE INDEX BY BINARY_INTEGER;
	   po_line_loc_tbl po_line_loc_type;

	       --************************
          --** Constant Declarations
          --************************
          --
        ct_ProcOrFuncName CONSTANT xxmx_module_messages.proc_or_func_name%TYPE := 'VALIDATE_PO_LINE_LOCATIONS';
		ct_CoreSchema                    CONSTANT VARCHAR2(10)                                := 'xxmx_core';
        ct_CoreTable                     CONSTANT xxmx_migration_metadata.stg_table%TYPE      := 'XXMX_SCM_PO_LINE_LOCATIONS_STD_VAL';
        ct_StgTable                      CONSTANT xxmx_migration_metadata.stg_table%TYPE      := 'XXMX_SCM_PO_LINE_LOCATIONS_STD_STG';
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
                    ,pt_i_SubEntity         => ct_SubEntity
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
                    ,pt_i_SubEntity         => ct_SubEntity
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

		OPEN po_line_loc_validations(l_migration_set_id);

		LOOP
--		 
		 FETCH po_line_loc_validations 
		 BULK COLLECT INTO po_line_loc_tbl
		 LIMIT xxmx_utilities_pkg.gcn_BulkCollectLimit;

		EXIT WHEN po_line_loc_tbl.COUNT=0  ;

		gvv_ProgressIndicator := '0060';

FORALL i in 1..po_line_loc_tbl.COUNT 

        INSERT INTO XXMX_SCM_PO_LINE_LOCATIONS_STD_VAL
        (
		VALIDATION_ERROR_MESSAGE,
		FILE_SET_ID,
		MIGRATION_SET_ID,
		MIGRATION_SET_NAME,
		MIGRATION_STATUS,
		INTERFACE_LINE_LOCATION_KEY,
		INTERFACE_LINE_KEY,
		SHIPMENT_NUM,
		SHIP_TO_LOCATION,
		SHIP_TO_ORGANIZATION_CODE,
		AMOUNT,
		QUANTITY,
		NEED_BY_DATE,
		PROMISED_DATE,
		SECONDARY_QUANTITY,
		SECONDARY_UNIT_OF_MEASURE,
		DESTINATION_TYPE_CODE,
		ACCRUE_ON_RECEIPT_FLAG,
		ALLOW_SUBSTITUTE_RECEIPTS_FLAG,
		ASSESSABLE_VALUE,
		DAYS_EARLY_RECEIPT_ALLOWED,
		DAYS_LATE_RECEIPT_ALLOWED,
		ENFORCE_SHIP_TO_LOCATION_CODE,
		INSPECTION_REQUIRED_FLAG,
		RECEIPT_REQUIRED_FLAG,
		INVOICE_CLOSE_TOLERANCE,
		RECEIPT_CLOSE_TOLERANCE,
		QTY_RCV_TOLERANCE,
		QTY_RCV_EXCEPTION_CODE,
		RECEIPT_DAYS_EXCEPTION_CODE,
		RECEIVING_ROUTING,
		NOTE_TO_RECEIVER,
		INPUT_TAX_CLASSIFICATION_CODE,
		LINE_INTENDED_USE,
		PRODUCT_CATEGORY,
		PRODUCT_FISC_CLASSIFICATION,
		PRODUCT_TYPE,
		TRX_BUSINESS_CATEGORY_CODE,
		USER_DEFINED_FISC_CLASS,
		FREIGHT_CARRIER,
		MODE_OF_TRANSPORT,
		SERVICE_LEVEL,
		FINAL_DISCHARGE_LOCATION_CODE,
		REQUESTED_SHIP_DATE,
		PROMISED_SHIP_DATE,
		REQUESTED_DELIVERY_DATE,
		PROMISED_DELIVERY_DATE,
		RETAINAGE_RATE,
		INVOICE_MATCH_OPTION,
		PO_HEADER_ID,
		PO_LINE_ID,
		LINE_LOCATION_ID,
		LOAD_BATCH
        )
        VALUES 
        (
        po_line_loc_tbl(i).VALIDATION_ERROR_MESSAGE,
		po_line_loc_tbl(i).FILE_SET_ID,
		po_line_loc_tbl(i).MIGRATION_SET_ID,
		po_line_loc_tbl(i).MIGRATION_SET_NAME,
		'VALIDATED',
		po_line_loc_tbl(i).INTERFACE_LINE_LOCATION_KEY,
		po_line_loc_tbl(i).INTERFACE_LINE_KEY,
		po_line_loc_tbl(i).SHIPMENT_NUM,
		po_line_loc_tbl(i).SHIP_TO_LOCATION,
		po_line_loc_tbl(i).SHIP_TO_ORGANIZATION_CODE,
		po_line_loc_tbl(i).AMOUNT,
		po_line_loc_tbl(i).QUANTITY,
		po_line_loc_tbl(i).NEED_BY_DATE,
		po_line_loc_tbl(i).PROMISED_DATE,
		po_line_loc_tbl(i).SECONDARY_QUANTITY,
		po_line_loc_tbl(i).SECONDARY_UNIT_OF_MEASURE,
		po_line_loc_tbl(i).DESTINATION_TYPE_CODE,
		po_line_loc_tbl(i).ACCRUE_ON_RECEIPT_FLAG,
		po_line_loc_tbl(i).ALLOW_SUBSTITUTE_RECEIPTS_FLAG,
		po_line_loc_tbl(i).ASSESSABLE_VALUE,
		po_line_loc_tbl(i).DAYS_EARLY_RECEIPT_ALLOWED,
		po_line_loc_tbl(i).DAYS_LATE_RECEIPT_ALLOWED,
		po_line_loc_tbl(i).ENFORCE_SHIP_TO_LOCATION_CODE,
		po_line_loc_tbl(i).INSPECTION_REQUIRED_FLAG,
		po_line_loc_tbl(i).RECEIPT_REQUIRED_FLAG,
		po_line_loc_tbl(i).INVOICE_CLOSE_TOLERANCE,
		po_line_loc_tbl(i).RECEIPT_CLOSE_TOLERANCE,
		po_line_loc_tbl(i).QTY_RCV_TOLERANCE,
		po_line_loc_tbl(i).QTY_RCV_EXCEPTION_CODE,
		po_line_loc_tbl(i).RECEIPT_DAYS_EXCEPTION_CODE,
		po_line_loc_tbl(i).RECEIVING_ROUTING,
		po_line_loc_tbl(i).NOTE_TO_RECEIVER,
		po_line_loc_tbl(i).INPUT_TAX_CLASSIFICATION_CODE,
		po_line_loc_tbl(i).LINE_INTENDED_USE,
		po_line_loc_tbl(i).PRODUCT_CATEGORY,
		po_line_loc_tbl(i).PRODUCT_FISC_CLASSIFICATION,
		po_line_loc_tbl(i).PRODUCT_TYPE,
		po_line_loc_tbl(i).TRX_BUSINESS_CATEGORY_CODE,
		po_line_loc_tbl(i).USER_DEFINED_FISC_CLASS,
		po_line_loc_tbl(i).FREIGHT_CARRIER,
		po_line_loc_tbl(i).MODE_OF_TRANSPORT,
		po_line_loc_tbl(i).SERVICE_LEVEL,
		po_line_loc_tbl(i).FINAL_DISCHARGE_LOCATION_CODE,
		po_line_loc_tbl(i).REQUESTED_SHIP_DATE,
		po_line_loc_tbl(i).PROMISED_SHIP_DATE,
		po_line_loc_tbl(i).REQUESTED_DELIVERY_DATE,
		po_line_loc_tbl(i).PROMISED_DELIVERY_DATE,
		po_line_loc_tbl(i).RETAINAGE_RATE,
		po_line_loc_tbl(i).INVOICE_MATCH_OPTION,
		po_line_loc_tbl(i).PO_HEADER_ID,
		po_line_loc_tbl(i).PO_LINE_ID,
		po_line_loc_tbl(i).LINE_LOCATION_ID,
		po_line_loc_tbl(i).LOAD_BATCH
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
               CLOSE po_line_loc_validations;
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
                    IF   po_line_loc_validations%ISOPEN
                    THEN
                         --
                         CLOSE po_line_loc_validations;
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
END VALIDATE_PO_LINE_LOCATIONS;

    /*
    ******************************
    ** PROCEDURE: VALIDATE_PO_DISTRIBUTIONS
    ******************************
    */
    PROCEDURE VALIDATE_PO_DISTRIBUTIONS
                    (
                     pt_i_ApplicationSuite           IN      xxmx_module_messages.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_module_messages.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_module_messages.business_entity%TYPE
                    )
    IS

        CURSOR po_dist_validations(pt_i_MigrationSetID NUMBER)
        IS
	 /*
     ** Validate if Requestor is an active employee
     */
	SELECT 'Requestor is not an active employee' as validation_error_message,xspds.* 
    FROM XXMX_SCM_PO_HEADERS_STD_STG xsph,XXMX_SCM_PO_DISTRIBUTIONS_STD_STG xspds
    WHERE 1=1
	AND xspds.migration_set_id=pt_i_MigrationSetID
    AND xsph.interface_header_key=xspds.po_header_id
    AND NOT EXISTS (SELECT 1 FROM XXMX_PER_NAMES_F_STG
                    WHERE last_name ||', '||first_name = xspds.deliver_to_person_full_name)
	UNION ALL
	 /*
     ** Validate if Project is closed or not
     */
	SELECT 'Project is closed' as validation_error_message,stg.* 
	FROM XXMX_SCM_PO_DISTRIBUTIONS_STD_STG stg 
	WHERE 1=1
	AND migration_set_id=pt_i_MigrationSetID
    AND stg.project IS NOT NULL
    AND  NOT EXISTS (SELECT 1 FROM xxmx_ppm_projects_stg
                     WHERE 1=1
                     AND project_name=stg.project)
    AND NOT EXISTS (SELECT 1 FROM xxmx_ppm_prj_tasks_stg
                    WHERE 1=1
                    AND project_name=stg.project)
	UNION ALL
    /*
     ** Validate if Task is closed or not when Project is Open
     */
	SELECT 'Task is closed' as validation_error_message,stg.* 
	FROM XXMX_SCM_PO_DISTRIBUTIONS_STD_STG stg 
	WHERE 1=1
	AND migration_set_id=pt_i_MigrationSetID
    AND stg.project IS NOT NULL
    AND  EXISTS (SELECT 1 FROM xxmx_ppm_projects_stg
                     WHERE 1=1
                     AND project_name=stg.project)
    AND NOT EXISTS (SELECT 1 FROM xxmx_ppm_prj_tasks_stg
                    WHERE 1=1
                    AND project_name=stg.project)
	UNION ALL
    /*
     ** Validate if PO Distribution has at least one PO Line Location
     */	
	SELECT 'PO Distribution has at least one PO Line Location' as validation_error_message,xspd.* 
	FROM xxmx_scm_po_distributions_std_stg xspd
    WHERE 1=1
	AND migration_set_id=pt_i_MigrationSetID
    AND NOT EXISTS (SELECT interface_line_key,interface_line_location_key
					FROM xxmx_scm_po_line_locations_std_stg
					WHERE po_header_id=xspd.po_header_id
					AND po_line_id=xspd.po_line_id
					AND line_location_id=xspd.line_location_id
					GROUP BY interface_line_key,interface_line_location_key
					HAVING COUNT(1) >= 1)
    UNION ALL
	 /*
     ** Validate if PO Line Location Quantity matches with PO Distribution Quantity
     */	
			SELECT 'PO Line Location Quantity does not match with Distribution Quantity' as validation_error_message,stg.*
            FROM  xxmx_scm_po_distributions_std_stg stg
				,(SELECT SUM(xspl.quantity) qty,xspl.po_header_id
				  FROM xxmx_scm_po_line_locations_std_stg xspl,xxmx_scm_po_headers_std_stg xsph
				  WHERE xspl.po_header_id=xsph.po_header_id
				  GROUP BY xspl.po_header_id)xspl
				,(SELECT SUM(xspd.quantity_ordered) qty,xspd.po_header_id
				  FROM xxmx_scm_po_distributions_std_stg xspd,xxmx_scm_po_headers_std_stg xsph
				  WHERE xspd.po_header_id=xsph.po_header_id
				  GROUP BY xspd.po_header_id)xspd
			WHERE 1=1
			AND  migration_set_id = pt_i_MigrationSetID
			AND stg.po_header_id=xspl.po_header_id
			AND stg.po_header_id=xspd.po_header_id
			AND xspl.qty != xspd.qty
	UNION ALL
	 /*
     ** Validate if PO Line Location Amount matches with PO Distribution Amount
     */		
			SELECT 'PO Line Location Amount does not match with Distribution Amount' as validation_error_message,stg.*
            FROM  xxmx_scm_po_distributions_std_stg stg
				,(SELECT SUM(xspl.amount) amount,xspl.po_header_id
				  FROM xxmx_scm_po_line_locations_std_stg xspl,xxmx_scm_po_headers_std_stg xsph
				  WHERE xspl.po_header_id=xsph.po_header_id
				  GROUP BY xspl.po_header_id)xspl
				,(SELECT SUM(xspd.amount_ordered) amount,xspd.po_header_id
				  FROM xxmx_scm_po_distributions_std_stg xspd,xxmx_scm_po_headers_std_stg xsph
				  WHERE xspd.po_header_id=xsph.po_header_id
				  GROUP BY xspd.po_header_id)xspd
			WHERE 1=1
			AND  migration_set_id = pt_i_MigrationSetID
			AND stg.po_header_id=xspl.po_header_id
			AND stg.po_header_id=xspd.po_header_id
			AND xspl.amount != xspd.amount;	


       TYPE po_dist_type IS TABLE OF po_dist_validations%ROWTYPE INDEX BY BINARY_INTEGER;
	   po_dist_tbl po_dist_type;

	       --************************
          --** Constant Declarations
          --************************
          --
        ct_ProcOrFuncName CONSTANT xxmx_module_messages.proc_or_func_name%TYPE := 'VALIDATE_PO_DISTRIBUTIONS';
		ct_CoreSchema                    CONSTANT VARCHAR2(10)                                := 'xxmx_core';
        ct_CoreTable                     CONSTANT xxmx_migration_metadata.stg_table%TYPE      := 'XXMX_SCM_PO_DISTRIBUTIONS_STD_VAL';
		ct_StgTable                     CONSTANT xxmx_migration_metadata.stg_table%TYPE      := 'XXMX_SCM_PO_DISTRIBUTIONS_STD_STG';
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
                    ,pt_i_SubEntity         => ct_SubEntity
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
                    ,pt_i_SubEntity         => ct_SubEntity
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

		OPEN po_dist_validations(l_migration_set_id);

		LOOP
--		 
		 FETCH po_dist_validations 
		 BULK COLLECT INTO po_dist_tbl
		 LIMIT xxmx_utilities_pkg.gcn_BulkCollectLimit;

		EXIT WHEN po_dist_tbl.COUNT=0  ;

		gvv_ProgressIndicator := '0060';

FORALL i in 1..po_dist_tbl.COUNT 

        INSERT INTO XXMX_SCM_PO_DISTRIBUTIONS_STD_VAL
        (
        VALIDATION_ERROR_MESSAGE,
		FILE_SET_ID,
		MIGRATION_SET_ID,
		MIGRATION_SET_NAME,
		MIGRATION_STATUS,
		INTERFACE_DISTRIBUTION_KEY,
		INTERFACE_LINE_LOCATION_KEY,
		DISTRIBUTION_NUM,
		DELIVER_TO_LOCATION,
		DELIVER_TO_PERSON_FULL_NAME,
		DESTINATION_SUBINVENTORY,
		AMOUNT_ORDERED,
		QUANTITY_ORDERED,
		CHARGE_ACCOUNT_SEGMENT1,
		CHARGE_ACCOUNT_SEGMENT2,
		CHARGE_ACCOUNT_SEGMENT3,
		CHARGE_ACCOUNT_SEGMENT4,
		CHARGE_ACCOUNT_SEGMENT5,
		CHARGE_ACCOUNT_SEGMENT6,
		CHARGE_ACCOUNT_SEGMENT7,
		CHARGE_ACCOUNT_SEGMENT8,
		CHARGE_ACCOUNT_SEGMENT9,
		CHARGE_ACCOUNT_SEGMENT10,
		DESTINATION_CONTEXT,
		PROJECT,
		TASK,
		PJC_EXPENDITURE_ITEM_DATE,
		EXPENDITURE_TYPE,
		EXPENDITURE_ORGANIZATION,
		PJC_BILLABLE_FLAG,
		PJC_CAPITALIZABLE_FLAG,
		PJC_WORK_TYPE,
		RATE,
		RATE_DATE,
		DELIVER_TO_PERSON_EMAIL_ADDR,
		BUDGET_DATE,
		PJC_CONTRACT_NUMBER,
		PJC_FUNDING_SOURCE,
		PO_HEADER_ID,
		PO_LINE_ID,
		LINE_LOCATION_ID,
		PO_DISTRIBUTION_ID,
		LOAD_BATCH
        )
        VALUES 
        (
        po_dist_tbl(i).VALIDATION_ERROR_MESSAGE,
		po_dist_tbl(i).FILE_SET_ID,
		po_dist_tbl(i).MIGRATION_SET_ID,
		po_dist_tbl(i).MIGRATION_SET_NAME,
		'VALIDATED',
		po_dist_tbl(i).INTERFACE_DISTRIBUTION_KEY,
		po_dist_tbl(i).INTERFACE_LINE_LOCATION_KEY,
		po_dist_tbl(i).DISTRIBUTION_NUM,
		po_dist_tbl(i).DELIVER_TO_LOCATION,
		po_dist_tbl(i).DELIVER_TO_PERSON_FULL_NAME,
		po_dist_tbl(i).DESTINATION_SUBINVENTORY,
		po_dist_tbl(i).AMOUNT_ORDERED,
		po_dist_tbl(i).QUANTITY_ORDERED,
		po_dist_tbl(i).CHARGE_ACCOUNT_SEGMENT1,
		po_dist_tbl(i).CHARGE_ACCOUNT_SEGMENT2,
		po_dist_tbl(i).CHARGE_ACCOUNT_SEGMENT3,
		po_dist_tbl(i).CHARGE_ACCOUNT_SEGMENT4,
		po_dist_tbl(i).CHARGE_ACCOUNT_SEGMENT5,
		po_dist_tbl(i).CHARGE_ACCOUNT_SEGMENT6,
		po_dist_tbl(i).CHARGE_ACCOUNT_SEGMENT7,
		po_dist_tbl(i).CHARGE_ACCOUNT_SEGMENT8,
		po_dist_tbl(i).CHARGE_ACCOUNT_SEGMENT9,
		po_dist_tbl(i).CHARGE_ACCOUNT_SEGMENT10,
		po_dist_tbl(i).DESTINATION_CONTEXT,
		po_dist_tbl(i).PROJECT,
		po_dist_tbl(i).TASK,
		po_dist_tbl(i).PJC_EXPENDITURE_ITEM_DATE,
		po_dist_tbl(i).EXPENDITURE_TYPE,
		po_dist_tbl(i).EXPENDITURE_ORGANIZATION,
		po_dist_tbl(i).PJC_BILLABLE_FLAG,
		po_dist_tbl(i).PJC_CAPITALIZABLE_FLAG,
		po_dist_tbl(i).PJC_WORK_TYPE,
		po_dist_tbl(i).RATE,
		po_dist_tbl(i).RATE_DATE,
		po_dist_tbl(i).DELIVER_TO_PERSON_EMAIL_ADDR,
		po_dist_tbl(i).BUDGET_DATE,
		po_dist_tbl(i).PJC_CONTRACT_NUMBER,
		po_dist_tbl(i).PJC_FUNDING_SOURCE,
		po_dist_tbl(i).PO_HEADER_ID,
		po_dist_tbl(i).PO_LINE_ID,
		po_dist_tbl(i).LINE_LOCATION_ID,
		po_dist_tbl(i).PO_DISTRIBUTION_ID,
		po_dist_tbl(i).LOAD_BATCH
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
               CLOSE po_dist_validations;
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
                    IF   po_dist_validations%ISOPEN
                    THEN
                         --
                         CLOSE po_dist_validations;
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
END VALIDATE_PO_DISTRIBUTIONS;


  /*
    ******************************
    ** PROCEDURE: VALIDATE_SUPPLIERS
    ******************************
    */
    PROCEDURE VALIDATE_PURCHASE_ORDERS
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
               SELECT  sub_entity_seq
                      ,LOWER(xmm.val_package_name)      AS val_package_name
                      ,LOWER(xmm.val_procedure_name)        AS val_procedure_name
               FROM    xxmx_migration_metadata  xmm
               WHERE   1 = 1
               AND     xmm.application_suite      = pt_ApplicationSuite
               AND     xmm.application            = pt_Application
               AND     xmm.business_entity        = pt_BusinessEntity
               AND     NVL(xmm.enabled_flag, 'N') = 'Y'
               ORDER BY sub_entity_seq;


gvv_SQLStatement        VARCHAR2(32000);
gcv_SQLSpace  CONSTANT  VARCHAR2(1) := ' ';	
gvt_Phase     VARCHAR2(15) := 'VALIDATE';	

    BEGIN
        ct_ProcOrFuncName := 'VALIDATE_PURCHASE_ORDERS';
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
    END VALIDATE_PURCHASE_ORDERS;


END XXMX_PO_VALIDATIONS_PKG;
/