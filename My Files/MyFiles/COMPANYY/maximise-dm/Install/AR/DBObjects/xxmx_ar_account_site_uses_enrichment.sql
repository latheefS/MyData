--------------------------------------------------------
--  File created - Wednesday-September-15-2021   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Procedure XXMX_AR_ACCOUNT_SITE_USES_ENRICHMENT
--------------------------------------------------------
set define off;

create or replace PROCEDURE   XXMX_AR_ACCOUNT_SITE_USES_ENRICHMENT
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_migration_metadata.business_entity%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                   )
     IS
          
     --
     /* Global Constants FOR use in all xxmx_utilities_pkg Procedure/Function Calls within this package */
     --
     gct_PackageName             CONSTANT xxmx_migration_metadata.entity_package_name%TYPE := 'ACCOUNT_SITE_USES_ENRICHMENT';
     gct_ApplicationSuite        CONSTANT xxmx_migration_metadata.application_suite%TYPE   := 'FIN';
     gct_Application             CONSTANT xxmx_migration_metadata.application%TYPE         := 'AR';
     gcv_SourceSystem            CONSTANT VARCHAR2(30)                                     := 'EBS';
     gct_phase                   CONSTANT xxmx_module_messages.phase%TYPE                  := 'TRANSFORM'; 
     -- In case the delimitter of the file creation changes
     gv_delim                   CONSTANT  VARCHAR2(4) := '|';
     -- have to add this to SELECT  from client config table   -- JEM
     gv_ClientCode      VARCHAR2(40) := 'SMBC';

     --
     /* Global Progress Indicator Variable FOR use in all Procedures/Functions within this package */
     --
     gvv_ProgressIndicator                              VARCHAR2(100);
     --
     /* Global Variables FOR receiving Status/Messages FROM certain Procedure/Function Calls (e.g. xxmx_utilities_pkg.clear_messages */
     --
     gvv_ReturnStatus                                   VARCHAR2(1);
     gvt_ReturnMessage                                  xxmx_module_messages.module_message%TYPE;
     --
     /* Global Variables FOR Exception Handlers */
     --
     gvt_Severity                                       xxmx_module_messages.severity%TYPE;
     gvt_ModuleMessage                                  xxmx_module_messages.module_message%TYPE;
     gvt_OracleError                                    xxmx_module_messages.oracle_error%TYPE;
     --
     /* Global Variable FOR Migration Set Name */
     --
     gvt_MigrationSetName                               xxmx_migration_headers.migration_set_name%TYPE;
     --
     /* Global constants and variables FOR dynamic SQL usage */
     --
     gcv_SQLSpace                             CONSTANT  VARCHAR2(1) := ' ';
     gvv_SQLAction                                      VARCHAR2(20);
     gvv_SQLTableClause                                 VARCHAR2(100);
     gvv_SQLColumnList                                  VARCHAR2(4000);
     gvv_SQLValuesList                                  VARCHAR2(4000);
     gvv_SQLWhereClause                                 VARCHAR2(4000);
     gvv_SQLStatement                                   VARCHAR2(32000);
     gvv_SQLResult                                      VARCHAR2(4000);

     --
     /* Global variables FOR holding table row counts */
     --
        gvn_RowCount                         NUMBER;

          /*********************
          ** Type Declarations
          *********************/
          --
          --
          /************************
          ** Constant Declarations
          *************************/
          --
          --
          cv_ProcOrFuncName           CONSTANT  VARCHAR2(30)                                := 'ACCOUNT_SITE_USES_ENRICHMENT';
          ct_file_location_type       CONSTANT xxmx_file_locations.file_location_type%TYPE  := 'FIN_INTERNAL';
          ct_StgTable                 CONSTANT xxmx_migration_metadata.stg_table%TYPE       := 'xxmx_hz_cust_site_uses_stg';  --XXMX_HZ_CUST_SITE_USES_STG

          cv_metadata              CONSTANT VARCHAR2(30) := 'METADATA';

          --
          /*************************
          ** Variable Declarations
          *************************/
          --
          --
          /****************************
          ** Record Table Declarations
          *****************************/
          --
          --
          --
          /**************************
          ** Exception Declarations
          **************************/
          --
          --** Set gvt_Severity, gvv_ProgressIndicator and gvt_ModuleMessage
          --** beFORe raising this exception.
          --
          e_ModuleError                   EXCEPTION;
          --
     --** END Declarations
     --
     --
     BEGIN

          --
          /*
          ** Initialise Procedure Global Variables
          */
          --
          gvv_ProgressIndicator := '0010';
          --
          gvv_ReturnStatus  := '';
          --
          /*
          ** Delete any MODULE messages FROM previous executions
          ** FOR the Business Entity and Business Entity Level
          */
          xxmx_utilities_pkg.clear_messages
               (
                pt_i_ApplicationSuite => gct_ApplicationSuite
               ,pt_i_Application      => gct_Application
               ,pt_i_BusinessEntity   => pt_i_BusinessEntity 
               ,pt_i_SubEntity        => pt_i_SubEntity
               ,pt_i_MigrationSetID   => NULL                 -- This is NULL so messages FOR all previous runs are deleted.
               ,pt_i_Phase            => gct_phase
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
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => gct_phase
                    ,pt_i_Severity          => 'ERROR'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
                    ,pt_i_OracleError       => NULL
                    );
               --
               RAISE e_ModuleError;
               --
          END IF;
          --
          gvv_ProgressIndicator := '0020';
          --
          gvv_ReturnStatus  := '';
          --
          /*
          ** Delete any DATA messages FROM previous executions
          ** FOR the Business Entity and Business Entity Level.
          **
          */
          --
          xxmx_utilities_pkg.clear_messages
               (
                pt_i_ApplicationSuite => gct_ApplicationSuite
               ,pt_i_Application      => gct_Application
               ,pt_i_BusinessEntity   => pt_i_BusinessEntity
               ,pt_i_SubEntity        => pt_i_SubEntity
               ,pt_i_MigrationSetID   => NULL                 -- This is NULL so messages FOR all previous runs are deleted.
               ,pt_i_Phase            => gct_phase
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
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => gct_phase
                    ,pt_i_Severity          => 'ERROR'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
                    ,pt_i_OracleError       => NULL
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
               ,pt_i_SubEntity         => pt_i_SubEntity
               ,pt_i_MigrationSetID    => pt_i_MigrationSetID
               ,pt_i_Phase             => gct_phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gct_PackageName
               ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'Procedure "'||gct_PackageName||'.'||cv_ProcOrFuncName||'" initiated.'
               ,pt_i_OracleError       => NULL
               );

            gvt_MigrationSetName := xxmx_utilities_pkg.get_migration_set_name(pt_i_MigrationSetID);
            --
            --
            gvv_ProgressIndicator := '0040';
            --
            xxmx_utilities_pkg.log_module_message
                              (
                               pt_i_ApplicationSuite  => gct_ApplicationSuite
                              ,pt_i_Application       => gct_Application
                              ,pt_i_BusinessEntity    => pt_i_BusinessEntity 
                              ,pt_i_SubEntity         => pt_i_SubEntity
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
            gvv_ProgressIndicator := '0050';            
            --
            xxmx_utilities_pkg.log_module_message
                              (
                               pt_i_ApplicationSuite  => gct_ApplicationSuite
                              ,pt_i_Application       => gct_Application
                              ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                              ,pt_i_SubEntity         => pt_i_SubEntity
                              ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                              ,pt_i_Phase             => gct_phase
                              ,pt_i_Severity          => 'NOTIFICATION'
                              ,pt_i_PackageName       => gct_PackageName
                              ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                              ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                              ,pt_i_ModuleMessage     => 'Insert STMT account site usage '
                              ,pt_i_OracleError       => NULL
                              );
            --
            gvv_ProgressIndicator := '0050';
            insert into  XXMX_HZ_CUST_SITE_USES_STG
                (
                MIGRATION_SET_ID, MIGRATION_SET_NAME, MIGRATION_STATUS, CUST_SITE_ORIG_SYSTEM, CUST_SITE_ORIG_SYS_REF, CUST_SITEUSE_ORIG_SYSTEM,
                CUST_SITEUSE_ORIG_SYS_REF, SITE_USE_CODE, PRIMARY_FLAG, INSERT_UPDATE_FLAG, LOCATION, SET_CODE, START_DATE, END_DATE,
                ATTRIBUTE_CATEGORY, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10,
                ATTRIBUTE11, ATTRIBUTE12, ATTRIBUTE13, ATTRIBUTE14, ATTRIBUTE15, ATTRIBUTE16, ATTRIBUTE17, ATTRIBUTE18, ATTRIBUTE19, ATTRIBUTE20,
                ATTRIBUTE21, ATTRIBUTE22, ATTRIBUTE23, ATTRIBUTE24, ATTRIBUTE25, ATTRIBUTE26, ATTRIBUTE27, ATTRIBUTE28, ATTRIBUTE29, ATTRIBUTE30,
                ACCOUNT_NUMBER, PARTY_SITE_NUMBER, LOAD_REQUEST_ID, CREATION_DATE, CREATED_BY, LAST_UPDATE_DATE, LAST_UPDATED_BY, OU_NAME
                )
            select
                MIGRATION_SET_ID, MIGRATION_SET_NAME, MIGRATION_STATUS, CUST_SITE_ORIG_SYSTEM, CUST_SITE_ORIG_SYS_REF, CUST_SITEUSE_ORIG_SYSTEM,
                CUST_SITEUSE_ORIG_SYS_REF||'.1', 'STMTS', PRIMARY_FLAG, INSERT_UPDATE_FLAG, LOCATION, SET_CODE, START_DATE, END_DATE,
                ATTRIBUTE_CATEGORY, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10,
                ATTRIBUTE11, ATTRIBUTE12, ATTRIBUTE13, ATTRIBUTE14, ATTRIBUTE15, ATTRIBUTE16, ATTRIBUTE17, ATTRIBUTE18, ATTRIBUTE19, ATTRIBUTE20,
                ATTRIBUTE21, ATTRIBUTE22, ATTRIBUTE23, ATTRIBUTE24, ATTRIBUTE25, ATTRIBUTE26, ATTRIBUTE27, ATTRIBUTE28, ATTRIBUTE29, ATTRIBUTE30,
                ACCOUNT_NUMBER, PARTY_SITE_NUMBER, LOAD_REQUEST_ID, CREATION_DATE, CREATED_BY, LAST_UPDATE_DATE, LAST_UPDATED_BY, OU_NAME
            from  XXMX_HZ_CUST_SITE_USES_STG STG
            where STG.MIGRATION_SET_ID    = pt_i_MigrationSetID
            and   STG.site_use_code       = 'BILL_TO'
            and   STG.primary_flag        = 'Y'
            and   not exists 
                  (select 1 from XXMX_HZ_CUST_SITE_USES_STG STG1 where STG1.MIGRATION_SET_ID=STG.MIGRATION_SET_ID 
                   and STG1.CUST_SITE_ORIG_SYS_REF=STG.CUST_SITE_ORIG_SYS_REF and STG1.site_use_code = 'STMTS');
            --
            gvv_ProgressIndicator := '0060';
            insert into  XXMX_HZ_CUST_SITE_USES_STG
                (
                MIGRATION_SET_ID, MIGRATION_SET_NAME, MIGRATION_STATUS, CUST_SITE_ORIG_SYSTEM, CUST_SITE_ORIG_SYS_REF, CUST_SITEUSE_ORIG_SYSTEM,
                CUST_SITEUSE_ORIG_SYS_REF, SITE_USE_CODE, PRIMARY_FLAG, INSERT_UPDATE_FLAG, LOCATION, SET_CODE, START_DATE, END_DATE,
                ATTRIBUTE_CATEGORY, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10,
                ATTRIBUTE11, ATTRIBUTE12, ATTRIBUTE13, ATTRIBUTE14, ATTRIBUTE15, ATTRIBUTE16, ATTRIBUTE17, ATTRIBUTE18, ATTRIBUTE19, ATTRIBUTE20,
                ATTRIBUTE21, ATTRIBUTE22, ATTRIBUTE23, ATTRIBUTE24, ATTRIBUTE25, ATTRIBUTE26, ATTRIBUTE27, ATTRIBUTE28, ATTRIBUTE29, ATTRIBUTE30,
                ACCOUNT_NUMBER, PARTY_SITE_NUMBER, LOAD_REQUEST_ID, CREATION_DATE, CREATED_BY, LAST_UPDATE_DATE, LAST_UPDATED_BY, OU_NAME
                )
            select
                MIGRATION_SET_ID, MIGRATION_SET_NAME, MIGRATION_STATUS, CUST_SITE_ORIG_SYSTEM, CUST_SITE_ORIG_SYS_REF, CUST_SITEUSE_ORIG_SYSTEM,
                CUST_SITEUSE_ORIG_SYS_REF||'.2', 'DUN', PRIMARY_FLAG, INSERT_UPDATE_FLAG, LOCATION, SET_CODE, START_DATE, END_DATE,
                ATTRIBUTE_CATEGORY, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10,
                ATTRIBUTE11, ATTRIBUTE12, ATTRIBUTE13, ATTRIBUTE14, ATTRIBUTE15, ATTRIBUTE16, ATTRIBUTE17, ATTRIBUTE18, ATTRIBUTE19, ATTRIBUTE20,
                ATTRIBUTE21, ATTRIBUTE22, ATTRIBUTE23, ATTRIBUTE24, ATTRIBUTE25, ATTRIBUTE26, ATTRIBUTE27, ATTRIBUTE28, ATTRIBUTE29, ATTRIBUTE30,
                ACCOUNT_NUMBER, PARTY_SITE_NUMBER, LOAD_REQUEST_ID, CREATION_DATE, CREATED_BY, LAST_UPDATE_DATE, LAST_UPDATED_BY, OU_NAME
            from  XXMX_HZ_CUST_SITE_USES_STG STG
            where STG.MIGRATION_SET_ID    = pt_i_MigrationSetID
            and   STG.site_use_code       = 'BILL_TO'
            and   STG.primary_flag        = 'Y'
            and   not exists 
                  (select 1 from XXMX_HZ_CUST_SITE_USES_STG STG1 where STG1.MIGRATION_SET_ID=STG.MIGRATION_SET_ID 
                   and STG1.CUST_SITE_ORIG_SYS_REF=STG.CUST_SITE_ORIG_SYS_REF and STG1.site_use_code = 'DUN');
            --
            -- Create BILL-TO usage for customer sites which are used in the AR receipts but dont have BILL-TO as usage in EBS.
            --
            gvv_ProgressIndicator := '0070';
            insert into  XXMX_HZ_CUST_SITE_USES_STG
                (
                MIGRATION_SET_ID, MIGRATION_SET_NAME, MIGRATION_STATUS, CUST_SITE_ORIG_SYSTEM, CUST_SITE_ORIG_SYS_REF, CUST_SITEUSE_ORIG_SYSTEM,
                CUST_SITEUSE_ORIG_SYS_REF, SITE_USE_CODE, PRIMARY_FLAG, INSERT_UPDATE_FLAG, LOCATION, SET_CODE, START_DATE, END_DATE,
                ATTRIBUTE_CATEGORY, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10,
                ATTRIBUTE11, ATTRIBUTE12, ATTRIBUTE13, ATTRIBUTE14, ATTRIBUTE15, ATTRIBUTE16, ATTRIBUTE17, ATTRIBUTE18, ATTRIBUTE19, ATTRIBUTE20,
                ATTRIBUTE21, ATTRIBUTE22, ATTRIBUTE23, ATTRIBUTE24, ATTRIBUTE25, ATTRIBUTE26, ATTRIBUTE27, ATTRIBUTE28, ATTRIBUTE29, ATTRIBUTE30,
                ACCOUNT_NUMBER, PARTY_SITE_NUMBER, LOAD_REQUEST_ID, CREATION_DATE, CREATED_BY, LAST_UPDATE_DATE, LAST_UPDATED_BY, OU_NAME
                )
            select
                hzcass.MIGRATION_SET_ID, hzcass.MIGRATION_SET_NAME, hzcass.MIGRATION_STATUS, hzcass.CUST_SITE_ORIG_SYSTEM, hzcass.CUST_SITE_ORIG_SYS_REF, hzcass.CUST_SITE_ORIG_SYSTEM,
                ebs_site_uses.site_use_id, 'BILL_TO', 'N', null, ebs_site_uses.LOCATION, SET_CODE, hzcass.START_DATE, null,
                null, null, null, null, null, null, null, null, null, null, null,
                null, null, null, null, null, null, null, null, null, null,
                null, null, null, null, null, null, null, null, null, null,
                ACCOUNT_NUMBER, PARTY_SITE_NUMBER, hzcass.LOAD_REQUEST_ID, hzcass.CREATION_DATE, hzcass.CREATED_BY,hzcass. LAST_UPDATE_DATE, hzcass.LAST_UPDATED_BY, hzcass.OU_NAME
            from 
                xxmx_hz_cust_acct_sites_stg                                            hzcass, 
                apps.hz_cust_site_uses_all@MXDM_NVIS_EXTRACT       ebs_site_uses
            where  
                migration_set_id                                       =  pt_i_MigrationSetID
                and        ebs_site_uses.cust_acct_site_id =  substr(CUST_SITE_ORIG_SYS_REF,instr(CUST_SITE_ORIG_SYS_REF,'-')+1) 
                and         ebs_site_uses.SITE_USE_CODE = 'BILL_TO'
                and  ebs_site_uses.creation_date = (select min(creation_date) from apps.hz_cust_site_uses_all@MXDM_NVIS_EXTRACT ebs_site_uses1 where ebs_site_uses1.cust_acct_site_id=ebs_site_uses.cust_acct_site_id)
                and (cust_orig_system_reference,cust_site_orig_sys_ref) in
                (
                select distinct hca.account_number, hca.CUST_ACCOUNT_ID||'-'||hcsu.CUST_ACCT_SITE_ID
                from
                    xxmx_ar_cash_receipts_scope_v                                       xacrsv,
                    apps.ar_cash_receipts_all@MXDM_NVIS_EXTRACT        acra,
                    apps.hz_cust_accounts@MXDM_NVIS_EXTRACT             hca,
                    apps.hz_cust_site_uses_all@MXDM_NVIS_EXTRACT      hcsu
                where
                    acra.org_id                                                = xacrsv.org_id
                    and       acra.cash_receipt_id                    = xacrsv.cash_receipt_id
                    and       hca.cust_account_id                     = xacrsv.customer_id    
                    and  hca.cust_account_id                          = acra.pay_from_customer
                    and hcsu.site_use_id(+)                             = acra.customer_site_use_id
                    and customer_site_use_id                        is not null
                minus
                select cas.cust_orig_system_reference,cas.cust_site_orig_sys_ref
                from xxmx_hz_cust_acct_sites_stg cas, xxmx_hz_cust_site_uses_stg su  
                where cas. migration_set_id          = pt_i_MigrationSetID
                and     cas.migration_set_id           = su.migration_set_id
                and     cas.cust_site_orig_sys_ref  = su.cust_site_orig_sys_ref
                and     su.site_use_code                  = 'BILL_TO'
                )
            ;
            --
            commit;
 --
 exception
 when others then 
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => gct_phase
                    ,pt_i_Severity          => 'ERROR'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => substr(sqlerrm,1,2000)
                    ,pt_i_OracleError       => NULL
                    );
               --
               RAISE e_ModuleError;

END XXMX_AR_ACCOUNT_SITE_USES_ENRICHMENT;

/
