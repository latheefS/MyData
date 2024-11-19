--------------------------------------------------------
--  DDL for Package Body MICHAL_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "XXMX_CORE"."MICHAL_PKG" 
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
    -- The following condition is to eliminate invoices that have not been migrated
    cursor c_adj_receipt is
        select *
        from xxmx_ar_cash_receipts_xfm STG
        where STG.invoice_number is not null
        and not exists
        (
            select 1 
                from xxmx_ppm_migrated_open_receipts PPM
                where PPM.invoice_number = STG.invoice_number
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
        --
        ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'ar_outstanding_cash_receipts_s';
        ct_Phase                        CONSTANT  xxmx_module_messages.phase%TYPE             := 'EXTRACT';
        ct_StgTable                     CONSTANT  xxmx_migration_metadata.stg_table%TYPE      := 'xxmx_ar_cash_receipts_xfm';
        --
        v_sql                           varchar2(3000);
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
    gvt_MigrationSetName := 'TEST1';
    if gvt_MigrationSetName IS NOT NULL then
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
        insert into xxmx_ar_cash_receipts_xfm
            (
                                 migration_set_id
                                ,migration_set_name
                                ,migration_status
                                ,item_number
                                ,record_type
                                ,migrated_receipt_type
                                --
                                ,operating_unit_name
                                ,batch_name
                                ,remittance_amount
                                ,remittance_amount_disp
                                ,cash_receipt_id
                                --
                                ,receipt_number
                                ,receipt_date
                                ,receipt_date_format
                                ,currency_code
                                ,exchange_rate_type
                                --
                                ,exchange_rate
                                ,customer_number
                                ,bill_to_location
                                ,lockbox_number
                                ,receipt_method
                                --
                                ,deposit_date
                                ,deposit_date_format
                                ,anticipated_clear_date
                                ,anticipated_clear_date_format
                                ,comments
                                ,attribute1
                                ,attribute2
                                ,attribute3
                                --
                                ,overflow_sequence
                                ,invoice_number
                                ,matching_date
                                ,matching_date_format 
                                ,amount_applied
                                ,amount_applied_disp 
                                ,INVOICE_CURRENCY_CODE 
                                ,trans_to_receipt_rate 
                                ,exchange_gain_loss 
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
                ),1,6,4 )                                          as record_type
            ,min(xacrsv.migrated_receipt_type)          as migrated_receipt_type
            --
            ,min(xacrsv.operating_unit_name)              AS operating_unit_name
            ,'BATCH-'||pt_i_MigrationSetID||'-'||
                min(xacrsv.operating_unit_name)                    AS batch_name
            ,min(xacrsv.receipt_amount_original)            AS remittance_amount
            ,min(xacrsv.receipt_amount_original*100)   AS remittance_amount_disp
            ,acra.cash_receipt_id                             as cash_receipt_id
            --
            ,acra.receipt_number                               AS receipt_number
            ,min(acra.receipt_date)                              AS receipt_date
            ,min(to_char(acra.receipt_date,'YYMMDD'))     AS receipt_date_format
            ,min(acra.currency_code)                            AS currency_code
            ,min(xacrsv.exchange_rate_type)                AS exchange_rate_type
            --
            ,min(xacrsv.exchange_rate)                          AS exchange_rate
            ,min(hca.account_number)                          AS customer_number
            ,min(hcsu.location)                              AS bill_to_location
            ,min(xfld.lockbox_number)                          AS lockbox_number
            ,min(arrm.name)                                    as receipt_method
            --
            ,min(acra.deposit_date)                              AS deposit_date
            ,min(to_char(acra.deposit_date,'YYMMDD'))     AS deposit_date_format
            ,min(acra.anticipated_clearing_date)    AS anticipated_clearing_date
            ,min(to_char(acra.anticipated_clearing_date,'YYMMDD'))
                                             AS anticipated_clearing_date_format
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
            ,sum(arra.amount_applied)                              as attribute3
            --
            ,row_number() over 
                (
                    partition by acra.receipt_number 
                    order by acra.receipt_number
                )                                           as overflow_sequence
            ,racta.trx_number                                  as invoice_number
            ,arra.apply_date                                    as matching_date
            ,to_char(arra.apply_date,'YYMMDD')           as matching_date_format
            ,sum(arra.amount_applied)                         as amount_to_apply
            ,sum(arra.amount_applied)*100                as amount_to_apply_disp
            ,arpsa.invoice_currency_code                as invoice_currency_code
            ,arra.trans_to_receipt_rate                 as trans_to_receipt_rate
            ,sum(arra.acctd_amount_applied_from-arra.acctd_amount_applied_to)
                                                           as exchange_gain_loss
            --
        FROM
             xxmx_ar_cash_receipts_scope_v                  xacrsv
            ,apps.ar_cash_receipts_all@XXMX_EXTRACT         acra
            ,apps.hz_cust_accounts@XXMX_EXTRACT             hca
            ,apps.hz_cust_site_uses_all@XXMX_EXTRACT        hcsu 
            ,apps.ar_receipt_methods@XXMX_EXTRACT           arrm
            ,apps.ar_receipt_classes@XXMX_EXTRACT           arrc
            ,ce_bank_acct_uses_all@XXMX_EXTRACT             cebaua
            ,ce_bank_accounts@XXMX_EXTRACT                  ceba
            ,xxmx_fusion_lockbox_details                    xfld
            ,ar_receivable_applications_all@XXMX_EXTRACT    arra
            ,ra_customer_trx_all@XXMX_EXTRACT               racta
            ,ar_payment_schedules_all@XXMX_EXTRACT          arpsa
        WHERE     nvl(xacrsv.receipt_amount_remaining  ,0) <> 0
        AND       acra.org_id                             = xacrsv.org_id
        AND       acra.cash_receipt_id                    = xacrsv.cash_receipt_id
        AND       hca.cust_account_id                     = xacrsv.customer_id
        AND       hcsu.site_use_id(+)                     = acra.customer_site_use_id               
        AND       arrm.receipt_method_id                  = acra.receipt_method_id
        AND       arrc.receipt_class_id                   = arrm.receipt_class_id
        AND       cebaua.bank_acct_use_id                 = acra.remit_bank_acct_use_id
        AND       ceba.bank_account_id                    = cebaua.bank_account_id
        AND       xfld.bu_name(+)                         = xacrsv.operating_unit_name
        AND       xfld.receipt_method(+)                  = arrm.name
        AND       xfld.bank_origination_number(+)         = ceba.bank_account_num
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
        having sum(arra.amount_applied)!=0
        UNION SELECT
             pt_i_MigrationSetID                             as migration_set_id
            ,gvt_MigrationSetName                          as migration_set_name
            ,'EXTRACTED'                                     as migration_status
            ,0                                                    as item_number
            ,6                                                    AS record_type
            ,xacrsv.migrated_receipt_type               as migrated_receipt_type
            --
            ,xacrsv.operating_unit_name                   AS operating_unit_name
            ,'BATCH-'||pt_i_MigrationSetID||'-'||
                xacrsv.operating_unit_name                         AS batch_name
            ,xacrsv.receipt_amount_original                 AS remittance_amount
            ,xacrsv.receipt_amount_original*100        AS remittance_amount_disp
            ,acra.cash_receipt_id                             as cash_receipt_id
            --
            ,acra.receipt_number                               AS receipt_number
            ,acra.receipt_date                                   AS receipt_date
            ,to_char(acra.receipt_date,'YYMMDD')          AS receipt_date_format
            ,acra.currency_code                                 AS currency_code
            ,xacrsv.exchange_rate_type                     AS exchange_rate_type
            --
            ,xacrsv.exchange_rate                               AS exchange_rate
            ,hca.account_number                               AS customer_number
            ,hcsu.location                                   AS bill_to_location
            ,xfld.lockbox_number                               AS lockbox_number
            ,arrm.name                                         as receipt_method
            --
            ,acra.deposit_date                                   AS deposit_date
            ,to_char(acra.deposit_date,'YYMMDD')          AS deposit_date_format
            ,acra.anticipated_clearing_date         AS anticipated_clearing_date
            ,to_char(acra.anticipated_clearing_date,'YYMMDD')
                                             AS anticipated_clearing_date_format
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
            ,null                                        as matching_date_format
            ,null                                             as amount_to_apply
            ,null                                        as amount_to_apply_disp
            ,null                                       as invoice_currency_code
            ,null                                       as trans_to_receipt_rate
            ,null                                          as exchange_gain_loss
            --
        FROM
             xxmx_ar_cash_receipts_scope_v                  xacrsv
            ,apps.ar_cash_receipts_all@XXMX_EXTRACT         acra
            ,apps.hz_cust_accounts@XXMX_EXTRACT             hca
            ,apps.hz_cust_site_uses_all@XXMX_EXTRACT        hcsu 
            ,apps.ar_receipt_methods@XXMX_EXTRACT           arrm
            ,apps.ar_receipt_classes@XXMX_EXTRACT           arrc
            ,ce_bank_acct_uses_all@XXMX_EXTRACT             cebaua
            ,ce_bank_accounts@XXMX_EXTRACT                  ceba
            ,xxmx_fusion_lockbox_details                    xfld
        WHERE     nvl(xacrsv.receipt_amount_remaining  ,0) <> 0
        AND       acra.org_id                             = xacrsv.org_id
        AND       acra.cash_receipt_id                    = xacrsv.cash_receipt_id
        AND       hca.cust_account_id                     = xacrsv.customer_id
        AND       hcsu.site_use_id(+)                     = acra.customer_site_use_id               
        AND       arrm.receipt_method_id                  = acra.receipt_method_id
        AND       arrc.receipt_class_id                   = arrm.receipt_class_id
        AND       cebaua.bank_acct_use_id                 = acra.remit_bank_acct_use_id
        AND       ceba.bank_account_id                    = cebaua.bank_account_id
        AND       xfld.bu_name(+)                         = xacrsv.operating_unit_name
        AND       xfld.receipt_method(+)                  = arrm.name
        AND       xfld.bank_origination_number(+)         = ceba.bank_account_num
        and       xacrsv.migrated_receipt_type            in ('On-Account','Unapplied')
        UNION SELECT
             pt_i_MigrationSetID                             as migration_set_id
            ,gvt_MigrationSetName                          as migration_set_name
            ,'EXTRACTED'                                     as migration_status
            ,0                                                    as item_number
            ,6                                                    AS record_type
            ,xacrsv.migrated_receipt_type               as migrated_receipt_type
            --
            ,xacrsv.operating_unit_name                   AS operating_unit_name
            ,'BATCH-'||pt_i_MigrationSetID||'-'||
                xacrsv.operating_unit_name                         AS batch_name
            ,xacrsv.receipt_amount_original                 AS remittance_amount
            ,xacrsv.receipt_amount_original*100        AS remittance_amount_disp
            ,acra.cash_receipt_id                             as cash_receipt_id
            ,acra.receipt_number                               AS receipt_number
            ,acra.receipt_date                                   AS receipt_date
            ,to_char(acra.receipt_date,'YYMMDD')          AS receipt_date_format
            ,acra.currency_code                                 AS currency_code
            ,xacrsv.exchange_rate_type                     AS exchange_rate_type
            ,xacrsv.exchange_rate                               AS exchange_rate
            ,null                                             AS customer_number
            ,null                                            AS bill_to_location
            ,xsou.lockbox_number                               AS lockbox_number
            ,xsou.lockbox_receipt_method                       as receipt_method
            ,acra.deposit_date                                   AS deposit_date
            ,to_char(acra.deposit_date,'YYMMDD')          AS deposit_date_format
            ,acra.anticipated_clearing_date         AS anticipated_clearing_date
            ,to_char(acra.anticipated_clearing_date,'YYMMDD')
                                             AS anticipated_clearing_date_format
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
            ,null                                        as matching_date_format
            ,null                                             as amount_to_apply
            ,null                                        as amount_to_apply_disp
            ,null                                       as invoice_currency_code
            ,null                                       as trans_to_receipt_rate
            ,null                                          as exchange_gain_loss
            --
        FROM
             xxmx_source_operating_units                  xsou
            ,xxmx_ar_cash_receipts_scope_v                xacrsv
            ,apps.ar_cash_receipts_all@XXMX_EXTRACT       acra
        WHERE     xsou.SOURCE_OPERATING_UNIT_NAME         = xacrsv.OPERATING_UNIT_NAME
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
        -- FOR CITCO ONLY: Remove invoices that have not been migrated using PPM table with open receipts.
        -- ------------------------------------------------------------------ --
        --
        --
        gvv_ProgressIndicator := 'S-008';
        for r_overflow_seq in c_overflow_seq loop
            v_sql := r_overflow_seq.update_stmt;
            execute immediate v_sql;
        end loop;
        --
        --
        gvv_ProgressIndicator := 'S-009';
        update xxmx_xfm.xxmx_ar_cash_receipts_xfm u
            set
                u.item_number=ROWNUM
            where u.record_type =6
            ;
        gvv_ProgressIndicator := 'S-010';
        update xxmx_xfm.xxmx_ar_cash_receipts_xfm u
            set
                u.item_number=(select x.item_number from xxmx_xfm.xxmx_ar_cash_receipts_xfm x where x.receipt_number=u.receipt_number and x.record_type=6)
            where u.record_type =4
            ;
        gvv_ProgressIndicator := 'S-011';
        update xxmx_xfm.xxmx_ar_cash_receipts_xfm
            set
                overflow_indicator = decode(overflow_sequence,null,null,0)
            ;
        gvv_ProgressIndicator := 'S-012';
        update xxmx_xfm.xxmx_ar_cash_receipts_xfm u
            set
                u.overflow_indicator = 9
            where u.overflow_sequence = (select max(overflow_sequence) from xxmx_xfm.xxmx_ar_cash_receipts_xfm x where x.cash_receipt_id=u.cash_receipt_id)
            ;
        --
        COMMIT;
        --
        --
        gvv_ProgressIndicator := 'S-015';
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
        --
        gvv_ProgressIndicator := 'S-017';
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
    -- *********************
	--  CURSOR Declarations
	-- *********************
    cursor c_batch (p_migration_set_id in number) is
        select distinct
            batch_name                  as batch_name,
            batch_name||'.csv'          as file_name
        from
            xxmx_xfm.XXMX_AR_CASH_RECEIPTS_XFM
        where       migration_set_id        = p_migration_set_id;
    --
	cursor c_file_components (p_applicationsuite varchar2,p_application varchar2) is
        select 
            mm.Sub_entity,
			mm.Metadata_id,
			mm.business_entity,
			mm.stg_Table stg_table_name,
			UPPER( mm.xfm_table) xfm_table_name,
			xt.xfm_table_id,
			xt.fusion_template_name,
			xt.fusion_template_sheet_name,
			mm.file_group_number
        from xxmx_migration_metadata mm, xxmx_xfm_tables xt
		where  mm.metadata_id = xt.metadata_id
		and    mm.application_suite = p_applicationsuite
		and    mm.application = p_application
		and    mm.Business_entity = pt_i_BusinessEntity
		and    mm.sub_entity = DECODE(pt_i_SubEntity,'ALL', mm.sub_entity, pt_i_SubEntity)
		and    mm.stg_table is not null
		and    mm.enabled_flag = 'Y'
		and    xt.fusion_template_name = NVL(pt_i_FileName,xt.fusion_template_name);
    --
	cursor c_missing_values ( p_xfm_table in VARCHAR2) is
        select  
            column_name
			,fusion_template_field_name
			,field_delimiter
        from    xxmx_xfm_table_columns xtc,
							xxmx_xfm_tables xt
		where   xt.table_name= p_xfm_table
		AND     xtc.xfm_table_id = xt.xfm_table_id
		and     xtc.include_in_outbound_file = 'Y'
		and     xtc.mandatory                = 'Y';
	--
    CURSOR c_file_columns ( p_xfm_table_id IN NUMBER,p_column_name IN VARCHAR2) is
        SELECT
            column_name,
			fusion_template_field_name,
			data_type,
			field_delimiter
        FROM    xxmx_xfm_table_columns xtc, xxmx_xfm_tables xt
		WHERE   xt.xfm_Table_id  = xtc.xfm_table_id
		AND     xt.xfm_table_id = p_xfm_table_id
		AND     UPPER(xtc.COLUMN_NAME) = NVL(UPPER(p_column_name),xtc.COLUMN_NAME)
		AND     include_in_outbound_file = 'Y'
		order by xfm_column_seq;
    --
				--
				--
				 /************************
				 ** Constant Declarations
				 *************************/
				  --

				  cv_ProcOrFuncName           CONSTANT  VARCHAR2(30)                                 := 'generate_csv_file';

				  vt_sub_entity                         xxmx_migration_metadata.sub_entity%TYPE :=pt_i_SubEntity ;--'ALL'; changed in 4.0
				  vt_ext                      CONSTANT  VARCHAR2(10)                            := '.csv';
				  gct_phase                   CONSTANT  xxmx_module_messages.phase%TYPE       := 'EXPORT';
				  g_zipped_blob               blob;

				  vv_file_type                          VARCHAR2(10) := 'M';
				  vv_file_dir                           xxmx_file_locations.file_location%TYPE;
				  v_hdr_flag                            VARCHAR2(5);

				  --
				  /************************
				 ** Variable Declarations
				 *************************/
				 --
				  vt_ApplicationSuite                  xxmx_migration_metadata.application_suite%TYPE:= 'XXMX';
				  vt_Application                       xxmx_migration_metadata.application%TYPE:='XXMX';

				  gvv_ReturnStatus                     VARCHAR2(1);
				  gvt_ReturnMessage                    xxmx_module_messages.module_message%TYPE;
				  gvt_ModuleMessage                    xxmx_module_messages.module_message%TYPE;
				  gvt_OracleError                      xxmx_module_messages.oracle_error%TYPE;
				  gvt_migrationsetname                 xxmx_migration_headers.migration_set_name%TYPE;
				  gvt_Severity                         xxmx_module_messages .severity%TYPE;
				  vv_hdl_file_header                   VARCHAR2(32000);
				  vv_error_message                     VARCHAR2(80);
				  vv_stop_processing                   VARCHAR2(1);
				  vv_column_name                       VARCHAR2(100);
				  gvv_SQLStatement                     VARCHAR2(32000);
				  v_sql                                 VARCHAR2(32000);
				  gvv_SQLPreString                     VARCHAR2(8000);
				  gvv_ProgressIndicator                VARCHAR2(100);
				  gvv_stop_processing                  VARCHAR2(5);
				  gvv_sqlresult_num                    NUMBER;
				  pv_o_OIC_Internal                    VARCHAR2(200);
				  pv_o_FTP_Data                        VARCHAR2(200);
				  pv_o_FTP_Process                     VARCHAR2(200);
				  pv_o_FTP_Out                         VARCHAR2(200);
				  pv_o_ZIP_Filename                    VARCHAR2(200);
				  pv_o_PROPERTY_Filename               VARCHAR2(200);
				  g_file_id                            UTL_FILE.FILE_TYPE;
				  lv_exists                            VARCHAR2(5);
                  v_count                              number;
				  --
				  --******************************
				  --** Dynamic Cursor Declarations
				  --******************************
				  --
				  TYPE RefCursor_t IS REF CURSOR;
				  MandColumnData_cur                         RefCursor_t;
				  --
				  --***************************
				  -- Record Table Declarations
				  -- **************************
				  --
				  type extract_data is table of varchar2(4000) index by binary_integer;
				  g_extract_data                 extract_data;
				  --
				  type exrtact_cursor_type IS REF CURSOR;
				  r_data                        exrtact_cursor_type;
				  --
				  -- **************************
				  -- Exception Declarations
				  -- **************************
				  --
				  --** Set gvt_Severity, gvv_ProgressIndicator and gvt_ModuleMessage
				  --** beFORe raising this exception.
				  --
				  e_ModuleError                   EXCEPTION;
				  e_dataerror                     EXCEPTION;
				  e_nodata                        EXCEPTION;
				  --
			 --** END Declarations
			 --
			 --
    --
begin
    gvv_ProgressIndicator := '0010';
    gvv_ReturnStatus  := '';
	xxmx_utilities_pkg.log_module_message
					   (
						pt_i_ApplicationSuite  => vt_Applicationsuite
					   ,pt_i_Application       => vt_Application
					   ,pt_i_BusinessEntity    => pt_i_BusinessEntity
					   ,pt_i_SubEntity         => vt_sub_entity
					   ,pt_i_MigrationSetID    => pt_i_MigrationSetID
					   ,pt_i_Phase             => gct_phase
					   ,pt_i_Severity          => 'NOTIFICATION'
					   ,pt_i_PackageName       => gct_PackageName
					   ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
					   ,pt_i_ProgressIndicator => gvv_ProgressIndicator
					   ,pt_i_ModuleMessage     => 'Procedure "'||gct_PackageName||'.'||cv_ProcOrFuncName||'" initiated.',pt_i_OracleError=> NULL
					   );
    --
	-- Delete any MODULE messages FROM previous executions
	-- FOR the Business Entity and Business Entity Level
	--
    gvv_ProgressIndicator := '0020';
	xxmx_utilities_pkg.clear_messages
        (
             pt_i_ApplicationSuite => vt_Applicationsuite
			,pt_i_Application      => vt_Application
			,pt_i_BusinessEntity   => pt_i_BusinessEntity
			,pt_i_SubEntity        => vt_sub_entity
			,pt_i_MigrationSetID   => NULL                 -- This is NULL so messages FOR all previous runs are deleted.
			,pt_i_Phase            => gct_phase
			,pt_i_MessageType      => 'MODULE'
			,pv_o_ReturnStatus     => gvv_ReturnStatus
        );
		--
	if gvv_ReturnStatus = 'F' then
        xxmx_utilities_pkg.log_module_message
            (
							 pt_i_ApplicationSuite  => vt_Applicationsuite
							,pt_i_Application       => vt_Application
							,pt_i_BusinessEntity    => pt_i_BusinessEntity
							,pt_i_SubEntity         => vt_sub_entity
							,pt_i_MigrationSetID    => pt_i_MigrationSetID
							,pt_i_Phase             => gct_phase
							,pt_i_Severity          => 'ERROR'
							,pt_i_PackageName       => gct_PackageName
							,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
							,pt_i_ProgressIndicator => gvv_ProgressIndicator
							,pt_i_ModuleMessage     => 'ORACLE ERROR in called procedure "xxmx_utilities_pkg.clear_messages".'
							,pt_i_OracleError       => NULL
			);
		raise e_ModuleError;
    end if;
    --
    -- Verify that the value in pt_i_BusinessEntity is valid.
    --
    gvv_ProgressIndicator := '0030';
    xxmx_utilities_pkg.verify_lookup_code
        (
					   pt_i_LookupType    => 'BUSINESS_ENTITIES'
					  ,pt_i_LookupCode    => pt_i_BusinessEntity
					  ,pv_o_ReturnStatus  => gvv_ReturnStatus
					  ,pt_o_ReturnMessage => gvt_ReturnMessage
		);
    --
	if gvv_ReturnStatus <> 'S' then
        gvt_Severity      := 'ERROR';
		gvt_ModuleMessage := gvt_ReturnMessage;
		--
		RAISE e_ModuleError;			  --
	end if;
    --
	--
	-- Retrieve the Application Suite and Application for the Business Entity.
	-- 
	-- A Business Entity can only be defined for a single Application e.g. there
	-- cannot be an "INVOICES" Business Entity in both the "AP" and "AR"
	-- Applications therefore for "AR" the "TRANSACTIONS" Business Entity is used.
	--
	gvv_ProgressIndicator := '0040';
	xxmx_utilities_pkg.get_entity_application
						   (
							pt_i_BusinessEntity   => pt_i_BusinessEntity
						   ,pt_o_ApplicationSuite => vt_ApplicationSuite
						   ,pt_o_Application      => vt_Application
						   ,pv_o_ReturnStatus     => gvv_ReturnStatus
						   ,pt_o_ReturnMessage    => gvt_ReturnMessage
						   );
				 --
    if gvv_ReturnStatus <> 'S' then
        gvt_Severity      := 'ERROR';
		gvt_ModuleMessage := gvt_ReturnMessage;
		--
		RAISE e_ModuleError;
	end if; 
    --
    -- Get the gvt_MigrationSetName
	gvv_ProgressIndicator := '0050';
	gvt_MigrationSetName := xxmx_utilities_pkg.get_migration_set_name(pt_i_MigrationSetID);
	xxmx_utilities_pkg.log_module_message
									  (
									   pt_i_ApplicationSuite  => vt_Applicationsuite
									  ,pt_i_Application       => vt_Application
									  ,pt_i_BusinessEntity    => pt_i_BusinessEntity
									  ,pt_i_SubEntity         => vt_sub_entity
									  ,pt_i_MigrationSetID    => pt_i_MigrationSetID
									  ,pt_i_Phase             => gct_phase
									  ,pt_i_Severity          => 'NOTIFICATION'
									  ,pt_i_PackageName       => gct_PackageName
									  ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
									  ,pt_i_ProgressIndicator => gvv_ProgressIndicator
									  ,pt_i_ModuleMessage     => 'Migration Set Name '||gvt_MigrationSetName
									  ,pt_i_OracleError       => NULL
									  );
	--
	--
	gvv_ProgressIndicator := '0060';
    --
	for r_file_component in c_file_components(vt_Applicationsuite ,vt_Application)
	loop
        -- call to update XFM table double quoates trailing spaces etc
		xxmx_utilities_pkg.clean_xfm_data(r_file_component.xfm_table_id,r_file_component.xfm_table_name);
        --
		begin -- for each component
            --
            gvv_ProgressIndicator := '0070';
    		gvv_sqlresult_num     := NULL;
        	gvv_stop_processing   := NULL;
            --
            -- Check: if no include_in_outbound_file = 'Y'
    		--
            gvv_sqlstatement:=
                    'select count(1) from xxmx_xfm_table_columns xtc,xxmx_xfm_tables xt where xt.table_name= '''||
                    r_file_component.xfm_table_name||''' and xtc.xfm_table_id = xt.xfm_table_id and xtc.include_in_outbound_file = ''Y''';
    		open MandColumnData_cur FOR gvv_sqlstatement;
        	fetch MandColumnData_cur INTO gvv_sqlresult_num;
            if gvv_sqlresult_num = 0 then
               	gvv_ProgressIndicator := '0080';
                gvv_stop_processing := 'Y';
    			gvt_ModuleMessage := 'No Columns are marked for Fusion Outbound File in xxmx_xfm_table_columns';
        		xxmx_utilities_pkg.log_module_message
						 (
						  pt_i_ApplicationSuite  => vt_Applicationsuite
						 ,pt_i_Application       => vt_Application
						 ,pt_i_BusinessEntity    => pt_i_BusinessEntity
						 ,pt_i_SubEntity         => vt_sub_entity
						 ,pt_i_MigrationSetID    => pt_i_MigrationSetID
						 ,pt_i_Phase             => gct_phase
						 ,pt_i_Severity          => 'ERROR'
						 ,pt_i_PackageName       => gct_PackageName
						 ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
						 ,pt_i_ProgressIndicator => gvv_ProgressIndicator
						 ,pt_i_ModuleMessage     => gvt_ModuleMessage
						 ,pt_i_OracleError       => NULL
						 );
                    raise e_ModuleError;
            end if;
            close MandColumnData_cur;
            --
            gvv_ProgressIndicator := '0090';
            gvv_sqlresult_num     := NULL;
            gvv_stop_processing   := NULL;
            --
            -- Check for missing values in the mandatory columns
            --
            FOR r_missing_values IN c_missing_values(r_file_component.xfm_table_name)
            LOOP
                gvv_sqlstatement := 
                    'SELECT count(1) from '||r_file_component.xfm_table_name||
                    ' WHERE '||r_missing_values.column_name||' IS NULL';
                EXECUTE IMMEDIATE gvv_sqlstatement INTO gvv_sqlresult_num;
                if gvv_sqlresult_num > 0 then
                        gvv_ProgressIndicator := '0081';
                        gvv_stop_processing := 'Y';
                        gvt_ModuleMessage := 
                            'Column '||r_missing_values.column_name||'is marked as Mandatory with Null values in the XFM table :'||r_file_component.xfm_table_name;
                        xxmx_utilities_pkg.log_module_message
								  (
								   pt_i_ApplicationSuite  => vt_Applicationsuite
								  ,pt_i_Application       => vt_Application
								  ,pt_i_BusinessEntity    => pt_i_BusinessEntity
								  ,pt_i_SubEntity         => vt_sub_entity
								  ,pt_i_MigrationSetID    => pt_i_MigrationSetID
								  ,pt_i_Phase             => gct_phase
								  ,pt_i_Severity          => 'ERROR'
								  ,pt_i_PackageName       => gct_PackageName
								  ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
								  ,pt_i_ProgressIndicator => gvv_ProgressIndicator
								  ,pt_i_ModuleMessage     => gvt_ModuleMessage
								  ,pt_i_OracleError       => NULL
								  );
                        raise e_ModuleError;
                    end if;
            end loop;
            --
            if vv_stop_processing = 'Y' then
						gvt_Severity              := 'ERROR';
						gvt_ModuleMessage         := 'Extract file has not created. Check xxmx_module_messages for errors.';
						RAISE e_moduleerror;
            end if;
            --
            gvv_SQLStatement := NULL;
            gvv_SQLStatement := NULL;
            --
            begin 
                    select  'Y'
                        INTO lv_exists
                        from 
                            xxmx_dm_subentity_file_map a,
							xxmx_migration_metadata m,
							xxmx_xfm_Table_columns b,
							xxmx_xfm_tables c
					where a.sub_entity = m.sub_entity
					and b.xfm_table_id = r_file_component.xfm_table_id
					and c.table_name = UPPER(m.xfm_table)
					and b.xfm_table_id = c.xfm_table_id
					and excel_file_header IS NOT NULL
					and rownum=1;
            exception
                when NO_DATA_FOUND then 
                        lv_exists:= 'N';                         
            end;
            --
            if (lv_exists = 'Y') then
                XXMX_FILE_COL_SEQ(r_file_component.xfm_table_id,gvv_ReturnStatus);
                if (gvv_ReturnStatus <> 'S') then
						  gvv_ProgressIndicator := '0081a';
						  gvv_stop_processing := 'Y';
						  gvt_ModuleMessage := 'File SEQ Failed';
						  raise e_ModuleError;
                end if;
                --
                -- Build the SQL that will extract the data in the import file format
                gvv_SQLStatement := NULL;
                for i in t_file_col.FIRST..t_file_col.LAST
                loop
                    for r_file_column  IN c_file_columns(r_file_component.xfm_table_id,t_file_col(i)) 
                    loop
                        if r_file_column.data_type = 'DATE' then
										vv_column_name := 'to_char('||r_file_column.column_name||',''YYYY/MM/DD'')';
                        ELSIF r_file_column.data_type IN ('VARCHAR2','CHAR') then
										vv_column_name := '''"''||'||r_file_column.column_name||'||''"''';
                        ELSE
										vv_column_name := r_file_column.column_name;
                        end if;
                        if (gvv_SQLStatement IS NULL ) then 
									gvv_SQLStatement := 'SELECT '||vv_column_name;
									vv_hdl_file_header := r_file_column.fusion_template_field_name;
                        else 
									gvv_SQLStatement := gvv_SQLStatement||'||'''||r_file_column.field_delimiter||''''||'||'||vv_column_name;
									vv_hdl_file_header := vv_hdl_file_header||r_file_column.field_delimiter||r_file_column.fusion_template_field_name;
                        end if;
                    end loop;
                end loop;
            else 
                gvv_SQLStatement := NULL;
                FOR r_file_column  IN c_file_columns(r_file_component.xfm_table_id,NULL) 
                    LOOP
							IF r_file_column.data_type = 'DATE' then
									vv_column_name := 'to_char('||r_file_column.column_name||',''YYYY/MM/DD'')';
							ELSIF r_file_column.data_type IN ('VARCHAR2','CHAR') then
									vv_column_name := '''"''||'||r_file_column.column_name||'||''"''';
							ELSE
									vv_column_name := r_file_column.column_name;
							end if;
							CASE c_file_columns%rowcount
								when 1 then
									gvv_SQLStatement := 'SELECT '||vv_column_name;
									vv_hdl_file_header := r_file_column.fusion_template_field_name;
								else
									gvv_SQLStatement := gvv_SQLStatement||'||'''||r_file_column.field_delimiter||''''||'||'||vv_column_name;
									vv_hdl_file_header := vv_hdl_file_header||r_file_column.field_delimiter||r_file_column.fusion_template_field_name;
							END CASE;
                    end loop;
            end if;
            --
            gvv_sqlstatement := gvv_sqlstatement||' from '||r_file_component.xfm_table_name ;
            --
            for r_batch in c_batch(pt_i_MigrationSetID)
            loop
                delete from xxmx_csv_file_temp where upper(file_name) = upper(r_batch.file_name);
                --
                v_sql := gvv_sqlstatement||' where batch_name='''||r_batch.batch_name||'''';
                gvv_ProgressIndicator := '0100';
                xxmx_utilities_pkg.log_module_message
							  (
							   pt_i_ApplicationSuite  => vt_Applicationsuite
							  ,pt_i_Application       => vt_Application
							  ,pt_i_BusinessEntity    => pt_i_BusinessEntity
							  ,pt_i_SubEntity         => vt_sub_entity
							  ,pt_i_MigrationSetID    => pt_i_MigrationSetID
							  ,pt_i_Phase             => gct_phase
							  ,pt_i_Severity          => 'NOTIFICATION'
							  ,pt_i_PackageName       => gct_PackageName
							  ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
							  ,pt_i_ProgressIndicator => gvv_ProgressIndicator
							  ,pt_i_ModuleMessage     => 'SQL= '||SUBSTR(v_sql,1,3000)
							  ,pt_i_OracleError       => NULL
							  );
                xxmx_utilities_pkg.log_module_message
							  (
							   pt_i_ApplicationSuite  => vt_Applicationsuite
							  ,pt_i_Application       => vt_Application
							  ,pt_i_BusinessEntity    => pt_i_BusinessEntity
							  ,pt_i_SubEntity         => vt_sub_entity
							  ,pt_i_MigrationSetID    => pt_i_MigrationSetID
							  ,pt_i_Phase             => gct_phase
							  ,pt_i_Severity          => 'NOTIFICATION'
							  ,pt_i_PackageName       => gct_PackageName
							  ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
							  ,pt_i_ProgressIndicator => gvv_ProgressIndicator
							  ,pt_i_ModuleMessage     => 'SQL= '||SUBSTR(v_sql,3001,6000)
							  ,pt_i_OracleError       => NULL
							  );
                --
                open r_data for v_sql;
                fetch r_data bulk collect into g_extract_data;
                close r_data;
                --
                gvv_ProgressIndicator := '0115';
                xxmx_utilities_pkg.log_module_message
							  (
							   pt_i_ApplicationSuite  => vt_Applicationsuite
							  ,pt_i_Application       => vt_Application
							  ,pt_i_BusinessEntity    => pt_i_BusinessEntity
							  ,pt_i_SubEntity         => vt_sub_entity
							  ,pt_i_MigrationSetID    => pt_i_MigrationSetID
							  ,pt_i_Phase             => gct_phase
							  ,pt_i_Severity          => 'NOTIFICATION'
							  ,pt_i_PackageName       => gct_PackageName
							  ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
							  ,pt_i_ProgressIndicator => gvv_ProgressIndicator
							  ,pt_i_ModuleMessage     => g_extract_data.COUNT
							  ,pt_i_OracleError       => NULL
							  );
                --
                if g_extract_data.COUNT = 0 then
                    gvv_ProgressIndicator := '0120';
                    gvt_ModuleMessage := 'No data in xfm table to generate the Import File';
                    xxmx_utilities_pkg.log_module_message
							  (
							   pt_i_ApplicationSuite  => vt_Applicationsuite
							  ,pt_i_Application       => vt_Application
							  ,pt_i_BusinessEntity    => pt_i_BusinessEntity
							  ,pt_i_SubEntity         => vt_sub_entity
							  ,pt_i_MigrationSetID    => pt_i_MigrationSetID
							  ,pt_i_Phase             => gct_phase
							  ,pt_i_Severity          => 'NOTIFICATION'
							  ,pt_i_PackageName       => gct_PackageName
							  ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
							  ,pt_i_ProgressIndicator => gvv_ProgressIndicator
							  ,pt_i_ModuleMessage     => gvt_ModuleMessage
							  ,pt_i_OracleError       => NULL
							  );
                    raise e_dataerror;
                end if;
                insert into xxmx_csv_file_temp
					( file_name, line_type, line_content, status)
                    values
					(r_batch.file_name,'File Header', vv_hdl_file_header,NULL );
                forall i in 1..g_extract_data.COUNT
                    insert into xxmx_csv_file_temp
                        ( file_name, line_type, line_content, status)
						values
						(r_batch.file_name,'File Detail', g_extract_data(i),NULL );
                commit;
            end loop;

            xxmx_utilities_pkg.log_module_message
							  (
							   pt_i_ApplicationSuite  => vt_Applicationsuite
							  ,pt_i_Application       => vt_Application
							  ,pt_i_BusinessEntity    => pt_i_BusinessEntity
							  ,pt_i_SubEntity         => vt_sub_entity
							  ,pt_i_MigrationSetID    => pt_i_MigrationSetID
							  ,pt_i_Phase             => gct_phase
							  ,pt_i_Severity          => 'NOTIFICATION'
							  ,pt_i_PackageName       => gct_PackageName
							  ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
							  ,pt_i_ProgressIndicator => gvv_ProgressIndicator
							  ,pt_i_ModuleMessage     => SUBSTR('Header='||vv_hdl_file_header,1,3000)
							  ,pt_i_OracleError       => NULL
							  );
            --
            gvv_ProgressIndicator := '0105';
			--
			-- Open cusrsor using the sql in gvv_SQLStatement
			--
			--
            --
            -- Write into data file
            -- 2. Write the data
            gvv_ProgressIndicator := '0126';
            --Added by DG on 20/01/22 for testing
            xxmx_utilities_pkg.log_module_message
							  (
							   pt_i_ApplicationSuite  => vt_Applicationsuite
							  ,pt_i_Application       => vt_Application
							  ,pt_i_BusinessEntity    => pt_i_BusinessEntity
							  ,pt_i_SubEntity         => vt_sub_entity
							  ,pt_i_MigrationSetID    => pt_i_MigrationSetID
							  ,pt_i_Phase             => gct_phase
							  ,pt_i_Severity          => 'NOTIFICATION'
							  ,pt_i_PackageName       => gct_PackageName
							  ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
							  ,pt_i_ProgressIndicator => gvv_ProgressIndicator
							  ,pt_i_ModuleMessage     => gvt_ModuleMessage
							  ,pt_i_OracleError       => NULL
							  );
/*
            IF( pt_file_generated_by = 'OIC') then -- Added for Both OIC And PLSQL
                    insert into xxmx_csv_file_temp
								( file_name, line_type, line_content, status)
								values
								(r_file_component.FUSION_TEMPLATE_NAME,'File Header', vv_hdl_file_header,NULL );
                    select count(*) into v_count from xxmx_csv_file_temp;
    				xxmx_utilities_pkg.log_module_message
							  (
							   pt_i_ApplicationSuite  => vt_Applicationsuite
							  ,pt_i_Application       => vt_Application
							  ,pt_i_BusinessEntity    => pt_i_BusinessEntity
							  ,pt_i_SubEntity         => vt_sub_entity
							  ,pt_i_MigrationSetID    => pt_i_MigrationSetID
							  ,pt_i_Phase             => gct_phase
							  ,pt_i_Severity          => 'NOTIFICATION'
							  ,pt_i_PackageName       => gct_PackageName
							  ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
							  ,pt_i_ProgressIndicator => gvv_ProgressIndicator
							  ,pt_i_ModuleMessage     => 'v_count='||v_count
							  ,pt_i_OracleError       => NULL
							  );
					FORALL i IN 1..g_extract_data.COUNT
								insert into xxmx_csv_file_temp
								( file_name, line_type, line_content, status)
								values
								(r_file_component.FUSION_TEMPLATE_NAME,'File Detail', g_extract_data(i),NULL );
                            commit;
						    --Commented by DG on 20/01/22 for testing
                            select count(*) into v_count from xxmx_csv_file_temp;
    						xxmx_utilities_pkg.log_module_message
							  (
							   pt_i_ApplicationSuite  => vt_Applicationsuite
							  ,pt_i_Application       => vt_Application
							  ,pt_i_BusinessEntity    => pt_i_BusinessEntity
							  ,pt_i_SubEntity         => vt_sub_entity
							  ,pt_i_MigrationSetID    => pt_i_MigrationSetID
							  ,pt_i_Phase             => gct_phase
							  ,pt_i_Severity          => 'NOTIFICATION'
							  ,pt_i_PackageName       => gct_PackageName
							  ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
							  ,pt_i_ProgressIndicator => gvv_ProgressIndicator
							  ,pt_i_ModuleMessage     => 'v_count='||v_count
							  ,pt_i_OracleError       => NULL
							  );
            ELSE  -- Added for Both OIC And PLSQL
                    -- 1. Write the header
					gvv_ProgressIndicator := '0125';
					-- Write the Business Entity header
					xxmx_utilities_pkg.open_csv  
                                ( 
                                    pt_i_BusinessEntity
                                    ,r_file_component.fusion_template_name
                                    ,r_file_component.fusion_template_sheet_name
                                    ,pv_o_FTP_Out
                                    ,'H'
                                    ,vv_hdl_file_header
                                    ,gvv_ReturnStatus
                                    ,gvt_ReturnMessage
                                );
					--
					for i IN 1..g_extract_data.COUNT loop
								xxmx_utilities_pkg.open_csv  ( pt_i_BusinessEntity
																,r_file_component.FUSION_TEMPLATE_NAME
																,r_file_component.fusion_template_sheet_name
																,pv_o_FTP_Out
																,'D'
																,g_extract_data(i)
																,gvv_ReturnStatus
																,gvt_ReturnMessage
																);
					end loop;
            end if;  -- Added for Both OIC And PLSQL
*/
                g_extract_data.DELETE;
                commit;
                --
                -- Close the file handler
                gvv_ProgressIndicator := '0130';
                --
            --
        exception -- for each component
            when e_dataerror then
					xxmx_utilities_pkg.log_module_message
						  (
						   pt_i_ApplicationSuite  => vt_Applicationsuite
						  ,pt_i_Application       => vt_Application
						  ,pt_i_BusinessEntity    => pt_i_BusinessEntity
						  ,pt_i_SubEntity         => vt_sub_entity
						  ,pt_i_MigrationSetID    => pt_i_MigrationSetID
						  ,pt_i_Phase             => gct_phase
						  ,pt_i_Severity          => 'ERROR'
						  ,pt_i_PackageName       => gct_PackageName
						  ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
						  ,pt_i_ProgressIndicator => gvv_ProgressIndicator
						  ,pt_i_ModuleMessage     => gvt_ModuleMessage
						  ,pt_i_OracleError       => NULL
						  );
        end; -- for each component
        --
    end loop; -- r_file_component
    gvt_ModuleMessage := 'Procedure generate_csv_file completed';
    xxmx_utilities_pkg.log_module_message
        (
             pt_i_ApplicationSuite  => vt_Applicationsuite
            ,pt_i_Application       => vt_Application
            ,pt_i_BusinessEntity    => pt_i_BusinessEntity
            ,pt_i_SubEntity         => vt_sub_entity
            ,pt_i_MigrationSetID    => pt_i_MigrationSetID
            ,pt_i_Phase             => gct_phase
            ,pt_i_Severity          => 'ERROR'
            ,pt_i_PackageName       => gct_PackageName
            ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
            ,pt_i_ProgressIndicator => gvv_ProgressIndicator
            ,pt_i_ModuleMessage     => gvt_ModuleMessage
            ,pt_i_OracleError       => NULL
		);
		--
EXCEPTION
			   WHEN e_nodata then
			   --
			   xxmx_utilities_pkg.log_module_message(
							 pt_i_ApplicationSuite    => vt_Applicationsuite
							,pt_i_Application         => vt_Application
							,pt_i_BusinessEntity      => pt_i_BusinessEntity
							,pt_i_SubEntity           =>  vt_sub_entity
							,pt_i_MigrationSetID    => pt_i_MigrationSetID
							,pt_i_Phase               => gct_phase
							,pt_i_Severity            => 'ERROR'
							,pt_i_PackageName         => gct_PackageName
							,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
							,pt_i_ProgressIndicator   => gvv_ProgressIndicator
							,pt_i_ModuleMessage       => gvt_ModuleMessage
							,pt_i_OracleError         => gvt_ReturnMessage       );
				--
				WHEN e_ModuleError then
						--
				xxmx_utilities_pkg.log_module_message(
							 pt_i_ApplicationSuite    => vt_Applicationsuite
							,pt_i_Application         => vt_Application
							,pt_i_BusinessEntity      => pt_i_BusinessEntity
							,pt_i_SubEntity           =>  vt_sub_entity
							,pt_i_MigrationSetID    => pt_i_MigrationSetID
							,pt_i_Phase               => gct_phase
							,pt_i_Severity            => 'ERROR'
							,pt_i_PackageName         => gct_PackageName
							,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
							,pt_i_ProgressIndicator   => gvv_ProgressIndicator
							,pt_i_ModuleMessage       => gvt_ModuleMessage
							,pt_i_OracleError         => gvt_ReturnMessage       );
					--
					RAISE;
					--** END e_ModuleError Exception
					--

				WHEN OTHERS then
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
								pt_i_ApplicationSuite    => vt_ApplicationSuite
							   ,pt_i_Application         => vt_Application
							   ,pt_i_BusinessEntity      => pt_i_BusinessEntity
							   ,pt_i_SubEntity           =>  vt_sub_entity
							   ,pt_i_MigrationSetID      => pt_i_MigrationSetID
							   ,pt_i_Phase               => gct_phase
							   ,pt_i_Severity            => 'ERROR'
							   ,pt_i_PackageName         => gct_PackageName
							   ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
							   ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
							   ,pt_i_ModuleMessage       => 'Oracle Error'
							   ,pt_i_OracleError         => gvt_OracleError
							   );

					--
					RAISE;
					-- Hr_Utility.raise_error@MXDM_NVIS_EXTRACT;
		end generate_csv_file;


END michal_pkg;

/
