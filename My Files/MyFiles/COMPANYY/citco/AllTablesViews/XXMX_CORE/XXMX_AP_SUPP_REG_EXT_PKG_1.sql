--------------------------------------------------------
--  DDL for Package Body XXMX_AP_SUPP_REG_EXT_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "XXMX_CORE"."XXMX_AP_SUPP_REG_EXT_PKG" AS
     --
     --**********************
     --** Global Declarations
     --**********************
     --
     /*
     ** Maximise Integration Globals
     */
     --
     /*
     ** Global Constants for use in all xxmx_utilities_pkg Procedure/Function Calls within this package
     */
     --
    gct_packagename             CONSTANT xxmx_module_messages.package_name%TYPE := 'XXMX_AP_SUPP_REG_EXT_PKG';  -- <<Package Name>>
    gct_applicationsuite        CONSTANT xxmx_module_messages.application_suite%TYPE := 'FIN';  -- <<ApplicationSuite>>
    gct_application             CONSTANT xxmx_module_messages.application%TYPE := 'AP';  -- << Application as per metadata table>>
    gct_stgschema               CONSTANT VARCHAR2(10) := 'xxmx_stg';
    gct_xfmschema               CONSTANT VARCHAR2(10) := 'xxmx_xfm';
    gct_coreschema              CONSTANT VARCHAR2(10) := 'xxmx_core';
    gct_businessentity          CONSTANT xxmx_migration_metadata.business_entity%TYPE := 'SUPPLIERS_REG'; -- <<Business Entity>>
    gct_migratecisdata          CONSTANT VARCHAR2(1) := 'N';                 -- Added for SMBC flexibility, could move to migration parameter table
     --
     --
    gvv_progressindicator       VARCHAR2(100);
     --
     /*
     ** Global Variables for receiving Status/Messages from certain Procedure/Function Calls (e.g. xxmx_utilities_pkg.clear_messages
     */
     --
    gvv_returnstatus            VARCHAR2(1);
    gvt_returnmessage           xxmx_module_messages.module_message%TYPE;
     --
     /*
     ** Global Variables for Exception Handlers
     */
     --
    gvv_applicationerrormessage VARCHAR2(2048);
    gvt_severity                xxmx_module_messages.severity%TYPE;
    gvt_modulemessage           xxmx_module_messages.module_message%TYPE;
    gvt_oracleerror             xxmx_module_messages.oracle_error%TYPE;
     --
     /*
     ** Global Variables for Exception Handlers
     */
     --
    gvt_migrationsetname        xxmx_migration_headers.migration_set_name%TYPE;
     --
     /*
     ** Global constants and variables for dynamic SQL usage
     */
     --
    gcv_sqlspace                CONSTANT VARCHAR2(1) := ' ';
    gvv_sqlaction               VARCHAR2(20);
    gvv_sqltableclause          VARCHAR2(100);
    gvv_sqlcolumnlist           VARCHAR2(4000);
    gvv_sqlvalueslist           VARCHAR2(4000);
    gvv_sqlwhereclause          VARCHAR2(4000);
    gvv_sqlstatement            VARCHAR2(32000);
    gvv_sqlresult               VARCHAR2(4000);
     --
     /*
     ** Global variables for holding table row counts
     */
     --
    gvn_rowcount                NUMBER;
     --
     --
     /*
     ******************************
     ** PROCEDURE: <Procedure Name>
     ** keep parameters as is
     ******************************
     */
     --
    PROCEDURE ap_supp_party_site_reg (
        pt_i_migrationsetid IN xxmx_migration_headers.migration_set_id%TYPE,
        pt_i_subentity      IN xxmx_migration_metadata.sub_entity%TYPE
    ) IS
          --
          --
          --**********************
          --** CURSOR Declarations
          --**********************
          --
          --<<Cursor to get the detail of SubEntity??>>
          --
        CURSOR get_supp_party_sites_cur IS
        SELECT
            hp.party_id,
            s.segment1                        --*Party Number
            ,
            s.vendor_name                  --Party Name
            ,
            NULL party_site_id,
            NULL operating_unit,
            NULL vendor_site_code,
            h.party_type_code,
            l.registration_number,
            to_char(
                l.effective_from, 'YYYY/MM/DD'
            )    effective_from_date
        FROM
            jai_party_regs@xxmx_extract      h,
            jai_party_reg_lines@xxmx_extract l,
            ja_lookups@xxmx_extract          sec_code,
            apps.hz_parties@xxmx_extract     hp,
            apps.ap_suppliers@xxmx_extract   s,
            (
                SELECT
                    vendor_id
                FROM
                    xxmx_supplier_scope
                GROUP BY
                    vendor_id
            )                                xss
        WHERE
            1 = 1
            AND h.party_type_code = 'THIRD_PARTY'
            AND h.party_reg_id = l.party_reg_id
            AND h.supplier_flag = 'Y'
            AND h.site_flag='N'
            AND s.vendor_id = h.party_id
            AND nvl(
                l.effective_to, sysdate + 1
            ) > trunc(sysdate) -- 221
            AND l.default_section_code = sec_code.lookup_code (+)
            AND sec_code.lookup_type (+) = 'JAI_TDS_SECTION'
            AND hp.party_id = s.party_id
            AND s.vendor_id = xss.vendor_id
            AND registration_type_code = 'PAN'
            group by hp.party_id,
            s.segment1                        --*Party Number
            ,
            s.vendor_name                  --Party Name
            ,
            h.party_type_code,
            l.registration_number,
                l.effective_from
--and  DEFAULT_SECTION_CODE is not null

        UNION
        SELECT
            hp.party_id,
            s.segment1                        --*Party Number
            ,
            s.vendor_name                  --Party Name
            ,
            ss.party_site_id,
            (
                SELECT
                    name
                FROM
                    apps.hr_all_organization_units@xxmx_extract
                WHERE
                    organization_id = ss.org_id
            ) operating_unit,
            ss.vendor_site_code,
            h.party_type_code,
            l.registration_number,
            to_char(
                l.effective_from, 'YYYY/MM/DD'
            ) effective_from_date
        FROM
            jai_party_regs@xxmx_extract             h,
            jai_party_reg_lines@xxmx_extract        l,
            ja_lookups@xxmx_extract                 sec_code,
            apps.hz_parties@xxmx_extract            hp,
            apps.ap_suppliers@xxmx_extract          s,
            apps.ap_supplier_sites_all@xxmx_extract ss,
            (
                SELECT
                    vendor_id,
                    org_id,
                    vendor_site_id
                FROM
                    xxmx_supplier_scope
                GROUP BY
                    vendor_id,
                    org_id,
                    vendor_site_id
            )                                       xss
        WHERE
            1 = 1
            AND h.party_type_code = 'THIRD_PARTY_SITE'
            AND h.party_reg_id = l.party_reg_id
            AND h.supplier_flag = 'Y'
            AND ss.vendor_site_id = h.party_site_id
            AND ss.vendor_id = s.vendor_id
            AND s.vendor_id = h.party_id
            AND nvl(
                l.effective_to, sysdate + 1
            ) > trunc(sysdate) -- 221
            AND l.default_section_code = sec_code.lookup_code (+)
    --AND sec_code.lookup_type (+) = 'JAI_TDS_SECTION'
            AND hp.party_id = s.party_id
            AND s.vendor_id = xss.vendor_id
            AND registration_type_code = 'PAN'
            AND ss.vendor_site_id = xss.vendor_site_id
--and  DEFAULT_SECTION_CODE is not null
            ;
               ----
               ----
               ----
               ----
          --** END CURSOR **
          --
          --
          --********************
          --** Type Declarations
          --********************
          --
        TYPE get_supp_party_sites_tt IS
            TABLE OF get_supp_party_sites_cur%rowtype INDEX BY BINARY_INTEGER;
          --
          --
          --************************
          --** Constant Declarations
          --************************
          --
        ct_procorfuncname        CONSTANT xxmx_module_messages.proc_or_func_name%TYPE := 'ap_supp_party_site_reg';  --<< Procedure Name>>
        ct_stgschema             CONSTANT VARCHAR2(10) := 'xxmx_stg';
        ct_stgtable              CONSTANT xxmx_migration_metadata.stg_table%TYPE := 'xxmx_ap_supp_tax_reg_stg';  --<< Staging Table Name>>
        ct_phase                 CONSTANT xxmx_module_messages.phase%TYPE := 'EXTRACT';
          --
          --
          --************************
          --** Variable Declarations
          --************************
          --
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
        get_supp_party_sites_tbl get_supp_party_sites_tt;
          --
          --
          --*************************
          --** Exception Declarations
          --*************************
          --
          --** Set gvt_Severity, gvv_ProgressIndicator and gvt_ModuleMessage
          --** before raising this exception.
          --
        e_moduleerror EXCEPTION;
          --
     --** END Declarations
     --
    BEGIN
          --
        gvv_progressindicator := '0010';
          --
        gvv_returnstatus := '';
        gvt_returnmessage := '';
          --
        xxmx_utilities_pkg.clear_messages(
                                         pt_i_applicationsuite => gct_applicationsuite,
                                         pt_i_application      => gct_application,
                                         pt_i_businessentity   => gct_businessentity,
                                         pt_i_subentity        => pt_i_subentity,
                                         pt_i_phase            => ct_phase,
                                         pt_i_messagetype      => 'MODULE',
                                         pv_o_returnstatus     => gvv_returnstatus
        );
          --
        IF gvv_returnstatus = 'F' THEN
               --
            xxmx_utilities_pkg.log_module_message(
                                                 pt_i_applicationsuite  => gct_applicationsuite,
                                                 pt_i_application       => gct_application,
                                                 pt_i_businessentity    => gct_businessentity,
                                                 pt_i_subentity         => pt_i_subentity,
                                                 pt_i_phase             => ct_phase,
                                                 pt_i_severity          => 'ERROR',
                                                 pt_i_packagename       => gct_packagename,
                                                 pt_i_procorfuncname    => ct_procorfuncname,
                                                 pt_i_progressindicator => gvv_progressindicator,
                                                 pt_i_modulemessage     => '- Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".',
                                                 pt_i_oracleerror       => gvt_returnmessage
            );
               --
            RAISE e_moduleerror;
               --
        END IF;
          --
        gvv_progressindicator := '0020';
          --
        gvv_returnstatus := '';
        gvt_returnmessage := '';
          --
        xxmx_utilities_pkg.clear_messages(
                                         pt_i_applicationsuite => gct_applicationsuite,
                                         pt_i_application      => gct_application,
                                         pt_i_businessentity   => gct_businessentity,
                                         pt_i_subentity        => pt_i_subentity,
                                         pt_i_phase            => ct_phase,
                                         pt_i_messagetype      => 'DATA',
                                         pv_o_returnstatus     => gvv_returnstatus
        );
          --
        IF gvv_returnstatus = 'F' THEN
               --
            xxmx_utilities_pkg.log_module_message(
                                                 pt_i_applicationsuite  => gct_applicationsuite,
                                                 pt_i_application       => gct_application,
                                                 pt_i_businessentity    => gct_businessentity,
                                                 pt_i_subentity         => pt_i_subentity,
                                                 pt_i_phase             => ct_phase,
                                                 pt_i_severity          => 'ERROR',
                                                 pt_i_packagename       => gct_packagename,
                                                 pt_i_procorfuncname    => ct_procorfuncname,
                                                 pt_i_progressindicator => gvv_progressindicator,
                                                 pt_i_modulemessage     => '- Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".',
                                                 pt_i_oracleerror       => gvt_returnmessage
            );
               --
            RAISE e_moduleerror;
               --
        END IF;
          --
        gvv_progressindicator := '0030';
          --
        xxmx_utilities_pkg.log_module_message(
                                             pt_i_applicationsuite  => gct_applicationsuite,
                                             pt_i_application       => gct_application,
                                             pt_i_businessentity    => gct_businessentity,
                                             pt_i_subentity         => pt_i_subentity,
                                             pt_i_phase             => ct_phase,
                                             pt_i_severity          => 'NOTIFICATION',
                                             pt_i_packagename       => gct_packagename,
                                             pt_i_procorfuncname    => ct_procorfuncname,
                                             pt_i_progressindicator => gvv_progressindicator,
                                             pt_i_modulemessage     => 'Procedure "'
                                                                   || gct_packagename
                                                                   || '.'
                                                                   || ct_procorfuncname
                                                                   || '" initiated.',
                                             pt_i_oracleerror       => NULL
        );
          --
          --** Retrieve the Migration Set Name
          --
        gvv_progressindicator := '0040';
          --
        gvt_migrationsetname := xxmx_utilities_pkg.get_migration_set_name(pt_i_migrationsetid);
          --
          --** If the Migration Set Name is NULL then the Migration has not been initialized.
          --
        IF gvt_migrationsetname IS NOT NULL THEN
               --
            xxmx_utilities_pkg.log_module_message(
                                                 pt_i_applicationsuite  => gct_applicationsuite,
                                                 pt_i_application       => gct_application,
                                                 pt_i_businessentity    => gct_businessentity,
                                                 pt_i_subentity         => pt_i_subentity,
                                                 pt_i_phase             => ct_phase,
                                                 pt_i_severity          => 'NOTIFICATION',
                                                 pt_i_packagename       => gct_packagename,
                                                 pt_i_procorfuncname    => ct_procorfuncname,
                                                 pt_i_progressindicator => gvv_progressindicator,
                                                 pt_i_modulemessage     => '- Extracting "'
                                                                       || pt_i_subentity
                                                                       || '":',
                                                 pt_i_oracleerror       => NULL
            );
               --
               --** The Migration Set has been initialized so now initialize the detail record
               --** for the current entity.
               --
            xxmx_utilities_pkg.init_migration_details(
                                                     pt_i_applicationsuite => gct_applicationsuite,
                                                     pt_i_application      => gct_application,
                                                     pt_i_businessentity   => gct_businessentity,
                                                     pt_i_subentity        => pt_i_subentity,
                                                     pt_i_migrationsetid   => pt_i_migrationsetid,
                                                     pt_i_stagingtable     => ct_stgtable,
                                                     pt_i_extractstartdate => sysdate
            );
               --
            xxmx_utilities_pkg.log_module_message(
                                                 pt_i_applicationsuite  => gct_applicationsuite,
                                                 pt_i_application       => gct_application,
                                                 pt_i_businessentity    => gct_businessentity,
                                                 pt_i_subentity         => pt_i_subentity,
                                                 pt_i_phase             => ct_phase,
                                                 pt_i_severity          => 'NOTIFICATION',
                                                 pt_i_packagename       => gct_packagename,
                                                 pt_i_procorfuncname    => ct_procorfuncname,
                                                 pt_i_progressindicator => gvv_progressindicator,
                                                 pt_i_modulemessage     => '  - Migration details for Table "'
                                                                       || ct_stgtable
                                                                       || '" initialised.',
                                                 pt_i_oracleerror       => NULL
            );
               --
            gvv_progressindicator := '0050';
               --
               --** Extract the Sub-entity data and insert into the staging table.
               --
            xxmx_utilities_pkg.log_module_message(
                                                 pt_i_applicationsuite  => gct_applicationsuite,
                                                 pt_i_application       => gct_application,
                                                 pt_i_businessentity    => gct_businessentity,
                                                 pt_i_subentity         => pt_i_subentity,
                                                 pt_i_phase             => ct_phase,
                                                 pt_i_severity          => 'NOTIFICATION',
                                                 pt_i_packagename       => gct_packagename,
                                                 pt_i_procorfuncname    => ct_procorfuncname,
                                                 pt_i_progressindicator => gvv_progressindicator,
                                                 pt_i_modulemessage     => '  - Extracting data into "'
                                                                       || ct_stgtable
                                                                       || '" table.',
                                                 pt_i_oracleerror       => NULL
            );
               --
            OPEN get_supp_party_sites_cur;
               --
            gvv_progressindicator := '0060';
               --
            LOOP
                    --
                FETCH get_supp_party_sites_cur
                BULK COLLECT INTO get_supp_party_sites_tbl LIMIT xxmx_utilities_pkg.gcn_bulkcollectlimit;
                    --
                EXIT WHEN get_supp_party_sites_tbl.count = 0;
                    --
                gvv_progressindicator := '0070';
                    --
                FORALL i IN 1..get_supp_party_sites_tbl.count
                         --
                    INSERT INTO xxmx_stg.xxmx_ap_supp_tax_reg_stg (
                        segment1,
                        business_unit,
                        vendor_site_code,
                        file_set_id,
                        migration_set_id,
                        migration_set_name,
                        migration_status,
                        party_type_code,
                        party_name,
                        registration_number,
                        effective_from
                    ) VALUES (
                        get_supp_party_sites_tbl(i).segment1,
                        get_supp_party_sites_tbl(i).operating_unit,
                        get_supp_party_sites_tbl(i).vendor_site_code,
                        60,--get_supp_party_sites_tbl(i).        ,
                        pt_i_migrationsetid,--get_supp_party_sites_tbl(i).        ,
                        gvt_migrationsetname,--get_supp_party_sites_tbl(i).        ,
                        'EXTRACT',--get_supp_party_sites_tbl(i).        ,
                        get_supp_party_sites_tbl(i).party_type_code,
                        get_supp_party_sites_tbl(i).vendor_name,
                         get_supp_party_sites_tbl(i).registration_number,
                        get_supp_party_sites_tbl(i).effective_from_date
                       
                    );
                         --
                    --** END FORALL
                    --
            END LOOP;
               --
            gvv_progressindicator := '0080';
               --
               --** Obtain the count of rows inserted.  We cannot use SQL$ROWCOUNT here because of the LIMIT
               --** clause on the BULK COLLECT statement.  The rowcount will be reset each time the limit
               --** is reached.
               --
            gvn_rowcount := xxmx_utilities_pkg.get_row_count(
                                                            ct_stgschema,
                                                            ct_stgtable,
                                                            pt_i_migrationsetid
                            );
               --
            COMMIT;
               --
            gvv_progressindicator := '0090';
               --
            CLOSE get_supp_party_sites_cur;
               --
            xxmx_utilities_pkg.log_module_message(
                                                 pt_i_applicationsuite  => gct_applicationsuite,
                                                 pt_i_application       => gct_application,
                                                 pt_i_businessentity    => gct_businessentity,
                                                 pt_i_subentity         => pt_i_subentity,
                                                 pt_i_phase             => ct_phase,
                                                 pt_i_severity          => 'NOTIFICATION',
                                                 pt_i_packagename       => gct_packagename,
                                                 pt_i_procorfuncname    => ct_procorfuncname,
                                                 pt_i_progressindicator => gvv_progressindicator,
                                                 pt_i_modulemessage     => '  - Extraction complete.',
                                                 pt_i_oracleerror       => NULL
            );
               --
               --
               --** Update the migration details (Migration status will be automatically determined
               --** in the called procedure dependant on the Phase and if an Error Message has been
               --** passed).
               --
            gvv_progressindicator := '0100';
               --
            xxmx_utilities_pkg.upd_migration_details(
                                                    pt_i_migrationsetid          => pt_i_migrationsetid,
                                                    pt_i_businessentity          => gct_businessentity,
                                                    pt_i_subentity               => pt_i_subentity,
                                                    pt_i_phase                   => ct_phase,
                                                    pt_i_extractcompletiondate   => sysdate,
                                                    pt_i_extractrowcount         => gvn_rowcount,
                                                    pt_i_transformtable          => NULL,
                                                    pt_i_transformstartdate      => NULL,
                                                    pt_i_transformcompletiondate => NULL,
                                                    pt_i_exportfilename          => NULL,
                                                    pt_i_exportstartdate         => NULL,
                                                    pt_i_exportcompletiondate    => NULL,
                                                    pt_i_exportrowcount          => NULL,
                                                    pt_i_errorflag               => NULL
            );
               --
            xxmx_utilities_pkg.log_module_message(
                                                 pt_i_applicationsuite  => gct_applicationsuite,
                                                 pt_i_application       => gct_application,
                                                 pt_i_businessentity    => gct_businessentity,
                                                 pt_i_subentity         => pt_i_subentity,
                                                 pt_i_phase             => ct_phase,
                                                 pt_i_severity          => 'NOTIFICATION',
                                                 pt_i_packagename       => gct_packagename,
                                                 pt_i_procorfuncname    => ct_procorfuncname,
                                                 pt_i_progressindicator => gvv_progressindicator,
                                                 pt_i_modulemessage     => '  - Migration details for Table "'
                                                                       || ct_stgtable
                                                                       || '" updated.',
                                                 pt_i_oracleerror       => NULL
            );
               --
               --
            gvv_progressindicator := '0120';
               --
               --
        ELSE
               --
            gvt_severity := 'ERROR';
            gvt_modulemessage := '- Migration Set not initialized.';
               --
            RAISE e_moduleerror;
               --
        END IF;
          --
        xxmx_utilities_pkg.log_module_message(
                                             pt_i_applicationsuite  => gct_applicationsuite,
                                             pt_i_application       => gct_application,
                                             pt_i_businessentity    => gct_businessentity,
                                             pt_i_subentity         => pt_i_subentity,
                                             pt_i_phase             => ct_phase,
                                             pt_i_severity          => 'NOTIFICATION',
                                             pt_i_packagename       => gct_packagename,
                                             pt_i_procorfuncname    => ct_procorfuncname,
                                             pt_i_progressindicator => gvv_progressindicator,
                                             pt_i_modulemessage     => 'Procedure "'
                                                                   || gct_packagename
                                                                   || '.'
                                                                   || ct_procorfuncname
                                                                   || '" completed.',
                                             pt_i_oracleerror       => NULL
        );
          --
    EXCEPTION
               --
        WHEN e_moduleerror THEN
                    --
            xxmx_utilities_pkg.log_module_message(
                                                 pt_i_applicationsuite  => gct_applicationsuite,
                                                 pt_i_application       => gct_application,
                                                 pt_i_businessentity    => gct_businessentity,
                                                 pt_i_subentity         => pt_i_subentity,
                                                 pt_i_phase             => ct_phase,
                                                 pt_i_severity          => gvt_severity,
                                                 pt_i_packagename       => gct_packagename,
                                                 pt_i_procorfuncname    => ct_procorfuncname,
                                                 pt_i_progressindicator => gvv_progressindicator,
                                                 pt_i_modulemessage     => gvt_modulemessage,
                                                 pt_i_oracleerror       => NULL
            );
                    --
            gvv_applicationerrormessage := substr(
                                                 '"e_ModuleError" Exception raised after Progress Indicator "'
                                                 || gct_packagename
                                                 || '.'
                                                 || ct_procorfuncname
                                                 || '-'
                                                 || gvv_progressindicator
                                                 || '".  Please refer to XXMX_MODULE_MESSAGES table for further details.',
                                                 1,
                                                 2048
                                           );
                    --
            raise_application_error(
                                   xxmx_utilities_pkg.gcn_applicationerrornumber,
                                   gvv_applicationerrormessage
            );
                    --
               --** END e_ModuleError Exception
               --
        WHEN OTHERS THEN
                    --
            IF get_supp_party_sites_cur%isopen THEN
                         --
                CLOSE get_supp_party_sites_cur;
                         --
            END IF;
                    --
            ROLLBACK;
                    --
            gvt_oracleerror := substr(
                                     sqlerrm
                                     || '** ERROR_BACKTRACE: '
                                     || dbms_utility.format_error_backtrace,
                                     1,
                                     4000
                               );
                    --
            xxmx_utilities_pkg.log_module_message(
                                                 pt_i_applicationsuite  => gct_applicationsuite,
                                                 pt_i_application       => gct_application,
                                                 pt_i_businessentity    => gct_businessentity,
                                                 pt_i_subentity         => pt_i_subentity,
                                                 pt_i_phase             => ct_phase,
                                                 pt_i_severity          => 'ERROR',
                                                 pt_i_packagename       => gct_packagename,
                                                 pt_i_procorfuncname    => ct_procorfuncname,
                                                 pt_i_progressindicator => gvv_progressindicator,
                                                 pt_i_modulemessage     => 'Oracle error encounted at after Progress Indicator.',
                                                 pt_i_oracleerror       => gvt_oracleerror
            );
                    --
            gvv_applicationerrormessage := substr(
                                                 'Unexpected Oracle Exception encountered after Progress Indicator "'
                                                 || gct_packagename
                                                 || '.'
                                                 || ct_procorfuncname
                                                 || '-'
                                                 || gvv_progressindicator
                                                 || '".  Please refer to XXMX_MODULE_MESSAGES table for further details.',
                                                 1,
                                                 2048
                                           );
                    --
            raise_application_error(
                                   xxmx_utilities_pkg.gcn_applicationerrornumber,
                                   gvv_applicationerrormessage
            );
                    --
               --** END OTHERS Exception
               --
          --** END Exception Handler
          --
    END ap_supp_party_site_reg;
     --
     --
     --
END xxmx_ap_supp_reg_ext_pkg;

/
