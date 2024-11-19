create or replace PACKAGE XXMX_PPM_PROJECTS_PKG AS 
     /*
     *****************************************************************************
     **
     **                 Copyright (c) 2020 Version 1
     **
     **                           Millennium House,
     **                           Millennium Walkway,
     **                           Dublin 1
     **                           D01 F5P8
     **
     **                           All rights reserved.
     **
     *****************************************************************************
     **
     **
     ** FILENAME  :  xxmx_ppm_projects_pkg.sql
     **
     ** FILEPATH  :  $XXMX_TOP/install/sql
     **
     ** VERSION   :  1.0
     **
     ** EXECUTE
     ** IN SCHEMA :  APPS
     **
     ** AUTHORS   :  Pallavi Kanajar
     **
     ** PURPOSE   :  This package contains procedures for extracting Projects 
     **               into Staging tables
     ** NOTES     :
     **
     ******************************************************************************
     **
     ** PRE-REQUISITIES
     ** ---------------
     **
     ** If this script is to be executed as part of an installation script, ensure
     ** that the installation script performs the following tasks prior to calling
     ** this script.
     **
     ** Task  Description
     ** ----  ---------------------------------------------------------------------
     ** 1.    Run the installation script to create all necessary database objects
     **       and Concurrent definitions:
     **
     **            $XXMX_TOP/install/sql/xxmx_ap_inv_stg_dbi.sql
     **            $XXMX_TOP/install/sql/xxmx_ap_inv_xfm_dbi.sql
     **
     ** If this script is not to be executed as part of an installation script,
     ** ensure that the tasks above are, or have been, performed prior to executing
     ** this script.
     **
     ******************************************************************************
     **
     ** CALLING INSTALLATION SCRIPTS
     ** ----------------------------
     **
     ** The following installation scripts call this script:
     **
     ** File Path                                     File Name
     ** --------------------------------------------  ------------------------------
     ** N/A                                           N/A
     **
     ******************************************************************************
     **
     ** CALLED INSTALLATION SCRIPTS
     ** ---------------------------
     **
     ** The following installation scripts are called by this script:
     **
     ** File Path                                    File Name
     ** -------------------------------------------  ------------------------------
     ** N/A                                          N/A
     **
     ******************************************************************************
     **
     ** PARAMETERS
     ** ----------
     **
     ** Parameter                       IN OUT  Type
     ** -----------------------------  ------  ------------------------------------
     ** [parameter_name]                IN OUT
     **
     ******************************************************************************
     **
     ** [previous_filename] HISTORY
     ** -----------------------------
     **
     **   Vsn  Change Date  Changed By          Change Description
     ** -----  -----------  ------------------  -----------------------------------
     ** [ 1.0  DD-Mon-YYYY  Change Author       Created.                          ]
     **
     ******************************************************************************
     **
     ** xxcust_common_pkg.sql HISTORY
     ** ------------------------------------
     **
     **   Vsn  Change Date  Changed By          Change Description
     ** -----  -----------  ------------------  -----------------------------------
     **   1.0  23-OCT-2021  Pallavi Kanajar      Created for Maximise.
     **
     **
     ******************************************************************************
     **
     **  Data Element Prefixes
     **  =====================
     **
     **  Utilizing prefixes for data and object names enhances the readability of code
     **  and allows for the context of a data element to be identified (and hopefully
     **  understood) without having to refer to the data element declarations section.
     **
     **  For example, having a variable in code simply named "x_id" is not very
     **  useful.  Don't laugh, I've seen it done.
     **
     **  If you came across such a variable hundreds of lines down in a packaged
     **  procedure or function, you could assume the variable's data type was
     **  NUMBER or INTEGER (if its purpose was to store an Oracle internal ID),
     **  but you would have to check in the declaration section to be sure.
     **
     **  However, if the purpose of the "x_id" variable was not to store an Oracle
     **  internal ID but perhaps some kind of client data identifier e.g. an
     **  Employee ID (and you could not tell this from the name) then the data type
     **  could easily be be VARCHAR2.  Again, you would have to navigate to the
     **  declaration section to be sure of the data type.
     **
     **  Also, the variable name does not give any developer who may need to modify
     **  the code (apart from the original author that is) any context as to the
     **  meaning of the variable.  Even the original author may struggle to remember
     **  what this variable is used for if s/he had to modify their own code months
     **  or years in the future.
     **
     **  This Package utilises prefixes of upto 6 characters for all data elements
     **  wherever possible.
     **
     **  The construction of Prefixes is governed by the following rules:
     **
     **       Parameters
     **       ----------
     **       1) Parameter prefixes always start with "p".
     **
     **       2) The second character in a parameter prefix denotes its
     **          data type:
     **
     **               b = Data element of type BOOLEAN.
     **               d = Data element of type DATE.
     **               i = Data element of type INTEGER.
     **               n = Data element of type NUMBER.
     **               r = Data element of type REAL.
     **               v = Data element of type VARCHAR2.
     **               t = Data element of type %TYPE (DB inherited type).
     **
     **       3) The third and/or fourth characters in a parameter prefix
     **          denote the direction in which value in the paramater is
     **          communicated:
     **
     **               i  = Input parameter (readable value only)
     **               o  = Output parameter (value assignable)
     **               io = Input/Output parameter (readable/assignable)
     **
     **          For clarity, the direction indicators are separated from
     **          the first two characters by an underscore. e.g. pv_i_
     **
     **       Global Data Elements
     **       --------------------
     **       1) Global data elements will always start with a "g" whether
     **          defined in the package body (and therefore only global within
     **          the package itself), or defined in the package specification
     **          (and therefore referencable outside of the package).
     **
     **          The subequent characters in a global prefix will follow the same
     **          conventions as per local constants and variables as explained
     **          below.
     **
     **       Local Data Elements
     **       -------------------
     **       1) The first character of a local data element's prefix (or second
     **          character for global) denotes the data element's assignability:
     **
     **               c = Denotes a constant.
     **
     **               v = Denotes a variable.
     **
     **       2) The second character or a local data element's prefix (or third
     **          character for global) denotes its data type (as with parameters):
     **
     **               b = Data element of type BOOLEAN.
     **               d = Data element of type DATE.
     **               i = Data element of type INTEGER.
     **               n = Data element of type NUMBER.
     **               r = Data element of type REAL.
     **               v = Data element of type VARCHAR2.
     **               t = Data element of type %TYPE (DB inherited type).
     **
     **  Prefix Examples
     **  ===============
     **
     **       Prefix    Indication
     **       --------  ----------------------------------------
     **       pb_i_     Input Parameter of type BOOLEAN
     **       pd_i_     Input Parameter of type DATE
     **       pi_i_     Input Parameter of type INTEGER
     **       pn_i_     Input Parameter of type NUMBER
     **       pr_i_     Input Parameter of type REAL
     **       pv_i_     Input Parameter of type VARCHAR2
     **       pt_i_     Input Parameter of type %TYPE
     **
     **       pb_o_     Output Parameter of type BOOLEAN
     **       pd_o_     Output Parameter of type DATE
     **       pi_o_     Output Parameter of type INTEGER
     **       pn_o_     Output Parameter of type NUMBER
     **       pr_o_     Output Parameter of type REAL
     **       pv_o_     Output Parameter of type VARCHAR2
     **       pt_o_     Output Parameter of type %TYPE
     **
     **       pb_io_    Input/Output Parameter of type BOOLEAN
     **       pd_io_    Input/Output Parameter of type DATE
     **       pi_io_    Input/Output Parameter of type INTEGER
     **       pn_io_    Input/Output Parameter of type NUMBER
     **       pr_io_    Input/Output Parameter of type REAL
     **       pv_io_    Input/Output Parameter of type VARCHAR2
     **       pt_io_    Input/Output Parameter of type %TYPE
     **
     **       gcb_      Global Constant of type BOOLEAN
     **       gcd_      Global Constant of type DATE
     **       gci_      Global Constant of type INTEGER
     **       gcn_      Global Constant of type NUMBER
     **       gcr_      Global Constant of type REAL
     **       gcv_      Global Constant of type VARCHAR2
     **       gct_      Global Constant of type %TYPE
     **
     **       gvb_      Global Variable of type BOOLEAN
     **       gvd_      Global Variable of type DATE
     **       gvi_      Global Variable of type INTEGER
     **       gvn_      Global Variable of type NUMBER
     **       gvr_      Global Variable of type REAL
     **       gvv_      Global Variable of type VARCHAR2
     **       gvt_      Global Variable of type %TYPE
     **
     **       cb_       Constant of type BOOLEAN
     **       cd_       Constant of type DATE
     **       ci_       Constant of type INTEGER
     **       cn_       Constant of type NUMBER
     **       cr_       Constant of type REAL
     **       cv_       Constant of type VARCHAR2
     **       ct_       Constant of type %TYPE
     **
     **       vb_       Variable of type BOOLEAN
     **       vd_       Variable of type DATE
     **       vi_       Variable of type INTEGER
     **       vn_       Variable of type NUMBER
     **       vr_       Variable of type REAL
     **       vv_       Variable of type VARCHAR2
     **       vt_       Variable of type %TYPE
     **
     **  PL/SQL Construct Suffixes
     **  =========================
     **
     **  Specific suffixes have been employed for PL/SQL Constructs:
     **
     **       _cur      Cursor Names
     **       _rt       PL/SQL Record Type Declarations
     **       _tt       PL/SQL Table Type Declarations
     **       _tbl      PL/SQL Table Declarations
     **       _rec      PL/SQL Record Declarations (or implicit
     **                 cursor record declarations)
     **
     **  Other Data Element Naming Conventions
     **  =====================================
     **
     **  Data elements names should have meaning which indicate their purpose or
     **  usage whilst adhering to the Oracle name length limit of 30 characters.
     **
     **  To compensate for longer data element prefixes, the rest of a data element
     **  name is constructed without underscores.  However to aid in maintaining
     **  readability and meaning, data elements names will contain concatenated
     **  words with initial letters capitalised in a similar manner to JAVA naming
     **  conventions.
     **
     **  By using the above conventions you can create meaningful data element
     **  names such as:
     **
     **       pn_i_POHeaderID
     **       ---------------
     **       This clearly identifies that the data element is an inbound only
     **       (non assignable) parameter of type NUMBER which holds an Oracle
     **       internal PO Header identifier.
     **
     **       pb_o_CreateOutputFileAsCSV
     **       --------------------------
     **       This clearly identifies that the data element is an output only
     **       parameter of type BOOLEAN that contains a flag which indicates
     **       that output of the calling process should be formatted as a CSV
     **       file.
     **
     **       gct_PackageName
     **       ---------------
     **       This data element is a global constant of type VARCHAR2.
     **
     **       ct_ProcOrFuncName
     **       -----------------
     **       This data element is a local constant of type VARCHAR2.
     **
     **       vt_APInvoiceID
     **       --------------
     **       This data element is a variable whose type is determined from a
     **       database table column and is meant to hold the Oracle internal
     **       identifier for a Payables Invoice Header.
     **
     **       vt_APInvoiceLineID
     **       ------------------
     **       Similar to the previous example but this clearly identified that the
     **       data element is intended to hold the Oracle internal identifier for
     **       a Payables Invoice Line.
     **
     **  Similarly for PL/SQL Constructs:
     **
     **       APInvoiceHeaders_cur
     **
     **       APInvoiceHeader_rec
     **
     **       TYPE EmployeeData_rt IS RECORD OF
     **            (
     **             employee_number   VARCHAR2(20)
     **            ,employee_name     VARCHAR2(30)
     **            );
     **
     **       TYPE EmployeeData_tt IS TABLE OF Employee_rt;
     **
     **       EmployeeData_tbl        EmployeeData_tt;
     **
     **  Careful and considerate use of the above rules when naming data elements
     **  can be a boon to other developers who may need to understand and/or modify
     **  your code in future.  In conjunction with good commenting practices of
     **  course.
     **
     ******************************************************************************
     */
     --
     --
     /*
     ********************************
     ** PROCEDURE: stg_main
     ********************************
     */
     --


      PROCEDURE stg_main
                     (pt_i_ClientCode                 IN      xxmx_client_config_parameters.client_code%TYPE
                     ,pt_i_MigrationSetName           IN      xxmx_migration_headers.migration_set_name%TYPE ) ;
     --
     /*
     ********************************
     ** PROCEDURE: src_pa_projects
     ********************************
     */
     --
      PROCEDURE src_pa_projects
                   (pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                  ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE);
     --
     /*
     ********************************
     ** PROCEDURE: src_pa_tasks
     ********************************
     */
     --
      PROCEDURE src_pa_tasks 
                    (pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                     ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE);

    --
     /*
     ********************************
     ** PROCEDURE: src_pa_trx_control
     ********************************
     */
     --

      PROCEDURE src_pa_trx_control
                            (pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                            ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE);

     --
     /*
     ********************************
     ** PROCEDURE: src_pa_classifications
     ********************************
     */
     --

      PROCEDURE src_pa_classifications
                            (pt_i_MigrationSetID              IN      xxmx_migration_headers.migration_set_id%TYPE
                            ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE);
     --
     /*
     ********************************
     ** PROCEDURE: src_pa_team_members
     ********************************
     */
     --
      PROCEDURE src_pa_team_members
                            (pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                            ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE);

END XXMX_PPM_PROJECTS_PKG;
/


create or replace PACKAGE BODY XXMX_PPM_PROJECTS_PKG AS 
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
--** FILENAME  :  xxmx_ppm_projects_pkg.pkb
--**
--** FILEPATH  :  $XXV1_TOP/install/sql
--**
--** VERSION   :  1.0
--**
--** EXECUTE
--** IN SCHEMA :  XXMX_CORE
--**
--** AUTHORS   :  Shaik Latheef
--**
--** PURPOSE   :  This package contains procedures for extracting Projects into Staging tables
--***************************************************************************************************
--**   Vsn  Change Date  Changed By          Change Description
--** -----  -----------  ------------------  -----------------------------------
--**   1.0  23-OCT-2021  Pallavi Kanajar      Created for Maximise.
--***************************************************************************************************

    gvv_ReturnStatus                          VARCHAR2(1); 
    gvt_ReturnMessage                         xxmx_module_messages.module_message%TYPE;
    gvv_ProgressIndicator                     VARCHAR2(100); 
    gcv_PackageName                           CONSTANT  VARCHAR2(30)                                := 'XXMX_PPM_PROJECTS_PKG';
    gct_ApplicationSuite                      CONSTANT  xxmx_module_messages.application_suite%TYPE := 'PPM';
    gct_Application                           CONSTANT  xxmx_module_messages.application%TYPE       := 'PRJ';
    gv_i_BusinessEntity                       CONSTANT  VARCHAR2(100)                               := 'PRJ_FOUNDATION';
    gvt_migrationsetname                                VARCHAR2(100);
    ct_Phase                                  CONSTANT  xxmx_module_messages.phase%TYPE             := 'EXTRACT';
    cv_i_BusinessEntityLevel                  CONSTANT  VARCHAR2(100)                               := 'ALL';
    g_batch_name                              CONSTANT  VARCHAR2(300)                               := 'Projects_'||to_char(TO_DATE(SYSDATE, 'DD-MON-RRRR'),'DDMMRRRRHHMISS') ;
    gv_hr_date					                        DATE                                        := '31-DEC-4712';
    gct_stgschema                                       VARCHAR2(10)                                := 'xxmx_stg';

    gvt_Severity                              xxmx_module_messages.severity%TYPE;
    gvt_ModuleMessage                         xxmx_module_messages.module_message%TYPE;
    gvt_OracleError                           xxmx_module_messages.oracle_error%TYPE;

    e_moduleerror                             EXCEPTION;
    e_dateerror                               EXCEPTION;
    gvv_migration_date                        VARCHAR2(30); 
    gvd_migration_date                        DATE;
    gvn_RowCount                              NUMBER;


	/****************************************************************	
	----------------Stg_main Procedure-------------------------------
	*****************************************************************/
   PROCEDURE stg_main (pt_i_ClientCode                 IN      xxmx_client_config_parameters.client_code%TYPE
                      ,pt_i_MigrationSetName           IN      xxmx_migration_headers.migration_set_name%TYPE ) 
   IS 

        CURSOR metadata_cur
        IS
         SELECT  Entity_package_name
                ,Stg_procedure_name
                ,business_entity
                ,sub_entity_seq
                ,sub_entity
         FROM     xxmx_migration_metadata a 
         WHERE application_suite = gct_ApplicationSuite
         AND   Application = gct_Application
         AND   business_entity = gv_i_BusinessEntity
         AND   a.enabled_flag = 'Y'
         ORDER
         BY  Business_entity_seq, 
             sub_entity_seq;

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'stg_main'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'PROJECTS';
        vt_MigrationSetID                               xxmx_migration_headers.migration_set_id%TYPE;
        lv_sql                                          VARCHAR2(32000);
   BEGIN 

   -- setup
        --
        gvv_ReturnStatus  := '';
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
                    ,pt_i_ModuleMessage       => 'Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'    
                    ,pt_i_OracleError         => gvt_ReturnMessage
            );
            --
            RAISE e_ModuleError;
            --
        END IF;
        --
        --
        gvv_ProgressIndicator := '0010';
        /* Migration Set ID Generation*/
        xxmx_utilities_pkg.init_migration_set
         (
         pt_i_ApplicationSuite  => gct_ApplicationSuite
         ,pt_i_Application       => gct_Application
         ,pt_i_BusinessEntity    => gv_i_BusinessEntity
         ,pt_i_MigrationSetName  => pt_i_MigrationSetName
         ,pt_o_MigrationSetID    => vt_MigrationSetID
         );

         --
        gvv_ProgressIndicator :='0015';
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
                        ,pt_i_ModuleMessage       => 'Migration Set "'
                                                   ||pt_i_MigrationSetName
                                                   ||'" initialized (Generated Migration Set ID = '
                                                   ||vt_MigrationSetID
                                                   ||').  Processing extracts:'       ,
                         pt_i_OracleError         => NULL
         );
        --
        --
        --main


        gvv_ProgressIndicator := '0020';
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
            ,pt_i_ModuleMessage       => 'Extract for Projects Started',
             pt_i_OracleError         => NULL
        );

        FOR METADATA_REC IN METADATA_CUR -- 2
        LOOP

--                dbms_output.put_line(' #' ||r_package_name.v_package ||' #'|| l_bg_name || '  #' || l_bg_id || '  #' || vt_MigrationSetID || '  #' || pt_i_MigrationSetName  );

                    lv_sql:= 'BEGIN '
                            ||METADATA_REC.Entity_package_name
                            ||'.'||METADATA_REC.Stg_procedure_name
                            ||'('
                            ||vt_MigrationSetID
                            ||','''
                            ||METADATA_REC.sub_entity
                            ||''''||'); END;'
                            ;

                    EXECUTE IMMEDIATE lv_sql ;

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
                        ,pt_i_ModuleMessage       => 'Extract call for Projects -'|| lv_sql       ,
                         pt_i_OracleError         => NULL
                     );
                    DBMS_OUTPUT.PUT_LINE(lv_sql);

        END LOOP; 

          gvv_ProgressIndicator := '0035';
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
         ,pt_i_ModuleMessage       => 'Extracts for Prjects Completed'
         ,pt_i_OracleError         => NULL
         );

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

   END stg_main;
   /*********************************************************
   --------------------src_pa_projects-----------------------
   -- Extracts Projects information from EBS
   ----------------------------------------------------------
   **********************************************************/

   PROCEDURE src_pa_projects
                     (pt_i_MigrationSetID              IN      xxmx_migration_headers.migration_set_id%TYPE
                     ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE)
     AS   

          --
          --**********************
          --** Cursor Declarations
          --**********************
          --
          CURSOR src_pa_projects_cur
         IS
         --
            SELECT  ppa.name                                                                        project_name
              ,ppa.segment1                                                                    project_number
              ,(SELECT segment1 
                FROM apps.pa_projects_all@MXDM_NVIS_EXTRACT ppa2 
                WHERE ppa2.project_id=ppa.created_from_project_id)                             source_template_number 
              ,NULL                                                                            source_application_code
            ,ppa.pm_project_reference                                                        source_project_reference
              ,(SELECT pppv.work_type_name
                 FROM   apps.pa_projects_prm_v@MXDM_NVIS_EXTRACT pppv
                 WHERE  pppv.project_id   = ppa.project_id
                 AND    pppv.calendar_id = ppa.calendar_id)                                    schedule_name
              ,''                                                                              eps_name
            ,NULL                                                                            project_plan_view_access
              ,''                                                                              schedule_type
              ,org.name                                                                        organization_name
              ,(select xep.name 
                  from apps.hr_operating_units@MXDM_NVIS_EXTRACT hou
                      ,apps.XLE_ENTITY_PROFILES@MXDM_NVIS_EXTRACT xep 
                 where xep.LEGAL_ENTITY_ID = hou.DEFAULT_LEGAL_CONTEXT_ID
                   and hou.organization_id= org.organization_id)                               legal_entity_name
              ,ppa.description                                                                 description
            ,(SELECT nvl(papf.employee_number,papf.npw_number)
                FROM   apps.pa_project_parties@MXDM_NVIS_EXTRACT ppp,
                       apps.per_all_people_f@MXDM_NVIS_EXTRACT papf,
                       apps.pa_project_role_types@MXDM_NVIS_EXTRACT pprt
                WHERE ppp.project_id = ppa.project_id
                AND   (TRUNC(sysdate) BETWEEN ppp.start_date_active AND
                       NVL(ppp.end_date_active,TRUNC(sysdate)))
                AND   ppp.resource_source_id= papf.person_id
                AND   TRUNC(sysdate) BETWEEN papf.effective_start_Date AND
                      NVL(papf.effective_end_Date, sysdate)
                AND   pprt.project_role_id=ppp.project_role_id
                AND   pprt.PROJECT_ROLE_TYPE='PROJECT MANAGER')                                project_manager_number 
             ,(SELECT papf.last_name||', '||papf.first_name
                FROM   apps.pa_project_parties@MXDM_NVIS_EXTRACT ppp,
                       apps.per_all_people_f@MXDM_NVIS_EXTRACT papf,
                       apps.pa_project_role_types@MXDM_NVIS_EXTRACT pprt
                WHERE ppp.project_id = ppa.project_id
                AND   (TRUNC(sysdate) BETWEEN ppp.start_date_active AND
                       NVL(ppp.end_date_active,TRUNC(sysdate)))
                AND   ppp.resource_source_id= papf.person_id
                AND   TRUNC(sysdate) BETWEEN papf.effective_start_Date AND
                      NVL(papf.effective_end_Date, sysdate)
                AND   pprt.project_role_id=ppp.project_role_id
                AND   pprt.PROJECT_ROLE_TYPE='PROJECT MANAGER')                                project_manager_name
                ,NULL                                                                         project_manager_email
              ,ppa.start_date                                                                 project_start_date
              ,ppa.completion_date                                                            project_finish_date
              ,ppa.closed_date                                                                closed_date
              ,''                                                                             prj_plan_baseline_name
              ,''                                                                             prj_plan_baseline_desc
              ,''                                                                             prj_plan_baseline_date
              ,(SELECT pps1.PROJECT_STATUS_NAME 
                  FROM apps.PA_PROJ_STATUSES_V@MXDM_NVIS_EXTRACT pps1
                 WHERE pps1.project_status_code = ppa.project_status_code)                    project_status_name
              ,NULL                                                                           project_priority_code
              ,''                                                                             outline_display_level
              ,''                                                                             planning_project_flag
              ,''                                                                             service_type_code
              ,(SELECT pppv.work_type_name
                FROM   apps.pa_projects_prm_v@MXDM_NVIS_EXTRACT pppv
                WHERE  pppv.project_id   = ppa.project_id
                AND    pppv.work_type_id = ppa.work_type_id)                                  work_type_name
              ,ppa.limit_to_txn_controls_flag                                                 limit_to_txn_controls_code
              ,''                                                                             budgetary_control_flag
              ,ppa.project_currency_code                                                      project_currency_code
              ,ppa.project_rate_type                                                          currency_conv_rate_type
              ,ppa.project_bil_rate_date_code                                                 currency_conv_date_type_code
              ,ppa.project_bil_rate_date                                                      currency_conv_date
              ,ppa.cint_eligible_flag                                                         cint_eligible_flag
              ,''                                                                             cint_rate_sch_name
              ,ppa.cint_stop_date                                                             cint_stop_date
              ,''                                                                             asset_allocation_method_code
              ,''                                                                             capital_event_processing_code
              ,ppa.allow_cross_charge_flag                                                    allow_cross_charge_flag
              ,ppa.cc_process_labor_flag                                                      cc_process_labor_flag
              ,''                                                                             labor_tp_schedule_name
              ,ppa.labor_tp_fixed_date                                                        labor_tp_fixed_date
              ,ppa.cc_process_nl_flag                                                         cc_process_nl_flag
              ,''                                                                             nl_tp_schedule_name
              ,ppa.nl_tp_fixed_date                                                           nl_tp_fixed_date
              ,''                                                                             burden_schedule_name
              ,''                                                                             burden_sch_fixed_dated
              ,''                                                                             kpi_notification_enabled
              ,''                                                                             kpi_notification_recipientS
              ,''                                                                             kpi_notification_include_nOTES
              ,''                                                                             copy_team_members_flag
              ,''                                                                             copy_project_classes_flag
              ,''                                                                             copy_attachments_flag
              ,''                                                                             copy_dff_flag
              ,''                                                                             copy_tasks_flag
              ,''                                                                             copy_task_attachments_flag
              ,''                                                                             copy_task_dff_flag
              ,''                                                                             copy_task_assignments_flag
              ,''                                                                             copy_transaction_controls_FLAG
              ,''                                                                             copy_assets_flag
              ,''                                                                             copy_asset_assignments_flaG
              ,''                                                                             copy_cost_overrides_flag
              ,''                                                                             opportunity_id
              ,''                                                                             opportunity_number
              ,''                                                                             opportunity_customer_number
              ,''                                                                             opportunity_customer_id
              ,''                                                                             opportunity_amt
              ,''                                                                             opportunity_currcode
              ,''                                                                             opportunity_win_conf_perceNT
              ,''                                                                             opportunity_name
              ,''                                                                             opportunity_desc
              ,''                                                                             opportunity_customer_name
              ,''                                                                             opportunity_status
              ,ppa.attribute_category                                                         attribute_category
              ,ppa.attribute1                                                                 attribute1
              ,ppa.attribute2                                                                 attribute2
              ,ppa.attribute3                                                                 attribute3
              ,ppa.attribute4                                                                 attribute4
              ,ppa.attribute5                                                                 attribute5
              ,ppa.attribute6                                                                 attribute6
              ,ppa.attribute7                                                                 attribute7
              ,ppa.attribute8                                                                 attribute8
              ,ppa.attribute9                                                                 attribute9
              ,ppa.attribute10                                                                attribute10
              ,''                                                                             attribute11
              ,''                                                                             attribute12
              ,''                                                                             attribute13
              ,''                                                                             attribute14
              ,''                                                                             attribute15
              ,''                                                                             attribute16
              ,''                                                                             attribute17
              ,''                                                                             attribute18
              ,''                                                                             attribute19
              ,''                                                                             attribute20
              ,''                                                                             attribute21
              ,''                                                                             attribute22
              ,''                                                                             attribute23
              ,''                                                                             attribute24
              ,''                                                                             attribute25
              ,''                                                                             attribute26
              ,''                                                                             attribute27
              ,''                                                                             attribute28
              ,''                                                                             attribute29
              ,''                                                                             attribute30
              ,''                                                                             attribute31
              ,''                                                                             attribute32
              ,''                                                                             attribute33
              ,''                                                                             attribute34
              ,''                                                                             attribute35
              ,''                                                                             attribute36
              ,''                                                                             attribute37
              ,''                                                                             attribute38
              ,''                                                                             attribute39
              ,''                                                                             attribute40
              ,''                                                                             attribute41
              ,''                                                                             attribute42
              ,''                                                                             attribute43
              ,''                                                                             attribute44
              ,''                                                                             attribute45
              ,''                                                                             attribute46
              ,''                                                                             attribute47
              ,''                                                                             attribute48
              ,''                                                                             attribute49
              ,''                                                                             attribute50
              ,''                                                                             attribute1_number
              ,''                                                                             attribute2_number
              ,''                                                                             attribute3_number
              ,''                                                                             attribute4_number
              ,''                                                                             attribute5_number
              ,''                                                                             attribute6_number
              ,''                                                                             attribute7_number
              ,''                                                                             attribute8_number
              ,''                                                                             attribute9_number
              ,''                                                                             attribute10_number
              ,''                                                                             attribute11_number
              ,''                                                                             attribute12_number
              ,''                                                                             attribute13_number
              ,''                                                                             attribute14_number
              ,''                                                                             attribute15_number
              ,''                                                                             attribute1_date
              ,''                                                                             attribute2_date
              ,''                                                                             attribute3_date
              ,''                                                                             attribute4_date
              ,''                                                                             attribute5_date
              ,''                                                                             attribute6_date
              ,''                                                                             attribute7_date
              ,''                                                                             attribute8_date
              ,''                                                                             attribute9_date
              ,''                                                                             attribute10_date
              ,''                                                                             attribute11_date
              ,''                                                                             attribute12_date
              ,''                                                                             attribute13_date
              ,''                                                                             attribute14_date
              ,''                                                                             attribute15_date
              ,''                                                                             copy_group_space_flag
              ,(SELECT hou.name
                FROM   apps.hr_all_organization_units@MXDM_NVIS_EXTRACT hou
                WHERE  hou.organization_id = ppa.carrying_out_organization_id)                proj_owning_org
            ,ppa.project_id                                                                   project_id
       FROM
               apps.pa_projects_all@MXDM_NVIS_EXTRACT ppa
              ,apps.hr_all_organization_units@MXDM_NVIS_EXTRACT  org
       WHERE   ppa.org_id                                   = org.organization_id
       AND     ppa.template_flag                            = 'N'
       AND     ppa.closed_date                              IS NULL  
       AND     ppa.project_status_code                      IN (SELECT PARAMETER_VALUE 
                                                                FROM XXMX_MIGRATION_PARAMETERS
                                                                WHERE PARAMETER_CODE = 'PROJECT_STATUS_CODE'
                                                                AND APPLICATION_SUITE= 'FIN'
                                                                AND APPLICATION = 'PPM'
                                                               )
       AND     org.NAME                                     IN (SELECT PARAMETER_VALUE 
                                                                FROM XXMX_MIGRATION_PARAMETERS
                                                                WHERE PARAMETER_CODE = 'ORGANIZATION_NAME'
                                                                AND APPLICATION_SUITE= 'FIN'
                                                                AND APPLICATION = 'ALL'
                                                               )
       AND     ppa.PROJECT_TYPE                             IN (SELECT PARAMETER_VALUE 
                                                                FROM XXMX_MIGRATION_PARAMETERS
                                                                WHERE PARAMETER_CODE = 'PROJECT_TYPE'
                                                                AND APPLICATION_SUITE= 'FIN'
                                                                AND APPLICATION = 'PPM'
                                                               );
       --
       --**********************
       --** Record Declarations
       --**********************
       --
         TYPE src_pa_projects_tbl IS TABLE OF src_pa_projects_cur%ROWTYPE INDEX BY BINARY_INTEGER;
         src_pa_projects_tb  src_pa_projects_tbl;
       --
       --************************
       --** Constant Declarations
       --************************
       --
        cv_ProcOrFuncName                   CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'src_pa_projects';
        cv_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_PPM_PROJECTS_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'PROJECTS';


       --
       --************************
       --** Variable Declarations
       --************************
       --
       --
       --*************************
       --** Exception Declarations
       --*************************
       --
       e_ModuleError                         EXCEPTION;
       e_DateError                           EXCEPTION;
       ex_dml_errors                         EXCEPTION;
       PRAGMA EXCEPTION_INIT(ex_dml_errors, -24381);
       l_error_count             NUMBER;
       --
       --** END Declarations **
       --
       -- Local Type Variables


   BEGIN
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
        FROM    xxmx_ppm_projects_stg ;

        COMMIT;
        --

        gvv_ProgressIndicator := '0020';
        --
        gvt_MigrationSetName := xxmx_utilities_pkg.get_migration_set_name(pt_i_MigrationSetID);
        --
        /*
        ** If the Migration Set Name is NULL then the Migration has not been initialized.
        */
        --
        IF   gvt_MigrationSetName IS NOT NULL
        THEN
            --
            gvv_ProgressIndicator := '0030';
            --
            xxmx_utilities_pkg.log_module_message
                 (
                  pt_i_ApplicationSuite  => gct_ApplicationSuite
                 ,pt_i_Application       => gct_Application
                 ,pt_i_BusinessEntity    => gv_i_BusinessEntity
                 ,pt_i_SubEntity         => cv_i_BusinessEntityLevel
                 ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                 ,pt_i_Phase             => ct_Phase
                 ,pt_i_Severity          => 'NOTIFICATION'
                 ,pt_i_PackageName       => gcv_PackageName
                 ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                 ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                 ,pt_i_ModuleMessage     => '- Extracting "'
                                          ||pt_i_SubEntity
                                          ||'":'
                 ,pt_i_OracleError       => NULL
                 );
            --
            /*
            ** The Migration Set has been initialised, so now initialize the detail record
            ** for the current entity.
            */
            --
            --** ISV 21/10/2020 - Removed Sequence Number parameters as the procedure will now determine the correct values from the metadata
            --**                  table based on the Application Suite, Application and Business Entity parameters.
            --**
            --**                  Removed "entity" from procedure_name.
            --
            xxmx_utilities_pkg.init_migration_details
                 (
                  pt_i_ApplicationSuite => gct_ApplicationSuite
                 ,pt_i_Application      => gct_Application
                 ,pt_i_BusinessEntity   => gv_i_BusinessEntity
                 ,pt_i_SubEntity        => cv_i_BusinessEntityLevel
                 ,pt_i_MigrationSetID   => pt_i_MigrationSetID
                 ,pt_i_StagingTable     => cv_StagingTable
                 ,pt_i_ExtractStartDate => SYSDATE
                 );
            --
            --** ISV 21/10/2020 - "pt_i_StagingTable" no longer needs to be passed as a parameter from the STG_MAIN procedure
            --**                  as the table name will never change so replace with new constant "ct_StgTable".
            --
            --**                  We will still keep the table name in the Metadata table as that can be used for reporting
            --**                  purposes.
            --
            xxmx_utilities_pkg.log_module_message
                 (
                  pt_i_ApplicationSuite  => gct_ApplicationSuite
                 ,pt_i_Application       => gct_Application
                 ,pt_i_BusinessEntity    => gv_i_BusinessEntity
                 ,pt_i_SubEntity         => cv_i_BusinessEntityLevel
                 ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                 ,pt_i_Phase             => ct_Phase
                 ,pt_i_Severity          => 'NOTIFICATION'
                 ,pt_i_PackageName       => gcv_PackageName
                 ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                 ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                 ,pt_i_ModuleMessage     => '  - Staging Table "'
                                          ||cv_StagingTable
                                          ||'" reporting details initialised.'
                 ,pt_i_OracleError       => NULL
                 );
            --
            gvv_ProgressIndicator := '0040';
            --
            --** Extract the Projects and insert into the staging table.
            --
            xxmx_utilities_pkg.log_module_message
                 (
                  pt_i_ApplicationSuite  => gct_ApplicationSuite
                 ,pt_i_Application       => gct_Application
                 ,pt_i_BusinessEntity    => gv_i_BusinessEntity
                 ,pt_i_SubEntity         => cv_i_BusinessEntityLevel
                 ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                 ,pt_i_Phase             => ct_Phase
                 ,pt_i_Severity          => 'NOTIFICATION'
                 ,pt_i_PackageName       => gcv_PackageName
                 ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                 ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                 ,pt_i_ModuleMessage     => '  - Extracting data into "'
                                          ||cv_StagingTable
                                          ||'".'
                 ,pt_i_OracleError       => NULL
                 );
            --
            --** ISV 21/10/2020 - The staging table is in the xxmx_stg schema but should not need to be prefixed as there should
            --**                  by a Synonym in the xxmx_core schema to that table.
            --


            OPEN src_pa_projects_cur;
                --

            gvv_ProgressIndicator := '0050';
            xxmx_utilities_pkg.log_module_message(  
                    pt_i_ApplicationSuite    => gct_ApplicationSuite
                   ,pt_i_Application         => gct_Application
                   ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                   ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                   ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                   ,pt_i_Phase               => ct_Phase
                   ,pt_i_Severity            => 'NOTIFICATION'
                   ,pt_i_PackageName         => gcv_PackageName
                   ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                   ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                   ,pt_i_ModuleMessage       =>'Cursor Open src_pa_projects_cur'
                   ,pt_i_OracleError         => gvt_ReturnMessage  );
            --
            LOOP
            --
            gvv_ProgressIndicator := '0060';
            xxmx_utilities_pkg.log_module_message(  
                    pt_i_ApplicationSuite    => gct_ApplicationSuite
                   ,pt_i_Application         => gct_Application
                   ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                   ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                   ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                   ,pt_i_Phase               => ct_Phase
                   ,pt_i_Severity            => 'NOTIFICATION'
                   ,pt_i_PackageName         => gcv_PackageName
                   ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                   ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                   ,pt_i_ModuleMessage       =>'Inside the Cursor loop'
                   ,pt_i_OracleError         => gvt_ReturnMessage  );

            --
            FETCH src_pa_projects_cur  BULK COLLECT INTO src_pa_projects_tb LIMIT 1000;
            --

            gvv_ProgressIndicator := '0070';
            xxmx_utilities_pkg.log_module_message(  
                    pt_i_ApplicationSuite    => gct_ApplicationSuite
                   ,pt_i_Application         => gct_Application
                   ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                   ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                   ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                   ,pt_i_Phase               => ct_Phase
                   ,pt_i_Severity            => 'NOTIFICATION'
                   ,pt_i_PackageName         => gcv_PackageName
                   ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                   ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                   ,pt_i_ModuleMessage       => 'Cursor src_pa_projects_cur Fetch into src_pa_projects_tb'
                   ,pt_i_OracleError         => gvt_ReturnMessage  );
            --
            EXIT WHEN src_pa_projects_tb.COUNT=0;
            --
            FORALL I IN 1..src_pa_projects_tb.COUNT SAVE EXCEPTIONS
            --
                 INSERT INTO xxmx_ppm_projects_stg (
                                    migration_set_id
                                    ,migration_status
                                    ,migration_set_name
                                    ,project_name
                                    ,project_number
                                    ,source_template_number
                                    ,source_application_code
                                    ,source_project_reference
                                    ,schedule_name
                                    ,eps_name
                                    ,project_plan_view_access
                                    ,schedule_type
                                    ,organization_name
                                    ,legal_entity_name
                                    ,description
                                    ,project_manager_number
                                    ,project_manager_name
                                    ,project_manager_email
                                    ,project_start_date
                                    ,project_finish_date
                                    ,closed_date
                                    ,prj_plan_baseline_name
                                    ,prj_plan_baseline_desc
                                    ,prj_plan_baseline_date
                                    ,project_status_name
                                    ,project_priority_code
                                    ,outline_display_level
                                    ,planning_project_flag
                                    ,service_type_code
                                    ,work_type_name
                                    ,limit_to_txn_controls_code
                                    ,budgetary_control_flag
                                    ,project_currency_code
                                    ,currency_conv_rate_type
                                    ,currency_conv_date_type_code
                                    ,currency_conv_date
                                    ,cint_eligible_flag
                                    ,cint_rate_sch_name
                                    ,cint_stop_date
                                    ,asset_allocation_method_code
                                    ,capital_event_processing_code
                                    ,allow_cross_charge_flag
                                    ,cc_process_labor_flag
                                    ,labor_tp_schedule_name
                                    ,labor_tp_fixed_date
                                    ,cc_process_nl_flag
                                    ,nl_tp_schedule_name
                                    ,nl_tp_fixed_date
                                    ,burden_schedule_name
                                    ,burden_sch_fixed_dated
                                    ,kpi_notification_enabled
                                    ,kpi_notification_recipients
                                    ,kpi_notification_include_notes
                                    ,copy_team_members_flag
                                    ,copy_classifications_flag
                                    ,copy_attachments_flag
                                    ,copy_dff_flag
                                    ,copy_tasks_flag
                                    ,copy_task_attachments_flag
                                    ,copy_task_dff_flag
                                    ,copy_task_assignments_flag
                                    ,copy_transaction_controls_flag
                                    ,copy_assets_flag
                                    ,copy_asset_assignments_flag
                                    ,copy_cost_overrides_flag
                                    ,opportunity_id
                                    ,opportunity_number
                                    ,opportunity_customer_number
                                    ,opportunity_customer_id
                                    ,opportunity_amt
                                    ,opportunity_currcode
                                    ,opportunity_win_conf_percent
                                    ,opportunity_name
                                    ,opportunity_desc
                                    ,opportunity_customer_name
                                    ,opportunity_status
                                    ,attribute_category
                                    ,attribute1
                                    ,attribute2
                                    ,attribute3
                                    ,attribute4
                                    ,attribute5
                                    ,attribute6
                                    ,attribute7
                                    ,attribute8
                                    ,attribute9
                                    ,attribute10
                                    ,attribute11
                                    ,attribute12
                                    ,attribute13
                                    ,attribute14
                                    ,attribute15
                                    ,attribute16
                                    ,attribute17
                                    ,attribute18
                                    ,attribute19
                                    ,attribute20
                                    ,attribute21
                                    ,attribute22
                                    ,attribute23
                                    ,attribute24
                                    ,attribute25
                                    ,attribute26
                                    ,attribute27
                                    ,attribute28
                                    ,attribute29
                                    ,attribute30
                                    ,attribute31
                                    ,attribute32
                                    ,attribute33
                                    ,attribute34
                                    ,attribute35
                                    ,attribute36
                                    ,attribute37
                                    ,attribute38
                                    ,attribute39
                                    ,attribute40
                                    ,attribute41
                                    ,attribute42
                                    ,attribute43
                                    ,attribute44
                                    ,attribute45
                                    ,attribute46
                                    ,attribute47
                                    ,attribute48
                                    ,attribute49
                                    ,attribute50
                                    ,attribute1_number
                                    ,attribute2_number
                                    ,attribute3_number
                                    ,attribute4_number
                                    ,attribute5_number
                                    ,attribute6_number
                                    ,attribute7_number
                                    ,attribute8_number
                                    ,attribute9_number
                                    ,attribute10_number
                                    ,attribute11_number
                                    ,attribute12_number
                                    ,attribute13_number
                                    ,attribute14_number
                                    ,attribute15_number
                                    ,attribute1_date
                                    ,attribute2_date
                                    ,attribute3_date
                                    ,attribute4_date
                                    ,attribute5_date
                                    ,attribute6_date
                                    ,attribute7_date
                                    ,attribute8_date
                                    ,attribute9_date
                                    ,attribute10_date
                                    ,attribute11_date
                                    ,attribute12_date
                                    ,attribute13_date
                                    ,attribute14_date
                                    ,attribute15_date
                                    ,copy_group_space_flag
                                    ,batch_name
                                    ,created_by
                                    ,creation_date
                                    ,last_updated_by
                                    ,last_update_date
                                    ,batch_id
                                    ,proj_owning_org
                                    ,project_id
                                    --,max_ei_creation_date
                                    --,max_event_creation_date
                             )
                           VALUES
                           (
                            pt_i_MigrationSetID
                           ,'EXTRACTED'
                           ,gvt_MigrationSetName
                           ,src_pa_projects_tb(i).project_name                          --project_name
                           ,src_pa_projects_tb(i).project_number                        --project_number
                           ,src_pa_projects_tb(i).source_template_number                --source_template_number
                           ,src_pa_projects_tb(i).source_application_code               --source_application_code
                           ,src_pa_projects_tb(i).source_project_reference              --source_project_reference
                           ,src_pa_projects_tb(i).schedule_name                         --schedule_name
                           ,src_pa_projects_tb(i).eps_name                              --eps_name
                           ,src_pa_projects_tb(i).project_plan_view_access              --project_plan_view_access
                           ,src_pa_projects_tb(i).schedule_type                         --schedule_type
                           ,src_pa_projects_tb(i).organization_name                     --organization_name
                           ,src_pa_projects_tb(i).legal_entity_name                     --legal_entity_name
                           ,src_pa_projects_tb(i).description                           --description
                           ,src_pa_projects_tb(i).project_manager_number                --project_manager_number
                           ,src_pa_projects_tb(i).project_manager_name                  --project_manager_name
                           ,src_pa_projects_tb(i).project_manager_email                 --project_manager_email
                           ,src_pa_projects_tb(i).project_start_date                    --project_start_date
                           ,src_pa_projects_tb(i).project_finish_date                   --project_finish_date
                           ,src_pa_projects_tb(i).closed_date                           --closed_date
                           ,src_pa_projects_tb(i).prj_plan_baseline_name                --prj_plan_baseline_name
                           ,src_pa_projects_tb(i).prj_plan_baseline_desc                --prj_plan_baseline_desc
                           ,src_pa_projects_tb(i).prj_plan_baseline_date                --prj_plan_baseline_date
                           ,src_pa_projects_tb(i).project_status_name                   --project_status_name
                           ,src_pa_projects_tb(i).project_priority_code                 --project_priority_code
                           ,src_pa_projects_tb(i).outline_display_level                 --outline_display_level
                           ,src_pa_projects_tb(i).planning_project_flag                 --planning_project_flag
                           ,src_pa_projects_tb(i).service_type_code                     --service_type_code
                           ,src_pa_projects_tb(i).work_type_name                        --work_type_name
                           ,src_pa_projects_tb(i).limit_to_txn_controls_code            --limit_to_txn_controls_code
                           ,src_pa_projects_tb(i).budgetary_control_flag                --budgetary_control_flag
                           ,src_pa_projects_tb(i).project_currency_code                 --project_currency_code
                           ,src_pa_projects_tb(i).currency_conv_rate_type               --currency_conv_rate_type
                           ,src_pa_projects_tb(i).currency_conv_date_type_code          --currency_conv_date_type_code
                           ,src_pa_projects_tb(i).currency_conv_date                    --currency_conv_date
                           ,src_pa_projects_tb(i).cint_eligible_flag                    --cint_eligible_flag
                           ,src_pa_projects_tb(i).cint_rate_sch_name                    --cint_rate_sch_name
                           ,src_pa_projects_tb(i).cint_stop_date                        --cint_stop_date
                           ,src_pa_projects_tb(i).asset_allocation_method_code          --asset_allocation_method_code
                           ,src_pa_projects_tb(i).capital_event_processing_code         --capital_event_processing_code
                           ,src_pa_projects_tb(i).allow_cross_charge_flag               --allow_cross_charge_flag
                           ,src_pa_projects_tb(i).cc_process_labor_flag                 --cc_process_labor_flag
                           ,src_pa_projects_tb(i).labor_tp_schedule_name                --labor_tp_schedule_name
                           ,src_pa_projects_tb(i).labor_tp_fixed_date                   --labor_tp_fixed_date
                           ,src_pa_projects_tb(i).cc_process_nl_flag                    --cc_process_nl_flag
                           ,src_pa_projects_tb(i).nl_tp_schedule_name                   --nl_tp_schedule_name
                           ,src_pa_projects_tb(i).nl_tp_fixed_date                      --nl_tp_fixed_date
                           ,src_pa_projects_tb(i).burden_schedule_name                  --burden_schedule_name
                           ,src_pa_projects_tb(i).burden_sch_fixed_dated                --burden_sch_fixed_dated
                           ,src_pa_projects_tb(i).kpi_notification_enabled              --kpi_notification_enabled
                           ,src_pa_projects_tb(i).kpi_notification_recipients           --kpi_notification_recipients
                           ,src_pa_projects_tb(i).kpi_notification_include_notes        --kpi_notification_include_notes
                           ,src_pa_projects_tb(i).copy_team_members_flag                --copy_team_members_flag
                           ,src_pa_projects_tb(i).copy_project_classes_flag             --copy_project_classes_flag
                           ,src_pa_projects_tb(i).copy_attachments_flag                 --copy_attachments_flag
                           ,src_pa_projects_tb(i).copy_dff_flag                         --copy_dff_flag
                           ,src_pa_projects_tb(i).copy_tasks_flag                       --copy_tasks_flag
                           ,src_pa_projects_tb(i).copy_task_attachments_flag            --copy_task_attachments_flag
                           ,src_pa_projects_tb(i).copy_task_dff_flag                    --copy_task_dff_flag
                           ,src_pa_projects_tb(i).copy_task_assignments_flag            --copy_task_assignments_flag
                           ,src_pa_projects_tb(i).copy_transaction_controls_flag        --copy_transaction_controls_flag
                           ,src_pa_projects_tb(i).copy_assets_flag                      --copy_assets_flag
                           ,src_pa_projects_tb(i).copy_asset_assignments_flag           --copy_asset_assignments_flag
                           ,src_pa_projects_tb(i).copy_cost_overrides_flag              --copy_cost_overrides_flag
                           ,src_pa_projects_tb(i).opportunity_id                        --opportunity_id
                           ,src_pa_projects_tb(i).opportunity_number                    --opportunity_number
                           ,src_pa_projects_tb(i).opportunity_customer_number           --opportunity_customer_number
                           ,src_pa_projects_tb(i).opportunity_customer_id               --opportunity_customer_id
                           ,src_pa_projects_tb(i).opportunity_amt                       --opportunity_amt
                           ,src_pa_projects_tb(i).opportunity_currcode                  --opportunity_currcode
                           ,src_pa_projects_tb(i).opportunity_win_conf_percent          --opportunity_win_conf_percent
                           ,src_pa_projects_tb(i).opportunity_name                      --opportunity_name
                           ,src_pa_projects_tb(i).opportunity_desc                      --opportunity_desc
                           ,src_pa_projects_tb(i).opportunity_customer_name             --opportunity_customer_name
                           ,src_pa_projects_tb(i).opportunity_status                    --opportunity_status
                           ,src_pa_projects_tb(i).attribute_category                    --attribute_category
                           ,src_pa_projects_tb(i).attribute1                            --attribute1
                           ,src_pa_projects_tb(i).attribute2                            --attribute2
                           ,src_pa_projects_tb(i).attribute3                            --attribute3
                           ,src_pa_projects_tb(i).attribute4                            --attribute4
                           ,src_pa_projects_tb(i).attribute5                            --attribute5
                           ,src_pa_projects_tb(i).attribute6                            --attribute6
                           ,src_pa_projects_tb(i).attribute7                            --attribute7
                           ,src_pa_projects_tb(i).attribute8                            --attribute8
                           ,src_pa_projects_tb(i).attribute9                            --attribute9
                           ,src_pa_projects_tb(i).attribute10                           --attribute10
                           ,src_pa_projects_tb(i).attribute11                           --attribute11
                           ,src_pa_projects_tb(i).attribute12                           --attribute12
                           ,src_pa_projects_tb(i).attribute13                           --attribute13
                           ,src_pa_projects_tb(i).attribute14                           --attribute14
                           ,src_pa_projects_tb(i).attribute15                           --attribute15
                           ,src_pa_projects_tb(i).attribute16                           --attribute16
                           ,src_pa_projects_tb(i).attribute17                           --attribute17
                           ,src_pa_projects_tb(i).attribute18                           --attribute18
                           ,src_pa_projects_tb(i).attribute19                           --attribute19
                           ,src_pa_projects_tb(i).attribute20                           --attribute20
                           ,src_pa_projects_tb(i).attribute21                           --attribute21
                           ,src_pa_projects_tb(i).attribute22                           --attribute22
                           ,src_pa_projects_tb(i).attribute23                           --attribute23
                           ,src_pa_projects_tb(i).attribute24                           --attribute24
                           ,src_pa_projects_tb(i).attribute25                           --attribute25
                           ,src_pa_projects_tb(i).attribute26                           --attribute26
                           ,src_pa_projects_tb(i).attribute27                           --attribute27
                           ,src_pa_projects_tb(i).attribute28                           --attribute28
                           ,src_pa_projects_tb(i).attribute29                           --attribute29
                           ,src_pa_projects_tb(i).attribute30                           --attribute30
                           ,src_pa_projects_tb(i).attribute31                           --attribute31
                           ,src_pa_projects_tb(i).attribute32                           --attribute32
                           ,src_pa_projects_tb(i).attribute33                           --attribute33
                           ,src_pa_projects_tb(i).attribute34                           --attribute34
                           ,src_pa_projects_tb(i).attribute35                           --attribute35
                           ,src_pa_projects_tb(i).attribute36                           --attribute36
                           ,src_pa_projects_tb(i).attribute37                           --attribute37
                           ,src_pa_projects_tb(i).attribute38                           --attribute38
                           ,src_pa_projects_tb(i).attribute39                           --attribute39
                           ,src_pa_projects_tb(i).attribute40                           --attribute40
                           ,src_pa_projects_tb(i).attribute41                           --attribute41
                           ,src_pa_projects_tb(i).attribute42                           --attribute42
                           ,src_pa_projects_tb(i).attribute43                           --attribute43
                           ,src_pa_projects_tb(i).attribute44                           --attribute44
                           ,src_pa_projects_tb(i).attribute45                           --attribute45
                           ,src_pa_projects_tb(i).attribute46                           --attribute46
                           ,src_pa_projects_tb(i).attribute47                           --attribute47
                           ,src_pa_projects_tb(i).attribute48                           --attribute48
                           ,src_pa_projects_tb(i).attribute49                           --attribute49
                           ,src_pa_projects_tb(i).attribute50                           --attribute50
                           ,src_pa_projects_tb(i).attribute1_number                     --attribute1_number
                           ,src_pa_projects_tb(i).attribute2_number                     --attribute2_number
                           ,src_pa_projects_tb(i).attribute3_number                     --attribute3_number
                           ,src_pa_projects_tb(i).attribute4_number                     --attribute4_number
                           ,src_pa_projects_tb(i).attribute5_number                     --attribute5_number
                           ,src_pa_projects_tb(i).attribute6_number                     --attribute6_number
                           ,src_pa_projects_tb(i).attribute7_number                     --attribute7_number
                           ,src_pa_projects_tb(i).attribute8_number                     --attribute8_number
                           ,src_pa_projects_tb(i).attribute9_number                     --attribute9_number
                           ,src_pa_projects_tb(i).attribute10_number                    --attribute10_number
                           ,src_pa_projects_tb(i).attribute11_number                    --attribute11_number
                           ,src_pa_projects_tb(i).attribute12_number                    --attribute12_number
                           ,src_pa_projects_tb(i).attribute13_number                    --attribute13_number
                           ,src_pa_projects_tb(i).attribute14_number                    --attribute14_number
                           ,src_pa_projects_tb(i).attribute15_number                    --attribute15_number
                           ,src_pa_projects_tb(i).attribute1_date                       --attribute1_date
                           ,src_pa_projects_tb(i).attribute2_date                       --attribute2_date
                           ,src_pa_projects_tb(i).attribute3_date                       --attribute3_date
                           ,src_pa_projects_tb(i).attribute4_date                       --attribute4_date
                           ,src_pa_projects_tb(i).attribute5_date                       --attribute5_date
                           ,src_pa_projects_tb(i).attribute6_date                       --attribute6_date
                           ,src_pa_projects_tb(i).attribute7_date                       --attribute7_date
                           ,src_pa_projects_tb(i).attribute8_date                       --attribute8_date
                           ,src_pa_projects_tb(i).attribute9_date                       --attribute9_date
                           ,src_pa_projects_tb(i).attribute10_date                      --attribute10_date
                           ,src_pa_projects_tb(i).attribute11_date                      --attribute11_date
                           ,src_pa_projects_tb(i).attribute12_date                      --attribute12_date
                           ,src_pa_projects_tb(i).attribute13_date                      --attribute13_date
                           ,src_pa_projects_tb(i).attribute14_date                      --attribute14_date
                           ,src_pa_projects_tb(i).attribute15_date                      --attribute15_date
                           ,src_pa_projects_tb(i).copy_group_space_flag                 --copy_group_space_flag
                           ,g_batch_name                                                -- src_pa_projects_tb(i).batch_name                            --batch_name
                           ,xxmx_utilities_pkg.gvv_UserName                             -- src_pa_projects_tb(i).created_by                            --created_by
                           ,SYSDATE                                                     -- src_pa_projects_tb(i).creation_date                         --creation_date
                           ,xxmx_utilities_pkg.gvv_UserName                             -- src_pa_projects_tb(i).last_updated_by                       --last_updated_by
                           ,SYSDATE                                                     -- src_pa_projects_tb(i).last_update_date                      --last_update_date
                           ,to_char(TO_DATE(SYSDATE, 'DD-MON-RRRR'),'DDMMRRRRHHMISS')     -- src_pa_projects_tb(i).batch_id                              --batch_id
                           ,src_pa_projects_tb(i).proj_owning_org                       --proj_owning_org
                           ,src_pa_projects_tb(i).project_id                            --project_id
                           );
                --
                END LOOP;
                --
                 gvv_ProgressIndicator := '0080';
                  xxmx_utilities_pkg.log_module_message(  
                            pt_i_ApplicationSuite    => gct_ApplicationSuite
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
                COMMIT;
                -- 
                -- Update latest transaction dates per project
                /*UPDATE pfc_ppm_projects_src tt
                SET    (tt.max_ei_creation_date, tt.max_event_creation_date) = 
                                    (SELECT st.max_ei_creation_date, st.max_event_creation_date
                                                                    FROM   pfc_ppm_projects_scope_p3_mv st
                                                                    WHERE  st.project = tt.project_number
                                    );*/
                --
                --
               gvv_ProgressIndicator := '0090';
              xxmx_utilities_pkg.log_module_message(  
                               pt_i_ApplicationSuite    => gct_ApplicationSuite
                              ,pt_i_Application         => gct_Application
                              ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                              ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                              ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                              ,pt_i_Phase               => ct_Phase
                              ,pt_i_Severity            => 'NOTIFICATION'
                              ,pt_i_PackageName         => gcv_PackageName
                              ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                              ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                              ,pt_i_ModuleMessage       => 'Close the Cursor src_pa_projects_cur'
                              ,pt_i_OracleError         => gvt_ReturnMessage       );   
             --


             IF src_pa_projects_cur%ISOPEN
             THEN
                  --
                     CLOSE src_pa_projects_cur;
                  --
             END IF;

           gvv_ProgressIndicator := '0100';
            --
            /*
            ** Obtain the count of rows inserted.  We cannot use SQL$ROWCOUNT here because of the LIMIT
            ** clause on the BULK COLLECT statement.  The rowcount will be reset each time the limit
            ** is reached.
            */
            --
            --** ISV 21/10/2020 - Replace "pt_i_ClientSchemaName" (no longer passed into the extract procedures) with new constant "gct_StgSchema".
            --**                  Replace "pt_i_StagingTable" (no longer passed into the extract procedures) with new constant "ct_StgTable"
            --
            gvn_RowCount := xxmx_utilities_pkg.get_row_count
                                 (
                                  gct_StgSchema
                                 ,cv_StagingTable
                                 ,pt_i_MigrationSetID
                                 );
            --
            COMMIT;


            xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gv_i_BusinessEntity
                    ,pt_i_SubEntity         => cv_i_BusinessEntityLevel
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Extraction complete.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               --
               --** Update the migration details (Migration status will be automatically determined
               --** in the called procedure dependant on the Phase and if an Error Message has been
               --** passed).
               --
               gvv_ProgressIndicator := '0110';
               --
               --** ISV 21/10/2020 - Removed Sequence Number parameters as the procedure will now determine the correct values from the metadata
               --**                  table based on the Application Suite, Application, Business Entity and Sub-Entity parameters.
               --**
               --**                  Removed "entity" from procedure_name.
               --
               xxmx_utilities_pkg.upd_migration_details
                    (
                     pt_i_MigrationSetID          => pt_i_MigrationSetID
                    ,pt_i_BusinessEntity          => gv_i_BusinessEntity
                    ,pt_i_SubEntity               => cv_i_BusinessEntityLevel
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
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gv_i_BusinessEntity
                    ,pt_i_SubEntity         => cv_i_BusinessEntityLevel
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Migration Table "'
                                             ||cv_StagingTable
                                             ||'" reporting details updated.'
                    ,pt_i_OracleError       => NULL
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
               RAISE e_ModuleError;
               --
               --
          END IF;
          --
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => gv_i_BusinessEntity
               ,pt_i_SubEntity         => cv_i_BusinessEntityLevel
               ,pt_i_MigrationSetID    => pt_i_MigrationSetID
               ,pt_i_Phase             => ct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gcv_PackageName
               ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'Procedure "'
                                        ||gcv_PackageName
                                        ||'.'
                                        ||cv_ProcOrFuncName
                                        ||'" completed.'
               ,pt_i_OracleError       => NULL
               );
          --
          --

    EXCEPTION
      WHEN ex_dml_errors THEN
         l_error_count := SQL%BULK_EXCEPTIONS.count;
         DBMS_OUTPUT.put_line('Number of failures: ' || l_error_count);
         FOR i IN 1 .. l_error_count LOOP

           gvt_ModuleMessage := 'Error: ' || i || 
                                ' Array Index: ' || SQL%BULK_EXCEPTIONS(i).error_index ||
                                ' Message: ' || SQLERRM(-SQL%BULK_EXCEPTIONS(i).ERROR_CODE);

           xxmx_utilities_pkg.log_module_message(  
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                    ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_Severity            => 'ERROR'
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => gvt_ModuleMessage  
                    ,pt_i_OracleError         => gvt_ReturnMessage   ); 

           DBMS_OUTPUT.put_line('Error: ' || i || 
             ' Array Index: ' || SQL%BULK_EXCEPTIONS(i).error_index ||
             ' Message: ' || SQLERRM(-SQL%BULK_EXCEPTIONS(i).ERROR_CODE));
         END LOOP;

      WHEN e_ModuleError THEN
                --
        IF src_pa_projects_cur%ISOPEN
        THEN
            --
            CLOSE src_pa_projects_cur;
            --
        END IF;

        xxmx_utilities_pkg.log_module_message(  
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                    ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
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
      WHEN OTHERS THEN

         IF src_pa_projects_cur%ISOPEN
         THEN
             --
             CLOSE src_pa_projects_cur;
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
         -- Hr_Utility.raise_error@MXDM_NVIS_EXTRACT;



     END src_pa_projects;

     /***********************************************
     -----------------src_pa_tasks-------------------
     ***********************************************/

     PROCEDURE src_pa_tasks (pt_i_MigrationSetID              IN      xxmx_migration_headers.migration_set_id%TYPE
                            ,pt_i_SubEntity                   IN      xxmx_migration_metadata.sub_entity%TYPE)
     IS

           cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'src_pa_tasks'; 
           ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
           cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_PPM_PRJ_TASKS_STG';
           cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'TASKS';

           e_DateError                         EXCEPTION;
           --
           -- Local Cursors
           -- Cursor to get all eligible Mass Additions to be migrated

           --  PA Project Tasks data Insertion from R12 to pa_tasks_src Table
           --  Local Cursor
          CURSOR src_pa_tasks_cur
          IS
          SELECT   ppa.project_name                                                   project_name
                  ,ppa.project_number                                                 project_number
                  ,pt.task_name                                                       task_name
                  ,pt.task_number                                                     task_number
                  ,''                                                                 source_task_reference
                  ,''                                                                 financial_task
                  ,pt.description                                                     task_description
                  ,(SELECT t.task_number
                    FROM   apps.pa_tasks@MXDM_NVIS_EXTRACT t
                    WHERE  t.task_id = pt.parent_task_id)                             parent_task_number
                  ,pt.start_date                                                      planning_start_date
                  ,nvl(pt.completion_date,ppa.project_finish_date )                   planning_end_date
                  ,(SELECT max(ptp.planned_effort)
                    FROM   apps.pa_task_progress_v@MXDM_NVIS_EXTRACT ptp
                    WHERE  pt.task_id = ptp.task_id
                    AND    pt.project_id = ptp.project_id)                            planned_effort
                  ,''                                                                 planned_duration
                  ,(SELECT max(ptp.milestone_flag)
                    FROM   apps.pa_task_progress_v@MXDM_NVIS_EXTRACT ptp
                    WHERE  pt.task_id = ptp.task_id
                    AND    pt.project_id = ptp.project_id)                            milestone_flag
                  ,(SELECT max(ptp.critical_flag)
                    FROM   apps.pa_task_progress_v@MXDM_NVIS_EXTRACT ptp
                    WHERE  pt.task_id = ptp.task_id
                    AND    pt.project_id = ptp.project_id)                            critical_flag
                  ,pt.chargeable_flag                                                 chargeable_flag  
                  ,pt.billable_flag                                                   billable_flag
                  ,NULL                                                               capitalizable_flag
                  ,pt.limit_to_txn_controls_flag                                      limit_to_txn_controls_flag
                  ,pt.service_type_code                                               service_type_code
                  ,pt.work_type_id                                                    work_type_id
                  ,(SELECT papf.employee_number
                   FROM   apps.per_all_people_f@MXDM_NVIS_EXTRACT papf
                   WHERE  1=1
                   AND  papf.person_id =pt.task_manager_person_id
                   AND   TRUNC(sysdate) BETWEEN papf.effective_start_Date AND
                         NVL(papf.effective_end_Date, sysdate))                       manager_person_id
                  ,pt.allow_cross_charge_flag                                         allow_cross_charge_flag
                  ,pt.cc_process_labor_flag                                           cc_process_labor_flag
                  ,pt.cc_process_nl_flag                                              cc_process_nl_flag
                  ,pt.receive_project_invoice_flag                                    receive_project_invoice_flag
                  ,(SELECT hou.name
                    FROM   apps.hr_all_organization_units@MXDM_NVIS_EXTRACT hou
                    WHERE  hou.organization_id = pt.carrying_out_organization_id)     organization_name
                  ,''                                                                 reqmnt_code
                  ,''                                                                 sprint
                  ,''                                                                 priority
                  ,''                                                                 schedule_mode
                  ,(SELECT pptp.baseline_start_date
                    FROM   apps.pa_proj_task_prog_det_v@MXDM_NVIS_EXTRACT pptp
                    WHERE  pt.task_id = pptp.task_id
                    AND    pt.project_id = pptp.project_id)                          baseline_start_date
                  ,(SELECT pptp.baseline_finish_date
                    FROM   apps.pa_proj_task_prog_det_v@MXDM_NVIS_EXTRACT pptp
                    WHERE  pt.task_id = pptp.task_id
                    AND    pt.project_id = pptp.project_id)                          baseline_finish_date
--                  ,(SELECT pptp.baselined_effort
--                    FROM   apps.pa_proj_task_prog_det_v@MXDM_NVIS_EXTRACT pptp
--                    WHERE  pt.task_id = pptp.task_id
--                    AND    pt.project_id = pptp.project_id)                           baseline_effort
                  ,NULL                                                               baseline_duration
                  ,''                                                                 baseline_allocation
                  ,''                                                                 baseline_labor_cost_amount
                  ,''                                                                 baseline_labor_billed_amount
                  ,''                                                                 baseline_expense_cost_amount
                  ,''                                                                 constraint_type
                  ,''                                                                 constraint_date
                  ,''                                                                 attribute_category
                  ,''                                                                 attribute1
                  ,''                                                                 attribute2
                  ,''                                                                 attribute3
                  ,''                                                                 attribute4
                  ,''                                                                 attribute5
                  ,''                                                                 attribute6
                  ,''                                                                 attribute7
                  ,''                                                                 attribute8
                  ,''                                                                 attribute9
                  ,''                                                                 attribute10
                  ,''                                                                 attribute11
                  ,''                                                                 attribute12
                  ,''                                                                 attribute13
                  ,''                                                                 attribute14
                  ,''                                                                 attribute15
                  ,''                                                                 attribute16
                  ,''                                                                 attribute17
                  ,''                                                                 attribute18
                  ,''                                                                 attribute19
                  ,''                                                                 attribute20
                  ,''                                                                 attribute21
                  ,''                                                                 attribute22
                  ,''                                                                 attribute23
                  ,''                                                                 attribute24
                  ,''                                                                 attribute25
                  ,''                                                                 attribute26
                  ,''                                                                 attribute27
                  ,''                                                                 attribute28
                  ,''                                                                 attribute29
                  ,''                                                                 attribute30
                  ,''                                                                 attribute31
                  ,''                                                                 attribute32
                  ,''                                                                 attribute33
                  ,''                                                                 attribute34
                  ,''                                                                 attribute35
                  ,''                                                                 attribute36
                  ,''                                                                 attribute37
                  ,''                                                                 attribute38
                  ,''                                                                 attribute39
                  ,''                                                                 attribute40
                  ,''                                                                 attribute41
                  ,''                                                                 attribute42
                  ,''                                                                 attribute43
                  ,''                                                                 attribute44
                  ,''                                                                 attribute45
                  ,''                                                                 attribute46
                  ,''                                                                 attribute47
                  ,''                                                                 attribute48
                  ,''                                                                 attribute49
                  ,''                                                                 attribute50
                  ,''                                                                 attribute1_number
                  ,''                                                                 attribute2_number
                  ,''                                                                 attribute3_number
                  ,''                                                                 attribute4_number
                  ,''                                                                 attribute5_number
                  ,''                                                                 attribute6_number
                  ,''                                                                 attribute7_number
                  ,''                                                                 attribute8_number
                  ,''                                                                 attribute9_number
                  ,''                                                                 attribute10_number
                  ,''                                                                 attribute11_number
                  ,''                                                                 attribute12_number
                  ,''                                                                 attribute13_number
                  ,''                                                                 attribute14_number
                  ,''                                                                 attribute15_number
                  ,''                                                                 attribute1_date
                  ,''                                                                 attribute2_date
                  ,''                                                                 attribute3_date
                  ,''                                                                 attribute4_date
                  ,''                                                                 attribute5_date
                  ,''                                                                 attribute6_date
                  ,''                                                                 attribute7_date
                  ,''                                                                 attribute8_date
                  ,''                                                                 attribute9_date
                  ,''                                                                 attribute10_date
                  ,''                                                                 attribute11_date
                  ,''                                                                 attribute12_date
                  ,''                                                                 attribute13_date
                  ,''                                                                 attribute14_date
                  ,''                                                                 attribute15_date
                  ,NULL                                                               source_application_code
                  ,ppa.organization_name                                              ou_name
                  ,null                                                               task_rank
          FROM
                   xxmx_ppm_projects_stg ppa
                  ,apps.pa_tasks@MXDM_NVIS_EXTRACT pt
                  --,(select * from pfc_ppm_tasks_scope_p3_v ) ptv
          WHERE   ppa.project_id                                                      = pt.project_id
          AND    ( pt.completion_date                                                 IS NULL
                    OR pt.completion_date                                               > SYSDATE) 
           ;

         -- Local Type Variables
         TYPE src_pa_tasks_tbl IS TABLE OF src_pa_tasks_cur%ROWTYPE INDEX BY BINARY_INTEGER;
         src_pa_tasks_tb  src_pa_tasks_tbl;

         ex_dml_errors             EXCEPTION;
         PRAGMA EXCEPTION_INIT(ex_dml_errors, -24381);
         l_error_count             NUMBER;

         BEGIN
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
                      ,pt_i_MigrationSetID      => pt_i_MigrationSetID 
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

            xxmx_utilities_pkg.log_module_message
                (pt_i_ApplicationSuite    => gct_ApplicationSuite
                ,pt_i_Application         => gct_Application
                ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                ,pt_i_MigrationSetID      => pt_i_MigrationSetID 
                ,pt_i_Phase               => ct_Phase
                ,pt_i_Severity            => 'NOTIFICATION'
                ,pt_i_PackageName         => gcv_PackageName
                ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                ,pt_i_ModuleMessage       => 'Begin Procedure '|| TO_CHAR(systimestamp, 'DDMMYYYYHH24MISS')
                ,pt_i_OracleError         => gvt_ReturnMessage
                );
            --

              gvv_ProgressIndicator := '0010';
              xxmx_utilities_pkg.log_module_message(  
                       pt_i_ApplicationSuite    => gct_ApplicationSuite
                      ,pt_i_Application         => gct_Application
                      ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                      ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                      ,pt_i_MigrationSetID      => pt_i_MigrationSetID 
                      ,pt_i_Phase               => ct_Phase
                      ,pt_i_Severity            => 'NOTIFICATION'
                      ,pt_i_PackageName         => gcv_PackageName
                      ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                      ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                      ,pt_i_ModuleMessage       => 'Deleting from "' || cv_StagingTable   || '".'
                      ,pt_i_OracleError         => gvt_ReturnMessage  );
              --   
              DELETE 
              FROM     XXMX_PPM_PRJ_TASKS_STG ;

              COMMIT;
              --

            gvv_ProgressIndicator := '0020';
            --
            gvt_MigrationSetName := xxmx_utilities_pkg.get_migration_set_name(pt_i_MigrationSetID);
            --
            /*
            ** If the Migration Set Name is NULL then the Migration has not been initialized.
            */
            --
            IF   gvt_MigrationSetName IS NOT NULL
            THEN
               --
               gvv_ProgressIndicator := '0030';
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gv_i_BusinessEntity
                    ,pt_i_SubEntity         => cv_i_BusinessEntityLevel
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Extracting "'
                                             ||pt_i_SubEntity
                                             ||'":'
                    ,pt_i_OracleError       => NULL
                    );
               --
               /*
               ** The Migration Set has been initialised, so now initialize the detail record
               ** for the current entity.
               */
               --
               --** ISV 21/10/2020 - Removed Sequence Number parameters as the procedure will now determine the correct values from the metadata
               --**                  table based on the Application Suite, Application and Business Entity parameters.
               --**
               --**                  Removed "entity" from procedure_name.
               --
               xxmx_utilities_pkg.init_migration_details
                    (
                     pt_i_ApplicationSuite => gct_ApplicationSuite
                    ,pt_i_Application      => gct_Application
                    ,pt_i_BusinessEntity   => gv_i_BusinessEntity
                    ,pt_i_SubEntity        => cv_i_BusinessEntityLevel
                    ,pt_i_MigrationSetID   => pt_i_MigrationSetID
                    ,pt_i_StagingTable     => cv_StagingTable
                    ,pt_i_ExtractStartDate => SYSDATE
                    );
               --
               --** ISV 21/10/2020 - "pt_i_StagingTable" no longer needs to be passed as a parameter from the STG_MAIN procedure
               --**                  as the table name will never change so replace with new constant "ct_StgTable".
               --
               --**                  We will still keep the table name in the Metadata table as that can be used for reporting
               --**                  purposes.
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gv_i_BusinessEntity
                    ,pt_i_SubEntity         => cv_i_BusinessEntityLevel
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Staging Table "'
                                             ||cv_StagingTable
                                             ||'" reporting details initialised.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               gvv_ProgressIndicator := '0040';
               --
               --** Extract the Projects and insert into the staging table.
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gv_i_BusinessEntity
                    ,pt_i_SubEntity         => cv_i_BusinessEntityLevel
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Extracting data into "'
                                             ||cv_StagingTable
                                             ||'".'
                    ,pt_i_OracleError       => NULL
                    );
               --
               --** ISV 21/10/2020 - The staging table is in the xxmx_stg schema but should not need to be prefixed as there should
               --**                  by a Synonym in the xxmx_core schema to that table.
               --
              OPEN src_pa_tasks_cur;
              --

              gvv_ProgressIndicator := '0050';
              xxmx_utilities_pkg.log_module_message(  
                       pt_i_ApplicationSuite    => gct_ApplicationSuite
                      ,pt_i_Application         => gct_Application
                      ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                      ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                      ,pt_i_MigrationSetID      => pt_i_MigrationSetID 
                      ,pt_i_Phase               => ct_Phase
                      ,pt_i_Severity            => 'NOTIFICATION'
                      ,pt_i_PackageName         => gcv_PackageName
                      ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                      ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                      ,pt_i_ModuleMessage       => 'Cursor Open src_pa_tasks_cur'
                      ,pt_i_OracleError         => gvt_ReturnMessage  );
              --
              LOOP
              --        
              gvv_ProgressIndicator := '0060';
              xxmx_utilities_pkg.log_module_message(  
                       pt_i_ApplicationSuite    => gct_ApplicationSuite
                      ,pt_i_Application         => gct_Application
                      ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                      ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                      ,pt_i_MigrationSetID      => pt_i_MigrationSetID 
                      ,pt_i_Phase               => ct_Phase
                      ,pt_i_Severity            => 'NOTIFICATION'
                      ,pt_i_PackageName         => gcv_PackageName
                      ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                      ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                      ,pt_i_ModuleMessage       => 'Inside the Cursor loop'
                      ,pt_i_OracleError         => gvt_ReturnMessage  );
              --
              FETCH src_pa_tasks_cur  BULK COLLECT INTO src_pa_tasks_tb LIMIT 1000;
              --

              gvv_ProgressIndicator := '0070';
              xxmx_utilities_pkg.log_module_message(  
                       pt_i_ApplicationSuite    => gct_ApplicationSuite
                      ,pt_i_Application         => gct_Application
                      ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                      ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                      ,pt_i_MigrationSetID      => pt_i_MigrationSetID 
                      ,pt_i_Phase               => ct_Phase
                      ,pt_i_Severity            => 'NOTIFICATION'
                      ,pt_i_PackageName         => gcv_PackageName
                      ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                      ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                      ,pt_i_ModuleMessage       => 'Cursor src_pa_tasks_cur Fetch into src_pa_tasks_tb'
                      ,pt_i_OracleError         => gvt_ReturnMessage  );
              --
              EXIT WHEN src_pa_tasks_tb.COUNT=0;
              --
              FORALL I IN 1..src_pa_tasks_tb.COUNT
              --
                  INSERT INTO XXMX_PPM_PRJ_TASKS_STG
                                              (
                                              migration_set_id
                                              ,migration_status
                                              ,migration_set_name
                                              ,project_name
                                              ,project_number
                                              ,task_name
                                              ,task_number
                                              ,source_task_reference
                                              ,financial_task
                                              ,task_description
                                              ,parent_task_number
                                              ,planning_start_date
                                              ,planning_end_date
                                              ,planned_effort
                                              ,planned_duration
                                              ,milestone_flag
                                              ,critical_flag
                                              ,chargeable_flag
                                              ,billable_flag
                                              ,capitalizable_flag
                                              ,limit_to_txn_controls_flag
                                              ,service_type_code
                                              ,work_type_id
                                              ,manager_person_id
                                              ,allow_cross_charge_flag
                                              ,cc_process_labor_flag
                                              ,cc_process_nl_flag
                                              ,receive_project_invoice_flag
                                              ,organization_name
                                              ,reqmnt_code
                                              ,sprint
                                              ,priority
                                              ,schedule_mode
                                              ,baseline_start_date
                                              ,baseline_finish_date
                                              --,baseline_effort
                                              ,baseline_duration
                                              ,baseline_allocation
                                              ,baseline_labor_cost_amount
                                              ,baseline_labor_billed_amount
                                              ,baseline_expense_cost_amount
                                              ,CONSTRAINT_TYPE_CODE
                                              ,constraint_date
                                              ,attribute_category
                                              ,attribute1
                                              ,attribute2
                                              ,attribute3
                                              ,attribute4
                                              ,attribute5
                                              ,attribute6
                                              ,attribute7
                                              ,attribute8
                                              ,attribute9
                                              ,attribute10
                                              ,attribute11
                                              ,attribute12
                                              ,attribute13
                                              ,attribute14
                                              ,attribute15
                                              ,attribute16
                                              ,attribute17
                                              ,attribute18
                                              ,attribute19
                                              ,attribute20
                                              ,attribute21
                                              ,attribute22
                                              ,attribute23
                                              ,attribute24
                                              ,attribute25
                                              ,attribute26
                                              ,attribute27
                                              ,attribute28
                                              ,attribute29
                                              ,attribute30
                                              ,attribute31
                                              ,attribute32
                                              ,attribute33
                                              ,attribute34
                                              ,attribute35
                                              ,attribute36
                                              ,attribute37
                                              ,attribute38
                                              ,attribute39
                                              ,attribute40
                                              ,attribute41
                                              ,attribute42
                                              ,attribute43
                                              ,attribute44
                                              ,attribute45
                                              ,attribute46
                                              ,attribute47
                                              ,attribute48
                                              ,attribute49
                                              ,attribute50
                                              ,attribute1_number
                                              ,attribute2_number
                                              ,attribute3_number
                                              ,attribute4_number
                                              ,attribute5_number
                                              ,attribute6_number
                                              ,attribute7_number
                                              ,attribute8_number
                                              ,attribute9_number
                                              ,attribute10_number
                                              ,attribute11_number
                                              ,attribute12_number
                                              ,attribute13_number
                                              ,attribute14_number
                                              ,attribute15_number
                                              ,attribute1_date
                                              ,attribute2_date
                                              ,attribute3_date
                                              ,attribute4_date
                                              ,attribute5_date
                                              ,attribute6_date
                                              ,attribute7_date
                                              ,attribute8_date
                                              ,attribute9_date
                                              ,attribute10_date
                                              ,attribute11_date
                                              ,attribute12_date
                                              ,attribute13_date
                                              ,attribute14_date
                                              ,attribute15_date
                                              ,source_application_code
                                              ,batch_name
                                              ,created_by
                                              ,creation_date
                                              ,last_updated_by
                                              ,last_update_date
                                              ,batch_id
                                          )
                              VALUES
                                          (
                                               pt_i_MigrationSetID
                                              ,gvt_MigrationSetName
                                              ,'Extracted'
                                              ,src_pa_tasks_tb(i).project_name
                                              ,src_pa_tasks_tb(i).project_number
                                              ,src_pa_tasks_tb(i).task_name
                                              ,src_pa_tasks_tb(i).task_number
                                              ,src_pa_tasks_tb(i).source_task_reference
                                              ,src_pa_tasks_tb(i).financial_task
                                              ,src_pa_tasks_tb(i).task_description
                                              ,src_pa_tasks_tb(i).parent_task_number
                                              ,src_pa_tasks_tb(i).planning_start_date
                                              ,src_pa_tasks_tb(i).planning_end_date
                                              ,src_pa_tasks_tb(i).planned_effort
                                              ,src_pa_tasks_tb(i).planned_duration
                                              ,src_pa_tasks_tb(i).milestone_flag
                                              ,src_pa_tasks_tb(i).critical_flag
                                              ,src_pa_tasks_tb(i).chargeable_flag
                                              ,src_pa_tasks_tb(i).billable_flag
                                              ,src_pa_tasks_tb(i).capitalizable_flag
                                              ,src_pa_tasks_tb(i).limit_to_txn_controls_flag
                                              ,src_pa_tasks_tb(i).service_type_code
                                              ,src_pa_tasks_tb(i).work_type_id
                                              ,src_pa_tasks_tb(i).manager_person_id
                                              ,src_pa_tasks_tb(i).allow_cross_charge_flag
                                              ,src_pa_tasks_tb(i).cc_process_labor_flag
                                              ,src_pa_tasks_tb(i).cc_process_nl_flag
                                              ,src_pa_tasks_tb(i).receive_project_invoice_flag
                                              ,src_pa_tasks_tb(i).reqmnt_code
                                              ,src_pa_tasks_tb(i).sprint
                                              ,src_pa_tasks_tb(i).priority
                                              ,src_pa_tasks_tb(i).schedule_mode
                                              ,src_pa_tasks_tb(i).baseline_start_date
                                              ,src_pa_tasks_tb(i).baseline_finish_date
                                              --,src_pa_tasks_tb(i).baseline_effort
                                              ,src_pa_tasks_tb(i).baseline_duration
                                              ,src_pa_tasks_tb(i).baseline_allocation
                                              ,src_pa_tasks_tb(i).baseline_labor_cost_amount
                                              ,src_pa_tasks_tb(i).baseline_labor_billed_amount
                                              ,src_pa_tasks_tb(i).baseline_expense_cost_amount
                                              ,src_pa_tasks_tb(i).constraint_type
                                              ,src_pa_tasks_tb(i).constraint_date
                                              ,src_pa_tasks_tb(i).attribute_category
                                              ,src_pa_tasks_tb(i).attribute1
                                              ,src_pa_tasks_tb(i).attribute2
                                              ,src_pa_tasks_tb(i).attribute3
                                              ,src_pa_tasks_tb(i).attribute4
                                              ,src_pa_tasks_tb(i).attribute5
                                              ,src_pa_tasks_tb(i).attribute6
                                              ,src_pa_tasks_tb(i).attribute7
                                              ,src_pa_tasks_tb(i).attribute8
                                              ,src_pa_tasks_tb(i).attribute9
                                              ,src_pa_tasks_tb(i).attribute10
                                              ,src_pa_tasks_tb(i).attribute11
                                              ,src_pa_tasks_tb(i).attribute12
                                              ,src_pa_tasks_tb(i).attribute13
                                              ,src_pa_tasks_tb(i).attribute14
                                              ,src_pa_tasks_tb(i).attribute15
                                              ,src_pa_tasks_tb(i).attribute16
                                              ,src_pa_tasks_tb(i).attribute17
                                              ,src_pa_tasks_tb(i).attribute18
                                              ,src_pa_tasks_tb(i).attribute19
                                              ,src_pa_tasks_tb(i).attribute20
                                              ,src_pa_tasks_tb(i).attribute21
                                              ,src_pa_tasks_tb(i).attribute22
                                              ,src_pa_tasks_tb(i).attribute23
                                              ,src_pa_tasks_tb(i).attribute24
                                              ,src_pa_tasks_tb(i).attribute25
                                              ,src_pa_tasks_tb(i).attribute26
                                              ,src_pa_tasks_tb(i).attribute27
                                              ,src_pa_tasks_tb(i).attribute28
                                              ,src_pa_tasks_tb(i).attribute29
                                              ,src_pa_tasks_tb(i).attribute30
                                              ,src_pa_tasks_tb(i).attribute31
                                              ,src_pa_tasks_tb(i).attribute32
                                              ,src_pa_tasks_tb(i).attribute33
                                              ,src_pa_tasks_tb(i).attribute34
                                              ,src_pa_tasks_tb(i).attribute35
                                              ,src_pa_tasks_tb(i).attribute36
                                              ,src_pa_tasks_tb(i).attribute37
                                              ,src_pa_tasks_tb(i).attribute38
                                              ,src_pa_tasks_tb(i).attribute39
                                              ,src_pa_tasks_tb(i).attribute40
                                              ,src_pa_tasks_tb(i).attribute41
                                              ,src_pa_tasks_tb(i).attribute42
                                              ,src_pa_tasks_tb(i).attribute43
                                              ,src_pa_tasks_tb(i).attribute44
                                              ,src_pa_tasks_tb(i).attribute45
                                              ,src_pa_tasks_tb(i).attribute46
                                              ,src_pa_tasks_tb(i).attribute47
                                              ,src_pa_tasks_tb(i).attribute48
                                              ,src_pa_tasks_tb(i).attribute49
                                              ,src_pa_tasks_tb(i).attribute50
                                              ,src_pa_tasks_tb(i).attribute1_number
                                              ,src_pa_tasks_tb(i).attribute2_number
                                              ,src_pa_tasks_tb(i).attribute3_number
                                              ,src_pa_tasks_tb(i).attribute4_number
                                              ,src_pa_tasks_tb(i).attribute5_number
                                              ,src_pa_tasks_tb(i).attribute6_number
                                              ,src_pa_tasks_tb(i).attribute7_number
                                              ,src_pa_tasks_tb(i).attribute8_number
                                              ,src_pa_tasks_tb(i).attribute9_number
                                              ,src_pa_tasks_tb(i).attribute10_number
                                              ,src_pa_tasks_tb(i).attribute11_number
                                              ,src_pa_tasks_tb(i).attribute12_number
                                              ,src_pa_tasks_tb(i).attribute13_number
                                              ,src_pa_tasks_tb(i).attribute14_number
                                              ,src_pa_tasks_tb(i).attribute15_number
                                              ,src_pa_tasks_tb(i).attribute1_date
                                              ,src_pa_tasks_tb(i).attribute2_date
                                              ,src_pa_tasks_tb(i).attribute3_date
                                              ,src_pa_tasks_tb(i).attribute4_date
                                              ,src_pa_tasks_tb(i).attribute5_date
                                              ,src_pa_tasks_tb(i).attribute6_date
                                              ,src_pa_tasks_tb(i).attribute7_date
                                              ,src_pa_tasks_tb(i).attribute8_date
                                              ,src_pa_tasks_tb(i).attribute9_date
                                              ,src_pa_tasks_tb(i).attribute10_date
                                              ,src_pa_tasks_tb(i).attribute11_date
                                              ,src_pa_tasks_tb(i).attribute12_date
                                              ,src_pa_tasks_tb(i).attribute13_date
                                              ,src_pa_tasks_tb(i).attribute14_date
                                              ,src_pa_tasks_tb(i).attribute15_date
                                              ,src_pa_tasks_tb(i).source_application_code
                                              ,g_batch_name                                 --src_pa_tasks_tb(i).batch_name
                                              ,xxmx_utilities_pkg.gvv_UserName              --src_pa_tasks_tb(i).created_by
                                              ,SYSDATE                                      --src_pa_tasks_tb(i).creation_date
                                              ,xxmx_utilities_pkg.gvv_UserName               --src_pa_tasks_tb(i).last_updated_by
                                              ,SYSDATE                                      --src_pa_tasks_tb(i).last_update_date
                                              ,to_char(TO_DATE(SYSDATE, 'DD-MON-RRRR'),'DDMMRRRRHHMISS')          --src_pa_tasks_tb(i).batch_id
                                              ,src_pa_tasks_tb(i).ou_name              
                                          );
              --
              END LOOP;
              --

              gvv_ProgressIndicator := '0080';
              xxmx_utilities_pkg.log_module_message(  
                       pt_i_ApplicationSuite    => gct_ApplicationSuite
                      ,pt_i_Application         => gct_Application
                      ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                      ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                      ,pt_i_MigrationSetID      => pt_i_MigrationSetID 
                      ,pt_i_Phase               => ct_Phase
                      ,pt_i_Severity            => 'NOTIFICATION'
                      ,pt_i_PackageName         => gcv_PackageName
                      ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                      ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                      ,pt_i_ModuleMessage       => 'After insert into XXMX_PPM_PRJ_TASKS_STG'
                      ,pt_i_OracleError         => gvt_ReturnMessage  );
              --
              COMMIT;
              --

              gvv_ProgressIndicator := '0090';
              xxmx_utilities_pkg.log_module_message(  
                       pt_i_ApplicationSuite    => gct_ApplicationSuite
                      ,pt_i_Application         => gct_Application
                      ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                      ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                      ,pt_i_MigrationSetID      => pt_i_MigrationSetID 
                      ,pt_i_Phase               => ct_Phase
                      ,pt_i_Severity            => 'NOTIFICATION'
                      ,pt_i_PackageName         => gcv_PackageName
                      ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                      ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                      ,pt_i_ModuleMessage       => 'Data Insertion in SRC Table End' ||cv_StagingTable
                      ,pt_i_OracleError         => gvt_ReturnMessage  );


              --

             IF src_pa_tasks_cur%ISOPEN
             THEN
               --
               CLOSE src_pa_tasks_cur;
               --
             END IF;
              --

            gvv_ProgressIndicator := '0100';
            --
            /*
            ** Obtain the count of rows inserted.  We cannot use SQL$ROWCOUNT here because of the LIMIT
            ** clause on the BULK COLLECT statement.  The rowcount will be reset each time the limit
            ** is reached.
            */
            --
            --** ISV 21/10/2020 - Replace "pt_i_ClientSchemaName" (no longer passed into the extract procedures) with new constant "gct_StgSchema".
            --**                  Replace "pt_i_StagingTable" (no longer passed into the extract procedures) with new constant "ct_StgTable"
            --
            gvn_RowCount := xxmx_utilities_pkg.get_row_count
                                 (
                                  gct_StgSchema
                                 ,cv_StagingTable
                                 ,pt_i_MigrationSetID
                                 );
            --
            COMMIT;


            xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gv_i_BusinessEntity
                    ,pt_i_SubEntity         => cv_i_BusinessEntityLevel
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Extraction complete.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               --
               --** Update the migration details (Migration status will be automatically determined
               --** in the called procedure dependant on the Phase and if an Error Message has been
               --** passed).
               --
               gvv_ProgressIndicator := '0110';
               --
               --** ISV 21/10/2020 - Removed Sequence Number parameters as the procedure will now determine the correct values from the metadata
               --**                  table based on the Application Suite, Application, Business Entity and Sub-Entity parameters.
               --**
               --**                  Removed "entity" from procedure_name.
               --
               xxmx_utilities_pkg.upd_migration_details
                    (
                     pt_i_MigrationSetID          => pt_i_MigrationSetID
                    ,pt_i_BusinessEntity          => gv_i_BusinessEntity
                    ,pt_i_SubEntity               => cv_i_BusinessEntityLevel
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
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gv_i_BusinessEntity
                    ,pt_i_SubEntity         => cv_i_BusinessEntityLevel
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Migration Table "'
                                             ||cv_StagingTable
                                             ||'" reporting details updated.'
                    ,pt_i_OracleError       => NULL
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
               RAISE e_ModuleError;
               --
               --
          END IF;
          --
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => gv_i_BusinessEntity
               ,pt_i_SubEntity         => cv_i_BusinessEntityLevel
               ,pt_i_MigrationSetID    => pt_i_MigrationSetID
               ,pt_i_Phase             => ct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gcv_PackageName
               ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'Procedure "'
                                        ||gcv_PackageName
                                        ||'.'
                                        ||cv_ProcOrFuncName
                                        ||'" completed.'
               ,pt_i_OracleError       => NULL
               );
          --
          --
              --
          EXCEPTION

            WHEN ex_dml_errors THEN
                  l_error_count := SQL%BULK_EXCEPTIONS.count;
                  DBMS_OUTPUT.put_line('Number of failures: ' || l_error_count);
                  FOR i IN 1 .. l_error_count LOOP

                    gvt_ModuleMessage := 'Error: ' || i || 
                                         ' Array Index: ' || SQL%BULK_EXCEPTIONS(i).error_index ||
                                         ' Message: ' || SQLERRM(-SQL%BULK_EXCEPTIONS(i).ERROR_CODE);

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
                             ,pt_i_OracleError         => gvt_ReturnMessage   ); 

                    DBMS_OUTPUT.put_line('Error: ' || i || 
                                        ' Array Index: ' || SQL%BULK_EXCEPTIONS(i).error_index ||
                                        ' Message: ' || SQLERRM(-SQL%BULK_EXCEPTIONS(i).ERROR_CODE));
                  END LOOP;

            WHEN e_ModuleError THEN
                         --
                   IF src_pa_tasks_cur%ISOPEN
                   THEN
                     --
                     CLOSE src_pa_tasks_cur;
                     --
                   END IF;

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
                  IF src_pa_tasks_cur%ISOPEN
                   THEN
                     --
                     CLOSE src_pa_tasks_cur;
                     --
                   END IF;

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

                  IF src_pa_tasks_cur%ISOPEN
                   THEN
                     --
                     CLOSE src_pa_tasks_cur;
                     --
                   END IF;

                  --
                  ROLLBACK;
                  --
                  gvt_OracleError := SUBSTR(SQLERRM
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

      END src_pa_tasks;

     /*********************************************************
     -----------------src_pa_classifications-------------------
     **********************************************************/

     PROCEDURE src_pa_classifications
                            (pt_i_MigrationSetID              IN      xxmx_migration_headers.migration_set_id%TYPE
                            ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE)

     AS
          --
          --**********************
          --** Cursor Declarations
          --**********************
          --
         CURSOR pa_classifications_cur
          IS

          SELECT
                 ppa.name                                               AS PROJECT_NAME   --pfc_classifications_data
                ,ppc.class_category                                     AS CLASS_CATEGORY
                ,ppc.class_code                                         AS CLASS_CODE
                ,ppc.code_percentage                                    AS CODE_PERCENTAGE
                ,g_batch_name                                           AS BATCH_NAME
                ,sysdate                                                AS CREATION_DATE
                ,xxmx_utilities_pkg.gvv_UserName                        AS CREATED_BY
                ,sysdate                                                AS LAST_UPDATE_DATE
                ,xxmx_utilities_pkg.gvv_UserName                        AS LAST_UPDATED_BY
                ,to_char(TO_DATE(SYSDATE, 'DD-MON-RRRR'),'DDMMRRRRHHMISS')   AS batch_id
                ,org.name                                               AS OU_NAME
            FROM  apps.pa_projects_all@MXDM_NVIS_EXTRACT ppa
               ,apps.pa_project_classes@MXDM_NVIS_EXTRACT ppc
               ,apps.hr_all_organization_units@MXDM_NVIS_EXTRACT  org
            WHERE ppa.project_id                        = ppc.project_id
            AND ppa.org_id                              = org.organization_id
            AND org.NAME                               IN (SELECT PARAMETER_VALUE 
                                                                FROM XXMX_MIGRATION_PARAMETERS
                                                                WHERE PARAMETER_CODE = 'ORGANIZATION_NAME'
                                                                AND APPLICATION_SUITE= 'FIN'
                                                                AND APPLICATION = 'ALL'
                                                               )
            ;

       --
       --**********************
       --** Record Declarations
       --**********************
       --
         TYPE pa_classifications_tbl IS TABLE OF pa_classifications_cur%ROWTYPE INDEX BY BINARY_INTEGER;
         pa_classifications_tb pa_classifications_tbl;
       --
       --************************
       --** Constant Declarations
       --************************
       --
        cv_ProcOrFuncName                   CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'src_pa_classifications';
        cv_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_PPM_PRJ_CLASS_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'CLASSIFICATIONS';


       --
       --************************
       --** Variable Declarations
       --************************
       --
       --
       --*************************
       --** Exception Declarations
       --*************************
       --
       e_ModuleError                         EXCEPTION;
       e_DateError                           EXCEPTION;
       ex_dml_errors                         EXCEPTION;
       PRAGMA EXCEPTION_INIT(ex_dml_errors, -24381);
       l_error_count             NUMBER;
       --
       --** END Declarations **
       --
       -- Local Type Variables


   BEGIN
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
        FROM    XXMX_PPM_PRJ_CLASS_STG ;

        COMMIT;
        --

        gvv_ProgressIndicator := '0020';
        --
        gvt_MigrationSetName := xxmx_utilities_pkg.get_migration_set_name(pt_i_MigrationSetID);
        --
        /*
        ** If the Migration Set Name is NULL then the Migration has not been initialized.
        */
        --
        IF   gvt_MigrationSetName IS NOT NULL
        THEN
            --
            gvv_ProgressIndicator := '0030';
            --
            xxmx_utilities_pkg.log_module_message
                 (
                  pt_i_ApplicationSuite  => gct_ApplicationSuite
                 ,pt_i_Application       => gct_Application
                 ,pt_i_BusinessEntity    => gv_i_BusinessEntity
                 ,pt_i_SubEntity         => cv_i_BusinessEntityLevel
                 ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                 ,pt_i_Phase             => ct_Phase
                 ,pt_i_Severity          => 'NOTIFICATION'
                 ,pt_i_PackageName       => gcv_PackageName
                 ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                 ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                 ,pt_i_ModuleMessage     => '- Extracting "'
                                          ||pt_i_SubEntity
                                          ||'":'
                 ,pt_i_OracleError       => NULL
                 );
            --
            /*
            ** The Migration Set has been initialised, so now initialize the detail record
            ** for the current entity.
            */
            --
            --** ISV 21/10/2020 - Removed Sequence Number parameters as the procedure will now determine the correct values from the metadata
            --**                  table based on the Application Suite, Application and Business Entity parameters.
            --**
            --**                  Removed "entity" from procedure_name.
            --
            xxmx_utilities_pkg.init_migration_details
                 (
                  pt_i_ApplicationSuite => gct_ApplicationSuite
                 ,pt_i_Application      => gct_Application
                 ,pt_i_BusinessEntity   => gv_i_BusinessEntity
                 ,pt_i_SubEntity        => cv_i_BusinessEntityLevel
                 ,pt_i_MigrationSetID   => pt_i_MigrationSetID
                 ,pt_i_StagingTable     => cv_StagingTable
                 ,pt_i_ExtractStartDate => SYSDATE
                 );
            --
            --** ISV 21/10/2020 - "pt_i_StagingTable" no longer needs to be passed as a parameter from the STG_MAIN procedure
            --**                  as the table name will never change so replace with new constant "ct_StgTable".
            --
            --**                  We will still keep the table name in the Metadata table as that can be used for reporting
            --**                  purposes.
            --
            xxmx_utilities_pkg.log_module_message
                 (
                  pt_i_ApplicationSuite  => gct_ApplicationSuite
                 ,pt_i_Application       => gct_Application
                 ,pt_i_BusinessEntity    => gv_i_BusinessEntity
                 ,pt_i_SubEntity         => cv_i_BusinessEntityLevel
                 ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                 ,pt_i_Phase             => ct_Phase
                 ,pt_i_Severity          => 'NOTIFICATION'
                 ,pt_i_PackageName       => gcv_PackageName
                 ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                 ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                 ,pt_i_ModuleMessage     => '  - Staging Table "'
                                          ||cv_StagingTable
                                          ||'" reporting details initialised.'
                 ,pt_i_OracleError       => NULL
                 );
            --
            gvv_ProgressIndicator := '0040';
            --
            --** Extract the Projects and insert into the staging table.
            --
            xxmx_utilities_pkg.log_module_message
                 (
                  pt_i_ApplicationSuite  => gct_ApplicationSuite
                 ,pt_i_Application       => gct_Application
                 ,pt_i_BusinessEntity    => gv_i_BusinessEntity
                 ,pt_i_SubEntity         => cv_i_BusinessEntityLevel
                 ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                 ,pt_i_Phase             => ct_Phase
                 ,pt_i_Severity          => 'NOTIFICATION'
                 ,pt_i_PackageName       => gcv_PackageName
                 ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                 ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                 ,pt_i_ModuleMessage     => '  - Extracting data into "'
                                          ||cv_StagingTable
                                          ||'".'
                 ,pt_i_OracleError       => NULL
                 );
            --
            --** ISV 21/10/2020 - The staging table is in the xxmx_stg schema but should not need to be prefixed as there should
            --**                  by a Synonym in the xxmx_core schema to that table.
            --


            OPEN pa_classifications_cur;
                --

            gvv_ProgressIndicator := '0050';
            xxmx_utilities_pkg.log_module_message(  
                    pt_i_ApplicationSuite    => gct_ApplicationSuite
                   ,pt_i_Application         => gct_Application
                   ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                   ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                   ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                   ,pt_i_Phase               => ct_Phase
                   ,pt_i_Severity            => 'NOTIFICATION'
                   ,pt_i_PackageName         => gcv_PackageName
                   ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                   ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                   ,pt_i_ModuleMessage       =>'Cursor Open pa_classifications_cur'
                   ,pt_i_OracleError         => gvt_ReturnMessage  );
            --
            LOOP
            --
            gvv_ProgressIndicator := '0060';
            xxmx_utilities_pkg.log_module_message(  
                    pt_i_ApplicationSuite    => gct_ApplicationSuite
                   ,pt_i_Application         => gct_Application
                   ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                   ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                   ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                   ,pt_i_Phase               => ct_Phase
                   ,pt_i_Severity            => 'NOTIFICATION'
                   ,pt_i_PackageName         => gcv_PackageName
                   ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                   ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                   ,pt_i_ModuleMessage       =>'Inside the Cursor loop'
                   ,pt_i_OracleError         => gvt_ReturnMessage  );

            --
            FETCH pa_classifications_cur  BULK COLLECT INTO pa_classifications_tb LIMIT 1000;
            --

            gvv_ProgressIndicator := '0070';
            xxmx_utilities_pkg.log_module_message(  
                    pt_i_ApplicationSuite    => gct_ApplicationSuite
                   ,pt_i_Application         => gct_Application
                   ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                   ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                   ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                   ,pt_i_Phase               => ct_Phase
                   ,pt_i_Severity            => 'NOTIFICATION'
                   ,pt_i_PackageName         => gcv_PackageName
                   ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                   ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                   ,pt_i_ModuleMessage       => 'Cursor pa_classifications_cur Fetch into pa_classifications_tb'
                   ,pt_i_OracleError         => gvt_ReturnMessage  );
            --
            EXIT WHEN pa_classifications_tb.COUNT=0;
            --
            FORALL I IN 1..pa_classifications_tb.COUNT SAVE EXCEPTIONS
            --
                 INSERT INTO XXMX_PPM_PRJ_CLASS_STG (
                                    migration_set_id
                                   ,migration_set_name
                                   ,migration_status
                                   ,project_name
									        ,class_category
									        ,class_code
									        ,code_percentage
									        ,batch_name
									        ,created_by
									        ,creation_date
									        ,last_updated_by
									        ,last_update_date
                                   ,batch_id
                                   ,organization_name
									       )
                                  VALUES
                                  (
                                   pt_i_MigrationSetID
                                  ,gvt_MigrationSetName
                                  ,'Extracted'
                                  ,pa_classifications_tb(i).project_name         --project_name
										    ,pa_classifications_tb(i).class_category       --class_category
										    ,pa_classifications_tb(i).class_code           --class_code
										    ,pa_classifications_tb(i).code_percentage      --code_percentage
										    ,g_batch_name                                  --pa_classifications_tb(i).batch_name                          --batch_name
                                  ,xxmx_utilities_pkg.gvv_UserName                        
                                  ,sysdate                                       
                                  ,xxmx_utilities_pkg.gvv_UserName               
                                  ,sysdate                
                                  ,to_char(TO_DATE(SYSDATE, 'DD-MON-RRRR'),'DDMMRRRRHHMISS')
                                  ,pa_classifications_tb(i).ou_name              --ou_name
										   );
                --
                END LOOP;
                --
                 gvv_ProgressIndicator := '0080';
                  xxmx_utilities_pkg.log_module_message(  
                            pt_i_ApplicationSuite    => gct_ApplicationSuite
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
                COMMIT;
                -- 

                --
                --
               gvv_ProgressIndicator := '0090';
              xxmx_utilities_pkg.log_module_message(  
                               pt_i_ApplicationSuite    => gct_ApplicationSuite
                              ,pt_i_Application         => gct_Application
                              ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                              ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                              ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                              ,pt_i_Phase               => ct_Phase
                              ,pt_i_Severity            => 'NOTIFICATION'
                              ,pt_i_PackageName         => gcv_PackageName
                              ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                              ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                              ,pt_i_ModuleMessage       => 'Close the Cursor pa_classifications_cur'
                              ,pt_i_OracleError         => gvt_ReturnMessage       );   
             --


             IF pa_classifications_cur%ISOPEN
             THEN
                  --
                     CLOSE pa_classifications_cur;
                  --
             END IF;

           gvv_ProgressIndicator := '0100';
            --
            /*
            ** Obtain the count of rows inserted.  We cannot use SQL$ROWCOUNT here because of the LIMIT
            ** clause on the BULK COLLECT statement.  The rowcount will be reset each time the limit
            ** is reached.
            */
            --
            --** ISV 21/10/2020 - Replace "pt_i_ClientSchemaName" (no longer passed into the extract procedures) with new constant "gct_StgSchema".
            --**                  Replace "pt_i_StagingTable" (no longer passed into the extract procedures) with new constant "ct_StgTable"
            --
            gvn_RowCount := xxmx_utilities_pkg.get_row_count
                                 (
                                  gct_StgSchema
                                 ,cv_StagingTable
                                 ,pt_i_MigrationSetID
                                 );
            --
            COMMIT;


            xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gv_i_BusinessEntity
                    ,pt_i_SubEntity         => cv_i_BusinessEntityLevel
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Extraction complete.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               --
               --** Update the migration details (Migration status will be automatically determined
               --** in the called procedure dependant on the Phase and if an Error Message has been
               --** passed).
               --
               gvv_ProgressIndicator := '0110';
               --
               --** ISV 21/10/2020 - Removed Sequence Number parameters as the procedure will now determine the correct values from the metadata
               --**                  table based on the Application Suite, Application, Business Entity and Sub-Entity parameters.
               --**
               --**                  Removed "entity" from procedure_name.
               --
               xxmx_utilities_pkg.upd_migration_details
                    (
                     pt_i_MigrationSetID          => pt_i_MigrationSetID
                    ,pt_i_BusinessEntity          => gv_i_BusinessEntity
                    ,pt_i_SubEntity               => cv_i_BusinessEntityLevel
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
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gv_i_BusinessEntity
                    ,pt_i_SubEntity         => cv_i_BusinessEntityLevel
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Migration Table "'
                                             ||cv_StagingTable
                                             ||'" reporting details updated.'
                    ,pt_i_OracleError       => NULL
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
               RAISE e_ModuleError;
               --
               --
          END IF;
          --
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => gv_i_BusinessEntity
               ,pt_i_SubEntity         => cv_i_BusinessEntityLevel
               ,pt_i_MigrationSetID    => pt_i_MigrationSetID
               ,pt_i_Phase             => ct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gcv_PackageName
               ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'Procedure "'
                                        ||gcv_PackageName
                                        ||'.'
                                        ||cv_ProcOrFuncName
                                        ||'" completed.'
               ,pt_i_OracleError       => NULL
               );
          --
          --

    EXCEPTION
      WHEN ex_dml_errors THEN
         l_error_count := SQL%BULK_EXCEPTIONS.count;
         DBMS_OUTPUT.put_line('Number of failures: ' || l_error_count);
         FOR i IN 1 .. l_error_count LOOP

           gvt_ModuleMessage := 'Error: ' || i || 
                                ' Array Index: ' || SQL%BULK_EXCEPTIONS(i).error_index ||
                                ' Message: ' || SQLERRM(-SQL%BULK_EXCEPTIONS(i).ERROR_CODE);

           xxmx_utilities_pkg.log_module_message(  
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                    ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_Severity            => 'ERROR'
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => gvt_ModuleMessage  
                    ,pt_i_OracleError         => gvt_ReturnMessage   ); 

           DBMS_OUTPUT.put_line('Error: ' || i || 
             ' Array Index: ' || SQL%BULK_EXCEPTIONS(i).error_index ||
             ' Message: ' || SQLERRM(-SQL%BULK_EXCEPTIONS(i).ERROR_CODE));
         END LOOP;

      WHEN e_ModuleError THEN
                --
        IF pa_classifications_cur%ISOPEN
        THEN
            --
            CLOSE pa_classifications_cur;
            --
        END IF;

        xxmx_utilities_pkg.log_module_message(  
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                    ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
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
      WHEN OTHERS THEN

         IF pa_classifications_cur%ISOPEN
         THEN
             --
             CLOSE pa_classifications_cur;
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
         -- Hr_Utility.raise_error@MXDM_NVIS_EXTRACT;



     END src_pa_classifications;


     /*********************************************************
     -----------------src_pa_trx_control-------------------
     **********************************************************/

     PROCEDURE src_pa_trx_control
                            (pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                            ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE)

     AS
          --
          --**********************
          --** Cursor Declarations
          --**********************
          --
             CURSOR pa_trx_control_cur
             IS

               SELECT
                   xxmx_ppm_prj_trx_control_seq.nextval AS  txn_ctrl_reference,
                   src.project_name,
                   src.project_number,
                   src.task_number,
                   src.task_name,
                   src.expenditure_category_name,
                   src.expenditure_type,
                   src.non_labor_resource,
                   src.person_number,
                   src.person_name,
                   src.person_emailid,
                   src.person_type,
                   src.job_name,
                   src.organization_name,
                   src.chargeable_flag,
                   src.billable_flag,
                   src.capitalizable_flag,
                   src.start_date_active,
                   src.end_date_active
               from
               (SELECT
                      ppa.name                                                          AS  project_name
                     ,ppa.segment1                                                      AS  project_number
                     ,pt.task_number                                                    AS  task_number
                     ,pt.task_name                                                      AS  task_name
                     ,ptc.expenditure_category                                          as  expenditure_category_name
                     ,ptc.expenditure_type                                              as  expenditure_type
                     ,ptc.non_labor_resource                                            AS  non_labor_resource
                     ,NULL                                   AS  person_number
                     ,null                                      AS  person_name
                     ,null                                    AS  person_emailid
                     ,null           AS  person_type
                     ,NULL                                                              AS  job_name
                     ,org.name                                                         AS organization_name
                     ,ptc.chargeable_flag                                               AS chargeable_flag
                     ,ptc.billable_indicator                                            AS billable_flag
                     ,NULL                                                              AS capitalizable_flag
                     ,ptc.start_date_active                                             AS start_date_active
                     ,ptc.end_date_active                                               AS end_date_active
                FROM  apps.pa_projects_all@MXDM_NVIS_EXTRACT ppa
                     ,apps.pa_transaction_controls@MXDM_NVIS_EXTRACT ptc
                     ,apps.pa_tasks@MXDM_NVIS_EXTRACT pt
                     ,apps.hr_all_organization_units@MXDM_NVIS_EXTRACT  org
                     ,xxmx_ppm_projects_stg xpa
                WHERE ppa.project_id                                                    = ptc.project_id
                AND ptc.project_id                                                      = pt.project_id(+)
                AND xpa.project_id                                                      = ppa.project_id
                AND ptc.task_id                                                         = pt.task_id(+)
                AND ppa.org_id                                                          = org.organization_id 
                AND sysdate  BETWEEN TRUNC(ptc.start_date_active) AND TRUNC(ptc.end_date_active)

            AND ptc.person_id IS NULL
            union
            SELECT
                   --   pfc_txn_ctrl_ref_seq.nextval                                      AS  txn_ctrl_reference
                     ppa.name                                                          AS  project_name
                     ,ppa.segment1                                                      AS  project_number
                     ,pt.task_number                                                    AS  task_number
                     ,pt.task_name                                                      AS  task_name
                     ,ptc.expenditure_category                                          as  expenditure_category_name
                     ,ptc.expenditure_type                                              as  expenditure_type
                     ,ptc.non_labor_resource                                            AS  non_labor_resource
                     ,person_details.employee_number                                    AS  person_number
                     ,person_details.full_name                                          AS  person_name
                     ,person_details.email_address                                      AS  person_emailid
                     ,(SELECT substr(ppt.user_person_type,1,20)
                       FROM
                       apps.per_person_types@MXDM_NVIS_EXTRACT   ppt
                       WHERE
                       ppt.person_type_id = person_details.person_type_id)              AS  person_type
                     ,(Select distinct j.name job_name
                       from per_jobs@MXDM_NVIS_EXTRACT j,
                            pa_expenditure_items_all@MXDM_NVIS_EXTRACT peim 
                       where peim.job_id = j.job_id
                       AND   pt.task_id = peim.task_id
                       AND    ppa.project_id = peim.project_id)                         AS  job_name
                    ,org.name                                                           AS organization_name
                     ,ptc.chargeable_flag                                               AS chargeable_flag
                     ,ptc.billable_indicator                                            AS billable_flag
                     ,(SELECT max(peia.capitalizable_flag)
                       FROM   apps.pa_expend_items_adjust_all_v@MXDM_NVIS_EXTRACT peia
                       WHERE  pt.task_id = peia.task_id
                       AND    pt.project_id = peia.project_id)                     AS  capitalizable_flag
                     ,ptc.start_date_active                                             AS start_date_active
                     ,ptc.end_date_active                                               AS end_date_active
                FROM  apps.pa_projects_all@MXDM_NVIS_EXTRACT ppa
                     ,apps.pa_transaction_controls@MXDM_NVIS_EXTRACT ptc
                     ,apps.pa_tasks@MXDM_NVIS_EXTRACT pt
                     ,apps.hr_all_organization_units@MXDM_NVIS_EXTRACT  org
                     ,apps.per_all_people_f@MXDM_NVIS_EXTRACT   person_details
                     ,xxmx_ppm_projects_stg xpa
                WHERE ppa.project_id                                                    = ptc.project_id
                AND xpa.project_id                                                      = ppa.project_id
                AND ptc.project_id                                                      = pt.project_id(+)
                AND ptc.task_id                                                         = pt.task_id(+)
                AND ptc.person_id                                                       = person_details.person_id
                AND ppa.org_id                                                          = org.organization_id
                AND sysdate                                                             BETWEEN TRUNC(person_details.effective_start_date) 
                                                                                        AND TRUNC(person_details.effective_end_date)
                AND sysdate  BETWEEN TRUNC(ptc.start_date_active) AND NVL(TRUNC(ptc.end_date_active),'31-DEC-4712')
                AND ptc.person_id IS NOT NULL ) src  ;

       --
       --**********************
       --** Record Declarations
       --**********************
       --
         TYPE pa_trx_control_tbl IS TABLE OF pa_trx_control_cur%ROWTYPE INDEX BY BINARY_INTEGER;
         pa_trx_control_tb pa_trx_control_tbl;
       --
       --************************
       --** Constant Declarations
       --************************
       --
        cv_ProcOrFuncName                   CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'src_pa_trx_control';
        cv_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_PPM_PRJ_TRX_CONTROL_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'TRX_CONTROL';


       --
       --************************
       --** Variable Declarations
       --************************
       --
       --
       --*************************
       --** Exception Declarations
       --*************************
       --
       e_ModuleError                         EXCEPTION;
       e_DateError                           EXCEPTION;
       ex_dml_errors                         EXCEPTION;
       PRAGMA EXCEPTION_INIT(ex_dml_errors, -24381);
       l_error_count             NUMBER;
       --
       --** END Declarations **
       --
       -- Local Type Variables


   BEGIN
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
        FROM    xxmx_ppm_prj_trx_control_stg ;

        COMMIT;
        --

        gvv_ProgressIndicator := '0020';
        --
        gvt_MigrationSetName := xxmx_utilities_pkg.get_migration_set_name(pt_i_MigrationSetID);
        --
        /*
        ** If the Migration Set Name is NULL then the Migration has not been initialized.
        */
        --
        IF   gvt_MigrationSetName IS NOT NULL
        THEN
            --
            gvv_ProgressIndicator := '0030';
            --
            xxmx_utilities_pkg.log_module_message
                 (
                  pt_i_ApplicationSuite  => gct_ApplicationSuite
                 ,pt_i_Application       => gct_Application
                 ,pt_i_BusinessEntity    => gv_i_BusinessEntity
                 ,pt_i_SubEntity         => cv_i_BusinessEntityLevel
                 ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                 ,pt_i_Phase             => ct_Phase
                 ,pt_i_Severity          => 'NOTIFICATION'
                 ,pt_i_PackageName       => gcv_PackageName
                 ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                 ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                 ,pt_i_ModuleMessage     => '- Extracting "'
                                          ||pt_i_SubEntity
                                          ||'":'
                 ,pt_i_OracleError       => NULL
                 );
            --
            /*
            ** The Migration Set has been initialised, so now initialize the detail record
            ** for the current entity.
            */
            --
            --** ISV 21/10/2020 - Removed Sequence Number parameters as the procedure will now determine the correct values from the metadata
            --**                  table based on the Application Suite, Application and Business Entity parameters.
            --**
            --**                  Removed "entity" from procedure_name.
            --
            xxmx_utilities_pkg.init_migration_details
                 (
                  pt_i_ApplicationSuite => gct_ApplicationSuite
                 ,pt_i_Application      => gct_Application
                 ,pt_i_BusinessEntity   => gv_i_BusinessEntity
                 ,pt_i_SubEntity        => cv_i_BusinessEntityLevel
                 ,pt_i_MigrationSetID   => pt_i_MigrationSetID
                 ,pt_i_StagingTable     => cv_StagingTable
                 ,pt_i_ExtractStartDate => SYSDATE
                 );
            --
            --** ISV 21/10/2020 - "pt_i_StagingTable" no longer needs to be passed as a parameter from the STG_MAIN procedure
            --**                  as the table name will never change so replace with new constant "ct_StgTable".
            --
            --**                  We will still keep the table name in the Metadata table as that can be used for reporting
            --**                  purposes.
            --
            xxmx_utilities_pkg.log_module_message
                 (
                  pt_i_ApplicationSuite  => gct_ApplicationSuite
                 ,pt_i_Application       => gct_Application
                 ,pt_i_BusinessEntity    => gv_i_BusinessEntity
                 ,pt_i_SubEntity         => cv_i_BusinessEntityLevel
                 ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                 ,pt_i_Phase             => ct_Phase
                 ,pt_i_Severity          => 'NOTIFICATION'
                 ,pt_i_PackageName       => gcv_PackageName
                 ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                 ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                 ,pt_i_ModuleMessage     => '  - Staging Table "'
                                          ||cv_StagingTable
                                          ||'" reporting details initialised.'
                 ,pt_i_OracleError       => NULL
                 );
            --
            gvv_ProgressIndicator := '0040';
            --
            --** Extract the Projects and insert into the staging table.
            --
            xxmx_utilities_pkg.log_module_message
                 (
                  pt_i_ApplicationSuite  => gct_ApplicationSuite
                 ,pt_i_Application       => gct_Application
                 ,pt_i_BusinessEntity    => gv_i_BusinessEntity
                 ,pt_i_SubEntity         => cv_i_BusinessEntityLevel
                 ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                 ,pt_i_Phase             => ct_Phase
                 ,pt_i_Severity          => 'NOTIFICATION'
                 ,pt_i_PackageName       => gcv_PackageName
                 ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                 ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                 ,pt_i_ModuleMessage     => '  - Extracting data into "'
                                          ||cv_StagingTable
                                          ||'".'
                 ,pt_i_OracleError       => NULL
                 );
            --
            --** ISV 21/10/2020 - The staging table is in the xxmx_stg schema but should not need to be prefixed as there should
            --**                  by a Synonym in the xxmx_core schema to that table.
            --


            OPEN pa_trx_control_cur;
                --

            gvv_ProgressIndicator := '0050';
            xxmx_utilities_pkg.log_module_message(  
                    pt_i_ApplicationSuite    => gct_ApplicationSuite
                   ,pt_i_Application         => gct_Application
                   ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                   ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                   ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                   ,pt_i_Phase               => ct_Phase
                   ,pt_i_Severity            => 'NOTIFICATION'
                   ,pt_i_PackageName         => gcv_PackageName
                   ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                   ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                   ,pt_i_ModuleMessage       =>'Cursor Open pa_trx_control_cur'
                   ,pt_i_OracleError         => gvt_ReturnMessage  );
            --
            LOOP
            --
            gvv_ProgressIndicator := '0060';
            xxmx_utilities_pkg.log_module_message(  
                    pt_i_ApplicationSuite    => gct_ApplicationSuite
                   ,pt_i_Application         => gct_Application
                   ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                   ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                   ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                   ,pt_i_Phase               => ct_Phase
                   ,pt_i_Severity            => 'NOTIFICATION'
                   ,pt_i_PackageName         => gcv_PackageName
                   ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                   ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                   ,pt_i_ModuleMessage       =>'Inside the Cursor loop'
                   ,pt_i_OracleError         => gvt_ReturnMessage  );

            --
            FETCH pa_trx_control_cur  BULK COLLECT INTO pa_trx_control_tb LIMIT 1000;
            --

            gvv_ProgressIndicator := '0070';
            xxmx_utilities_pkg.log_module_message(  
                    pt_i_ApplicationSuite    => gct_ApplicationSuite
                   ,pt_i_Application         => gct_Application
                   ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                   ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                   ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                   ,pt_i_Phase               => ct_Phase
                   ,pt_i_Severity            => 'NOTIFICATION'
                   ,pt_i_PackageName         => gcv_PackageName
                   ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                   ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                   ,pt_i_ModuleMessage       => 'Cursor pa_trx_control_cur Fetch into pa_trx_control_tb'
                   ,pt_i_OracleError         => gvt_ReturnMessage  );
            --
            EXIT WHEN pa_trx_control_tb.COUNT=0;
            --
            FORALL I IN 1..pa_trx_control_tb.COUNT SAVE EXCEPTIONS
            --

                        INSERT INTO xxmx_ppm_prj_trx_control_stg (
                                       migration_set_id
                                      ,migration_set_name
                                      ,migration_status
                                      ,txn_ctrl_reference
                                      ,project_name
                                      ,project_number
                                      ,task_number
                                      ,task_name
                                      ,expenditure_category_name
                                      ,expenditure_type
                                      ,non_labor_resource
                                      ,person_number
                                      ,person_name
                                      ,person_email
                                      ,person_type
		                                ,job_name
		                                ,organization_name
		                                ,chargeable_flag
		                                ,billable_flag
		                                ,capitalizable_flag
		                                ,start_date_active
		                                ,end_date_active
		                                ,batch_name
		                                ,creation_date
		                                ,created_by
		                                ,last_update_date
		                                ,last_updated_by
                                      ,batch_id
									    )
                                  VALUES
                                        (
                                         pt_i_MigrationSetID
                                        ,gvt_MigrationSetName
                                        ,'Extracted'
                                        ,pa_trx_control_tb(i).txn_ctrl_reference                   --txn_ctrl_reference
                                        ,pa_trx_control_tb(i).project_name                         --project_name
                                        ,pa_trx_control_tb(i).project_number                       --project_number
                                        ,pa_trx_control_tb(i).task_number                          --task_number
                                        ,pa_trx_control_tb(i).task_name                            --task_name
                                        ,pa_trx_control_tb(i).expenditure_category_name            --expenditure_category_name
                                        ,pa_trx_control_tb(i).expenditure_type                     --expenditure_type
                                        ,pa_trx_control_tb(i).non_labor_resource                   --non_labor_resource
                                        ,pa_trx_control_tb(i).person_number                        --person_number
                                        ,pa_trx_control_tb(i).person_name                          --person_name
                                        ,pa_trx_control_tb(i).person_emailid                       --person_emailid
                                        ,pa_trx_control_tb(i).person_type                          --person_type
                                        ,pa_trx_control_tb(i).job_name                             --job_name
                                        ,pa_trx_control_tb(i).organization_name                    --organization_name
                                        ,pa_trx_control_tb(i).chargeable_flag                      --chargeable_flag
                                        ,pa_trx_control_tb(i).billable_flag                        --billable_flag
                                        ,pa_trx_control_tb(i).capitalizable_flag                   --capitalizable_flag
                                        ,pa_trx_control_tb(i).start_date_active                    --start_date_active
                                        ,pa_trx_control_tb(i).end_date_active                      --end_date_active
                                        ,g_batch_name                                  --pa_classifications_tb(i).batch_name                          --batch_name
                                        ,sysdate                                       
                                        ,xxmx_utilities_pkg.gvv_UserName                        
                                        ,sysdate                                                
                                        ,xxmx_utilities_pkg.gvv_UserName                        
                                        ,to_char(TO_DATE(SYSDATE, 'DD-MON-RRRR'),'DDMMRRRRHHMISS')                            --batch_id
										);


                --
                END LOOP;
                --
                 gvv_ProgressIndicator := '0080';
                  xxmx_utilities_pkg.log_module_message(  
                            pt_i_ApplicationSuite    => gct_ApplicationSuite
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
                COMMIT;
                --
                --
               gvv_ProgressIndicator := '0090';
              xxmx_utilities_pkg.log_module_message(  
                               pt_i_ApplicationSuite    => gct_ApplicationSuite
                              ,pt_i_Application         => gct_Application
                              ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                              ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                              ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                              ,pt_i_Phase               => ct_Phase
                              ,pt_i_Severity            => 'NOTIFICATION'
                              ,pt_i_PackageName         => gcv_PackageName
                              ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                              ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                              ,pt_i_ModuleMessage       => 'Close the Cursor pa_trx_control_cur'
                              ,pt_i_OracleError         => gvt_ReturnMessage       );   
             --


             IF pa_trx_control_cur%ISOPEN
             THEN
                  --
                     CLOSE pa_trx_control_cur;
                  --
             END IF;

           gvv_ProgressIndicator := '0100';
            --
            /*
            ** Obtain the count of rows inserted.  We cannot use SQL$ROWCOUNT here because of the LIMIT
            ** clause on the BULK COLLECT statement.  The rowcount will be reset each time the limit
            ** is reached.
            */
            --
            --** ISV 21/10/2020 - Replace "pt_i_ClientSchemaName" (no longer passed into the extract procedures) with new constant "gct_StgSchema".
            --**                  Replace "pt_i_StagingTable" (no longer passed into the extract procedures) with new constant "ct_StgTable"
            --
            gvn_RowCount := xxmx_utilities_pkg.get_row_count
                                 (
                                  gct_StgSchema
                                 ,cv_StagingTable
                                 ,pt_i_MigrationSetID
                                 );
            --
            COMMIT;


            xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gv_i_BusinessEntity
                    ,pt_i_SubEntity         => cv_i_BusinessEntityLevel
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Extraction complete.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               --
               --** Update the migration details (Migration status will be automatically determined
               --** in the called procedure dependant on the Phase and if an Error Message has been
               --** passed).
               --
               gvv_ProgressIndicator := '0110';
               --
               --** ISV 21/10/2020 - Removed Sequence Number parameters as the procedure will now determine the correct values from the metadata
               --**                  table based on the Application Suite, Application, Business Entity and Sub-Entity parameters.
               --**
               --**                  Removed "entity" from procedure_name.
               --
               xxmx_utilities_pkg.upd_migration_details
                    (
                     pt_i_MigrationSetID          => pt_i_MigrationSetID
                    ,pt_i_BusinessEntity          => gv_i_BusinessEntity
                    ,pt_i_SubEntity               => cv_i_BusinessEntityLevel
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
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gv_i_BusinessEntity
                    ,pt_i_SubEntity         => cv_i_BusinessEntityLevel
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Migration Table "'
                                             ||cv_StagingTable
                                             ||'" reporting details updated.'
                    ,pt_i_OracleError       => NULL
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
               RAISE e_ModuleError;
               --
               --
          END IF;
          --
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => gv_i_BusinessEntity
               ,pt_i_SubEntity         => cv_i_BusinessEntityLevel
               ,pt_i_MigrationSetID    => pt_i_MigrationSetID
               ,pt_i_Phase             => ct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gcv_PackageName
               ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'Procedure "'
                                        ||gcv_PackageName
                                        ||'.'
                                        ||cv_ProcOrFuncName
                                        ||'" completed.'
               ,pt_i_OracleError       => NULL
               );
          --
          --

    EXCEPTION
      WHEN ex_dml_errors THEN
         l_error_count := SQL%BULK_EXCEPTIONS.count;
         DBMS_OUTPUT.put_line('Number of failures: ' || l_error_count);
         FOR i IN 1 .. l_error_count LOOP

           gvt_ModuleMessage := 'Error: ' || i || 
                                ' Array Index: ' || SQL%BULK_EXCEPTIONS(i).error_index ||
                                ' Message: ' || SQLERRM(-SQL%BULK_EXCEPTIONS(i).ERROR_CODE);

           xxmx_utilities_pkg.log_module_message(  
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                    ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_Severity            => 'ERROR'
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => gvt_ModuleMessage  
                    ,pt_i_OracleError         => gvt_ReturnMessage   ); 

           DBMS_OUTPUT.put_line('Error: ' || i || 
             ' Array Index: ' || SQL%BULK_EXCEPTIONS(i).error_index ||
             ' Message: ' || SQLERRM(-SQL%BULK_EXCEPTIONS(i).ERROR_CODE));
         END LOOP;

      WHEN e_ModuleError THEN
                --
        IF pa_trx_control_cur%ISOPEN
        THEN
            --
            CLOSE pa_trx_control_cur;
            --
        END IF;

        xxmx_utilities_pkg.log_module_message(  
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                    ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
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
      WHEN OTHERS THEN

         IF pa_trx_control_cur%ISOPEN
         THEN
             --
             CLOSE pa_trx_control_cur;
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
         -- Hr_Utility.raise_error@MXDM_NVIS_EXTRACT;



     END src_pa_trx_control;


     /*********************************************************
     -----------------src_pa_team_members-------------------
     **********************************************************/

     PROCEDURE src_pa_team_members
                            (pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                            ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE)

     AS
          --
          --**********************
          --** Cursor Declarations
          --**********************
          --
            CURSOR pa_team_mem_cur
            IS

            SELECT 
                src.project_name
               ,src.team_member_number
               ,src.team_member_name
               ,src.team_member_email
               ,src.project_role_name
               --,MIN(src.start_date_active) start_date_active
               ,src.start_date_active 
               --,TO_DATE(MAX(DECODE(src.end_date_active,'31-DEC-12',NULL,src.end_date_active))) end_date_active
               ,DECODE(src.end_date_active,'31-DEC-12',NULL,src.end_date_active) end_date_active
               ,src.allocation
               ,src.effort
               ,src.cost_rate
               ,src.bill_rate
               ,src.track_time_flag
               ,src.assignment_type
               ,src.billable_percent
               ,src.billable_percent_reason_code
               ,src.ou_name
               ,src.extract_source
               ,src.extract_comments
               ,src.project_number
            FROM(
            SELECT DISTINCT 
                ppa.project_name                                   AS project_name,
                NVL(papf.employee_number,papf.npw_number)          AS team_member_number,
                NULL                                               AS team_member_name,
                NULL                                               AS team_member_email,
                pprt.meaning                                       AS PROJECT_ROLE_NAME,
                --TO_DATE(TO_DATE(g_cutover_date,'DD-MON-YY') + 1) AS start_date_active,
            	 ppp.start_date_active                              AS START_DATE_ACTIVE,
                ppp.end_date_active                                AS end_date_active,
                NULL                                               AS allocation,
                NULL                                               AS effort,
                NULL                                               AS cost_rate,
                NULL                                               AS bill_rate,
                NULL                                               AS track_time_flag,
                NULL                                               AS assignment_type,
                NULL                                               AS billable_percent,
                NULL                                               AS billable_percent_reason_code,
                ppa.organization_name                              AS ou_name,
                ppa.project_number                                 AS project_number,
                NULL                                               AS extract_source,
                NULL                                               AS extract_comments
            FROM
                apps.pa_project_parties@MXDM_NVIS_EXTRACT ppp,
                apps.per_all_people_f@MXDM_NVIS_EXTRACT papf,
                apps.pa_project_role_types_tl@MXDM_NVIS_EXTRACT pprt,
               -- apps.pa_projects_all@MXDM_NVIS_EXTRACT ppa,
                xxmx_ppm_projects_stg ppa
            	--apps.hr_all_organization_units@MXDM_NVIS_EXTRACT org
            WHERE
                ppp.project_id = ppa.project_id
                AND   ppp.resource_source_id = papf.person_id
                AND   pprt.project_role_id = ppp.project_role_id
                AND SYSDATE BETWEEN papf.effective_start_date AND NVL(papf.effective_end_date,SYSDATE)
                AND SYSDATE BETWEEN ppp.start_date_active AND NVL(ppp.end_date_active,SYSDATE)      
                AND nvl(papf.employee_number,papf.npw_number)  IS NOT NULL
                --AND nvl(papf.employee_number,papf.npw_number) NOT LIKE 'X%'
                -- AND   ppa.org_id = org.organization_id	 
            )src ;
       --
       --**********************
       --** Record Declarations
       --**********************
       --
         TYPE pa_team_mem_tbl IS TABLE OF pa_team_mem_cur%ROWTYPE INDEX BY BINARY_INTEGER;
         pa_team_mem_tb pa_team_mem_tbl;
       --
       --************************
       --** Constant Declarations
       --************************
       --
        cv_ProcOrFuncName                   CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'src_pa_team_members';
        cv_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_PPM_PRJ_TEAM_MEM_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'TEAM_MEMBERS';


       --
       --************************
       --** Variable Declarations
       --************************
       --
       --
       --*************************
       --** Exception Declarations
       --*************************
       --
       e_ModuleError                         EXCEPTION;
       e_DateError                           EXCEPTION;
       ex_dml_errors                         EXCEPTION;
       PRAGMA EXCEPTION_INIT(ex_dml_errors, -24381);
       l_error_count             NUMBER;
       --
       --** END Declarations **
       --
       -- Local Type Variables


   BEGIN
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
        FROM    xxmx_ppm_prj_team_mem_stg ;

        COMMIT;
        --

        gvv_ProgressIndicator := '0020';
        --
        gvt_MigrationSetName := xxmx_utilities_pkg.get_migration_set_name(pt_i_MigrationSetID);
        --
        /*
        ** If the Migration Set Name is NULL then the Migration has not been initialized.
        */
        --
        IF   gvt_MigrationSetName IS NOT NULL
        THEN
            --
            gvv_ProgressIndicator := '0030';
            --
            xxmx_utilities_pkg.log_module_message
                 (
                  pt_i_ApplicationSuite  => gct_ApplicationSuite
                 ,pt_i_Application       => gct_Application
                 ,pt_i_BusinessEntity    => gv_i_BusinessEntity
                 ,pt_i_SubEntity         => cv_i_BusinessEntityLevel
                 ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                 ,pt_i_Phase             => ct_Phase
                 ,pt_i_Severity          => 'NOTIFICATION'
                 ,pt_i_PackageName       => gcv_PackageName
                 ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                 ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                 ,pt_i_ModuleMessage     => '- Extracting "'
                                          ||pt_i_SubEntity
                                          ||'":'
                 ,pt_i_OracleError       => NULL
                 );
            --
            /*
            ** The Migration Set has been initialised, so now initialize the detail record
            ** for the current entity.
            */
            --
            --** ISV 21/10/2020 - Removed Sequence Number parameters as the procedure will now determine the correct values from the metadata
            --**                  table based on the Application Suite, Application and Business Entity parameters.
            --**
            --**                  Removed "entity" from procedure_name.
            --
            xxmx_utilities_pkg.init_migration_details
                 (
                  pt_i_ApplicationSuite => gct_ApplicationSuite
                 ,pt_i_Application      => gct_Application
                 ,pt_i_BusinessEntity   => gv_i_BusinessEntity
                 ,pt_i_SubEntity        => cv_i_BusinessEntityLevel
                 ,pt_i_MigrationSetID   => pt_i_MigrationSetID
                 ,pt_i_StagingTable     => cv_StagingTable
                 ,pt_i_ExtractStartDate => SYSDATE
                 );
            --
            --** ISV 21/10/2020 - "pt_i_StagingTable" no longer needs to be passed as a parameter from the STG_MAIN procedure
            --**                  as the table name will never change so replace with new constant "ct_StgTable".
            --
            --**                  We will still keep the table name in the Metadata table as that can be used for reporting
            --**                  purposes.
            --
            xxmx_utilities_pkg.log_module_message
                 (
                  pt_i_ApplicationSuite  => gct_ApplicationSuite
                 ,pt_i_Application       => gct_Application
                 ,pt_i_BusinessEntity    => gv_i_BusinessEntity
                 ,pt_i_SubEntity         => cv_i_BusinessEntityLevel
                 ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                 ,pt_i_Phase             => ct_Phase
                 ,pt_i_Severity          => 'NOTIFICATION'
                 ,pt_i_PackageName       => gcv_PackageName
                 ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                 ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                 ,pt_i_ModuleMessage     => '  - Staging Table "'
                                          ||cv_StagingTable
                                          ||'" reporting details initialised.'
                 ,pt_i_OracleError       => NULL
                 );
            --
            gvv_ProgressIndicator := '0040';
            --
            --** Extract the Projects and insert into the staging table.
            --
            xxmx_utilities_pkg.log_module_message
                 (
                  pt_i_ApplicationSuite  => gct_ApplicationSuite
                 ,pt_i_Application       => gct_Application
                 ,pt_i_BusinessEntity    => gv_i_BusinessEntity
                 ,pt_i_SubEntity         => cv_i_BusinessEntityLevel
                 ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                 ,pt_i_Phase             => ct_Phase
                 ,pt_i_Severity          => 'NOTIFICATION'
                 ,pt_i_PackageName       => gcv_PackageName
                 ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                 ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                 ,pt_i_ModuleMessage     => '  - Extracting data into "'
                                          ||cv_StagingTable
                                          ||'".'
                 ,pt_i_OracleError       => NULL
                 );
            --
            --** ISV 21/10/2020 - The staging table is in the xxmx_stg schema but should not need to be prefixed as there should
            --**                  by a Synonym in the xxmx_core schema to that table.
            --


            OPEN pa_team_mem_cur;
                --

            gvv_ProgressIndicator := '0050';
            xxmx_utilities_pkg.log_module_message(  
                    pt_i_ApplicationSuite    => gct_ApplicationSuite
                   ,pt_i_Application         => gct_Application
                   ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                   ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                   ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                   ,pt_i_Phase               => ct_Phase
                   ,pt_i_Severity            => 'NOTIFICATION'
                   ,pt_i_PackageName         => gcv_PackageName
                   ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                   ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                   ,pt_i_ModuleMessage       =>'Cursor Open pa_team_mem_cur'
                   ,pt_i_OracleError         => gvt_ReturnMessage  );
            --
            LOOP
            --
            gvv_ProgressIndicator := '0060';
            xxmx_utilities_pkg.log_module_message(  
                    pt_i_ApplicationSuite    => gct_ApplicationSuite
                   ,pt_i_Application         => gct_Application
                   ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                   ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                   ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                   ,pt_i_Phase               => ct_Phase
                   ,pt_i_Severity            => 'NOTIFICATION'
                   ,pt_i_PackageName         => gcv_PackageName
                   ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                   ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                   ,pt_i_ModuleMessage       =>'Inside the Cursor loop'
                   ,pt_i_OracleError         => gvt_ReturnMessage  );

            --
            FETCH pa_team_mem_cur  BULK COLLECT INTO pa_team_mem_tb LIMIT 1000;
            --

            gvv_ProgressIndicator := '0070';
            xxmx_utilities_pkg.log_module_message(  
                    pt_i_ApplicationSuite    => gct_ApplicationSuite
                   ,pt_i_Application         => gct_Application
                   ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                   ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                   ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                   ,pt_i_Phase               => ct_Phase
                   ,pt_i_Severity            => 'NOTIFICATION'
                   ,pt_i_PackageName         => gcv_PackageName
                   ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                   ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                   ,pt_i_ModuleMessage       => 'Cursor pa_team_mem_cur Fetch into pa_team_mem_tb'
                   ,pt_i_OracleError         => gvt_ReturnMessage  );
            --
            EXIT WHEN pa_team_mem_tb.COUNT=0;
            --
            FORALL I IN 1..pa_team_mem_tb.COUNT SAVE EXCEPTIONS
            --

                        INSERT INTO xxmx_ppm_prj_team_mem_stg (
                                       migration_set_id,
                                       migration_set_name,
                                       migration_status,
                                       project_name,
                                       team_member_number,
                                       team_member_name,
                                       team_member_email,
                                       project_role,
                                       start_date_active,
                                       end_date_active,
                                       allocation,
                                       labor_effort,
                                       cost_rate,
                                       bill_rate,
                                       track_time, 
                                       assignment_type_code,
                                       billable_percent,
                                       billable_percent_reason_code,
                                       batch_name,
                                       creation_date,
                                       created_by,
                                       last_update_date,
                                       last_updated_by,
                                       batch_id,
                                       Organization_name,
                                       project_number

									    )
                                  VALUES
                                        (
                                         pt_i_MigrationSetID
                                        ,gvt_MigrationSetName
                                        ,'Extracted'
                                        ,pa_team_mem_tb(i).project_name                         
                                        ,pa_team_mem_tb(i).team_member_number                   
                                        ,pa_team_mem_tb(i).team_member_name                     
                                        ,pa_team_mem_tb(i).team_member_email                    
                                        ,pa_team_mem_tb(i).project_role_name                    
                                        ,pa_team_mem_tb(i).start_date_active            
                                        ,pa_team_mem_tb(i).end_date_active                     
                                        ,pa_team_mem_tb(i).allocation                   
                                        ,pa_team_mem_tb(i).effort                        
                                        ,pa_team_mem_tb(i).cost_rate                          
                                        ,pa_team_mem_tb(i).bill_rate                       
                                        ,pa_team_mem_tb(i).track_time_flag                          
                                        ,pa_team_mem_tb(i).assignment_type                             
                                        ,pa_team_mem_tb(i).billable_percent                    
                                        ,pa_team_mem_tb(i).billable_percent_reason_code                      
                                        ,g_batch_name                                           
                                        ,sysdate                                       
                                        ,xxmx_utilities_pkg.gvv_UserName                        
                                        ,sysdate                                                
                                        ,xxmx_utilities_pkg.gvv_UserName                        
                                        ,to_char(TO_DATE(SYSDATE, 'DD-MON-RRRR'),'DDMMRRRRHHMISS') --batch_id
                                        ,pa_team_mem_tb(i).ou_name
                                        ,pa_team_mem_tb(i).project_number
										);


                --
                END LOOP;
                --
                 gvv_ProgressIndicator := '0080';
                  xxmx_utilities_pkg.log_module_message(  
                            pt_i_ApplicationSuite    => gct_ApplicationSuite
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
                COMMIT;
                --
                --
               gvv_ProgressIndicator := '0090';
              xxmx_utilities_pkg.log_module_message(  
                               pt_i_ApplicationSuite    => gct_ApplicationSuite
                              ,pt_i_Application         => gct_Application
                              ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                              ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                              ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                              ,pt_i_Phase               => ct_Phase
                              ,pt_i_Severity            => 'NOTIFICATION'
                              ,pt_i_PackageName         => gcv_PackageName
                              ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                              ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                              ,pt_i_ModuleMessage       => 'Close the Cursor pa_team_mem_cur'
                              ,pt_i_OracleError         => gvt_ReturnMessage       );   
             --


             IF pa_team_mem_cur%ISOPEN
             THEN
                  --
                     CLOSE pa_team_mem_cur;
                  --
             END IF;

           gvv_ProgressIndicator := '0100';
            --
            /*
            ** Obtain the count of rows inserted.  We cannot use SQL$ROWCOUNT here because of the LIMIT
            ** clause on the BULK COLLECT statement.  The rowcount will be reset each time the limit
            ** is reached.
            */
            --
            --** ISV 21/10/2020 - Replace "pt_i_ClientSchemaName" (no longer passed into the extract procedures) with new constant "gct_StgSchema".
            --**                  Replace "pt_i_StagingTable" (no longer passed into the extract procedures) with new constant "ct_StgTable"
            --
            gvn_RowCount := xxmx_utilities_pkg.get_row_count
                                 (
                                  gct_StgSchema
                                 ,cv_StagingTable
                                 ,pt_i_MigrationSetID
                                 );
            --
            COMMIT;


            xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gv_i_BusinessEntity
                    ,pt_i_SubEntity         => cv_i_BusinessEntityLevel
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Extraction complete.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               --
               --** Update the migration details (Migration status will be automatically determined
               --** in the called procedure dependant on the Phase and if an Error Message has been
               --** passed).
               --
               gvv_ProgressIndicator := '0110';
               --
               --** ISV 21/10/2020 - Removed Sequence Number parameters as the procedure will now determine the correct values from the metadata
               --**                  table based on the Application Suite, Application, Business Entity and Sub-Entity parameters.
               --**
               --**                  Removed "entity" from procedure_name.
               --
               xxmx_utilities_pkg.upd_migration_details
                    (
                     pt_i_MigrationSetID          => pt_i_MigrationSetID
                    ,pt_i_BusinessEntity          => gv_i_BusinessEntity
                    ,pt_i_SubEntity               => cv_i_BusinessEntityLevel
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
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gv_i_BusinessEntity
                    ,pt_i_SubEntity         => cv_i_BusinessEntityLevel
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Migration Table "'
                                             ||cv_StagingTable
                                             ||'" reporting details updated.'
                    ,pt_i_OracleError       => NULL
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
               RAISE e_ModuleError;
               --
               --
          END IF;
          --
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => gv_i_BusinessEntity
               ,pt_i_SubEntity         => cv_i_BusinessEntityLevel
               ,pt_i_MigrationSetID    => pt_i_MigrationSetID
               ,pt_i_Phase             => ct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gcv_PackageName
               ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'Procedure "'
                                        ||gcv_PackageName
                                        ||'.'
                                        ||cv_ProcOrFuncName
                                        ||'" completed.'
               ,pt_i_OracleError       => NULL
               );
          --
          --

    EXCEPTION
      WHEN ex_dml_errors THEN
         l_error_count := SQL%BULK_EXCEPTIONS.count;
         DBMS_OUTPUT.put_line('Number of failures: ' || l_error_count);
         FOR i IN 1 .. l_error_count LOOP

           gvt_ModuleMessage := 'Error: ' || i || 
                                ' Array Index: ' || SQL%BULK_EXCEPTIONS(i).error_index ||
                                ' Message: ' || SQLERRM(-SQL%BULK_EXCEPTIONS(i).ERROR_CODE);

           xxmx_utilities_pkg.log_module_message(  
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                    ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_Severity            => 'ERROR'
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => gvt_ModuleMessage  
                    ,pt_i_OracleError         => gvt_ReturnMessage   ); 

           DBMS_OUTPUT.put_line('Error: ' || i || 
             ' Array Index: ' || SQL%BULK_EXCEPTIONS(i).error_index ||
             ' Message: ' || SQLERRM(-SQL%BULK_EXCEPTIONS(i).ERROR_CODE));
         END LOOP;

      WHEN e_ModuleError THEN
                --
        IF pa_team_mem_cur%ISOPEN
        THEN
            --
            CLOSE pa_team_mem_cur;
            --
        END IF;

        xxmx_utilities_pkg.log_module_message(  
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                    ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
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
      WHEN OTHERS THEN

         IF pa_team_mem_cur%ISOPEN
         THEN
             --
             CLOSE pa_team_mem_cur;
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
         -- Hr_Utility.raise_error@MXDM_NVIS_EXTRACT;



     END src_pa_team_members;


END XXMX_PPM_PROJECTS_PKG;
/

SHOW ERRORS PACKAGE BODY XXMX_PPM_PROJECTS_PKG;
/