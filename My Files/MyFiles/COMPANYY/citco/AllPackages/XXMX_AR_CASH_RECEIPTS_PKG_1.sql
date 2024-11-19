create or replace PACKAGE BODY XXMX_AR_CASH_RECEIPTS_PKG
AS
-- ================================================================================
-- | VERSION1 |
-- ================================================================================
--
-- FILENAME
-- XXMX_AR_CASH_RECEIPTS_PKG.sql
--
-- DESCRIPTION
-- AR cash receipts extract
-- -----------------------------------------------------------------------------
--
-- Change List
-- ===========
--
-- Date       Author            Comment
-- ---------- ----------------- -------------------- ---------------------------
-- 29/06/2022 Michal Arrowsmith NEW: ar_original_cash_receipts_stg
-- 18/07/2023 Michal Arrowsmith Batch name: use lockbox instead of BU 
-- =============================================================================
--
--
-- -----------------------------------------------------------------------------
-- Global Declarations
-- -----------------------------------------------------------------------------
     --
-- -----------------------------------------------------------------------------
-- Maximise Integration Globals
-- -----------------------------------------------------------------------------
--
-- -----------------------------------------------------------------------------
-- Global Constants for use in all xxmx_utilities_pkg Procedure/Function Calls within this package
-- -----------------------------------------------------------------------------
--
gct_PackageName                           CONSTANT xxmx_module_messages.package_name%TYPE       := 'xxmx_ar_cash_receipts_pkg';
gct_StgSchema                             CONSTANT VARCHAR2(10)                                 := 'xxmx_stg';
gct_XfmSchema                             CONSTANT VARCHAR2(10)                                 := 'xxmx_xfm';
gct_CoreSchema                            CONSTANT VARCHAR2(10)                                 := 'xxmx_core';
gct_DfltBankOriginationNum                CONSTANT VARCHAR2(10)                                 := 'RADIUS';  -- SMBC default value
gct_AmountAsPence                         CONSTANT VARCHAR2(1)                                  := 'N';       -- SMBC default value
gct_ApplicationSuite                      xxmx_module_messages.application_suite%TYPE  := 'FIN';
gct_Application                           xxmx_module_messages.application%TYPE        := 'AR';
gct_BusinessEntity                        xxmx_migration_metadata.business_entity%TYPE := 'CASH_RECEIPTS';
gct_phase                             xxmx_module_messages.phase%TYPE              := 'EXPORT';

--
-- -----------------------------------------------------------------------------
-- Global Progress Indicator Variable for use in all Procedures/Functions within this package
-- -----------------------------------------------------------------------------
--
gvv_ProgressIndicator                              VARCHAR2(100);
--
-- -----------------------------------------------------------------------------
-- Global Variables for receiving Status/Messages from certain Procedure/Function Calls (e.g. xxmx_utilities_pkg.clear_messages
-- -----------------------------------------------------------------------------
--
gvv_ReturnStatus                          VARCHAR2(1);
gvt_ReturnMessage                         xxmx_module_messages.module_message%TYPE;
--
-- -----------------------------------------------------------------------------
-- Global Variables for Exception Handlers
-- -----------------------------------------------------------------------------
--
gvv_ApplicationErrorMessage               VARCHAR2(2048);
gvt_Severity                              xxmx_module_messages.severity%TYPE;
gvt_ModuleMessage                         xxmx_module_messages.module_message%TYPE;
gvt_OracleError                           xxmx_module_messages.oracle_error%TYPE;
--
-- -----------------------------------------------------------------------------
-- Global Variables for Migration Set Name
-- -----------------------------------------------------------------------------
--
gvt_MigrationSetName                      xxmx_migration_headers.migration_set_name%TYPE;
--
-- -----------------------------------------------------------------------------
-- Global constants and variables for dynamic SQL usage
-- -----------------------------------------------------------------------------
--
gcv_SQLSpace                              CONSTANT  VARCHAR2(1) := ' ';
gvv_SQLAction                             VARCHAR2(20);
gvv_SQLTableClause                        VARCHAR2(100);
gvv_SQLColumnList                         VARCHAR2(4000);
gvv_SQLValuesList                         VARCHAR2(4000);
gvv_SQLWhereClause                        VARCHAR2(4000);
gvv_SQLStatement                          VARCHAR2(32000);
gvv_SQLResult                             VARCHAR2(4000);
--
-- -----------------------------------------------------------------------------
-- Global variables for holding table row counts
-- -----------------------------------------------------------------------------
--
gvn_RowCount                                       NUMBER;
TYPE t_File_columns IS VARRAY(50000) OF VARCHAR2(200) ;
t_File_col t_File_columns := t_File_columns();
--
-- -----------------------------------------------------------------------------
-- Global variables for transform procedures
-- -----------------------------------------------------------------------------
--
gvb_MissingSetup                                   BOOLEAN;
e_ModuleError                   EXCEPTION;
e_dataerror                     EXCEPTION;
e_nodata                        EXCEPTION;

--
--
procedure XXMX_FILE_COL_SEQ (p_xfm_Table_id IN VARCHAR2,pv_o_ReturnStatus OUT VARCHAR2) IS 
    --
    cursor c1 IS 
        select
            length(regexp_replace(TRIM(SUBSTR(excel_file_header,1,50000)), '[^,]'))/ length(',') cnt
					   ,excel_file_header
					   ,b.xfm_table_id
					   ,substr(excel_file_header,INSTR(excel_file_header,',',-1,1)+1,length(excel_file_header)) last_col
        from
            xxmx_dm_subentity_file_map a,
			xxmx_migration_metadata m,
			xxmx_xfm_Table_columns b,
			xxmx_xfm_tables c
        where a.sub_entity = m.sub_entity
		and b.xfm_table_id = p_xfm_Table_id
		and c.table_name = UPPER(m.xfm_table)
		and b.xfm_table_id = c.xfm_table_id
		and rownum=1;
    --
	lv_test VARCHAR2(200);
	j NUMBER;
	lv_sql CLOB;
	cv_ProcOrFuncName                    CONSTANT VARCHAR2(30)                            := 'xxmx_file_col_seq';
    --
begin
    gvv_ProgressIndicator:= '0010';
	t_File_col  := t_File_columns();
    --
    select meta.application_suite,meta.application,meta.business_entity 
        into gct_ApplicationSuite,gct_Application,gct_BusinessEntity
        from xxmx_xfm_tables xfm, xxmx_migration_metadata meta
        where xfm.metadata_id=meta.metadata_id 
        and xfm.xfm_table_id=p_xfm_Table_id; 
    FOR r IN C1
	LOOP
        j:=r.cnt+1;
		t_File_col.EXTEND(r.cnt+1);
					 gvv_ProgressIndicator:= '0015';
					 FOR i IN 1..r.cnt
					 LOOP
						lv_test := NULL;
						gvv_ProgressIndicator:= '0020';
						IF( i=1) then 
							gvv_ProgressIndicator:= '0025';
						 -- lv_sql:= 'Select REPLACE(substr('''||r.excel_file_header||''','||i||',INSTR('''||r.excel_file_header||''','','','||i||','||i||')),'','','''')'||
						 --' from dual';
							lv_sql:= 'Select REPLACE(substr(:a,:b,INSTR(:c,'','',:d,:d)),'','','''')'||
									' from dual';
					   -- DBMS_OUTPUT.PUT_LINE(lv_sql);
							EXECUTE IMMEDIATE lv_sql INTO lv_test using r.excel_file_header,i,r.excel_file_header,i,i;
							gvv_ProgressIndicator:= '0030';
						ELSE 
						 gvv_ProgressIndicator:= '0035';

						 lv_sql:= 'SELECT substr(:a,INSTR(:b,'','',1,:c-1)+1,(INSTR(:d,'','',1,:e))-(INSTR(:f,'','',1,:g-1)+1)) from dual';
						 --DBMS_OUTPUT.PUT_LINE(lv_sql);
						 EXECUTE IMMEDIATE lv_sql INTO lv_test using r.excel_file_header,
																	 r.excel_file_header,
																	 i,
																	 r.excel_file_header,
																	 i,
																	 r.excel_file_header,
																	 i;

						 gvv_ProgressIndicator:= '0040';

						END IF;

						IF( lv_test IS NOT NULL) then
							gvv_ProgressIndicator:= '0045';
							gvt_ModuleMessage:= 'Field_name '||lv_test;
							t_File_col(i) := lv_test;
						   -- DBMS_OUTPUT.PUT_LINE(lv_test);
						ELSE 
							gvv_ProgressIndicator:= '0050'; 
							gvt_ModuleMessage := 'Column with null value';
							--raise e_ModuleError;
						END IF;


            END LOOP;
            gvt_ModuleMessage:= 'Field_name '||r.last_col||' '||j;
            t_File_col(j):= r.last_col;
    END LOOP;
    --
    gvv_ProgressIndicator:= '0055'; 
	pv_o_ReturnStatus := 'S';
EXCEPTION
    WHEN e_ModuleError then
					 pv_o_ReturnStatus := 'E';
					 xxmx_utilities_pkg.log_module_message(  
							 pt_i_ApplicationSuite    => gct_ApplicationSuite
							,pt_i_Application         => gct_Application
							,pt_i_BusinessEntity      => gct_BusinessEntity
							,pt_i_SubEntity           =>  'ALL'
							,pt_i_MigrationSetID      => 0
							,pt_i_Phase               => gct_phase
							,pt_i_Severity            => 'ERROR'
							,pt_i_PackageName         => gct_PackageName
							,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
							,pt_i_ProgressIndicator   => gvv_ProgressIndicator
							,pt_i_ModuleMessage       => gvt_ModuleMessage  
							,pt_i_OracleError         => gvt_ReturnMessage       );    
    --
	WHEN OTHERS then 
			   --
					 pv_o_ReturnStatus := 'E';
					 gvt_OracleError := SUBSTR(SQLERRM||'-'||SQLCODE,1,500);
					 xxmx_utilities_pkg.log_module_message(  
							 pt_i_ApplicationSuite    => gct_ApplicationSuite
							,pt_i_Application         => gct_Application
							,pt_i_BusinessEntity      => gct_BusinessEntity
							,pt_i_SubEntity           =>  'ALL'
							,pt_i_MigrationSetID      => 0
							,pt_i_Phase               => gct_phase
							,pt_i_Severity            => 'ERROR'
							,pt_i_PackageName         => gct_PackageName
							,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
							,pt_i_ProgressIndicator   => gvv_ProgressIndicator
							,pt_i_ModuleMessage       => gvt_ModuleMessage  
							,pt_i_OracleError         => gvt_OracleError       );    
END XXMX_FILE_COL_SEQ;
-- -------------------------------------------------------------------------- --
-- AR_ORIGINAL_CASH_RECEIPTS_STG
-- -------------------------------------------------------------------------- --
PROCEDURE ar_original_cash_receipts_stg
(
     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
)
is
        --
        ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'ar_outstanding_cash_receipts_s';
        ct_Phase                        CONSTANT  xxmx_module_messages.phase%TYPE             := 'EXTRACT';
        ct_StgTable                     CONSTANT  xxmx_migration_metadata.stg_table%TYPE      := 'xxmx_ar_cash_receipts_stg';
        --
        v_sql                           varchar2(3000);
        v_cut_off_date                  varchar2(50);
        v_cut_off_date_conv             date;
        --
        e_ModuleError                   EXCEPTION;
        --
BEGIN
    --
    gvv_ProgressIndicator := 'S-001';
    gvv_ReturnStatus  := '';
    gvt_ReturnMessage := '';
    xxmx_utilities_pkg.clear_messages
               (
                pt_i_ApplicationSuite    => gct_ApplicationSuite
               ,pt_i_Application         => gct_Application
               ,pt_i_BusinessEntity      => gct_BusinessEntity
               ,pt_i_SubEntity           => pt_i_SubEntity
               ,pt_i_Phase               => ct_Phase
               ,pt_i_MessageType         => 'MODULE'
               ,pv_o_ReturnStatus        => gvv_ReturnStatus
               );
    --
    IF   gvv_ReturnStatus = 'F' then
        xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gct_BusinessEntity
                    ,pt_i_SubEntity           => pt_i_SubEntity
                    ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_PackageName         => gct_PackageName
                    ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                    ,pt_i_Severity               => 'ERROR'
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => '(*) Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
                    ,pt_i_OracleError         => gvt_ReturnMessage
                    );
        --
        RAISE e_ModuleError;
    end if;
    --
    --
    gvv_ProgressIndicator := 'S-002';
    gvv_ReturnStatus  := '';
    gvt_ReturnMessage := '';
    xxmx_utilities_pkg.clear_messages
               (
                pt_i_ApplicationSuite    => gct_ApplicationSuite
               ,pt_i_Application         => gct_Application
               ,pt_i_BusinessEntity      => gct_BusinessEntity
               ,pt_i_SubEntity           => pt_i_SubEntity
               ,pt_i_Phase               => ct_Phase
               ,pt_i_MessageType         => 'DATA'
               ,pv_o_ReturnStatus        => gvv_ReturnStatus
               );
    --
    IF   gvv_ReturnStatus = 'F' then
        xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gct_BusinessEntity
                    ,pt_i_SubEntity           => pt_i_SubEntity
                    ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_PackageName         => gct_PackageName
                    ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                    ,pt_i_Severity               => 'ERROR'
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => '(*) Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
                    ,pt_i_OracleError         => gvt_ReturnMessage
                    );
        --
        RAISE e_ModuleError;
    end if;
    --
    --
    gvv_ProgressIndicator := 'S-003';
    xxmx_utilities_pkg.log_module_message
               (
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gct_BusinessEntity
                    ,pt_i_SubEntity           => pt_i_SubEntity
                    ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_PackageName         => gct_PackageName
                    ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                    ,pt_i_Severity            => 'NOTIFICATION'
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => 'Procedure "'||gct_PackageName||'.'||ct_ProcOrFuncName||'" initiated.'
                    ,pt_i_OracleError         => NULL
               );
    --
    -- Retrieve the Migration Set Name
    -- If the Migration Set Name is NULL then the Migration has not been initialized.
    --
    gvv_ProgressIndicator := 'S-004';
    gvt_MigrationSetName := xxmx_utilities_pkg.get_migration_set_name(pt_i_MigrationSetID);
    if gvt_MigrationSetName IS NOT NULL then
        xxmx_utilities_pkg.init_migration_details
                    (
                     pt_i_ApplicationSuite       => gct_ApplicationSuite
                    ,pt_i_Application            => gct_Application
                    ,pt_i_BusinessEntity         => gct_BusinessEntity
                    ,pt_i_SubEntity              => pt_i_SubEntity
                    ,pt_i_MigrationSetID         => pt_i_MigrationSetID
                    ,pt_i_StagingTable           => ct_StgTable
                    ,pt_i_ExtractStartDate       => SYSDATE
                    );
        --
        xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gct_BusinessEntity
                    ,pt_i_SubEntity           => pt_i_SubEntity
                    ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_PackageName         => gct_PackageName
                    ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                    ,pt_i_Severity            => 'NOTIFICATION'
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => pt_i_SubEntity||': Extract from EBS to STG table "'||ct_StgTable||'"'
                    ,pt_i_OracleError         => NULL
                    );
        --
        -- Extract the AR Cash Receipts and insert into the staging table.
        --
        gvv_ProgressIndicator := 'S-005';
        insert into xxmx_ar_cash_receipts_stg
            (
                                 migration_set_id
                                ,migration_set_name
                                ,migration_status
                                ,item_number
                                ,record_type
                                ,migrated_receipt_type
                                ,operating_unit_name
                                --
                                ,remittance_amount
                                ,cash_receipt_id
                                ,receipt_number
                                ,receipt_date
                                --
                                ,currency_code
                                ,exchange_rate_type
                                ,exchange_rate
                                --
                                ,customer_number
                                ,bill_to_location
                                --,lockbox_number
                                ,receipt_method
                                --
                                ,deposit_date
                                ,anticipated_clear_date
                                --
                                ,comments
                                ,attribute1
                                ,attribute2
                                ,attribute3
                                --
                                ,overflow_sequence
                                ,invoice_number
                                ,matching_date
                                ,amount_applied
                                ,INVOICE_CURRENCY_CODE 
                                ,trans_to_receipt_rate 
                                ,exchange_gain_loss 
                                ,bank_account_num
            )
        SELECT
             pt_i_MigrationSetID                             as migration_set_id
            ,gvt_MigrationSetName                          as migration_set_name
            ,'EXTRACTED'                                     as migration_status
            ,0                                                    as item_number
            ,decode(
                row_number() over 
                (
                    partition by acra.receipt_number 
                    order by acra.receipt_number
                ),1,6,4 )                                         as record_type
            ,min(xacrsv.migrated_receipt_type)          as migrated_receipt_type
            ,min(xacrsv.operating_unit_name)              AS operating_unit_name
            --
            ,min(xacrsv.receipt_amount_original)            AS remittance_amount
            ,acra.cash_receipt_id                             as cash_receipt_id
            ,acra.receipt_number                               AS receipt_number
            ,min(acra.receipt_date)                              AS receipt_date
            --
            ,min(acra.currency_code)                            AS currency_code
            ,min(xacrsv.exchange_rate_type)                AS exchange_rate_type
            ,min(xacrsv.exchange_rate)                          AS exchange_rate
            --
            ,min(hca.account_number)                          AS customer_number
            ,min(hcsu.location)                              AS bill_to_location
            --,min(xfld.lockbox_number)                          AS lockbox_number
            ,min(arrm.name)                                    as receipt_method
            --
            ,min(acra.deposit_date)                              AS deposit_date
            ,min(acra.anticipated_clearing_date)    AS anticipated_clearing_date
            --
            ,xxmx_utilities_pkg.convert_string
                   (
                    pv_i_StringToConvert     => min(acra.comments)
                   ,pv_i_ConvertCommaToSpace => 'N'
                   ,pi_i_SubstrStartPos      => 1
                   ,pi_i_SubstrLength        => 240
                   ,pv_i_UseBinarySubstr     => 'Y'
                   )                                                 AS comments
            ,min(xacrsv.receipt_amount_original)                   as attribute1
            ,racta.trx_number                                      as attribute2
            --,(arra.amount_applied)                              as attribute3
            ,round(sum(arra.amount_applied * nvl(arra.trans_to_receipt_rate,1)),2)                              as attribute3
            --
            --
            ,row_number() over 
                (
                    partition by acra.receipt_number 
                    order by acra.receipt_number
                )                                           as overflow_sequence
            ,racta.trx_number                                  as invoice_number
            ,arra.apply_date                                    as matching_date
            --,(arra.amount_applied)                         as amount_to_apply --Milind amended to handle exchange rate
            ,round(sum(arra.amount_applied * nvl(arra.trans_to_receipt_rate,1)),2)                         as amount_to_apply
            ,arpsa.invoice_currency_code                as invoice_currency_code
            ,arra.trans_to_receipt_rate                 as trans_to_receipt_rate
            ,sum(arra.acctd_amount_applied_from-arra.acctd_amount_applied_to)
                                                           as exchange_gain_loss
            --
            ,min(ceba.bank_account_num)                      as bank_account_num
        FROM
             xxmx_ar_cash_receipts_scope_v                  xacrsv
            ,apps.ar_cash_receipts_all@XXMX_EXTRACT         acra
            ,apps.hz_cust_accounts@XXMX_EXTRACT             hca
            ,apps.hz_cust_site_uses_all@XXMX_EXTRACT        hcsu 
            ,apps.ar_receipt_methods@XXMX_EXTRACT           arrm
            ,apps.ar_receipt_classes@XXMX_EXTRACT           arrc
            ,ce_bank_acct_uses_all@XXMX_EXTRACT             cebaua
            ,ce_bank_accounts@XXMX_EXTRACT                  ceba
--            ,xxmx_fusion_lockbox_details                    xfld
            ,ar.ar_receivable_applications_all@XXMX_EXTRACT    arra
            ,ra_customer_trx_all@XXMX_EXTRACT               racta
            ,ar_payment_schedules_all@XXMX_EXTRACT          arpsa
        WHERE     1=1 --nvl(xacrsv.receipt_amount_remaining  ,0) <> 0
        AND       acra.org_id                             = xacrsv.org_id
        AND       acra.cash_receipt_id                    = xacrsv.cash_receipt_id
        AND       hca.cust_account_id                     = xacrsv.customer_id
        AND       hcsu.site_use_id(+)                     = acra.customer_site_use_id               
        AND       arrm.receipt_method_id                  = acra.receipt_method_id
        AND       arrc.receipt_class_id                   = arrm.receipt_class_id
        AND       cebaua.bank_acct_use_id                 = acra.remit_bank_acct_use_id
        AND       ceba.bank_account_id                    = cebaua.bank_account_id
--        AND       xfld.bu_name(+)                         = xacrsv.operating_unit_name
--        AND       xfld.receipt_method(+)                  = arrm.name
--        AND       xfld.bank_origination_number(+)         = ceba.bank_account_num
        and   arra.cash_receipt_id           = acra.cash_receipt_id
        and   arra.applied_customer_trx_id   = racta.customer_trx_id
        and   arra.applied_customer_trx_id   is not null 
        and   arra.payment_schedule_id       = arpsa.payment_schedule_id
        --
        group by
             acra.receipt_number
            ,acra.cash_receipt_id
            ,arra.apply_date
            ,to_char(arra.apply_date,'YYMMDD')
            ,arra.applied_customer_trx_id
            ,racta.trx_number
            ,arpsa.invoice_currency_code
            ,arra.trans_to_receipt_rate
        --having sum(arra.amount_applied)!=0
        UNION 
        SELECT
             pt_i_MigrationSetID                             as migration_set_id
            ,gvt_MigrationSetName                          as migration_set_name
            ,'EXTRACTED'                                     as migration_status
            ,0                                                    as item_number
            ,6                                                    as record_type
            ,xacrsv.migrated_receipt_type               as migrated_receipt_type
            ,xacrsv.operating_unit_name                   AS operating_unit_name
            --
            --,xacrsv.receipt_amount_original                 AS remittance_amount
            ,nvl(xacrsv.receipt_amount_original  ,0)        AS remittance_amount   --Amended by Milind
            ,acra.cash_receipt_id                             as cash_receipt_id
            ,acra.receipt_number                               AS receipt_number
            ,acra.receipt_date                                   AS receipt_date
            --
            ,acra.currency_code                                 AS currency_code
            ,xacrsv.exchange_rate_type                     AS exchange_rate_type
            ,xacrsv.exchange_rate                               AS exchange_rate
            --
            ,hca.account_number                               AS customer_number
            ,hcsu.location                                   AS bill_to_location
--            ,xfld.lockbox_number                               AS lockbox_number
            ,arrm.name                                         as receipt_method
            --
            ,acra.deposit_date                                   AS deposit_date
            ,acra.anticipated_clearing_date         AS anticipated_clearing_date
            --
            ,xxmx_utilities_pkg.convert_string
                   (
                    pv_i_StringToConvert     => acra.comments
                   ,pv_i_ConvertCommaToSpace => 'N'
                   ,pi_i_SubstrStartPos      => 1
                   ,pi_i_SubstrLength        => 240
                   ,pv_i_UseBinarySubstr     => 'Y'
                   )                                                 AS comments                        
            ,xacrsv.receipt_amount_original                        as attribute1
            ,null                                                  as attribute2
            ,null                                                  as attribute3
            --
            ,null                                           as overflow_sequence
            ,null                                              as invoice_number
            ,null                                               as matching_date
            ,null                                             as amount_to_apply
            ,null                                       as invoice_currency_code
            ,null                                       as trans_to_receipt_rate
            ,null                                          as exchange_gain_loss
            --
            ,ceba.bank_account_num                           as bank_account_num
        FROM
             xxmx_ar_cash_receipts_scope_v                  xacrsv
            ,apps.ar_cash_receipts_all@XXMX_EXTRACT         acra
            ,apps.hz_cust_accounts@XXMX_EXTRACT             hca
            ,apps.hz_cust_site_uses_all@XXMX_EXTRACT        hcsu 
            ,apps.ar_receipt_methods@XXMX_EXTRACT           arrm
            ,apps.ar_receipt_classes@XXMX_EXTRACT           arrc
            ,ce_bank_acct_uses_all@XXMX_EXTRACT             cebaua
            ,ce_bank_accounts@XXMX_EXTRACT                  ceba
--            ,xxmx_fusion_lockbox_details                    xfld
        WHERE     1=1 --nvl(xacrsv.receipt_amount_remaining  ,0) <> 0
        AND       acra.org_id                             = xacrsv.org_id
        AND       acra.cash_receipt_id                    = xacrsv.cash_receipt_id
        AND       hca.cust_account_id                     = xacrsv.customer_id
        AND       hcsu.site_use_id(+)                     = acra.customer_site_use_id               
        AND       arrm.receipt_method_id                  = acra.receipt_method_id
        AND       arrc.receipt_class_id                   = arrm.receipt_class_id
        AND       cebaua.bank_acct_use_id                 = acra.remit_bank_acct_use_id
        AND       ceba.bank_account_id                    = cebaua.bank_account_id
--        AND       xfld.bu_name(+)                         = xacrsv.operating_unit_name
--        AND       xfld.receipt_method(+)                  = arrm.name
--        AND       xfld.bank_origination_number(+)         = ceba.bank_account_num
        and       xacrsv.migrated_receipt_type            in ('On-Account','Unapplied')
        UNION 
        SELECT
             pt_i_MigrationSetID                             as migration_set_id
            ,gvt_MigrationSetName                          as migration_set_name
            ,'EXTRACTED'                                     as migration_status
            ,0                                                    as item_number
            ,6                                                    as record_type
            ,xacrsv.migrated_receipt_type               as migrated_receipt_type
            ,xacrsv.operating_unit_name                   AS operating_unit_name
            --
            --,xacrsv.receipt_amount_original                 as remittance_amount
            ,nvl(xacrsv.receipt_amount_original,0)         as remittance_amount   --Amended by Milind
            ,acra.cash_receipt_id                             as cash_receipt_id
            ,acra.receipt_number                               as receipt_number
            ,acra.receipt_date                                   as receipt_date
            --
            ,acra.currency_code                                 as currency_code
            ,xacrsv.exchange_rate_type                     as exchange_rate_type
            ,xacrsv.exchange_rate                               as exchange_rate
            --
            ,null                                             as customer_number
            ,null                                            as bill_to_location
--            ,xfld.lockbox_number                               AS lockbox_number
            ,arrm.name                                         as receipt_method
            --
            ,acra.deposit_date                                   AS deposit_date
            ,acra.anticipated_clearing_date         AS anticipated_clearing_date
            --
            ,xxmx_utilities_pkg.convert_string
                   (
                    pv_i_StringToConvert     => acra.comments
                   ,pv_i_ConvertCommaToSpace => 'N'
                   ,pi_i_SubstrStartPos      => 1
                   ,pi_i_SubstrLength        => 240
                   ,pv_i_UseBinarySubstr     => 'Y'
                   )                                                 AS comments
            ,xacrsv.receipt_amount_original                        as attribute1
            ,null                                                  as attribute2
            ,null                                                  as attribute3
            --
            ,null                                           as overflow_sequence
            ,null                                              as invoice_number
            ,null                                               as matching_date
            ,null                                             as amount_to_apply
            ,null                                       as invoice_currency_code
            ,null                                       as trans_to_receipt_rate
            ,null                                          as exchange_gain_loss
            --
            ,ceba.bank_account_num                           as bank_account_num
        FROM
--             xxmx_fusion_lockbox_details                  xfld
             xxmx_ar_cash_receipts_scope_v                xacrsv
            ,apps.ar_cash_receipts_all@XXMX_EXTRACT       acra
            ,apps.ar_receipt_methods@XXMX_EXTRACT           arrm
            ,ce_bank_acct_uses_all@XXMX_EXTRACT             cebaua
            ,ce_bank_accounts@XXMX_EXTRACT                  ceba
        WHERE     1=1
        AND       arrm.receipt_method_id                  = acra.receipt_method_id
        AND       cebaua.bank_acct_use_id                 = acra.remit_bank_acct_use_id
        AND       ceba.bank_account_id                    = cebaua.bank_account_id
--        AND       xfld.bu_name(+)                         = xacrsv.operating_unit_name
--        AND       xfld.receipt_method(+)                  = arrm.name
--        AND       xfld.bank_origination_number(+)         = ceba.bank_account_num
        and       xacrsv.migrated_receipt_type            = 'Unidentified' 
        AND       nvl(xacrsv.receipt_amount_remaining,0)  <> 0
        AND       acra.org_id                             = xacrsv.org_id
        AND       acra.cash_receipt_id                    = xacrsv.cash_receipt_id
        ;
        --
        gvv_ProgressIndicator := 'S-006';
        xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gct_BusinessEntity
                    ,pt_i_SubEntity           => pt_i_SubEntity
                    ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_PackageName         => gct_PackageName
                    ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                    ,pt_i_Severity            => 'NOTIFICATION'
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => SQL%rowcount||' rows inserted into "'||ct_StgTable
                    ,pt_i_OracleError         => NULL
                    );

        gvv_ProgressIndicator := 'S-007';
        COMMIT;
        -- ------------------------------------------------------------------ --
        -- --------- FOR CITCO ONLY: Remove IC (internal customers) --------- --
        -- ------------------------------------------------------------------ --
        gvv_ProgressIndicator := 'S-008';
        delete from xxmx_ar_cash_receipts_stg
            where customer_number in
            (select account_number from xxmx_hz_cust_accounts_stg where customer_type='I');

/*
--Following delete added by Milind 18-SEP-2023 to remove receipts for CLOSER_AR
        delete from xxmx_ar_cash_receipts_stg s
            where not exists  (select null from xxmx_ppm_migrated_open_receipts o  where o.invoice_number = s.invoice_number );

        delete from xxmx_ar_cash_receipts_stg s
            where s.invoice_number not in (select o.invoice_number from xxmx_ppm_migrated_open_receipts o where o.invoice_number is not null)
            and s.invoice_number is not null;  
*/
        xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gct_BusinessEntity
                    ,pt_i_SubEntity           => pt_i_SubEntity
                    ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_PackageName         => gct_PackageName
                    ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                    ,pt_i_Severity            => 'NOTIFICATION'
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => SQL%rowcount||' rows delete from "'||ct_StgTable||' - IC'
                    ,pt_i_OracleError         => NULL
                    );
        -- ------------------------------------------------------------------ --
        -- ------- FOR CITCO ONLY: Remove Receipts before cutoff date ------- --
        -- ------------------------------------------------------------------ --
        -- NOTE-009
        -- delete any receipts where the receipt date is after the cut off date
        --
        gvv_ProgressIndicator := 'S-009';
        v_cut_off_date := XXMX_UTILITIES_PKG.get_single_parameter_value
            (
             pt_i_ApplicationSuite           => 'FIN'
            ,pt_i_Application                => 'AR'
            ,pt_i_BusinessEntity             => 'ALL'
            ,pt_i_SubEntity                  => 'ALL'
            ,pt_i_ParameterCode              => 'CUT_OFF_DATE'
            );        
        if v_cut_off_date is not null then
            v_cut_off_date_conv := to_date(v_cut_off_date,'DD-MON-YYYY');
            delete from xxmx_ar_cash_receipts_stg
                where receipt_date > v_cut_off_date_conv;   --Milind changed greater than equal to just greater than as it is 31-MAY-2023.
            xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gct_BusinessEntity
                    ,pt_i_SubEntity           => pt_i_SubEntity
                    ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_PackageName         => gct_PackageName
                    ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                    ,pt_i_Severity            => 'NOTIFICATION'
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => SQL%rowcount||' rows delete from "'||ct_StgTable||' - CUT-OFF-DATE='||v_cut_off_date
                    ,pt_i_OracleError         => NULL
                    );
        end if;
        --
--rm10102023
--      -- ---------------------------------------------------------- --
        -- --------- FOR CITCO ONLY: Remove Closed Receipts --------- --
        -- ---------------------------------------------------------- --
        gvv_ProgressIndicator := 'S-010';
/*        DELETE FROM xxmx_ar_cash_receipts_stg 
        WHERE cash_receipt_id IN
                                (SELECT arra.cash_receipt_id 
                                   FROM ar.ar_receivable_applications_all@XXMX_EXTRACT    arra
                                       ,ar_payment_schedules_all@XXMX_EXTRACT          arpsa
                                  WHERE 1=1
                                    AND arra.payment_schedule_id       = arpsa.payment_schedule_id
                                    AND arpsa.status                   ='CL'
                                    and arra.cash_receipt_id = arpsa.cash_receipt_id); */

        UPDATE xxmx_ar_cash_receipts_stg 
           set remittance_amount = amount_applied
        WHERE  remittance_amount = 0
        AND    amount_applied  > 0;

        xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gct_BusinessEntity
                    ,pt_i_SubEntity           => pt_i_SubEntity
                    ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_PackageName         => gct_PackageName
                    ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                    ,pt_i_Severity            => 'NOTIFICATION'
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => SQL%rowcount||' rows delete from "'||ct_StgTable||' - Closed Receipts'
                    ,pt_i_OracleError         => NULL
                    );
--rm10102023        
        gvv_ProgressIndicator := '0-010';
        gvn_RowCount := xxmx_utilities_pkg.get_row_count
                                    (
                                     gct_StgSchema
                                    ,ct_StgTable
                                    ,pt_i_MigrationSetID
                                    );
        --
        xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gct_BusinessEntity
                    ,pt_i_SubEntity           => pt_i_SubEntity
                    ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_PackageName         => gct_PackageName
                    ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                    ,pt_i_Severity            => 'NOTIFICATION'
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => gvn_RowCount||' rows inserted into "'||ct_StgTable||'".'
                    ,pt_i_OracleError         => NULL
                    );
        gvv_ProgressIndicator := '0-011';
        --
        gvv_ProgressIndicator := '0-015';
        xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gct_BusinessEntity
                    ,pt_i_SubEntity           => pt_i_SubEntity
                    ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_PackageName         => gct_PackageName
                    ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                    ,pt_i_Severity            => 'NOTIFICATION'
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => 'Extraction complete.'
                    ,pt_i_OracleError         => NULL
                    );
        --
        -- Update the migration details (Migration status will be automatically determined
        -- in the called procedure dependant on the Phase and if an Error Message has been
        -- passed).
        --
        gvv_ProgressIndicator := '0-016';
        xxmx_utilities_pkg.upd_migration_details
                    (
                     pt_i_MigrationSetID          => pt_i_MigrationSetID
                    ,pt_i_BusinessEntity          => gct_BusinessEntity
                    ,pt_i_SubEntity               => pt_i_SubEntity
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
        gvv_ProgressIndicator := '0-017';
        xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gct_BusinessEntity
                    ,pt_i_SubEntity           => pt_i_SubEntity
                    ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_PackageName         => gct_PackageName
                    ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                    ,pt_i_Severity               => 'NOTIFICATION'
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => 'Migration Table "'||ct_StgTable||'" reporting details updated.'
                    ,pt_i_OracleError         => NULL
                    );
        --
    else
        --
        gvt_Severity      := 'ERROR';
        gvt_ModuleMessage := '- Migration Set not initialized.';
        RAISE e_ModuleError;
    end if;
    --
    gvv_ProgressIndicator := '0-018';
    xxmx_utilities_pkg.log_module_message
               (
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gct_BusinessEntity
                    ,pt_i_SubEntity           => pt_i_SubEntity
                    ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_PackageName         => gct_PackageName
                    ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                    ,pt_i_Severity               => 'NOTIFICATION'
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => 'Procedure "'||gct_PackageName||'.'||ct_ProcOrFuncName||'" completed.'
                    ,pt_i_OracleError         => NULL
               );
    --
EXCEPTION
    WHEN e_ModuleError then
        ROLLBACK;
        xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite    => gct_ApplicationSuite
                         ,pt_i_Application         => gct_Application
                         ,pt_i_BusinessEntity      => gct_BusinessEntity
                         ,pt_i_SubEntity           => pt_i_SubEntity
                         ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                         ,pt_i_Phase               => ct_Phase
                         ,pt_i_PackageName         => gct_PackageName
                         ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                         ,pt_i_Severity            => gvt_Severity
                         ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage       => gvt_ModuleMessage
                         ,pt_i_OracleError         => NULL
                         );
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
    WHEN OTHERS then
        ROLLBACK;
        gvt_OracleError := SUBSTR(SQLERRM||'** ERROR_BACKTRACE: '||dbms_utility.format_error_backtrace,1,4000);
        --
        xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite    => gct_ApplicationSuite
                         ,pt_i_Application         => gct_Application
                         ,pt_i_BusinessEntity      => gct_BusinessEntity
                         ,pt_i_SubEntity           => pt_i_SubEntity
                         ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                         ,pt_i_Phase               => ct_Phase
                         ,pt_i_PackageName         => gct_PackageName
                         ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                         ,pt_i_Severity            => 'ERROR'
                         ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage       => 'Oracle error encounted at after Progress Indicator.'
                         ,pt_i_OracleError         => gvt_OracleError
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
        RAISE_APPLICATION_ERROR(xxmx_utilities_pkg.gcn_ApplicationErrorNumber, gvv_ApplicationErrorMessage);
    --
end ar_original_cash_receipts_stg;
-- -------------------------------------------------------------------------- --
-- TRANSFORM Cash Receipts
-- -------------------------------------------------------------------------- --
PROCEDURE ar_original_cash_receipts_xfm
(
    pt_i_ApplicationSuite       in varchar2,
    pt_i_Application            in varchar2,
    pt_i_BusinessEntity         in varchar2,
    pt_i_StgPopulationMethod    in varchar2,
    pt_i_FileSetID              in varchar2,
    pt_i_MigrationSetID         in number,
    pv_o_ReturnStatus           out varchar2
)
is
        ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'ar_cash_receipts_xfm';
        ct_Phase                        CONSTANT  xxmx_module_messages.phase%TYPE             := 'TRANSFORM';
        ct_StgTable                     CONSTANT  xxmx_migration_metadata.stg_table%TYPE      := 'xxmx_ar_cash_receipts_xfm';
        v_sql                           varchar2(3000);
    -- The following condition is to eliminate invoices that have not been migrated
    cursor c_adj_receipt is
        select *
        from xxmx_ar_cash_receipts_xfm STG
        where STG.attribute2 is not null
        and not exists
        (
            select 1 
                from xxmx_ppm_migrated_open_receipts PPM
                where PPM.invoice_number = STG.attribute2
        );
    cursor c_overflow_seq is
        select 
            'update xxmx_ar_cash_receipts_xfm set overflow_sequence='||
            row_number() over 
                (
                    partition by receipt_number 
                    order by receipt_number
                )||' where receipt_number='''||receipt_number||''' and invoice_number='''||invoice_number||'''' as update_stmt
        from    xxmx_ar_cash_receipts_xfm X
        where   X.record_type       = 4;
begin
    --
    gvv_ProgressIndicator := '001';
    xxmx_utilities_pkg.log_module_message
               (
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gct_BusinessEntity
                    ,pt_i_SubEntity           => null
                    ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_PackageName         => gct_PackageName
                    ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                    ,pt_i_Severity               => 'NOTIFICATION'
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => 'START: Procedure "'||gct_PackageName||'.'||ct_ProcOrFuncName
                    ,pt_i_OracleError         => NULL
               );
    gvv_ProgressIndicator := '002';

DELETE from xxmx_xfm.xxmx_ar_cash_receipts_xfm x WHERE REMITTANCE_AMOUNT <= 0;  --Milind added on 11-MAR-2024 to exclude credit and negative receipts.

--Remove following DELETE after UAT, only excluding bad data identified by Rebecca.
/*    DELETE from xxmx_xfm.xxmx_ar_cash_receipts_xfm x 
    where x.cash_receipt_id in (
    '1251399',
'1797659',
'1714976',
'1061310',
'1061310',
'1106311',
'1106311',
'4247883',
'4247883',
'2534522',
'4707246',
'512930',
'4707246',
'4913008',
'803804',
'1266409',
'803804',
'1266409',
'813847',
'1731487',
'1731487',
'4247883',
'4247883',
'4707246',
'4707246',
'1731487'
);
 */

    UPDATE xxmx_xfm.xxmx_ar_cash_receipts_xfm x 
               set x.operating_unit_name = nvl((select xmm.output_code_1
                                    from xxmx_mapping_master xmm
                                     WHERE
                                           xmm.application     = 'PPM'
					                   AND xmm.category_code   = 'BUSINESS_UNIT'
                                       AND upper(xmm.input_code_1) = upper(x.operating_unit_name) 
                                       AND ROWNUM = 1
                                       ),x.operating_unit_name)
     ;    

--Milind added new mapping for customer site number from TCA XFM tables. JIRA 27042
    UPDATE xxmx_xfm.xxmx_ar_cash_receipts_xfm x 
               set x.BILL_TO_LOCATION = nvl((select (m.LOCATION) 
                                             from xxmx_xfm.XXMX_HZ_CUST_SITE_USES_XFM m 
                                             where m.site_use_code = 'BILL_TO' 
                                             and m.ATTRIBUTE29 = x.BILL_TO_LOCATION 
                                             and ROWNUM = 1
                                             ),x.BILL_TO_LOCATION)
     ;    



    update xxmx_xfm.xxmx_ar_cash_receipts_xfm XFM
        set
            XFM.lockbox_number              =
            (
                select      lockbox_number
                from        xxmx_fusion_lockbox_details FUSION
                where       FUSION.bu_name                         = XFM.operating_unit_name
                and         FUSION.receipt_method                  = XFM.receipt_method
                and         FUSION.bank_origination_number         = XFM.bank_account_num
            )
    ;

    xxmx_utilities_pkg.log_module_message
               (
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gct_BusinessEntity
                    ,pt_i_SubEntity           => null
                    ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_PackageName         => gct_PackageName
                    ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                    ,pt_i_Severity               => 'NOTIFICATION'
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => 'LOCKBOX number updated: '||to_char(SQL%rowcount)
                    ,pt_i_OracleError         => NULL
               );
    gvv_ProgressIndicator := '003';
    update xxmx_xfm.xxmx_ar_cash_receipts_xfm XFM
        set
            batch_name                  = 'BATCH'||to_char(migration_set_id)||'-'||
                substr(XFM.lockbox_number,1,15),
            remittance_amount_disp      = XFM.remittance_amount*100,
            receipt_date_format         = to_char(XFM.receipt_date,'YYMMDD'),
            anticipated_clear_date_format = to_char(XFM.anticipated_clear_date,'YYMMDD'),
            amount_applied_disp         = to_char(XFM.amount_applied*100),
            deposit_date_format         = to_char(XFM.deposit_date,'YYMMDD'),
            matching_date_format        = to_char(XFM.matching_date,'YYMMDD')
    ;

    xxmx_utilities_pkg.log_module_message
               (
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gct_BusinessEntity
                    ,pt_i_SubEntity           => null
                    ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_PackageName         => gct_PackageName
                    ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                    ,pt_i_Severity               => 'NOTIFICATION'
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => 'FORMATED COLUMNS updated: '||to_char(SQL%rowcount)
                    ,pt_i_OracleError         => NULL
               );
    -- ------------------------------------------------------------------ --
    -- FOR CITCO ONLY: Remove invoices that have not been migrated using PPM table with open receipts.
    -- ------------------------------------------------------------------ --
    gvv_ProgressIndicator := '003';
    for r_adj_receipt in c_adj_receipt loop
            gvv_ProgressIndicator := '003-1';
            xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gct_BusinessEntity
                    ,pt_i_SubEntity           => null
                    ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_PackageName         => gct_PackageName
                    ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                    ,pt_i_Severity            => 'NOTIFICATION'
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => 'Adjusting RECEIPT '||r_adj_receipt.receipt_number||' Removing INVOICE '||r_adj_receipt.invoice_number
                    ,pt_i_OracleError         => NULL
                    );
            gvv_ProgressIndicator := '003-2';
            update xxmx_xfm.xxmx_ar_cash_receipts_xfm U
                set 
                    U.remittance_amount        = U.remittance_amount-r_adj_receipt.amount_applied,
                    U.remittance_amount_disp   = (U.remittance_amount-r_adj_receipt.amount_applied)*100
                where U.receipt_number = r_adj_receipt.receipt_number;
            gvv_ProgressIndicator := '003-3';
            update xxmx_xfm.xxmx_ar_cash_receipts_xfm U
                set
                    attribute2              = invoice_number,
                    attribute3              = amount_applied,
                    invoice_number          = null,
                    invoice_installment     = null,
                    matching_date           = null,
                    matching_date_format    = null,
                    invoice_currency_code   = null,  
                    trans_to_receipt_rate   = null,
                    amount_applied          = null,
                    amount_applied_disp     = null,
                    amount_applied_from     = null,
                    customer_reference      = null,
                    exchange_gain_loss      = null
                where U.receipt_number = r_adj_receipt.receipt_number
                and   U.invoice_number = r_adj_receipt.invoice_number;
        end loop;
        commit;
        --
        --
        gvv_ProgressIndicator := '004';
        delete from xxmx_ar_cash_receipts_xfm DEL
        where exists
        (
                select  XFM.receipt_number,sum(nvl(XFM.amount_applied,0))
                from    xxmx_ar_cash_receipts_xfm XFM
                where   XFM.migrated_receipt_type = 'Partially Applied'
                and     XFM.invoice_number is null
                and     XFM.record_type = 4
                and     XFM.receipt_number  = DEL.receipt_number
                group by XFM.receipt_number
                having sum(nvl(XFM.amount_applied,0))=0
        )
        and     DEL.migrated_receipt_type = 'Partially Applied'
        and     DEL.invoice_number is null
        and     DEL.record_type = 4
        ;
        gvv_ProgressIndicator := '005';
        for r_overflow_seq in c_overflow_seq loop
            v_sql := r_overflow_seq.update_stmt;
            execute immediate v_sql;
        end loop;
        --
        gvv_ProgressIndicator := '006';
        update xxmx_xfm.xxmx_ar_cash_receipts_xfm u
            set
                u.attribute2=null,
                u.attribute3=null
            ;
        --
        gvv_ProgressIndicator := '007';
        update xxmx_xfm.xxmx_ar_cash_receipts_xfm u
            set
                u.item_number=ROWNUM
            where u.record_type =6
            ;
        gvv_ProgressIndicator := '008';
        update xxmx_xfm.xxmx_ar_cash_receipts_xfm u
            set
                u.item_number=(select x.item_number from xxmx_xfm.xxmx_ar_cash_receipts_xfm x 
                               where x.receipt_number=u.receipt_number and x.record_type=6 and rownum < 2)
            where u.record_type =4
            ;
        gvv_ProgressIndicator := '009';
        update xxmx_xfm.xxmx_ar_cash_receipts_xfm
            set
                overflow_indicator = decode(overflow_sequence,null,null,0)
            ;
        gvv_ProgressIndicator := '010';
        update xxmx_xfm.xxmx_ar_cash_receipts_xfm u
            set
                u.overflow_indicator = 9
            where u.overflow_sequence = (select max(overflow_sequence) from xxmx_stg.xxmx_ar_cash_receipts_stg x where x.cash_receipt_id=u.cash_receipt_id)
            ;
/*
        delete from xxmx_ar_cash_receipts_xfm 
        where MIGRATED_RECEIPT_TYPE in ('On-Account','Unapplied','Unidentified')
        and invoice_number is not null;

        delete from xxmx_ar_cash_receipts_xfm d
            where d.MIGRATED_RECEIPT_TYPE in ('On-Account','Unapplied')
              and d.rowid not in (select min(m.rowid) 
                                from xxmx_ar_cash_receipts_xfm m
                                where m.MIGRATED_RECEIPT_TYPE in ('On-Account','Unapplied')
                                group by m.RECEIPT_NUMBER
                                having count(1) > 1)
              and exists       (select null
                                from xxmx_ar_cash_receipts_xfm e
                                where e.MIGRATED_RECEIPT_TYPE in ('On-Account','Unapplied')
                                and e.RECEIPT_NUMBER = d.RECEIPT_NUMBER
                                group by e.RECEIPT_NUMBER
                                having count(1) > 1);
*/
        --
        commit;
        --
end ar_original_cash_receipts_xfm;
-- -------------------------------------------------------------------------- --
-- STG_MAIN
-- -------------------------------------------------------------------------- --
PROCEDURE stg_main
                    (
                     pt_i_ClientCode                 IN      xxmx_client_config_parameters.client_code%TYPE
                    ,pt_i_MigrationSetName           IN      xxmx_migration_headers.migration_set_name%TYPE
                    )
     IS
          --
          --**********************
          --** Cursor Declarations
          --**********************
          --
          CURSOR StagingMetadata_cur
                      (
                       pt_ApplicationSuite             xxmx_migration_metadata.application_suite%TYPE
                      ,pt_Application                  xxmx_migration_metadata.application%TYPE
                      ,pt_BusinessEntity               xxmx_migration_metadata.business_entity%TYPE
                      )
          IS
               --
               SELECT  xmm.sub_entity_seq
                      ,xmm.sub_entity
                      ,xmm.entity_package_name
                      ,xmm.stg_procedure_name
                      ,xmm.stg_table
               FROM    xxmx_migration_metadata  xmm
               WHERE   1 = 1
               AND     xmm.application_suite = pt_ApplicationSuite
               AND     xmm.application       = pt_Application
               AND     xmm.business_entity   = pt_BusinessEntity
               ORDER BY xmm.sub_entity_seq;
               --
          --** END CURSOR StagingMetadata_cur
          --
          --**********************
          --** Record Declarations
          --**********************
          --
          --
          --************************
          --** Constant Declarations
          --************************
          --
          ct_ProcOrFuncName               CONSTANT  VARCHAR2(30)                          := 'stg_main';
          ct_SubEntity                    CONSTANT  xxmx_module_messages.sub_entity%TYPE  := 'ALL';
          ct_Phase                        CONSTANT  xxmx_module_messages.phase%TYPE       := 'EXTRACT';
          --
          --************************
          --** Variable Declarations
          --************************
          --
          vt_ConfigParameter              xxmx_client_config_parameters.config_parameter%TYPE;
          vt_MigrationSetID               xxmx_migration_headers.migration_set_id%TYPE;
          --
          --*************************
          --** Exception Declarations
          --*************************
          --
          --** Set gvt_Severity, gvv_ProgressIndicator and gvt_ModuleMessage
          --** before raising this exception.
          --
          e_ModuleError                   EXCEPTION;
          --
     --** END Declarations **
     --
BEGIN
    --
    gvv_ProgressIndicator := 'M-0010';
    if pt_i_ClientCode IS NULL then
        gvt_Severity      := 'ERROR';
        gvt_ModuleMessage := '- "pt_i_ClientCode" parameter is mandatory.';
        RAISE e_ModuleError;
    end if;
    --
    gvv_ProgressIndicator := 'M-0020';
    gvv_ReturnStatus  := '';
    xxmx_utilities_pkg.clear_messages
               (
                pt_i_ApplicationSuite    => gct_ApplicationSuite
               ,pt_i_Application         => gct_Application
               ,pt_i_BusinessEntity      => gct_BusinessEntity
               ,pt_i_SubEntity           => ct_SubEntity
               ,pt_i_Phase               => ct_Phase
               ,pt_i_MessageType         => 'MODULE'
               ,pv_o_ReturnStatus        => gvv_ReturnStatus
               );
    --
    IF gvv_ReturnStatus = 'F' then
        xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gct_BusinessEntity
                    ,pt_i_SubEntity           => ct_SubEntity
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_Severity            => 'ERROR'
                    ,pt_i_PackageName         => gct_PackageName
                    ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => '- Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
                    ,pt_i_OracleError         => gvt_ReturnMessage
                    );
               --
        RAISE e_ModuleError;
    end if;
    --
    gvv_ProgressIndicator := 'M-0030';
    xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite    => gct_ApplicationSuite
               ,pt_i_Application         => gct_Application
               ,pt_i_BusinessEntity      => gct_BusinessEntity
               ,pt_i_SubEntity           => ct_SubEntity
               ,pt_i_Phase               => ct_Phase
               ,pt_i_Severity            => 'NOTIFICATION'
               ,pt_i_PackageName         => gct_PackageName
               ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
               ,pt_i_ModuleMessage       => 'Procedure "'||gct_PackageName||'.'||ct_ProcOrFuncName||'" initiated.'
               ,pt_i_OracleError         => NULL
               );
    --
    gvv_ProgressIndicator := 'M-0040';
    xxmx_utilities_pkg.init_migration_set
               (
                pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => gct_BusinessEntity
               ,pt_i_MigrationSetName  => pt_i_MigrationSetName
               ,pt_o_MigrationSetID    => vt_MigrationSetID
               );
    xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite    => gct_ApplicationSuite
               ,pt_i_Application         => gct_Application
               ,pt_i_BusinessEntity      => gct_BusinessEntity
               ,pt_i_SubEntity           => ct_SubEntity
               ,pt_i_MigrationSetID      => vt_MigrationSetID
               ,pt_i_Phase               => ct_Phase
               ,pt_i_Severity            => 'NOTIFICATION'
               ,pt_i_PackageName         => gct_PackageName
               ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
               ,pt_i_ModuleMessage       => 'Migration Set "'||pt_i_MigrationSetName||'" initialized (Generated Migration Set ID = '||vt_MigrationSetID||').  Processing extracts:'
               ,pt_i_OracleError         => NULL
               );
    --
    -- Loop through the Migration Metadata table to retrieve the Staging Package Name, Procedure Name and table name
    -- for each extract requied for the current Business Entity. 
    gvv_ProgressIndicator := 'M-0050';
    FOR StagingMetadata_rec IN StagingMetadata_cur
                    (
                     gct_ApplicationSuite
                    ,gct_Application
                    ,gct_BusinessEntity
                    )
    LOOP
        --
        xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gct_BusinessEntity
                    ,pt_i_SubEntity           => ct_SubEntity
                    ,pt_i_MigrationSetID      => vt_MigrationSetID
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_Severity            => 'NOTIFICATION'
                    ,pt_i_PackageName         => gct_PackageName
                    ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => 'Calling Procedure "'||StagingMetadata_rec.entity_package_name||'.'||StagingMetadata_rec.stg_procedure_name||'".'
                    ,pt_i_OracleError         => NULL
                    );
        --
        gvv_SQLStatement := 'BEGIN '
                                 ||StagingMetadata_rec.entity_package_name
                                 ||'.'
                                 ||StagingMetadata_rec.stg_procedure_name
                                 ||gcv_SQLSpace
                                 ||'('
                                 ||'pt_i_MigrationSetID => '
                                 ||vt_MigrationSetID
                                 ||',pt_i_SubEntity => '''
                                 ||StagingMetadata_rec.sub_entity||''''
                                 ||'); end;';
        --
        xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gct_BusinessEntity
                    ,pt_i_SubEntity           => ct_SubEntity
                    ,pt_i_MigrationSetID      => vt_MigrationSetID
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_Severity            => 'NOTIFICATION'
                    ,pt_i_PackageName         => gct_PackageName
                    ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => SUBSTR('- Generated SQL Statement: '||gvv_SQLStatement,1,4000)
                    ,pt_i_OracleError         => NULL
                    );
        --
        EXECUTE IMMEDIATE gvv_SQLStatement;
    end loop;
    --
    gvv_ProgressIndicator := 'M-0060';
    COMMIT;
    --
    xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite    => gct_ApplicationSuite
               ,pt_i_Application         => gct_Application
               ,pt_i_BusinessEntity      => gct_BusinessEntity
               ,pt_i_SubEntity           => ct_SubEntity
               ,pt_i_MigrationSetID      => vt_MigrationSetID
               ,pt_i_Phase               => ct_Phase
               ,pt_i_Severity            => 'NOTIFICATION'
               ,pt_i_PackageName         => gct_PackageName
               ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
               ,pt_i_ModuleMessage       => 'Procedure "'||gct_PackageName||'.'||ct_ProcOrFuncName||'" completed.'
               ,pt_i_OracleError         => NULL
               );
          --
EXCEPTION
               --
               WHEN e_ModuleError
               then
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite    => gct_ApplicationSuite
                         ,pt_i_Application         => gct_Application
                         ,pt_i_BusinessEntity      => gct_BusinessEntity
                         ,pt_i_SubEntity           => ct_SubEntity
                         ,pt_i_Phase               => ct_Phase
                         ,pt_i_Severity            => gvt_Severity
                         ,pt_i_PackageName         => gct_PackageName
                         ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage       => gvt_ModuleMessage
                         ,pt_i_OracleError         => NULL
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
               then
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
                          pt_i_ApplicationSuite    => gct_ApplicationSuite
                         ,pt_i_Application         => gct_Application
                         ,pt_i_BusinessEntity      => gct_BusinessEntity
                         ,pt_i_SubEntity           => ct_SubEntity
                         ,pt_i_Phase               => ct_Phase
                         ,pt_i_MigrationSetID      => vt_MigrationSetID
                         ,pt_i_Severity            => 'ERROR'
                         ,pt_i_PackageName         => gct_PackageName
                         ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage       => 'Oracle error encounted after Progress Indicator.'
                         ,pt_i_OracleError         => gvt_OracleError
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
END stg_main;
-- -------------------------------------------------------------------------- --
-- PURGE
-- -------------------------------------------------------------------------- --
PROCEDURE purge
                   (
                    pt_i_ClientCode                 IN      xxmx_client_config_parameters.client_code%TYPE
                   ,pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                   )
IS
          --
          --
          --**********************
          --** Cursor Declarations
          --**********************
          --
          CURSOR PurgingMetadata_cur
                      (
                       pt_ApplicationSuite             xxmx_migration_metadata.application_suite%TYPE
                      ,pt_Application                  xxmx_migration_metadata.application%TYPE
                      ,pt_BusinessEntity               xxmx_migration_metadata.business_entity%TYPE
                      )
          IS
               --
               --
               SELECT  xmm.stg_table
                      ,xmm.xfm_table
               FROM    xxmx_migration_metadata  xmm
               WHERE   1 = 1
               AND     xmm.application_suite = pt_ApplicationSuite
               AND     xmm.application       = pt_Application
               AND     xmm.business_entity   = pt_BusinessEntity
               ORDER BY xmm.sub_entity_seq;
               --
               --
          --** END CURSOR PurgingMetadata_cur
          --
          --**********************
          --** Record Declarations
          --**********************
          --
          --
          --************************
          --** Constant Declarations
          --************************
          --
          ct_ProcOrFuncName               CONSTANT  VARCHAR2(30)                         := 'purge';
          ct_SubEntity                    CONSTANT  xxmx_module_messages.sub_entity%TYPE := 'ALL';
          ct_Phase                        CONSTANT  xxmx_module_messages.phase%TYPE      := 'CORE';
          --
          --************************
          --** Variable Declarations
          --************************
          --
          vt_ConfigParameter              xxmx_client_config_parameters.config_parameter%TYPE;
          vv_PurgeTableName               VARCHAR2(30);
          --
          --*************************
          --** Exception Declarations
          --*************************
          --
          --** Set gvt_Severity, gvv_ProgressIndicator and gvt_ModuleMessage
          --** before raising this exception.
          --
          e_ModuleError                   EXCEPTION;
          --
          --
     --** END Declarations **
     --
     --
     BEGIN
          --
          gvv_ProgressIndicator := '0010';
          --
          IF   pt_i_ClientCode     IS NULL
          OR   pt_i_MigrationSetID IS NULL
          then
               --
               gvt_Severity      := 'ERROR';
               gvt_ModuleMessage := '- "pt_i_ClientCode" and "pt_i_MigrationSetName" parameters are mandatory.';
               --
               RAISE e_ModuleError;
               --
          end if;
           --
          gvv_ReturnStatus  := '';
          gvt_ReturnMessage := '';
          --
          xxmx_utilities_pkg.clear_messages
               (
                pt_i_ApplicationSuite    => gct_ApplicationSuite
               ,pt_i_Application         => gct_Application
               ,pt_i_BusinessEntity      => gct_BusinessEntity
               ,pt_i_SubEntity           => ct_SubEntity
               ,pt_i_Phase               => ct_Phase
               ,pt_i_MessageType         => 'MODULE'
               ,pv_o_ReturnStatus        => gvv_ReturnStatus
               );
          --
          IF   gvv_ReturnStatus = 'F'
          then
               --
               gvt_Severity      := 'ERROR';
               --
               gvt_ModuleMessage := '- Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".';
               --
               RAISE e_ModuleError;
               --
          end if;
          --
          gvv_ProgressIndicator := '0020';
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite    => gct_ApplicationSuite
               ,pt_i_Application         => gct_Application
               ,pt_i_BusinessEntity      => gct_BusinessEntity
               ,pt_i_SubEntity           => ct_SubEntity
               ,pt_i_MigrationSetID      => pt_i_MigrationSetID
               ,pt_i_Phase               => ct_Phase
               ,pt_i_Severity            => 'NOTIFICATION'
               ,pt_i_PackageName         => gct_PackageName
               ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
               ,pt_i_ModuleMessage       => 'Procedure "'
                                          ||gct_PackageName
                                          ||'.'
                                          ||ct_ProcOrFuncName
                                          ||'" initiated.'
               ,pt_i_OracleError         => NULL
               );
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => gct_BusinessEntity
               ,pt_i_SubEntity         => ct_SubEntity
               ,pt_i_MigrationSetID    => pt_i_MigrationSetID
               ,pt_i_Phase             => ct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gct_PackageName
               ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => '- Purging tables.'
               ,pt_i_OracleError       => NULL
               );
          --
          gvv_ProgressIndicator := '0040';
          --
          /*
          ** Loop through the Migration Metadata table to retrieve
          ** the staging table names to purge for the current Business
          ** Entity.
          */
          --
          gvv_SQLAction := 'DELETE';
          --
          gvv_SQLWhereClause := 'WHERE 1 = 1 '
                              ||'AND   migration_set_id = '
                              ||pt_i_MigrationSetID;
          --
          FOR  PurgingMetadata_rec
          IN   PurgingMetadata_cur
                    (
                     gct_ApplicationSuite
                    ,gct_Application
                    ,gct_BusinessEntity
                    )
          LOOP
               --
               gvv_SQLTableClause := 'FROM '
                                   ||gct_StgSchema
                                   ||'.'
                                   ||PurgingMetadata_rec.stg_table;
               --
               gvv_SQLStatement := gvv_SQLAction
                                 ||gcv_SQLSpace
                                 ||gvv_SQLTableClause
                                 ||gcv_SQLSpace
                                 ||gvv_SQLWhereClause;
               --
               --
               EXECUTE IMMEDIATE gvv_SQLStatement;
               --
               gvn_RowCount := SQL%ROWCOUNT;
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gct_BusinessEntity
                    ,pt_i_SubEntity           => ct_SubEntity
                    ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_Severity            => 'NOTIFICATION'
                    ,pt_i_PackageName         => gct_PackageName
                    ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => '  - Records purged from "'
                                               ||PurgingMetadata_rec.stg_table
                                               ||'" table: '
                                               ||gvn_RowCount
                    ,pt_i_OracleError         => NULL
                    );
               --
               --gvv_SQLTableClause := 'FROM '
               --                    ||vt_ClientSchemaName
               --                    ||'.'
               --                    ||PurgingMetadata_rec.xfm_table;
               ----
               --gvv_SQLStatement := gvv_SQLAction
               --                  ||gcv_SQLSpace
               --                  ||gvv_SQLTableClause
               --                  ||gcv_SQLSpace
               --                  ||gvv_SQLWhereClause;
               ----
               --EXECUTE IMMEDIATE gvv_SQLStatement;
               ----
               --gvn_RowCount := SQL%ROWCOUNT;
               ----
               --xxmx_utilities_pkg.log_module_message
               --     (
               --      pt_i_ApplicationSuite    => gct_ApplicationSuite
               --     ,pt_i_Application         => gct_Application
               --     ,pt_i_BusinessEntity      => gct_BusinessEntity
               --     ,pt_i_SubEntity           => ct_SubEntity
               --     ,pt_i_MigrationSetID      => pt_i_MigrationSetID
               --     ,pt_i_Phase               => ct_Phase
               --     ,pt_i_Severity            => 'NOTIFICATION'
               --     ,pt_i_PackageName         => gct_PackageName
               --     ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
               --     ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
               --     ,pt_i_ModuleMessage       => '  - Records purged from "'
               --                                ||PurgingMetadata_rec.xfm_table
               --                                ||'" table: '
               --                                ||gvn_RowCount
               --     ,pt_i_OracleError         => NULL
               --     );
               --
          end loop;
          --
          /*
          ** Purge the records for the Business Entity Levels
          ** Levels from the Migration Details table.
          */
          --
          vv_PurgeTableName := 'xxmx_migration_details';
          --
          --
          --** DSF 26/10/2020 - Replace with new constant for Core Schema.
          --
          gvv_SQLTableClause := 'FROM '
                              ||gct_CoreSchema
                              ||'.'
                              ||vv_PurgeTableName;
          --
          gvv_SQLStatement := gvv_SQLAction
                            ||gcv_SQLSpace
                            ||gvv_SQLTableClause
                            ||gcv_SQLSpace
                            ||gvv_SQLWhereClause;
          --
          EXECUTE IMMEDIATE gvv_SQLStatement;
          --
          gvn_RowCount := SQL%ROWCOUNT;
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite    => gct_ApplicationSuite
               ,pt_i_Application         => gct_Application
               ,pt_i_BusinessEntity      => gct_BusinessEntity
               ,pt_i_SubEntity           => ct_SubEntity
               ,pt_i_MigrationSetID      => pt_i_MigrationSetID
               ,pt_i_Phase               => ct_Phase
               ,pt_i_Severity            => 'NOTIFICATION'
               ,pt_i_PackageName         => gct_PackageName
               ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
               ,pt_i_ModuleMessage       => '  - Records purged from "'
                                          ||vv_PurgeTableName
                                          ||'" table: '
                                          ||gvn_RowCount
               ,pt_i_OracleError         => NULL
               );
          --
          /*
          ** Purge the records for the Business Entity
          ** from the Migration Headers table.
          */
          --
          --** DSF 261/10/2020 - Replace with new constant for Core Schema.
          --
          vv_PurgeTableName := 'xxmx_migration_headers';
          --
          gvv_SQLTableClause := 'FROM '
                              ||gct_CoreSchema
                              ||'.'
                              ||vv_PurgeTableName;
          --
          gvv_SQLStatement := gvv_SQLAction
                            ||gcv_SQLSpace
                            ||gvv_SQLTableClause
                            ||gcv_SQLSpace
                            ||gvv_SQLWhereClause;
          --
          EXECUTE IMMEDIATE gvv_SQLStatement;
          --
          gvn_RowCount := SQL%ROWCOUNT;
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite    => gct_ApplicationSuite
               ,pt_i_Application         => gct_Application
               ,pt_i_BusinessEntity      => gct_BusinessEntity
               ,pt_i_SubEntity           => ct_SubEntity
               ,pt_i_MigrationSetID      => pt_i_MigrationSetID
               ,pt_i_Phase               => ct_Phase
               ,pt_i_Severity            => 'NOTIFICATION'
               ,pt_i_PackageName         => gct_PackageName
               ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
               ,pt_i_ModuleMessage       => '  - Records purged from "'
                                          ||vv_PurgeTableName
                                          ||'" table: '
                                          ||gvn_RowCount
               ,pt_i_OracleError         => NULL
               );
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite    => gct_ApplicationSuite
               ,pt_i_Application         => gct_Application
               ,pt_i_BusinessEntity      => gct_BusinessEntity
               ,pt_i_SubEntity           => ct_SubEntity
               ,pt_i_MigrationSetID      => pt_i_MigrationSetID
               ,pt_i_Phase               => ct_Phase
               ,pt_i_Severity            => 'NOTIFICATION'
               ,pt_i_PackageName         => gct_PackageName
               ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
               ,pt_i_ModuleMessage       => '- Purging complete.'
               ,pt_i_OracleError         => NULL
               );
          --
          COMMIT;
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite    => gct_ApplicationSuite
               ,pt_i_Application         => gct_Application
               ,pt_i_BusinessEntity      => gct_BusinessEntity
               ,pt_i_SubEntity           => ct_SubEntity
               ,pt_i_MigrationSetID      => pt_i_MigrationSetID
               ,pt_i_Phase               => ct_Phase
               ,pt_i_Severity            => 'NOTIFICATION'
               ,pt_i_PackageName         => gct_PackageName
               ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
               ,pt_i_ModuleMessage       => 'Procedure "'
                                          ||gct_PackageName
                                          ||'.'
                                          ||ct_ProcOrFuncName
                                          ||'" completed.'
               ,pt_i_OracleError         => NULL
               );
          --
          EXCEPTION
               --
               WHEN e_ModuleError
               then
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite    => gct_ApplicationSuite
                         ,pt_i_Application         => gct_Application
                         ,pt_i_BusinessEntity      => gct_BusinessEntity
                         ,pt_i_SubEntity           => ct_SubEntity
                         ,pt_i_Phase               => ct_Phase
                         ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                         ,pt_i_Severity            => gvt_Severity
                         ,pt_i_PackageName         => gct_PackageName
                         ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage       => gvt_ModuleMessage
                         ,pt_i_OracleError         => NULL
                         );
                    --
                    RAISE;
                    --
               --** END e_ModuleError Exception
               --
               WHEN OTHERS
               then
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
                          pt_i_ApplicationSuite    => gct_ApplicationSuite
                         ,pt_i_Application         => gct_Application
                         ,pt_i_BusinessEntity      => gct_BusinessEntity
                         ,pt_i_SubEntity           => ct_SubEntity
                         ,pt_i_Phase               => ct_Phase
                         ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                         ,pt_i_Severity            => 'ERROR'
                         ,pt_i_PackageName         => gct_PackageName
                         ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage       => 'Oracle error encounted after Progress Indicator.'
                         ,pt_i_OracleError         => gvt_OracleError
                         );
                    --
                    RAISE;
                    --
               --** END OTHERS Exception
               --
          --** END Exception Handler
          --
end purge;
--
procedure generate_csv_file
    (
         pt_i_MigrationSetID            IN      xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_BusinessEntity            IN      xxmx_migration_metadata.business_entity%TYPE
        ,pt_i_FileName                  IN      xxmx_migration_metadata.data_file_name%TYPE
        ,pt_i_SubEntity                 IN      xxmx_migration_metadata.sub_entity%TYPE DEFAULT 'ALL'
    )
is
    cv_ProcOrFuncName           CONSTANT  VARCHAR2(30)   := 'generate_csv_file';
    cursor c_batch (pc_migration_set_id number) is
        select distinct batch_name
            from xxmx_ar_cash_receipts_xfm
            where   migration_set_id = pc_migration_set_id;
    cursor c_data (pc_migration_set_id number, pc_batch_name varchar2) is
        select *
            from xxmx_ar_cash_receipts_xfm
            where   migration_set_id = pc_migration_set_id
            and     batch_name       = pc_batch_name;
    v_line  varchar2(3000);
begin
-- check mandatory
    for r_batch in c_batch(pt_i_MigrationSetID) loop
        delete from xxmx_csv_file_temp where upper(file_name) = upper(r_batch.batch_name||'.csv');
        for r_data in c_data(pt_i_MigrationSetID, r_batch.batch_name) loop
            case r_data.record_type
                when 6 then
                    v_line := 
                        r_data.record_type||','||r_data.batch_name||','||r_data.item_number||','||r_data.remittance_amount_disp||','||
                        r_data.transit_routing_number||','||r_data.customer_bank_account||','||r_data.receipt_number||','||r_data.receipt_date_format||','||
                        r_data.currency_code||','||r_data.exchange_rate_type||','||r_data.exchange_rate||','||r_data.customer_number||','||
                        r_data.bill_to_location||','||r_data.customer_bank_branch_name||','||r_data.customer_bank_name||','||r_data.receipt_method||','||
                        r_data.remittance_bank_branch_name||','||r_data.remittance_bank_name||','||r_data.lockbox_number||','||r_data.deposit_date_format||','||
                        r_data.deposit_time||','||r_data.anticipated_clear_date_format||','||r_data.invoice_number||','||r_data.invoice_installment||','||
                        r_data.matching_date_format||','||r_data.invoice_currency_code||','||r_data.trans_to_receipt_rate||','||r_data.amount_applied_disp||','||
                        r_data.amount_applied_from||','||r_data.customer_reference||',,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,"'||r_data.comments||'",'||
                        r_data.attribute1||','||r_data.attribute2||','||r_data.attribute3||','||r_data.attribute4||','||r_data.attribute5||','||r_data.attribute6||','||
                        r_data.attribute7||','||r_data.attribute8||','||r_data.attribute9||','||r_data.attribute10||','||r_data.attribute11||','||r_data.attribute12||','||
                        r_data.attribute13||','||r_data.attribute14||','||r_data.attribute13||','||r_data.attribute_category;
                when 4 then
                    v_line := 
                        r_data.record_type||','||r_data.batch_name||','||r_data.item_number||','||r_data.overflow_indicator||','||
                        r_data.overflow_sequence||','||r_data.transit_routing_number||','||r_data.customer_bank_account||','||
                        r_data.currency_code||','||r_data.exchange_rate_type||','||r_data.exchange_rate||','||r_data.customer_number||','||
                        r_data.bill_to_location||','||r_data.customer_bank_branch_name||','||r_data.customer_bank_name||','||r_data.lockbox_number||','||
                        r_data.deposit_date_format||','||r_data.deposit_time||','||r_data.invoice_number||','||r_data.invoice_installment||','||
                        r_data.matching_date_format||','||r_data.invoice_currency_code||','||r_data.trans_to_receipt_rate||','||r_data.amount_applied_disp||','||
                        r_data.amount_applied_from||','||r_data.customer_reference||',,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,'||
                        r_data.attribute1||','||r_data.attribute2||','||r_data.attribute3||','||r_data.attribute4||','||r_data.attribute5||','||r_data.attribute6||','||
                        r_data.attribute7||','||r_data.attribute8||','||r_data.attribute9||','||r_data.attribute10||','||r_data.attribute11||','||r_data.attribute12||','||
                        r_data.attribute13||','||r_data.attribute14||','||r_data.attribute13||','||r_data.attribute_category;
                else
                    xxmx_utilities_pkg.log_module_message
                        (
							 pt_i_ApplicationSuite  => gct_ApplicationSuite
							,pt_i_Application       => gct_Application
							,pt_i_BusinessEntity    => pt_i_BusinessEntity
							,pt_i_SubEntity         => null
							,pt_i_MigrationSetID    => pt_i_MigrationSetID
							,pt_i_Phase             => gct_phase
							,pt_i_Severity          => 'ERROR'
							,pt_i_PackageName       => gct_PackageName
							,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
							,pt_i_ProgressIndicator => gvv_ProgressIndicator
							,pt_i_ModuleMessage     => 'Invalid RECORD_TYPE - '||r_data.record_type
							,pt_i_OracleError       => NULL
                        );
            end case;
            insert into xxmx_csv_file_temp
                    ( file_name, line_type, line_content, status )
                values
                    ( r_batch.batch_name||'.csv','File Detail', v_line, NULL );

        end loop; --data
    end loop; -- batch
end generate_csv_file;
--
procedure map_operating_unit
( 
    pt_i_ApplicationSuite       in varchar2,
    pt_i_Application            in varchar2,
    pt_i_BusinessEntity         in varchar2,
    pt_i_StgPopulationMethod    in varchar2,
    pt_i_FileSetID              in varchar2,
    pt_i_MigrationSetID         in number,
    pv_o_ReturnStatus           out varchar2
)
is
begin
    --
    gvt_ModuleMessage := 'Begin procedure map_operating_unit';
    xxmx_utilities_pkg.log_module_message
          (
           pt_i_ApplicationSuite  => 'FIN'
          ,pt_i_Application       => 'AR'
          ,pt_i_BusinessEntity    => 'CASH_RECEIPTS'
          ,pt_i_SubEntity         => null
          ,pt_i_MigrationSetID    => null
          ,pt_i_Phase             => 'TRANSFORM'
          ,pt_i_Severity          => 'NOTIFICATION'
          ,pt_i_PackageName       => gct_PackageName
          ,pt_i_ProcOrFuncName    => 'map_operating_unit'
          ,pt_i_ProgressIndicator => gvv_ProgressIndicator
          ,pt_i_ModuleMessage     => gvt_ModuleMessage
          ,pt_i_OracleError       => NULL
          );
    --
    update XXMX_AR_CASH_RECEIPTS_STG STG
        set OPERATING_UNIT_NAME =
        (
            select  OUTPUT_CODE_1
            from    XXMX_MAPPING_MASTER MAP
            where   MAP.category_code   = 'BUSINESS_UNIT'
            and     MAP.INPUT_CODE_1    = STG.OPERATING_UNIT_NAME
        )
    ;
    xxmx_utilities_pkg.log_module_message
          (
           pt_i_ApplicationSuite  => 'FIN'
          ,pt_i_Application       => 'AR'
          ,pt_i_BusinessEntity    => 'CASH_RECEIPTS'
          ,pt_i_SubEntity         => null
          ,pt_i_MigrationSetID    => null
          ,pt_i_Phase             => 'TRANSFORM'
          ,pt_i_Severity          => 'NOTIFICATION'
          ,pt_i_PackageName       => gct_PackageName
          ,pt_i_ProcOrFuncName    => 'map_operating_unit'
          ,pt_i_ProgressIndicator => gvv_ProgressIndicator
          ,pt_i_ModuleMessage     => SQL%rowcount||' rows updated.'
          ,pt_i_OracleError       => NULL
          );
    commit;
    update XXMX_AR_CASH_RECEIPTS_STG STG
        set batch_name = 'BATCH-'||migration_set_id||'-'||OPERATING_UNIT_NAME
    ;
    commit;
    --
    gvt_ModuleMessage := 'End procedure map_operating_unit';
    xxmx_utilities_pkg.log_module_message
          (
           pt_i_ApplicationSuite  => 'FIN'
          ,pt_i_Application       => 'AR'
          ,pt_i_BusinessEntity    => 'CASH_RECEIPTS'
          ,pt_i_SubEntity         => null
          ,pt_i_MigrationSetID    => null
          ,pt_i_Phase             => 'TRANSFORM'
          ,pt_i_Severity          => 'NOTIFICATION'
          ,pt_i_PackageName       => gct_PackageName
          ,pt_i_ProcOrFuncName    => 'map_operating_unit'
          ,pt_i_ProgressIndicator => gvv_ProgressIndicator
          ,pt_i_ModuleMessage     => gvt_ModuleMessage
          ,pt_i_OracleError       => NULL
          );
    --
    pv_o_ReturnStatus := 'S';
exception
    when others then
        pv_o_ReturnStatus := 'F';
end map_operating_unit;

END xxmx_ar_cash_receipts_pkg;
