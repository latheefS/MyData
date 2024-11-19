CREATE OR REPLACE PACKAGE XXMX_PO_PKG AS 
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
	----------------Export PO Headers-------------------------
	*****************************************************************/
    gvv_ReturnStatus                          VARCHAR2(1); 
    gvt_ReturnMessage                         xxmx_module_messages.module_message%TYPE;
    gvv_ProgressIndicator                     VARCHAR2(100); 
    gcv_PackageName                           CONSTANT  VARCHAR2(30)                                := 'xxmx_po_pkg';
    gct_ApplicationSuite                      CONSTANT  xxmx_module_messages.application_suite%TYPE := 'FIN';
    gct_Application                           CONSTANT  xxmx_module_messages.application%TYPE       := 'IREC';
    gv_i_BusinessEntity                       CONSTANT  VARCHAR2(100)                               := 'IRecruitment';
    ct_Phase                                  CONSTANT  xxmx_module_messages.phase%TYPE             := 'EXTRACT';
    cv_i_BusinessEntityLevel                  CONSTANT  VARCHAR2(100)                               := 'ALL';
    gv_hr_date					              DATE                                                  := '31-DEC-4712';
	--pt_i_MigrationSetName                     VARCHAR2(100)                                         := 'IRecruitment '||to_char(SYSDATE, 'DD/MM/YYYY');  --no hard code
	p_bg_name  VARCHAR2(100)                                         := 'TEST_BG'; 
    gvt_Severity                              xxmx_module_messages.severity%TYPE;
    gvt_ModuleMessage                         xxmx_module_messages.module_message%TYPE;
    gvt_OracleError                           xxmx_module_messages.oracle_error%TYPE;

    E_MODULEERROR                             EXCEPTION;



	/****************************************************************	
	----------------Export PO Headers-------------------------
	*****************************************************************/

    PROCEDURE export_po_headers
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          number
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_po_headers'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_PO_HEADERS_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'PO_HEADERS';

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
        FROM    XXMX_PO_HEADERS_STG    
        WHERE   bg_id    = p_bg_id    ;

        COMMIT;
        --

        INSERT  
        INTO    XXMX_PO_HEADERS_STG
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
				FOB,
				FREIGHT_CARRIER					,
				FREIGHT_TERMS					,
				PAY_ON_CODE						,
				PAYMENT_TERMS					,
				ORIGINATOR_ROLE					,
				CHANGE_ORDER_DESC				,
				ACCEPTANCE_REQUIRED_FLAG		,
				ACCEPTANCE_WITHIN_DAYS			,
				SUPPLIER_NOTIF_METHOD			,
				FAX,
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
				BCC_EMAIL_ADDRESS				
			)
			
        SELECT  distinct pt_i_MigrationSetID                               
                ,pt_i_MigrationSetName                               
                ,'EXTRACTED'
				,''
				,''
				,''
				,pha.INTERFACE_SOURCE_CODE
				,''
				,pha.SEGMENT1
				,pha.TYPE_LOOKUP_CODE
				,''
				,''
				,''
				,''
				,''
				,''
				,pha.CURRENCY_CODE
				,pha.RATE
				,pha.RATE_TYPE
				,pha.RATE_DATE
				,pha.COMMENTS
				,''
				,''
				,pv.VENDOR_NAME
				,pv.SEGMENT1
				,pvs.VENDOR_SITE_CODE
				,''
				,''
				,''
				,''
				,''
				,pha.PAY_ON_CODE
				,''
				,''
				,''
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
		FROM
				PO_HEADERS_ALL@MXDM_NVIS_EXTRACT			pha
				,PO_VENDORS@MXDM_NVIS_EXTRACT   			pv
				,PO_VENDOR_SITES_ALL@MXDM_NVIS_EXTRACT		pvs
		WHERE  1                                 = 1
        --
        AND    pha.vendor_id                     = pv.vendor_id
        AND    pha.vendor_site_id                = pvs.vendor_site_id
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
    END export_po_headers;
END XXMX_PO_PKG;