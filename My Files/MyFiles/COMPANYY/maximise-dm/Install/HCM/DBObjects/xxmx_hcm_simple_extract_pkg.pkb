create or replace PACKAGE BODY    xxmx_hcm_simple_extract_pkg AS

 --******************************************************************************
--
--**
--**                 Copyright (c) 2023 Version 1
--**
--**                           MilPlennium House,
--**                           Millennium Walkway,
--**                           Dublin 1
--**                           D01 F5P8
--**
--**                           All rights reserved.
--**
--*****************************************************************************
--**
--**
--** FILENAME  :  xxmx_hcm_simple_extract_pkg.sql
--**
--** FILEPATH  :  $XXV1_TOP/install/sql
--**
--** VERSION   :  1.0
--**
--** EXECUTE
--** IN SCHEMA :  XXMX_CORE
--**
--** AUTHORS   :  Ayush Rathore
--**
--** PURPOSE   :  This package contains procedures for populating HCM Staging table
--**               Employee from EBS for simple HCM
--**
--** NOTES     :
--**
--******************************************************************************
--**
--** PRE-REQUISITIES
--** ---------------
--**
--** If this script is to be executed as part of an installation script, ensure
--** that the installation script performs the following tasks prior to calling
--** this script.
--**
--** Task  Description
--** ----  ---------------------------------------------------------------------
--** 1.    Run the installation script to create all necessary database objects
--**       and Concurrent definitions:
--**
--**            $XXV1_TOP/install/sql/xxv1_mxdm_utilities_1_dbi.sql
--**
--** If this script is not to be executed as part of an installation script,
--** ensure that the tasks above are, or have been, performed prior to executing
--** this script.
--**
--******************************************************************************
--**
--** CALLING INSTALLATION SCRIPTS
--** ----------------------------
--**
--** The following installation scripts call this script:
--**
--** File Path                                     File Name
--** --------------------------------------------  ------------------------------
--** N/A                                           N/A
--**
--******************************************************************************
--**
--** CALLED INSTALLATION SCRIPTS
--** ---------------------------
--**
--** The following installation scripts are called by this script:
--**
--** File Path                                    File Name
--** -------------------------------------------  ------------------------------
--** N/A                                          N/A
--**
--******************************************************************************
--**
--** PARAMETERS
--** ----------
--**
--** Parameter                       IN OUT  Type
--** -----------------------------  ------  ------------------------------------
--** [parameter_name]                IN OUT
--**
--******************************************************************************
--**
--** [previous_filename] HISTORY
--** -----------------------------
--**
--**   Vsn  Change Date  Changed By          Change Description
--** -----  -----------  ------------------  -----------------------------------
--** [ 1.0  DD-Mon-YYYY  Change Author       Created.                          ]
--**
--******************************************************************************
--**
--** xxcust_common_pkg.sql HISTORY
--** ------------------------------------
--**
--**   Vsn  Change Date  Changed By          Change Description
--** -----  -----------  ------------------  -----------------------------------
--** 1.0    23/11/2022   Ayush Rathore            Initial Build
--******************************************************************************
--**
--**  Data Element Prefixes
--**  =====================
--**
--**  Utilizing prefixes for data and object names enhances the readability of code
--**  and allows for the context of a data element to be identified (and hopefully
--**  understood) without having to refer to the data element declarations section.
--**
--**  For example, having a variable in code simply named "x_id" is not very
--**  useful.  Don't laugh, I've seen it done.
--**
--**  If you came across such a variable hundreds of lines down in a packaged
--**  procedure or function, you could assume the variable's data type was
--**  NUMBER or INTEGER (if its purpose was to store an Oracle internal ID),
--**  but you would have to check in the declaration section to be sure.
--**
--**  However, if the purpose of the "x_id" variable was not to store an Oracle
--**  internal ID but perhaps some kind of client data identifier e.g. an
--**  Employee ID (and you could not tell this from the name) then the data type
--**  could easily be be VARCHAR2.  Again, you would have to navigate to the
--**  declaration section to be sure of the data type.
--**
--**  Also, the variable name does not give any developer who may need to modify
--**  the code (apart from the original author that is) any context as to the
--**  meaning of the variable.  Even the original author may struggle to remember
--**  what this variable is used for if s/he had to modify their own code months
--**  or years in the future.
--**
--**  This Package utilises prefixes of upto 6 characters for all data elements
--**  wherever possible.
--**
--**  The construction of Prefixes is governed by the following rules:
--**
--**       Parameters
--**       ----------
--**       1) Parameter prefixes always start with "p".
--**
--**       2) The second character in a parameter prefix denotes its
--**          data type:
--**
--**               b = Data element of type BOOLEAN.
--**               d = Data element of type DATE.
--**               i = Data element of type INTEGER.
--**               n = Data element of type NUMBER.
--**               r = Data element of type REAL.
--**               v = Data element of type VARCHAR2.
--**               t = Data element of type %TYPE (DB inherited type).
--**
--**       3) The third and/or fourth characters in a parameter prefix
--**          denote the direction in which value in the paramater is
--**          communicated:
--**
--**               i  = Input parameter (readable value only)
--**               o  = Output parameter (value assignable)
--**               io = Input/Output parameter (readable/assignable)
--**
--**          For clarity, the direction indicators are separated from
--**          the first two characters by an underscore. e.g. pv_i_
--**
--**       Global Data Elements
--**       --------------------
--**       1) Global data elements will always start with a "g" whether
--**          defined in the package body (and therefore only global within
--**          the package itself), or defined in the package specification
--**          (and therefore referencable outside of the package).
--**
--**          The subequent characters in a global prefix will follow the same
--**          conventions as per local constants and variables as explained
--**          below.
--**
--**       Local Data Elements
--**       -------------------
--**       1) The first character of a local data element's prefix (or second
--**          character for global) denotes the data element's assignability:
--**
--**               c = Denotes a constant.
--**
--**               v = Denotes a variable.
--**
--**       2) The second character or a local data element's prefix (or third
--**          character for global) denotes its data type (as with parameters):
--**
--**               b = Data element of type BOOLEAN.
--**               d = Data element of type DATE.
--**               i = Data element of type INTEGER.
--**               n = Data element of type NUMBER.
--**               r = Data element of type REAL.
--**               v = Data element of type VARCHAR2.
--**               t = Data element of type %TYPE (DB inherited type).
--**
--**  Prefix Examples
--**  ===============
--**
--**       Prefix    Indication
--**       --------  ----------------------------------------
--**       pb_i_     Input Parameter of type BOOLEAN
--**       pd_i_     Input Parameter of type DATE
--**       pi_i_     Input Parameter of type INTEGER
--**       pn_i_     Input Parameter of type NUMBER
--**       pr_i_     Input Parameter of type REAL
--**       pv_i_     Input Parameter of type VARCHAR2
--**       pt_i_     Input Parameter of type %TYPE
--**
--**       pb_o_     Output Parameter of type BOOLEAN
--**       pd_o_     Output Parameter of type DATE
--**       pi_o_     Output Parameter of type INTEGER
--**       pn_o_     Output Parameter of type NUMBER
--**       pr_o_     Output Parameter of type REAL
--**       pv_o_     Output Parameter of type VARCHAR2
--**       pt_o_     Output Parameter of type %TYPE
--**
--**       pb_io_    Input/Output Parameter of type BOOLEAN
--**       pd_io_    Input/Output Parameter of type DATE
--**       pi_io_    Input/Output Parameter of type INTEGER
--**       pn_io_    Input/Output Parameter of type NUMBER
--**       pr_io_    Input/Output Parameter of type REAL
--**       pv_io_    Input/Output Parameter of type VARCHAR2
--**       pt_io_    Input/Output Parameter of type %TYPE
--**
--**       gcb_      Global Constant of type BOOLEAN
--**       gcd_      Global Constant of type DATE
--**       gci_      Global Constant of type INTEGER
--**       gcn_      Global Constant of type NUMBER
--**       gcr_      Global Constant of type REAL
--**       gcv_      Global Constant of type VARCHAR2
--**       gct_      Global Constant of type %TYPE
--**
--**       gvb_      Global Variable of type BOOLEAN
--**       gvd_      Global Variable of type DATE
--**       gvi_      Global Variable of type INTEGER
--**       gvn_      Global Variable of type NUMBER
--**       gvr_      Global Variable of type REAL
--**       gvv_      Global Variable of type VARCHAR2
--**       gvt_      Global Variable of type %TYPE
--**
--**       cb_       Constant of type BOOLEAN
--**       cd_       Constant of type DATE
--**       ci_       Constant of type INTEGER
--**       cn_       Constant of type NUMBER
--**       cr_       Constant of type REAL
--**       cv_       Constant of type VARCHAR2
--**       ct_       Constant of type %TYPE
--**
--**       vb_       Variable of type BOOLEAN
--**       vd_       Variable of type DATE
--**       vi_       Variable of type INTEGER
--**       vn_       Variable of type NUMBER
--**       vr_       Variable of type REAL
--**       vv_       Variable of type VARCHAR2
--**       vt_       Variable of type %TYPE
--**
--**  PL/SQL Construct Suffixes
--**  =========================
--**
--**  Specific suffixes have been employed for PL/SQL Constructs:
--**
--**       _cur      Cursor Names
--**       _rt       PL/SQL Record Type Declarations
--**       _tt       PL/SQL Table Type Declarations
--**       _tbl      PL/SQL Table Declarations
--**       _rec      PL/SQL Record Declarations (or implicit
--**                 cursor record declarations)
--**
--**  Other Data Element Naming Conventions
--**  =====================================
--**
--**  Data elements names should have meaning which indicate their purpose or
--**  usage whilst adhering to the Oracle name length limit of 30 characters.
--**
--**  To compensate for longer data element prefixes, the rest of a data element
--**  name is constructed without underscores.  However to aid in maintaining
--**  readability and meaning, data elements names will contain concatenated
--**  words with initial letters capitalised in a similar manner to JAVA naming
--**  conventions.
--**
--**  By using the above conventions you can create meaningful data element
--**  names such as:
--**
--**       pn_i_POHeaderID
--**       ---------------
--**       This clearly identifies that the data element is an inbound only
--**       (non assignable) parameter of type NUMBER which holds an Oracle
--**       internal PO Header identifier.
--**
--**       pb_o_CreateOutputFileAsCSV
--**       --------------------------
--**       This clearly identifies that the data element is an output only
--**       parameter of type BOOLEAN that contains a flag which indicates
--**       that output of the calling process should be formatted as a CSV
--**       file.
--**
--**       gcv_PackageName
--**       ---------------
--**       This data element is a global constant of type VARCHAR2.
--**
--**       cv_ProcOrFuncName
--**       -----------------
--**       This data element is a local constant of type VARCHAR2.
--**
--**       vt_APInvoiceID
--**       --------------
--**       This data element is a variable whose type is determined from a
--**       database table column and is meant to hold the Oracle internal
--**       identifier for a Payables Invoice Header.
--**
--**       vt_APInvoiceLineID
--**       ------------------
--**       Similar to the previous example but this clearly identified that the
--**       data element is intended to hold the Oracle internal identifier for
--**       a Payables Invoice Line.
--**
--**  Similarly for PL/SQL Constructs:
--**
--**       APInvoiceHeaders_cur
--**
--**       APInvoiceHeader_rec
--**
--**       TYPE EmployeeData_rt IS RECORD OF
--**            (
--**             employee_number   VARCHAR2(20)
--**            ,employee_name     VARCHAR2(30)
--**            );
--**
--**       TYPE EmployeeData_tt IS TABLE OF Employee_rt;
--**
--**       EmployeeData_tbl        EmployeeData_tt;
--**
--**  Careful and considerate use of the above rules when naming data elements
--**  can be a boon to other developers who may need to understand and/or modify
--**  your code in future.  In conjunction with good commenting practices of
--**  course.
--**
--******************************************************************************
--
--


    --
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
    gcv_PackageName                           CONSTANT  VARCHAR2(30)                                 := 'xxmx_hcm_simple_extract_pkg';
    gct_ApplicationSuite                      CONSTANT  xxmx_module_messages.application_suite%TYPE := 'HCM';
    gct_Application                           CONSTANT  xxmx_module_messages.application%TYPE       := 'HR';
    gv_i_BusinessEntity                       CONSTANT  VARCHAR2(100)                                := 'PERSON';
    ct_Phase                                  CONSTANT  xxmx_module_messages.phase%TYPE             := 'EXTRACT';
    cv_i_BusinessEntityLevel                  CONSTANT  VARCHAR2(100)                                := 'ALL';
    gv_hr_date					              DATE                                                       := '31-DEC-4712';

    gvv_ReturnStatus                          VARCHAR2(1);
    gvv_ProgressIndicator                     VARCHAR2(100);
    gvn_RowCount                              NUMBER;
    gvt_ReturnMessage                         xxmx_module_messages .module_message%TYPE;
    gvt_Severity                              xxmx_module_messages .severity%TYPE;
    gvt_OracleError                           xxmx_module_messages .oracle_error%TYPE;
    gvt_ModuleMessage                         xxmx_module_messages .module_message%TYPE;
    e_ModuleError                             EXCEPTION;

	 gvv_migration_date_to                     VARCHAR2(30);
    gvv_migration_date_from                   VARCHAR2(30);
    gvv_prev_tax_year_date                    VARCHAR2(30);
    gvd_migration_date_to                     DATE;
    gvd_migration_date_from                   DATE;
    gvd_prev_tax_year_date                    DATE;


    e_DateError                         EXCEPTION;

--*******************
--** PROCEDURE: export_persons
--*******************
--
 PROCEDURE export_persons(p_bg_name                  IN          VARCHAR2
                        ,p_bg_id                    IN          number
                        ,pt_i_MigrationSetID        IN          xxmx_migration_headers.migration_set_id%TYPE
                        ,pt_i_MigrationSetName      IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

        -- Local Cursors
        -- Cursor to get all eligible employees to be migrated from per_all_people_f Table
        CURSOR stg_worker_cur
        IS
            SELECT pt_i_MigrationSetID
                       AS migration_set_id,
                   'MERGE'
                       AS metadata,
                   'Worker'
                       AS worker,
                   'DATA_MIGRATION'
                       AS source_system_owner,
                   'PER_' || person_id
                       AS source_system_id,
                   person_id
                       AS person_id,
                   effective_start_date
                       AS effective_start_date,
                   effective_end_date
                       AS effective_end_date,
                   employee_number
                       AS person_number,
                    effective_start_date
                       AS start_date,     
                   'HIRE'
                       AS action_code
              FROM apps.per_all_people_f@mxdm_nvis_extract papf
             WHERE SYSDATE BETWEEN papf.effective_start_date
                               AND NVL (papf.effective_end_date, SYSDATE)
             AND papf.business_group_id = p_bg_id
             AND papf.employee_number is not null
             AND   EXISTS ( SELECT 1
                            FROM   apps.per_all_assignments_f@mxdm_nvis_extract pa
                            WHERE  SYSDATE BETWEEN pa.effective_start_date
                                               AND NVL (pa.effective_end_date, SYSDATE)
                            AND    pa.person_id  = papf.person_id )
            ;
        --
        -- Local Type Variables
        TYPE stg_worker_cur_tbl IS TABLE OF stg_worker_cur%ROWTYPE
            INDEX BY BINARY_INTEGER;
        stg_worker_cur_tb   stg_worker_cur_tbl;
        --
        -- Local Cursor to update the Supervisor Start Dates to Employee Start date when Supervisor Start Date is less than the Employee Start Date
        CURSOR emp_manager_date_cnt_cur
        IS
          
        Select  count(1) 
        from xxmx_per_persons_stg papf_sup,
            (SElect papf.person_id,papf.effective_start_date, paaf.supervisor_id from xxmx_per_persons_stg papf,apps.per_all_assignments_f@mxdm_nvis_extract paaf
            WHERE   paaf.person_id  = papf.person_id
            and paaf.supervisor_id IS NOT NULL
            and papf.migration_set_id = pt_i_MigrationSetID
            and paaf.business_group_id = p_bg_id
            AND  SYSDATE BETWEEN paaf.effective_start_date AND NVL (paaf.effective_end_date, SYSDATE))emp
        where papf_sup.person_id = emp.supervisor_id
        and papf_sup.effective_start_date > emp.effective_start_date
        and papf_sup.migration_set_id = pt_i_MigrationSetID
        and papf_sup.bg_id = p_bg_id;
        --
        CURSOR emp_manager_start_date_cur
        IS
          
        Select  emp.person_id emp_person_id,
                   emp.supervisor_id mgr_person_id,
                   emp.effective_start_date emp_effective_start_date,
                   papf_sup.effective_start_date mgr_effective_start_date 
        from xxmx_per_persons_stg papf_sup,
            (SElect papf.person_id,papf.effective_start_date, paaf.supervisor_id from xxmx_per_persons_stg papf,apps.per_all_assignments_f@mxdm_nvis_extract paaf
            WHERE   paaf.person_id  = papf.person_id
            and paaf.supervisor_id IS NOT NULL
            and papf.migration_set_id = pt_i_MigrationSetID
            and paaf.business_group_id = p_bg_id
            AND  SYSDATE BETWEEN paaf.effective_start_date AND NVL (paaf.effective_end_date, SYSDATE))emp
        where papf_sup.person_id = emp.supervisor_id
        and papf_sup.effective_start_date > emp.effective_start_date
        and papf_sup.migration_set_id = pt_i_MigrationSetID
        and papf_sup.bg_id = p_bg_id
        ORDER BY  2, 4
            ;
        --
        -- Local Type Variables
        TYPE emp_manager_start_date_cur_tbl IS TABLE OF emp_manager_start_date_cur%ROWTYPE
            INDEX BY BINARY_INTEGER;
        emp_manager_start_date_cur_tb   emp_manager_start_date_cur_tbl;
        ln_cnt NUMBER := 0;
    --

      cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_persons';
      ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
      cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'xxmx_per_persons_stg';
      cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'PERSON';

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
                ,pt_i_MigrationSetID      => pt_i_MigrationSetID
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
        DELETE
        FROM    xxmx_per_persons_stg
        WHERE   bg_id    = p_bg_id    ;
        --
        --
        OPEN stg_worker_cur;
        --

        --
        LOOP
            --
            gvv_ProgressIndicator := '0010';
            --
            FETCH stg_worker_cur
            BULK COLLECT INTO stg_worker_cur_tb
            LIMIT 1000;
            --
            gvv_ProgressIndicator := '0015';
            --
            EXIT WHEN stg_worker_cur_tb.COUNT = 0;
            --
            FOR I IN 1 .. stg_worker_cur_tb.COUNT
            --
            LOOP
                INSERT
                INTO xxmx_per_persons_stg
                            (migration_set_id,
                             migration_set_name,
                             migration_status,
                             bg_name,
                             bg_id,
                             metadata,
                             source_system_owner,
                             source_system_id,
                             person_id,
                             effective_start_date,
                             effective_end_date,
                             personnumber,
                             start_date,
                             action_code)
                     VALUES (stg_worker_cur_tb (i).migration_set_id,
                             pt_i_MigrationSetName,
                             'EXTRACTED',
                             p_bg_name,
                             p_bg_id,
                             stg_worker_cur_tb (i).metadata,
                             stg_worker_cur_tb (i).source_system_owner,
                             stg_worker_cur_tb (i).source_system_id,
                             stg_worker_cur_tb (i).person_id,
                             stg_worker_cur_tb (i).effective_start_date,
                             stg_worker_cur_tb (i).effective_end_date,
                             stg_worker_cur_tb (i).person_number,
                             stg_worker_cur_tb (i).start_date,
                             stg_worker_cur_tb (i).action_code);
            END LOOP;
        --
        END LOOP;
        --
        gvv_ProgressIndicator := '0020';
        --
        CLOSE stg_worker_cur;
        --
        
        xxmx_utilities_pkg.log_module_message(
                        pt_i_ApplicationSuite     => gct_ApplicationSuite
                        ,pt_i_Application         => gct_Application
                        ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                        ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                        ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                        ,pt_i_Phase               => ct_Phase
                        ,pt_i_Severity            => 'NOTIFICATION'
                        ,pt_i_PackageName         => gcv_PackageName
                        ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                        ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                        ,pt_i_ModuleMessage       => 'commit data to  ' ||'xxmx_per_persons_stg'
                        ,pt_i_OracleError         => NULL       );
        COMMIT;
        --
        gvv_ProgressIndicator := '0025';
        --
        LOOP
            --
            ln_cnt := 0;
            --
            gvv_ProgressIndicator := '0030';
            --
            OPEN  emp_manager_date_cnt_cur;
            --
            gvv_ProgressIndicator := '0035';
            --
            FETCH emp_manager_date_cnt_cur
            INTO  ln_cnt;
            --
            
            gvv_ProgressIndicator := '0040';
            xxmx_utilities_pkg.log_module_message(
                        pt_i_ApplicationSuite     => gct_ApplicationSuite
                        ,pt_i_Application         => gct_Application
                        ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                        ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                        ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                        ,pt_i_Phase               => ct_Phase
                        ,pt_i_Severity            => 'NOTIFICATION'
                        ,pt_i_PackageName         => gcv_PackageName
                        ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                        ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                        ,pt_i_ModuleMessage       => 'Count of Records to Update'||ln_cnt
                        ,pt_i_OracleError         => NULL       );
            --
            CLOSE emp_manager_date_cnt_cur;
            --
            EXIT WHEN ln_cnt = 0;
            --
           gvv_ProgressIndicator := '0045';
            --
            OPEN  emp_manager_start_date_cur;
            --
            gvv_ProgressIndicator := '0050';
            --
            FETCH emp_manager_start_date_cur
            BULK COLLECT INTO emp_manager_start_date_cur_tb;
            --
            gvv_ProgressIndicator := '0055';
            --
            CLOSE emp_manager_start_date_cur;
            --
            xxmx_utilities_pkg.log_module_message(
                        pt_i_ApplicationSuite     => gct_ApplicationSuite
                        ,pt_i_Application         => gct_Application
                        ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                        ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                        ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                        ,pt_i_Phase               => ct_Phase
                        ,pt_i_Severity            => 'NOTIFICATION'
                        ,pt_i_PackageName         => gcv_PackageName
                        ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                        ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                        ,pt_i_ModuleMessage       => 'Before Update'||emp_manager_start_date_cur_tb.COUNT
                        ,pt_i_OracleError         => NULL       );
                        
            FOR I IN 1 .. emp_manager_start_date_cur_tb.COUNT
            --
            LOOP
                --
                gvv_ProgressIndicator := '0060';
                  
            
                --
                UPDATE xxmx_per_persons_stg
                SET    effective_start_date = emp_manager_start_date_cur_tb(I).emp_effective_start_date
                WHERE  migration_set_id = pt_i_MigrationSetID
                AND    person_id = emp_manager_start_date_cur_tb(I).mgr_person_id;
                --
            END LOOP;
            --
            emp_manager_start_date_cur_tb.DELETE;
            --
            COMMIT;
            --
        END LOOP;
        --
        gvv_ProgressIndicator := '0065';
        --
        -- Update the Start_Date to Effective_Start_Date
        UPDATE xxmx_per_persons_stg
        SET    start_date = effective_start_date
        WHERE  migration_set_id = pt_i_MigrationSetID;
        --
        COMMIT;

        gvv_ProgressIndicator := '0070';
        xxmx_utilities_pkg.log_module_message(
                        pt_i_ApplicationSuite     => gct_ApplicationSuite
                        ,pt_i_Application         => gct_Application
                        ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                        ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                        ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                        ,pt_i_Phase               => ct_Phase
                        ,pt_i_Severity            => 'NOTIFICATION'
                        ,pt_i_PackageName         => gcv_PackageName
                        ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                        ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                        ,pt_i_ModuleMessage       => 'End of extraction at ' || to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS.FF2') || '. Procedure completed'
                        ,pt_i_OracleError         => gvt_ReturnMessage       );
    --
    EXCEPTION
        WHEN e_ModuleError THEN
                --
        xxmx_utilities_pkg.log_module_message(
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                    ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                    ,pt_i_MigrationSetID      => pt_i_MigrationSetID
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
                    ,pt_i_MigrationSetID      => pt_i_MigrationSetID
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
                    ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_Severity            => 'ERROR'
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => 'Oracle error encounted at after Progress Indicator.'
                    ,pt_i_OracleError         => gvt_OracleError       );
            --
            RAISE;

    END export_persons;

--*******************
--** PROCEDURE: export_per_name
--*******************
--
 PROCEDURE export_per_name(p_bg_name                  IN          VARCHAR2
                          ,p_bg_id                    IN          number
                          ,pt_i_MigrationSetID        IN          xxmx_migration_headers.migration_set_id%TYPE
                          ,pt_i_MigrationSetName      IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

           CURSOR stg_emp_name_cur
        IS
            SELECT pt_i_MigrationSetID
                       AS migration_set_id,
                   'MERGE'
                       AS metadata,
                   'PersonName'
                       AS person_name,
                   'DATA_MIGRATION'
                       AS source_system_owner,
                   'PER_NAME_' || papf.person_id
                       AS source_system_id,
                   xhws.effective_start_date
                       AS effective_start_date,
                   xhws.effective_end_date
                       AS effective_end_date,
                   NVL (papf.per_information_category, 'GB')
                       AS legislation_code,
                   papf.person_id
                       AS person_id,
                   'GLOBAL'
                       AS name_type,
                   papf.first_name
                       AS first_name,
                   papf.middle_names
                       AS middle_name,
                   papf.last_name
                       AS last_name,
                   employee_number
                       AS person_number,
                   xhws.source_system_id
                       AS person_source_system_id
              FROM apps.per_all_people_f@mxdm_nvis_extract papf,
                   XXMX_PER_PERSONS_STG xhws
             WHERE SYSDATE BETWEEN papf.effective_start_date AND NVL (papf.effective_end_date, SYSDATE)
                   AND papf.person_id  = xhws.person_id
                   AND xhws.MIGRATION_SET_ID = pt_i_MigrationSetID
                   AND xhws.bg_id = p_bg_id
                   ;
    --
        -- Local Type Variables
        TYPE stg_emp_name_cur_tbl IS TABLE OF stg_emp_name_cur%ROWTYPE
            INDEX BY BINARY_INTEGER;
     --
        stg_emp_name_cur_tb   stg_emp_name_cur_tbl;
     --
        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_per_name';
      ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
      cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_PER_NAMES_F_STG';
      cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'PERSON';

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
        DELETE
        FROM    XXMX_PER_NAMES_F_STG   ;
        --

        OPEN stg_emp_name_cur;
        --
        --
        gvv_ProgressIndicator := '0010';
        --
        --
        LOOP
            --
            gvv_ProgressIndicator := '0015';
            --
            FETCH stg_emp_name_cur
                BULK COLLECT INTO stg_emp_name_cur_tb
                LIMIT 1000;
            --
            gvv_ProgressIndicator := '0020';
            --
            EXIT WHEN stg_emp_name_cur_tb.COUNT = 0;
            --
            FOR I IN 1 .. stg_emp_name_cur_tb.COUNT
            --
            LOOP
                --
                    INSERT INTO XXMX_PER_NAMES_F_STG (
                                    migration_set_id,
                                    migration_set_name,
                                    migration_status,
                                    bg_name,
                                    bg_id,
                                    metadata,
                                    source_system_owner,
                                    source_system_id,
                                    effective_start_date,
                                    effective_end_date,
                                    legislation_code,
                                    person_id,
                                    name_type,
                                    first_name,
                                    middle_names,
                                    last_name,
                                    personnumber,
                                    person_source_system_id)
                             VALUES (
                                        stg_emp_name_cur_tb (i).migration_set_id,
                                        pt_i_MigrationSetName,
                                        'EXTRACTED',
                                        p_bg_name,
                                        p_bg_id,
                                        stg_emp_name_cur_tb (i).metadata,
                                        stg_emp_name_cur_tb (i).source_system_owner,
                                        stg_emp_name_cur_tb (i).source_system_id,
                                        stg_emp_name_cur_tb (i).effective_start_date,
                                        stg_emp_name_cur_tb (i).effective_end_date,
                                        stg_emp_name_cur_tb (i).legislation_code,
                                        stg_emp_name_cur_tb (i).person_id,
                                        stg_emp_name_cur_tb (i).name_type,
                                        stg_emp_name_cur_tb (i).first_name,
                                        stg_emp_name_cur_tb (i).middle_name,
                                        stg_emp_name_cur_tb (i).last_name,
                                        stg_emp_name_cur_tb (i).person_number,
                                        stg_emp_name_cur_tb (i).person_source_system_id);
            END LOOP;
        --
        END LOOP;
        --
        gvv_ProgressIndicator := '0025';
        --
        CLOSE stg_emp_name_cur;
        --
        COMMIT;
        --
        gvv_ProgressIndicator := '0030';
    --
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
        WHEN OTHERS
        THEN
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
    --
    END export_per_name;

--*******************
--** PROCEDURE: export_per_email
--*******************
--
 PROCEDURE export_per_email(p_bg_name                  IN          VARCHAR2
                          ,p_bg_id                    IN          number
                          ,pt_i_MigrationSetID        IN          xxmx_migration_headers.migration_set_id%TYPE
                          ,pt_i_MigrationSetName      IN          xxmx_migration_headers.migration_set_name%TYPE ) IS



    -- Cursor to get all eligible employee email to be migrated from per_all_people_f Table
        --
        CURSOR stg_emp_email_cur IS
            SELECT pt_i_MigrationSetID
                       AS migration_set_id,
                   'MERGE'
                       AS metadata,
                   'PersonEmail'
                       AS person_email,
                   'DATA_MIGRATION'
                       AS source_system_owner,
                   'PEM_' || papf.person_id
                       AS source_system_id,
                   xhws.effective_start_date
                       AS date_from,
                   xhws.effective_end_date
                       AS date_to,
                   'W1'
                       AS email_type,
                   papf.email_address
                       AS email_address,
                   'Y'
                       AS primary_flag,
                   xhws.personnumber
                       AS person_number,
                   xhws.source_system_id
                       AS person_source_system_id
              FROM apps.per_all_people_f@mxdm_nvis_extract papf,
                   XXMX_PER_PERSONS_STG    xhws
             WHERE SYSDATE BETWEEN papf.effective_start_date
                               AND NVL (papf.effective_end_date, SYSDATE)
                   AND TRIM(papf.email_address) IS NOT NULL
                   AND papf.person_id            = xhws.person_id
                   AND xhws.migration_set_id             = pt_i_MigrationSetID
                   AND xhws.bg_id = p_bg_id
            ;
      -- Local Type Variables
        TYPE stg_emp_email_cur_tbl IS TABLE OF stg_emp_email_cur%ROWTYPE
            INDEX BY BINARY_INTEGER;
        --
        stg_emp_email_cur_tb   stg_emp_email_cur_tbl;

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_per_email';
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'xxmx_per_email_f_stg';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'PERSON_EMAIL';
    --
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
        DELETE FROM  XXMX_PER_EMAIL_F_STG;
        --
        OPEN stg_emp_email_cur;
        --
        --
        gvv_ProgressIndicator := '0010';
        --
        --
        LOOP
            --
            gvv_ProgressIndicator := '0015';
            --
            FETCH   stg_emp_email_cur
            BULK
            COLLECT
            INTO    stg_emp_email_cur_tb
            LIMIT   1000;
            --
            gvv_ProgressIndicator := '0020';
            --
            EXIT WHEN stg_emp_email_cur_tb.COUNT = 0;
            --
            FOR I IN 1 .. stg_emp_email_cur_tb.COUNT
            --
            LOOP
                INSERT
                INTO XXMX_PER_EMAIL_F_STG (
                                    migration_set_id,
                                    migration_set_name,
                                    migration_status,
                                    bg_name,
                                    bg_id,
                                    metadata,
                                    source_system_owner,
                                    source_system_id,
                                    date_from,
                                    date_to,
                                    email_type,
                                    email_address,
                                    primary_flag,
                                    personnumber,
                                    person_source_system_id)
                         VALUES (
                                    stg_emp_email_cur_tb (i).migration_set_id,
                                    pt_i_MigrationSetName,
                                    'EXTRACTED',
                                    p_bg_name,
                                    p_bg_id,
                                    stg_emp_email_cur_tb (i).metadata,
                                    stg_emp_email_cur_tb (i).source_system_owner,
                                    stg_emp_email_cur_tb (i).source_system_id,
                                    stg_emp_email_cur_tb (i).date_from,
                                    stg_emp_email_cur_tb (i).date_to,
                                    stg_emp_email_cur_tb (i).email_type,
                                    stg_emp_email_cur_tb (i).email_address,
                                    stg_emp_email_cur_tb (i).primary_flag,
                                    stg_emp_email_cur_tb (i).person_number,
                                    stg_emp_email_cur_tb (i).person_source_system_id);
            END LOOP;
        --
        END LOOP;
        --
        gvv_ProgressIndicator := '0025';
        --
        CLOSE stg_emp_email_cur;
        --
        COMMIT;
    --
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
        WHEN OTHERS
        THEN
            --
            IF stg_emp_email_cur%ISOPEN
            THEN
                --
                CLOSE stg_emp_email_cur;
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
    --
    END export_per_email;

--*******************
--** PROCEDURE: export_phones
--*******************
--
 PROCEDURE export_phones(p_bg_name                          IN          VARCHAR2
                        ,p_bg_id                            IN          number
                        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
                        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

         -- Cursor to get all eligible employee Name to be migrated from PER_PHONES Table
        CURSOR stg_emp_phone_cur IS
            SELECT pt_i_MigrationSetID
                       AS migration_set_id,
                   'MERGE'
                       AS metadata,
                   'PersonPhone'
                       AS person_phone,
                   'DATA_MIGRATION'
                       AS source_system_owner,
                   'PER_PHONE_' || pp.parent_id
                       AS source_system_id,
                   pp.phone_type
                       AS phone_type,
                   xhws.effective_start_date
                       AS date_from,
                   xhws.effective_end_date
                       AS date_to,
                   REGEXP_REPLACE (pp.phone_number, '[^[:digit:]]', '')
                       AS phone_number,
                   xhws.personnumber
                       AS person_number,
                   xhws.source_system_id
                       AS person_source_system_id
              FROM apps.per_phones@mxdm_nvis_extract        pp,
                   apps.per_all_people_f@mxdm_nvis_extract  papf,
                   XXMX_PER_PERSONS_STG                     xhws
             WHERE     1 = 1
                   AND pp.parent_id = papf.person_id
                   AND SYSDATE BETWEEN papf.effective_start_date AND NVL (papf.effective_end_date, SYSDATE + 1)
                   AND SYSDATE BETWEEN pp.date_from AND NVL (pp.date_to, SYSDATE + 1)
                   AND pp.parent_table = 'PER_ALL_PEOPLE_F'
                   AND papf.person_id = xhws.person_id
                   AND REGEXP_REPLACE (pp.phone_number, '[^[:digit:]]', '') IS NOT NULL
                   AND xhws.migration_set_id = pt_i_MigrationSetID
                   AND xhws.bg_id = p_bg_id
                   ;
       --
        -- Local Type Variables
        TYPE stg_emp_phone_tbl IS TABLE OF stg_emp_phone_cur%ROWTYPE
            INDEX BY BINARY_INTEGER;
        stg_emp_phone_tb   stg_emp_phone_tbl;

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_phones';
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'xxmx_per_phones_stg';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'PERSON_PHONE';

      --
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
        DELETE FROM  XXMX_PER_PHONES_STG;
        --
        OPEN stg_emp_phone_cur;
        --
        gvv_ProgressIndicator := '0010';
        --
        LOOP
            --
            gvv_ProgressIndicator := '0015';
            --
            FETCH stg_emp_phone_cur
                BULK COLLECT INTO stg_emp_phone_tb
                LIMIT 1000;
            --
            gvv_ProgressIndicator := '0020';
            --
            EXIT WHEN stg_emp_phone_tb.COUNT = 0;
            --
            FOR I IN 1 .. stg_emp_phone_tb.COUNT
            --
            LOOP
                    INSERT INTO XXMX_PER_PHONES_STG (
                                    migration_set_id,
                                    migration_set_name,
                                    migration_status,
                                    bg_name,
                                    bg_id,
                                    metadata,
                                    source_system_owner,
                                    source_system_id,
                                    phone_type,
                                    date_from,
                                    date_to,
                                    phone_number,
                                    personnumber,
                                    person_source_system_id)
                             VALUES (
                                    stg_emp_phone_tb (i).migration_set_id,
                                    pt_i_MigrationSetName,
                                    'EXTRACTED',
                                    p_bg_name,
                                    p_bg_id,
                                    stg_emp_phone_tb (i).metadata,
                                    stg_emp_phone_tb (i).source_system_owner,
                                    stg_emp_phone_tb (i).source_system_id,
                                    stg_emp_phone_tb (i).phone_type,
                                    stg_emp_phone_tb (i).date_from,
                                    stg_emp_phone_tb (i).date_to,
                                    stg_emp_phone_tb (i).phone_number,
                                    stg_emp_phone_tb (i).person_number,
                                    stg_emp_phone_tb (i).person_source_system_id);
            END LOOP;
        --
        END LOOP;
        --
        gvv_ProgressIndicator := '0025';
        --
        CLOSE stg_emp_phone_cur;
        --
        COMMIT;
    --
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
        WHEN OTHERS
        THEN
            --
            IF stg_emp_phone_cur%ISOPEN
            THEN
                --
                CLOSE stg_emp_phone_cur;
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
    --
    END export_phones;

--*******************
--** PROCEDURE: export_per_mgr
--*******************
--
  PROCEDURE export_per_mgr(p_bg_name                          IN          VARCHAR2
                         ,p_bg_id                            IN          number
                         ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
                         ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

             -- Local Cursors
        -- Cursor to get all eligible employee Manager to be migrated from PER_ALL_ASSIGNMENTS_F Table
        CURSOR stg_emp_mgr_cur IS
            SELECT pt_i_MigrationSetID
                       AS migration_set_id,
                   'MERGE'
                       AS metadata,
                   'AssignmentSupervisor'
                       AS assignment,
                   'DATA_MIGRATION'
                       AS source_system_owner,
                   'MGR_' || papf.person_id
                       AS source_system_id,
                   (SELECT effective_start_date
                        FROM   XXMX_PER_PERSONS_STG
                    WHERE
                    --migration_set_id = pt_i_MigrationSetID
                       person_id = papf.person_id)
                       AS effective_start_date,
                   (SELECT effective_end_date
                    FROM    XXMX_PER_PERSONS_STG
                    WHERE
                    --migration_set_id = pt_i_MigrationSetID
                        person_id = papf.person_id)
                       AS effective_end_date,
                   'LINE_MANAGER'
                       AS manager_type,
                   papf.person_id
                       AS person_id,
                   paaf.primary_flag
                       AS primary_flag,
                   'PER_ASS_' || papf.person_id
                       AS assignment_number,
                   'PER_' || papf_supervisor.person_id
                       AS manager_person_number,
                    papf.employee_number
                       AS person_number,
                   papf_supervisor.person_id
                       AS manager_assignment_id
             FROM  apps.per_all_assignments_f@mxdm_nvis_extract paaf
                  ,apps.per_all_people_f@mxdm_nvis_extract      papf
                  ,apps.per_all_people_f@mxdm_nvis_extract      papf_supervisor
            WHERE  1 = 1
              AND  paaf.person_id  = papf.person_id
              AND  papf.employee_number is not null
              and papf.business_group_id = p_bg_id
              AND  paaf.supervisor_id  = papf_supervisor.person_id
              AND  SYSDATE BETWEEN paaf.effective_start_date
                               AND NVL (paaf.effective_end_date, SYSDATE)
              AND  SYSDATE BETWEEN papf.effective_start_date
                               AND NVL (papf.effective_end_date, SYSDATE)
              AND  SYSDATE BETWEEN papf_supervisor.effective_start_date
                               AND NVL (papf_supervisor.effective_end_date, SYSDATE)
              AND  EXISTS ( SELECT 1
                            FROM   xxmx_per_persons_stg
                            WHERE bg_id = p_bg_id
                            --migration_set_id = pt_i_MigrationSetID
                            AND  person_id = papf.person_id)
              AND  EXISTS ( SELECT 1
                            FROM   xxmx_per_persons_stg
                            WHERE bg_id = p_bg_id
                            --migration_set_id = pt_i_MigrationSetID
                             AND   person_id = papf_supervisor.person_id)
            ;
          --
        -- Local Type Variables
        TYPE stg_emp_mgr_cur_tbl IS TABLE OF stg_emp_mgr_cur%ROWTYPE
            INDEX BY BINARY_INTEGER;
        stg_emp_mgr_cur_tb   stg_emp_mgr_cur_tbl;

        --
        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_per_mgr';
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_PER_ASG_SUP_F_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'PERSON_ASG_SUPERVISOR';

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
        DELETE FROM XXMX_PER_ASG_SUP_F_STG;
        --
        OPEN stg_emp_mgr_cur;
        --
        gvv_ProgressIndicator := '0010';
        --
        LOOP
            --
            gvv_ProgressIndicator := '0015';
            --
            FETCH stg_emp_mgr_cur
            BULK  COLLECT INTO stg_emp_mgr_cur_tb
            LIMIT 1000;
            --
            gvv_ProgressIndicator := '0020';
            --
            EXIT WHEN stg_emp_mgr_cur_tb.COUNT = 0;
            --
            FOR I IN 1 .. stg_emp_mgr_cur_tb.COUNT
            --
            LOOP
                    INSERT
                    INTO   XXMX_PER_ASG_SUP_F_STG (
                                    migration_set_id,
                                    migration_set_name,
                                    migration_status,
                                    bg_name,
                                    bg_id,
                                    metadata,
                                    sourcesystemowner,
                                    sourcesystemid,
                                    effective_start_date,
                                    effective_end_date,
                                    manager_type,
                                    person_id,
                                    primary_flag,
                                    assignment_number,
                                    manager_person_number,
                                    personnumber,
                                    manager_assignment_id)
                             VALUES ( stg_emp_mgr_cur_tb (i).migration_set_id,
                                        pt_i_MigrationSetName,
                                       'EXTRACTED',
                                        p_bg_name,
                                        p_bg_id,
                                        stg_emp_mgr_cur_tb (i).metadata,
                                        stg_emp_mgr_cur_tb (i).source_system_owner,
                                        stg_emp_mgr_cur_tb (i).source_system_id,
                                        stg_emp_mgr_cur_tb (i).effective_start_date,
                                        stg_emp_mgr_cur_tb (i).effective_end_date,
                                        stg_emp_mgr_cur_tb (i).manager_type,
                                        stg_emp_mgr_cur_tb (i).person_id,
                                        stg_emp_mgr_cur_tb (i).primary_flag,
                                        stg_emp_mgr_cur_tb (i).assignment_number,
                                        stg_emp_mgr_cur_tb (i).manager_person_number,
                                        stg_emp_mgr_cur_tb (i).person_number,
                                        stg_emp_mgr_cur_tb (i).manager_assignment_id);
            END LOOP;
        --
        END LOOP;
        --
        gvv_ProgressIndicator := '0025';
        --
        CLOSE stg_emp_mgr_cur;
        --
        COMMIT;
    --
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
        WHEN OTHERS
        THEN
            --
            IF stg_emp_mgr_cur%ISOPEN
            THEN
                --
                CLOSE stg_emp_mgr_cur;
            --
            END IF;
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
    --
     END export_per_mgr;

--*******************
--** PROCEDURE: export_assignments
--*******************
--
  PROCEDURE export_assignments(p_bg_name                          IN          VARCHAR2
                                ,p_bg_id                            IN          number
                                ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
                                ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

      -- Local Cursors
        -- Cursor to get all eligible employee Work Terms to be migrated from PER_ALL_ASSIGNMENTS_F Table
        CURSOR stg_emp_assi_cur
        IS
            SELECT pt_i_MigrationSetID
                       AS migration_set_id,
                   'MERGE'
                       AS metadata,
                   'Assignment'
                       AS assignment,
                   'DATA_MIGRATION'
                       AS source_system_owner,
                   'PER_ASS_' || papf.person_id
                       AS source_system_id,
                   papf.person_id
                       AS person_id,
                    xhws.personnumber
                       AS person_number,
                    'Y'
                     AS  PRIMARY_WORK_TERMS_FLAG,
                   papf.person_id
                       AS work_terms_assignment_id,
                   'HIRE'
                       AS action_code,
                   xhws.effective_start_date
                       AS effective_start_date,
                   xhws.effective_end_date
                       AS effective_end_date,
                   'ACTIVE_PROCESS'
                       AS assignment_status_type_code,
                   'Employee'
                       AS person_type_code,
                   'Client'
                       AS business_unit_short_code,
                    'Client'
                       AS location_code,
                   paaf.assignment_number
                       AS assignment_name,
                   paaf.assignment_number
                       AS assignment_number,
                   'Y'
                       AS primary_assignment_flag,
                   '1'
                       AS effective_sequence,
                   'Y'
                       AS effective_latest_change,
                   gcc.concatenated_segments
                       AS default_expense_account,
                   ''
                       AS job_code
              FROM     apps.per_all_people_f@mxdm_nvis_extract           papf,
                       apps.per_all_assignments_f@mxdm_nvis_extract      paaf,
                       apps.gl_code_combinations_kfv@mxdm_nvis_extract   gcc,
                       XXMX_PER_PERSONS_STG              xhws
             WHERE     SYSDATE BETWEEN papf.effective_start_date AND NVL (papf.effective_end_date, SYSDATE)
                   AND paaf.person_id                         = papf.person_id
                   AND paaf.default_code_comb_id              = gcc.code_combination_id(+)
                   AND paaf.primary_flag                      = 'Y'
                   AND paaf.assignment_number is not null
                   AND SYSDATE BETWEEN paaf.effective_start_date AND NVL (paaf.effective_end_date, SYSDATE)
                   AND papf.person_id                         = xhws.person_id
                   AND xhws.bg_id = p_bg_id
                   --AND xhws.MIGRATION_SET_ID                  = pt_i_MigrationSetID
            ;

          -- Local Type Variables
        TYPE stg_emp_assi_cur_tbl IS TABLE OF stg_emp_assi_cur%ROWTYPE
            INDEX BY BINARY_INTEGER;
        stg_emp_assi_cur_tb   stg_emp_assi_cur_tbl;

        --
        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_assignments';
      ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
      cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_PER_ASSIGNMENTS_M_STG';
      cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'PERSON_ASSIGNMENTS';

      e_DateError                         EXCEPTION;
    --
    BEGIN
        --
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
        DELETE FROM XXMX_PER_ASSIGNMENTS_M_STG;
        --
        OPEN stg_emp_assi_cur;
        --
        gvv_ProgressIndicator := '0010';
        --
        LOOP
            --
            gvv_ProgressIndicator := '0015';
            --
            FETCH stg_emp_assi_cur
            BULK COLLECT INTO stg_emp_assi_cur_tb
            LIMIT 1000;
            --
            gvv_ProgressIndicator := '0020';
            --
            EXIT WHEN stg_emp_assi_cur_tb.COUNT = 0;
            --
            FOR I IN 1 .. stg_emp_assi_cur_tb.COUNT
            --
            LOOP
                    INSERT
                    INTO XXMX_PER_ASSIGNMENTS_M_STG (
                                    migration_set_id,
                                    migration_set_name,
                                    migration_status,
                                    bg_name,
                                    bg_id,
                                    metadata,
                                    sourcesystemowner,
                                    sourcesystemid,
                                    person_id,
                                    personnumber,
                                    PRIMARY_WORK_TERMS_FLAG,
                                    work_terms_assignment_id,
                                    action_code,
                                    effective_start_date,
                                    effective_end_date,
                                    assignment_status_type_code,
                                    person_type_code,
                                    business_unit_short_code,
                                    location_code,
                                    assignment_name,
                                    assignment_number,
                                    primary_assignment_flag,
                                    effective_sequence,
                                    effective_latest_change,
                                    default_expense_account,
                                    job_code)
                             VALUES (
                                    stg_emp_assi_cur_tb (i).migration_set_id,
                                    pt_i_MigrationSetName,
                                    'EXTRACTED',
                                    p_bg_name,
                                    p_bg_id,
                                    stg_emp_assi_cur_tb (i).metadata,
                                    stg_emp_assi_cur_tb (i).source_system_owner,
                                    stg_emp_assi_cur_tb (i).source_system_id,
                                    stg_emp_assi_cur_tb (i).person_id,
                                    stg_emp_assi_cur_tb (i).person_number,
                                    stg_emp_assi_cur_tb (i).PRIMARY_WORK_TERMS_FLAG,
                                    stg_emp_assi_cur_tb (i).work_terms_assignment_id,
                                    stg_emp_assi_cur_tb (i).action_code,
                                    stg_emp_assi_cur_tb (i).effective_start_date,
                                    stg_emp_assi_cur_tb (i).effective_end_date,
                                    stg_emp_assi_cur_tb (i).assignment_status_type_code,
                                    stg_emp_assi_cur_tb (i).person_type_code,
                                    stg_emp_assi_cur_tb (i).business_unit_short_code,
                                    stg_emp_assi_cur_tb (i).location_code,
                                    stg_emp_assi_cur_tb (i).assignment_name,
                                    stg_emp_assi_cur_tb (i).assignment_number,
                                    stg_emp_assi_cur_tb (i).primary_assignment_flag,
                                    stg_emp_assi_cur_tb (i).effective_sequence,
                                    stg_emp_assi_cur_tb (i).effective_latest_change,
                                    stg_emp_assi_cur_tb (i).default_expense_account,
                                    stg_emp_assi_cur_tb (i).job_code);
            END LOOP;
        --
        END LOOP;
        --
        gvv_ProgressIndicator := '0025';
        --
        CLOSE stg_emp_assi_cur;
        --
        COMMIT;
        --
         gvv_ProgressIndicator := '0030';
    --
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
        WHEN OTHERS
        THEN
            --
            IF stg_emp_assi_cur%ISOPEN
            THEN
                --
                CLOSE stg_emp_assi_cur;
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

    END export_assignments;

--*******************
--** PROCEDURE: export_per_workrel
--*******************
--
  PROCEDURE export_per_workrel(p_bg_name                          IN          VARCHAR2
                              ,p_bg_id                            IN          number
                              ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
                              ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

    -- Local Cursors
        -- Cursor to get all eligible employee Work Relationship to be migrated from STG Table
        CURSOR stg_emp_workrel_cur
        IS
            SELECT pt_i_MigrationSetID
                       AS migration_set_id,
                   'MERGE'
                       AS metadata,
                   'WorkRelationship'
                       AS work_relationship,
                   'DATA_MIGRATION'
                       AS source_system_owner,
                   'PER_WR_' || papf.person_id
                       AS source_system_id,
                   papf.person_id
                       AS person_id,
                   papf.employee_number
                       AS person_number,
                   xhws.effective_start_date
                       AS date_start,
                   'Client'
                       AS legal_employer_name,
                   'E'
                       AS worker_type,
                   'Y'
                       AS primary_flag,
                   xhws.source_system_id
                       AS person_source_system_id,
                    ppos.period_of_Service_id
              FROM apps.per_all_people_f@mxdm_nvis_extract        papf,
                   apps.per_periods_of_service@mxdm_nvis_extract  ppos,
                   XXMX_PER_PERSONS_STG           xhws
             WHERE     SYSDATE BETWEEN papf.effective_start_date AND NVL (papf.effective_end_date, SYSDATE)
                   AND ppos.person_id = papf.person_id
                   AND papf.person_id = xhws.person_id
                   AND xhws.bg_id = p_bg_id;
                   --AND xhws.migration_set_id = pt_i_MigrationSetID;
        --
        -- Local Type Variables
        TYPE stg_emp_workrel_cur_tbl IS TABLE OF stg_emp_workrel_cur%ROWTYPE
            INDEX BY BINARY_INTEGER;
        stg_emp_workrel_cur_tb   stg_emp_workrel_cur_tbl;

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_per_workrel';
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_PER_WORKREL_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'PERSON_WORKRELATIONSHIP';
    --
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
        DELETE FROM XXMX_PER_WORKREL_STG;
        --
        OPEN stg_emp_workrel_cur;
        --
        gvv_ProgressIndicator := '0010';
        --
        LOOP
            --
            gvv_ProgressIndicator := '0015';
            --
            FETCH stg_emp_workrel_cur
            BULK COLLECT INTO stg_emp_workrel_cur_tb
            LIMIT 1000;
            --
            gvv_ProgressIndicator := '0020';
            --
            EXIT WHEN stg_emp_workrel_cur_tb.COUNT = 0;
            --
            FOR I IN 1 .. stg_emp_workrel_cur_tb.COUNT
            --
            LOOP
                    INSERT
                    INTO XXMX_PER_WORKREL_STG (
                                    migration_set_id,
                                    migration_set_name,
                                    migration_status,
                                    bg_name,
                                    bg_id,
                                    metadata,
                                    source_system_owner,
                                    source_system_id,
                                    person_id,
                                    personnumber,
                                    date_start,
                                    legal_employer_name,
                                    worker_type,
                                    primary_flag,
                                    person_source_system_id,
                                    period_of_Service_id)
                             VALUES (
                                    stg_emp_workrel_cur_tb (i).migration_set_id,
                                    pt_i_MigrationSetName,
                                    'EXTRACTED',
                                    p_bg_name,
                                    p_bg_id,
                                    stg_emp_workrel_cur_tb (i).metadata,
                                    stg_emp_workrel_cur_tb (i).source_system_owner,
                                    stg_emp_workrel_cur_tb (i).source_system_id,
                                    stg_emp_workrel_cur_tb (i).person_id,
                                    stg_emp_workrel_cur_tb (i).person_number,
                                    stg_emp_workrel_cur_tb (i).date_start,
                                    stg_emp_workrel_cur_tb (i).legal_employer_name,
                                    stg_emp_workrel_cur_tb (i).worker_type,
                                    stg_emp_workrel_cur_tb (i).primary_flag,
                                    stg_emp_workrel_cur_tb (i).person_source_system_id,
                                    stg_emp_workrel_cur_tb (i).period_of_Service_id);
            END LOOP;
        --
        END LOOP;
        --
        gvv_ProgressIndicator := '0025';
        --
        CLOSE stg_emp_workrel_cur;
        --
        COMMIT;
    --
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
        WHEN OTHERS
        THEN
            --
            IF stg_emp_workrel_cur%ISOPEN
            THEN
                --
                CLOSE stg_emp_workrel_cur;
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
  END export_per_workrel;

--*******************
--** PROCEDURE: export_per_pos_wr
--*******************
--

 PROCEDURE export_per_pos_wr(p_bg_name                          IN          VARCHAR2
                            ,p_bg_id                            IN          number
                            ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
                            ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE )  IS

         -- Local Cursors
        -- Cursor to get all eligible employee Work Terms to be migrated from PER_ALL_PEOPLE_F Table
        CURSOR stg_emp_workterm_cur IS
            SELECT pt_i_MigrationSetID
                       AS migration_set_id,
                   'MERGE'
                       AS metadata,
                   'WorkTerms'
                       AS work_terms,
                   'DATA_MIGRATION'
                       AS source_system_owner,
                   'PER_WT_' || papf.person_id
                       AS source_system_id,
                   papf.person_id
                       AS period_of_service_id,
                   papf.person_id
                       AS assignment_id,
                   papf.person_id
                       AS person_id,
                   papf.employee_number
                       AS person_number,
                   xhws.effective_start_date
                       AS date_start,
                   'Client'
                       AS legal_employer_name,
                   'HIRE'
                       AS action_code,
                   'WT' || papf.person_id
                       AS assignment_name,
                   'WT' || papf.person_id
                       AS assignment_number,
                   'ACTIVE_PROCESS'
                       AS assignment_status_type_code,
                   'ET'
                       AS assignment_type,
                   xhws.effective_start_date
                       AS effective_start_date,
                   xhws.effective_end_date
                       AS effective_end_date,
                   'Y'
                       AS effective_latest_change,
                   '1'
                       AS effective_sequence,
                   'PER_WR_' || papf.person_id
                       AS workrel_source_system_id
              FROM apps.per_all_people_f@mxdm_nvis_extract papf,
                   XXMX_PER_PERSONS_STG xhws
             WHERE     SYSDATE BETWEEN papf.effective_start_date AND NVL (papf.effective_end_date, SYSDATE)
                   AND papf.person_id = xhws.person_id
                   AND xhws.bg_id = p_bg_id;
                   --AND xhws.migration_set_id = pt_i_MigrationSetID;
       --
        -- Local Type Variables
        TYPE stg_emp_workterm_cur_tbl IS TABLE OF stg_emp_workterm_cur%ROWTYPE INDEX BY BINARY_INTEGER;
        stg_emp_workterm_cur_tb   stg_emp_workterm_cur_tbl;

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_per_pos_wr';
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_PER_POS_WR_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'PERSON_POS';
   --
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
        DELETE FROM XXMX_PER_POS_WR_STG;
        --
        OPEN stg_emp_workterm_cur;
        --
        gvv_ProgressIndicator := '0010';
        --
        LOOP
            --
            gvv_ProgressIndicator := '0015';
            --
            FETCH stg_emp_workterm_cur
            BULK COLLECT INTO stg_emp_workterm_cur_tb
            LIMIT 1000;
            --
            gvv_ProgressIndicator := '0020';
            --
            EXIT WHEN stg_emp_workterm_cur_tb.COUNT = 0;
            --
            FOR I IN 1 .. stg_emp_workterm_cur_tb.COUNT
            --
            LOOP
                    INSERT
                    INTO XXMX_PER_POS_WR_STG (
                                    migration_set_id,
                                    migration_set_name,
                                    migration_status,
                                    bg_name,
                                    bg_id,
                                    metadata,
                                    source_system_owner,
                                    sourcesystemid,
                                    period_of_service_id,
                                    assignment_id,
                                    person_id,
                                    personnumber,
                                    date_start,
                                    legal_employer_name,
                                    action_code,
                                    assignment_name,
                                    assignment_number,
                                    assignment_status_type_code,
                                    assignment_type,
                                    effective_start_date,
                                    effective_end_date,
                                    effective_latest_change,
                                    effective_sequence,
                                    workrel_source_system_id)
                             VALUES (
                                    stg_emp_workterm_cur_tb (i).migration_set_id,
                                    pt_i_MigrationSetName,
                                    'EXTRACTED',
                                    p_bg_name,
                                    p_bg_id,
                                    stg_emp_workterm_cur_tb (i).metadata,
                                    stg_emp_workterm_cur_tb (i).source_system_owner,
                                    stg_emp_workterm_cur_tb (i).source_system_id,
                                    stg_emp_workterm_cur_tb (i).period_of_service_id,
                                    stg_emp_workterm_cur_tb (i).assignment_id,
                                    stg_emp_workterm_cur_tb (i).person_id,
                                    stg_emp_workterm_cur_tb (i).person_number,
                                    stg_emp_workterm_cur_tb (i).date_start,
                                    stg_emp_workterm_cur_tb (i).legal_employer_name,
                                    stg_emp_workterm_cur_tb (i).action_code,
                                    stg_emp_workterm_cur_tb (i).assignment_name,
                                    stg_emp_workterm_cur_tb (i).assignment_number,
                                    stg_emp_workterm_cur_tb (i).assignment_status_type_code,
                                    stg_emp_workterm_cur_tb (i).assignment_type,
                                    stg_emp_workterm_cur_tb (i).effective_start_date,
                                    stg_emp_workterm_cur_tb (i).effective_end_date,
                                    stg_emp_workterm_cur_tb (i).effective_latest_change,
                                    stg_emp_workterm_cur_tb (i).effective_sequence,
                                    stg_emp_workterm_cur_tb (i).workrel_source_system_id);
            END LOOP;
        --
        END LOOP;
        --
         gvv_ProgressIndicator := '0025';
        --
        CLOSE stg_emp_workterm_cur;
        --
        COMMIT;
    --
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
        WHEN OTHERS
        THEN
            --
            IF stg_emp_workterm_cur%ISOPEN
            THEN
                --
                CLOSE stg_emp_workterm_cur;
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

   END export_per_pos_wr;
   /*******************************************
   export_per_addr_f_us
   ********************************************/
   
   PROCEDURE export_per_addr_f_us(p_bg_name                  IN          VARCHAR2
                        ,p_bg_id                    IN          number
                        ,pt_i_MigrationSetID        IN          xxmx_migration_headers.migration_set_id%TYPE
                        ,pt_i_MigrationSetName      IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

        -- Local Cursors
        -- Cursor to get all eligible employees to be migrated from per_all_people_f Table
        CURSOR stg_add_cur
        IS
            SELECT pt_i_MigrationSetID 
                        migration_set_id,
                   'MERGE'
                       AS metadata,
                   'PersonAddress'
                       AS OBJECTNAME,
                   'DATA_MIGRATION'
                       AS source_system_owner,
                   'PER_ADD_' || xhws.person_id
                       AS source_system_id,
                   xhws.person_id
                       AS person_id,
                   date_from
                       AS effective_start_date,
                   date_to
                       AS effective_end_date,
                   xhws.personnumber
                       AS person_number,
                   'HIRE'
                       AS action_code,
                    pa.address_line1
                    ,pa.address_line2
                    ,pa.address_line3
                    ,pa.town_or_city
                    ,pa.region_1 
                    ,pa.region_2
                    ,pa.country
                    ,pa.postal_code
                    ,pa.derived_locale
                    ,pa.address_id --||'_'||'PERSON_ADDRESS'  -- Commented by Ayush Rathore for Task 1838 
                    ,pa.primary_flag
                    ,pa.telephone_number_1
                    ,pa.telephone_number_2
                    ,pa.telephone_number_3
                    ,NVL(pa.address_type ,'MAIL') address_type
                    ,addr_attribute1
                    ,addr_attribute2
                    ,addr_attribute3
                    ,addr_attribute4
                    ,addr_attribute5
                    ,xhws.source_system_id
                       AS person_source_system_id
              FROM XXMX_PER_PERSONS_STG xhws
                  ,apps.per_addresses@MXDM_NVIS_EXTRACT PA
             WHERE SYSDATE BETWEEN pa.date_From
                               AND NVL (pa.date_to, SYSDATE)
             --AND xhws.bg_id = p_bg_id
             AND pa.person_id = xhws.person_id
            ;
        
        --
        -- Local Type Variables
        TYPE stg_add_cur_tbl IS TABLE OF stg_add_cur%ROWTYPE
            INDEX BY BINARY_INTEGER;
        stg_add_cur_tb   stg_add_cur_tbl;
        --

      cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_persons';
      ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
      cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'xxmx_per_persons_stg';
      cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'PERSON';

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
                ,pt_i_MigrationSetID      => pt_i_MigrationSetID
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
        DELETE
        FROM    xxmx_per_address_f_stg
        WHERE   bg_id    = p_bg_id    ;
        --
        --
        OPEN stg_add_cur;
        --

        --
        LOOP
            --
            gvv_ProgressIndicator := '0010';
            --
            FETCH stg_add_cur
            BULK COLLECT INTO stg_add_cur_tb
            LIMIT 1000;
            --
            gvv_ProgressIndicator := '0015';
            --
            EXIT WHEN stg_add_cur_tb.COUNT = 0;
            --
            FOR I IN 1 .. stg_add_cur_tb.COUNT
            --
            LOOP
                INSERT
                INTO xxmx_per_address_f_stg
                            (migration_set_id
                            ,migration_set_name                   
                            ,migration_status
                            ,bg_name
                            ,bg_id
                            ,metadata
                            ,effective_start_date
                            ,effective_end_date
                            ,address_line_1
                            ,address_line_2
                            ,address_line_3
                            ,town_or_city
                            ,region_1
                            ,region_2
                            ,country
                            ,postal_code
                            ,derived_locale
                            ,address_id
                            ,Person_id
                            ,Primary_flag
                            ,Telephone_number_1
                            ,TELEPHONE_NUMBER_2
                            ,TELEPHONE_NUMBER_3
                            ,address_type
                            ,personnumber
                            ,OBJECTNAME
                            ,SOURCE_SYSTEM_OWNER
                            ,SOURCE_SYSTEM_ID
                            ,person_source_system_id
                            )
                     VALUES (stg_add_cur_tb (i).migration_set_id,
                             pt_i_MigrationSetName,
                             'EXTRACTED',
                             p_bg_name,
                             p_bg_id,
                             stg_add_cur_tb (i).metadata,
                             stg_add_cur_tb (i).effective_start_date,
                             stg_add_cur_tb (i).effective_end_date,
                             stg_add_cur_tb (i).address_line1,
                             stg_add_cur_tb (i).address_line2,
                             stg_add_cur_tb (i).address_line3,
                             stg_add_cur_tb (i).town_or_city,
                             stg_add_cur_tb (i).region_1,
                             stg_add_cur_tb (i).region_2,
                             stg_add_cur_tb (i).country,
                             stg_add_cur_tb (i).postal_code,
                             stg_add_cur_tb (i).derived_locale,
                             stg_add_cur_tb (i).address_id,
                             stg_add_cur_tb (i).person_id,
                             stg_add_cur_tb (i).Primary_flag,
                             stg_add_cur_tb (i).Telephone_number_1,
                             stg_add_cur_tb (i).TELEPHONE_NUMBER_2,
                             stg_add_cur_tb (i).TELEPHONE_NUMBER_3,
                             stg_add_cur_tb (i).address_type,
                             stg_add_cur_tb (i).person_number,
                             stg_add_cur_tb (i).OBJECTNAME,
                             stg_add_cur_tb (i).source_system_owner,
                             stg_add_cur_tb (i).source_system_id,
                             stg_add_cur_tb (i).person_source_system_id);
            END LOOP;
        --
        END LOOP;
        --
        gvv_ProgressIndicator := '0020';
        --
        CLOSE stg_add_cur;
        --
       COMMIT; 
        xxmx_utilities_pkg.log_module_message(
                        pt_i_ApplicationSuite     => gct_ApplicationSuite
                        ,pt_i_Application         => gct_Application
                        ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                        ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                        ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                        ,pt_i_Phase               => ct_Phase
                        ,pt_i_Severity            => 'NOTIFICATION'
                        ,pt_i_PackageName         => gcv_PackageName
                        ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                        ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                        ,pt_i_ModuleMessage       => 'commit data to  ' ||'xxmx_per_address_f_stg'
                        ,pt_i_OracleError         => NULL       );
        COMMIT;
        --
        gvv_ProgressIndicator := '0025';
        --
       
        gvv_ProgressIndicator := '0070';
        xxmx_utilities_pkg.log_module_message(
                        pt_i_ApplicationSuite     => gct_ApplicationSuite
                        ,pt_i_Application         => gct_Application
                        ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                        ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                        ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                        ,pt_i_Phase               => ct_Phase
                        ,pt_i_Severity            => 'NOTIFICATION'
                        ,pt_i_PackageName         => gcv_PackageName
                        ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                        ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                        ,pt_i_ModuleMessage       => 'End of extraction at ' || to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS.FF2') || '. Procedure completed'
                        ,pt_i_OracleError         => gvt_ReturnMessage       );
    --
    EXCEPTION
        WHEN e_ModuleError THEN
                --
        xxmx_utilities_pkg.log_module_message(
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                    ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                    ,pt_i_MigrationSetID      => pt_i_MigrationSetID
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
                    ,pt_i_MigrationSetID      => pt_i_MigrationSetID
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
                    ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_Severity            => 'ERROR'
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => 'Oracle error encounted at after Progress Indicator.'
                    ,pt_i_OracleError         => gvt_OracleError       );
            --
            RAISE;

    END export_per_addr_f_us;

END xxmx_hcm_simple_extract_pkg;
/
show errors package body xxmx_hcm_simple_extract_pkg;
/