
    PROCEDURE export_po_headers
        (pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_po_headers'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_SCM_PO_HEADERS_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'PURCHASE_ORDERS';

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

--        gvv_ProgressIndicator := '0010';
--       xxmx_utilities_pkg.log_module_message(  
--                 pt_i_ApplicationSuite    => gct_ApplicationSuite
--                ,pt_i_Application         => gct_Application
--                ,pt_i_BusinessEntity      => gv_i_BusinessEntity
--                ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
--                ,pt_i_Phase               => ct_Phase
--                ,pt_i_Severity            => 'NOTIFICATION'
--                ,pt_i_PackageName         => gcv_PackageName
--                ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
--                ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
--                ,pt_i_ModuleMessage       => 'Deleting from "' || cv_StagingTable   || '".'
--                ,pt_i_OracleError         => gvt_ReturnMessage  );
        --   
--        DELETE 
--        FROM    XXMX_SCM_PO_HEADERS_STG    
--          ;
--
--        COMMIT;
        --
		
		export_po_headers_std
        (
        
         pt_i_MigrationSetID                => pt_i_MigrationSetID
        ,pt_i_MigrationSetName              => pt_i_MigrationSetName);
        
       export_po_headers_bpa
        (
        
         pt_i_MigrationSetID                => pt_i_MigrationSetID
        ,pt_i_MigrationSetName              => pt_i_MigrationSetName);
		
    END export_po_headers;
	
/**
**/

	/****************************************************************	
	----------------Export PO STD Lines-------------------------
	*****************************************************************/

    PROCEDURE export_po_lines_std
        (
        
         pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_po_lines_std'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_SCM_PO_LINES_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'PO_LINES';

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
        FROM    XXMX_SCM_PO_LINES_STG    
          ;

        COMMIT;
        --

        INSERT  
        INTO    XXMX_SCM_PO_LINES_STG
               (MIGRATION_SET_ID				,
				MIGRATION_SET_NAME				,
				MIGRATION_STATUS				, 
				INTERFACE_LINE_KEY				,
				INTERFACE_HEADER_KEY			,
				ACTION							,
				LINE_NUM						,
				LINE_TYPE						,
				ITEM							,
				ITEM_DESCRIPTION				,
				ITEM_REVISION					,
				CATEGORY						,
				AMOUNT							,
				QUANTITY						,
				UNIT_OF_MEASURE					,
				UNIT_PRICE						,
				SECONDARY_QUANTITY				,
				SECONDARY_UNIT_OF_MEASURE		,
				VENDOR_PRODUCT_NUM				,
				NEGOTIATED_BY_PREPARER_FLAG		,
				HAZARD_CLASS					,
				UN_NUMBER						,
				NOTE_TO_VENDOR					,
				NOTE_TO_RECEIVER				,
				LINE_ATTRIBUTE_CATEGORY_LINES	,
				LINE_ATTRIBUTE1					,
				LINE_ATTRIBUTE2					,
				LINE_ATTRIBUTE3					,
				LINE_ATTRIBUTE4					,
				LINE_ATTRIBUTE5					,
				LINE_ATTRIBUTE6					,
				LINE_ATTRIBUTE7					,
				LINE_ATTRIBUTE8					,
				LINE_ATTRIBUTE9					,
				LINE_ATTRIBUTE10				,
				LINE_ATTRIBUTE11				,
				LINE_ATTRIBUTE12				,
				LINE_ATTRIBUTE13				,
				LINE_ATTRIBUTE14				,
				LINE_ATTRIBUTE15				,
				LINE_ATTRIBUTE16				,
				LINE_ATTRIBUTE17				,
				LINE_ATTRIBUTE18				,
				LINE_ATTRIBUTE19				,
				LINE_ATTRIBUTE20				,
				ATTRIBUTE_DATE1					,
				ATTRIBUTE_DATE2					,
				ATTRIBUTE_DATE3					,
				ATTRIBUTE_DATE4					,
				ATTRIBUTE_DATE5					,
				ATTRIBUTE_DATE6					,
				ATTRIBUTE_DATE7					,
				ATTRIBUTE_DATE8					,
				ATTRIBUTE_DATE9					,
				ATTRIBUTE_DATE10				,
				ATTRIBUTE_NUMBER1				,
				ATTRIBUTE_NUMBER2				,
				ATTRIBUTE_NUMBER3				,
				ATTRIBUTE_NUMBER4				,
				ATTRIBUTE_NUMBER5				,
				ATTRIBUTE_NUMBER6				,
				ATTRIBUTE_NUMBER7				,
				ATTRIBUTE_NUMBER8				,
				ATTRIBUTE_NUMBER9				,
				ATTRIBUTE_NUMBER10				,
				ATTRIBUTE_TIMESTAMP1			,
				ATTRIBUTE_TIMESTAMP2			,
				ATTRIBUTE_TIMESTAMP3			,
				ATTRIBUTE_TIMESTAMP4			,
				ATTRIBUTE_TIMESTAMP5			,
				ATTRIBUTE_TIMESTAMP6			,
				ATTRIBUTE_TIMESTAMP7			,
				ATTRIBUTE_TIMESTAMP8			,
				ATTRIBUTE_TIMESTAMP9			,
				ATTRIBUTE_TIMESTAMP10			,
				UNIT_WEIGHT						,
				WEIGHT_UOM_CODE					,
				WEIGHT_UNIT_OF_MEASURE			,
				UNIT_VOLUME						,
				VOLUME_UOM_CODE					,
				VOLUME_UNIT_OF_MEASURE			,
				TEMPLATE_NAME					,
				ITEM_ATTRIBUTE_CATEGORY			,
				ITEM_ATTRIBUTE1					,
				ITEM_ATTRIBUTE2					,
				ITEM_ATTRIBUTE3					,
				ITEM_ATTRIBUTE4					,
				ITEM_ATTRIBUTE5					,
				ITEM_ATTRIBUTE6					,
				ITEM_ATTRIBUTE7					,
				ITEM_ATTRIBUTE8					,
				ITEM_ATTRIBUTE9					,
				ITEM_ATTRIBUTE10				,
				ITEM_ATTRIBUTE11				,
				ITEM_ATTRIBUTE12				,
				ITEM_ATTRIBUTE13				,
				ITEM_ATTRIBUTE14				,
				ITEM_ATTRIBUTE15				,
				SOURCE_AGREEMENT_PRC_BU_NAME	,
				SOURCE_AGREEMENT				,
				SOURCE_AGREEMENT_LINE			,
				DISCOUNT_TYPE					,
				DISCOUNT						,
				DISCOUNT_REASON					,
				MAX_RETAINAGE_AMOUNT            ,
                PO_HEADER_ID                    ,
                PO_LINE_ID
			)
			
        SELECT  distinct pt_i_MigrationSetID                               
                ,pt_i_MigrationSetName                               
                ,'EXTRACTED'
				,''
				,pha.po_header_id
				,''
				,pla.LINE_NUM
				,plt.LINE_TYPE
				,''
				,pla.ITEM_DESCRIPTION
				,pla.ITEM_REVISION
				,( SELECT mct.description
                   FROM   	 mtl_categories_b@MXDM_NVIS_EXTRACT      mcb
                      		,mtl_categories_tl@MXDM_NVIS_EXTRACT     mct
                   WHERE  1 = 1
                   AND    mcb.category_id = mct.category_id
                   AND    mcb.category_id = pla.category_id )
				,pla.AMOUNT
				,pla.QUANTITY
				,pla.UNIT_MEAS_LOOKUP_CODE
				,pla.UNIT_PRICE
				,pla.SECONDARY_QUANTITY
				,pla.SECONDARY_UNIT_OF_MEASURE
				,pla.VENDOR_PRODUCT_NUM
				,pla.NEGOTIATED_BY_PREPARER_FLAG
				,( SELECT phc.hazard_class
                   FROM   po_hazard_classes_tl@MXDM_NVIS_EXTRACT  phc
                   WHERE  phc.hazard_class_id = pla.hazard_class_id)
				,( SELECT poun.un_number
                   FROM   po_un_numbers_tl@MXDM_NVIS_EXTRACT poun
                   WHERE  poun.un_number_id = pla.un_number_id)
				,pla.NOTE_TO_VENDOR
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,pla.MAX_RETAINAGE_AMOUNT	
                ,pha.po_header_id
                ,pla.po_line_id
		FROM
				 PO_HEADERS_ALL@MXDM_NVIS_EXTRACT		    pha
				,PO_LINES_ALL@MXDM_NVIS_EXTRACT   			pla
				,PO_LINE_TYPES@MXDM_NVIS_EXTRACT			plt
				,HR_OPERATING_UNITS@MXDM_NVIS_EXTRACT		hou
				,XXMX_PURCHASE_ORDER_SCOPE_V				xpos
		WHERE  1                                   = 1
        --
		 AND pha.type_lookup_code                  = 'STANDARD'
         AND pha.org_id                            = xpos.org_id
		 AND pha.org_id							   = hou.organization_id	
		 AND pha.po_header_id				       = xpos.po_header_id	
         --
         AND pla.po_header_id                     = pha.po_header_id
         AND pla.line_type_id                     = plt.line_type_id
		 --AND pla.po_line_id						  = 
		;			
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
    END export_po_lines_std;


/**
**/

	/****************************************************************	
	----------------Export PO BPA Headers-------------------------
	*****************************************************************/

    PROCEDURE export_po_headers_bpa
        (
        
         pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_po_headers_bpa'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_SCM_PO_HEADERS_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'PURCHASE_ORDERS';

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
        FROM    XXMX_SCM_PO_HEADERS_STG    
          ;

        COMMIT;
        --

        INSERT  
        INTO    XXMX_SCM_PO_HEADERS_STG
               (MIGRATION_SET_ID				,
				MIGRATION_SET_NAME				,
				MIGRATION_STATUS				, 
				INTERFACE_HEADER_KEY			,
				ACTION							,
				BATCH_ID						,
				INTERFACE_SOURCE_CODE			,
				APPROVAL_ACTION					,
				DOCUMENT_NUM					,
				DOCUMENT_TYPE_CODE				,
				STYLE_DISPLAY_NAME				,
				PRC_BU_NAME						,
				REQ_BU_NAME						,
				SOLDTO_LE_NAME					,
				BILLTO_BU_NAME					,
				AGENT_NAME						,
				CURRENCY_CODE					,
				RATE							,
				RATE_TYPE						,
				RATE_DATE						,
				COMMENTS						,
				BILL_TO_LOCATION				,
				SHIP_TO_LOCATION				,
				VENDOR_NAME						,
				VENDOR_NUM						,
				VENDOR_SITE_CODE				,
				VENDOR_CONTACT					,
				VENDOR_DOC_NUM					,
				FOB                             ,
				FREIGHT_CARRIER					,
				FREIGHT_TERMS					,
				PAY_ON_CODE						,
				PAYMENT_TERMS					,
				ORIGINATOR_ROLE					,
				CHANGE_ORDER_DESC				,
				ACCEPTANCE_REQUIRED_FLAG		,
				ACCEPTANCE_WITHIN_DAYS			,
				SUPPLIER_NOTIF_METHOD			,
				FAX                             ,
				EMAIL_ADDRESS					,
				CONFIRMING_ORDER_FLAG			,
				NOTE_TO_VENDOR					,
				NOTE_TO_RECEIVER				,
				DEFAULT_TAXATION_COUNTRY		,
				TAX_DOCUMENT_SUBTYPE			,
				ATTRIBUTE_CATEGORY				,
				ATTRIBUTE1						,
				ATTRIBUTE2						,
				ATTRIBUTE3						,
				ATTRIBUTE4						,
				ATTRIBUTE5						,
				ATTRIBUTE6						,
				ATTRIBUTE7						,
				ATTRIBUTE8						,
				ATTRIBUTE9						,
				ATTRIBUTE10						,
				ATTRIBUTE11						,
				ATTRIBUTE12						,
				ATTRIBUTE13						,
				ATTRIBUTE14						,
				ATTRIBUTE15						,
				ATTRIBUTE16						,
				ATTRIBUTE17						,
				ATTRIBUTE18						,
				ATTRIBUTE19						,
				ATTRIBUTE20						,
				ATTRIBUTE_DATE1					,
				ATTRIBUTE_DATE2					,
				ATTRIBUTE_DATE3					,
				ATTRIBUTE_DATE4					,
				ATTRIBUTE_DATE5					,
				ATTRIBUTE_DATE6					,
				ATTRIBUTE_DATE7					,
				ATTRIBUTE_DATE8					,
				ATTRIBUTE_DATE9					,
				ATTRIBUTE_DATE10				,
				ATTRIBUTE_NUMBER1				,
				ATTRIBUTE_NUMBER2				,
				ATTRIBUTE_NUMBER3				,
				ATTRIBUTE_NUMBER4				,
				ATTRIBUTE_NUMBER5				,
				ATTRIBUTE_NUMBER6				,
				ATTRIBUTE_NUMBER7				,
				ATTRIBUTE_NUMBER8				,
				ATTRIBUTE_NUMBER9				,
				ATTRIBUTE_NUMBER10				,
				ATTRIBUTE_TIMESTAMP1			,
				ATTRIBUTE_TIMESTAMP2			,
				ATTRIBUTE_TIMESTAMP3			,
				ATTRIBUTE_TIMESTAMP4			,
				ATTRIBUTE_TIMESTAMP5			,
				ATTRIBUTE_TIMESTAMP6			,
				ATTRIBUTE_TIMESTAMP7			,
				ATTRIBUTE_TIMESTAMP8			,
				ATTRIBUTE_TIMESTAMP9			,
				ATTRIBUTE_TIMESTAMP10			,
				AGENT_EMAIL_ADDRESS				,
				MODE_OF_TRANSPORT_CODE			,
				SERVICE_LEVEL					,
				FIRST_PTY_REG_NUM				,
				THIRD_PTY_REG_NUM				,
				BUYER_MANAGED_TRANSPORT_FLAG	,
				MASTER_CONTRACT_NUMBER			,
				MASTER_CONTRACT_TYPE			,
				CC_EMAIL_ADDRESS				,
				BCC_EMAIL_ADDRESS				,
                PO_HEADER_ID
			)
			
        SELECT  distinct pt_i_MigrationSetID                               
                ,pt_i_MigrationSetName                               
                ,'EXTRACTED'
				,pha.po_header_id
				,''
				,''
				,pha.INTERFACE_SOURCE_CODE
				,pha.authorization_status
				,pha.SEGMENT1
				,pha.TYPE_LOOKUP_CODE
				,(SELECT pds.display_name
                  FROM   po_doc_style_lines_tl@MXDM_NVIS_EXTRACT pds
                  WHERE  pds.document_subtype = 'STANDARD'
                  AND    pds.style_id = pha.style_id)
				,hou.name
				,NVL((SELECT hout.name
                      FROM   po_distributions_all@MXDM_NVIS_EXTRACT         pda
                      		,po_req_distributions_all@MXDM_NVIS_EXTRACT     prda
                      		,po_requisition_lines_all@MXDM_NVIS_EXTRACT     prla
                      		,po_requisition_headers_all@MXDM_NVIS_EXTRACT   prha
                      		,hr_operating_units@MXDM_NVIS_EXTRACT           hout
                	  WHERE  pha.po_header_id           = pda.po_header_id
                      AND    pda.req_distribution_id    = prda.distribution_id
                      AND    prda.requisition_line_id   = prla.requisition_line_id
                      AND    prla.requisition_header_id = prha.requisition_header_id
                      AND    hou.organization_id        = prha.org_id
                      AND    rownum                     = 1),hou.name)
				,(SELECT xep.name
                  FROM   	hr_operating_units@MXDM_NVIS_EXTRACT hout
                    	   ,xle_entity_profiles@MXDM_NVIS_EXTRACT xep
                  WHERE  xep.legal_entity_id  = hout.default_legal_context_id
                  AND    hout.organization_id = hou.organization_id)
				,hou.name
				,(SELECT lower(ppf.email_address)
                  FROM   per_all_people_f@MXDM_NVIS_EXTRACT  ppf
                  WHERE  ppf.person_id            = pha.agent_id
                  AND    ppf.email_address       IS NOT NULL
                  AND    ppf.effective_start_date = ( SELECT max(effective_start_date)
                                                   FROM   per_all_people_f@MXDM_NVIS_EXTRACT  ppf1
                                                   WHERE  ppf1.person_id = ppf.person_id) )
				,pha.CURRENCY_CODE
				,pha.RATE
				,pha.RATE_TYPE
				,pha.RATE_DATE
				,pha.COMMENTS
				,''
				,''
				,pv.VENDOR_NAME
				,pv.SEGMENT1
				,pvsa.VENDOR_SITE_CODE
				,''
				,''
				,''
				,''
				,''
				,pha.PAY_ON_CODE
				,(select name
                  from   ap_terms@MXDM_NVIS_EXTRACT
                  where  term_id = pha.terms_id)
				,''
				,pha.change_summary
				,pha.ACCEPTANCE_REQUIRED_FLAG
				,''
				,pha.SUPPLIER_NOTIF_METHOD
				,pha.FAX
				,pha.EMAIL_ADDRESS
				,pha.CONFIRMING_ORDER_FLAG
				,pha.NOTE_TO_VENDOR
				,pha.NOTE_TO_RECEIVER
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''
				,''	
                ,''
		FROM
				 PO_HEADERS_ALL@MXDM_NVIS_EXTRACT			pha
				,PO_VENDORS@MXDM_NVIS_EXTRACT   			pv
				,PO_VENDOR_SITES_ALL@MXDM_NVIS_EXTRACT		pvsa
				,HR_OPERATING_UNITS@MXDM_NVIS_EXTRACT		hou
				,XXMX_PURCHASE_ORDER_SCOPE_V				xpos
		WHERE  1                                 = 1
        --
		AND pha.type_lookup_code              	= 'BLANKET'
		AND pha.org_id                    	 	= xpos.org_id
        AND hou.organization_id				    = pha.org_id
		AND pha.po_header_id				  	= xpos.po_header_id
		--
        AND pha.vendor_id                   	= pv.vendor_id
        AND pha.vendor_site_id               	= pvsa.vendor_site_id
		;				
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
    END export_po_headers_bpa;

	