create or replace PACKAGE XXMX_PPM_PRJ_RBS_PKG AS 
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
     ** FILENAME  :  xxmx_ppm_prj_rbs_pkg.sql
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
     ** PURPOSE   :  This package contains procedures for extracting Project Resource Breakdown 
     **              Structure into Staging tables
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
     --
     /*
     ********************************
     ** PROCEDURE: src_rbs_header
     ********************************
     */
     --
      PROCEDURE src_rbs_header
                   (pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                  ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE);
--
     --
     /*
     ********************************
     ** PROCEDURE: src_resources
     ********************************
     */
     --
     
      PROCEDURE src_resources
                    (pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                     ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE);


END XXMX_PPM_PRJ_RBS_PKG;
/
create or replace PACKAGE BODY XXMX_PPM_PRJ_RBS_PKG AS 
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
--** FILENAME  :  xxmx_ppm_prj_rbs_pkg.pkb
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
--** PURPOSE   :  This package contains procedures for extracting Project Resource BrkDown Structure
--***************************************************************************************************
--**   Vsn  Change Date  Changed By          Change Description
--** -----  -----------  ------------------  -----------------------------------
--**   1.0  23-OCT-2021  Pallavi Kanajar      Created for Maximise.
--***************************************************************************************************

    gvv_ReturnStatus                          VARCHAR2(1); 
    gvt_ReturnMessage                         xxmx_module_messages.module_message%TYPE;
    gvv_ProgressIndicator                     VARCHAR2(100); 
    gcv_PackageName                           CONSTANT  VARCHAR2(30)                                := 'XXMX_PPM_PRJ_RBS_PKG';
    gct_ApplicationSuite                      CONSTANT  xxmx_module_messages.application_suite%TYPE:= 'FIN';
    gct_Application                           CONSTANT  xxmx_module_messages.application%TYPE      := 'PPM';
    gv_i_BusinessEntity                       CONSTANT  VARCHAR2(100)                               := 'PRJ_RBS';
    gvt_migrationsetname                                VARCHAR2(100);
    ct_Phase                                  CONSTANT  xxmx_module_messages.phase%TYPE            := 'EXTRACT';
    cv_i_BusinessEntityLevel                  CONSTANT  VARCHAR2(100)                               := 'ALL';
    g_batch_name                              CONSTANT  VARCHAR2(300)                               := 'RBS_'||to_char(TO_DATE(SYSDATE, 'DD-MON-RRRR'),'DDMMRRRRHHMISS') ;
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
         AND   Business_entity = gv_i_BusinessEntity
         AND   a.enabled_flag = 'Y'
         ORDER
         BY  Business_entity_seq, 
             sub_entity_seq;

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'stg_main'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
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
   
   --------------------src_rbs_headers-----------------------
   -- Extracts Resource Breakdown Structure from EBS
   ----------------------------------------------------------
   

   PROCEDURE src_rbs_header
                     (pt_i_MigrationSetID              IN      xxmx_migration_headers.migration_set_id%TYPE
                     ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE)
     AS   

          --
          --**********************
          --** Cursor Declarations
          --**********************
          --
          CURSOR src_rbs_hdr_cur
         IS


          SELECT 
              hdrtl.name                       rbs_header_name
             ,hdrtl.description                description
             ,NULL                             project_unit_name           
             ,NULL                             job_set_name   
             ,hdr.use_for_alloc_flag           allow_change_in_project_flag
             ,hdr.effective_from_date          start_date_active
             ,hdr.effective_to_date            end_date_active
             ,hdr.business_group_id

          from pa_rbs_headers_b@mxdm_nvis_extract hdr ,
          pa_rbs_headers_tl@mxdm_nvis_extract hdrtl 
          WHERE hdr.rbs_header_id = hdrtl.rbs_header_id
          and hdrtl.language = userenv('LANG') 
          and exists (select 'Y' 
                     from pa_rbs_versions_b@mxdm_nvis_extract ver
                     where ver.rbs_header_id = hdr.rbs_header_id 
                     and ver.status_code = 'FROZEN') 
          ;
       --
       --**********************
       --** Record Declarations
       --**********************
       --
         TYPE src_rbs_hdr_tbl IS TABLE OF src_rbs_hdr_cur%ROWTYPE INDEX BY BINARY_INTEGER;
         src_rbs_hdr_tb  src_rbs_hdr_tbl;

       --
       --************************
       --** Constant Declarations
       --************************
       --
        cv_ProcOrFuncName                   CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'src_rbs_header';
        cv_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_PPM_PLANRBS_HEADER_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'RBS_HEADERS';


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
       l_error_count                         NUMBER;
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
        FROM    xxmx_ppm_planrbs_header_stg ;

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


            OPEN src_rbs_hdr_cur;
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
                   ,pt_i_ModuleMessage       =>'Cursor Open src_rbs_hdr_cur'
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
            FETCH src_rbs_hdr_cur  BULK COLLECT INTO src_rbs_hdr_tb LIMIT 1000;
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
                   ,pt_i_ModuleMessage       => 'Cursor src_rbs_hdr_cur Fetch into src_rbs_hdr_tb'
                   ,pt_i_OracleError         => gvt_ReturnMessage  );
            --
            EXIT WHEN src_rbs_hdr_tb.COUNT=0;
            --
            FORALL I IN 1..src_rbs_hdr_tb.COUNT SAVE EXCEPTIONS
            --
                 INSERT INTO xxmx_ppm_planrbs_header_stg (
                                     migration_set_id                 
                                    ,migration_set_name               
                                    ,migration_status                 
                                    ,rbs_header_name                  
                                    ,description                      
                                    ,project_unit_name                
                                    ,job_set_name                     
                                    ,allow_change_in_project_flag     
                                    ,start_date_active                
                                    ,end_date_active                  
                                    ,batch_name                       
                                    ,batch_id                         
                                    ,last_updated_by                  
                                    ,created_by                       
                                    ,last_update_login                
                                    ,last_update_date                 
                                    ,creation_date                    
                             )
                           VALUES
                           (
                            pt_i_MigrationSetID
                           ,gvt_MigrationSetName
                           ,'EXTRACTED'
                           ,src_rbs_hdr_tb(i).rbs_header_name                           --rbs_header_name
                           ,src_rbs_hdr_tb(i).description                               --description
                           ,src_rbs_hdr_tb(i).project_unit_name                         --project_unit_name
                           ,src_rbs_hdr_tb(i).job_set_name                              --job_set_name
                           ,src_rbs_hdr_tb(i).allow_change_in_project_flag              --allow_change_in_project_flag
                           ,src_rbs_hdr_tb(i).start_date_active                         --start_date_active
                           ,src_rbs_hdr_tb(i).end_date_active                           --end_date_active
                           ,g_batch_name    
                           ,to_char(TO_DATE(SYSDATE, 'DD-MON-RRRR'),'DDMMRRRRHHMISS')   
                           ,xxmx_utilities_pkg.gvv_UserName 
                           ,xxmx_utilities_pkg.gvv_UserName
                           ,xxmx_utilities_pkg.gvv_UserName
                           ,SYSDATE                                                     
                           ,SYSDATE                                                     

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
                              ,pt_i_ModuleMessage       => 'Close the Cursor src_rbs_hdr_cur'
                              ,pt_i_OracleError         => gvt_ReturnMessage       );   
             --


             IF src_rbs_hdr_cur%ISOPEN
             THEN
                  --
                     CLOSE src_rbs_hdr_cur;
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
        IF src_rbs_hdr_cur%ISOPEN
        THEN
            --
            CLOSE src_rbs_hdr_cur;
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

         IF src_rbs_hdr_cur%ISOPEN
         THEN
             --
             CLOSE src_rbs_hdr_cur;
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



     END src_rbs_header;

   /*********************************************************
   --------------------src_resources-----------------------
   -- Extracts Resource Breakdown Structure from EBS
   ----------------------------------------------------------
   **********************************************************/

   PROCEDURE src_resources
                     (pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                     ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE)
     AS   

          --
          --**********************
          --** Cursor Declarations
          --**********************
          --
         CURSOR src_resources_cur
         IS
            SELECT distinct
                 hdr.NAME                         AS rbs_header_name,
                 ppr.RES_FORMAT_NAME              AS res_format_name,
                 trim( pre.resource_name)         AS alias,
                 pre.rbs_level                    AS level1_res_name,
                 NULL                             AS level2_res_name,
                 NULL                             AS level3_res_name,
                 ppr.RESOURCE_CLASS_NAME          AS resource_class_name,
                 pra.SPREAD_CURVE_NAME            AS spread_curve_name,
                 ver.status_code,
                 NULL                             AS Project_number
            FROM
                 pa_rbs_elements_v@MXDM_NVIS_EXTRACT   pre,
                 pa_rbs_headers_v@MXDM_NVIS_EXTRACT    hdr,
                 pa_rbs_versions_b@MXDM_NVIS_EXTRACT  ver,
                 pa_task_assignments_v@MXDM_NVIS_EXTRACT pra,
                 pa_planning_resources_v@MXDM_NVIS_EXTRACT ppr

            WHERE ver.rbs_header_id = hdr.rbs_header_id
            AND    pre.rbs_version_id = ver.rbs_version_id
            AND    pra.rbs_element_id = pre.rbs_element_id
            AND    ppr.resource_list_member_id = pra.resource_list_member_id;


       --
       --**********************
       --** Record Declarations
       --**********************
       --
         TYPE src_resources_tbl IS TABLE OF src_resources_cur%ROWTYPE INDEX BY BINARY_INTEGER;
         src_resources_tb  src_resources_tbl;

       --
       --************************
       --** Constant Declarations
       --************************
       --
        cv_ProcOrFuncName                   CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'src_resources';
        cv_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_PPM_RESOURCES_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'RESOURCES';


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
       l_error_count                         NUMBER;
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
        FROM    xxmx_ppm_resources_stg ;

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


            OPEN src_resources_cur;
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
                   ,pt_i_ModuleMessage       =>'Cursor Open src_resources_cur'
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
            FETCH src_resources_cur  BULK COLLECT INTO src_resources_tb LIMIT 1000;
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
                   ,pt_i_ModuleMessage       => 'Cursor src_rbs_hdr_cur Fetch into src_resources_tb'
                   ,pt_i_OracleError         => gvt_ReturnMessage  );
            --
            EXIT WHEN src_resources_tb.COUNT=0;
            --
            FORALL I IN 1..src_resources_tb.COUNT SAVE EXCEPTIONS
            --
                 INSERT INTO xxmx_ppm_resources_stg (
                                     migration_set_id                 
                                    ,migration_set_name               
                                    ,migration_status                 
                                    ,rbs_header_name                  
                                    ,res_format_name
                                    ,alias
                                    ,leve1_res_name
                                    ,leve2_res_name
                                    ,leve3_res_name
                                    ,resource_class_name
                                    ,spread_curve_name
                                    ,project_number
                                    ,batch_name                       
                                    ,batch_id                         
                                    ,last_updated_by                  
                                    ,created_by                       
                                    ,last_update_login                
                                    ,last_update_date                 
                                    ,creation_date                    
                             )
                           VALUES
                           (
                            pt_i_MigrationSetID
                           ,gvt_MigrationSetName
                           ,'EXTRACTED'
                           ,src_resources_tb(i).rbs_header_name         
                           ,src_resources_tb(i).res_format_name
                           ,src_resources_tb(i).alias
                           ,src_resources_tb(i).level1_res_name    
                           ,src_resources_tb(i).level2_res_name  
                           ,src_resources_tb(i).level3_res_name  
                           ,src_resources_tb(i).resource_class_name 
                           ,src_resources_tb(i).spread_curve_name            
                           ,src_resources_tb(i).project_number              
                           ,g_batch_name    
                           ,to_char(TO_DATE(SYSDATE, 'DD-MON-RRRR'),'DDMMRRRRHHMISS')   
                           ,xxmx_utilities_pkg.gvv_UserName 
                           ,xxmx_utilities_pkg.gvv_UserName
                           ,xxmx_utilities_pkg.gvv_UserName
                           ,SYSDATE                                                     
                           ,SYSDATE                                                     

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
                              ,pt_i_ModuleMessage       => 'Close the Cursor src_resources_cur'
                              ,pt_i_OracleError         => gvt_ReturnMessage       );   
             --


             IF src_resources_cur%ISOPEN
             THEN
                  --
                     CLOSE src_resources_cur;
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
        IF src_resources_cur%ISOPEN
        THEN
            --
            CLOSE src_resources_cur;
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

         IF src_resources_cur%ISOPEN
         THEN
             --
             CLOSE src_resources_cur;
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



     END src_resources;


END XXMX_PPM_PRJ_RBS_PKG;
/