create or replace PACKAGE BODY xxmx_users_pkg AS
     /*
     **********************
     ** Global Declarations
     **********************
     */
     --
     /* Maximise Integration Globals */
     --
     /* Global Constants for use in all xxmx_utilities_pkg Procedure/Function Calls within this package */
     --
     gcv_PackageName                           CONSTANT VARCHAR2(30)                                 := 'xxmx_users_pkg';
     gct_ApplicationSuite                      CONSTANT xxmx_module_messages.application_suite%TYPE  := 'HCM';
     gct_Application                           CONSTANT xxmx_module_messages.application%TYPE        := 'FND';
     gct_StgSchema                             CONSTANT VARCHAR2(10)                                 := 'xxmx_stg';
     gct_XfmSchema                             CONSTANT VARCHAR2(10)                                 := 'xxmx_xfm';
     gct_CoreSchema                            CONSTANT VARCHAR2(10)                                 := 'xxmx_core';
     gcv_BusinessEntity                        CONSTANT xxmx_migration_metadata.business_entity%TYPE := 'USERS';
     gct_OrigSystem                            CONSTANT VARCHAR2(10)                                 := 'ORACLER12';
     --
     /* Global Progress Indicator Variable for use in all Procedures/Functions within this package */
     --
     gvv_ProgressIndicator                              VARCHAR2(100);
     --
     /* Global Variables for receiving Status/Messages from certain Procedure/Function Calls (e.g. xxmx_utilities_pkg.clear_messages */
     --
     gvv_ReturnStatus                                   VARCHAR2(1);
     gvt_ReturnMessage                                  xxmx_module_messages.module_message%TYPE;
     --
     /* Global Variables for Exception Handlers */
     --
     gvt_Severity                                       xxmx_module_messages.severity%TYPE;
     gvt_ModuleMessage                                  xxmx_module_messages.module_message%TYPE;
     gvt_OracleError                                    xxmx_module_messages.oracle_error%TYPE;
     --
     /* Global Variables for Exception Handlers */
     --
     gvt_MigrationSetName                               xxmx_migration_headers.migration_set_name%TYPE;
     --
     /* Global constants and variables for dynamic SQL usage */
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
     /* Global variables for holding table row counts */
     --
     gvn_RowCount                                       NUMBER;
     --
     --
procedure users_stg
(
     p_bg_name                      in      VARCHAR2
    ,p_bg_id                        in      NUMBER
    ,pt_i_MigrationSetID            in      xxmx_migration_headers.migration_set_id%TYPE
    ,pt_i_MigrationSetName          in      xxmx_migration_headers.migration_set_name%TYPE
)
is
     gcv_SubEntity                             CONSTANT VARCHAR2(10)                                 := 'USERS';
    --
    -- Cursor to fetch all current user accounts
    --
    cursor user_cur (p_effective_date date) is
        SELECT distinct
            'MERGE'                                                  as metadata
            ,'User'                                               as record_type
            ,nvl(xxmx_current_emp.employee_number,NPW_NUMBER)   as person_number
            ,fu.user_name                                      as orig_user_name
            ,fu.user_name                                       as new_user_name
            ,'N'                                       as credentials_email_sent
            ,'Y'                                        as generate_user_account
        FROM 
            applsys.fnd_user@xxmx_extract                   fu,
            fnd_user_resp_groups_direct@xxmx_extract        furg,
            applsys.fnd_responsibility@xxmx_extract         fr,
            applsys.fnd_responsibility_tl@xxmx_extract      frt,
            xxmx_user_scope                                 xxus,
            XXMX_HCM_WORKERS_SCOPE                          xxmx_current_emp
            --xxmx_per_persons_stg                            xxmx_current_emp
        WHERE furg.user_id                       =  fu.user_id
        AND furg.responsibility_id               =  fr.responsibility_id
        AND fr.responsibility_id                 =  frt.responsibility_id
        AND frt.language                         =  USERENV('LANG')
        and xxus.user_name                       = fu.user_name
        AND fu.employee_id                       = xxmx_current_emp.person_id
        and p_effective_date between xxmx_current_emp.EFFECTIVE_START_DATE and xxmx_current_emp.EFFECTIVE_END_DATE
        --
        AND fu.user_name                        not like 'V1_%'
        and fu.employee_id                      is not null
        AND nvl(fu.end_date,sysdate+1)          >= TRUNC(SYSDATE)
        AND nvl(furg.end_date,sysdate+1)        >= TRUNC(SYSDATE)
        AND xxmx_current_emp.user_person_type   in ('Employee','Contingent Worker')
        and fu.user_name                        = xxus.user_name
        ;
        --
    gvv_effective_date                          varchar2(30);
    gvd_effective_date                          date;
    -- ********************
    -- ** Type Declarations
    -- ********************
    --
    TYPE user_tt IS TABLE OF user_cur%ROWTYPE INDEX BY BINARY_INTEGER;
              --
              --
              --************************
              --** Constant Declarations
              --************************
              --
              cv_ProcOrFuncName               CONSTANT  VARCHAR2(30)                                    := 'users_stg';
              ct_Phase                        CONSTANT  xxmx_module_messages.phase%TYPE                 := 'EXTRACT';
              ct_StgTable                     CONSTANT  xxmx_migration_metadata.stg_table%TYPE          := 'xxmx_user_stg';
              --
              --****************************
              --** PL/SQL Table Declarations
              --****************************
              --
              user_tbl                     user_tt;
              --
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
     --** END Declarations
     --
     --
begin
    --
    gvv_ProgressIndicator := '0010';
    --
    delete from xxmx_stg.xxmx_user_stg;
    delete from xxmx_stg.xxmx_resp_stg;
    delete from xxmx_xfm.xxmx_user_xfm;
    delete from xxmx_xfm.xxmx_resp_xfm;
    delete from xxmx_xfm.xxmx_user_data_access_xfm;
    delete from XXMX_PO_AGENT;
    delete from XXMX_PO_AGENT_ACCESS;
    update XXMX_MIGRATION_USERS_AND_ROLES set user_name=upper(user_name),cloud_role=trim(cloud_role),role_group_name=trim(role_group_name);
    update XXMX_MIGRATION_ROLE_GROUPS     set group_name=trim(group_name);
    update XXMX_MIGRATION_CLOUD_ROLES     set security_context='Business unit' where upper(security_context) = 'BUSINESS UNIT';
    update XXMX_MIGRATION_ROLE_GROUPS     set security_context='Business unit' where upper(security_context) = 'BUSINESS UNIT';
--
    gvv_ReturnStatus  := '';
    gvt_ReturnMessage := '';
    xxmx_utilities_pkg.clear_messages
               (
                pt_i_ApplicationSuite    => gct_ApplicationSuite
               ,pt_i_Application         => gct_Application
               ,pt_i_BusinessEntity      => gcv_BusinessEntity
               ,pt_i_SubEntity           => gcv_SubEntity
               ,pt_i_MigrationSetID      => NULL                 -- This is NULL so messages for all previous runs are deleted.
               ,pt_i_Phase               => ct_Phase
               ,pt_i_MessageType         => 'MODULE'
               ,pv_o_ReturnStatus        => gvv_ReturnStatus
               );
    --
    gvv_ProgressIndicator :='0015';
    --
    if gvv_ReturnStatus = 'F' then
        xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gcv_BusinessEntity
                    ,pt_i_SubEntity           => gcv_SubEntity
                    ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                    ,pt_i_Severity            => 'ERROR'
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => 'ORACLE error in called procedure "xxmx_utilities_pkg.clear_messages".'
                    ,pt_i_OracleError         => gvt_ReturnMessage
                    );
        raise e_ModuleError;
    end if;
    --
    gvv_ProgressIndicator :='0020';
    --
    gvv_ReturnStatus  := '';
    gvt_ReturnMessage := '';
    --
    xxmx_utilities_pkg.clear_messages
               (
                pt_i_ApplicationSuite    => gct_ApplicationSuite
               ,pt_i_Application         => gct_Application
               ,pt_i_BusinessEntity      => gcv_BusinessEntity
               ,pt_i_SubEntity           => gcv_SubEntity
               ,pt_i_Phase               => ct_Phase
               ,pt_i_MessageType         => 'DATA'
               ,pv_o_ReturnStatus        => gvv_ReturnStatus
               );
    --
    IF gvv_ReturnStatus = 'F' THEN
        xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gcv_BusinessEntity
                    ,pt_i_SubEntity           => gcv_SubEntity
                    ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                    ,pt_i_Severity            => 'ERROR'
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => 'ORACLE error in called procedure "xxmx_utilities_pkg.clear_messages".'
                    ,pt_i_OracleError         => gvt_ReturnMessage
                    );
        raise e_ModuleError;
    end if;
    --
    gvv_ProgressIndicator :='0030';
    --
    xxmx_utilities_pkg.log_module_message
               (
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gcv_BusinessEntity
                    ,pt_i_SubEntity           => gcv_SubEntity
                    ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                    ,pt_i_Severity            => 'NOTIFICATION'
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => 'Procedure "'||gcv_PackageName||'.'||cv_ProcOrFuncName||'" initiated.'
                    ,pt_i_OracleError         => NULL
               );
    --
    -- Retrieve the Migration Set Name
    --
    gvv_ProgressIndicator :='0040';
    gvt_MigrationSetName := xxmx_utilities_pkg.get_migration_set_name(pt_i_MigrationSetID);
    --
    -- If the Migration Set Name is NULL then the Migration has not been initialized.
    --
    if gvt_MigrationSetName IS NOT NULL THEN
        --
        gvv_ProgressIndicator :='0050';
        --
        xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gcv_BusinessEntity
                    ,pt_i_SubEntity           => gcv_SubEntity
                    ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                    ,pt_i_Severity            => 'NOTIFICATION'
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => 'Extracting "USERS":'
                    ,pt_i_OracleError         => NULL
                    );
        --
        --
        -- The Migration Set has been initialized so now initialize the detail record
        -- for the current entity.
        xxmx_utilities_pkg.init_migration_details
                    (
                     pt_i_ApplicationSuite       => gct_ApplicationSuite
                    ,pt_i_Application            => gct_Application
                    ,pt_i_BusinessEntity         => gcv_BusinessEntity
                    ,pt_i_SubEntity              => gcv_SubEntity
                    ,pt_i_MigrationSetID         => pt_i_MigrationSetID
                    ,pt_i_StagingTable           => ct_StgTable
                    ,pt_i_ExtractStartDate       => SYSDATE
                    );
        --
        xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gcv_BusinessEntity
                    ,pt_i_SubEntity           => gcv_SubEntity
                    ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                    ,pt_i_Severity            => 'NOTIFICATION'
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => 'Staging Table "'||ct_StgTable||'" reporting details initialised.'
                    ,pt_i_OracleError         => NULL
                    );
               --
        gvv_ProgressIndicator :='0060';
        --
        --** Extract the AR Customer and insert into the staging table.
        --
        xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gcv_BusinessEntity
                    ,pt_i_SubEntity           => gcv_SubEntity
                    ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                    ,pt_i_Severity            => 'NOTIFICATION'
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => 'Extracting data into "'||ct_StgTable||'".'
                    ,pt_i_OracleError         => NULL
                    );
        --
        --
        gvv_effective_date := xxmx_utilities_pkg.get_single_parameter_value(
                         pt_i_ApplicationSuite           =>     'HCM'
                        ,pt_i_Application                =>     'HR'
                        ,pt_i_BusinessEntity             =>     'HCMEMPLOYEE'
                        ,pt_i_SubEntity                  =>     'ALL'
                        ,pt_i_ParameterCode              =>     'MIGRATE_DATE_FROM'
        );        
       gvd_effective_date := TO_DATE(gvv_effective_date,'YYYY-MM-DD');

        gvv_ProgressIndicator :='0061';
        OPEN user_cur (gvd_effective_date);
            --
            LOOP
            --
            gvv_ProgressIndicator :='0070';
            --
            FETCH user_cur
                BULK COLLECT
                INTO user_tbl
                LIMIT        xxmx_utilities_pkg.gcn_BulkCollectLimit;
                EXIT WHEN    user_tbl.COUNT = 0;
            --
            gvv_ProgressIndicator := '0080';
            --
            FORALL i IN 1..user_tbl.count
                INSERT INTO xxmx_stg.xxmx_user_stg
                    (
                         migration_set_id
                        ,migration_set_name
                        ,migration_status
                        ,metadata
                        ,source_system_id
                        ,source_system_owner
                        ,record_type
                        ,person_number
                        ,orig_user_name      
                        ,new_user_name
                        ,CREDENTIAL_EMAIL_SENT
                        ,GENERATE_USER_ACCOUNT
                    )
                    values 
                    (
                         pt_i_MigrationSetID
                        ,gvt_MigrationSetName
                        ,'EXTRACTED'
                        ,'MERGE'
                        ,user_tbl(i).person_number
                        ,'EBS'
                        ,'User'
                        ,user_tbl(i).person_number
                        ,user_tbl(i).orig_user_name
                        ,user_tbl(i).new_user_name
                        ,'N'
                        ,'Y'
                    );
            END LOOP;
            --
            --
            gvv_ProgressIndicator :='0100';
            CLOSE user_cur;
            --
            -- Additional users/Roles
            gvv_ProgressIndicator :='0110';
            insert into xxmx_stg.xxmx_user_stg
                (
                     migration_set_id
                    ,migration_set_name
                    ,migration_status
                    ,metadata
                    ,source_system_id
                    ,source_system_owner
                    ,record_type
                    ,person_number
                    ,orig_user_name      
                    ,new_user_name      
                    ,CREDENTIAL_EMAIL_SENT
                    ,GENERATE_USER_ACCOUNT
                )
                select distinct
                     pt_i_MigrationSetID
                    ,gvt_MigrationSetName
                    ,'EXTRACTED'
                    ,'MERGE'
                    ,xurtm.employee_number
                    ,'EBS'
                    ,'User'
                    ,xurtm.employee_number
                    ,xurtm.user_name
                    ,xurtm.user_name
                    ,'N'
                    ,'Y'
                from 
                    XXMX_MIGRATION_USERS_AND_ROLES           xurtm,
                    fnd_user@xxmx_extract               fu,
                    XXMX_HCM_WORKERS_SCOPE              xxmx_current_emp
                where xurtm.user_name        = fu.user_name
                and   fu.employee_id         = xxmx_current_emp.person_id
                and   gvd_effective_date between xxmx_current_emp.EFFECTIVE_START_DATE and xxmx_current_emp.EFFECTIVE_END_DATE
                and   not exists
                (   select 1 from xxmx_stg.xxmx_user_stg STG where STG.orig_user_name=xurtm.user_name )
                ;
            --
            -- Save changes
            gvv_ProgressIndicator :='0120';
            COMMIT;
            --
            --
            --
            -- Obtain the count of rows inserted.  We cannot use SQL$ROWCOUNT here because of the LIMIT
            -- clause on the BULK COLLECT statement.  The rowcount will be reset each time the limit
            -- is reached.
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
                    ,pt_i_BusinessEntity      => gcv_BusinessEntity
                    ,pt_i_SubEntity           => gcv_SubEntity
                    ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                    ,pt_i_Severity            => 'NOTIFICATION'
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => '  - Extraction complete.'
                    ,pt_i_OracleError         => NULL
                    );
            --
            --
            -- Update the migration details (Migration status will be automatically determined
            -- in the called procedure dependant on the Phase and if an Error Message has been
            -- passed).
            --
            gvv_ProgressIndicator :='0110';
            --
            xxmx_utilities_pkg.upd_migration_details
                        (
                     pt_i_MigrationSetID          => pt_i_MigrationSetID
                    ,pt_i_BusinessEntity          => gcv_BusinessEntity
                    ,pt_i_SubEntity               => gcv_SubEntity
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
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gcv_BusinessEntity
                    ,pt_i_SubEntity           => gcv_SubEntity
                    ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                    ,pt_i_Severity            => 'NOTIFICATION'
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => '  - Migration Table "'
                                                 ||ct_StgTable
                                                 ||'" reporting details updated.'
                    ,pt_i_OracleError         => NULL
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
        raise e_ModuleError;
        --
    end if;
    --
    xxmx_utilities_pkg.log_module_message
               (
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gcv_BusinessEntity
                    ,pt_i_SubEntity           => gcv_SubEntity
                    ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                    ,pt_i_Severity            => 'NOTIFICATION'
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => 'Procedure "'
                                                 ||gcv_PackageName
                                                 ||'.'
                                                 ||cv_ProcOrFuncName
                                                 ||'" completed.'
                    ,pt_i_OracleError         => NULL
                    );
    --
          --
EXCEPTION
    --
    WHEN e_ModuleError THEN
        IF user_cur%ISOPEN THEN
            CLOSE user_cur;
        end if;
        ROLLBACK;
        --
        xxmx_utilities_pkg.log_module_message
                        (
                         pt_i_ApplicationSuite    => gct_ApplicationSuite
                        ,pt_i_Application         => gct_Application
                        ,pt_i_BusinessEntity      => gcv_BusinessEntity
                        ,pt_i_SubEntity           => gcv_SubEntity
                        ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                        ,pt_i_Phase               => ct_Phase
                        ,pt_i_PackageName         => gcv_PackageName
                        ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                        ,pt_i_Severity            => gvt_Severity
                        ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                        ,pt_i_ModuleMessage       => gvt_ModuleMessage
                        ,pt_i_OracleError         => NULL
                        );
        --
        RAISE;
    WHEN OTHERS THEN
        IF user_cur%ISOPEN THEN
            CLOSE user_cur;
        end if;
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
                          pt_i_ApplicationSuite     => gct_ApplicationSuite
                         ,pt_i_Application          => gct_Application
                         ,pt_i_BusinessEntity       => gcv_BusinessEntity
                         ,pt_i_SubEntity            => gcv_SubEntity
                         ,pt_i_MigrationSetID       => pt_i_MigrationSetID
                         ,pt_i_Phase                => ct_Phase
                         ,pt_i_PackageName          => gcv_PackageName
                         ,pt_i_ProcOrFuncName       => cv_ProcOrFuncName
                         ,pt_i_Severity             => 'ERROR'
                         ,pt_i_ProgressIndicator    => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage        => 'Oracle error encounted at after Progress Indicator.'
                         ,pt_i_OracleError          => gvt_OracleError
                         );
        --
        RAISE;
    --
end users_stg;
--
-- -----------------------------------------------------------------------------
-- ------------------------------- < resp_stg > --------------------------------
-- -----------------------------------------------------------------------------
PROCEDURE resp_stg
(
     p_bg_name                      in      VARCHAR2
    ,p_bg_id                        in      NUMBER
    ,pt_i_MigrationSetID   IN      xxmx_migration_headers.migration_set_id%TYPE
    ,pt_i_MigrationSetName          in      xxmx_migration_headers.migration_set_name%TYPE
)
IS
     gcv_SubEntity                             CONSTANT VARCHAR2(10)                                 := 'RESP';
    --
    -- Cursor to fetch all current user accounts
    --
    CURSOR resp_cur (p_effective_date date) is
        SELECT distinct
             'MERGE'                                                 as metadata
            ,'UserRole'                                           as record_type
            ,nvl(xxmx_current_emp.employee_number,NPW_NUMBER)  as person_number
            --,PERSONNUMBER                                       as person_number
            ,fu.user_name                                      as orig_user_name
            ,fu.user_name                                       as new_user_name
            ,fr.responsibility_key                         as responsibility_key
            ,frt.responsibility_name                      as responsibility_name
            ,fa.application_short_name                 as application_short_name
        FROM 
            applsys.fnd_user@xxmx_extract                   fu,
            fnd_user_resp_groups_direct@xxmx_extract        furg,
            applsys.fnd_responsibility@xxmx_extract         fr,
            applsys.fnd_application_tl@xxmx_extract         fat,
            applsys.fnd_application@xxmx_extract            fa,
            applsys.fnd_responsibility_tl@xxmx_extract      frt,
            xxmx_user_scope                                 xxus,
            XXMX_HCM_WORKERS_SCOPE                          xxmx_current_emp
            --xxmx_per_persons_stg                            xxmx_current_emp
        WHERE furg.user_id                       =  fu.user_id
        AND furg.responsibility_id               =  fr.responsibility_id
        AND fr.responsibility_id                 =  frt.responsibility_id
        AND frt.language                         =  USERENV('LANG')
        AND fu.employee_id                       = xxmx_current_emp.person_id
        and fa.application_id                    = fat.application_id
        and fa.application_id                    = fr.application_id
        --
        AND fu.user_name                        not like 'V1_%'
        and fu.employee_id                      is not null
        AND nvl(fu.end_date,sysdate+1)          >= TRUNC(SYSDATE)
        AND nvl(furg.end_date,sysdate+1)        >= TRUNC(SYSDATE)
        AND xxmx_current_emp.user_person_type   in ('Employee','Contingent Worker')
        and p_effective_date between xxmx_current_emp.EFFECTIVE_START_DATE and xxmx_current_emp.EFFECTIVE_END_DATE
        and fu.user_name                        = xxus.user_name
        ;
    --
    --
    gvv_migrate_resp                            varchar2(30);
    gvv_effective_date                          varchar2(30);
    gvd_effective_date                          date;
              --** END CURSOR **
              --
              --
              --********************
              --** Type Declarations
              --********************
              --
                TYPE responsibility_tt IS TABLE OF resp_cur%ROWTYPE INDEX BY BINARY_INTEGER;
              --
              --
              --************************
              --** Constant Declarations
              --************************
              cv_ProcOrFuncName               CONSTANT  VARCHAR2(30)                                    := 'resp_stg';
              ct_Phase                        CONSTANT  xxmx_module_messages.phase%TYPE                 := 'EXTRACT';
              ct_StgTable                     CONSTANT  xxmx_migration_metadata.stg_table%TYPE          := 'xxmx_resp_stg';
              --
              --************************
              --** Variable Declarations
              --************************
              --
              --
              --****************************
              --** Record Table Declarations
              --****************************
              --
              --
              --
              --****************************
              --** PL/SQL Table Declarations
              --****************************
              --

            responsibility_tbl                 responsibility_tt;
              --
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
     --** END Declarations
     --
     --
begin
    --
    gvv_ProgressIndicator :='0010';
    gvv_ReturnStatus  := '';
    gvt_ReturnMessage := '';
    --
    -- Delete any MODULE messages from previous executions
    -- for the Business Entity and Business Entity Level
    xxmx_utilities_pkg.clear_messages
               (
                pt_i_ApplicationSuite    => gct_ApplicationSuite
               ,pt_i_Application         => gct_Application
               ,pt_i_BusinessEntity      => gcv_BusinessEntity
               ,pt_i_SubEntity           => gcv_SubEntity
               ,pt_i_Phase               => ct_Phase
               ,pt_i_MessageType         => 'MODULE'
               ,pv_o_ReturnStatus        => gvv_ReturnStatus
               );
          --
          --
    IF gvv_ReturnStatus = 'F' THEN
        --
        xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gcv_BusinessEntity
                    ,pt_i_SubEntity           => gcv_SubEntity
                    ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                    ,pt_i_Severity            => 'ERROR'
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => '- Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
                    ,pt_i_OracleError         => gvt_ReturnMessage
                    );
        raise e_ModuleError;
   end if;
    --
    --
    gvv_ProgressIndicator :='0020';
    gvv_ReturnStatus  := '';
    gvt_ReturnMessage := '';
          --
          --
          /*
          ** Delete any DATA messages from previous executions
          ** for the Business Entity and Business Entity Level.
          **
          ** There should not be any DATA messages issued from
          ** within Extract procedures so this is here as an
          ** example that can be copied into Transform/enrichment
          ** procedures as those procedures SHOULD be issuing
          ** data messages as part of any validation they perform.
          */
          --
          --
    xxmx_utilities_pkg.clear_messages
               (
                pt_i_ApplicationSuite    => gct_ApplicationSuite
               ,pt_i_Application         => gct_Application
               ,pt_i_BusinessEntity      => gcv_BusinessEntity
               ,pt_i_SubEntity           => gcv_SubEntity
               ,pt_i_MigrationSetID      => NULL                 -- This is NULL so messages for all previous runs are deleted.
               ,pt_i_Phase               => ct_Phase
               ,pt_i_MessageType         => 'DATA'
               ,pv_o_ReturnStatus        => gvv_ReturnStatus
               );
          --
          --
    IF   gvv_ReturnStatus = 'F' THEN
        xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gcv_BusinessEntity
                    ,pt_i_SubEntity           => gcv_SubEntity
                    ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                    ,pt_i_Severity            => 'ERROR'
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => '- Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
                    ,pt_i_OracleError         => gvt_ReturnMessage
                    );
        raise e_ModuleError;
    end if;
          --
          --
    gvv_ProgressIndicator :='0030';
    xxmx_utilities_pkg.log_module_message
               (
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gcv_BusinessEntity
                    ,pt_i_SubEntity           => gcv_SubEntity
                    ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                    ,pt_i_Severity            => 'NOTIFICATION'
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => 'Procedure "'
                                                 ||gcv_PackageName
                                                 ||'.'
                                                 ||cv_ProcOrFuncName
                                                 ||'" initiated.'
                    ,pt_i_OracleError         => NULL
               );
    --
    -- Retrieve the Migration Set Name
    gvv_ProgressIndicator :='0040';
    gvt_MigrationSetName := xxmx_utilities_pkg.get_migration_set_name(pt_i_MigrationSetID);
    --
    gvv_ProgressIndicator := '0050';
    if gvt_MigrationSetName IS NOT NULL THEN
        -- If the Migration Set Name is NULL then the Migration has not been initialized.
        xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gcv_BusinessEntity
                    ,pt_i_SubEntity           => gcv_SubEntity
                    ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                    ,pt_i_Severity            => 'NOTIFICATION'
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => '- Extracting "'||gcv_SubEntity||'":'
                    ,pt_i_OracleError         => NULL
                    );
        xxmx_utilities_pkg.init_migration_details
                    (
                     pt_i_ApplicationSuite       => gct_ApplicationSuite
                    ,pt_i_Application            => gct_Application
                    ,pt_i_BusinessEntity         => gcv_BusinessEntity
                    ,pt_i_SubEntity              => gcv_SubEntity
                    ,pt_i_MigrationSetID         => pt_i_MigrationSetID
                    ,pt_i_StagingTable           => ct_StgTable
                    ,pt_i_ExtractStartDate       => SYSDATE
                    );
        xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gcv_BusinessEntity
                    ,pt_i_SubEntity           => gcv_SubEntity
                    ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                    ,pt_i_Severity            => 'NOTIFICATION'
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => '  - Staging Table "'||ct_StgTable||'" reporting details initialised.'
                    ,pt_i_OracleError         => NULL
        );
        --
        -- Extract the AR Customer and insert into the staging table.
        gvv_ProgressIndicator :='0060';
        xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gcv_BusinessEntity
                    ,pt_i_SubEntity           => gcv_SubEntity
                    ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                    ,pt_i_Severity            => 'NOTIFICATION'
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => 'Extracting data into "'||ct_StgTable||'".'
                    ,pt_i_OracleError         => NULL
                    );
        --
        gvv_migrate_resp := xxmx_utilities_pkg.get_single_parameter_value(
                         pt_i_ApplicationSuite           =>     'HCM'
                        ,pt_i_Application                =>     'FND'
                        ,pt_i_BusinessEntity             =>     'USERS'
                        ,pt_i_SubEntity                  =>     'RESP'
                        ,pt_i_ParameterCode              =>     'MIGRATE_RESPONSIBILITIES'
        );        
        if gvv_migrate_resp = 'Y' then
        --
            gvv_effective_date := xxmx_utilities_pkg.get_single_parameter_value(
                         pt_i_ApplicationSuite           =>     'HCM'
                        ,pt_i_Application                =>     'HR'
                        ,pt_i_BusinessEntity             =>     'HCMEMPLOYEE'
                        ,pt_i_SubEntity                  =>     'ALL'
                        ,pt_i_ParameterCode              =>     'MIGRATE_DATE_FROM'
            );        
            gvd_effective_date := TO_DATE(gvv_effective_date,'YYYY-MM-DD');
            --
            gvv_ProgressIndicator :='0070';
            OPEN resp_cur (gvd_effective_date);
            loop -- main loop
                    FETCH resp_cur
                    BULK COLLECT
                    INTO responsibility_tbl
                    LIMIT        xxmx_utilities_pkg.gcn_BulkCollectLimit;
                EXIT WHEN responsibility_tbl.COUNT=0;
                --
                gvv_ProgressIndicator :='0071';
                --
                forall i in 1..responsibility_tbl.count
                    insert into xxmx_stg.xxmx_resp_stg
                    (
                         migration_set_id
                        ,migration_set_name
                        ,migration_status
                        ,metadata
                        ,source_system_id
                        ,source_system_owner
                        ,record_type
                        ,person_number
                        ,orig_user_name
                        ,new_user_name
                        ,ebs_responsibility
                        ,ebs_responsibility_key
                        ,ebs_application
                        ,add_remove_role
                    )
                    values
                    (
                         pt_i_MigrationSetID
                        ,gvt_MigrationSetName
                        ,'EXTRACTED'
                        ,responsibility_tbl(i).metadata
                        ,responsibility_tbl(i).person_number||'-'||responsibility_tbl(i).responsibility_key
                        ,'EBS'
                        ,responsibility_tbl(i).record_type
                        ,responsibility_tbl(i).person_number
                        ,responsibility_tbl(i).orig_user_name
                        ,responsibility_tbl(i).orig_user_name
                        ,responsibility_tbl(i).responsibility_name
                        ,responsibility_tbl(i).responsibility_key
                        ,responsibility_tbl(i).application_short_name
                        ,'ADD'
                    );
            -- end forall
            end loop; -- end main loop
            --
            gvv_ProgressIndicator :='0090';
            CLOSE resp_cur;
            --
            gvv_ProgressIndicator :='0080';
            commit;
            -- Obtain the count of rows inserted.  We cannot use SQL$ROWCOUNT here because of the LIMIT
            -- clause on the BULK COLLECT statement.  The rowcount will be reset each time the limit
            -- is reached.
            gvn_RowCount := xxmx_utilities_pkg.get_row_count(gct_StgSchema,ct_StgTable,pt_i_MigrationSetID);
            xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gcv_BusinessEntity
                    ,pt_i_SubEntity           => gcv_SubEntity
                    ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                    ,pt_i_Severity            => 'NOTIFICATION'
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => '  - Extraction complete.'
                    ,pt_i_OracleError         => NULL
                    );
               --** Update the migration details (Migration status will be automatically determined
               --** in the called procedure dependant on the Phase and if an Error Message has been
               --** passed).
               --
            gvv_ProgressIndicator :='0100';
               --
               --
            xxmx_utilities_pkg.upd_migration_details
                    (
                     pt_i_MigrationSetID          => pt_i_MigrationSetID
                    ,pt_i_BusinessEntity          => gcv_BusinessEntity
                    ,pt_i_SubEntity               => gcv_SubEntity
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
            xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gcv_BusinessEntity
                    ,pt_i_SubEntity           => gcv_SubEntity
                    ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                    ,pt_i_Severity            => 'NOTIFICATION'
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => '  - Migration Table "'
                                                 ||ct_StgTable
                                                 ||'" reporting details updated.'
                    ,pt_i_OracleError         => NULL
                    );
               --
               --
        end if;
    else
        --
        gvt_Severity      := 'ERROR';
        gvt_ModuleMessage := '- Migration Set not initialized.';
        --
        raise e_ModuleError;
    end if;
          --
          --
    xxmx_utilities_pkg.log_module_message
               (
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gcv_BusinessEntity
                    ,pt_i_SubEntity           => gcv_SubEntity
                    ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                    ,pt_i_Severity            => 'NOTIFICATION'
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => 'Procedure "'
                                                 ||gcv_PackageName
                                                 ||'.'
                                                 ||cv_ProcOrFuncName
                                                 ||'" completed.'
                    ,pt_i_OracleError         => NULL
               );
          --
          --
EXCEPTION
               --
               --
               WHEN e_ModuleError
               THEN
                    --
                    IF resp_cur%ISOPEN
                    THEN
                         CLOSE resp_cur;
                    end if;
                    --
                    ROLLBACK;
                    --
                    xxmx_utilities_pkg.log_module_message
                        (
                         pt_i_ApplicationSuite    => gct_ApplicationSuite
                        ,pt_i_Application         => gct_Application
                        ,pt_i_BusinessEntity      => gcv_BusinessEntity
                        ,pt_i_SubEntity           => gcv_SubEntity
                        ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                        ,pt_i_Phase               => ct_Phase
                        ,pt_i_PackageName         => gcv_PackageName
                        ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                        ,pt_i_Severity            => gvt_Severity
                        ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                        ,pt_i_ModuleMessage       => gvt_ModuleMessage
                        ,pt_i_OracleError         => NULL
                        );
                    --
                    --
                    RAISE;
                    --
                    --
               --** END e_ModuleError Exception
               --
               --
               WHEN OTHERS
               THEN
                    --
                    --
                        --
                    IF resp_cur%ISOPEN
                    THEN
                        CLOSE resp_cur;
                    end if;
                    --
                    --
                    ROLLBACK;
                    --
                    --
                    gvt_OracleError := SUBSTR(
                                             SQLERRM
                                           ||'** ERROR_BACKTRACE: '
                                           ||dbms_utility.format_error_backtrace
                                            ,1
                                            ,4000
                                            );
                    --
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                         pt_i_ApplicationSuite     => gct_ApplicationSuite
                         ,pt_i_Application         => gct_Application
                         ,pt_i_BusinessEntity      => gcv_BusinessEntity
                         ,pt_i_SubEntity           => gcv_SubEntity
                         ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                         ,pt_i_Phase               => ct_Phase
                         ,pt_i_PackageName         => gcv_PackageName
                         ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                         ,pt_i_Severity            => 'ERROR'
                         ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage       => 'Oracle error encounted at after Progress Indicator.'
                         ,pt_i_OracleError         => gvt_OracleError
                         );
                    --
                    --
                    RAISE;
                    --
                    --
               --** END OTHERS Exception
               --
               --
          --** END Exception Handler
          --
          --
END resp_stg;
--
--
-- -----------------------------------------------------------------------------
-- --------------------------- < data_access_stg > -----------------------------
-- -----------------------------------------------------------------------------
procedure data_access_stg
(
     p_bg_name                      in      VARCHAR2
    ,p_bg_id                        in      NUMBER
    ,pt_i_MigrationSetID   IN      xxmx_migration_headers.migration_set_id%TYPE
    ,pt_i_MigrationSetName          in      xxmx_migration_headers.migration_set_name%TYPE
)
is
begin
    null;
end data_access_stg;
--
--
-- -----------------------------------------------------------------------------
-- ------------------------- < map_responsibilities > --------------------------
-- -----------------------------------------------------------------------------
procedure map_responsibilities 
( 
    pt_i_applicationsuite      IN    xxmx_seeded_extensions.application_suite%TYPE,
    pt_i_application           IN    xxmx_seeded_extensions.application%TYPE,
    pt_i_businessentity        IN    xxmx_seeded_extensions.business_entity%TYPE,
    pt_i_stgpopulationmethod   IN    xxmx_core_parameters.parameter_value%TYPE,
    pt_i_filesetid             IN    xxmx_migration_headers.file_set_id%TYPE,
    pt_i_migrationsetid        IN    xxmx_migration_headers.migration_set_id%TYPE,
    pv_o_returnstatus          OUT   VARCHAR2
)
is
    cursor c_all_data_access is
        select *
        from xxmx_xfm.xxmx_user_data_access_xfm 
        where security_context_value='ALL';
    gvv_effective_date                          varchar2(30);
    gvd_effective_date                          date;
begin
    xxmx_utilities_pkg.log_module_message
        (
             pt_i_ApplicationSuite     => gct_ApplicationSuite
             ,pt_i_Application         => gct_Application
             ,pt_i_BusinessEntity      => gcv_BusinessEntity
             ,pt_i_SubEntity           => 'RESPONSIBILITY'
             ,pt_i_MigrationSetID      => pt_i_MigrationSetID
             ,pt_i_Phase               => 'TRANSFORM'
             ,pt_i_PackageName         => gcv_PackageName
             ,pt_i_ProcOrFuncName      => 'map_responsibilities'
             ,pt_i_Severity            => 'NOTIFICATION'
             ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
             ,pt_i_ModuleMessage       => 'Procedure map_responsibilities - Start'
             ,pt_i_OracleError         => gvt_OracleError
         );
    delete from xxmx_xfm.xxmx_user_data_access_xfm;
    --
    -- Retrieve the Migration Set Name
    gvv_ProgressIndicator :='0000';
    gvt_MigrationSetName := xxmx_utilities_pkg.get_migration_set_name(pt_i_MigrationSetID);
    --
    gvv_effective_date := xxmx_utilities_pkg.get_single_parameter_value(
                         pt_i_ApplicationSuite           =>     'HCM'
                        ,pt_i_Application                =>     'HR'
                        ,pt_i_BusinessEntity             =>     'HCMEMPLOYEE'
                        ,pt_i_SubEntity                  =>     'ALL'
                        ,pt_i_ParameterCode              =>     'MIGRATE_DATE_FROM'
        );        
    gvd_effective_date := TO_DATE(gvv_effective_date,'YYYY-MM-DD');
    -- ---------------------------------------------------------------------- --
    -- ------------------------- POPULATE ROLE TABLE ------------------------ --
    -- ---------------------------------------------------------------------- --
    gvv_ProgressIndicator :='0100';
    insert into xxmx_xfm.xxmx_resp_xfm
            (
                 migration_set_id
                ,migration_set_name
                ,migration_status
                ,metadata
                ,source_system_id
                ,source_system_owner
                ,record_type
                ,person_number
                ,orig_user_name
                ,new_user_name
                ,ebs_application
                ,ebs_responsibility
                ,ebs_responsibility_key
                ,cloud_role
                ,add_remove_role
            )
            select distinct 
                 pt_i_MigrationSetID
                ,gvt_MigrationSetName
                ,'EXTRACTED'
                ,'MERGE'
                ,xurtm.employee_number||'-'||xurtm.cloud_role
                ,'EBS'
                ,'UserRole'
                ,xurtm.employee_number
                ,xurtm.user_name
                ,xurtm.user_name
                ,'-'
                ,'-'
                ,'-'
                ,xcr.role_common_name
                ,'ADD'
            from 
                XXMX_MIGRATION_USERS_AND_ROLES           xurtm,
                XXMX_ALL_CLOUD_ROLES                    xcr,
                fnd_user@xxmx_extract               fu,
                XXMX_HCM_WORKERS_SCOPE              xxmx_current_emp
            where xurtm.user_name        = fu.user_name
            and   fu.employee_id         = xxmx_current_emp.person_id
            and   xcr.role_name          = xurtm.cloud_role
            and   gvd_effective_date between xxmx_current_emp.EFFECTIVE_START_DATE and xxmx_current_emp.EFFECTIVE_END_DATE
            ;
            xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gcv_BusinessEntity
                    ,pt_i_SubEntity           => 'RESPONSIBILITY'
                    ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                    ,pt_i_Phase               => 'TRANSFORM'
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => 'map_responsibilities'
                    ,pt_i_Severity            => 'NOTIFICATION'
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => 'SQL count=.'||SQL%rowcount
                    ,pt_i_OracleError         => NULL
                    );
    -- ---------------------------------------------------------------------- --
    -- --------------------------- DATA ACCESS ------------------------------ --
    -- ---------------------------------------------------------------------- --
    gvv_ProgressIndicator :='0201';
    insert into xxmx_xfm.xxmx_user_data_access_xfm
    (
        migration_set_id                        ,
        migration_set_name                      ,
        migration_status                        ,
        metadata                                ,
        source_system_id                        ,
        source_system_owner                     ,
        person_number                           ,
        orig_user_name                          ,
        new_user_name                           ,
        role                                    ,
        security_context                        ,
        security_context_value                  
    )
    select distinct
        resp.migration_set_id, resp.migration_set_name, resp.migration_status, resp.metadata, 
        resp.person_number||all_roles.role_common_name||'-'||mig_role_grp.security_context_value, 'EBS',
        resp.person_number, resp.orig_user_name, resp.new_user_name,
        mig_usr_role.cloud_role, mig_roles.security_context, mig_role_grp.security_context_value
    from
        XXMX_MIGRATION_USERS_AND_ROLES    mig_usr_role,
        XXMX_MIGRATION_CLOUD_ROLES        mig_roles,
        XXMX_MIGRATION_ROLE_GROUPS        mig_role_grp,
        XXMX_ALL_CLOUD_ROLES              all_roles,
        xxmx_xfm.xxmx_resp_xfm            resp
    where 1=1
    and mig_roles.role_name                =   mig_usr_role.cloud_role
    and mig_role_grp.application           =   mig_roles.application
    and mig_role_grp.security_context      =   mig_roles.security_context
    and mig_role_grp.group_name            =   mig_usr_role.role_group_name
    and all_roles.role_name                =   mig_usr_role.cloud_role
    and resp.person_number                 =   mig_usr_role.employee_number
    and resp.cloud_role                    =   all_roles.role_common_name
    ;
    -- ---------------------------------------------------------------------- --
    -- ------------------- ALL - DATA ACCESS PROCESSING --------------------- --
    -- ---------------------------------------------------------------------- --
    gvv_ProgressIndicator :='0212';
    for r_dara_access in c_all_data_access 
    loop
        if r_dara_access.security_context = 'Asset book' then
            insert into xxmx_user_data_access_xfm
            (
                migration_set_id                        ,
                migration_set_name                      ,
                migration_status                        ,
                metadata                                ,
                source_system_id                        ,
                source_system_owner                     ,
                person_number                           ,
                orig_user_name                          ,
                new_user_name                           ,
                role                                    ,
                security_context                        ,
                security_context_value                  
            )
            select
                r_dara_access.migration_set_id, r_dara_access.migration_set_name, r_dara_access.migration_status, 
                r_dara_access.metadata, r_dara_access.source_system_id, r_dara_access.source_system_owner,
                r_dara_access.person_number, r_dara_access.orig_user_name, r_dara_access.new_user_name,
                r_dara_access.role, r_dara_access.security_context, all_books.book_type_code
            from      XXMX_CLOUD_ASSET_BOOKS all_books;
        --
        elsif r_dara_access.security_context = 'Business unit' then
            insert into xxmx_user_data_access_xfm
            (
                migration_set_id                        ,
                migration_set_name                      ,
                migration_status                        ,
                metadata                                ,
                source_system_id                        ,
                source_system_owner                     ,
                person_number                           ,
                orig_user_name                          ,
                new_user_name                           ,
                role                                    ,
                security_context                        ,
                security_context_value                  
            )
            select
                r_dara_access.migration_set_id, r_dara_access.migration_set_name, r_dara_access.migration_status, 
                r_dara_access.metadata, r_dara_access.source_system_id, r_dara_access.source_system_owner,
                r_dara_access.person_number, r_dara_access.orig_user_name, r_dara_access.new_user_name,
                r_dara_access.role, r_dara_access.security_context, all_bu.fusion_business_unit_name
            from      xxmx_source_operating_units        all_bu
            where MIGRATION_ENABLED_FLAG='Y';
        --
        elsif r_dara_access.security_context = 'Reference Data Set' then
            insert into xxmx_user_data_access_xfm
            (
                migration_set_id                        ,
                migration_set_name                      ,
                migration_status                        ,
                metadata                                ,
                source_system_id                        ,
                source_system_owner                     ,
                person_number                           ,
                orig_user_name                          ,
                new_user_name                           ,
                role                                    ,
                security_context                        ,
                security_context_value                  
            )
            select
                r_dara_access.migration_set_id, r_dara_access.migration_set_name, r_dara_access.migration_status, 
                r_dara_access.metadata, r_dara_access.source_system_id, r_dara_access.source_system_owner,
                r_dara_access.person_number, r_dara_access.orig_user_name, r_dara_access.new_user_name,
                r_dara_access.role, r_dara_access.security_context, all_bu.fusion_business_unit_name
            from      xxmx_source_operating_units        all_bu
            where MIGRATION_ENABLED_FLAG='Y';
        --
        elsif r_dara_access.security_context = 'Data Access Set' then
            insert into xxmx_user_data_access_xfm
            (
                migration_set_id                        ,
                migration_set_name                      ,
                migration_status                        ,
                metadata                                ,
                source_system_id                        ,
                source_system_owner                     ,
                person_number                           ,
                orig_user_name                          ,
                new_user_name                           ,
                role                                    ,
                security_context                        ,
                security_context_value                  
            )
            Values
            (
                r_dara_access.migration_set_id, r_dara_access.migration_set_name, r_dara_access.migration_status, 
                r_dara_access.metadata, r_dara_access.source_system_id, r_dara_access.source_system_owner,
                r_dara_access.person_number, r_dara_access.orig_user_name, r_dara_access.new_user_name,
                r_dara_access.role, r_dara_access.security_context, 'ALL Ledgers'
            );
        --
        elsif r_dara_access.security_context = 'Itercompany Organization' then
            insert into xxmx_user_data_access_xfm
            (
                migration_set_id                        ,
                migration_set_name                      ,
                migration_status                        ,
                metadata                                ,
                source_system_id                        ,
                source_system_owner                     ,
                person_number                           ,
                orig_user_name                          ,
                new_user_name                           ,
                role                                    ,
                security_context                        ,
                security_context_value                  
            )
            select
                r_dara_access.migration_set_id, r_dara_access.migration_set_name, r_dara_access.migration_status, 
                r_dara_access.metadata, r_dara_access.source_system_id, r_dara_access.source_system_owner,
                r_dara_access.person_number, r_dara_access.orig_user_name, r_dara_access.new_user_name,
                r_dara_access.role, r_dara_access.security_context, all_inter.ORG_NAME
            from      XXMX_CLOUD_INTERCOMPANIES        all_inter
            ;
        end if;
    end loop;
    delete from xxmx_user_data_access_xfm where security_context_value='ALL';
    --
    --
    gvv_ProgressIndicator :='0213';
    -- ---------------------------------------------------------------------- --
    -- ------------------------ PROCUREMENT AGENT --------------------------- --
    -- ---------------------------------------------------------------------- --
    -- NOTE: For every user with the Buyer role, create the O AGENT spreadsheet data
    -- 
    delete from XXMX_PO_AGENT;
    insert into XXMX_PO_AGENT
        (
            AGENT_NAME                  ,
            ENTERPRISE_ID               ,
            AGENT_EMAIL_ADDRESS         ,
            BU_CODE                     ,
            ACTIVE                      
        )
        select
            worker.FULL_NAME,
            1,
            perapf.EMAIL_ADDRESS,
            xrgvtm.SECURITY_CONTEXT_VALUE,
            'Y'
            from
                XXMX_HCM_WORKERS_SCOPE              worker,
                per_all_people_f@xxmx_extract       perapf,
                XXMX_MIGRATION_USERS_AND_ROLES           xurtm,
                XXMX_ROLES_TO_MIGRATE               xrtm,
                XXMX_ROLE_GROUP_VAL_TO_MIGRATE      xrgvtm
            where 1=1
            and     xurtm.employee_number       =   perapf.employee_number
            and     sysdate                     between perapf.effective_start_date and perapf.effective_end_date
            and     xurtm.CLOUD_ROLE            =   'Buyer'
            and     xrtm.CLOUD_ROLE             =   xurtm.CLOUD_ROLE
            and     xrgvtm.APPLICATION_CODE     =   xrtm.APPLICATION_CODE
            and     xrgvtm.SECURITY_CONTEXT     =   xrtm.SECURITY_CONTEXT
            and     xrgvtm.GROUP_NAME           =   xurtm.ROLE_GROUP_NAME
            and     worker.person_id            = perapf.person_id
            ;
    delete from XXMX_PO_AGENT_ACCESS;
    insert into XXMX_PO_AGENT_ACCESS
        (
            AGENT_NAME                  ,
            ENTERPRISE_ID               ,
            AGENT_EMAIL_ADDRESS         ,
            BU_CODE                     ,
            ACCESS_ACTION_CODE          ,
            ACCESS_ACTION_CODE_LEVEL    ,
            ACTIVE_FLAG                 ,
            ALLOWED_FLAG                
        )
        select
            worker.FULL_NAME,
            1,
            perapf.EMAIL_ADDRESS,
            xrgvtm.SECURITY_CONTEXT_VALUE,
            xpaad.ACCESS_ACTION_CODE          ,
            xpaad.ACCESS_ACTION_CODE_LEVEL    ,
            xpaad.ACTIVE_FLAG                 ,
            xpaad.ALLOWED_FLAG                
            from
                XXMX_HCM_WORKERS_SCOPE              worker,
                per_all_people_f@xxmx_extract       perapf,
                XXMX_MIGRATION_USERS_AND_ROLES           xurtm,
                XXMX_ROLES_TO_MIGRATE               xrtm,
                XXMX_ROLE_GROUP_VAL_TO_MIGRATE      xrgvtm,
                XXMX_PO_AGENT_ACCESS_DEFAULTS       xpaad
            where 1=1
            and     xurtm.employee_number       =   perapf.employee_number
            and     sysdate                     between perapf.effective_start_date and perapf.effective_end_date
            and     xurtm.CLOUD_ROLE            =   'Buyer'
            and     xrtm.CLOUD_ROLE             =   xurtm.CLOUD_ROLE
            and     xrgvtm.APPLICATION_CODE     =   xrtm.APPLICATION_CODE
            and     xrgvtm.SECURITY_CONTEXT     =   xrtm.SECURITY_CONTEXT
            and     xrgvtm.GROUP_NAME           =   xurtm.ROLE_GROUP_NAME
            and     worker.person_id            = perapf.person_id
            ;
            
    --
    --
    gvv_ProgressIndicator :='0200';
    delete  from xxmx_xfm.xxmx_resp_xfm xfm where xfm.cloud_role is null;
    --
    commit;
    xxmx_utilities_pkg.log_module_message
        (
             pt_i_ApplicationSuite     => gct_ApplicationSuite
             ,pt_i_Application         => gct_Application
             ,pt_i_BusinessEntity      => gcv_BusinessEntity
             ,pt_i_SubEntity           => 'RESPONSIBILITY'
             ,pt_i_MigrationSetID      => pt_i_MigrationSetID
             ,pt_i_Phase               => 'TRANSFORM'
             ,pt_i_PackageName         => gcv_PackageName
             ,pt_i_ProcOrFuncName      => 'map_responsibilities'
             ,pt_i_Severity            => 'NOTIFICATION'
             ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
             ,pt_i_ModuleMessage       => 'Procedure map_responsibilities - End'
             ,pt_i_OracleError         => gvt_OracleError
         );
exception
    when others then 
        xxmx_utilities_pkg.log_module_message
        (
             pt_i_ApplicationSuite     => gct_ApplicationSuite
             ,pt_i_Application         => gct_Application
             ,pt_i_BusinessEntity      => gcv_BusinessEntity
             ,pt_i_SubEntity           => 'RESPONSIBILITY'
             ,pt_i_MigrationSetID      => pt_i_MigrationSetID
             ,pt_i_Phase               => 'TRANSFORM'
             ,pt_i_PackageName         => gcv_PackageName
             ,pt_i_ProcOrFuncName      => 'map_responsibilities'
             ,pt_i_Severity            => 'NOTIFICATION'
             ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
             ,pt_i_ModuleMessage       => substr(sqlerrm,1,300)
             ,pt_i_OracleError         => gvt_OracleError
         );
end map_responsibilities;
--
-- -----------------------------------------------------------------------------
-- -------------------------------- < stg_main > -------------------------------
-- -----------------------------------------------------------------------------
procedure XXMX_USER_GEN is
begin
null;
end XXMX_USER_GEN;
--
-- -----------------------------------------------------------------------------
-- -------------------------------- < stg_main > -------------------------------
-- -----------------------------------------------------------------------------
procedure XXMX_RESP_GEN is
begin
null;
end XXMX_RESP_GEN;
--
-- -----------------------------------------------------------------------------
-- -------------------------------- < stg_main > -------------------------------
-- -----------------------------------------------------------------------------
PROCEDURE stg_main
                    (
                     pt_i_ClientCode                 IN      xxmx_client_config_parameters.client_code%TYPE
                    ,pt_i_MigrationSetName           IN      xxmx_migration_headers.migration_set_name%TYPE
                    )
is
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
          cv_ProcOrFuncName               CONSTANT  VARCHAR2(30)                                    := 'stg_main';
          ct_SubEntity                    CONSTANT  xxmx_module_messages.sub_entity%TYPE            := 'ALL';
          ct_Phase                        CONSTANT  xxmx_module_messages.phase%TYPE                 := 'EXTRACT';
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
begin
    --
    gvv_ProgressIndicator := '0010';
    --
    IF   pt_i_ClientCode       IS NULL
    OR   pt_i_MigrationSetName IS NULL
    THEN
               --
               gvt_Severity      := 'ERROR';
               gvt_ModuleMessage := '- "pt_i_ClientCode" and "pt_i_MigrationSetName" parameters are mandatory.';
               --
               raise e_ModuleError;
               --
    end if;
    --
    -- Clear Customers Module Messages
    --
    gvv_ProgressIndicator := '0020';
    --
    gvv_ReturnStatus  := '';
    --
    xxmx_utilities_pkg.clear_messages
               (
                pt_i_ApplicationSuite    => gct_ApplicationSuite
               ,pt_i_Application         => gct_Application
               ,pt_i_BusinessEntity      => gcv_BusinessEntity
               ,pt_i_SubEntity           => ct_SubEntity
               ,pt_i_Phase               => ct_Phase
               ,pt_i_MessageType         => 'MODULE'
               ,pv_o_ReturnStatus        => gvv_ReturnStatus
               );
    --
    IF   gvv_ReturnStatus = 'F'
    THEN
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gcv_BusinessEntity
                    ,pt_i_SubEntity           => ct_SubEntity
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_Severity            => 'ERROR'
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => '- Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
                    ,pt_i_OracleError         => gvt_ReturnMessage
                    );
               --
               raise e_ModuleError;
    end if;
    --
    gvv_ProgressIndicator := '0030';
    --
    xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite    => gct_ApplicationSuite
               ,pt_i_Application         => gct_Application
               ,pt_i_BusinessEntity      => gcv_BusinessEntity
               ,pt_i_SubEntity           => ct_SubEntity
               ,pt_i_Phase               => ct_Phase
               ,pt_i_Severity            => 'NOTIFICATION'
               ,pt_i_PackageName         => gcv_PackageName
               ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
               ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
               ,pt_i_ModuleMessage       => 'Procedure "'||gcv_PackageName||'.'||cv_ProcOrFuncName||'" initiated.'
               ,pt_i_OracleError         => NULL
               );
    --
    -- Initialize the Migration Set for the Business Entity retrieving
    -- a new Migration Set ID.
    --
    gvv_ProgressIndicator := '0040';
    --
    xxmx_utilities_pkg.init_migration_set
               (
                pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => gcv_BusinessEntity
               ,pt_i_MigrationSetName  => pt_i_MigrationSetName
               ,pt_o_MigrationSetID    => vt_MigrationSetID
               );

          --vt_MigrationSetID := pt_i_ClientCode;
    xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite    => gct_ApplicationSuite
               ,pt_i_Application         => gct_Application
               ,pt_i_BusinessEntity      => gcv_BusinessEntity
               ,pt_i_SubEntity           => ct_SubEntity
               ,pt_i_MigrationSetID      => vt_MigrationSetID
               ,pt_i_Phase               => ct_Phase
               ,pt_i_Severity            => 'NOTIFICATION'
               ,pt_i_PackageName         => gcv_PackageName
               ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
               ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
               ,pt_i_ModuleMessage       => '- Migration Set "'||pt_i_MigrationSetName||'" initialized (Generated Migration Set ID = '||vt_MigrationSetID||').  Processing extracts:'
               ,pt_i_OracleError         => NULL
               );
    --
    -- First for performance reasons create a Temp table to hold details
    -- of all the sites we are to extract data for
    --
    xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gcv_BusinessEntity
                    ,pt_i_SubEntity           => ct_SubEntity
                    ,pt_i_MigrationSetID      => vt_MigrationSetID
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_Severity            => 'NOTIFICATION'
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => SQL%ROWCOUNT || ' entries added to Customer Scope Temp Staging'
                    ,pt_i_OracleError         => gvt_ReturnMessage
                    );
    --
    -- Loop through the Migration Metadata table to retrieve
    -- the Staging Package Name, Procedure Name and table name
    -- for each extract requied for the current Business Entity.
    --
    gvv_ProgressIndicator := '0050';
    --
    FOR  StagingMetadata_rec
    IN   StagingMetadata_cur
                    (
                     gct_ApplicationSuite
                    ,gct_Application
                    ,gcv_BusinessEntity
                    )
    LOOP
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gcv_BusinessEntity
                    ,pt_i_SubEntity           => ct_SubEntity
                    ,pt_i_MigrationSetID      => vt_MigrationSetID
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_Severity            => 'NOTIFICATION'
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => '- Calling Procedure "'
                                               ||StagingMetadata_rec.entity_package_name
                                               ||'.'
                                               ||StagingMetadata_rec.stg_procedure_name
                                               ||'".'
                    ,pt_i_OracleError         => NULL
                    );
               --
               gvv_SQLStatement := 'begin '
                                 ||StagingMetadata_rec.entity_package_name
                                 ||'.'
                                 ||StagingMetadata_rec.stg_procedure_name
                                 ||gcv_SQLSpace
                                 ||'(pt_i_MigrationSetID          => '
                                 ||vt_MigrationSetID
                                 ||',pt_i_SubEntity     => '''
                                 ||StagingMetadata_rec.sub_entity||''''
                                 ||'); END;';
        --
        xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gcv_BusinessEntity
                    ,pt_i_SubEntity           => ct_SubEntity
                    ,pt_i_MigrationSetID      => vt_MigrationSetID
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_Severity            => 'NOTIFICATION'
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => SUBSTR('- Generated SQL Statement: '||gvv_SQLStatement,1,4000)
                    ,pt_i_OracleError         => NULL
                    );
               --
        EXECUTE IMMEDIATE gvv_SQLStatement;
        --
    END LOOP;
    --
    gvv_ProgressIndicator := '0060';
    --
    COMMIT;
    --
    xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite    => gct_ApplicationSuite
               ,pt_i_Application         => gct_Application
               ,pt_i_BusinessEntity      => gcv_BusinessEntity
               ,pt_i_SubEntity           => ct_SubEntity
               ,pt_i_MigrationSetID      => vt_MigrationSetID
               ,pt_i_Phase               => ct_Phase
               ,pt_i_Severity            => 'NOTIFICATION'
               ,pt_i_PackageName         => gcv_PackageName
               ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
               ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
               ,pt_i_ModuleMessage       => 'Procedure "'
                                            ||gcv_PackageName
                                            ||'.'
                                            ||cv_ProcOrFuncName
                                            ||'" completed.'
               ,pt_i_OracleError         => NULL
               );
         --
         gvv_ProgressIndicator :='0070';
         --
         --** DH  16/04/2021 - call custom package for any customisations to be processed.
         --
          xxmx_core.xxmx_utilities_pkg.log_module_message
          (
              pt_i_ApplicationSuite    => gct_ApplicationSuite
             ,pt_i_Application         => gct_Application
             ,pt_i_BusinessEntity      => gcv_BusinessEntity
             ,pt_i_SubEntity           => ct_SubEntity
             ,pt_i_MigrationSetID      => vt_MigrationSetID
             ,pt_i_Phase               => ct_Phase
             ,pt_i_PackageName         => gcv_PackageName
             ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
             ,pt_i_Severity            => 'NOTIFICATION'
             ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
             ,pt_i_ModuleMessage       => 'Calling procedure "'
                                          ||'xxmx_ar_customes_cm_pkg'
                                          ||'.'
                                          ||'upd_customer_dffs_stg'
                                          ||'".'
             ,pt_i_OracleError       => NULL
          );
          --
          --
          --
          COMMIT;
          --
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite    => gct_ApplicationSuite
               ,pt_i_Application         => gct_Application
               ,pt_i_BusinessEntity      => gcv_BusinessEntity
               ,pt_i_SubEntity           => ct_SubEntity
               ,pt_i_MigrationSetID      => vt_MigrationSetID
               ,pt_i_Phase               => ct_Phase
               ,pt_i_Severity            => 'NOTIFICATION'
               ,pt_i_PackageName         => 'xxmx_ar_customes_cm_pkg'
               ,pt_i_ProcOrFuncName      => 'upd_customer_dffs_stg'
               ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
               ,pt_i_ModuleMessage       => 'Procedure "'
                                            ||'xxmx_ar_customes_cm_pkg'
                                            ||'.'
                                            ||'upd_customer_dffs_stg'
                                            ||'" completed.'
               ,pt_i_OracleError         => NULL
               );
          --
          EXCEPTION
               --
               WHEN e_ModuleError
               THEN
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite    => gct_ApplicationSuite
                         ,pt_i_Application         => gct_Application
                         ,pt_i_BusinessEntity      => gcv_BusinessEntity
                         ,pt_i_SubEntity           => ct_SubEntity
                         ,pt_i_Phase               => ct_Phase
                         ,pt_i_Severity            => gvt_Severity
                         ,pt_i_PackageName         => gcv_PackageName
                         ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
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
               THEN
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
                         ,pt_i_BusinessEntity      => gcv_BusinessEntity
                         ,pt_i_SubEntity => ct_SubEntity
                         ,pt_i_Phase               => ct_Phase
                         ,pt_i_Severity            => 'ERROR'
                         ,pt_i_PackageName         => gcv_PackageName
                         ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
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
END stg_main;
     --
     --
     --*******************
     --** PROCEDURE: purge
     --*******************
     --
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
          cv_ProcOrFuncName               CONSTANT  VARCHAR2(30)                                    := 'purge';
          ct_SubEntity                    CONSTANT  xxmx_module_messages.sub_entity%TYPE            := 'ALL';
          ct_Phase                        CONSTANT  xxmx_module_messages.phase%TYPE                 := 'CORE';
          --
          --************************
          --** Variable Declarations
          --************************
          --
          vt_ConfigParameter              xxmx_client_config_parameters.config_parameter%TYPE;
          --vt_ClientSchemaName             xxmx_client_config_parameters.config_value%TYPE;
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
     begin
          --
          gvv_ProgressIndicator := '0010';
          --
          IF   pt_i_ClientCode     IS NULL
          OR   pt_i_MigrationSetID IS NULL
          THEN
               --
               gvt_Severity      := 'ERROR';
               gvt_ModuleMessage := '- "pt_i_ClientCode" and "pt_i_MigrationSetName" parameters are mandatory.';
               --
               raise e_ModuleError;
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
               ,pt_i_BusinessEntity      => gcv_BusinessEntity
               ,pt_i_SubEntity           => ct_SubEntity
               ,pt_i_Phase               => ct_Phase
               ,pt_i_MessageType         => 'MODULE'
               ,pv_o_ReturnStatus        => gvv_ReturnStatus
               );
          --
          IF   gvv_ReturnStatus = 'F'
          THEN
               --
               gvt_Severity      := 'ERROR';
               --
               gvt_ModuleMessage := '- Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".';
               --
               raise e_ModuleError;
               --
          end if;
          --
          gvv_ProgressIndicator := '0020';
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite    => gct_ApplicationSuite
               ,pt_i_Application         => gct_Application
               ,pt_i_BusinessEntity      => gcv_BusinessEntity
               ,pt_i_SubEntity           => ct_SubEntity
               ,pt_i_MigrationSetID      => pt_i_MigrationSetID
               ,pt_i_Phase               => ct_Phase
               ,pt_i_Severity            => 'NOTIFICATION'
               ,pt_i_PackageName         => gcv_PackageName
               ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
               ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
               ,pt_i_ModuleMessage       => 'Procedure "'
                                            ||gcv_PackageName
                                            ||'.'
                                            ||cv_ProcOrFuncName
                                            ||'" initiated.'
               ,pt_i_OracleError         => NULL
               );
          --
          --
           xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite    => gct_ApplicationSuite
               ,pt_i_Application         => gct_Application
               ,pt_i_BusinessEntity      => gcv_BusinessEntity
               ,pt_i_SubEntity           => ct_SubEntity
               ,pt_i_MigrationSetID      => pt_i_MigrationSetID
               ,pt_i_Phase               => ct_Phase
               ,pt_i_Severity            => 'NOTIFICATION'
               ,pt_i_PackageName         => gcv_PackageName
               ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
               ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
               ,pt_i_ModuleMessage       => '- Purging tables.'
               ,pt_i_OracleError         => NULL
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
                    ,gcv_BusinessEntity
                    )
          LOOP
               --
               --** DSF 26/10/2020 - Replace with new constant for Staging Schema.
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
               EXECUTE IMMEDIATE gvv_SQLStatement;
               --
               gvn_RowCount := SQL%ROWCOUNT;
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gcv_BusinessEntity
                    ,pt_i_SubEntity           => ct_SubEntity
                    ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_Severity            => 'NOTIFICATION'
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
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
               --     ,pt_i_BusinessEntity      => gcv_BusinessEntity
               --     ,pt_i_SubEntity           => ct_SubEntity
               --     ,pt_i_MigrationSetID      => pt_i_MigrationSetID
               --     ,pt_i_Phase               => ct_Phase
               --     ,pt_i_Severity            => 'NOTIFICATION'
               --     ,pt_i_PackageName         => gcv_PackageName
               --     ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
               --     ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
               --     ,pt_i_ModuleMessage       => '  - Records purged from "'
               --                                  ||PurgingMetadata_rec.xfm_table
               --                                  ||'" table: '
               --                                  ||gvn_RowCount
               --     ,pt_i_OracleError         => NULL
               --     );
               --
          END LOOP;
          --
          /*
          ** Purge the records for the Business Entity Levels
          ** Levels from the Migration Details table.
          */
          --
          vv_PurgeTableName := 'xxmx_migration_details';
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
               ,pt_i_BusinessEntity      => gcv_BusinessEntity
               ,pt_i_SubEntity           => ct_SubEntity
               ,pt_i_MigrationSetID      => pt_i_MigrationSetID
               ,pt_i_Phase               => ct_Phase
               ,pt_i_Severity            => 'NOTIFICATION'
               ,pt_i_PackageName         => gcv_PackageName
               ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
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
               ,pt_i_BusinessEntity      => gcv_BusinessEntity
               ,pt_i_SubEntity           => ct_SubEntity
               ,pt_i_MigrationSetID      => pt_i_MigrationSetID
               ,pt_i_Phase               => ct_Phase
               ,pt_i_Severity            => 'NOTIFICATION'
               ,pt_i_PackageName         => gcv_PackageName
               ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
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
               ,pt_i_BusinessEntity      => gcv_BusinessEntity
               ,pt_i_SubEntity           => ct_SubEntity
               ,pt_i_MigrationSetID      => pt_i_MigrationSetID
               ,pt_i_Phase               => ct_Phase
               ,pt_i_Severity            => 'NOTIFICATION'
               ,pt_i_PackageName         => gcv_PackageName
               ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
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
               ,pt_i_BusinessEntity      => gcv_BusinessEntity
               ,pt_i_SubEntity           => ct_SubEntity
               ,pt_i_MigrationSetID      => pt_i_MigrationSetID
               ,pt_i_Phase               => ct_Phase
               ,pt_i_Severity            => 'NOTIFICATION'
               ,pt_i_PackageName         => gcv_PackageName
               ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
               ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
               ,pt_i_ModuleMessage       => 'Procedure "'
                                          ||gcv_PackageName
                                          ||'.'
                                          ||cv_ProcOrFuncName
                                          ||'" completed.'
               ,pt_i_OracleError         => NULL
               );
          --
          EXCEPTION
               --
               WHEN e_ModuleError
               THEN
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite    => gct_ApplicationSuite
                         ,pt_i_Application         => gct_Application
                         ,pt_i_BusinessEntity      => gcv_BusinessEntity
                         ,pt_i_SubEntity           => ct_SubEntity
                         ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                         ,pt_i_Phase               => ct_Phase
                         ,pt_i_Severity            => gvt_Severity
                         ,pt_i_PackageName         => gcv_PackageName
                         ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
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
               THEN
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
                         ,pt_i_BusinessEntity      => gcv_BusinessEntity
                         ,pt_i_SubEntity           => ct_SubEntity
                         ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                         ,pt_i_Phase               => ct_Phase
                         ,pt_i_Severity            => 'ERROR'
                         ,pt_i_PackageName         => gcv_PackageName
                         ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
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
     END purge;
     --
END xxmx_users_pkg;