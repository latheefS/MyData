CREATE OR REPLACE PACKAGE XXMX_PPM_PRJ_BILLEVENT_PKG AS 

     --
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
     ** FILENAME  :  xxmx_ppm_prj_billevent_pkg.sql
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
     ** PURPOSE   :  This package contains procedures for extracting Project Billing Events and Cost
     **              into Staging tables
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
     ** PROCEDURE: src_pa_billing_events
     ********************************
     */
     --
      PROCEDURE src_pa_billing_events
                   (pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                  ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE);
     --
     /*
     ********************************
     ** PROCEDURE: src_pa_misc_costs
     ********************************
     */
     --

      PROCEDURE  src_pa_misc_costs     
                  (pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                  ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE);

     --
     /*
     ********************************
     ** PROCEDURE: src_pa_sup_costs
     ********************************
     */
     --

      PROCEDURE src_pa_sup_costs
                     (pt_i_MigrationSetID              IN      xxmx_migration_headers.migration_set_id%TYPE
                     ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE);
     --
     /*
     ********************************
     ** PROCEDURE: src_pa_nonlbr_costs
     ********************************
     */
     --

      PROCEDURE src_pa_nonlbr_costs
                     (pt_i_MigrationSetID              IN      xxmx_migration_headers.migration_set_id%TYPE
                     ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE);
     --
     /*
     ********************************
     ** PROCEDURE: src_pa_lbr_costs
     ********************************
     */
     --

      PROCEDURE src_pa_lbr_costs
                     (pt_i_MigrationSetID              IN      xxmx_migration_headers.migration_set_id%TYPE
                     ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE);                     


END XXMX_PPM_PRJ_BILLEVENT_PKG;
/


CREATE OR REPLACE PACKAGE BODY XXMX_PPM_PRJ_BILLEVENT_PKG AS 
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
--** FILENAME  :  XXMX_PPM_PRJ_BILLEVENT_PKG.pkb
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
--** PURPOSE   :  This package contains procedures for extracting Purchase Order 
--**              into Staging tables
--*****************************************************************************
--**   Vsn  Change Date  Changed By          Change Description
--** -----  -----------  ------------------  ----------------------------------
--**   1.0  23-OCT-2021  Pallavi Kanajar      Created for Maximise.
--**
--***************************************************************************************

    gvv_ReturnStatus                          VARCHAR2(1); 
    gvt_ReturnMessage                         xxmx_module_messages.module_message%TYPE;
    gvv_ProgressIndicator                     VARCHAR2(100); 
    gcv_PackageName                           CONSTANT  VARCHAR2(30)                                := 'XXMX_PPM_PRJ_BILLEVENT_PKG';
    gct_ApplicationSuite                      CONSTANT  xxmx_module_messages.application_suite%TYPE := 'PPM';
    gct_Application                           CONSTANT  xxmx_module_messages.application%TYPE       := 'PRJ';
    gv_i_BusinessEntity                                 VARCHAR2(100)                               := 'PRJ_EVENTS';
    gvt_migrationsetname                                VARCHAR2(100);
    ct_Phase                                  CONSTANT  xxmx_module_messages.phase%TYPE             := 'EXTRACT';
    cv_i_BusinessEntityLevel                  CONSTANT  VARCHAR2(100)                               := 'ALL';
    g_batch_name                              CONSTANT  VARCHAR2(300)                               := 'BE_'||to_char(TO_DATE(SYSDATE, 'DD-MON-RRRR'),'DDMMRRRRHHMISS') ;
    gv_hr_date					                             DATE                                        := '31-DEC-4712';
    gct_stgschema                                       VARCHAR2(10)                                := 'xxmx_stg';

    gvt_Severity                              xxmx_module_messages.severity%TYPE;
    gvt_ModuleMessage                         xxmx_module_messages.module_message%TYPE;
    gvt_OracleError                           xxmx_module_messages.oracle_error%TYPE;

    e_moduleerror                             EXCEPTION;
    e_dateerror                               EXCEPTION;
    gvv_migration_date                        VARCHAR2(30); 
    gvd_migration_date                        DATE;
    gvn_RowCount                              NUMBER;
    gvv_migration_date_to                     VARCHAR2(30); 
    gvv_migration_date_from                   VARCHAR2(30); 
    gvv_prev_tax_year_date                    VARCHAR2(30);         
    gvd_migration_date_to                     DATE;  
    gvd_migration_date_from                   DATE;
    gvd_prev_tax_year_date                    DATE;
    gvv_cost_ext_type                         VARCHAR2(30);



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
         AND   Business_entity IN('PRJ_COST','PRJ_BILL_EVNT')
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
                   gv_i_BusinessEntity:= METADATA_REC.business_entity;

                    lv_sql:= 'BEGIN '
                            ||METADATA_REC.Entity_package_name
                            ||'.'||METADATA_REC.Stg_procedure_name
                            ||'('
                            ||vt_MigrationSetID
                            ||','''
                            ||METADATA_REC.sub_entity
                            ||''''||'); END;'
                            ;
                dbms_output.put_line(lv_sql );

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


   --------------------src_pa_billing_events-----------------------
   -- Extracts Project Billing Events from EBS
   ----------------------------------------------------------------


   PROCEDURE src_pa_billing_events
                     (pt_i_MigrationSetID              IN      xxmx_migration_headers.migration_set_id%TYPE
                     ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE)
     AS   

          --
          --**********************
          --** Cursor Declarations
          --**********************
          --
          CURSOR src_pa_billing_events_cur
         IS
        SELECT
                 NULL                  EXTRACT_REF
                ,SYSDATE               DATE_EXTRACTED
                ,ROWNUM                EXTRACT_ROW_NUMBER
                ,src.SOURCENAME
                ,src.SOURCEREF
                ,src.ORGANIZATION_NAME
                ,src.CONTRACT_TYPE_NAME
                ,src.CONTRACT_NUMBER
                ,src.CONTRACT_LINE_NUMBER
                ,src.EVENT_TYPE_NAME
                ,src.EVENT_DESC
                ,src.COMPLETION_DATE
                ,src.BILL_TRNS_CURRENCY_CODE
                ,src.BILL_TRNS_AMOUNT
                ,src.PROJECT_NUMBER
                ,src.TASK_NUMBER
                ,src.BILL_HOLD_FLAG
                ,src.REVENUE_HOLD_FLAG
                ,src.ATTRIBUTE_CATEGORY
                ,src.ATTRIBUTE1
                ,src.ATTRIBUTE2
                ,src.ATTRIBUTE3
                ,src.ATTRIBUTE4
                ,src.ATTRIBUTE5
                ,src.ATTRIBUTE6
                ,src.ATTRIBUTE7
                ,src.ATTRIBUTE8
                ,src.ATTRIBUTE9
                ,src.ATTRIBUTE10
                ,PROJECT_CURRENCY_CODE
                ,PROJECT_BILL_AMOUNT
                ,PROJFUNC_CURRENCY_CODE
                ,PROJFUNC_BILL_AMOUNT
            FROM (
                            --REVENUE EVENTS-PROJECT LEVEL
               SELECT DISTINCT
                     NULL                                                                SOURCENAME
                    ,ppa.segment1 ||'-'||'DM2020'                                  SOURCEREF
                    --   ,haou.name                                                      ORGANIZATION_NAME
                    ,NULL                                                                 ORGANIZATION_NAME
                    -- ,'Sell: Project Contract Type'                                    CONTRACT_TYPE_NAME
                    ,NULL                                                                CONTRACT_TYPE_NAME
                    ,NULL                                                                CONTRACT_NUMBER
                    ,NULL                                                                CONTRACT_LINE_NUMBER --Need to map(CL) Contract line number from lookup
                    ,'Revenue - Data Migration'							   				 EVENT_TYPE_NAME
                    ,ppa.segment1 ||'-'||'DM2020'||'-'||'Revenue'                  EVENT_DESC
                    --,'30-SEP-20'                                                       COMPLETION_DATE   --TBD
                    ,last_day(sysdate)                                                   COMPLETION_DATE   --TBD
                    ,'GBP'                                                               BILL_TRNS_CURRENCY_CODE
                    ,nvl(SUM(pdri.projfunc_revenue_amount),0)                            BILL_TRNS_AMOUNT
                    ,ppa.segment1                                                  PROJECT_NUMBER
                    ,ppa.segment1 ||'-'||'DM2020'                                  TASK_NUMBER
                    ,'N'                                                                 BILL_HOLD_FLAG
                    ,'N'                                                                 REVENUE_HOLD_FLAG
                    ,NULL                                                                ATTRIBUTE_CATEGORY
                    ,NULL                                                                ATTRIBUTE1
                    ,NULL                                                                ATTRIBUTE2
                    ,NULL                                                                ATTRIBUTE3
                    ,NULL                                                                ATTRIBUTE4
                    ,NULL                                                                ATTRIBUTE5
                    ,NULL                                                                ATTRIBUTE6
                    ,NULL                                                                ATTRIBUTE7
                    ,NULL                                                                ATTRIBUTE8
                    ,NULL                                                                ATTRIBUTE9
                    ,NULL                                                                ATTRIBUTE10
                    ,'GBP'                                                               PROJECT_CURRENCY_CODE
                    -- ,nvl(nullif(pe.PROJECT_BILL_AMOUNT,0),pe.bill_trans_bill_amount)               PROJECT_BILL_AMOUNT --PROJECT_REVENUE_AMOUNT
                    ,sum(pdri.PROJECT_REVENUE_AMOUNT)                                PROJECT_BILL_AMOUNT
                    ,'GBP'                                                               PROJFUNC_CURRENCY_CODE
                    ,sum(pdri.PROJFUNC_REVENUE_AMOUNT)                              PROJFUNC_BILL_AMOUNT
                    --            ,ppa.project_id
                    FROM
                        pa_draft_revenue_items@MXDM_NVIS_EXTRACT pdri
                        ,pa_draft_revenues_all@MXDM_NVIS_EXTRACT pdra
                        ,pa_projects_all@MXDM_NVIS_EXTRACT ppa
                       -- ,pfc_ppm_bill_contracts_lookup_p3  contr
                    WHERE
                    pdra.project_id                 = pdri.project_id
                    AND pdri.project_id             = ppa.project_id
                    AND   pdri.draft_revenue_num    = pdra.draft_revenue_num
                    AND   pdra.project_id           = ppa.project_id
                    AND   pdra.transfer_status_code = 'A'
                    --and ppa.Project_number='103990'
                    AND     EXISTS                          ( SELECT 1 
                                                          FROM xxmx_ppm_projects_stg pps 
                                                          WHERE pps.project_id = ppa.project_id
                    --                                                              and pps.flag='N'
                                                         )
                    -- and ppa.Project_number   = contr.project_number(+)
                    --and contr.task_number =  ppa.Project_number||'-'||'DM2020'
                   AND   pdra.gl_period_name IN( SELECT parameter_value
                                                                        from xxmx_migration_parameters
                                                                        where parameter_code  = 'GL_PERIOD_NAME'
                                                                        and application = 'PPM')
                    AND   pdra.gl_date   BETWEEN to_date(gvv_migration_date_from,'DD-MON-RRRR') AND to_date(gvv_migration_date_to,'DD-MON-RRRR')
                    GROUP BY ppa.segment1) src
        ;



        CURSOR src_billing_dtl
        IS

        SELECT
                 NULL                  EXTRACT_REF
                ,SYSDATE               DATE_EXTRACTED
                ,ROWNUM                EXTRACT_ROW_NUMBER
                ,src.SOURCENAME
                ,src.SOURCEREF
                ,src.ORGANIZATION_NAME
                ,src.CONTRACT_TYPE_NAME
                ,src.CONTRACT_NUMBER
                ,src.CONTRACT_LINE_NUMBER
                ,src.EVENT_TYPE_NAME
                ,src.EVENT_DESC
                ,src.COMPLETION_DATE
                ,src.BILL_TRNS_CURRENCY_CODE
                ,src.BILL_TRNS_AMOUNT
                ,src.PROJECT_NUMBER
                ,src.TASK_NUMBER
                ,src.BILL_HOLD_FLAG
                ,src.REVENUE_HOLD_FLAG
                ,src.ATTRIBUTE_CATEGORY
                ,src.ATTRIBUTE1
                ,src.ATTRIBUTE2
                ,src.ATTRIBUTE3
                ,src.ATTRIBUTE4
                ,src.ATTRIBUTE5
                ,src.ATTRIBUTE6
                ,src.ATTRIBUTE7
                ,src.ATTRIBUTE8
                ,src.ATTRIBUTE9
                ,src.ATTRIBUTE10
                ,PROJECT_CURRENCY_CODE
                ,PROJECT_BILL_AMOUNT
                ,PROJFUNC_CURRENCY_CODE
                ,PROJFUNC_BILL_AMOUNT
            FROM (
                --REVENUE EVENTS - TASKS LEVEL
                SELECT DISTINCT
                NULL                                                                  SOURCENAME
                ,pt.task_number                                                       SOURCEREF
                --   ,haou.name                                                      ORGANIZATION_NAME
                ,NULL                                                                ORGANIZATION_NAME
                -- ,'Sell: Project Contract Type'                                    CONTRACT_TYPE_NAME
                ,null                                                               CONTRACT_TYPE_NAME
                ,null                                                               CONTRACT_NUMBER
                ,null                                                               CONTRACT_LINE_NUMBER --Need to map(CL) Contract line number from lookup
                ,'Revenue - Data Migration'							   				 EVENT_TYPE_NAME
                ,ppa.Project_number ||'-'||'DM2021'||'-'||'Revenue'                  EVENT_DESC
                --,'30-SEP-20'                                                       COMPLETION_DATE   --TBD
                ,last_day(sysdate)                                                   COMPLETION_DATE   --TBD
                ,null                                                                BILL_TRNS_CURRENCY_CODE
                ,nvl(SUM(pdri.projfunc_revenue_amount),0)                            BILL_TRNS_AMOUNT
                ,ppa.Project_number                                                  PROJECT_NUMBER
                ,pt.task_number                                                      TASK_NUMBER
                ,NULL                                                                BILL_HOLD_FLAG
                ,NULL                                                                REVENUE_HOLD_FLAG
                --            ,'N'                                                   BILL_HOLD_FLAG
                --            ,'N'                                                   REVENUE_HOLD_FLAG
                ,NULL                                                                ATTRIBUTE_CATEGORY
                ,NULL                                                                ATTRIBUTE1
                ,NULL                                                                ATTRIBUTE2
                ,NULL                                                                ATTRIBUTE3
                ,NULL                                                                ATTRIBUTE4
                ,NULL                                                                ATTRIBUTE5
                ,NULL                                                                ATTRIBUTE6
                ,NULL                                                                ATTRIBUTE7
                ,NULL                                                                ATTRIBUTE8
                ,NULL                                                                ATTRIBUTE9
                ,NULL                                                                ATTRIBUTE10
                ,NULL                                                               PROJECT_CURRENCY_CODE
                --            ,'GBP'                                                               PROJECT_CURRENCY_CODE
                -- ,nvl(nullif(pe.PROJECT_BILL_AMOUNT,0),pe.bill_trans_bill_amount)               PROJECT_BILL_AMOUNT --PROJECT_REVENUE_AMOUNT
                ,sum(pdri.PROJECT_REVENUE_AMOUNT)                                PROJECT_BILL_AMOUNT
                ,NULL                                                            PROJFUNC_CURRENCY_CODE
                --            ,'GBP                                              PROJFUNC_CURRENCY_CODE
                ,sum(pdri.PROJFUNC_REVENUE_AMOUNT)                             PROJFUNC_BILL_AMOUNT
                --            ,ppa.project_id
                FROM
                    apps.pa_draft_revenue_items@MXDM_NVIS_EXTRACT pdri
                    ,apps.pa_draft_revenues_all@MXDM_NVIS_EXTRACT pdra
                    ,xxmx_ppm_projects_stg                        ppa
                    ,apps.pa_tasks@MXDM_NVIS_EXTRACT              pt
                    --                    ,pfc_ppm_bill_contracts_lookup_p3  contr
                    WHERE
                    pdra.project_id                 = pdri.project_id
                    AND pdri.project_id             = pt.project_id
                    AND pdri.task_id                = pt.task_id
                    AND pdri.project_id             = ppa.project_id
                    AND   pdri.draft_revenue_num    = pdra.draft_revenue_num
                    AND   pdra.project_id           = ppa.project_id
                    AND   pdra.transfer_status_code = 'A'
                    --and ppa.Project_number='103990'
                    --and ppa.Project_number                = contr.project_number(+)
                    --                     and contr.task_number =  ppa.Project_number||'-'||'DM2021'

                    AND     EXISTS                          ( SELECT 1 
                                                              FROM xxmx_ppm_projects_stg pps 
                                                              WHERE pps.project_id = ppa.project_id
                    --                                                              and pps.flag='Y'
                                                             )
                   AND   pdra.gl_period_name IN( SELECT parameter_value
                                                                        from xxmx_migration_parameters
                                                                        where parameter_code  = 'GL_PERIOD_NAME'
                                                                        and application = 'PPM')
                    AND  last_day(TO_DATE('01'|| upper(pdra.gl_period_name),'DD-MM-RRRR') ) 
                    BETWEEN TO_DATE(gvv_migration_date_from,'DD-MM-RRRR') AND TO_DATE(gvv_migration_date_to,'DD-MM-RRRR')   
                    GROUP BY ppa.Project_number
                             ,pt.task_number

                      )	 src
                    WHERE src.BILL_TRNS_AMOUNT <> 0;

       --
       --**********************
       --** Record Declarations
       --**********************
       --
        TYPE src_pa_billing_events_tbl IS TABLE OF src_pa_billing_events_cur%ROWTYPE INDEX BY BINARY_INTEGER;
        src_pa_billing_events_tb  src_pa_billing_events_tbl;


       --
       --************************
       --** Constant Declarations
       --************************
       --
        cv_ProcOrFuncName                   CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'src_pa_billing_events';
        cv_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_PPM_PRJ_BILLEVENT_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'BILLING_EVENTS';


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
         gvv_migration_date_from := xxmx_utilities_pkg.get_single_parameter_value(
                        pt_i_ApplicationSuite           =>     gct_ApplicationSuite
                        ,pt_i_Application                =>     gct_Application
                        ,pt_i_BusinessEntity             =>     'ALL'
                        ,pt_i_SubEntity                  =>     'ALL'
                        ,pt_i_ParameterCode              =>     'EXTRACT_START_DATE'
        );        
        --gvd_migration_date_from := TO_DATE(gvv_migration_date_from,'DD-MON-RRRR');


        gvv_migration_date_to := xxmx_utilities_pkg.get_single_parameter_value(
                        pt_i_ApplicationSuite           =>     gct_ApplicationSuite
                        ,pt_i_Application                =>     gct_Application
                        ,pt_i_BusinessEntity             =>     'ALL'
                        ,pt_i_SubEntity                  =>     'ALL'
                        ,pt_i_ParameterCode              =>     'EXTRACT_END_DATE'
        );        
        --gvd_migration_date_to := TO_DATE(gvv_migration_date_to,'DD-MON-RRRR');

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
                ,pt_i_ModuleMessage       => 'Prameters for extract' || gvv_migration_date_from   || '  '||gvv_migration_date_to
                ,pt_i_OracleError         => gvt_ReturnMessage  );

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
        FROM    xxmx_ppm_prj_billevent_stg ;

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


            OPEN src_pa_billing_events_cur;
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
                   ,pt_i_ModuleMessage       =>'Cursor Open src_pa_billing_events_cur'
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
                   ,pt_i_ModuleMessage       =>'Inside the Cursor loop'
                   ,pt_i_OracleError         => gvt_ReturnMessage  );

            --
            FETCH src_pa_billing_events_cur  BULK COLLECT INTO src_pa_billing_events_tb LIMIT 1000;
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
                   ,pt_i_ModuleMessage       => 'Cursor src_pa_billing_events_cur Fetch into src_pa_billing_events_tb'
                   ,pt_i_OracleError         => gvt_ReturnMessage  );
            --
            EXIT WHEN src_pa_billing_events_tb.COUNT=0;
            --
            FORALL I IN 1..src_pa_billing_events_tb.COUNT SAVE EXCEPTIONS
            --
                 INSERT INTO xxmx_ppm_prj_billevent_stg (
                                     migration_set_id                 
                                    ,migration_set_name               
                                    ,migration_status                 
                                    ,sourcename                 
                                         , sourceref                  
                                         , organization_name          
                                         , contract_type
                                         , contract_number            
                                         , contract_line_number       
                                         , event_type            
                                         , event_description               
                                         , event_completion_date            
                                         , bill_trns_currency_code    
                                         , bill_trns_amount           
                                         , project_number             
                                         , task_number                
                                         , bill_hold_flag             
                                         , revenue_hold_flag          
                                         , attribute_category         
                                         , attribute1                 
                                         , attribute2                 
                                         , attribute3                 
                                         , attribute4                 
                                         , attribute5                 
                                         , attribute6                 
                                         , attribute7                 
                                         , attribute8                 
                                         , attribute9                 
                                         , attribute10	             
                                       --  ,project_currency_code
                                       --  ,project_bill_amount
                                       --  ,projfunc_currency_code
                                       --  ,projfunc_bill_amount
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
                            ,src_pa_billing_events_tb(i).sourcename                 
                            ,src_pa_billing_events_tb(i).sourceref                  
                            ,src_pa_billing_events_tb(i).organization_name          
                            ,src_pa_billing_events_tb(i).contract_type_name         
                            ,src_pa_billing_events_tb(i).contract_number            
                            ,src_pa_billing_events_tb(i).contract_line_number       
                            ,src_pa_billing_events_tb(i).event_type_name            
                            ,src_pa_billing_events_tb(i).event_desc                 
                            ,src_pa_billing_events_tb(i).completion_date            
                            ,src_pa_billing_events_tb(i).bill_trns_currency_code    
                            ,src_pa_billing_events_tb(i).bill_trns_amount           
                            ,src_pa_billing_events_tb(i).project_number             
                            ,src_pa_billing_events_tb(i).task_number                
                            ,src_pa_billing_events_tb(i).bill_hold_flag             
                            ,src_pa_billing_events_tb(i).revenue_hold_flag          
                            ,src_pa_billing_events_tb(i).attribute_category         
                            ,src_pa_billing_events_tb(i).attribute1                 
                            ,src_pa_billing_events_tb(i).attribute2                 
                            ,src_pa_billing_events_tb(i).attribute3                 
                            ,src_pa_billing_events_tb(i).attribute4                 
                            ,src_pa_billing_events_tb(i).attribute5                 
                            ,src_pa_billing_events_tb(i).attribute6                 
                            ,src_pa_billing_events_tb(i).attribute7                 
                            ,src_pa_billing_events_tb(i).attribute8                 
                            ,src_pa_billing_events_tb(i).attribute9                 
                            ,src_pa_billing_events_tb(i).attribute10	             
                            --,src_pa_billing_events_tb(i).PROJECT_CURRENCY_CODE
                            --,src_pa_billing_events_tb(i).PROJECT_BILL_AMOUNT
                            --,src_pa_billing_events_tb(i).PROJFUNC_CURRENCY_CODE
                            --,src_pa_billing_events_tb(i).PROJFUNC_BILL_AMOUNT                            
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
                              ,pt_i_ModuleMessage       => 'Close the Cursor src_pa_billing_events_cur'
                              ,pt_i_OracleError         => gvt_ReturnMessage       );   
             --


             IF src_pa_billing_events_cur%ISOPEN
             THEN
                  --
                     CLOSE src_pa_billing_events_cur;
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
        IF src_pa_billing_events_cur%ISOPEN
        THEN
            --
            CLOSE src_pa_billing_events_cur;
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

         IF src_pa_billing_events_cur%ISOPEN
         THEN
             --
             CLOSE src_pa_billing_events_cur;
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



     END src_pa_billing_events;




   /*********************************************************
   --------------------src_pa_misc_cost-----------------------
   -- Extracts Project Misc Cost from EBS
   ----------------------------------------------------------
   **********************************************************/

   PROCEDURE src_pa_misc_costs
                     (pt_i_MigrationSetID              IN      xxmx_migration_headers.migration_set_id%TYPE
                     ,pt_i_SubEntity                   IN      xxmx_migration_metadata.sub_entity%TYPE)
     AS   

          --
          --**********************
          --** Cursor Declarations
          --**********************
          --
            CURSOR pa_costs_cur
            IS
            select       
                Transaction_type --  LABOR, NONLABOR
                ,business_unit --Nullify we consider BU based on Project Number
                ,org_id
                ,user_transaction_source
                ,transaction_source_id
                ,document_name
                ,document_id
                ,doc_entry_name
                ,doc_entry_id
                ,exp_batch_name
                ,batch_ending_date
                ,batch_description
                ,expenditure_item_date
                ,person_number
                ,person_name
                ,person_id
                ,hcm_assignment_name
                ,hcm_assignment_id
                ,project_number
                ,project_name
                ,project_id
                ,task_number
                ,task_name
                ,task_id
                ,expenditure_type
                ,expenditure_type_id
                ,organization_name                                                               --Organization_name
                ,organization_id
                ,non_labor_resource
                ,non_labor_resource_id
                ,non_labor_resource_org
                ,non_labor_resource_org_id
                ,quantity            
                ,unit_of_measure_name
                ,unit_of_measure
                ,work_type
                ,work_type_id
                ,billable_flag
                ,capitalizable_flag
                ,accrual_flag
                ,supplier_number
                ,supplier_name
                ,vendor_id
                ,inventory_item_name
                ,inventory_item_id
                ,orig_transaction_reference
                ,unmatched_negative_txn_flag
                ,reversed_orig_txn_reference
                ,expenditure_comment
                ,gl_date
                ,denom_currency_code
                ,denom_currency
                ,sum(denom_raw_cost)        AS denom_raw_cost                                          --denom_raw_cost
                ,sum(denom_burdened_cost)   AS denom_burdened_cost                                --denom_burdened_cost
                ,raw_cost_cr_ccid
                ,raw_cost_cr_account
                ,raw_cost_dr_ccid
                ,raw_cost_dr_account
                ,burdened_cost_cr_ccid
                ,burdened_cost_cr_account
                ,burdened_cost_dr_ccid
                ,burdened_cost_dr_account
                ,burden_cost_cr_ccid
                ,burden_cost_cr_account
                ,burden_cost_dr_ccid
                ,burden_cost_dr_account
                ,acct_currency_code
                ,acct_currency
                ,sum(acct_raw_cost)             AS acct_raw_cost -- based on UAT recon from business recon report
                ,sum(acct_burdened_cost)        AS acct_burdened_cost
                ,acct_rate_type 
                ,acct_rate_date
                ,acct_rate_date_type
                ,acct_exchange_rate
                ,acct_exchange_rounding_limit
                ,receipt_currency_code
                ,receipt_currency
                ,receipt_currency_amount
                ,receipt_exchange_rate
                ,converted_flag
                ,context_category
                ,user_def_attribute1
                ,user_def_attribute2
                ,user_def_attribute3
                ,user_def_attribute4
                ,user_def_attribute5
                ,user_def_attribute6
                ,user_def_attribute7
                ,user_def_attribute8
                ,user_def_attribute9
                ,user_def_attribute10
                ,reserved_attribute1
                ,reserved_attribute2
                ,reserved_attribute3
                ,reserved_attribute4
                ,reserved_attribute5
                ,reserved_attribute6
                ,reserved_attribute7
                ,reserved_attribute8
                ,reserved_attribute9
                ,reserved_attribute10
                ,attribute_category
                ,attribute1
                ,attribute2
                ,attribute3
                ,attribute4
                ,attribute5
                ,attribute6
                ,attribute7
                ,attribute9
                ,attribute8
                ,attribute10 -- to split costs Labor, NonLabor and Misc in EDQ
                ,contract_number
                ,contract_name
                ,contract_id
                ,funding_source_number
                ,funding_source_name
          from
        (SELECT distinct 
             NULL                                                                             AS transaction_type --  LABOR, NONLABOR
            ,haou1.name                                                                       AS business_unit --Nullify as we consider BU based on Project Number
            ,NULL                                                                             AS org_id
            ,null                                                                             AS user_transaction_source
            ,NULL                                                                             AS transaction_source_id
            ,NULL                                                                             AS document_name
            ,NULL                                                                             AS document_id
            ,NULL                                                                             AS doc_entry_name
            ,NULL                                                                             AS doc_entry_id
            ,NULL                                                                             AS exp_batch_name
            ,NULL                                                                             AS batch_ending_date
            ,NULL                                                                             AS batch_description
            ,NULL                                                                             AS expenditure_item_date
            ,NULL                                                                             AS person_number
            ,NULL                                                                             AS person_name
            ,NULL                                                                             AS person_id
            ,NULL                                                                             AS hcm_assignment_name
            ,NULL                                                                             As hcm_assignment_id
            ,ppa.project_number                                                               AS project_number
            ,ppa.project_name                                                                 AS project_name
            ,ppa.project_id                                                                   AS project_id
            ,NULL                                                                             AS task_number
            ,NULL                                                                             AS task_name
            ,NULL                                                                             AS task_id
            ,peia.expenditure_type                                                            AS expenditure_type
            ,NULL                                                                             AS expenditure_type_id
            ,(select haou2.name 
                from apps.hr_all_organization_units@MXDM_NVIS_EXTRACT haou2 
                     ,apps.pa_expenditures_all@MXDM_NVIS_EXTRACT pea1
                where haou2.organization_id= NVL (peia.override_to_organization_id, pea1.incurred_by_organization_id)
                and peia.expenditure_id = pea1.expenditure_id)                                AS organization_name  
            ,NULL                                                                             AS organization_id
            ,peia.non_labor_resource                                                          AS non_labor_resource
            ,NULL                                                                             AS non_labor_resource_id
            ,NULL                                                                             AS non_labor_resource_org
            ,NULL                                                                             AS non_labor_resource_org_id
            ,peia.quantity                                                                    AS quantity            
            ,NULL                                                                             AS unit_of_measure_name
            ,peia.unit_of_measure                                                             AS unit_of_measure
            ,NULL                                                                             AS work_type
            ,NULL                                                                             AS work_type_id
            ,NULL                                                                             AS billable_flag
            ,NULL                                                                             AS capitalizable_flag
            ,NULL                                                                             AS accrual_flag
            ,NULL                                                                             As supplier_number
            ,NULL                                                                             AS supplier_name
            ,NULL                                                                             AS vendor_id
            ,NULL                                                                             As inventory_item_name
            ,NULL                                                                             AS inventory_item_id
            ,NULL                                                                             AS orig_transaction_reference
            ,NULL                                                                             AS unmatched_negative_txn_flag
            ,NULL                                                                             AS reversed_orig_txn_reference
            ,NULL                                                                             AS expenditure_comment
            ,NULL                                                                             AS gl_date
            ,pcdla.denom_currency_code                                                        AS denom_currency_code
            ,NULL                                                                             AS denom_currency
            ,pcdla.denom_raw_cost                                                             AS denom_raw_cost
            ,peia.denom_burdened_cost                                                         AS denom_burdened_cost
            ,NULL                                                                             AS raw_cost_cr_ccid
            ,NULL                                                                             AS raw_cost_cr_account
            ,NULL                                                                             AS raw_cost_dr_ccid
            ,NULL                                                                             AS raw_cost_dr_account
            ,NULL                                                                             AS burdened_cost_cr_ccid
            ,NULL                                                                             AS burdened_cost_cr_account
            ,NULL                                                                             AS burdened_cost_dr_ccid
            ,NULL                                                                             AS burdened_cost_dr_account
            ,NULL                                                                             AS burden_cost_cr_ccid
            ,NULL                                                                             AS burden_cost_cr_account
            ,NULL                                                                             AS burden_cost_dr_ccid
            ,NULL                                                                             AS burden_cost_dr_account
            ,peia.acct_currency_code                                                          AS acct_currency_code
            ,NULL                                                                             AS acct_currency
            ,pcdla.acct_raw_cost                                                              AS acct_raw_cost  -- based on UAT recon from business recon report
            ,peia.acct_burdened_cost                                                          AS acct_burdened_cost
            ,peia.acct_rate_type                                                              AS acct_rate_type 
            ,peia.acct_rate_date                                                              AS acct_rate_date
            ,NULL                                                                             AS acct_rate_date_type
            ,peia.acct_exchange_rate                                                          AS acct_exchange_rate
            ,NULL                                                                             AS acct_exchange_rounding_limit
            ,NULL                                                                             AS receipt_currency_code
            ,NULL                                                                             AS receipt_currency
            ,NULL                                                                             AS receipt_currency_amount
            ,NULL                                                                             AS receipt_exchange_rate
            ,peia.converted_flag                                                              AS converted_flag
            ,NULL                                                                             As context_category
            ,NULL                                                                             AS user_def_attribute1
            ,NULL                                                                             AS user_def_attribute2
            ,NULL                                                                             AS user_def_attribute3
            ,NULL                                                                             AS user_def_attribute4
            ,NULL                                                                             AS user_def_attribute5
            ,NULL                                                                             AS user_def_attribute6
            ,NULL                                                                             AS user_def_attribute7
            ,NULL                                                                             AS user_def_attribute8
            ,NULL                                                                             AS user_def_attribute9
            ,NULL                                                                             AS user_def_attribute10
            ,NULL                                                                             As reserved_attribute1
            ,NULL                                                                             AS reserved_attribute2
            ,NULL                                                                             AS reserved_attribute3
            ,NULL                                                                             AS reserved_attribute4
            ,NULL                                                                             AS reserved_attribute5
            ,NULL                                                                             AS reserved_attribute6
            ,NULL                                                                             AS reserved_attribute7
            ,NULL                                                                             AS reserved_attribute8
            ,NULL                                                                             AS reserved_attribute9
            ,NULL                                                                             AS reserved_attribute10
            ,NULL                                                                             AS attribute_category
            ,NULL                                                                             AS attribute1
            ,NULL                                                                             AS attribute2
            ,NULL                                                                             AS attribute3
            ,NULL                                                                             AS attribute4
            ,NULL                                                                             AS attribute5
            ,NULL                                                                             AS attribute6
            ,NULL                                                                             AS attribute7
            ,NULL                                                                             AS attribute9
            ,NULL                                                                             AS attribute8
            ,null                                                                             AS attribute10 -- to split costs Labor, NonLabor and Misc in EDQ
            ,NULL                                                                             AS contract_number
            ,NULL                                                                             AS contract_name
            ,NULL                                                                             AS contract_id
            ,NULL                                                                             AS funding_source_number
            ,NULL                                                                             AS funding_source_name
            FROM  xxmx_ppm_projects_stg                                    ppa
                 ,apps.pa_expenditure_items_all@MXDM_NVIS_EXTRACT          peia
                 ,apps.hr_all_organization_units@MXDM_NVIS_EXTRACT         haou1
                 ,apps.pa_cost_distribution_lines_all@MXDM_NVIS_EXTRACT    pcdla
            WHERE ppa.project_id                    = peia.project_id
            AND pcdla.expenditure_item_id         = peia.expenditure_item_id
            AND pcdla.project_id                  = peia.project_id
            AND peia.org_id                       = haou1.organization_id
            AND  gl_date   BETWEEN TO_DATE(gvv_migration_date_from,'DD-MM-RRRR') AND TO_DATE(gvv_migration_date_to,'DD-MM-RRRR')
            AND system_linkage_function in (select parameter_value
                                                  from xxmx_migration_parameters
                                                  where application= 'PPM'
                                                  and application_suite= 'FIN'
                                                  and parameter_code = 'EXP_SYSTEM_LINK_TYPE'
                                                  and sub_entity = 'MISC_COSTS'
                                                  and enabled_flag = 'Y'
                                                  ) 

            ) src
             GROUP BY
                 Transaction_type --  LABOR, NONLABOR
                ,business_unit --Nullify we consider BU based on Project Number
                ,org_id
                ,user_transaction_source
                ,transaction_source_id
                ,document_name
                ,document_id
                ,doc_entry_name
                ,doc_entry_id
                ,exp_batch_name
                ,batch_ending_date
                ,batch_description
                ,expenditure_item_date
                ,person_number
                ,person_name
                ,person_id
                ,hcm_assignment_name
                ,hcm_assignment_id
                ,project_number
                ,project_name
                ,project_id
                ,task_number
                ,task_name
                ,task_id
                ,expenditure_type
                ,expenditure_type_id
                ,organization_name                                                               --Organization_name
                ,organization_id
                ,non_labor_resource
                ,non_labor_resource_id
                ,non_labor_resource_org
                ,non_labor_resource_org_id
                ,quantity            
                ,unit_of_measure_name
                ,unit_of_measure
                ,work_type
                ,work_type_id
                ,billable_flag
                ,capitalizable_flag
                ,accrual_flag
                ,supplier_number
                ,supplier_name
                ,vendor_id
                ,inventory_item_name
                ,inventory_item_id
                ,orig_transaction_reference
                ,unmatched_negative_txn_flag
                ,reversed_orig_txn_reference
                ,expenditure_comment
                ,gl_date
                ,denom_currency_code
                ,denom_currency
                ,raw_cost_cr_ccid
                ,raw_cost_cr_account
                ,raw_cost_dr_ccid
                ,raw_cost_dr_account
                ,burdened_cost_cr_ccid
                ,burdened_cost_cr_account
                ,burdened_cost_dr_ccid
                ,burdened_cost_dr_account
                ,burden_cost_cr_ccid
                ,burden_cost_cr_account
                ,burden_cost_dr_ccid
                ,burden_cost_dr_account
                ,acct_currency_code
                ,acct_currency
                ,acct_rate_type 
                ,acct_rate_date
                ,acct_rate_date_type
                ,acct_exchange_rate
                ,acct_exchange_rounding_limit
                ,receipt_currency_code
                ,receipt_currency
                ,receipt_currency_amount
                ,receipt_exchange_rate
                ,converted_flag
                ,context_category
                ,user_def_attribute1
                ,user_def_attribute2
                ,user_def_attribute3
                ,user_def_attribute4
                ,user_def_attribute5
                ,user_def_attribute6
                ,user_def_attribute7
                ,user_def_attribute8
                ,user_def_attribute9
                ,user_def_attribute10
                ,reserved_attribute1
                ,reserved_attribute2
                ,reserved_attribute3
                ,reserved_attribute4
                ,reserved_attribute5
                ,reserved_attribute6
                ,reserved_attribute7
                ,reserved_attribute8
                ,reserved_attribute9
                ,reserved_attribute10
                ,attribute_category
                ,attribute1
                ,attribute2
                ,attribute3
                ,attribute4
                ,attribute5
                ,attribute6
                ,attribute7
                ,attribute9
                ,attribute8
                ,attribute10 -- to split costs Labor, NonLabor and Misc in EDQ
                ,contract_number
                ,contract_name
                ,contract_id
                ,funding_source_number
                ,funding_source_name   
                  ;


        CURSOR src_pa_cost_dtl
        IS
             select  Transaction_type --  LABOR, NONLABOR
                ,business_unit --Nullify we consider BU based on Project Number
                ,org_id
                ,user_transaction_source
                ,transaction_source_id
                ,document_name
                ,document_id
                ,doc_entry_name
                ,doc_entry_id
                ,exp_batch_name
                ,batch_ending_date
                ,batch_description
                ,expenditure_item_date
                ,person_number
                ,person_name
                ,person_id
                ,hcm_assignment_name
                ,hcm_assignment_id
                ,project_number
                ,project_name
                ,project_id
                ,task_number
                ,task_name
                ,task_id
                ,expenditure_type
                ,expenditure_type_id
                ,organization_name                                                               --Organization_name
                ,organization_id
                ,non_labor_resource
                ,non_labor_resource_id
                ,non_labor_resource_org
                ,non_labor_resource_org_id
                ,quantity            
                ,unit_of_measure_name
                ,unit_of_measure
                ,work_type
                ,work_type_id
                ,billable_flag
                ,capitalizable_flag
                ,accrual_flag
                ,supplier_number
                ,supplier_name
                ,vendor_id
                ,inventory_item_name
                ,inventory_item_id
                ,orig_transaction_reference
                ,unmatched_negative_txn_flag
                ,reversed_orig_txn_reference
                ,expenditure_comment
                ,gl_date
                ,denom_currency_code
                ,denom_currency
                ,sum(denom_raw_cost)        AS denom_raw_cost                                          --denom_raw_cost
                ,sum(denom_burdened_cost)   AS denom_burdened_cost                                --denom_burdened_cost
                ,raw_cost_cr_ccid
                ,raw_cost_cr_account
                ,raw_cost_dr_ccid
                ,raw_cost_dr_account
                ,burdened_cost_cr_ccid
                ,burdened_cost_cr_account
                ,burdened_cost_dr_ccid
                ,burdened_cost_dr_account
                ,burden_cost_cr_ccid
                ,burden_cost_cr_account
                ,burden_cost_dr_ccid
                ,burden_cost_dr_account
                ,acct_currency_code
                ,acct_currency
                ,sum(acct_raw_cost)             AS acct_raw_cost -- based on UAT recon from business recon report
                ,sum(acct_burdened_cost)        AS acct_burdened_cost
                ,acct_rate_type 
                ,acct_rate_date
                ,acct_rate_date_type
                ,acct_exchange_rate
                ,acct_exchange_rounding_limit
                ,receipt_currency_code
                ,receipt_currency
                ,receipt_currency_amount
                ,receipt_exchange_rate
                ,converted_flag
                ,context_category
                ,user_def_attribute1
                ,user_def_attribute2
                ,user_def_attribute3
                ,user_def_attribute4
                ,user_def_attribute5
                ,user_def_attribute6
                ,user_def_attribute7
                ,user_def_attribute8
                ,user_def_attribute9
                ,user_def_attribute10
                ,reserved_attribute1
                ,reserved_attribute2
                ,reserved_attribute3
                ,reserved_attribute4
                ,reserved_attribute5
                ,reserved_attribute6
                ,reserved_attribute7
                ,reserved_attribute8
                ,reserved_attribute9
                ,reserved_attribute10
                ,attribute_category
                ,attribute1
                ,attribute2
                ,attribute3
                ,attribute4
                ,attribute5
                ,attribute6
                ,attribute7
                ,attribute9
                ,attribute8
                ,attribute10 -- to split costs Labor, NonLabor and Misc in EDQ
                ,contract_number
                ,contract_name
                ,contract_id
                ,funding_source_number
                ,funding_source_name                                                                                                          funding_source_name
           from(SELECT 
            NULL                                                                                                             transaction_type --  LABOR, NONLABOR
            ,haou1.name                                                                                                        business_unit --Nullify as we consider BU based on Project Number
            ,NULL                                                                                                             org_id
            ,null                                                                                                             user_transaction_source
            ,NULL                                                                                                             transaction_source_id
            ,NULL                                                                                                             document_name
            ,NULL                                                                                                             document_id
            ,NULL                                                                                                             doc_entry_name
            ,NULL                                                                                                             doc_entry_id
            --  'Data Migration'                                                                                              exp_batch_name
            ,(SELECT pea.expenditure_group
              FROM apps.pa_expenditures_all@MXDM_NVIS_EXTRACT pea
              WHERE peia.expenditure_id = pea.expenditure_id)                                                                 exp_batch_name
            ,(SELECT pea.expenditure_ending_date
              FROM apps.pa_expenditures_all@MXDM_NVIS_EXTRACT pea
              WHERE peia.expenditure_id = pea.expenditure_id)                                                                 batch_ending_date
            ,(SELECT pea.description
              FROM apps.pa_expenditures_all@MXDM_NVIS_EXTRACT pea
              WHERE peia.expenditure_id = pea.expenditure_id)                                                                 batch_description
            ,peia.expenditure_item_date                                                                                       expenditure_item_date
            ,NULL                                                                                                             person_number
            ,NULL                                                                                                             person_name
            ,NULL                                                                                                             person_id
            ,NULL                                                                                                             hcm_assignment_name
            ,NULL                                                                                                             hcm_assignment_id
            ,ppa.project_number                                                                                               project_number
            ,ppa.project_name                                                                                                 project_name
            ,NULL                                                                                                             project_id
            ,pt.task_number                                                                                                   task_number
            ,pt.task_name                                                                                                     task_name
            --,ppa.segment1||'-'||'DM2020'                                                                                    task_number
            --,ppa.segment1||'-'||'DM2020'                                                                                                     task_name
            ,NULL                                                                                                             task_id
            ,peia.expenditure_type                                                                                            expenditure_type
            ,NULL                                                                                                             expenditure_type_id
            ,(select haou2.name 
                from apps.hr_all_organization_units@MXDM_NVIS_EXTRACT haou2 
                     ,apps.pa_expenditures_all@MXDM_NVIS_EXTRACT pea1
                where haou2.organization_id= NVL (peia.override_to_organization_id, pea1.incurred_by_organization_id)
                  and peia.expenditure_id = pea1.expenditure_id)                                                               organization_name

            ,NULL                                                                                                             organization_id -- POO from Project Number Mapped in EDQ
            ,peia.non_labor_resource                                                                                          non_labor_resource
            ,NULL                                                                                                             non_labor_resource_id
            ,null                                                                                                             non_labor_resource_org
            ,NULL                                                                                                             non_labor_resource_org_id
            ,peia.quantity                                                                                                    quantity
            ,NULL                                                                                                             unit_of_measure_name
            ,peia.unit_of_measure                                                                                             unit_of_measure
            ,(SELECT name
              FROM   apps.pa_work_types_tl@MXDM_NVIS_EXTRACT pwtt--apps.PA_TASKS_V@MXDM_NVIS_EXTRACT
              WHERE  peia.work_type_id=pwtt.work_type_id)                                                                     work_type
            ,NULL                                                                                                             work_type_id
            ,peia.billable_flag                                                                                               billable_flag
            ,NULL                                                                                                             capitalizable_flag
            ,NULL                                                                                                             accrual_flag
            ,NULL                                                                                                             supplier_number
            ,NULL                                                                                                             supplier_name
            ,NULL                                                                                                             vendor_id
            ,NULL                                                                                                             inventory_item_name
            ,NULL                                                                                                             inventory_item_id
            ,ppa.project_number||'-'||'DM2020'                                                                                orig_transaction_reference
            ,NULL                                                                                                             unmatched_negative_txn_flag
            ,NULL                                                                                                             reversed_orig_txn_reference
            ,NULL                                                                                                             expenditure_comment
            ,pcdla.gl_date                                                                                                    gl_date
            ,pcdla.denom_currency_code                                                                                         denom_currency_code
            ,NULL                                                                                                             denom_currency
            ,pcdla.denom_raw_cost                                                                                              denom_raw_cost
            ,peia.denom_burdened_cost                                                                                         denom_burdened_cost
            ,NULL                                                                                                             raw_cost_cr_ccid
            ,NULL                                                                                                             raw_cost_cr_account
            ,NULL                                                                                                             raw_cost_dr_ccid
            ,NULL                                                                                                             raw_cost_dr_account
            ,NULL                                                                                                             burdened_cost_cr_ccid
            ,NULL                                                                                                             burdened_cost_cr_account
            ,NULL                                                                                                             burdened_cost_dr_ccid
            ,NULL                                                                                                             burdened_cost_dr_account
            ,NULL                                                                                                             burden_cost_cr_ccid
            ,NULL                                                                                                             burden_cost_cr_account
            ,NULL                                                                                                             burden_cost_dr_ccid
            ,NULL                                                                                                             burden_cost_dr_account
            ,peia.acct_currency_code                                                                                          acct_currency_code
            ,NULL                                                                                                             acct_currency
            ,pcdla.acct_raw_cost                                                                                               acct_raw_cost  -- based on UAT recon from business recon report
            ,peia.acct_burdened_cost                                                                                          acct_burdened_cost
            ,peia.acct_rate_type                                                                                              acct_rate_type
            ,peia.acct_rate_date                                                                                              acct_rate_date
            ,NULL                                                                                                             acct_rate_date_type
            ,peia.acct_exchange_rate                                                                                          acct_exchange_rate
            ,NULL                                                                                                             acct_exchange_rounding_limit
            ,NULL                                                                                                             receipt_currency_code
            ,NULL                                                                                                             receipt_currency
            ,NULL                                                                                                             receipt_currency_amount
            ,NULL                                                                                                             receipt_exchange_rate
            ,peia.converted_flag                                                                                              converted_flag
            ,NULL                                                                                                             context_category
            ,NULL                                                                                                             user_def_attribute1
            ,NULL                                                                                                             user_def_attribute2
            ,NULL                                                                                                             user_def_attribute3
            ,NULL                                                                                                             user_def_attribute4
            ,NULL                                                                                                             user_def_attribute5
            ,NULL                                                                                                             user_def_attribute6
            ,NULL                                                                                                             user_def_attribute7
            ,NULL                                                                                                             user_def_attribute8
            ,NULL                                                                                                             user_def_attribute9
            ,NULL                                                                                                             user_def_attribute10
            ,NULL                                                                                                             reserved_attribute1
            ,NULL                                                                                                             reserved_attribute2
            ,NULL                                                                                                             reserved_attribute3
            ,NULL                                                                                                             reserved_attribute4
            ,NULL                                                                                                             reserved_attribute5
            ,NULL                                                                                                             reserved_attribute6
            ,NULL                                                                                                             reserved_attribute7
            ,NULL                                                                                                             reserved_attribute8
            ,NULL                                                                                                             reserved_attribute9
            ,NULL                                                                                                             reserved_attribute10
            ,NULL                                                                                                             attribute_category
            ,NULL                                                                                                             attribute1
            ,NULL                                                                                                             attribute2
            ,NULL                                                                                                             attribute3
            ,NULL                                                                                                             attribute4
            ,NULL                                                                                                             attribute5
            ,NULL                                                                                                             attribute6
            ,NULL                                                                                                             attribute7
            ,NULL                                                                                                             attribute9
            ,NULL                                                                                                             attribute8
            ,null                                                                                                             attribute10 -- to split costs Labor, NonLabor and Misc in EDQ
            ,NULL                                                                                                             contract_number
            ,NULL                                                                                                             contract_name
            ,NULL                                                                                                             contract_id
            ,NULL                                                                                                             funding_source_number
            ,NULL                                                                                                             funding_source_name
            FROM  xxmx_ppm_projects_stg                                    ppa
                 ,apps.pa_expenditure_items_all@MXDM_NVIS_EXTRACT          peia
                 ,apps.pa_tasks@MXDM_NVIS_EXTRACT                          pt
                 ,apps.hr_all_organization_units@MXDM_NVIS_EXTRACT         haou1
                 ,apps.pa_cost_distribution_lines_all@MXDM_NVIS_EXTRACT    pcdla
                 --,apps.gl_code_combinations@MXDM_NVIS_EXTRACT gcc
            WHERE ppa.project_id                    = peia.project_id
--              AND peia.cc_cross_charge_type <> 'IC'
              and pt.project_id = ppa.project_id
              AND pt.project_id                     = peia.project_id
              AND pt.task_id   (+)                     = peia.task_id
              AND pcdla.expenditure_item_id         = peia.expenditure_item_id
              AND pcdla.project_id                  = peia.project_id
              AND pt.task_id                        = pcdla.task_id
              AND peia.org_id                       = haou1.organization_id
            --AND   peia.org_id                       = haou1.organization_id
            --AND   peia.expenditure_id               = pea.expenditure_id
            AND   ( pt.completion_date              IS NULL
                    OR pt.completion_date           > SYSDATE)   
            --and peia.EXPENDITURE_ITEM_ID=56028655        
            AND NOT EXISTS ( SELECT 1 FROM apps.pa_tasks@MXDM_NVIS_EXTRACT b WHERE b.parent_task_id=pt.task_id)
            --AND peia.expenditure_item_date >= to_date('01-JAN-2020','DD-MON-RRRR')
            /*AND   TO_CHAR(TO_DATE(pcdla.gl_period_name,'Mon-RR'),'RRRR') IN( SELECT TO_CHAR(TO_DATE(parameter_value,'Mon-RR'),'RRRR') 
                                                                                from xxmx_migration_parameters
                                                                                where parameter_code  = 'GL_PERIOD_NAME'
                                                                                and application = 'PPM')*/
            AND  pcdla.gl_date BETWEEN TO_DATE(gvv_migration_date_from,'DD-MM-RRRR') AND TO_DATE(gvv_migration_date_to,'DD-MM-RRRR')  
            AND system_linkage_function in (select parameter_value
                                                  from xxmx_migration_parameters
                                                  where application= 'PPM'
                                                  and application_suite= 'FIN'
                                                  and parameter_code = 'EXP_SYSTEM_LINK_TYPE'
                                                  and sub_entity = 'MISC_COSTS'
                                                  and enabled_flag = 'Y'
                                                  )                    
                    --AND pcdla.project_id = 2073
                    )
            GROUP BY
            Transaction_type --  LABOR, NONLABOR
                ,business_unit --Nullify we consider BU based on Project Number
                ,org_id
                ,user_transaction_source
                ,transaction_source_id
                ,document_name
                ,document_id
                ,doc_entry_name
                ,doc_entry_id
                ,exp_batch_name
                ,batch_ending_date
                ,batch_description
                ,expenditure_item_date
                ,person_number
                ,person_name
                ,person_id
                ,hcm_assignment_name
                ,hcm_assignment_id
                ,project_number
                ,project_name
                ,project_id
                ,task_number
                ,task_name
                ,task_id
                ,expenditure_type
                ,expenditure_type_id
                ,organization_name                                                               --Organization_name
                ,organization_id
                ,non_labor_resource
                ,non_labor_resource_id
                ,non_labor_resource_org
                ,non_labor_resource_org_id
                ,quantity            
                ,unit_of_measure_name
                ,unit_of_measure
                ,work_type
                ,work_type_id
                ,billable_flag
                ,capitalizable_flag
                ,accrual_flag
                ,supplier_number
                ,supplier_name
                ,vendor_id
                ,inventory_item_name
                ,inventory_item_id
                ,orig_transaction_reference
                ,unmatched_negative_txn_flag
                ,reversed_orig_txn_reference
                ,expenditure_comment
                ,gl_date
                ,denom_currency_code
                ,denom_currency
                ,raw_cost_cr_ccid
                ,raw_cost_cr_account
                ,raw_cost_dr_ccid
                ,raw_cost_dr_account
                ,burdened_cost_cr_ccid
                ,burdened_cost_cr_account
                ,burdened_cost_dr_ccid
                ,burdened_cost_dr_account
                ,burden_cost_cr_ccid
                ,burden_cost_cr_account
                ,burden_cost_dr_ccid
                ,burden_cost_dr_account
                ,acct_currency_code
                ,acct_currency
                ,acct_rate_type 
                ,acct_rate_date
                ,acct_rate_date_type
                ,acct_exchange_rate
                ,acct_exchange_rounding_limit
                ,receipt_currency_code
                ,receipt_currency
                ,receipt_currency_amount
                ,receipt_exchange_rate
                ,converted_flag
                ,context_category
                ,user_def_attribute1
                ,user_def_attribute2
                ,user_def_attribute3
                ,user_def_attribute4
                ,user_def_attribute5
                ,user_def_attribute6
                ,user_def_attribute7
                ,user_def_attribute8
                ,user_def_attribute9
                ,user_def_attribute10
                ,reserved_attribute1
                ,reserved_attribute2
                ,reserved_attribute3
                ,reserved_attribute4
                ,reserved_attribute5
                ,reserved_attribute6
                ,reserved_attribute7
                ,reserved_attribute8
                ,reserved_attribute9
                ,reserved_attribute10
                ,attribute_category
                ,attribute1
                ,attribute2
                ,attribute3
                ,attribute4
                ,attribute5
                ,attribute6
                ,attribute7
                ,attribute9
                ,attribute8
                ,attribute10 -- to split costs Labor, NonLabor and Misc in EDQ
                ,contract_number
                ,contract_name
                ,contract_id
                ,funding_source_number
                ,funding_source_name;
       --
       --**********************
       --** Record Declarations
       --**********************
       --
        TYPE pa_costs_tbl IS TABLE OF pa_costs_cur%ROWTYPE INDEX BY BINARY_INTEGER;
        pa_costs_tb  pa_costs_tbl;

        TYPE pa_costs_dtl_tbl IS TABLE OF src_pa_cost_dtl%ROWTYPE INDEX BY BINARY_INTEGER;
        pa_costs_dtl_tb  pa_costs_dtl_tbl;



       --
       --************************
       --** Constant Declarations
       --************************
       --
        cv_ProcOrFuncName                   CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'src_pa_misc_costs';
        cv_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_PPM_PRJ_MISCCOST_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'MISC_COSTS';
        gv_i_BusinessEntity                                 VARCHAR2(100)     := 'PRJ_COST';


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

        gvv_cost_ext_type := xxmx_utilities_pkg.get_single_parameter_value(
                        pt_i_ApplicationSuite           =>     gct_ApplicationSuite
                        ,pt_i_Application                =>     gct_Application
                        ,pt_i_BusinessEntity             =>     'PRJ_COST'
                        ,pt_i_SubEntity                  =>     'ALL'
                        ,pt_i_ParameterCode              =>     'COST_EXT_TYPE');

        gvv_migration_date_from := xxmx_utilities_pkg.get_single_parameter_value(
                        pt_i_ApplicationSuite           =>     gct_ApplicationSuite
                        ,pt_i_Application                =>     gct_Application
                        ,pt_i_BusinessEntity             =>     'ALL'
                        ,pt_i_SubEntity                  =>     'ALL'
                        ,pt_i_ParameterCode              =>     'EXTRACT_START_DATE'
        );        
        --gvd_migration_date_from := TO_DATE(gvv_migration_date_from,'YYYY-MM-DD');


        gvv_migration_date_to := xxmx_utilities_pkg.get_single_parameter_value(
                        pt_i_ApplicationSuite           =>     gct_ApplicationSuite
                        ,pt_i_Application                =>     gct_Application
                        ,pt_i_BusinessEntity             =>     'ALL'
                        ,pt_i_SubEntity                  =>     'ALL'
                        ,pt_i_ParameterCode              =>     'EXTRACT_END_DATE'
        );        
       -- gvd_migration_date_to := TO_DATE(gvv_migration_date_to,'YYYY-MM-DD');
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
        FROM    XXMX_PPM_PRJ_MISCCOST_STG ;

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

            IF( UPPER(gvv_cost_ext_type) = 'SUMMARY') THEN 
                  OPEN pa_costs_cur;
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
                         ,pt_i_ModuleMessage       =>'Cursor Open src_pa_billing_events_cur'
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
                  FETCH pa_costs_cur  BULK COLLECT INTO pa_costs_tb LIMIT 1000;
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
                         ,pt_i_ModuleMessage       => 'Cursor pa_costs_cur Fetch into pa_costs_tb'
                         ,pt_i_OracleError         => gvt_ReturnMessage  );
                  --
                  EXIT WHEN pa_costs_tb.COUNT=0;
                  --
                  FORALL I IN 1..pa_costs_tb.COUNT SAVE EXCEPTIONS
                  --
                       INSERT INTO XXMX_PPM_PRJ_MISCCOST_STG (
                                           migration_set_id                 
                                          ,migration_set_name               
                                          ,migration_status                 
                                          ,transaction_type                
                                          ,business_unit                   
                                          ,org_id                          
                                          ,user_transaction_source         
                                          ,transaction_source_id           
                                          ,document_name                   
                                          ,document_id                     
                                          ,doc_entry_name                  
                                          ,doc_entry_id                    
                                          ,batch_ending_date               
                                          ,batch_description               
                                          ,expenditure_item_date           
                                          ,person_number                   
                                          ,person_name                     
                                          ,person_id                       
                                          ,hcm_assignment_name             
                                          ,hcm_assignment_id               
                                          ,project_number                  
                                          ,project_name                    
                                          ,project_id                      
                                          ,task_number                     
                                          ,task_name                       
                                          ,task_id                         
                                          ,expenditure_type                
                                          ,expenditure_type_id             
                                          ,organization_name               
                                          ,organization_id                 
                                         -- ,non_labor_resource              
                                          --,non_labor_resource_id           
                                          --,non_labor_resource_org          
                                          --,non_labor_resource_org_id       
                                          ,quantity                        
                                          ,unit_of_measure_name            
                                          ,unit_of_measure                 
                                          ,work_type                       
                                          ,work_type_id                    
                                          ,billable_flag                   
                                          ,capitalizable_flag              
                                          ,accrual_flag                    
                                         -- ,supplier_number                 
                                          --,supplier_name                   
                                          --,vendor_id                       
                                          --,inventory_item_name             
                                         -- ,inventory_item_id               
                                          ,orig_transaction_reference      
                                          ,unmatched_negative_txn_flag     
                                          ,reversed_orig_txn_reference     
                                          ,expenditure_comment             
                                          ,gl_date                         
                                          ,denom_currency_code             
                                          ,denom_currency                  
                                          ,denom_raw_cost                  
                                          ,denom_burdened_cost             
                                          ,raw_cost_cr_ccid                
                                          ,raw_cost_cr_account             
                                          ,raw_cost_dr_ccid                
                                          ,raw_cost_dr_account             
                                          ,burdened_cost_cr_ccid           
                                          ,burdened_cost_cr_account        
                                          ,burdened_cost_dr_ccid           
                                          ,burdened_cost_dr_account        
                                          ,burden_cost_cr_ccid             
                                          ,burden_cost_cr_account          
                                          ,burden_cost_dr_ccid             
                                          ,burden_cost_dr_account          
                                          ,acct_currency_code              
                                          ,acct_currency                   
                                          ,acct_raw_cost                   
                                          ,acct_burdened_cost              
                                          ,acct_rate_type                  
                                          ,acct_rate_date                  
                                          ,acct_rate_date_type             
                                          ,acct_exchange_rate              
                                          ,acct_exchange_rounding_limit    
                                          --,receipt_currency_code           
                                          --,receipt_currency                
                                          --,receipt_currency_amount         
                                         -- ,receipt_exchange_rate           
                                          ,converted_flag                  
                                          ,context_category                
                                          ,user_def_attribute1             
                                          ,user_def_attribute2             
                                          ,user_def_attribute3             
                                          ,user_def_attribute4             
                                          ,user_def_attribute5             
                                          ,user_def_attribute6             
                                          ,user_def_attribute7             
                                          ,user_def_attribute8             
                                          ,user_def_attribute9             
                                          ,user_def_attribute10            
                                          ,reserved_attribute1             
                                          ,reserved_attribute2             
                                          ,reserved_attribute3             
                                          ,reserved_attribute4             
                                          ,reserved_attribute5             
                                          ,reserved_attribute6             
                                          ,reserved_attribute7             
                                          ,reserved_attribute8             
                                          ,reserved_attribute9             
                                          ,reserved_attribute10            
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
                                          ,contract_number                 
                                          ,contract_name                   
                                          ,contract_id                     
                                          ,funding_source_number           
                                          ,funding_source_name             
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
                                  ,pa_costs_tb(i).transaction_type                
                                  ,pa_costs_tb(i).business_unit                   
                                  ,pa_costs_tb(i).org_id                          
                                  ,pa_costs_tb(i).user_transaction_source         
                                  ,pa_costs_tb(i).transaction_source_id           
                                  ,pa_costs_tb(i).document_name                   
                                  ,pa_costs_tb(i).document_id                     
                                  ,pa_costs_tb(i).doc_entry_name                  
                                  ,pa_costs_tb(i).doc_entry_id                    
                                  ,pa_costs_tb(i).batch_ending_date               
                                  ,pa_costs_tb(i).batch_description               
                                  ,pa_costs_tb(i).expenditure_item_date           
                                  ,pa_costs_tb(i).person_number                   
                                  ,pa_costs_tb(i).person_name                     
                                  ,pa_costs_tb(i).person_id                       
                                  ,pa_costs_tb(i).hcm_assignment_name             
                                  ,pa_costs_tb(i).hcm_assignment_id               
                                  ,pa_costs_tb(i).project_number                  
                                  ,pa_costs_tb(i).project_name                    
                                  ,pa_costs_tb(i).project_id                      
                                  ,pa_costs_tb(i).task_number                     
                                  ,pa_costs_tb(i).task_name                       
                                  ,pa_costs_tb(i).task_id                         
                                  ,pa_costs_tb(i).expenditure_type                
                                  ,pa_costs_tb(i).expenditure_type_id             
                                  ,pa_costs_tb(i).organization_name               
                                  ,pa_costs_tb(i).organization_id                 
                                  --,pa_costs_tb(i).non_labor_resource              
                                  --,pa_costs_tb(i).non_labor_resource_id           
                                  --,pa_costs_tb(i).non_labor_resource_org          
                                  --,pa_costs_tb(i).non_labor_resource_org_id       
                                  ,pa_costs_tb(i).quantity                        
                                  ,pa_costs_tb(i).unit_of_measure_name            
                                  ,pa_costs_tb(i).unit_of_measure                 
                                  ,pa_costs_tb(i).work_type                       
                                  ,pa_costs_tb(i).work_type_id                    
                                  ,pa_costs_tb(i).billable_flag                   
                                  ,pa_costs_tb(i).capitalizable_flag              
                                  ,pa_costs_tb(i).accrual_flag                    
                                  --,pa_costs_tb(i).supplier_number                 
                                  --,pa_costs_tb(i).supplier_name                   
                                  --,pa_costs_tb(i).vendor_id                       
                                  --,pa_costs_tb(i).inventory_item_name             
                                  --,pa_costs_tb(i).inventory_item_id               
                                  ,pa_costs_tb(i).orig_transaction_reference      
                                  ,pa_costs_tb(i).unmatched_negative_txn_flag     
                                  ,pa_costs_tb(i).reversed_orig_txn_reference     
                                  ,pa_costs_tb(i).expenditure_comment             
                                  ,pa_costs_tb(i).gl_date                         
                                  ,pa_costs_tb(i).denom_currency_code             
                                  ,pa_costs_tb(i).denom_currency                  
                                  ,pa_costs_tb(i).denom_raw_cost                  
                                  ,pa_costs_tb(i).denom_burdened_cost             
                                  ,pa_costs_tb(i).raw_cost_cr_ccid                
                                  ,pa_costs_tb(i).raw_cost_cr_account             
                                  ,pa_costs_tb(i).raw_cost_dr_ccid                
                                  ,pa_costs_tb(i).raw_cost_dr_account             
                                  ,pa_costs_tb(i).burdened_cost_cr_ccid           
                                  ,pa_costs_tb(i).burdened_cost_cr_account        
                                  ,pa_costs_tb(i).burdened_cost_dr_ccid           
                                  ,pa_costs_tb(i).burdened_cost_dr_account        
                                  ,pa_costs_tb(i).burden_cost_cr_ccid             
                                  ,pa_costs_tb(i).burden_cost_cr_account           
                                  ,pa_costs_tb(i).burden_cost_dr_ccid             
                                  ,pa_costs_tb(i).burden_cost_dr_account          
                                  ,pa_costs_tb(i).acct_currency_code              
                                  ,pa_costs_tb(i).acct_currency                   
                                  ,pa_costs_tb(i).acct_raw_cost                   
                                  ,pa_costs_tb(i).acct_burdened_cost              
                                  ,pa_costs_tb(i).acct_rate_type                  
                                  ,pa_costs_tb(i).acct_rate_date                  
                                  ,pa_costs_tb(i).acct_rate_date_type             
                                  ,pa_costs_tb(i).acct_exchange_rate              
                                  ,pa_costs_tb(i).acct_exchange_rounding_limit    
                                  --,pa_costs_tb(i).receipt_currency_code           
                                  --,pa_costs_tb(i).receipt_currency                
                                  --,pa_costs_tb(i).receipt_currency_amount         
                                  --,pa_costs_tb(i).receipt_exchange_rate           
                                  ,pa_costs_tb(i).converted_flag                  
                                  ,pa_costs_tb(i).context_category                
                                  ,pa_costs_tb(i).user_def_attribute1             
                                  ,pa_costs_tb(i).user_def_attribute2             
                                  ,pa_costs_tb(i).user_def_attribute3             
                                  ,pa_costs_tb(i).user_def_attribute4             
                                  ,pa_costs_tb(i).user_def_attribute5             
                                  ,pa_costs_tb(i).user_def_attribute6             
                                  ,pa_costs_tb(i).user_def_attribute7             
                                  ,pa_costs_tb(i).user_def_attribute8             
                                  ,pa_costs_tb(i).user_def_attribute9             
                                  ,pa_costs_tb(i).user_def_attribute10            
                                  ,pa_costs_tb(i).reserved_attribute1             
                                  ,pa_costs_tb(i).reserved_attribute2             
                                  ,pa_costs_tb(i).reserved_attribute3             
                                  ,pa_costs_tb(i).reserved_attribute4             
                                  ,pa_costs_tb(i).reserved_attribute5             
                                  ,pa_costs_tb(i).reserved_attribute6             
                                  ,pa_costs_tb(i).reserved_attribute7             
                                  ,pa_costs_tb(i).reserved_attribute8             
                                  ,pa_costs_tb(i).reserved_attribute9             
                                  ,pa_costs_tb(i).reserved_attribute10            
                                  ,pa_costs_tb(i).attribute_category              
                                  ,pa_costs_tb(i).attribute1                      
                                  ,pa_costs_tb(i).attribute2                      
                                  ,pa_costs_tb(i).attribute3                      
                                  ,pa_costs_tb(i).attribute4                      
                                  ,pa_costs_tb(i).attribute5                      
                                  ,pa_costs_tb(i).attribute6                      
                                  ,pa_costs_tb(i).attribute7                      
                                  ,pa_costs_tb(i).attribute8                      
                                  ,pa_costs_tb(i).attribute9                      
                                  ,pa_costs_tb(i).attribute10                     
                                  ,pa_costs_tb(i).contract_number                 
                                  ,pa_costs_tb(i).contract_name                   
                                  ,pa_costs_tb(i).contract_id                     
                                  ,pa_costs_tb(i).funding_source_number           
                                  ,pa_costs_tb(i).funding_source_name             
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
                                    ,pt_i_ModuleMessage       => 'Close the Cursor pa_costs_cur'
                                    ,pt_i_OracleError         => gvt_ReturnMessage       );   
                   --


                   IF pa_costs_cur%ISOPEN
                   THEN
                        --
                           CLOSE pa_costs_cur;
                        --
                   END IF;

            ELSIF ( UPPER(gvv_cost_ext_type) = 'DETAIL')   
            THEN

                  OPEN src_pa_cost_dtl;
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
                         ,pt_i_ModuleMessage       =>'Cursor Open src_pa_cost_dtl'
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
                  FETCH src_pa_cost_dtl  BULK COLLECT INTO pa_costs_dtl_tb LIMIT 1000;
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
                         ,pt_i_ModuleMessage       => 'Cursor src_pa_cost_dtl Fetch into pa_costs_dtl_tb'
                         ,pt_i_OracleError         => gvt_ReturnMessage  );
                  --
                  EXIT WHEN pa_costs_dtl_tb.COUNT=0;
                  --
                  FORALL I IN 1..pa_costs_dtl_tb.COUNT SAVE EXCEPTIONS
                  --
                       INSERT INTO XXMX_PPM_PRJ_MISCCOST_STG (
                                           migration_set_id                 
                                          ,migration_set_name               
                                          ,migration_status                 
                                          ,transaction_type                
                                          ,business_unit                   
                                          ,org_id                          
                                          ,user_transaction_source         
                                          ,transaction_source_id           
                                          ,document_name                   
                                          ,document_id                     
                                          ,doc_entry_name                  
                                          ,doc_entry_id                    
                                          ,batch_ending_date               
                                          ,batch_description               
                                          ,expenditure_item_date           
                                          ,person_number                   
                                          ,person_name                     
                                          ,person_id                       
                                          ,hcm_assignment_name             
                                          ,hcm_assignment_id               
                                          ,project_number                  
                                          ,project_name                    
                                          ,project_id                      
                                          ,task_number                     
                                          ,task_name                       
                                          ,task_id                         
                                          ,expenditure_type                
                                          ,expenditure_type_id             
                                          ,organization_name               
                                          ,organization_id                 
                                         -- ,non_labor_resource              
                                          --,non_labor_resource_id           
                                          --,non_labor_resource_org          
                                          --,non_labor_resource_org_id       
                                          ,quantity                        
                                          ,unit_of_measure_name            
                                          ,unit_of_measure                 
                                          ,work_type                       
                                          ,work_type_id                    
                                          ,billable_flag                   
                                          ,capitalizable_flag              
                                          ,accrual_flag                    
                                         -- ,supplier_number                 
                                          --,supplier_name                   
                                          --,vendor_id                       
                                          --,inventory_item_name             
                                         -- ,inventory_item_id               
                                          ,orig_transaction_reference      
                                          ,unmatched_negative_txn_flag     
                                          ,reversed_orig_txn_reference     
                                          ,expenditure_comment             
                                          ,gl_date                         
                                          ,denom_currency_code             
                                          ,denom_currency                  
                                          ,denom_raw_cost                  
                                          ,denom_burdened_cost             
                                          ,raw_cost_cr_ccid                
                                          ,raw_cost_cr_account             
                                          ,raw_cost_dr_ccid                
                                          ,raw_cost_dr_account             
                                          ,burdened_cost_cr_ccid           
                                          ,burdened_cost_cr_account        
                                          ,burdened_cost_dr_ccid           
                                          ,burdened_cost_dr_account        
                                          ,burden_cost_cr_ccid             
                                          ,burden_cost_cr_account          
                                          ,burden_cost_dr_ccid             
                                          ,burden_cost_dr_account          
                                          ,acct_currency_code              
                                          ,acct_currency                   
                                          ,acct_raw_cost                   
                                          ,acct_burdened_cost              
                                          ,acct_rate_type                  
                                          ,acct_rate_date                  
                                          ,acct_rate_date_type             
                                          ,acct_exchange_rate              
                                          ,acct_exchange_rounding_limit    
                                          --,receipt_currency_code           
                                          --,receipt_currency                
                                          --,receipt_currency_amount         
                                         -- ,receipt_exchange_rate           
                                          ,converted_flag                  
                                          ,context_category                
                                          ,user_def_attribute1             
                                          ,user_def_attribute2             
                                          ,user_def_attribute3             
                                          ,user_def_attribute4             
                                          ,user_def_attribute5             
                                          ,user_def_attribute6             
                                          ,user_def_attribute7             
                                          ,user_def_attribute8             
                                          ,user_def_attribute9             
                                          ,user_def_attribute10            
                                          ,reserved_attribute1             
                                          ,reserved_attribute2             
                                          ,reserved_attribute3             
                                          ,reserved_attribute4             
                                          ,reserved_attribute5             
                                          ,reserved_attribute6             
                                          ,reserved_attribute7             
                                          ,reserved_attribute8             
                                          ,reserved_attribute9             
                                          ,reserved_attribute10            
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
                                          ,contract_number                 
                                          ,contract_name                   
                                          ,contract_id                     
                                          ,funding_source_number           
                                          ,funding_source_name             
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
                                  ,pa_costs_dtl_tb(i).transaction_type                
                                  ,pa_costs_dtl_tb(i).business_unit                   
                                  ,pa_costs_dtl_tb(i).org_id                          
                                  ,pa_costs_dtl_tb(i).user_transaction_source         
                                  ,pa_costs_dtl_tb(i).transaction_source_id           
                                  ,pa_costs_dtl_tb(i).document_name                   
                                  ,pa_costs_dtl_tb(i).document_id                     
                                  ,pa_costs_dtl_tb(i).doc_entry_name                  
                                  ,pa_costs_dtl_tb(i).doc_entry_id                    
                                  ,pa_costs_dtl_tb(i).batch_ending_date               
                                  ,pa_costs_dtl_tb(i).batch_description               
                                  ,pa_costs_dtl_tb(i).expenditure_item_date           
                                  ,pa_costs_dtl_tb(i).person_number                   
                                  ,pa_costs_dtl_tb(i).person_name                     
                                  ,pa_costs_dtl_tb(i).person_id                       
                                  ,pa_costs_dtl_tb(i).hcm_assignment_name             
                                  ,pa_costs_dtl_tb(i).hcm_assignment_id               
                                  ,pa_costs_dtl_tb(i).project_number                  
                                  ,pa_costs_dtl_tb(i).project_name                    
                                  ,pa_costs_dtl_tb(i).project_id                      
                                  ,pa_costs_dtl_tb(i).task_number                     
                                  ,pa_costs_dtl_tb(i).task_name                       
                                  ,pa_costs_dtl_tb(i).task_id                         
                                  ,pa_costs_dtl_tb(i).expenditure_type                
                                  ,pa_costs_dtl_tb(i).expenditure_type_id             
                                  ,pa_costs_dtl_tb(i).organization_name               
                                  ,pa_costs_dtl_tb(i).organization_id                 
                                  --,pa_costs_dtl_tb(i).non_labor_resource              
                                  --,pa_costs_dtl_tb(i).non_labor_resource_id           
                                  --,pa_costs_dtl_tb(i).non_labor_resource_org          
                                  --,pa_costs_dtl_tb(i).non_labor_resource_org_id       
                                  ,pa_costs_dtl_tb(i).quantity                        
                                  ,pa_costs_dtl_tb(i).unit_of_measure_name            
                                  ,pa_costs_dtl_tb(i).unit_of_measure                 
                                  ,pa_costs_dtl_tb(i).work_type                       
                                  ,pa_costs_dtl_tb(i).work_type_id                    
                                  ,pa_costs_dtl_tb(i).billable_flag                   
                                  ,pa_costs_dtl_tb(i).capitalizable_flag              
                                  ,pa_costs_dtl_tb(i).accrual_flag                    
                                  --,pa_costs_dtl_tb(i).supplier_number                 
                                  --,pa_costs_dtl_tb(i).supplier_name                   
                                  --,pa_costs_dtl_tb(i).vendor_id                       
                                  --,pa_costs_dtl_tb(i).inventory_item_name             
                                  --,pa_costs_dtl_tb(i).inventory_item_id               
                                  ,pa_costs_dtl_tb(i).orig_transaction_reference      
                                  ,pa_costs_dtl_tb(i).unmatched_negative_txn_flag     
                                  ,pa_costs_dtl_tb(i).reversed_orig_txn_reference     
                                  ,pa_costs_dtl_tb(i).expenditure_comment             
                                  ,pa_costs_dtl_tb(i).gl_date                         
                                  ,pa_costs_dtl_tb(i).denom_currency_code             
                                  ,pa_costs_dtl_tb(i).denom_currency                  
                                  ,pa_costs_dtl_tb(i).denom_raw_cost                  
                                  ,pa_costs_dtl_tb(i).denom_burdened_cost             
                                  ,pa_costs_dtl_tb(i).raw_cost_cr_ccid                
                                  ,pa_costs_dtl_tb(i).raw_cost_cr_account             
                                  ,pa_costs_dtl_tb(i).raw_cost_dr_ccid                
                                  ,pa_costs_dtl_tb(i).raw_cost_dr_account             
                                  ,pa_costs_dtl_tb(i).burdened_cost_cr_ccid           
                                  ,pa_costs_dtl_tb(i).burdened_cost_cr_account        
                                  ,pa_costs_dtl_tb(i).burdened_cost_dr_ccid           
                                  ,pa_costs_dtl_tb(i).burdened_cost_dr_account        
                                  ,pa_costs_dtl_tb(i).burden_cost_cr_ccid             
                                  ,pa_costs_dtl_tb(i).burden_cost_cr_account           
                                  ,pa_costs_dtl_tb(i).burden_cost_dr_ccid             
                                  ,pa_costs_dtl_tb(i).burden_cost_dr_account          
                                  ,pa_costs_dtl_tb(i).acct_currency_code              
                                  ,pa_costs_dtl_tb(i).acct_currency                   
                                  ,pa_costs_dtl_tb(i).acct_raw_cost                   
                                  ,pa_costs_dtl_tb(i).acct_burdened_cost              
                                  ,pa_costs_dtl_tb(i).acct_rate_type                  
                                  ,pa_costs_dtl_tb(i).acct_rate_date                  
                                  ,pa_costs_dtl_tb(i).acct_rate_date_type             
                                  ,pa_costs_dtl_tb(i).acct_exchange_rate              
                                  ,pa_costs_dtl_tb(i).acct_exchange_rounding_limit    
                                  --,pa_costs_dtl_tb(i).receipt_currency_code           
                                  --,pa_costs_dtl_tb(i).receipt_currency                
                                  --,pa_costs_dtl_tb(i).receipt_currency_amount         
                                  --,pa_costs_dtl_tb(i).receipt_exchange_rate           
                                  ,pa_costs_dtl_tb(i).converted_flag                  
                                  ,pa_costs_dtl_tb(i).context_category                
                                  ,pa_costs_dtl_tb(i).user_def_attribute1             
                                  ,pa_costs_dtl_tb(i).user_def_attribute2             
                                  ,pa_costs_dtl_tb(i).user_def_attribute3             
                                  ,pa_costs_dtl_tb(i).user_def_attribute4             
                                  ,pa_costs_dtl_tb(i).user_def_attribute5             
                                  ,pa_costs_dtl_tb(i).user_def_attribute6             
                                  ,pa_costs_dtl_tb(i).user_def_attribute7             
                                  ,pa_costs_dtl_tb(i).user_def_attribute8             
                                  ,pa_costs_dtl_tb(i).user_def_attribute9             
                                  ,pa_costs_dtl_tb(i).user_def_attribute10            
                                  ,pa_costs_dtl_tb(i).reserved_attribute1             
                                  ,pa_costs_dtl_tb(i).reserved_attribute2             
                                  ,pa_costs_dtl_tb(i).reserved_attribute3             
                                  ,pa_costs_dtl_tb(i).reserved_attribute4             
                                  ,pa_costs_dtl_tb(i).reserved_attribute5             
                                  ,pa_costs_dtl_tb(i).reserved_attribute6             
                                  ,pa_costs_dtl_tb(i).reserved_attribute7             
                                  ,pa_costs_dtl_tb(i).reserved_attribute8             
                                  ,pa_costs_dtl_tb(i).reserved_attribute9             
                                  ,pa_costs_dtl_tb(i).reserved_attribute10            
                                  ,pa_costs_dtl_tb(i).attribute_category              
                                  ,pa_costs_dtl_tb(i).attribute1                      
                                  ,pa_costs_dtl_tb(i).attribute2                      
                                  ,pa_costs_dtl_tb(i).attribute3                      
                                  ,pa_costs_dtl_tb(i).attribute4                      
                                  ,pa_costs_dtl_tb(i).attribute5                      
                                  ,pa_costs_dtl_tb(i).attribute6                      
                                  ,pa_costs_dtl_tb(i).attribute7                      
                                  ,pa_costs_dtl_tb(i).attribute8                      
                                  ,pa_costs_dtl_tb(i).attribute9                      
                                  ,pa_costs_dtl_tb(i).attribute10                     
                                  ,pa_costs_dtl_tb(i).contract_number                 
                                  ,pa_costs_dtl_tb(i).contract_name                   
                                  ,pa_costs_dtl_tb(i).contract_id                     
                                  ,pa_costs_dtl_tb(i).funding_source_number           
                                  ,pa_costs_dtl_tb(i).funding_source_name             
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
                                    ,pt_i_ModuleMessage       => 'Close the Cursor src_pa_cost_dtl'
                                    ,pt_i_OracleError         => gvt_ReturnMessage       );   
                   --


                   IF src_pa_cost_dtl%ISOPEN
                   THEN
                        --
                           CLOSE src_pa_cost_dtl;
                        --
                   END IF;

               ELSE 
                  --
                  gvv_ProgressIndicator := '0090';
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
                                    ,pt_i_ModuleMessage       => 'Parameter Cost_ext_type is mandatory - Summary or Detail Extract'
                                    ,pt_i_OracleError         => gvt_ReturnMessage       );   
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
        IF pa_costs_cur%ISOPEN
        THEN
            --
            CLOSE pa_costs_cur;
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

         IF pa_costs_cur%ISOPEN
         THEN
             --
             CLOSE pa_costs_cur;
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



     END src_pa_misc_costs;

   /*********************************************************
   --------------------src_pa_lbr_costs-----------------------
   -- Extracts Project labour cost from EBS
   ----------------------------------------------------------
   **********************************************************/

   PROCEDURE src_pa_lbr_costs
                     (pt_i_MigrationSetID              IN      xxmx_migration_headers.migration_set_id%TYPE
                     ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE)
     AS   

          --
          --**********************
          --** Cursor Declarations
          --**********************
          --
            CURSOR pa_costs_cur
            IS
            select       
                Transaction_type --  LABOR, NONLABOR
                ,business_unit --Nullify we consider BU based on Project Number
                ,org_id
                ,user_transaction_source
                ,transaction_source_id
                ,document_name
                ,document_id
                ,doc_entry_name
                ,doc_entry_id
                ,exp_batch_name
                ,batch_ending_date
                ,batch_description
                ,expenditure_item_date
                ,person_number
                ,person_name
                ,person_id
                ,hcm_assignment_name
                ,hcm_assignment_id
                ,project_number
                ,project_name
                ,project_id
                ,task_number
                ,task_name
                ,task_id
                ,expenditure_type
                ,expenditure_type_id
                ,organization_name                                                               --Organization_name
                ,organization_id
                ,non_labor_resource
                ,non_labor_resource_id
                ,non_labor_resource_org
                ,non_labor_resource_org_id
                ,quantity            
                ,unit_of_measure_name
                ,unit_of_measure
                ,work_type
                ,work_type_id
                ,billable_flag
                ,capitalizable_flag
                ,accrual_flag
                ,supplier_number
                ,supplier_name
                ,vendor_id
                ,inventory_item_name
                ,inventory_item_id
                ,orig_transaction_reference
                ,unmatched_negative_txn_flag
                ,reversed_orig_txn_reference
                ,expenditure_comment
                ,gl_date
                ,denom_currency_code
                ,denom_currency
                ,sum(denom_raw_cost)        AS denom_raw_cost                                          --denom_raw_cost
                ,sum(denom_burdened_cost)   AS denom_burdened_cost                                --denom_burdened_cost
                ,raw_cost_cr_ccid
                ,raw_cost_cr_account
                ,raw_cost_dr_ccid
                ,raw_cost_dr_account
                ,burdened_cost_cr_ccid
                ,burdened_cost_cr_account
                ,burdened_cost_dr_ccid
                ,burdened_cost_dr_account
                ,burden_cost_cr_ccid
                ,burden_cost_cr_account
                ,burden_cost_dr_ccid
                ,burden_cost_dr_account
                ,acct_currency_code
                ,acct_currency
                ,sum(acct_raw_cost)             AS acct_raw_cost -- based on UAT recon from business recon report
                ,sum(acct_burdened_cost)        AS acct_burdened_cost
                ,acct_rate_type 
                ,acct_rate_date
                ,acct_rate_date_type
                ,acct_exchange_rate
                ,acct_exchange_rounding_limit
                ,receipt_currency_code
                ,receipt_currency
                ,receipt_currency_amount
                ,receipt_exchange_rate
                ,converted_flag
                ,context_category
                ,user_def_attribute1
                ,user_def_attribute2
                ,user_def_attribute3
                ,user_def_attribute4
                ,user_def_attribute5
                ,user_def_attribute6
                ,user_def_attribute7
                ,user_def_attribute8
                ,user_def_attribute9
                ,user_def_attribute10
                ,reserved_attribute1
                ,reserved_attribute2
                ,reserved_attribute3
                ,reserved_attribute4
                ,reserved_attribute5
                ,reserved_attribute6
                ,reserved_attribute7
                ,reserved_attribute8
                ,reserved_attribute9
                ,reserved_attribute10
                ,attribute_category
                ,attribute1
                ,attribute2
                ,attribute3
                ,attribute4
                ,attribute5
                ,attribute6
                ,attribute7
                ,attribute9
                ,attribute8
                ,attribute10 -- to split costs Labor, NonLabor and Misc in EDQ
                ,contract_number
                ,contract_name
                ,contract_id
                ,funding_source_number
                ,funding_source_name
          from
        (SELECT distinct 
             NULL                                                                             AS transaction_type --  LABOR, NONLABOR
            ,haou1.name                                                                       AS business_unit --Nullify as we consider BU based on Project Number
            ,NULL                                                                             AS org_id
            ,null                                                                             AS user_transaction_source
            ,NULL                                                                             AS transaction_source_id
            ,NULL                                                                             AS document_name
            ,NULL                                                                             AS document_id
            ,NULL                                                                             AS doc_entry_name
            ,NULL                                                                             AS doc_entry_id
            ,NULL                                                                             AS exp_batch_name
            ,NULL                                                                             AS batch_ending_date
            ,NULL                                                                             AS batch_description
            ,NULL                                                                             AS expenditure_item_date
            ,NULL                                                                             AS person_number
            ,NULL                                                                             AS person_name
            ,NULL                                                                             AS person_id
            ,NULL                                                                             AS hcm_assignment_name
            ,NULL                                                                             As hcm_assignment_id
            ,ppa.project_number                                                               AS project_number
            ,ppa.project_name                                                                 AS project_name
            ,ppa.project_id                                                                   AS project_id
            ,NULL                                                                             AS task_number
            ,NULL                                                                             AS task_name
            ,NULL                                                                             AS task_id
            ,peia.expenditure_type                                                            AS expenditure_type
            ,NULL                                                                             AS expenditure_type_id
            ,(select haou2.name 
                from apps.hr_all_organization_units@MXDM_NVIS_EXTRACT haou2 
                     ,apps.pa_expenditures_all@MXDM_NVIS_EXTRACT pea1
                where haou2.organization_id= NVL (peia.override_to_organization_id, pea1.incurred_by_organization_id)
                and peia.expenditure_id = pea1.expenditure_id)                                AS organization_name  
            ,NULL                                                                             AS organization_id
            ,NULL                                                                             AS non_labor_resource
            ,NULL                                                                             AS non_labor_resource_id
            ,NULL                                                                             AS non_labor_resource_org
            ,NULL                                                                             AS non_labor_resource_org_id
            ,peia.quantity                                                                    AS quantity            
            ,NULL                                                                             AS unit_of_measure_name
            ,peia.unit_of_measure                                                             AS unit_of_measure
            ,NULL                                                                             AS work_type
            ,NULL                                                                             AS work_type_id
            ,NULL                                                                             AS billable_flag
            ,NULL                                                                             AS capitalizable_flag
            ,NULL                                                                             AS accrual_flag
            ,NULL                                                                             As supplier_number
            ,NULL                                                                             AS supplier_name
            ,NULL                                                                             AS vendor_id
            ,NULL                                                                             As inventory_item_name
            ,NULL                                                                             AS inventory_item_id
            ,NULL                                                                             AS orig_transaction_reference
            ,NULL                                                                             AS unmatched_negative_txn_flag
            ,NULL                                                                             AS reversed_orig_txn_reference
            ,NULL                                                                             AS expenditure_comment
            ,NULL                                                                             AS gl_date
            ,pcdla.denom_currency_code                                                        AS denom_currency_code
            ,NULL                                                                             AS denom_currency
            ,pcdla.denom_raw_cost                                                             AS denom_raw_cost
            ,peia.denom_burdened_cost                                                         AS denom_burdened_cost
            ,NULL                                                                             AS raw_cost_cr_ccid
            ,NULL                                                                             AS raw_cost_cr_account
            ,NULL                                                                             AS raw_cost_dr_ccid
            ,NULL                                                                             AS raw_cost_dr_account
            ,NULL                                                                             AS burdened_cost_cr_ccid
            ,NULL                                                                             AS burdened_cost_cr_account
            ,NULL                                                                             AS burdened_cost_dr_ccid
            ,NULL                                                                             AS burdened_cost_dr_account
            ,NULL                                                                             AS burden_cost_cr_ccid
            ,NULL                                                                             AS burden_cost_cr_account
            ,NULL                                                                             AS burden_cost_dr_ccid
            ,NULL                                                                             AS burden_cost_dr_account
            ,peia.acct_currency_code                                                          AS acct_currency_code
            ,NULL                                                                             AS acct_currency
            ,pcdla.acct_raw_cost                                                              AS acct_raw_cost  -- based on UAT recon from business recon report
            ,peia.acct_burdened_cost                                                          AS acct_burdened_cost
            ,peia.acct_rate_type                                                              AS acct_rate_type 
            ,peia.acct_rate_date                                                              AS acct_rate_date
            ,NULL                                                                             AS acct_rate_date_type
            ,peia.acct_exchange_rate                                                          AS acct_exchange_rate
            ,NULL                                                                             AS acct_exchange_rounding_limit
            ,NULL                                                                             AS receipt_currency_code
            ,NULL                                                                             AS receipt_currency
            ,NULL                                                                             AS receipt_currency_amount
            ,NULL                                                                             AS receipt_exchange_rate
            ,peia.converted_flag                                                              AS converted_flag
            ,NULL                                                                             As context_category
            ,NULL                                                                             AS user_def_attribute1
            ,NULL                                                                             AS user_def_attribute2
            ,NULL                                                                             AS user_def_attribute3
            ,NULL                                                                             AS user_def_attribute4
            ,NULL                                                                             AS user_def_attribute5
            ,NULL                                                                             AS user_def_attribute6
            ,NULL                                                                             AS user_def_attribute7
            ,NULL                                                                             AS user_def_attribute8
            ,NULL                                                                             AS user_def_attribute9
            ,NULL                                                                             AS user_def_attribute10
            ,NULL                                                                             As reserved_attribute1
            ,NULL                                                                             AS reserved_attribute2
            ,NULL                                                                             AS reserved_attribute3
            ,NULL                                                                             AS reserved_attribute4
            ,NULL                                                                             AS reserved_attribute5
            ,NULL                                                                             AS reserved_attribute6
            ,NULL                                                                             AS reserved_attribute7
            ,NULL                                                                             AS reserved_attribute8
            ,NULL                                                                             AS reserved_attribute9
            ,NULL                                                                             AS reserved_attribute10
            ,NULL                                                                             AS attribute_category
            ,NULL                                                                             AS attribute1
            ,NULL                                                                             AS attribute2
            ,NULL                                                                             AS attribute3
            ,NULL                                                                             AS attribute4
            ,NULL                                                                             AS attribute5
            ,NULL                                                                             AS attribute6
            ,NULL                                                                             AS attribute7
            ,NULL                                                                             AS attribute9
            ,NULL                                                                             AS attribute8
            ,null                                                                             AS attribute10 -- to split costs Labor, NonLabor and Misc in EDQ
            ,NULL                                                                             AS contract_number
            ,NULL                                                                             AS contract_name
            ,NULL                                                                             AS contract_id
            ,NULL                                                                             AS funding_source_number
            ,NULL                                                                             AS funding_source_name
            FROM  xxmx_ppm_projects_stg                                    ppa
                 ,apps.pa_expenditure_items_all@MXDM_NVIS_EXTRACT          peia
                 ,apps.hr_all_organization_units@MXDM_NVIS_EXTRACT         haou1
                 ,apps.pa_cost_distribution_lines_all@MXDM_NVIS_EXTRACT    pcdla
            WHERE ppa.project_id                    = peia.project_id
            AND pcdla.expenditure_item_id         = peia.expenditure_item_id
            AND pcdla.project_id                  = peia.project_id
            AND peia.org_id                       = haou1.organization_id
            AND  gl_date   BETWEEN TO_DATE(gvv_migration_date_from,'DD-MM-RRRR') AND TO_DATE(gvv_migration_date_to,'DD-MM-RRRR')
            AND system_linkage_function in (select parameter_value
                                                  from xxmx_migration_parameters
                                                  where application= 'PPM'
                                                  and application_suite= 'FIN'
                                                  and parameter_code = 'EXP_SYSTEM_LINK_TYPE'
                                                  and sub_entity = 'LABOUR_COST'
                                                  and enabled_flag = 'Y'
                                                  ) 

            ) src
             GROUP BY
                 Transaction_type --  LABOR, NONLABOR
                ,business_unit --Nullify we consider BU based on Project Number
                ,org_id
                ,user_transaction_source
                ,transaction_source_id
                ,document_name
                ,document_id
                ,doc_entry_name
                ,doc_entry_id
                ,exp_batch_name
                ,batch_ending_date
                ,batch_description
                ,expenditure_item_date
                ,person_number
                ,person_name
                ,person_id
                ,hcm_assignment_name
                ,hcm_assignment_id
                ,project_number
                ,project_name
                ,project_id
                ,task_number
                ,task_name
                ,task_id
                ,expenditure_type
                ,expenditure_type_id
                ,organization_name                                                               --Organization_name
                ,organization_id
                ,non_labor_resource
                ,non_labor_resource_id
                ,non_labor_resource_org
                ,non_labor_resource_org_id
                ,quantity            
                ,unit_of_measure_name
                ,unit_of_measure
                ,work_type
                ,work_type_id
                ,billable_flag
                ,capitalizable_flag
                ,accrual_flag
                ,supplier_number
                ,supplier_name
                ,vendor_id
                ,inventory_item_name
                ,inventory_item_id
                ,orig_transaction_reference
                ,unmatched_negative_txn_flag
                ,reversed_orig_txn_reference
                ,expenditure_comment
                ,gl_date
                ,denom_currency_code
                ,denom_currency
                ,raw_cost_cr_ccid
                ,raw_cost_cr_account
                ,raw_cost_dr_ccid
                ,raw_cost_dr_account
                ,burdened_cost_cr_ccid
                ,burdened_cost_cr_account
                ,burdened_cost_dr_ccid
                ,burdened_cost_dr_account
                ,burden_cost_cr_ccid
                ,burden_cost_cr_account
                ,burden_cost_dr_ccid
                ,burden_cost_dr_account
                ,acct_currency_code
                ,acct_currency
                ,acct_rate_type 
                ,acct_rate_date
                ,acct_rate_date_type
                ,acct_exchange_rate
                ,acct_exchange_rounding_limit
                ,receipt_currency_code
                ,receipt_currency
                ,receipt_currency_amount
                ,receipt_exchange_rate
                ,converted_flag
                ,context_category
                ,user_def_attribute1
                ,user_def_attribute2
                ,user_def_attribute3
                ,user_def_attribute4
                ,user_def_attribute5
                ,user_def_attribute6
                ,user_def_attribute7
                ,user_def_attribute8
                ,user_def_attribute9
                ,user_def_attribute10
                ,reserved_attribute1
                ,reserved_attribute2
                ,reserved_attribute3
                ,reserved_attribute4
                ,reserved_attribute5
                ,reserved_attribute6
                ,reserved_attribute7
                ,reserved_attribute8
                ,reserved_attribute9
                ,reserved_attribute10
                ,attribute_category
                ,attribute1
                ,attribute2
                ,attribute3
                ,attribute4
                ,attribute5
                ,attribute6
                ,attribute7
                ,attribute9
                ,attribute8
                ,attribute10 -- to split costs Labor, NonLabor and Misc in EDQ
                ,contract_number
                ,contract_name
                ,contract_id
                ,funding_source_number
                ,funding_source_name   
                  ;


        CURSOR src_pa_cost_dtl
        IS
             select  Transaction_type --  LABOR, NONLABOR
                ,business_unit --Nullify we consider BU based on Project Number
                ,org_id
                ,user_transaction_source
                ,transaction_source_id
                ,document_name
                ,document_id
                ,doc_entry_name
                ,doc_entry_id
                ,exp_batch_name
                ,batch_ending_date
                ,batch_description
                ,expenditure_item_date
                ,person_number
                ,person_name
                ,person_id
                ,hcm_assignment_name
                ,hcm_assignment_id
                ,project_number
                ,project_name
                ,project_id
                ,task_number
                ,task_name
                ,task_id
                ,expenditure_type
                ,expenditure_type_id
                ,organization_name                                                               --Organization_name
                ,organization_id
                ,non_labor_resource
                ,non_labor_resource_id
                ,non_labor_resource_org
                ,non_labor_resource_org_id
                ,quantity            
                ,unit_of_measure_name
                ,unit_of_measure
                ,work_type
                ,work_type_id
                ,billable_flag
                ,capitalizable_flag
                ,accrual_flag
                ,supplier_number
                ,supplier_name
                ,vendor_id
                ,inventory_item_name
                ,inventory_item_id
                ,orig_transaction_reference
                ,unmatched_negative_txn_flag
                ,reversed_orig_txn_reference
                ,expenditure_comment
                ,gl_date
                ,denom_currency_code
                ,denom_currency
                ,sum(denom_raw_cost)        AS denom_raw_cost                                          --denom_raw_cost
                ,sum(denom_burdened_cost)   AS denom_burdened_cost                                --denom_burdened_cost
                ,raw_cost_cr_ccid
                ,raw_cost_cr_account
                ,raw_cost_dr_ccid
                ,raw_cost_dr_account
                ,burdened_cost_cr_ccid
                ,burdened_cost_cr_account
                ,burdened_cost_dr_ccid
                ,burdened_cost_dr_account
                ,burden_cost_cr_ccid
                ,burden_cost_cr_account
                ,burden_cost_dr_ccid
                ,burden_cost_dr_account
                ,acct_currency_code
                ,acct_currency
                ,sum(acct_raw_cost)             AS acct_raw_cost -- based on UAT recon from business recon report
                ,sum(acct_burdened_cost)        AS acct_burdened_cost
                ,acct_rate_type 
                ,acct_rate_date
                ,acct_rate_date_type
                ,acct_exchange_rate
                ,acct_exchange_rounding_limit
                ,receipt_currency_code
                ,receipt_currency
                ,receipt_currency_amount
                ,receipt_exchange_rate
                ,converted_flag
                ,context_category
                ,user_def_attribute1
                ,user_def_attribute2
                ,user_def_attribute3
                ,user_def_attribute4
                ,user_def_attribute5
                ,user_def_attribute6
                ,user_def_attribute7
                ,user_def_attribute8
                ,user_def_attribute9
                ,user_def_attribute10
                ,reserved_attribute1
                ,reserved_attribute2
                ,reserved_attribute3
                ,reserved_attribute4
                ,reserved_attribute5
                ,reserved_attribute6
                ,reserved_attribute7
                ,reserved_attribute8
                ,reserved_attribute9
                ,reserved_attribute10
                ,attribute_category
                ,attribute1
                ,attribute2
                ,attribute3
                ,attribute4
                ,attribute5
                ,attribute6
                ,attribute7
                ,attribute9
                ,attribute8
                ,attribute10 -- to split costs Labor, NonLabor and Misc in EDQ
                ,contract_number
                ,contract_name
                ,contract_id
                ,funding_source_number
                ,funding_source_name                                                                                                          funding_source_name
           from(SELECT 
            NULL                                                                                                             transaction_type --  LABOR, NONLABOR
            ,haou1.name                                                                                                        business_unit --Nullify as we consider BU based on Project Number
            ,NULL                                                                                                             org_id
            ,null                                                                                                             user_transaction_source
            ,NULL                                                                                                             transaction_source_id
            ,NULL                                                                                                             document_name
            ,NULL                                                                                                             document_id
            ,NULL                                                                                                             doc_entry_name
            ,NULL                                                                                                             doc_entry_id
            --  'Data Migration'                                                                                              exp_batch_name
            ,(SELECT pea.expenditure_group
              FROM apps.pa_expenditures_all@MXDM_NVIS_EXTRACT pea
              WHERE peia.expenditure_id = pea.expenditure_id)                                                                 exp_batch_name
            ,(SELECT pea.expenditure_ending_date
              FROM apps.pa_expenditures_all@MXDM_NVIS_EXTRACT pea
              WHERE peia.expenditure_id = pea.expenditure_id)                                                                 batch_ending_date
            ,(SELECT pea.description
              FROM apps.pa_expenditures_all@MXDM_NVIS_EXTRACT pea
              WHERE peia.expenditure_id = pea.expenditure_id)                                                                 batch_description
            ,peia.expenditure_item_date                                                                                       expenditure_item_date
            ,NULL                                                                                                             person_number
            ,NULL                                                                                                             person_name
            ,NULL                                                                                                             person_id
            ,NULL                                                                                                             hcm_assignment_name
            ,NULL                                                                                                             hcm_assignment_id
            ,ppa.project_number                                                                                               project_number
            ,ppa.project_name                                                                                                 project_name
            ,NULL                                                                                                             project_id
            ,pt.task_number                                                                                                   task_number
            ,pt.task_name                                                                                                     task_name
            --,ppa.segment1||'-'||'DM2020'                                                                                    task_number
            --,ppa.segment1||'-'||'DM2020'                                                                                                     task_name
            ,NULL                                                                                                             task_id
            ,peia.expenditure_type                                                                                            expenditure_type
            ,NULL                                                                                                             expenditure_type_id
            ,(select haou2.name 
                from apps.hr_all_organization_units@MXDM_NVIS_EXTRACT haou2 
                     ,apps.pa_expenditures_all@MXDM_NVIS_EXTRACT pea1
                where haou2.organization_id= NVL (peia.override_to_organization_id, pea1.incurred_by_organization_id)
                  and peia.expenditure_id = pea1.expenditure_id)                                                               organization_name

            ,NULL                                                                                                             organization_id -- POO from Project Number Mapped in EDQ
            ,NULL                                                                                                             non_labor_resource
            ,NULL                                                                                                             non_labor_resource_id
            ,null                                                                                                             non_labor_resource_org
            ,NULL                                                                                                             non_labor_resource_org_id
            ,peia.quantity                                                                                                    quantity
            ,NULL                                                                                                             unit_of_measure_name
            ,peia.unit_of_measure                                                                                             unit_of_measure
            ,(SELECT name
              FROM   apps.pa_work_types_tl@MXDM_NVIS_EXTRACT pwtt--apps.PA_TASKS_V@MXDM_NVIS_EXTRACT
              WHERE  peia.work_type_id=pwtt.work_type_id)                                                                     work_type
            ,NULL                                                                                                             work_type_id
            ,peia.billable_flag                                                                                               billable_flag
            ,NULL                                                                                                             capitalizable_flag
            ,NULL                                                                                                             accrual_flag
            ,NULL                                                                                                             supplier_number
            ,NULL                                                                                                             supplier_name
            ,NULL                                                                                                             vendor_id
            ,NULL                                                                                                             inventory_item_name
            ,NULL                                                                                                             inventory_item_id
            ,ppa.project_number||'-'||'DM2020'                                                                                orig_transaction_reference
            ,NULL                                                                                                             unmatched_negative_txn_flag
            ,NULL                                                                                                             reversed_orig_txn_reference
            ,NULL                                                                                                             expenditure_comment
            ,pcdla.gl_date                                                                                                    gl_date
            ,pcdla.denom_currency_code                                                                                         denom_currency_code
            ,NULL                                                                                                             denom_currency
            ,pcdla.denom_raw_cost                                                                                              denom_raw_cost
            ,peia.denom_burdened_cost                                                                                         denom_burdened_cost
            ,NULL                                                                                                             raw_cost_cr_ccid
            ,NULL                                                                                                             raw_cost_cr_account
            ,NULL                                                                                                             raw_cost_dr_ccid
            ,NULL                                                                                                             raw_cost_dr_account
            ,NULL                                                                                                             burdened_cost_cr_ccid
            ,NULL                                                                                                             burdened_cost_cr_account
            ,NULL                                                                                                             burdened_cost_dr_ccid
            ,NULL                                                                                                             burdened_cost_dr_account
            ,NULL                                                                                                             burden_cost_cr_ccid
            ,NULL                                                                                                             burden_cost_cr_account
            ,NULL                                                                                                             burden_cost_dr_ccid
            ,NULL                                                                                                             burden_cost_dr_account
            ,peia.acct_currency_code                                                                                          acct_currency_code
            ,NULL                                                                                                             acct_currency
            ,pcdla.acct_raw_cost                                                                                               acct_raw_cost  -- based on UAT recon from business recon report
            ,peia.acct_burdened_cost                                                                                          acct_burdened_cost
            ,peia.acct_rate_type                                                                                              acct_rate_type
            ,peia.acct_rate_date                                                                                              acct_rate_date
            ,NULL                                                                                                             acct_rate_date_type
            ,peia.acct_exchange_rate                                                                                          acct_exchange_rate
            ,NULL                                                                                                             acct_exchange_rounding_limit
            ,NULL                                                                                                             receipt_currency_code
            ,NULL                                                                                                             receipt_currency
            ,NULL                                                                                                             receipt_currency_amount
            ,NULL                                                                                                             receipt_exchange_rate
            ,peia.converted_flag                                                                                              converted_flag
            ,NULL                                                                                                             context_category
            ,NULL                                                                                                             user_def_attribute1
            ,NULL                                                                                                             user_def_attribute2
            ,NULL                                                                                                             user_def_attribute3
            ,NULL                                                                                                             user_def_attribute4
            ,NULL                                                                                                             user_def_attribute5
            ,NULL                                                                                                             user_def_attribute6
            ,NULL                                                                                                             user_def_attribute7
            ,NULL                                                                                                             user_def_attribute8
            ,NULL                                                                                                             user_def_attribute9
            ,NULL                                                                                                             user_def_attribute10
            ,NULL                                                                                                             reserved_attribute1
            ,NULL                                                                                                             reserved_attribute2
            ,NULL                                                                                                             reserved_attribute3
            ,NULL                                                                                                             reserved_attribute4
            ,NULL                                                                                                             reserved_attribute5
            ,NULL                                                                                                             reserved_attribute6
            ,NULL                                                                                                             reserved_attribute7
            ,NULL                                                                                                             reserved_attribute8
            ,NULL                                                                                                             reserved_attribute9
            ,NULL                                                                                                             reserved_attribute10
            ,NULL                                                                                                             attribute_category
            ,NULL                                                                                                             attribute1
            ,NULL                                                                                                             attribute2
            ,NULL                                                                                                             attribute3
            ,NULL                                                                                                             attribute4
            ,NULL                                                                                                             attribute5
            ,NULL                                                                                                             attribute6
            ,NULL                                                                                                             attribute7
            ,NULL                                                                                                             attribute9
            ,NULL                                                                                                             attribute8
            ,null                                                                                                             attribute10 -- to split costs Labor, NonLabor and Misc in EDQ
            ,NULL                                                                                                             contract_number
            ,NULL                                                                                                             contract_name
            ,NULL                                                                                                             contract_id
            ,NULL                                                                                                             funding_source_number
            ,NULL                                                                                                             funding_source_name
            FROM  xxmx_ppm_projects_stg                                    ppa
                 ,apps.pa_expenditure_items_all@MXDM_NVIS_EXTRACT          peia
                 ,apps.pa_tasks@MXDM_NVIS_EXTRACT                          pt
                 ,apps.hr_all_organization_units@MXDM_NVIS_EXTRACT         haou1
                 ,apps.pa_cost_distribution_lines_all@MXDM_NVIS_EXTRACT    pcdla
                 --,apps.gl_code_combinations@MXDM_NVIS_EXTRACT gcc
            WHERE ppa.project_id                    = peia.project_id
--              AND peia.cc_cross_charge_type <> 'IC'
              and pt.project_id = ppa.project_id
              AND pt.project_id                     = peia.project_id
              AND pt.task_id   (+)                     = peia.task_id
              AND pcdla.expenditure_item_id         = peia.expenditure_item_id
              AND pcdla.project_id                  = peia.project_id
              AND pt.task_id                        = pcdla.task_id
              AND peia.org_id                       = haou1.organization_id
            --AND   peia.org_id                       = haou1.organization_id
            --AND   peia.expenditure_id               = pea.expenditure_id
            AND   ( pt.completion_date              IS NULL
                    OR pt.completion_date           > SYSDATE)   
            --and peia.EXPENDITURE_ITEM_ID=56028655        
            AND NOT EXISTS ( SELECT 1 FROM apps.pa_tasks@MXDM_NVIS_EXTRACT b WHERE b.parent_task_id=pt.task_id)
            --AND peia.expenditure_item_date >= to_date('01-JAN-2020','DD-MON-RRRR')
            /*AND   TO_CHAR(TO_DATE(pcdla.gl_period_name,'Mon-RR'),'RRRR') IN( SELECT TO_CHAR(TO_DATE(parameter_value,'Mon-RR'),'RRRR') 
                                                                                from xxmx_migration_parameters
                                                                                where parameter_code  = 'GL_PERIOD_NAME'
                                                                                and application = 'PPM')*/
            AND  pcdla.gl_date BETWEEN TO_DATE(gvv_migration_date_from,'DD-MM-RRRR') AND TO_DATE(gvv_migration_date_to,'DD-MM-RRRR')  
            AND system_linkage_function in (select parameter_value
                                                  from xxmx_migration_parameters
                                                  where application= 'PPM'
                                                  and application_suite= 'FIN'
                                                  and parameter_code = 'EXP_SYSTEM_LINK_TYPE'
                                                  and sub_entity = 'LABOUR_COST'
                                                  and enabled_flag = 'Y'
                                                  )                    
                    --AND pcdla.project_id = 2073
                    )
            GROUP BY
            Transaction_type --  LABOR, NONLABOR
                ,business_unit --Nullify we consider BU based on Project Number
                ,org_id
                ,user_transaction_source
                ,transaction_source_id
                ,document_name
                ,document_id
                ,doc_entry_name
                ,doc_entry_id
                ,exp_batch_name
                ,batch_ending_date
                ,batch_description
                ,expenditure_item_date
                ,person_number
                ,person_name
                ,person_id
                ,hcm_assignment_name
                ,hcm_assignment_id
                ,project_number
                ,project_name
                ,project_id
                ,task_number
                ,task_name
                ,task_id
                ,expenditure_type
                ,expenditure_type_id
                ,organization_name                                                               --Organization_name
                ,organization_id
                ,non_labor_resource
                ,non_labor_resource_id
                ,non_labor_resource_org
                ,non_labor_resource_org_id
                ,quantity            
                ,unit_of_measure_name
                ,unit_of_measure
                ,work_type
                ,work_type_id
                ,billable_flag
                ,capitalizable_flag
                ,accrual_flag
                ,supplier_number
                ,supplier_name
                ,vendor_id
                ,inventory_item_name
                ,inventory_item_id
                ,orig_transaction_reference
                ,unmatched_negative_txn_flag
                ,reversed_orig_txn_reference
                ,expenditure_comment
                ,gl_date
                ,denom_currency_code
                ,denom_currency
                ,raw_cost_cr_ccid
                ,raw_cost_cr_account
                ,raw_cost_dr_ccid
                ,raw_cost_dr_account
                ,burdened_cost_cr_ccid
                ,burdened_cost_cr_account
                ,burdened_cost_dr_ccid
                ,burdened_cost_dr_account
                ,burden_cost_cr_ccid
                ,burden_cost_cr_account
                ,burden_cost_dr_ccid
                ,burden_cost_dr_account
                ,acct_currency_code
                ,acct_currency
                ,acct_rate_type 
                ,acct_rate_date
                ,acct_rate_date_type
                ,acct_exchange_rate
                ,acct_exchange_rounding_limit
                ,receipt_currency_code
                ,receipt_currency
                ,receipt_currency_amount
                ,receipt_exchange_rate
                ,converted_flag
                ,context_category
                ,user_def_attribute1
                ,user_def_attribute2
                ,user_def_attribute3
                ,user_def_attribute4
                ,user_def_attribute5
                ,user_def_attribute6
                ,user_def_attribute7
                ,user_def_attribute8
                ,user_def_attribute9
                ,user_def_attribute10
                ,reserved_attribute1
                ,reserved_attribute2
                ,reserved_attribute3
                ,reserved_attribute4
                ,reserved_attribute5
                ,reserved_attribute6
                ,reserved_attribute7
                ,reserved_attribute8
                ,reserved_attribute9
                ,reserved_attribute10
                ,attribute_category
                ,attribute1
                ,attribute2
                ,attribute3
                ,attribute4
                ,attribute5
                ,attribute6
                ,attribute7
                ,attribute9
                ,attribute8
                ,attribute10 -- to split costs Labor, NonLabor and Misc in EDQ
                ,contract_number
                ,contract_name
                ,contract_id
                ,funding_source_number
                ,funding_source_name;
       --
       --**********************
       --** Record Declarations
       --**********************
       --
        TYPE pa_costs_tbl IS TABLE OF pa_costs_cur%ROWTYPE INDEX BY BINARY_INTEGER;
        pa_costs_tb  pa_costs_tbl;

        TYPE pa_costs_dtl_tbl IS TABLE OF src_pa_cost_dtl%ROWTYPE INDEX BY BINARY_INTEGER;
        pa_costs_dtl_tb  pa_costs_dtl_tbl;



       --
       --************************
       --** Constant Declarations
       --************************
       --
        cv_ProcOrFuncName                   CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'src_pa_lbr_costs';
        cv_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_PPM_PRJ_LBRCOST_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'LABOUR_COST';
        gv_i_BusinessEntity                                 VARCHAR2(100)     := 'PRJ_COST';


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

        gvv_cost_ext_type := xxmx_utilities_pkg.get_single_parameter_value(
                        pt_i_ApplicationSuite           =>     gct_ApplicationSuite
                        ,pt_i_Application                =>     gct_Application
                        ,pt_i_BusinessEntity             =>     'PRJ_COST'
                        ,pt_i_SubEntity                  =>     'ALL'
                        ,pt_i_ParameterCode              =>     'COST_EXT_TYPE');

        gvv_migration_date_from := xxmx_utilities_pkg.get_single_parameter_value(
                        pt_i_ApplicationSuite           =>     gct_ApplicationSuite
                        ,pt_i_Application                =>     gct_Application
                        ,pt_i_BusinessEntity             =>     'ALL'
                        ,pt_i_SubEntity                  =>     'ALL'
                        ,pt_i_ParameterCode              =>     'EXTRACT_START_DATE'
        );        
        --gvd_migration_date_from := TO_DATE(gvv_migration_date_from,'YYYY-MM-DD');


        gvv_migration_date_to := xxmx_utilities_pkg.get_single_parameter_value(
                        pt_i_ApplicationSuite           =>     gct_ApplicationSuite
                        ,pt_i_Application                =>     gct_Application
                        ,pt_i_BusinessEntity             =>     'ALL'
                        ,pt_i_SubEntity                  =>     'ALL'
                        ,pt_i_ParameterCode              =>     'EXTRACT_END_DATE'
        );        
       -- gvd_migration_date_to := TO_DATE(gvv_migration_date_to,'YYYY-MM-DD');
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
        FROM    XXMX_PPM_PRJ_LBRCOST_STG ;

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

            IF( UPPER(gvv_cost_ext_type) = 'SUMMARY') THEN 
                  OPEN pa_costs_cur;
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
                         ,pt_i_ModuleMessage       =>'Cursor Open src_pa_billing_events_cur'
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
                  FETCH pa_costs_cur  BULK COLLECT INTO pa_costs_tb LIMIT 1000;
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
                         ,pt_i_ModuleMessage       => 'Cursor pa_costs_cur Fetch into pa_costs_tb'
                         ,pt_i_OracleError         => gvt_ReturnMessage  );
                  --
                  EXIT WHEN pa_costs_tb.COUNT=0;
                  --
                  FORALL I IN 1..pa_costs_tb.COUNT SAVE EXCEPTIONS
                  --
                       INSERT INTO XXMX_PPM_PRJ_LBRCOST_STG (
                                           migration_set_id                 
                                          ,migration_set_name               
                                          ,migration_status                 
                                          ,transaction_type                
                                          ,business_unit                   
                                          ,org_id                          
                                          ,user_transaction_source         
                                          ,transaction_source_id           
                                          ,document_name                   
                                          ,document_id                     
                                          ,doc_entry_name                  
                                          ,doc_entry_id                    
                                          ,batch_ending_date               
                                          ,batch_description               
                                          ,expenditure_item_date           
                                          ,person_number                   
                                          ,person_name                     
                                          ,person_id                       
                                          ,hcm_assignment_name             
                                          ,hcm_assignment_id               
                                          ,project_number                  
                                          ,project_name                    
                                          ,project_id                      
                                          ,task_number                     
                                          ,task_name                       
                                          ,task_id                         
                                          ,expenditure_type                
                                          ,expenditure_type_id             
                                          ,organization_name               
                                          ,organization_id                 
                                         -- ,non_labor_resource              
                                          --,non_labor_resource_id           
                                          --,non_labor_resource_org          
                                          --,non_labor_resource_org_id       
                                          ,quantity                        
                                          ,unit_of_measure_name            
                                          ,unit_of_measure                 
                                          ,work_type                       
                                          ,work_type_id                    
                                          ,billable_flag                   
                                          ,capitalizable_flag              
                                          ,accrual_flag                    
                                         -- ,supplier_number                 
                                          --,supplier_name                   
                                          --,vendor_id                       
                                          --,inventory_item_name             
                                         -- ,inventory_item_id               
                                          ,orig_transaction_reference      
                                          ,unmatched_negative_txn_flag     
                                          ,reversed_orig_txn_reference     
                                          ,expenditure_comment             
                                          ,gl_date                         
                                          ,denom_currency_code             
                                          ,denom_currency                  
                                          ,denom_raw_cost                  
                                          ,denom_burdened_cost             
                                          ,raw_cost_cr_ccid                
                                          ,raw_cost_cr_account             
                                          ,raw_cost_dr_ccid                
                                          ,raw_cost_dr_account             
                                          ,burdened_cost_cr_ccid           
                                          ,burdened_cost_cr_account        
                                          ,burdened_cost_dr_ccid           
                                          ,burdened_cost_dr_account        
                                          ,burden_cost_cr_ccid             
                                          ,burden_cost_cr_account          
                                          ,burden_cost_dr_ccid             
                                          ,burden_cost_dr_account          
                                          ,acct_currency_code              
                                          ,acct_currency                   
                                          ,acct_raw_cost                   
                                          ,acct_burdened_cost              
                                          ,acct_rate_type                  
                                          ,acct_rate_date                  
                                          ,acct_rate_date_type             
                                          ,acct_exchange_rate              
                                          ,acct_exchange_rounding_limit    
                                          --,receipt_currency_code           
                                          --,receipt_currency                
                                          --,receipt_currency_amount         
                                         -- ,receipt_exchange_rate           
                                          ,converted_flag                  
                                          ,context_category                
                                          ,user_def_attribute1             
                                          ,user_def_attribute2             
                                          ,user_def_attribute3             
                                          ,user_def_attribute4             
                                          ,user_def_attribute5             
                                          ,user_def_attribute6             
                                          ,user_def_attribute7             
                                          ,user_def_attribute8             
                                          ,user_def_attribute9             
                                          ,user_def_attribute10            
                                          ,reserved_attribute1             
                                          ,reserved_attribute2             
                                          ,reserved_attribute3             
                                          ,reserved_attribute4             
                                          ,reserved_attribute5             
                                          ,reserved_attribute6             
                                          ,reserved_attribute7             
                                          ,reserved_attribute8             
                                          ,reserved_attribute9             
                                          ,reserved_attribute10            
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
                                          ,contract_number                 
                                          ,contract_name                   
                                          ,contract_id                     
                                          ,funding_source_number           
                                          ,funding_source_name             
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
                                  ,pa_costs_tb(i).transaction_type                
                                  ,pa_costs_tb(i).business_unit                   
                                  ,pa_costs_tb(i).org_id                          
                                  ,pa_costs_tb(i).user_transaction_source         
                                  ,pa_costs_tb(i).transaction_source_id           
                                  ,pa_costs_tb(i).document_name                   
                                  ,pa_costs_tb(i).document_id                     
                                  ,pa_costs_tb(i).doc_entry_name                  
                                  ,pa_costs_tb(i).doc_entry_id                    
                                  ,pa_costs_tb(i).batch_ending_date               
                                  ,pa_costs_tb(i).batch_description               
                                  ,pa_costs_tb(i).expenditure_item_date           
                                  ,pa_costs_tb(i).person_number                   
                                  ,pa_costs_tb(i).person_name                     
                                  ,pa_costs_tb(i).person_id                       
                                  ,pa_costs_tb(i).hcm_assignment_name             
                                  ,pa_costs_tb(i).hcm_assignment_id               
                                  ,pa_costs_tb(i).project_number                  
                                  ,pa_costs_tb(i).project_name                    
                                  ,pa_costs_tb(i).project_id                      
                                  ,pa_costs_tb(i).task_number                     
                                  ,pa_costs_tb(i).task_name                       
                                  ,pa_costs_tb(i).task_id                         
                                  ,pa_costs_tb(i).expenditure_type                
                                  ,pa_costs_tb(i).expenditure_type_id             
                                  ,pa_costs_tb(i).organization_name               
                                  ,pa_costs_tb(i).organization_id                 
                                  --,pa_costs_tb(i).non_labor_resource              
                                  --,pa_costs_tb(i).non_labor_resource_id           
                                  --,pa_costs_tb(i).non_labor_resource_org          
                                  --,pa_costs_tb(i).non_labor_resource_org_id       
                                  ,pa_costs_tb(i).quantity                        
                                  ,pa_costs_tb(i).unit_of_measure_name            
                                  ,pa_costs_tb(i).unit_of_measure                 
                                  ,pa_costs_tb(i).work_type                       
                                  ,pa_costs_tb(i).work_type_id                    
                                  ,pa_costs_tb(i).billable_flag                   
                                  ,pa_costs_tb(i).capitalizable_flag              
                                  ,pa_costs_tb(i).accrual_flag                    
                                  --,pa_costs_tb(i).supplier_number                 
                                  --,pa_costs_tb(i).supplier_name                   
                                  --,pa_costs_tb(i).vendor_id                       
                                  --,pa_costs_tb(i).inventory_item_name             
                                  --,pa_costs_tb(i).inventory_item_id               
                                  ,pa_costs_tb(i).orig_transaction_reference      
                                  ,pa_costs_tb(i).unmatched_negative_txn_flag     
                                  ,pa_costs_tb(i).reversed_orig_txn_reference     
                                  ,pa_costs_tb(i).expenditure_comment             
                                  ,pa_costs_tb(i).gl_date                         
                                  ,pa_costs_tb(i).denom_currency_code             
                                  ,pa_costs_tb(i).denom_currency                  
                                  ,pa_costs_tb(i).denom_raw_cost                  
                                  ,pa_costs_tb(i).denom_burdened_cost             
                                  ,pa_costs_tb(i).raw_cost_cr_ccid                
                                  ,pa_costs_tb(i).raw_cost_cr_account             
                                  ,pa_costs_tb(i).raw_cost_dr_ccid                
                                  ,pa_costs_tb(i).raw_cost_dr_account             
                                  ,pa_costs_tb(i).burdened_cost_cr_ccid           
                                  ,pa_costs_tb(i).burdened_cost_cr_account        
                                  ,pa_costs_tb(i).burdened_cost_dr_ccid           
                                  ,pa_costs_tb(i).burdened_cost_dr_account        
                                  ,pa_costs_tb(i).burden_cost_cr_ccid             
                                  ,pa_costs_tb(i).burden_cost_cr_account           
                                  ,pa_costs_tb(i).burden_cost_dr_ccid             
                                  ,pa_costs_tb(i).burden_cost_dr_account          
                                  ,pa_costs_tb(i).acct_currency_code              
                                  ,pa_costs_tb(i).acct_currency                   
                                  ,pa_costs_tb(i).acct_raw_cost                   
                                  ,pa_costs_tb(i).acct_burdened_cost              
                                  ,pa_costs_tb(i).acct_rate_type                  
                                  ,pa_costs_tb(i).acct_rate_date                  
                                  ,pa_costs_tb(i).acct_rate_date_type             
                                  ,pa_costs_tb(i).acct_exchange_rate              
                                  ,pa_costs_tb(i).acct_exchange_rounding_limit    
                                  --,pa_costs_tb(i).receipt_currency_code           
                                  --,pa_costs_tb(i).receipt_currency                
                                  --,pa_costs_tb(i).receipt_currency_amount         
                                  --,pa_costs_tb(i).receipt_exchange_rate           
                                  ,pa_costs_tb(i).converted_flag                  
                                  ,pa_costs_tb(i).context_category                
                                  ,pa_costs_tb(i).user_def_attribute1             
                                  ,pa_costs_tb(i).user_def_attribute2             
                                  ,pa_costs_tb(i).user_def_attribute3             
                                  ,pa_costs_tb(i).user_def_attribute4             
                                  ,pa_costs_tb(i).user_def_attribute5             
                                  ,pa_costs_tb(i).user_def_attribute6             
                                  ,pa_costs_tb(i).user_def_attribute7             
                                  ,pa_costs_tb(i).user_def_attribute8             
                                  ,pa_costs_tb(i).user_def_attribute9             
                                  ,pa_costs_tb(i).user_def_attribute10            
                                  ,pa_costs_tb(i).reserved_attribute1             
                                  ,pa_costs_tb(i).reserved_attribute2             
                                  ,pa_costs_tb(i).reserved_attribute3             
                                  ,pa_costs_tb(i).reserved_attribute4             
                                  ,pa_costs_tb(i).reserved_attribute5             
                                  ,pa_costs_tb(i).reserved_attribute6             
                                  ,pa_costs_tb(i).reserved_attribute7             
                                  ,pa_costs_tb(i).reserved_attribute8             
                                  ,pa_costs_tb(i).reserved_attribute9             
                                  ,pa_costs_tb(i).reserved_attribute10            
                                  ,pa_costs_tb(i).attribute_category              
                                  ,pa_costs_tb(i).attribute1                      
                                  ,pa_costs_tb(i).attribute2                      
                                  ,pa_costs_tb(i).attribute3                      
                                  ,pa_costs_tb(i).attribute4                      
                                  ,pa_costs_tb(i).attribute5                      
                                  ,pa_costs_tb(i).attribute6                      
                                  ,pa_costs_tb(i).attribute7                      
                                  ,pa_costs_tb(i).attribute8                      
                                  ,pa_costs_tb(i).attribute9                      
                                  ,pa_costs_tb(i).attribute10                     
                                  ,pa_costs_tb(i).contract_number                 
                                  ,pa_costs_tb(i).contract_name                   
                                  ,pa_costs_tb(i).contract_id                     
                                  ,pa_costs_tb(i).funding_source_number           
                                  ,pa_costs_tb(i).funding_source_name             
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
                                    ,pt_i_ModuleMessage       => 'Close the Cursor pa_costs_cur'
                                    ,pt_i_OracleError         => gvt_ReturnMessage       );   
                   --


                   IF pa_costs_cur%ISOPEN
                   THEN
                        --
                           CLOSE pa_costs_cur;
                        --
                   END IF;

            ELSIF ( UPPER(gvv_cost_ext_type) = 'DETAIL')   
            THEN

                  OPEN src_pa_cost_dtl;
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
                         ,pt_i_ModuleMessage       =>'Cursor Open src_pa_cost_dtl'
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
                  FETCH src_pa_cost_dtl  BULK COLLECT INTO pa_costs_dtl_tb LIMIT 1000;
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
                         ,pt_i_ModuleMessage       => 'Cursor src_pa_cost_dtl Fetch into pa_costs_dtl_tb'
                         ,pt_i_OracleError         => gvt_ReturnMessage  );
                  --
                  EXIT WHEN pa_costs_dtl_tb.COUNT=0;
                  --
                  FORALL I IN 1..pa_costs_dtl_tb.COUNT SAVE EXCEPTIONS
                  --
                       INSERT INTO XXMX_PPM_PRJ_LBRCOST_STG (
                                           migration_set_id                 
                                          ,migration_set_name               
                                          ,migration_status                 
                                          ,transaction_type                
                                          ,business_unit                   
                                          ,org_id                          
                                          ,user_transaction_source         
                                          ,transaction_source_id           
                                          ,document_name                   
                                          ,document_id                     
                                          ,doc_entry_name                  
                                          ,doc_entry_id                    
                                          ,batch_ending_date               
                                          ,batch_description               
                                          ,expenditure_item_date           
                                          ,person_number                   
                                          ,person_name                     
                                          ,person_id                       
                                          ,hcm_assignment_name             
                                          ,hcm_assignment_id               
                                          ,project_number                  
                                          ,project_name                    
                                          ,project_id                      
                                          ,task_number                     
                                          ,task_name                       
                                          ,task_id                         
                                          ,expenditure_type                
                                          ,expenditure_type_id             
                                          ,organization_name               
                                          ,organization_id                 
                                         -- ,non_labor_resource              
                                          --,non_labor_resource_id           
                                          --,non_labor_resource_org          
                                          --,non_labor_resource_org_id       
                                          ,quantity                        
                                          ,unit_of_measure_name            
                                          ,unit_of_measure                 
                                          ,work_type                       
                                          ,work_type_id                    
                                          ,billable_flag                   
                                          ,capitalizable_flag              
                                          ,accrual_flag                    
                                         -- ,supplier_number                 
                                          --,supplier_name                   
                                          --,vendor_id                       
                                          --,inventory_item_name             
                                         -- ,inventory_item_id               
                                          ,orig_transaction_reference      
                                          ,unmatched_negative_txn_flag     
                                          ,reversed_orig_txn_reference     
                                          ,expenditure_comment             
                                          ,gl_date                         
                                          ,denom_currency_code             
                                          ,denom_currency                  
                                          ,denom_raw_cost                  
                                          ,denom_burdened_cost             
                                          ,raw_cost_cr_ccid                
                                          ,raw_cost_cr_account             
                                          ,raw_cost_dr_ccid                
                                          ,raw_cost_dr_account             
                                          ,burdened_cost_cr_ccid           
                                          ,burdened_cost_cr_account        
                                          ,burdened_cost_dr_ccid           
                                          ,burdened_cost_dr_account        
                                          ,burden_cost_cr_ccid             
                                          ,burden_cost_cr_account          
                                          ,burden_cost_dr_ccid             
                                          ,burden_cost_dr_account          
                                          ,acct_currency_code              
                                          ,acct_currency                   
                                          ,acct_raw_cost                   
                                          ,acct_burdened_cost              
                                          ,acct_rate_type                  
                                          ,acct_rate_date                  
                                          ,acct_rate_date_type             
                                          ,acct_exchange_rate              
                                          ,acct_exchange_rounding_limit    
                                          --,receipt_currency_code           
                                          --,receipt_currency                
                                          --,receipt_currency_amount         
                                         -- ,receipt_exchange_rate           
                                          ,converted_flag                  
                                          ,context_category                
                                          ,user_def_attribute1             
                                          ,user_def_attribute2             
                                          ,user_def_attribute3             
                                          ,user_def_attribute4             
                                          ,user_def_attribute5             
                                          ,user_def_attribute6             
                                          ,user_def_attribute7             
                                          ,user_def_attribute8             
                                          ,user_def_attribute9             
                                          ,user_def_attribute10            
                                          ,reserved_attribute1             
                                          ,reserved_attribute2             
                                          ,reserved_attribute3             
                                          ,reserved_attribute4             
                                          ,reserved_attribute5             
                                          ,reserved_attribute6             
                                          ,reserved_attribute7             
                                          ,reserved_attribute8             
                                          ,reserved_attribute9             
                                          ,reserved_attribute10            
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
                                          ,contract_number                 
                                          ,contract_name                   
                                          ,contract_id                     
                                          ,funding_source_number           
                                          ,funding_source_name             
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
                                  ,pa_costs_dtl_tb(i).transaction_type                
                                  ,pa_costs_dtl_tb(i).business_unit                   
                                  ,pa_costs_dtl_tb(i).org_id                          
                                  ,pa_costs_dtl_tb(i).user_transaction_source         
                                  ,pa_costs_dtl_tb(i).transaction_source_id           
                                  ,pa_costs_dtl_tb(i).document_name                   
                                  ,pa_costs_dtl_tb(i).document_id                     
                                  ,pa_costs_dtl_tb(i).doc_entry_name                  
                                  ,pa_costs_dtl_tb(i).doc_entry_id                    
                                  ,pa_costs_dtl_tb(i).batch_ending_date               
                                  ,pa_costs_dtl_tb(i).batch_description               
                                  ,pa_costs_dtl_tb(i).expenditure_item_date           
                                  ,pa_costs_dtl_tb(i).person_number                   
                                  ,pa_costs_dtl_tb(i).person_name                     
                                  ,pa_costs_dtl_tb(i).person_id                       
                                  ,pa_costs_dtl_tb(i).hcm_assignment_name             
                                  ,pa_costs_dtl_tb(i).hcm_assignment_id               
                                  ,pa_costs_dtl_tb(i).project_number                  
                                  ,pa_costs_dtl_tb(i).project_name                    
                                  ,pa_costs_dtl_tb(i).project_id                      
                                  ,pa_costs_dtl_tb(i).task_number                     
                                  ,pa_costs_dtl_tb(i).task_name                       
                                  ,pa_costs_dtl_tb(i).task_id                         
                                  ,pa_costs_dtl_tb(i).expenditure_type                
                                  ,pa_costs_dtl_tb(i).expenditure_type_id             
                                  ,pa_costs_dtl_tb(i).organization_name               
                                  ,pa_costs_dtl_tb(i).organization_id                 
                                  --,pa_costs_dtl_tb(i).non_labor_resource              
                                  --,pa_costs_dtl_tb(i).non_labor_resource_id           
                                  --,pa_costs_dtl_tb(i).non_labor_resource_org          
                                  --,pa_costs_dtl_tb(i).non_labor_resource_org_id       
                                  ,pa_costs_dtl_tb(i).quantity                        
                                  ,pa_costs_dtl_tb(i).unit_of_measure_name            
                                  ,pa_costs_dtl_tb(i).unit_of_measure                 
                                  ,pa_costs_dtl_tb(i).work_type                       
                                  ,pa_costs_dtl_tb(i).work_type_id                    
                                  ,pa_costs_dtl_tb(i).billable_flag                   
                                  ,pa_costs_dtl_tb(i).capitalizable_flag              
                                  ,pa_costs_dtl_tb(i).accrual_flag                    
                                  --,pa_costs_dtl_tb(i).supplier_number                 
                                  --,pa_costs_dtl_tb(i).supplier_name                   
                                  --,pa_costs_dtl_tb(i).vendor_id                       
                                  --,pa_costs_dtl_tb(i).inventory_item_name             
                                  --,pa_costs_dtl_tb(i).inventory_item_id               
                                  ,pa_costs_dtl_tb(i).orig_transaction_reference      
                                  ,pa_costs_dtl_tb(i).unmatched_negative_txn_flag     
                                  ,pa_costs_dtl_tb(i).reversed_orig_txn_reference     
                                  ,pa_costs_dtl_tb(i).expenditure_comment             
                                  ,pa_costs_dtl_tb(i).gl_date                         
                                  ,pa_costs_dtl_tb(i).denom_currency_code             
                                  ,pa_costs_dtl_tb(i).denom_currency                  
                                  ,pa_costs_dtl_tb(i).denom_raw_cost                  
                                  ,pa_costs_dtl_tb(i).denom_burdened_cost             
                                  ,pa_costs_dtl_tb(i).raw_cost_cr_ccid                
                                  ,pa_costs_dtl_tb(i).raw_cost_cr_account             
                                  ,pa_costs_dtl_tb(i).raw_cost_dr_ccid                
                                  ,pa_costs_dtl_tb(i).raw_cost_dr_account             
                                  ,pa_costs_dtl_tb(i).burdened_cost_cr_ccid           
                                  ,pa_costs_dtl_tb(i).burdened_cost_cr_account        
                                  ,pa_costs_dtl_tb(i).burdened_cost_dr_ccid           
                                  ,pa_costs_dtl_tb(i).burdened_cost_dr_account        
                                  ,pa_costs_dtl_tb(i).burden_cost_cr_ccid             
                                  ,pa_costs_dtl_tb(i).burden_cost_cr_account           
                                  ,pa_costs_dtl_tb(i).burden_cost_dr_ccid             
                                  ,pa_costs_dtl_tb(i).burden_cost_dr_account          
                                  ,pa_costs_dtl_tb(i).acct_currency_code              
                                  ,pa_costs_dtl_tb(i).acct_currency                   
                                  ,pa_costs_dtl_tb(i).acct_raw_cost                   
                                  ,pa_costs_dtl_tb(i).acct_burdened_cost              
                                  ,pa_costs_dtl_tb(i).acct_rate_type                  
                                  ,pa_costs_dtl_tb(i).acct_rate_date                  
                                  ,pa_costs_dtl_tb(i).acct_rate_date_type             
                                  ,pa_costs_dtl_tb(i).acct_exchange_rate              
                                  ,pa_costs_dtl_tb(i).acct_exchange_rounding_limit    
                                  --,pa_costs_dtl_tb(i).receipt_currency_code           
                                  --,pa_costs_dtl_tb(i).receipt_currency                
                                  --,pa_costs_dtl_tb(i).receipt_currency_amount         
                                  --,pa_costs_dtl_tb(i).receipt_exchange_rate           
                                  ,pa_costs_dtl_tb(i).converted_flag                  
                                  ,pa_costs_dtl_tb(i).context_category                
                                  ,pa_costs_dtl_tb(i).user_def_attribute1             
                                  ,pa_costs_dtl_tb(i).user_def_attribute2             
                                  ,pa_costs_dtl_tb(i).user_def_attribute3             
                                  ,pa_costs_dtl_tb(i).user_def_attribute4             
                                  ,pa_costs_dtl_tb(i).user_def_attribute5             
                                  ,pa_costs_dtl_tb(i).user_def_attribute6             
                                  ,pa_costs_dtl_tb(i).user_def_attribute7             
                                  ,pa_costs_dtl_tb(i).user_def_attribute8             
                                  ,pa_costs_dtl_tb(i).user_def_attribute9             
                                  ,pa_costs_dtl_tb(i).user_def_attribute10            
                                  ,pa_costs_dtl_tb(i).reserved_attribute1             
                                  ,pa_costs_dtl_tb(i).reserved_attribute2             
                                  ,pa_costs_dtl_tb(i).reserved_attribute3             
                                  ,pa_costs_dtl_tb(i).reserved_attribute4             
                                  ,pa_costs_dtl_tb(i).reserved_attribute5             
                                  ,pa_costs_dtl_tb(i).reserved_attribute6             
                                  ,pa_costs_dtl_tb(i).reserved_attribute7             
                                  ,pa_costs_dtl_tb(i).reserved_attribute8             
                                  ,pa_costs_dtl_tb(i).reserved_attribute9             
                                  ,pa_costs_dtl_tb(i).reserved_attribute10            
                                  ,pa_costs_dtl_tb(i).attribute_category              
                                  ,pa_costs_dtl_tb(i).attribute1                      
                                  ,pa_costs_dtl_tb(i).attribute2                      
                                  ,pa_costs_dtl_tb(i).attribute3                      
                                  ,pa_costs_dtl_tb(i).attribute4                      
                                  ,pa_costs_dtl_tb(i).attribute5                      
                                  ,pa_costs_dtl_tb(i).attribute6                      
                                  ,pa_costs_dtl_tb(i).attribute7                      
                                  ,pa_costs_dtl_tb(i).attribute8                      
                                  ,pa_costs_dtl_tb(i).attribute9                      
                                  ,pa_costs_dtl_tb(i).attribute10                     
                                  ,pa_costs_dtl_tb(i).contract_number                 
                                  ,pa_costs_dtl_tb(i).contract_name                   
                                  ,pa_costs_dtl_tb(i).contract_id                     
                                  ,pa_costs_dtl_tb(i).funding_source_number           
                                  ,pa_costs_dtl_tb(i).funding_source_name             
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
                                    ,pt_i_ModuleMessage       => 'Close the Cursor src_pa_cost_dtl'
                                    ,pt_i_OracleError         => gvt_ReturnMessage       );   
                   --


                   IF src_pa_cost_dtl%ISOPEN
                   THEN
                        --
                           CLOSE src_pa_cost_dtl;
                        --
                   END IF;

               ELSE 
                  --
                  gvv_ProgressIndicator := '0090';
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
                                    ,pt_i_ModuleMessage       => 'Parameter Cost_ext_type is mandatory - Summary or Detail Extract'
                                    ,pt_i_OracleError         => gvt_ReturnMessage       );   
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
        IF pa_costs_cur%ISOPEN
        THEN
            --
            CLOSE pa_costs_cur;
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

         IF pa_costs_cur%ISOPEN
         THEN
             --
             CLOSE pa_costs_cur;
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



     END src_pa_lbr_costs;


   /*********************************************************
   --------------------src_pa_nonlbr_costs-----------------------
   -- Extracts Project non Labour Cost from EBS
   ----------------------------------------------------------
   **********************************************************/

   PROCEDURE src_pa_nonlbr_costs
                     (pt_i_MigrationSetID              IN      xxmx_migration_headers.migration_set_id%TYPE
                     ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE)
     AS   

          --
          --**********************
          --** Cursor Declarations
          --**********************
          --
            CURSOR pa_costs_cur
            IS
            select       
                'NONLABOR' Transaction_type --  LABOR, NONLABOR
                ,business_unit --Nullify we consider BU based on Project Number
                ,org_id
                ,user_transaction_source
                ,transaction_source_id
                ,document_name
                ,document_id
                ,doc_entry_name
                ,doc_entry_id
                ,exp_batch_name
                ,batch_ending_date
                ,batch_description
                ,expenditure_item_date
                ,person_number
                ,person_name
                ,person_id
                ,hcm_assignment_name
                ,hcm_assignment_id
                ,project_number
                ,project_name
                ,project_id
                ,task_number
                ,task_name
                ,task_id
                ,expenditure_type
                ,expenditure_type_id
                ,organization_name                                                               --Organization_name
                ,organization_id
                ,non_labor_resource
                ,non_labor_resource_id
                ,non_labor_resource_org
                ,non_labor_resource_org_id
                ,quantity            
                ,unit_of_measure_name
                ,unit_of_measure
                ,work_type
                ,work_type_id
                ,billable_flag
                ,capitalizable_flag
                ,accrual_flag
                ,supplier_number
                ,supplier_name
                ,vendor_id
                ,inventory_item_name
                ,inventory_item_id
                ,orig_transaction_reference
                ,unmatched_negative_txn_flag
                ,reversed_orig_txn_reference
                ,expenditure_comment
                ,gl_date
                ,denom_currency_code
                ,denom_currency
                ,sum(denom_raw_cost)        AS denom_raw_cost                                          --denom_raw_cost
                ,sum(denom_burdened_cost)   AS denom_burdened_cost                                --denom_burdened_cost
                ,raw_cost_cr_ccid
                ,raw_cost_cr_account
                ,raw_cost_dr_ccid
                ,raw_cost_dr_account
                ,burdened_cost_cr_ccid
                ,burdened_cost_cr_account
                ,burdened_cost_dr_ccid
                ,burdened_cost_dr_account
                ,burden_cost_cr_ccid
                ,burden_cost_cr_account
                ,burden_cost_dr_ccid
                ,burden_cost_dr_account
                ,acct_currency_code
                ,acct_currency
                ,sum(acct_raw_cost)             AS acct_raw_cost -- based on UAT recon from business recon report
                ,sum(acct_burdened_cost)        AS acct_burdened_cost
                ,acct_rate_type 
                ,acct_rate_date
                ,acct_rate_date_type
                ,acct_exchange_rate
                ,acct_exchange_rounding_limit
                ,receipt_currency_code
                ,receipt_currency
                ,receipt_currency_amount
                ,receipt_exchange_rate
                ,converted_flag
                ,context_category
                ,user_def_attribute1
                ,user_def_attribute2
                ,user_def_attribute3
                ,user_def_attribute4
                ,user_def_attribute5
                ,user_def_attribute6
                ,user_def_attribute7
                ,user_def_attribute8
                ,user_def_attribute9
                ,user_def_attribute10
                ,reserved_attribute1
                ,reserved_attribute2
                ,reserved_attribute3
                ,reserved_attribute4
                ,reserved_attribute5
                ,reserved_attribute6
                ,reserved_attribute7
                ,reserved_attribute8
                ,reserved_attribute9
                ,reserved_attribute10
                ,attribute_category
                ,attribute1
                ,attribute2
                ,attribute3
                ,attribute4
                ,attribute5
                ,attribute6
                ,attribute7
                ,attribute9
                ,attribute8
                ,attribute10 -- to split costs Labor, NonLabor and Misc in EDQ
                ,contract_number
                ,contract_name
                ,contract_id
                ,funding_source_number
                ,funding_source_name
          from
        (SELECT distinct 
             NULL                                                                             AS transaction_type --  LABOR, NONLABOR
            ,haou1.name                                                                       AS business_unit --Nullify as we consider BU based on Project Number
            ,NULL                                                                             AS org_id
            ,null                                                                             AS user_transaction_source
            ,NULL                                                                             AS transaction_source_id
            ,NULL                                                                             AS document_name
            ,NULL                                                                             AS document_id
            ,NULL                                                                             AS doc_entry_name
            ,NULL                                                                             AS doc_entry_id
            ,NULL                                                                             AS exp_batch_name
            ,NULL                                                                             AS batch_ending_date
            ,NULL                                                                             AS batch_description
            ,NULL                                                                             AS expenditure_item_date
            ,NULL                                                                             AS person_number
            ,NULL                                                                             AS person_name
            ,NULL                                                                             AS person_id
            ,NULL                                                                             AS hcm_assignment_name
            ,NULL                                                                             As hcm_assignment_id
            ,ppa.project_number                                                               AS project_number
            ,ppa.project_name                                                                 AS project_name
            ,ppa.project_id                                                                   AS project_id
            ,NULL                                                                             AS task_number
            ,NULL                                                                             AS task_name
            ,NULL                                                                             AS task_id
            ,peia.expenditure_type                                                            AS expenditure_type
            ,NULL                                                                             AS expenditure_type_id
            ,(select haou2.name 
                from apps.hr_all_organization_units@MXDM_NVIS_EXTRACT haou2 
                     ,apps.pa_expenditures_all@MXDM_NVIS_EXTRACT pea1
                where haou2.organization_id= NVL (peia.override_to_organization_id, pea1.incurred_by_organization_id)
                and peia.expenditure_id = pea1.expenditure_id)                                AS organization_name  
            ,NULL                                                                             AS organization_id
            ,peia.non_labor_resource                                                          AS non_labor_resource
            ,NULL                                                                             AS non_labor_resource_id
            ,(select haou2.name 
                from apps.hr_all_organization_units@MXDM_NVIS_EXTRACT haou2 
                where haou2.organization_id= peia.organization_id
                  )                                                                           AS non_labor_resource_org
            ,NULL                                                                             AS non_labor_resource_org_id
            ,peia.quantity                                                                    AS quantity            
            ,NULL                                                                             AS unit_of_measure_name
            ,peia.unit_of_measure                                                             AS unit_of_measure
            ,NULL                                                                             AS work_type
            ,NULL                                                                             AS work_type_id
            ,NULL                                                                             AS billable_flag
            ,NULL                                                                             AS capitalizable_flag
            ,NULL                                                                             AS accrual_flag
            ,NULL                                                                             As supplier_number
            ,NULL                                                                             AS supplier_name
            ,NULL                                                                             AS vendor_id
            ,NULL                                                                             As inventory_item_name
            ,NULL                                                                             AS inventory_item_id
            ,NULL                                                                             AS orig_transaction_reference
            ,NULL                                                                             AS unmatched_negative_txn_flag
            ,NULL                                                                             AS reversed_orig_txn_reference
            ,NULL                                                                             AS expenditure_comment
            ,NULL                                                                             AS gl_date
            ,pcdla.denom_currency_code                                                        AS denom_currency_code
            ,NULL                                                                             AS denom_currency
            ,pcdla.denom_raw_cost                                                             AS denom_raw_cost
            ,peia.denom_burdened_cost                                                         AS denom_burdened_cost
            ,NULL                                                                             AS raw_cost_cr_ccid
            ,NULL                                                                             AS raw_cost_cr_account
            ,NULL                                                                             AS raw_cost_dr_ccid
            ,NULL                                                                             AS raw_cost_dr_account
            ,NULL                                                                             AS burdened_cost_cr_ccid
            ,NULL                                                                             AS burdened_cost_cr_account
            ,NULL                                                                             AS burdened_cost_dr_ccid
            ,NULL                                                                             AS burdened_cost_dr_account
            ,NULL                                                                             AS burden_cost_cr_ccid
            ,NULL                                                                             AS burden_cost_cr_account
            ,NULL                                                                             AS burden_cost_dr_ccid
            ,NULL                                                                             AS burden_cost_dr_account
            ,peia.acct_currency_code                                                          AS acct_currency_code
            ,NULL                                                                             AS acct_currency
            ,pcdla.acct_raw_cost                                                              AS acct_raw_cost  -- based on UAT recon from business recon report
            ,peia.acct_burdened_cost                                                          AS acct_burdened_cost
            ,peia.acct_rate_type                                                              AS acct_rate_type 
            ,peia.acct_rate_date                                                              AS acct_rate_date
            ,NULL                                                                             AS acct_rate_date_type
            ,peia.acct_exchange_rate                                                          AS acct_exchange_rate
            ,NULL                                                                             AS acct_exchange_rounding_limit
            ,NULL                                                                             AS receipt_currency_code
            ,NULL                                                                             AS receipt_currency
            ,NULL                                                                             AS receipt_currency_amount
            ,NULL                                                                             AS receipt_exchange_rate
            ,peia.converted_flag                                                              AS converted_flag
            ,NULL                                                                             As context_category
            ,NULL                                                                             AS user_def_attribute1
            ,NULL                                                                             AS user_def_attribute2
            ,NULL                                                                             AS user_def_attribute3
            ,NULL                                                                             AS user_def_attribute4
            ,NULL                                                                             AS user_def_attribute5
            ,NULL                                                                             AS user_def_attribute6
            ,NULL                                                                             AS user_def_attribute7
            ,NULL                                                                             AS user_def_attribute8
            ,NULL                                                                             AS user_def_attribute9
            ,NULL                                                                             AS user_def_attribute10
            ,NULL                                                                             As reserved_attribute1
            ,NULL                                                                             AS reserved_attribute2
            ,NULL                                                                             AS reserved_attribute3
            ,NULL                                                                             AS reserved_attribute4
            ,NULL                                                                             AS reserved_attribute5
            ,NULL                                                                             AS reserved_attribute6
            ,NULL                                                                             AS reserved_attribute7
            ,NULL                                                                             AS reserved_attribute8
            ,NULL                                                                             AS reserved_attribute9
            ,NULL                                                                             AS reserved_attribute10
            ,NULL                                                                             AS attribute_category
            ,NULL                                                                             AS attribute1
            ,NULL                                                                             AS attribute2
            ,NULL                                                                             AS attribute3
            ,NULL                                                                             AS attribute4
            ,NULL                                                                             AS attribute5
            ,NULL                                                                             AS attribute6
            ,NULL                                                                             AS attribute7
            ,NULL                                                                             AS attribute9
            ,NULL                                                                             AS attribute8
            ,null                                                                             AS attribute10 -- to split costs Labor, NonLabor and Misc in EDQ
            ,NULL                                                                             AS contract_number
            ,NULL                                                                             AS contract_name
            ,NULL                                                                             AS contract_id
            ,NULL                                                                             AS funding_source_number
            ,NULL                                                                             AS funding_source_name
            FROM  xxmx_ppm_projects_stg                                    ppa
                 ,apps.pa_expenditure_items_all@MXDM_NVIS_EXTRACT          peia
                 ,apps.hr_all_organization_units@MXDM_NVIS_EXTRACT         haou1
                 ,apps.pa_cost_distribution_lines_all@MXDM_NVIS_EXTRACT    pcdla
            WHERE ppa.project_id                    = peia.project_id
            AND pcdla.expenditure_item_id         = peia.expenditure_item_id
            AND pcdla.project_id                  = peia.project_id
            AND peia.org_id                       = haou1.organization_id
            AND  gl_date   BETWEEN TO_DATE(gvv_migration_date_from,'DD-MM-RRRR') AND TO_DATE(gvv_migration_date_to,'DD-MM-RRRR')
            AND system_linkage_function in (select parameter_value
                                                  from xxmx_migration_parameters
                                                  where application= 'PPM'
                                                  and application_suite= 'FIN'
                                                  and parameter_code = 'EXP_SYSTEM_LINK_TYPE'
                                                  and sub_entity = 'NON_LBR_COST'
                                                  and enabled_flag = 'Y'
                                                  ) 

            ) src
             GROUP BY
                 Transaction_type --  LABOR, NONLABOR
                ,business_unit --Nullify we consider BU based on Project Number
                ,org_id
                ,user_transaction_source
                ,transaction_source_id
                ,document_name
                ,document_id
                ,doc_entry_name
                ,doc_entry_id
                ,exp_batch_name
                ,batch_ending_date
                ,batch_description
                ,expenditure_item_date
                ,person_number
                ,person_name
                ,person_id
                ,hcm_assignment_name
                ,hcm_assignment_id
                ,project_number
                ,project_name
                ,project_id
                ,task_number
                ,task_name
                ,task_id
                ,expenditure_type
                ,expenditure_type_id
                ,organization_name                                                               --Organization_name
                ,organization_id
                ,non_labor_resource
                ,non_labor_resource_id
                ,non_labor_resource_org
                ,non_labor_resource_org_id
                ,quantity            
                ,unit_of_measure_name
                ,unit_of_measure
                ,work_type
                ,work_type_id
                ,billable_flag
                ,capitalizable_flag
                ,accrual_flag
                ,supplier_number
                ,supplier_name
                ,vendor_id
                ,inventory_item_name
                ,inventory_item_id
                ,orig_transaction_reference
                ,unmatched_negative_txn_flag
                ,reversed_orig_txn_reference
                ,expenditure_comment
                ,gl_date
                ,denom_currency_code
                ,denom_currency
                ,raw_cost_cr_ccid
                ,raw_cost_cr_account
                ,raw_cost_dr_ccid
                ,raw_cost_dr_account
                ,burdened_cost_cr_ccid
                ,burdened_cost_cr_account
                ,burdened_cost_dr_ccid
                ,burdened_cost_dr_account
                ,burden_cost_cr_ccid
                ,burden_cost_cr_account
                ,burden_cost_dr_ccid
                ,burden_cost_dr_account
                ,acct_currency_code
                ,acct_currency
                ,acct_rate_type 
                ,acct_rate_date
                ,acct_rate_date_type
                ,acct_exchange_rate
                ,acct_exchange_rounding_limit
                ,receipt_currency_code
                ,receipt_currency
                ,receipt_currency_amount
                ,receipt_exchange_rate
                ,converted_flag
                ,context_category
                ,user_def_attribute1
                ,user_def_attribute2
                ,user_def_attribute3
                ,user_def_attribute4
                ,user_def_attribute5
                ,user_def_attribute6
                ,user_def_attribute7
                ,user_def_attribute8
                ,user_def_attribute9
                ,user_def_attribute10
                ,reserved_attribute1
                ,reserved_attribute2
                ,reserved_attribute3
                ,reserved_attribute4
                ,reserved_attribute5
                ,reserved_attribute6
                ,reserved_attribute7
                ,reserved_attribute8
                ,reserved_attribute9
                ,reserved_attribute10
                ,attribute_category
                ,attribute1
                ,attribute2
                ,attribute3
                ,attribute4
                ,attribute5
                ,attribute6
                ,attribute7
                ,attribute9
                ,attribute8
                ,attribute10 -- to split costs Labor, NonLabor and Misc in EDQ
                ,contract_number
                ,contract_name
                ,contract_id
                ,funding_source_number
                ,funding_source_name   
                  ;


        CURSOR src_pa_cost_dtl
        IS
             select  'NONLABOR'  Transaction_type --  LABOR, NONLABOR
                ,business_unit --Nullify we consider BU based on Project Number
                ,org_id
                ,user_transaction_source
                ,transaction_source_id
                ,document_name
                ,document_id
                ,doc_entry_name
                ,doc_entry_id
                ,exp_batch_name
                ,batch_ending_date
                ,batch_description
                ,expenditure_item_date
                ,person_number
                ,person_name
                ,person_id
                ,hcm_assignment_name
                ,hcm_assignment_id
                ,project_number
                ,project_name
                ,project_id
                ,task_number
                ,task_name
                ,task_id
                ,expenditure_type
                ,expenditure_type_id
                ,organization_name                                                               --Organization_name
                ,organization_id
                ,non_labor_resource
                ,non_labor_resource_id
                ,non_labor_resource_org
                ,non_labor_resource_org_id
                ,quantity            
                ,unit_of_measure_name
                ,unit_of_measure
                ,work_type
                ,work_type_id
                ,billable_flag
                ,capitalizable_flag
                ,accrual_flag
                ,supplier_number
                ,supplier_name
                ,vendor_id
                ,inventory_item_name
                ,inventory_item_id
                ,orig_transaction_reference
                ,unmatched_negative_txn_flag
                ,reversed_orig_txn_reference
                ,expenditure_comment
                ,gl_date
                ,denom_currency_code
                ,denom_currency
                ,sum(denom_raw_cost)        AS denom_raw_cost                                          --denom_raw_cost
                ,sum(denom_burdened_cost)   AS denom_burdened_cost                                --denom_burdened_cost
                ,raw_cost_cr_ccid
                ,raw_cost_cr_account
                ,raw_cost_dr_ccid
                ,raw_cost_dr_account
                ,burdened_cost_cr_ccid
                ,burdened_cost_cr_account
                ,burdened_cost_dr_ccid
                ,burdened_cost_dr_account
                ,burden_cost_cr_ccid
                ,burden_cost_cr_account
                ,burden_cost_dr_ccid
                ,burden_cost_dr_account
                ,acct_currency_code
                ,acct_currency
                ,sum(acct_raw_cost)             AS acct_raw_cost -- based on UAT recon from business recon report
                ,sum(acct_burdened_cost)        AS acct_burdened_cost
                ,acct_rate_type 
                ,acct_rate_date
                ,acct_rate_date_type
                ,acct_exchange_rate
                ,acct_exchange_rounding_limit
                ,receipt_currency_code
                ,receipt_currency
                ,receipt_currency_amount
                ,receipt_exchange_rate
                ,converted_flag
                ,context_category
                ,user_def_attribute1
                ,user_def_attribute2
                ,user_def_attribute3
                ,user_def_attribute4
                ,user_def_attribute5
                ,user_def_attribute6
                ,user_def_attribute7
                ,user_def_attribute8
                ,user_def_attribute9
                ,user_def_attribute10
                ,reserved_attribute1
                ,reserved_attribute2
                ,reserved_attribute3
                ,reserved_attribute4
                ,reserved_attribute5
                ,reserved_attribute6
                ,reserved_attribute7
                ,reserved_attribute8
                ,reserved_attribute9
                ,reserved_attribute10
                ,attribute_category
                ,attribute1
                ,attribute2
                ,attribute3
                ,attribute4
                ,attribute5
                ,attribute6
                ,attribute7
                ,attribute9
                ,attribute8
                ,attribute10 -- to split costs Labor, NonLabor and Misc in EDQ
                ,contract_number
                ,contract_name
                ,contract_id
                ,funding_source_number
                ,funding_source_name                                                                                                          funding_source_name
           from(SELECT 
            NULL                                                                                                             transaction_type --  LABOR, NONLABOR
            ,haou1.name                                                                                                        business_unit --Nullify as we consider BU based on Project Number
            ,NULL                                                                                                             org_id
            ,null                                                                                                             user_transaction_source
            ,NULL                                                                                                             transaction_source_id
            ,NULL                                                                                                             document_name
            ,NULL                                                                                                             document_id
            ,NULL                                                                                                             doc_entry_name
            ,NULL                                                                                                             doc_entry_id
            --  'Data Migration'                                                                                              exp_batch_name
            ,(SELECT pea.expenditure_group
              FROM apps.pa_expenditures_all@MXDM_NVIS_EXTRACT pea
              WHERE peia.expenditure_id = pea.expenditure_id)                                                                 exp_batch_name
            ,(SELECT pea.expenditure_ending_date
              FROM apps.pa_expenditures_all@MXDM_NVIS_EXTRACT pea
              WHERE peia.expenditure_id = pea.expenditure_id)                                                                 batch_ending_date
            ,(SELECT pea.description
              FROM apps.pa_expenditures_all@MXDM_NVIS_EXTRACT pea
              WHERE peia.expenditure_id = pea.expenditure_id)                                                                 batch_description
            ,peia.expenditure_item_date                                                                                       expenditure_item_date
            ,NULL                                                                                                             person_number
            ,NULL                                                                                                             person_name
            ,NULL                                                                                                             person_id
            ,NULL                                                                                                             hcm_assignment_name
            ,NULL                                                                                                             hcm_assignment_id
            ,ppa.project_number                                                                                               project_number
            ,ppa.project_name                                                                                                 project_name
            ,NULL                                                                                                             project_id
            ,pt.task_number                                                                                                   task_number
            ,pt.task_name                                                                                                     task_name
            --,ppa.segment1||'-'||'DM2020'                                                                                    task_number
            --,ppa.segment1||'-'||'DM2020'                                                                                    task_name
            ,NULL                                                                                                             task_id
            ,peia.expenditure_type                                                                                            expenditure_type
            ,NULL                                                                                                             expenditure_type_id
            ,(select haou2.name 
                from apps.hr_all_organization_units@MXDM_NVIS_EXTRACT haou2 
                     ,apps.pa_expenditures_all@MXDM_NVIS_EXTRACT pea1
                where haou2.organization_id= NVL (peia.override_to_organization_id, pea1.incurred_by_organization_id)
                  and peia.expenditure_id = pea1.expenditure_id)                                                              organization_name
            ,NULL                                                                                                             organization_id -- POO from Project Number Mapped in EDQ
            ,peia.non_labor_resource                                                                                          non_labor_resource
            ,NULL                                                                                                             non_labor_resource_id
            ,(select haou2.name 
                from apps.hr_all_organization_units@MXDM_NVIS_EXTRACT haou2 
                where haou2.organization_id= peia.organization_id
                  )                                                                                                           non_labor_resource_org
            ,NULL                                                                                                             non_labor_resource_org_id
            ,peia.quantity                                                                                                    quantity
            ,NULL                                                                                                             unit_of_measure_name
            ,peia.unit_of_measure                                                                                             unit_of_measure
            ,(SELECT name
              FROM   apps.pa_work_types_tl@MXDM_NVIS_EXTRACT pwtt--apps.PA_TASKS_V@MXDM_NVIS_EXTRACT
              WHERE  peia.work_type_id=pwtt.work_type_id)                                                                     work_type
            ,NULL                                                                                                             work_type_id
            ,peia.billable_flag                                                                                               billable_flag
            ,NULL                                                                                                             capitalizable_flag
            ,NULL                                                                                                             accrual_flag
            ,NULL                                                                                                             supplier_number
            ,NULL                                                                                                             supplier_name
            ,NULL                                                                                                             vendor_id
            ,NULL                                                                                                             inventory_item_name
            ,NULL                                                                                                             inventory_item_id
            ,ppa.project_number||'-'||'DM2020'                                                                                orig_transaction_reference
            ,NULL                                                                                                             unmatched_negative_txn_flag
            ,NULL                                                                                                             reversed_orig_txn_reference
            ,NULL                                                                                                             expenditure_comment
            ,pcdla.gl_date                                                                                                    gl_date
            ,pcdla.denom_currency_code                                                                                         denom_currency_code
            ,NULL                                                                                                             denom_currency
            ,pcdla.denom_raw_cost                                                                                              denom_raw_cost
            ,peia.denom_burdened_cost                                                                                         denom_burdened_cost
            ,NULL                                                                                                             raw_cost_cr_ccid
            ,NULL                                                                                                             raw_cost_cr_account
            ,NULL                                                                                                             raw_cost_dr_ccid
            ,NULL                                                                                                             raw_cost_dr_account
            ,NULL                                                                                                             burdened_cost_cr_ccid
            ,NULL                                                                                                             burdened_cost_cr_account
            ,NULL                                                                                                             burdened_cost_dr_ccid
            ,NULL                                                                                                             burdened_cost_dr_account
            ,NULL                                                                                                             burden_cost_cr_ccid
            ,NULL                                                                                                             burden_cost_cr_account
            ,NULL                                                                                                             burden_cost_dr_ccid
            ,NULL                                                                                                             burden_cost_dr_account
            ,peia.acct_currency_code                                                                                          acct_currency_code
            ,NULL                                                                                                             acct_currency
            ,pcdla.acct_raw_cost                                                                                               acct_raw_cost  -- based on UAT recon from business recon report
            ,peia.acct_burdened_cost                                                                                          acct_burdened_cost
            ,peia.acct_rate_type                                                                                              acct_rate_type
            ,peia.acct_rate_date                                                                                              acct_rate_date
            ,NULL                                                                                                             acct_rate_date_type
            ,peia.acct_exchange_rate                                                                                          acct_exchange_rate
            ,NULL                                                                                                             acct_exchange_rounding_limit
            ,NULL                                                                                                             receipt_currency_code
            ,NULL                                                                                                             receipt_currency
            ,NULL                                                                                                             receipt_currency_amount
            ,NULL                                                                                                             receipt_exchange_rate
            ,peia.converted_flag                                                                                              converted_flag
            ,NULL                                                                                                             context_category
            ,NULL                                                                                                             user_def_attribute1
            ,NULL                                                                                                             user_def_attribute2
            ,NULL                                                                                                             user_def_attribute3
            ,NULL                                                                                                             user_def_attribute4
            ,NULL                                                                                                             user_def_attribute5
            ,NULL                                                                                                             user_def_attribute6
            ,NULL                                                                                                             user_def_attribute7
            ,NULL                                                                                                             user_def_attribute8
            ,NULL                                                                                                             user_def_attribute9
            ,NULL                                                                                                             user_def_attribute10
            ,NULL                                                                                                             reserved_attribute1
            ,NULL                                                                                                             reserved_attribute2
            ,NULL                                                                                                             reserved_attribute3
            ,NULL                                                                                                             reserved_attribute4
            ,NULL                                                                                                             reserved_attribute5
            ,NULL                                                                                                             reserved_attribute6
            ,NULL                                                                                                             reserved_attribute7
            ,NULL                                                                                                             reserved_attribute8
            ,NULL                                                                                                             reserved_attribute9
            ,NULL                                                                                                             reserved_attribute10
            ,NULL                                                                                                             attribute_category
            ,NULL                                                                                                             attribute1
            ,NULL                                                                                                             attribute2
            ,NULL                                                                                                             attribute3
            ,NULL                                                                                                             attribute4
            ,NULL                                                                                                             attribute5
            ,NULL                                                                                                             attribute6
            ,NULL                                                                                                             attribute7
            ,NULL                                                                                                             attribute9
            ,NULL                                                                                                             attribute8
            ,null                                                                                                             attribute10 -- to split costs Labor, NonLabor and Misc in EDQ
            ,NULL                                                                                                             contract_number
            ,NULL                                                                                                             contract_name
            ,NULL                                                                                                             contract_id
            ,NULL                                                                                                             funding_source_number
            ,NULL                                                                                                             funding_source_name
            FROM  xxmx_ppm_projects_stg                                    ppa
                 ,apps.pa_expenditure_items_all@MXDM_NVIS_EXTRACT          peia
                 ,apps.pa_tasks@MXDM_NVIS_EXTRACT                          pt
                 ,apps.hr_all_organization_units@MXDM_NVIS_EXTRACT         haou1
                 ,apps.pa_cost_distribution_lines_all@MXDM_NVIS_EXTRACT    pcdla
                 --,apps.gl_code_combinations@MXDM_NVIS_EXTRACT gcc
            WHERE ppa.project_id                    = peia.project_id
--              AND peia.cc_cross_charge_type <> 'IC'
              and pt.project_id = ppa.project_id
              AND pt.project_id                     = peia.project_id
              AND pt.task_id   (+)                     = peia.task_id
              AND pcdla.expenditure_item_id         = peia.expenditure_item_id
              AND pcdla.project_id                  = peia.project_id
              AND pt.task_id                        = pcdla.task_id
              AND peia.org_id                       = haou1.organization_id
            --AND   peia.org_id                       = haou1.organization_id
            --AND   peia.expenditure_id               = pea.expenditure_id
            AND   ( pt.completion_date              IS NULL
                    OR pt.completion_date           > SYSDATE)   
            --and peia.EXPENDITURE_ITEM_ID=56028655        
            AND NOT EXISTS ( SELECT 1 FROM apps.pa_tasks@MXDM_NVIS_EXTRACT b WHERE b.parent_task_id=pt.task_id)
            --AND peia.expenditure_item_date >= to_date('01-JAN-2020','DD-MON-RRRR')
            /*AND   TO_CHAR(TO_DATE(pcdla.gl_period_name,'Mon-RR'),'RRRR') IN( SELECT TO_CHAR(TO_DATE(parameter_value,'Mon-RR'),'RRRR') 
                                                                                from xxmx_migration_parameters
                                                                                where parameter_code  = 'GL_PERIOD_NAME'
                                                                                and application = 'PPM')*/
            AND  pcdla.gl_date BETWEEN TO_DATE(gvv_migration_date_from,'DD-MM-RRRR') AND TO_DATE(gvv_migration_date_to,'DD-MM-RRRR')  
            AND system_linkage_function in (select parameter_value
                                                  from xxmx_migration_parameters
                                                  where application= 'PPM'
                                                  and application_suite= 'FIN'
                                                  and parameter_code = 'EXP_SYSTEM_LINK_TYPE'
                                                  and sub_entity = 'NON_LBR_COST'
                                                  and enabled_flag = 'Y'
                                                  )                    
                    --AND pcdla.project_id = 2073
                    )
            GROUP BY
            Transaction_type --  LABOR, NONLABOR
                ,business_unit --Nullify we consider BU based on Project Number
                ,org_id
                ,user_transaction_source
                ,transaction_source_id
                ,document_name
                ,document_id
                ,doc_entry_name
                ,doc_entry_id
                ,exp_batch_name
                ,batch_ending_date
                ,batch_description
                ,expenditure_item_date
                ,person_number
                ,person_name
                ,person_id
                ,hcm_assignment_name
                ,hcm_assignment_id
                ,project_number
                ,project_name
                ,project_id
                ,task_number
                ,task_name
                ,task_id
                ,expenditure_type
                ,expenditure_type_id
                ,organization_name                                                               --Organization_name
                ,organization_id
                ,non_labor_resource
                ,non_labor_resource_id
                ,non_labor_resource_org
                ,non_labor_resource_org_id
                ,quantity            
                ,unit_of_measure_name
                ,unit_of_measure
                ,work_type
                ,work_type_id
                ,billable_flag
                ,capitalizable_flag
                ,accrual_flag
                ,supplier_number
                ,supplier_name
                ,vendor_id
                ,inventory_item_name
                ,inventory_item_id
                ,orig_transaction_reference
                ,unmatched_negative_txn_flag
                ,reversed_orig_txn_reference
                ,expenditure_comment
                ,gl_date
                ,denom_currency_code
                ,denom_currency
                ,raw_cost_cr_ccid
                ,raw_cost_cr_account
                ,raw_cost_dr_ccid
                ,raw_cost_dr_account
                ,burdened_cost_cr_ccid
                ,burdened_cost_cr_account
                ,burdened_cost_dr_ccid
                ,burdened_cost_dr_account
                ,burden_cost_cr_ccid
                ,burden_cost_cr_account
                ,burden_cost_dr_ccid
                ,burden_cost_dr_account
                ,acct_currency_code
                ,acct_currency
                ,acct_rate_type 
                ,acct_rate_date
                ,acct_rate_date_type
                ,acct_exchange_rate
                ,acct_exchange_rounding_limit
                ,receipt_currency_code
                ,receipt_currency
                ,receipt_currency_amount
                ,receipt_exchange_rate
                ,converted_flag
                ,context_category
                ,user_def_attribute1
                ,user_def_attribute2
                ,user_def_attribute3
                ,user_def_attribute4
                ,user_def_attribute5
                ,user_def_attribute6
                ,user_def_attribute7
                ,user_def_attribute8
                ,user_def_attribute9
                ,user_def_attribute10
                ,reserved_attribute1
                ,reserved_attribute2
                ,reserved_attribute3
                ,reserved_attribute4
                ,reserved_attribute5
                ,reserved_attribute6
                ,reserved_attribute7
                ,reserved_attribute8
                ,reserved_attribute9
                ,reserved_attribute10
                ,attribute_category
                ,attribute1
                ,attribute2
                ,attribute3
                ,attribute4
                ,attribute5
                ,attribute6
                ,attribute7
                ,attribute9
                ,attribute8
                ,attribute10 -- to split costs Labor, NonLabor and Misc in EDQ
                ,contract_number
                ,contract_name
                ,contract_id
                ,funding_source_number
                ,funding_source_name;
       --
       --**********************
       --** Record Declarations
       --**********************
       --
        TYPE pa_costs_tbl IS TABLE OF pa_costs_cur%ROWTYPE INDEX BY BINARY_INTEGER;
        pa_costs_tb  pa_costs_tbl;

        TYPE pa_costs_dtl_tbl IS TABLE OF src_pa_cost_dtl%ROWTYPE INDEX BY BINARY_INTEGER;
        pa_costs_dtl_tb  pa_costs_dtl_tbl;



       --
       --************************
       --** Constant Declarations
       --************************
       --
        cv_ProcOrFuncName                   CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'src_pa_nonlbr_costs';
        cv_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_PPM_PRJ_NONLABCOST_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'NON_LBR_COST';
        gv_i_BusinessEntity                                 VARCHAR2(100)     := 'PRJ_COST';


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

        gvv_cost_ext_type := xxmx_utilities_pkg.get_single_parameter_value(
                        pt_i_ApplicationSuite           =>     gct_ApplicationSuite
                        ,pt_i_Application                =>     gct_Application
                        ,pt_i_BusinessEntity             =>     'PRJ_COST'
                        ,pt_i_SubEntity                  =>     'ALL'
                        ,pt_i_ParameterCode              =>     'COST_EXT_TYPE');

        gvv_migration_date_from := xxmx_utilities_pkg.get_single_parameter_value(
                        pt_i_ApplicationSuite           =>     gct_ApplicationSuite
                        ,pt_i_Application                =>     gct_Application
                        ,pt_i_BusinessEntity             =>     'ALL'
                        ,pt_i_SubEntity                  =>     'ALL'
                        ,pt_i_ParameterCode              =>     'EXTRACT_START_DATE'
        );        
        --gvd_migration_date_from := TO_DATE(gvv_migration_date_from,'YYYY-MM-DD');


        gvv_migration_date_to := xxmx_utilities_pkg.get_single_parameter_value(
                        pt_i_ApplicationSuite           =>     gct_ApplicationSuite
                        ,pt_i_Application                =>     gct_Application
                        ,pt_i_BusinessEntity             =>     'ALL'
                        ,pt_i_SubEntity                  =>     'ALL'
                        ,pt_i_ParameterCode              =>     'EXTRACT_END_DATE'
        );        
       -- gvd_migration_date_to := TO_DATE(gvv_migration_date_to,'YYYY-MM-DD');
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
        FROM    XXMX_PPM_PRJ_NONLABCOST_STG ;

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

            IF( UPPER(gvv_cost_ext_type) = 'SUMMARY') THEN 
                  OPEN pa_costs_cur;
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
                         ,pt_i_ModuleMessage       =>'Cursor Open src_pa_billing_events_cur'
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
                  FETCH pa_costs_cur  BULK COLLECT INTO pa_costs_tb LIMIT 1000;
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
                         ,pt_i_ModuleMessage       => 'Cursor pa_costs_cur Fetch into pa_costs_tb'
                         ,pt_i_OracleError         => gvt_ReturnMessage  );
                  --
                  EXIT WHEN pa_costs_tb.COUNT=0;
                  --
                  FORALL I IN 1..pa_costs_tb.COUNT SAVE EXCEPTIONS
                  --
                       INSERT INTO XXMX_PPM_PRJ_NONLABCOST_STG (
                                           migration_set_id                 
                                          ,migration_set_name               
                                          ,migration_status                 
                                          ,transaction_type                
                                          ,business_unit                   
                                          ,org_id                          
                                          ,user_transaction_source         
                                          ,transaction_source_id           
                                          ,document_name                   
                                          ,document_id                     
                                          ,doc_entry_name                  
                                          ,doc_entry_id                    
                                          ,batch_ending_date               
                                          ,batch_description               
                                          ,expenditure_item_date           
                                          ,person_number                   
                                          ,person_name                     
                                          ,person_id                       
                                          ,hcm_assignment_name             
                                          ,hcm_assignment_id               
                                          ,project_number                  
                                          ,project_name                    
                                          ,project_id                      
                                          ,task_number                     
                                          ,task_name                       
                                          ,task_id                         
                                          ,expenditure_type                
                                          ,expenditure_type_id             
                                          ,organization_name               
                                          ,organization_id                 
                                         -- ,non_labor_resource              
                                          --,non_labor_resource_id           
                                          --,non_labor_resource_org          
                                          --,non_labor_resource_org_id       
                                          ,quantity                        
                                          ,unit_of_measure_name            
                                          ,unit_of_measure                 
                                          ,work_type                       
                                          ,work_type_id                    
                                          ,billable_flag                   
                                          ,capitalizable_flag              
                                         -- ,accrual_flag                    
                                         -- ,supplier_number                 
                                          --,supplier_name                   
                                          --,vendor_id                       
                                          --,inventory_item_name             
                                         -- ,inventory_item_id               
                                          ,orig_transaction_reference      
                                          ,unmatched_negative_txn_flag     
                                          ,reversed_orig_txn_reference     
                                          ,expenditure_comment             
                                          ,gl_date                         
                                          ,denom_currency_code             
                                          ,denom_currency                  
                                          ,denom_raw_cost                  
                                          ,denom_burdened_cost             
                                          ,raw_cost_cr_ccid                
                                          ,raw_cost_cr_account             
                                          ,raw_cost_dr_ccid                
                                          ,raw_cost_dr_account             
                                          ,burdened_cost_cr_ccid           
                                          ,burdened_cost_cr_account        
                                          ,burdened_cost_dr_ccid           
                                          ,burdened_cost_dr_account        
                                          ,burden_cost_cr_ccid             
                                          ,burden_cost_cr_account          
                                          ,burden_cost_dr_ccid             
                                          ,burden_cost_dr_account          
                                          ,acct_currency_code              
                                          ,acct_currency                   
                                          ,acct_raw_cost                   
                                          ,acct_burdened_cost              
                                          ,acct_rate_type                  
                                          ,acct_rate_date                  
                                          ,acct_rate_date_type             
                                          ,acct_exchange_rate              
                                          ,acct_exchange_rounding_limit    
                                          --,receipt_currency_code           
                                          --,receipt_currency                
                                          --,receipt_currency_amount         
                                         -- ,receipt_exchange_rate           
                                          ,converted_flag                  
                                          ,context_category                
                                          ,user_def_attribute1             
                                          ,user_def_attribute2             
                                          ,user_def_attribute3             
                                          ,user_def_attribute4             
                                          ,user_def_attribute5             
                                          ,user_def_attribute6             
                                          ,user_def_attribute7             
                                          ,user_def_attribute8             
                                          ,user_def_attribute9             
                                          ,user_def_attribute10            
                                          ,reserved_attribute1             
                                          ,reserved_attribute2             
                                          ,reserved_attribute3             
                                          ,reserved_attribute4             
                                          ,reserved_attribute5             
                                          ,reserved_attribute6             
                                          ,reserved_attribute7             
                                          ,reserved_attribute8             
                                          ,reserved_attribute9             
                                          ,reserved_attribute10            
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
                                          ,contract_number                 
                                          ,contract_name                   
                                          ,contract_id                     
                                          ,funding_source_number           
                                          ,funding_source_name             
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
                                  ,pa_costs_tb(i).transaction_type                
                                  ,pa_costs_tb(i).business_unit                   
                                  ,pa_costs_tb(i).org_id                          
                                  ,pa_costs_tb(i).user_transaction_source         
                                  ,pa_costs_tb(i).transaction_source_id           
                                  ,pa_costs_tb(i).document_name                   
                                  ,pa_costs_tb(i).document_id                     
                                  ,pa_costs_tb(i).doc_entry_name                  
                                  ,pa_costs_tb(i).doc_entry_id                    
                                  ,pa_costs_tb(i).batch_ending_date               
                                  ,pa_costs_tb(i).batch_description               
                                  ,pa_costs_tb(i).expenditure_item_date           
                                  ,pa_costs_tb(i).person_number                   
                                  ,pa_costs_tb(i).person_name                     
                                  ,pa_costs_tb(i).person_id                       
                                  ,pa_costs_tb(i).hcm_assignment_name             
                                  ,pa_costs_tb(i).hcm_assignment_id               
                                  ,pa_costs_tb(i).project_number                  
                                  ,pa_costs_tb(i).project_name                    
                                  ,pa_costs_tb(i).project_id                      
                                  ,pa_costs_tb(i).task_number                     
                                  ,pa_costs_tb(i).task_name                       
                                  ,pa_costs_tb(i).task_id                         
                                  ,pa_costs_tb(i).expenditure_type                
                                  ,pa_costs_tb(i).expenditure_type_id             
                                  ,pa_costs_tb(i).organization_name               
                                  ,pa_costs_tb(i).organization_id                 
                                  --,pa_costs_tb(i).non_labor_resource              
                                  --,pa_costs_tb(i).non_labor_resource_id           
                                  --,pa_costs_tb(i).non_labor_resource_org          
                                  --,pa_costs_tb(i).non_labor_resource_org_id       
                                  ,pa_costs_tb(i).quantity                        
                                  ,pa_costs_tb(i).unit_of_measure_name            
                                  ,pa_costs_tb(i).unit_of_measure                 
                                  ,pa_costs_tb(i).work_type                       
                                  ,pa_costs_tb(i).work_type_id                    
                                  ,pa_costs_tb(i).billable_flag                   
                                  ,pa_costs_tb(i).capitalizable_flag              
                                 -- ,pa_costs_tb(i).accrual_flag                    
                                  --,pa_costs_tb(i).supplier_number                 
                                  --,pa_costs_tb(i).supplier_name                   
                                  --,pa_costs_tb(i).vendor_id                       
                                  --,pa_costs_tb(i).inventory_item_name             
                                  --,pa_costs_tb(i).inventory_item_id               
                                  ,pa_costs_tb(i).orig_transaction_reference      
                                  ,pa_costs_tb(i).unmatched_negative_txn_flag     
                                  ,pa_costs_tb(i).reversed_orig_txn_reference     
                                  ,pa_costs_tb(i).expenditure_comment             
                                  ,pa_costs_tb(i).gl_date                         
                                  ,pa_costs_tb(i).denom_currency_code             
                                  ,pa_costs_tb(i).denom_currency                  
                                  ,pa_costs_tb(i).denom_raw_cost                  
                                  ,pa_costs_tb(i).denom_burdened_cost             
                                  ,pa_costs_tb(i).raw_cost_cr_ccid                
                                  ,pa_costs_tb(i).raw_cost_cr_account             
                                  ,pa_costs_tb(i).raw_cost_dr_ccid                
                                  ,pa_costs_tb(i).raw_cost_dr_account             
                                  ,pa_costs_tb(i).burdened_cost_cr_ccid           
                                  ,pa_costs_tb(i).burdened_cost_cr_account        
                                  ,pa_costs_tb(i).burdened_cost_dr_ccid           
                                  ,pa_costs_tb(i).burdened_cost_dr_account        
                                  ,pa_costs_tb(i).burden_cost_cr_ccid             
                                  ,pa_costs_tb(i).burden_cost_cr_account           
                                  ,pa_costs_tb(i).burden_cost_dr_ccid             
                                  ,pa_costs_tb(i).burden_cost_dr_account          
                                  ,pa_costs_tb(i).acct_currency_code              
                                  ,pa_costs_tb(i).acct_currency                   
                                  ,pa_costs_tb(i).acct_raw_cost                   
                                  ,pa_costs_tb(i).acct_burdened_cost              
                                  ,pa_costs_tb(i).acct_rate_type                  
                                  ,pa_costs_tb(i).acct_rate_date                  
                                  ,pa_costs_tb(i).acct_rate_date_type             
                                  ,pa_costs_tb(i).acct_exchange_rate              
                                  ,pa_costs_tb(i).acct_exchange_rounding_limit    
                                  --,pa_costs_tb(i).receipt_currency_code           
                                  --,pa_costs_tb(i).receipt_currency                
                                  --,pa_costs_tb(i).receipt_currency_amount         
                                  --,pa_costs_tb(i).receipt_exchange_rate           
                                  ,pa_costs_tb(i).converted_flag                  
                                  ,pa_costs_tb(i).context_category                
                                  ,pa_costs_tb(i).user_def_attribute1             
                                  ,pa_costs_tb(i).user_def_attribute2             
                                  ,pa_costs_tb(i).user_def_attribute3             
                                  ,pa_costs_tb(i).user_def_attribute4             
                                  ,pa_costs_tb(i).user_def_attribute5             
                                  ,pa_costs_tb(i).user_def_attribute6             
                                  ,pa_costs_tb(i).user_def_attribute7             
                                  ,pa_costs_tb(i).user_def_attribute8             
                                  ,pa_costs_tb(i).user_def_attribute9             
                                  ,pa_costs_tb(i).user_def_attribute10            
                                  ,pa_costs_tb(i).reserved_attribute1             
                                  ,pa_costs_tb(i).reserved_attribute2             
                                  ,pa_costs_tb(i).reserved_attribute3             
                                  ,pa_costs_tb(i).reserved_attribute4             
                                  ,pa_costs_tb(i).reserved_attribute5             
                                  ,pa_costs_tb(i).reserved_attribute6             
                                  ,pa_costs_tb(i).reserved_attribute7             
                                  ,pa_costs_tb(i).reserved_attribute8             
                                  ,pa_costs_tb(i).reserved_attribute9             
                                  ,pa_costs_tb(i).reserved_attribute10            
                                  ,pa_costs_tb(i).attribute_category              
                                  ,pa_costs_tb(i).attribute1                      
                                  ,pa_costs_tb(i).attribute2                      
                                  ,pa_costs_tb(i).attribute3                      
                                  ,pa_costs_tb(i).attribute4                      
                                  ,pa_costs_tb(i).attribute5                      
                                  ,pa_costs_tb(i).attribute6                      
                                  ,pa_costs_tb(i).attribute7                      
                                  ,pa_costs_tb(i).attribute8                      
                                  ,pa_costs_tb(i).attribute9                      
                                  ,pa_costs_tb(i).attribute10                     
                                  ,pa_costs_tb(i).contract_number                 
                                  ,pa_costs_tb(i).contract_name                   
                                  ,pa_costs_tb(i).contract_id                     
                                  ,pa_costs_tb(i).funding_source_number           
                                  ,pa_costs_tb(i).funding_source_name             
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
                                    ,pt_i_ModuleMessage       => 'Close the Cursor pa_costs_cur'
                                    ,pt_i_OracleError         => gvt_ReturnMessage       );   
                   --


                   IF pa_costs_cur%ISOPEN
                   THEN
                        --
                           CLOSE pa_costs_cur;
                        --
                   END IF;

            ELSIF ( UPPER(gvv_cost_ext_type) = 'DETAIL')   
            THEN

                  OPEN src_pa_cost_dtl;
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
                         ,pt_i_ModuleMessage       =>'Cursor Open src_pa_cost_dtl'
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
                  FETCH src_pa_cost_dtl  BULK COLLECT INTO pa_costs_dtl_tb LIMIT 1000;
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
                         ,pt_i_ModuleMessage       => 'Cursor src_pa_cost_dtl Fetch into pa_costs_dtl_tb'
                         ,pt_i_OracleError         => gvt_ReturnMessage  );
                  --
                  EXIT WHEN pa_costs_dtl_tb.COUNT=0;
                  --
                  FORALL I IN 1..pa_costs_dtl_tb.COUNT SAVE EXCEPTIONS
                  --
                       INSERT INTO XXMX_PPM_PRJ_NONLABCOST_STG (
                                           migration_set_id                 
                                          ,migration_set_name               
                                          ,migration_status                 
                                          ,transaction_type                
                                          ,business_unit                   
                                          ,org_id                          
                                          ,user_transaction_source         
                                          ,transaction_source_id           
                                          ,document_name                   
                                          ,document_id                     
                                          ,doc_entry_name                  
                                          ,doc_entry_id                    
                                          ,batch_ending_date               
                                          ,batch_description               
                                          ,expenditure_item_date           
                                          ,person_number                   
                                          ,person_name                     
                                          ,person_id                       
                                          ,hcm_assignment_name             
                                          ,hcm_assignment_id               
                                          ,project_number                  
                                          ,project_name                    
                                          ,project_id                      
                                          ,task_number                     
                                          ,task_name                       
                                          ,task_id                         
                                          ,expenditure_type                
                                          ,expenditure_type_id             
                                          ,organization_name               
                                          ,organization_id                 
                                          ,non_labor_resource              
                                          ,non_labor_resource_id           
                                          ,non_labor_resource_org          
                                          ,non_labor_resource_org_id       
                                          ,quantity                        
                                          ,unit_of_measure_name            
                                          ,unit_of_measure                 
                                          ,work_type                       
                                          ,work_type_id                    
                                          ,billable_flag                   
                                          ,capitalizable_flag              
                                          --,accrual_flag                    
                                         -- ,supplier_number                 
                                          --,supplier_name                   
                                          --,vendor_id                       
                                          --,inventory_item_name             
                                         -- ,inventory_item_id               
                                          ,orig_transaction_reference      
                                          ,unmatched_negative_txn_flag     
                                          ,reversed_orig_txn_reference     
                                          ,expenditure_comment             
                                          ,gl_date                         
                                          ,denom_currency_code             
                                          ,denom_currency                  
                                          ,denom_raw_cost                  
                                          ,denom_burdened_cost             
                                          ,raw_cost_cr_ccid                
                                          ,raw_cost_cr_account             
                                          ,raw_cost_dr_ccid                
                                          ,raw_cost_dr_account             
                                          ,burdened_cost_cr_ccid           
                                          ,burdened_cost_cr_account        
                                          ,burdened_cost_dr_ccid           
                                          ,burdened_cost_dr_account        
                                          ,burden_cost_cr_ccid             
                                          ,burden_cost_cr_account          
                                          ,burden_cost_dr_ccid             
                                          ,burden_cost_dr_account          
                                          ,acct_currency_code              
                                          ,acct_currency                   
                                          ,acct_raw_cost                   
                                          ,acct_burdened_cost              
                                          ,acct_rate_type                  
                                          ,acct_rate_date                  
                                          ,acct_rate_date_type             
                                          ,acct_exchange_rate              
                                          ,acct_exchange_rounding_limit    
                                          --,receipt_currency_code           
                                          --,receipt_currency                
                                          --,receipt_currency_amount         
                                         -- ,receipt_exchange_rate           
                                          ,converted_flag                  
                                          ,context_category                
                                          ,user_def_attribute1             
                                          ,user_def_attribute2             
                                          ,user_def_attribute3             
                                          ,user_def_attribute4             
                                          ,user_def_attribute5             
                                          ,user_def_attribute6             
                                          ,user_def_attribute7             
                                          ,user_def_attribute8             
                                          ,user_def_attribute9             
                                          ,user_def_attribute10            
                                          ,reserved_attribute1             
                                          ,reserved_attribute2             
                                          ,reserved_attribute3             
                                          ,reserved_attribute4             
                                          ,reserved_attribute5             
                                          ,reserved_attribute6             
                                          ,reserved_attribute7             
                                          ,reserved_attribute8             
                                          ,reserved_attribute9             
                                          ,reserved_attribute10            
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
                                          ,contract_number                 
                                          ,contract_name                   
                                          ,contract_id                     
                                          ,funding_source_number           
                                          ,funding_source_name             
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
                                  ,pa_costs_dtl_tb(i).transaction_type                
                                  ,pa_costs_dtl_tb(i).business_unit                   
                                  ,pa_costs_dtl_tb(i).org_id                          
                                  ,pa_costs_dtl_tb(i).user_transaction_source         
                                  ,pa_costs_dtl_tb(i).transaction_source_id           
                                  ,pa_costs_dtl_tb(i).document_name                   
                                  ,pa_costs_dtl_tb(i).document_id                     
                                  ,pa_costs_dtl_tb(i).doc_entry_name                  
                                  ,pa_costs_dtl_tb(i).doc_entry_id                    
                                  ,pa_costs_dtl_tb(i).batch_ending_date               
                                  ,pa_costs_dtl_tb(i).batch_description               
                                  ,pa_costs_dtl_tb(i).expenditure_item_date           
                                  ,pa_costs_dtl_tb(i).person_number                   
                                  ,pa_costs_dtl_tb(i).person_name                     
                                  ,pa_costs_dtl_tb(i).person_id                       
                                  ,pa_costs_dtl_tb(i).hcm_assignment_name             
                                  ,pa_costs_dtl_tb(i).hcm_assignment_id               
                                  ,pa_costs_dtl_tb(i).project_number                  
                                  ,pa_costs_dtl_tb(i).project_name                    
                                  ,pa_costs_dtl_tb(i).project_id                      
                                  ,pa_costs_dtl_tb(i).task_number                     
                                  ,pa_costs_dtl_tb(i).task_name                       
                                  ,pa_costs_dtl_tb(i).task_id                         
                                  ,pa_costs_dtl_tb(i).expenditure_type                
                                  ,pa_costs_dtl_tb(i).expenditure_type_id             
                                  ,pa_costs_dtl_tb(i).organization_name               
                                  ,pa_costs_dtl_tb(i).organization_id                 
                                  ,pa_costs_dtl_tb(i).non_labor_resource              
                                  ,pa_costs_dtl_tb(i).non_labor_resource_id           
                                  ,pa_costs_dtl_tb(i).non_labor_resource_org          
                                  ,pa_costs_dtl_tb(i).non_labor_resource_org_id       
                                  ,pa_costs_dtl_tb(i).quantity                        
                                  ,pa_costs_dtl_tb(i).unit_of_measure_name            
                                  ,pa_costs_dtl_tb(i).unit_of_measure                 
                                  ,pa_costs_dtl_tb(i).work_type                       
                                  ,pa_costs_dtl_tb(i).work_type_id                    
                                  ,pa_costs_dtl_tb(i).billable_flag                   
                                  ,pa_costs_dtl_tb(i).capitalizable_flag              
                                  --,pa_costs_dtl_tb(i).accrual_flag                    
                                  --,pa_costs_dtl_tb(i).supplier_number                 
                                  --,pa_costs_dtl_tb(i).supplier_name                   
                                  --,pa_costs_dtl_tb(i).vendor_id                       
                                  --,pa_costs_dtl_tb(i).inventory_item_name             
                                  --,pa_costs_dtl_tb(i).inventory_item_id               
                                  ,pa_costs_dtl_tb(i).orig_transaction_reference      
                                  ,pa_costs_dtl_tb(i).unmatched_negative_txn_flag     
                                  ,pa_costs_dtl_tb(i).reversed_orig_txn_reference     
                                  ,pa_costs_dtl_tb(i).expenditure_comment             
                                  ,pa_costs_dtl_tb(i).gl_date                         
                                  ,pa_costs_dtl_tb(i).denom_currency_code             
                                  ,pa_costs_dtl_tb(i).denom_currency                  
                                  ,pa_costs_dtl_tb(i).denom_raw_cost                  
                                  ,pa_costs_dtl_tb(i).denom_burdened_cost             
                                  ,pa_costs_dtl_tb(i).raw_cost_cr_ccid                
                                  ,pa_costs_dtl_tb(i).raw_cost_cr_account             
                                  ,pa_costs_dtl_tb(i).raw_cost_dr_ccid                
                                  ,pa_costs_dtl_tb(i).raw_cost_dr_account             
                                  ,pa_costs_dtl_tb(i).burdened_cost_cr_ccid           
                                  ,pa_costs_dtl_tb(i).burdened_cost_cr_account        
                                  ,pa_costs_dtl_tb(i).burdened_cost_dr_ccid           
                                  ,pa_costs_dtl_tb(i).burdened_cost_dr_account        
                                  ,pa_costs_dtl_tb(i).burden_cost_cr_ccid             
                                  ,pa_costs_dtl_tb(i).burden_cost_cr_account           
                                  ,pa_costs_dtl_tb(i).burden_cost_dr_ccid             
                                  ,pa_costs_dtl_tb(i).burden_cost_dr_account          
                                  ,pa_costs_dtl_tb(i).acct_currency_code              
                                  ,pa_costs_dtl_tb(i).acct_currency                   
                                  ,pa_costs_dtl_tb(i).acct_raw_cost                   
                                  ,pa_costs_dtl_tb(i).acct_burdened_cost              
                                  ,pa_costs_dtl_tb(i).acct_rate_type                  
                                  ,pa_costs_dtl_tb(i).acct_rate_date                  
                                  ,pa_costs_dtl_tb(i).acct_rate_date_type             
                                  ,pa_costs_dtl_tb(i).acct_exchange_rate              
                                  ,pa_costs_dtl_tb(i).acct_exchange_rounding_limit    
                                  --,pa_costs_dtl_tb(i).receipt_currency_code           
                                  --,pa_costs_dtl_tb(i).receipt_currency                
                                  --,pa_costs_dtl_tb(i).receipt_currency_amount         
                                  --,pa_costs_dtl_tb(i).receipt_exchange_rate           
                                  ,pa_costs_dtl_tb(i).converted_flag                  
                                  ,pa_costs_dtl_tb(i).context_category                
                                  ,pa_costs_dtl_tb(i).user_def_attribute1             
                                  ,pa_costs_dtl_tb(i).user_def_attribute2             
                                  ,pa_costs_dtl_tb(i).user_def_attribute3             
                                  ,pa_costs_dtl_tb(i).user_def_attribute4             
                                  ,pa_costs_dtl_tb(i).user_def_attribute5             
                                  ,pa_costs_dtl_tb(i).user_def_attribute6             
                                  ,pa_costs_dtl_tb(i).user_def_attribute7             
                                  ,pa_costs_dtl_tb(i).user_def_attribute8             
                                  ,pa_costs_dtl_tb(i).user_def_attribute9             
                                  ,pa_costs_dtl_tb(i).user_def_attribute10            
                                  ,pa_costs_dtl_tb(i).reserved_attribute1             
                                  ,pa_costs_dtl_tb(i).reserved_attribute2             
                                  ,pa_costs_dtl_tb(i).reserved_attribute3             
                                  ,pa_costs_dtl_tb(i).reserved_attribute4             
                                  ,pa_costs_dtl_tb(i).reserved_attribute5             
                                  ,pa_costs_dtl_tb(i).reserved_attribute6             
                                  ,pa_costs_dtl_tb(i).reserved_attribute7             
                                  ,pa_costs_dtl_tb(i).reserved_attribute8             
                                  ,pa_costs_dtl_tb(i).reserved_attribute9             
                                  ,pa_costs_dtl_tb(i).reserved_attribute10            
                                  ,pa_costs_dtl_tb(i).attribute_category              
                                  ,pa_costs_dtl_tb(i).attribute1                      
                                  ,pa_costs_dtl_tb(i).attribute2                      
                                  ,pa_costs_dtl_tb(i).attribute3                      
                                  ,pa_costs_dtl_tb(i).attribute4                      
                                  ,pa_costs_dtl_tb(i).attribute5                      
                                  ,pa_costs_dtl_tb(i).attribute6                      
                                  ,pa_costs_dtl_tb(i).attribute7                      
                                  ,pa_costs_dtl_tb(i).attribute8                      
                                  ,pa_costs_dtl_tb(i).attribute9                      
                                  ,pa_costs_dtl_tb(i).attribute10                     
                                  ,pa_costs_dtl_tb(i).contract_number                 
                                  ,pa_costs_dtl_tb(i).contract_name                   
                                  ,pa_costs_dtl_tb(i).contract_id                     
                                  ,pa_costs_dtl_tb(i).funding_source_number           
                                  ,pa_costs_dtl_tb(i).funding_source_name             
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
                                    ,pt_i_ModuleMessage       => 'Close the Cursor src_pa_cost_dtl'
                                    ,pt_i_OracleError         => gvt_ReturnMessage       );   
                   --


                   IF src_pa_cost_dtl%ISOPEN
                   THEN
                        --
                           CLOSE src_pa_cost_dtl;
                        --
                   END IF;

               ELSE 
                  --
                  gvv_ProgressIndicator := '0090';
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
                                    ,pt_i_ModuleMessage       => 'Parameter Cost_ext_type is mandatory - Summary or Detail Extract'
                                    ,pt_i_OracleError         => gvt_ReturnMessage       );   
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
        IF pa_costs_cur%ISOPEN
        THEN
            --
            CLOSE pa_costs_cur;
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

         IF pa_costs_cur%ISOPEN
         THEN
             --
             CLOSE pa_costs_cur;
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



     END src_pa_nonlbr_costs;


   /*********************************************************
   --------------------src_pa_sup_costs-----------------------
   -- Extracts Project Supplier Cost from EBS
   ----------------------------------------------------------
   **********************************************************/

   PROCEDURE src_pa_sup_costs
                     (pt_i_MigrationSetID              IN      xxmx_migration_headers.migration_set_id%TYPE
                     ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE)
     AS   

          --
          --**********************
          --** Cursor Declarations
          --**********************
          --
            CURSOR pa_costs_cur
            IS
            select       
                'SUPPLIER' Transaction_type --  LABOR, NONLABOR
                ,business_unit --Nullify we consider BU based on Project Number
                ,org_id
                ,user_transaction_source
                ,transaction_source_id
                ,document_name
                ,document_id
                ,doc_entry_name
                ,doc_entry_id
                ,exp_batch_name
                ,batch_ending_date
                ,batch_description
                ,expenditure_item_date
                ,person_number
                ,person_name
                ,person_id
                ,hcm_assignment_name
                ,hcm_assignment_id
                ,project_number
                ,project_name
                ,project_id
                ,task_number
                ,task_name
                ,task_id
                ,expenditure_type
                ,expenditure_type_id
                ,organization_name                                                               --Organization_name
                ,organization_id
                ,non_labor_resource
                ,non_labor_resource_id
                ,non_labor_resource_org
                ,non_labor_resource_org_id
                ,quantity            
                ,unit_of_measure_name
                ,unit_of_measure
                ,work_type
                ,work_type_id
                ,billable_flag
                ,capitalizable_flag
                ,accrual_flag
                ,supplier_number
                ,supplier_name
                ,vendor_id
                ,inventory_item_name
                ,inventory_item_id
                ,orig_transaction_reference
                ,unmatched_negative_txn_flag
                ,reversed_orig_txn_reference
                ,expenditure_comment
                ,gl_date
                ,denom_currency_code
                ,denom_currency
                ,sum(denom_raw_cost)        AS denom_raw_cost                                          --denom_raw_cost
                ,sum(denom_burdened_cost)   AS denom_burdened_cost                                --denom_burdened_cost
                ,raw_cost_cr_ccid
                ,raw_cost_cr_account
                ,raw_cost_dr_ccid
                ,raw_cost_dr_account
                ,burdened_cost_cr_ccid
                ,burdened_cost_cr_account
                ,burdened_cost_dr_ccid
                ,burdened_cost_dr_account
                ,burden_cost_cr_ccid
                ,burden_cost_cr_account
                ,burden_cost_dr_ccid
                ,burden_cost_dr_account
                ,acct_currency_code
                ,acct_currency
                ,sum(acct_raw_cost)             AS acct_raw_cost -- based on UAT recon from business recon report
                ,sum(acct_burdened_cost)        AS acct_burdened_cost
                ,acct_rate_type 
                ,acct_rate_date
                ,acct_rate_date_type
                ,acct_exchange_rate
                ,acct_exchange_rounding_limit
                ,receipt_currency_code
                ,receipt_currency
                ,receipt_currency_amount
                ,receipt_exchange_rate
                ,converted_flag
                ,context_category
                ,user_def_attribute1
                ,user_def_attribute2
                ,user_def_attribute3
                ,user_def_attribute4
                ,user_def_attribute5
                ,user_def_attribute6
                ,user_def_attribute7
                ,user_def_attribute8
                ,user_def_attribute9
                ,user_def_attribute10
                ,reserved_attribute1
                ,reserved_attribute2
                ,reserved_attribute3
                ,reserved_attribute4
                ,reserved_attribute5
                ,reserved_attribute6
                ,reserved_attribute7
                ,reserved_attribute8
                ,reserved_attribute9
                ,reserved_attribute10
                ,attribute_category
                ,attribute1
                ,attribute2
                ,attribute3
                ,attribute4
                ,attribute5
                ,attribute6
                ,attribute7
                ,attribute9
                ,attribute8
                ,attribute10 -- to split costs Labor, NonLabor and Misc in EDQ
                ,contract_number
                ,contract_name
                ,contract_id
                ,funding_source_number
                ,funding_source_name
          from
        (SELECT distinct 
             NULL                                                                             AS transaction_type --  LABOR, NONLABOR
            ,haou1.name                                                                       AS business_unit --Nullify as we consider BU based on Project Number
            ,NULL                                                                             AS org_id
            ,null                                                                             AS user_transaction_source
            ,NULL                                                                             AS transaction_source_id
            ,NULL                                                                             AS document_name
            ,NULL                                                                             AS document_id
            ,NULL                                                                             AS doc_entry_name
            ,NULL                                                                             AS doc_entry_id
            ,NULL                                                                             AS exp_batch_name
            ,NULL                                                                             AS batch_ending_date
            ,NULL                                                                             AS batch_description
            ,NULL                                                                             AS expenditure_item_date
            ,NULL                                                                             AS person_number
            ,NULL                                                                             AS person_name
            ,NULL                                                                             AS person_id
            ,NULL                                                                             AS hcm_assignment_name
            ,NULL                                                                             As hcm_assignment_id
            ,ppa.project_number                                                               AS project_number
            ,ppa.project_name                                                                 AS project_name
            ,ppa.project_id                                                                   AS project_id
            ,NULL                                                                             AS task_number
            ,NULL                                                                             AS task_name
            ,NULL                                                                             AS task_id
            ,peia.expenditure_type                                                            AS expenditure_type
            ,NULL                                                                             AS expenditure_type_id
            ,(select haou2.name 
                from apps.hr_all_organization_units@MXDM_NVIS_EXTRACT haou2 
                     ,apps.pa_expenditures_all@MXDM_NVIS_EXTRACT pea1
                where haou2.organization_id= NVL (peia.override_to_organization_id, pea1.incurred_by_organization_id)
                and peia.expenditure_id = pea1.expenditure_id)                                AS organization_name  
            ,NULL                                                                             AS organization_id
            ,peia.non_labor_resource                                                          AS non_labor_resource
            ,NULL                                                                             AS non_labor_resource_id
            ,NULL                                                                             AS non_labor_resource_org
            ,NULL                                                                             AS non_labor_resource_org_id
            ,peia.quantity                                                                    AS quantity            
            ,NULL                                                                             AS unit_of_measure_name
            ,peia.unit_of_measure                                                             AS unit_of_measure
            ,NULL                                                                             AS work_type
            ,NULL                                                                             AS work_type_id
            ,NULL                                                                             AS billable_flag
            ,NULL                                                                             AS capitalizable_flag
            ,NULL                                                                             AS accrual_flag
            ,(Select sup.SEGMENT1 
              from ap_suppliers@MXDM_NVIS_EXTRACT sup
              where vendor_id = peia.vendor_id  )                                            As supplier_number
            ,(Select sup.vendor_name 
              from ap_suppliers@MXDM_NVIS_EXTRACT sup
              where vendor_id = peia.vendor_id  )                                             AS supplier_name
            ,peia.vendor_id                                                                   AS vendor_id
            ,(Select b.SEGMENT1 
              from mtl_system_items_b@MXDM_NVIS_EXTRACT b
              where vendor_id = peia.inventory_item_id 
              AND organization_id = peia.ORGANIZATION_ID)                                     As inventory_item_name
            ,peia.inventory_item_id                                                           AS inventory_item_id
            ,ppa.project_number||'-'||'DM2020'                                                AS orig_transaction_reference
            ,NULL                                                                             AS unmatched_negative_txn_flag
            ,NULL                                                                             AS reversed_orig_txn_reference
            ,NULL                                                                             AS expenditure_comment
            ,NULL                                                                             AS gl_date
            ,pcdla.denom_currency_code                                                        AS denom_currency_code
            ,NULL                                                                             AS denom_currency
            ,pcdla.denom_raw_cost                                                             AS denom_raw_cost
            ,peia.denom_burdened_cost                                                         AS denom_burdened_cost
            ,NULL                                                                             AS raw_cost_cr_ccid
            ,NULL                                                                             AS raw_cost_cr_account
            ,NULL                                                                             AS raw_cost_dr_ccid
            ,NULL                                                                             AS raw_cost_dr_account
            ,NULL                                                                             AS burdened_cost_cr_ccid
            ,NULL                                                                             AS burdened_cost_cr_account
            ,NULL                                                                             AS burdened_cost_dr_ccid
            ,NULL                                                                             AS burdened_cost_dr_account
            ,NULL                                                                             AS burden_cost_cr_ccid
            ,NULL                                                                             AS burden_cost_cr_account
            ,NULL                                                                             AS burden_cost_dr_ccid
            ,NULL                                                                             AS burden_cost_dr_account
            ,peia.acct_currency_code                                                          AS acct_currency_code
            ,NULL                                                                             AS acct_currency
            ,pcdla.acct_raw_cost                                                              AS acct_raw_cost  -- based on UAT recon from business recon report
            ,peia.acct_burdened_cost                                                          AS acct_burdened_cost
            ,peia.acct_rate_type                                                              AS acct_rate_type 
            ,peia.acct_rate_date                                                              AS acct_rate_date
            ,NULL                                                                             AS acct_rate_date_type
            ,peia.acct_exchange_rate                                                          AS acct_exchange_rate
            ,NULL                                                                             AS acct_exchange_rounding_limit
            ,NULL                                                                             AS receipt_currency_code
            ,NULL                                                                             AS receipt_currency
            ,NULL                                                                             AS receipt_currency_amount
            ,NULL                                                                             AS receipt_exchange_rate
            ,peia.converted_flag                                                              AS converted_flag
            ,NULL                                                                             As context_category
            ,NULL                                                                             AS user_def_attribute1
            ,NULL                                                                             AS user_def_attribute2
            ,NULL                                                                             AS user_def_attribute3
            ,NULL                                                                             AS user_def_attribute4
            ,NULL                                                                             AS user_def_attribute5
            ,NULL                                                                             AS user_def_attribute6
            ,NULL                                                                             AS user_def_attribute7
            ,NULL                                                                             AS user_def_attribute8
            ,NULL                                                                             AS user_def_attribute9
            ,NULL                                                                             AS user_def_attribute10
            ,NULL                                                                             As reserved_attribute1
            ,NULL                                                                             AS reserved_attribute2
            ,NULL                                                                             AS reserved_attribute3
            ,NULL                                                                             AS reserved_attribute4
            ,NULL                                                                             AS reserved_attribute5
            ,NULL                                                                             AS reserved_attribute6
            ,NULL                                                                             AS reserved_attribute7
            ,NULL                                                                             AS reserved_attribute8
            ,NULL                                                                             AS reserved_attribute9
            ,NULL                                                                             AS reserved_attribute10
            ,NULL                                                                             AS attribute_category
            ,NULL                                                                             AS attribute1
            ,NULL                                                                             AS attribute2
            ,NULL                                                                             AS attribute3
            ,NULL                                                                             AS attribute4
            ,NULL                                                                             AS attribute5
            ,NULL                                                                             AS attribute6
            ,NULL                                                                             AS attribute7
            ,NULL                                                                             AS attribute9
            ,NULL                                                                             AS attribute8
            ,null                                                                             AS attribute10 -- to split costs Labor, NonLabor and Misc in EDQ
            ,NULL                                                                             AS contract_number
            ,NULL                                                                             AS contract_name
            ,NULL                                                                             AS contract_id
            ,NULL                                                                             AS funding_source_number
            ,NULL                                                                             AS funding_source_name
            FROM  xxmx_ppm_projects_stg                                    ppa
                 ,apps.pa_expenditure_items_all@MXDM_NVIS_EXTRACT          peia
                 ,apps.hr_all_organization_units@MXDM_NVIS_EXTRACT         haou1
                 ,apps.pa_cost_distribution_lines_all@MXDM_NVIS_EXTRACT    pcdla
            WHERE ppa.project_id                    = peia.project_id
            AND pcdla.expenditure_item_id         = peia.expenditure_item_id
            AND pcdla.project_id                  = peia.project_id
            AND peia.org_id                       = haou1.organization_id
            AND  gl_date   BETWEEN TO_DATE(gvv_migration_date_from,'DD-MM-RRRR') AND TO_DATE(gvv_migration_date_to,'DD-MM-RRRR')
            AND system_linkage_function in (select parameter_value
                                                  from xxmx_migration_parameters
                                                  where application= 'PPM'
                                                  and application_suite= 'FIN'
                                                  and parameter_code = 'EXP_SYSTEM_LINK_TYPE'
                                                  and sub_entity = 'SUPPLIER_COST'
                                                  and enabled_flag = 'Y'
                                                  ) 

            ) src
             GROUP BY
                 Transaction_type --  LABOR, NONLABOR
                ,business_unit --Nullify we consider BU based on Project Number
                ,org_id
                ,user_transaction_source
                ,transaction_source_id
                ,document_name
                ,document_id
                ,doc_entry_name
                ,doc_entry_id
                ,exp_batch_name
                ,batch_ending_date
                ,batch_description
                ,expenditure_item_date
                ,person_number
                ,person_name
                ,person_id
                ,hcm_assignment_name
                ,hcm_assignment_id
                ,project_number
                ,project_name
                ,project_id
                ,task_number
                ,task_name
                ,task_id
                ,expenditure_type
                ,expenditure_type_id
                ,organization_name                                                               --Organization_name
                ,organization_id
                ,non_labor_resource
                ,non_labor_resource_id
                ,non_labor_resource_org
                ,non_labor_resource_org_id
                ,quantity            
                ,unit_of_measure_name
                ,unit_of_measure
                ,work_type
                ,work_type_id
                ,billable_flag
                ,capitalizable_flag
                ,accrual_flag
                ,supplier_number
                ,supplier_name
                ,vendor_id
                ,inventory_item_name
                ,inventory_item_id
                ,orig_transaction_reference
                ,unmatched_negative_txn_flag
                ,reversed_orig_txn_reference
                ,expenditure_comment
                ,gl_date
                ,denom_currency_code
                ,denom_currency
                ,raw_cost_cr_ccid
                ,raw_cost_cr_account
                ,raw_cost_dr_ccid
                ,raw_cost_dr_account
                ,burdened_cost_cr_ccid
                ,burdened_cost_cr_account
                ,burdened_cost_dr_ccid
                ,burdened_cost_dr_account
                ,burden_cost_cr_ccid
                ,burden_cost_cr_account
                ,burden_cost_dr_ccid
                ,burden_cost_dr_account
                ,acct_currency_code
                ,acct_currency
                ,acct_rate_type 
                ,acct_rate_date
                ,acct_rate_date_type
                ,acct_exchange_rate
                ,acct_exchange_rounding_limit
                ,receipt_currency_code
                ,receipt_currency
                ,receipt_currency_amount
                ,receipt_exchange_rate
                ,converted_flag
                ,context_category
                ,user_def_attribute1
                ,user_def_attribute2
                ,user_def_attribute3
                ,user_def_attribute4
                ,user_def_attribute5
                ,user_def_attribute6
                ,user_def_attribute7
                ,user_def_attribute8
                ,user_def_attribute9
                ,user_def_attribute10
                ,reserved_attribute1
                ,reserved_attribute2
                ,reserved_attribute3
                ,reserved_attribute4
                ,reserved_attribute5
                ,reserved_attribute6
                ,reserved_attribute7
                ,reserved_attribute8
                ,reserved_attribute9
                ,reserved_attribute10
                ,attribute_category
                ,attribute1
                ,attribute2
                ,attribute3
                ,attribute4
                ,attribute5
                ,attribute6
                ,attribute7
                ,attribute9
                ,attribute8
                ,attribute10 -- to split costs Labor, NonLabor and Misc in EDQ
                ,contract_number
                ,contract_name
                ,contract_id
                ,funding_source_number
                ,funding_source_name   
                  ;


        CURSOR src_pa_cost_dtl
        IS
             select  'SUPPLIER' Transaction_type --  LABOR, NONLABOR
                ,business_unit --Nullify we consider BU based on Project Number
                ,org_id
                ,user_transaction_source
                ,transaction_source_id
                ,document_name
                ,document_id
                ,doc_entry_name
                ,doc_entry_id
                ,exp_batch_name
                ,batch_ending_date
                ,batch_description
                ,expenditure_item_date
                ,person_number
                ,person_name
                ,person_id
                ,hcm_assignment_name
                ,hcm_assignment_id
                ,project_number
                ,project_name
                ,project_id
                ,task_number
                ,task_name
                ,task_id
                ,expenditure_type
                ,expenditure_type_id
                ,organization_name                                                               --Organization_name
                ,organization_id
                ,non_labor_resource
                ,non_labor_resource_id
                ,non_labor_resource_org
                ,non_labor_resource_org_id
                ,quantity            
                ,unit_of_measure_name
                ,unit_of_measure
                ,work_type
                ,work_type_id
                ,billable_flag
                ,capitalizable_flag
                ,accrual_flag
                ,supplier_number
                ,supplier_name
                ,vendor_id
                ,inventory_item_name
                ,inventory_item_id
                ,orig_transaction_reference
                ,unmatched_negative_txn_flag
                ,reversed_orig_txn_reference
                ,expenditure_comment
                ,gl_date
                ,denom_currency_code
                ,denom_currency
                ,sum(denom_raw_cost)        AS denom_raw_cost                                          --denom_raw_cost
                ,sum(denom_burdened_cost)   AS denom_burdened_cost                                --denom_burdened_cost
                ,raw_cost_cr_ccid
                ,raw_cost_cr_account
                ,raw_cost_dr_ccid
                ,raw_cost_dr_account
                ,burdened_cost_cr_ccid
                ,burdened_cost_cr_account
                ,burdened_cost_dr_ccid
                ,burdened_cost_dr_account
                ,burden_cost_cr_ccid
                ,burden_cost_cr_account
                ,burden_cost_dr_ccid
                ,burden_cost_dr_account
                ,acct_currency_code
                ,acct_currency
                ,sum(acct_raw_cost)             AS acct_raw_cost -- based on UAT recon from business recon report
                ,sum(acct_burdened_cost)        AS acct_burdened_cost
                ,acct_rate_type 
                ,acct_rate_date
                ,acct_rate_date_type
                ,acct_exchange_rate
                ,acct_exchange_rounding_limit
                ,receipt_currency_code
                ,receipt_currency
                ,receipt_currency_amount
                ,receipt_exchange_rate
                ,converted_flag
                ,context_category
                ,user_def_attribute1
                ,user_def_attribute2
                ,user_def_attribute3
                ,user_def_attribute4
                ,user_def_attribute5
                ,user_def_attribute6
                ,user_def_attribute7
                ,user_def_attribute8
                ,user_def_attribute9
                ,user_def_attribute10
                ,reserved_attribute1
                ,reserved_attribute2
                ,reserved_attribute3
                ,reserved_attribute4
                ,reserved_attribute5
                ,reserved_attribute6
                ,reserved_attribute7
                ,reserved_attribute8
                ,reserved_attribute9
                ,reserved_attribute10
                ,attribute_category
                ,attribute1
                ,attribute2
                ,attribute3
                ,attribute4
                ,attribute5
                ,attribute6
                ,attribute7
                ,attribute9
                ,attribute8
                ,attribute10 -- to split costs Labor, NonLabor and Misc in EDQ
                ,contract_number
                ,contract_name
                ,contract_id
                ,funding_source_number
                ,funding_source_name                                                                                                          funding_source_name
           from(SELECT 
            NULL                                                                                                             transaction_type --  LABOR, NONLABOR
            ,haou1.name                                                                                                        business_unit --Nullify as we consider BU based on Project Number
            ,NULL                                                                                                             org_id
            ,null                                                                                                             user_transaction_source
            ,NULL                                                                                                             transaction_source_id
            ,NULL                                                                                                             document_name
            ,NULL                                                                                                             document_id
            ,NULL                                                                                                             doc_entry_name
            ,NULL                                                                                                             doc_entry_id
            --  'Data Migration'                                                                                              exp_batch_name
            ,(SELECT pea.expenditure_group
              FROM apps.pa_expenditures_all@MXDM_NVIS_EXTRACT pea
              WHERE peia.expenditure_id = pea.expenditure_id)                                                                 exp_batch_name
            ,(SELECT pea.expenditure_ending_date
              FROM apps.pa_expenditures_all@MXDM_NVIS_EXTRACT pea
              WHERE peia.expenditure_id = pea.expenditure_id)                                                                 batch_ending_date
            ,(SELECT pea.description
              FROM apps.pa_expenditures_all@MXDM_NVIS_EXTRACT pea
              WHERE peia.expenditure_id = pea.expenditure_id)                                                                 batch_description
            ,peia.expenditure_item_date                                                                                       expenditure_item_date
            ,NULL                                                                                                             person_number
            ,NULL                                                                                                             person_name
            ,NULL                                                                                                             person_id
            ,NULL                                                                                                             hcm_assignment_name
            ,NULL                                                                                                             hcm_assignment_id
            ,ppa.project_number                                                                                               project_number
            ,ppa.project_name                                                                                                 project_name
            ,NULL                                                                                                             project_id
            ,pt.task_number                                                                                                   task_number
            ,pt.task_name                                                                                                     task_name
            --,ppa.segment1||'-'||'DM2020'                                                                                    task_number
            --,ppa.segment1||'-'||'DM2020'                                                                                                     task_name
            ,NULL                                                                                                             task_id
            ,peia.expenditure_type                                                                                            expenditure_type
            ,NULL                                                                                                             expenditure_type_id
            ,(select haou2.name 
                from apps.hr_all_organization_units@MXDM_NVIS_EXTRACT haou2 
                     ,apps.pa_expenditures_all@MXDM_NVIS_EXTRACT pea1
                where haou2.organization_id= NVL (peia.override_to_organization_id, pea1.incurred_by_organization_id)
                  and peia.expenditure_id = pea1.expenditure_id)                                                               organization_name

            ,NULL                                                                                                             organization_id -- POO from Project Number Mapped in EDQ
            ,peia.non_labor_resource                                                                                          non_labor_resource
            ,NULL                                                                                                             non_labor_resource_id
            ,null                                                                                                             non_labor_resource_org
            ,NULL                                                                                                             non_labor_resource_org_id
            ,peia.quantity                                                                                                    quantity
            ,NULL                                                                                                             unit_of_measure_name
            ,peia.unit_of_measure                                                                                             unit_of_measure
            ,(SELECT name
              FROM   apps.pa_work_types_tl@MXDM_NVIS_EXTRACT pwtt--apps.PA_TASKS_V@MXDM_NVIS_EXTRACT
              WHERE  peia.work_type_id=pwtt.work_type_id)                                                                     work_type
            ,NULL                                                                                                             work_type_id
            ,peia.billable_flag                                                                                               billable_flag
            ,NULL                                                                                                             capitalizable_flag
            ,NULL                                                                                                             accrual_flag
             ,(Select sup.SEGMENT1 
              from ap_suppliers@MXDM_NVIS_EXTRACT sup
              where vendor_id = peia.vendor_id  )                                            As supplier_number
            ,(Select sup.vendor_name 
              from ap_suppliers@MXDM_NVIS_EXTRACT sup
              where vendor_id = peia.vendor_id  )                                             AS supplier_name
            ,peia.vendor_id                                                                   AS vendor_id
            ,(Select b.SEGMENT1 
              from mtl_system_items_b@MXDM_NVIS_EXTRACT b
              where vendor_id = peia.inventory_item_id 
              AND organization_id = peia.ORGANIZATION_ID)                                     As inventory_item_name
            ,peia.inventory_item_id                                                           AS inventory_item_id
            ,ppa.project_number||'-'||'DM2020'                                                                                orig_transaction_reference
            ,NULL                                                                                                             unmatched_negative_txn_flag
            ,NULL                                                                                                             reversed_orig_txn_reference
            ,NULL                                                                                                             expenditure_comment
            ,pcdla.gl_date                                                                                                    gl_date
            ,pcdla.denom_currency_code                                                                                         denom_currency_code
            ,NULL                                                                                                             denom_currency
            ,pcdla.denom_raw_cost                                                                                              denom_raw_cost
            ,peia.denom_burdened_cost                                                                                         denom_burdened_cost
            ,NULL                                                                                                             raw_cost_cr_ccid
            ,NULL                                                                                                             raw_cost_cr_account
            ,NULL                                                                                                             raw_cost_dr_ccid
            ,NULL                                                                                                             raw_cost_dr_account
            ,NULL                                                                                                             burdened_cost_cr_ccid
            ,NULL                                                                                                             burdened_cost_cr_account
            ,NULL                                                                                                             burdened_cost_dr_ccid
            ,NULL                                                                                                             burdened_cost_dr_account
            ,NULL                                                                                                             burden_cost_cr_ccid
            ,NULL                                                                                                             burden_cost_cr_account
            ,NULL                                                                                                             burden_cost_dr_ccid
            ,NULL                                                                                                             burden_cost_dr_account
            ,peia.acct_currency_code                                                                                          acct_currency_code
            ,NULL                                                                                                             acct_currency
            ,pcdla.acct_raw_cost                                                                                               acct_raw_cost  -- based on UAT recon from business recon report
            ,peia.acct_burdened_cost                                                                                          acct_burdened_cost
            ,peia.acct_rate_type                                                                                              acct_rate_type
            ,peia.acct_rate_date                                                                                              acct_rate_date
            ,NULL                                                                                                             acct_rate_date_type
            ,peia.acct_exchange_rate                                                                                          acct_exchange_rate
            ,NULL                                                                                                             acct_exchange_rounding_limit
            ,NULL                                                                                                             receipt_currency_code
            ,NULL                                                                                                             receipt_currency
            ,NULL                                                                                                             receipt_currency_amount
            ,NULL                                                                                                             receipt_exchange_rate
            ,peia.converted_flag                                                                                              converted_flag
            ,NULL                                                                                                             context_category
            ,NULL                                                                                                             user_def_attribute1
            ,NULL                                                                                                             user_def_attribute2
            ,NULL                                                                                                             user_def_attribute3
            ,NULL                                                                                                             user_def_attribute4
            ,NULL                                                                                                             user_def_attribute5
            ,NULL                                                                                                             user_def_attribute6
            ,NULL                                                                                                             user_def_attribute7
            ,NULL                                                                                                             user_def_attribute8
            ,NULL                                                                                                             user_def_attribute9
            ,NULL                                                                                                             user_def_attribute10
            ,NULL                                                                                                             reserved_attribute1
            ,NULL                                                                                                             reserved_attribute2
            ,NULL                                                                                                             reserved_attribute3
            ,NULL                                                                                                             reserved_attribute4
            ,NULL                                                                                                             reserved_attribute5
            ,NULL                                                                                                             reserved_attribute6
            ,NULL                                                                                                             reserved_attribute7
            ,NULL                                                                                                             reserved_attribute8
            ,NULL                                                                                                             reserved_attribute9
            ,NULL                                                                                                             reserved_attribute10
            ,NULL                                                                                                             attribute_category
            ,NULL                                                                                                             attribute1
            ,NULL                                                                                                             attribute2
            ,NULL                                                                                                             attribute3
            ,NULL                                                                                                             attribute4
            ,NULL                                                                                                             attribute5
            ,NULL                                                                                                             attribute6
            ,NULL                                                                                                             attribute7
            ,NULL                                                                                                             attribute9
            ,NULL                                                                                                             attribute8
            ,null                                                                                                             attribute10 -- to split costs Labor, NonLabor and Misc in EDQ
            ,NULL                                                                                                             contract_number
            ,NULL                                                                                                             contract_name
            ,NULL                                                                                                             contract_id
            ,NULL                                                                                                             funding_source_number
            ,NULL                                                                                                             funding_source_name
            FROM  xxmx_ppm_projects_stg                                    ppa
                 ,apps.pa_expenditure_items_all@MXDM_NVIS_EXTRACT          peia
                 ,apps.pa_tasks@MXDM_NVIS_EXTRACT                          pt
                 ,apps.hr_all_organization_units@MXDM_NVIS_EXTRACT         haou1
                 ,apps.pa_cost_distribution_lines_all@MXDM_NVIS_EXTRACT    pcdla
                 --,apps.gl_code_combinations@MXDM_NVIS_EXTRACT gcc
            WHERE ppa.project_id                    = peia.project_id
--              AND peia.cc_cross_charge_type <> 'IC'
              and pt.project_id = ppa.project_id
              AND pt.project_id                     = peia.project_id
              AND pt.task_id   (+)                     = peia.task_id
              AND pcdla.expenditure_item_id         = peia.expenditure_item_id
              AND pcdla.project_id                  = peia.project_id
              AND pt.task_id                        = pcdla.task_id
              AND peia.org_id                       = haou1.organization_id
            --AND   peia.org_id                       = haou1.organization_id
            --AND   peia.expenditure_id               = pea.expenditure_id
            AND   ( pt.completion_date              IS NULL
                    OR pt.completion_date           > SYSDATE)   
            --and peia.EXPENDITURE_ITEM_ID=56028655        
            AND NOT EXISTS ( SELECT 1 FROM apps.pa_tasks@MXDM_NVIS_EXTRACT b WHERE b.parent_task_id=pt.task_id)
            --AND peia.expenditure_item_date >= to_date('01-JAN-2020','DD-MON-RRRR')
            /*AND   TO_CHAR(TO_DATE(pcdla.gl_period_name,'Mon-RR'),'RRRR') IN( SELECT TO_CHAR(TO_DATE(parameter_value,'Mon-RR'),'RRRR') 
                                                                                from xxmx_migration_parameters
                                                                                where parameter_code  = 'GL_PERIOD_NAME'
                                                                                and application = 'PPM')*/
            AND  pcdla.gl_date BETWEEN TO_DATE(gvv_migration_date_from,'DD-MM-RRRR') AND TO_DATE(gvv_migration_date_to,'DD-MM-RRRR')  
            AND system_linkage_function in (select parameter_value
                                                  from xxmx_migration_parameters
                                                  where application= 'PPM'
                                                  and application_suite= 'FIN'
                                                  and parameter_code = 'EXP_SYSTEM_LINK_TYPE'
                                                  and sub_entity = 'SUPPLIER_COST'
                                                  and enabled_flag = 'Y'
                                                  )                    
                    --AND pcdla.project_id = 2073
                    )
            GROUP BY
            Transaction_type --  LABOR, NONLABOR
                ,business_unit --Nullify we consider BU based on Project Number
                ,org_id
                ,user_transaction_source
                ,transaction_source_id
                ,document_name
                ,document_id
                ,doc_entry_name
                ,doc_entry_id
                ,exp_batch_name
                ,batch_ending_date
                ,batch_description
                ,expenditure_item_date
                ,person_number
                ,person_name
                ,person_id
                ,hcm_assignment_name
                ,hcm_assignment_id
                ,project_number
                ,project_name
                ,project_id
                ,task_number
                ,task_name
                ,task_id
                ,expenditure_type
                ,expenditure_type_id
                ,organization_name                                                               --Organization_name
                ,organization_id
                ,non_labor_resource
                ,non_labor_resource_id
                ,non_labor_resource_org
                ,non_labor_resource_org_id
                ,quantity            
                ,unit_of_measure_name
                ,unit_of_measure
                ,work_type
                ,work_type_id
                ,billable_flag
                ,capitalizable_flag
                ,accrual_flag
                ,supplier_number
                ,supplier_name
                ,vendor_id
                ,inventory_item_name
                ,inventory_item_id
                ,orig_transaction_reference
                ,unmatched_negative_txn_flag
                ,reversed_orig_txn_reference
                ,expenditure_comment
                ,gl_date
                ,denom_currency_code
                ,denom_currency
                ,raw_cost_cr_ccid
                ,raw_cost_cr_account
                ,raw_cost_dr_ccid
                ,raw_cost_dr_account
                ,burdened_cost_cr_ccid
                ,burdened_cost_cr_account
                ,burdened_cost_dr_ccid
                ,burdened_cost_dr_account
                ,burden_cost_cr_ccid
                ,burden_cost_cr_account
                ,burden_cost_dr_ccid
                ,burden_cost_dr_account
                ,acct_currency_code
                ,acct_currency
                ,acct_rate_type 
                ,acct_rate_date
                ,acct_rate_date_type
                ,acct_exchange_rate
                ,acct_exchange_rounding_limit
                ,receipt_currency_code
                ,receipt_currency
                ,receipt_currency_amount
                ,receipt_exchange_rate
                ,converted_flag
                ,context_category
                ,user_def_attribute1
                ,user_def_attribute2
                ,user_def_attribute3
                ,user_def_attribute4
                ,user_def_attribute5
                ,user_def_attribute6
                ,user_def_attribute7
                ,user_def_attribute8
                ,user_def_attribute9
                ,user_def_attribute10
                ,reserved_attribute1
                ,reserved_attribute2
                ,reserved_attribute3
                ,reserved_attribute4
                ,reserved_attribute5
                ,reserved_attribute6
                ,reserved_attribute7
                ,reserved_attribute8
                ,reserved_attribute9
                ,reserved_attribute10
                ,attribute_category
                ,attribute1
                ,attribute2
                ,attribute3
                ,attribute4
                ,attribute5
                ,attribute6
                ,attribute7
                ,attribute9
                ,attribute8
                ,attribute10 -- to split costs Labor, NonLabor and Misc in EDQ
                ,contract_number
                ,contract_name
                ,contract_id
                ,funding_source_number
                ,funding_source_name;
       --
       --**********************
       --** Record Declarations
       --**********************
       --
        TYPE pa_costs_tbl IS TABLE OF pa_costs_cur%ROWTYPE INDEX BY BINARY_INTEGER;
        pa_costs_tb  pa_costs_tbl;

        TYPE pa_costs_dtl_tbl IS TABLE OF src_pa_cost_dtl%ROWTYPE INDEX BY BINARY_INTEGER;
        pa_costs_dtl_tb  pa_costs_dtl_tbl;



       --
       --************************
       --** Constant Declarations
       --************************
       --
        cv_ProcOrFuncName                   CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'src_pa_sup_costs';
        cv_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_PPM_PRJ_SUPCOST_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'SUPPLIER_COST';
        gv_i_BusinessEntity                                 VARCHAR2(100)     := 'PRJ_COST';


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

        gvv_cost_ext_type := xxmx_utilities_pkg.get_single_parameter_value(
                        pt_i_ApplicationSuite           =>     gct_ApplicationSuite
                        ,pt_i_Application                =>     gct_Application
                        ,pt_i_BusinessEntity             =>     'PRJ_COST'
                        ,pt_i_SubEntity                  =>     'ALL'
                        ,pt_i_ParameterCode              =>     'COST_EXT_TYPE');

        gvv_migration_date_from := xxmx_utilities_pkg.get_single_parameter_value(
                        pt_i_ApplicationSuite           =>     gct_ApplicationSuite
                        ,pt_i_Application                =>     gct_Application
                        ,pt_i_BusinessEntity             =>     'ALL'
                        ,pt_i_SubEntity                  =>     'ALL'
                        ,pt_i_ParameterCode              =>     'EXTRACT_START_DATE'
        );        
        --gvd_migration_date_from := TO_DATE(gvv_migration_date_from,'YYYY-MM-DD');


        gvv_migration_date_to := xxmx_utilities_pkg.get_single_parameter_value(
                        pt_i_ApplicationSuite           =>     gct_ApplicationSuite
                        ,pt_i_Application                =>     gct_Application
                        ,pt_i_BusinessEntity             =>     'ALL'
                        ,pt_i_SubEntity                  =>     'ALL'
                        ,pt_i_ParameterCode              =>     'EXTRACT_END_DATE'
        );        
       -- gvd_migration_date_to := TO_DATE(gvv_migration_date_to,'YYYY-MM-DD');
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
        FROM    XXMX_PPM_PRJ_SUPCOST_STG ;

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

            IF( UPPER(gvv_cost_ext_type) = 'SUMMARY') THEN 
                  OPEN pa_costs_cur;
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
                         ,pt_i_ModuleMessage       =>'Cursor Open src_pa_billing_events_cur'
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
                  FETCH pa_costs_cur  BULK COLLECT INTO pa_costs_tb LIMIT 1000;
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
                         ,pt_i_ModuleMessage       => 'Cursor pa_costs_cur Fetch into pa_costs_tb'
                         ,pt_i_OracleError         => gvt_ReturnMessage  );
                  --
                  EXIT WHEN pa_costs_tb.COUNT=0;
                  --
                  FORALL I IN 1..pa_costs_tb.COUNT SAVE EXCEPTIONS
                  --
                       INSERT INTO XXMX_PPM_PRJ_SUPCOST_STG (
                                           migration_set_id                 
                                          ,migration_set_name               
                                          ,migration_status                 
                                          ,transaction_type                
                                          ,business_unit                   
                                          ,org_id                          
                                          ,user_transaction_source         
                                          ,transaction_source_id           
                                          ,document_name                   
                                          ,document_id                     
                                          ,doc_entry_name                  
                                          ,doc_entry_id                    
                                          ,batch_ending_date               
                                          ,batch_description               
                                          ,expenditure_item_date           
                                         -- ,person_number                   
                                         -- ,person_name                     
                                         -- ,person_id                       
                                        --  ,hcm_assignment_name             
                                        --  ,hcm_assignment_id               
                                          ,project_number                  
                                          ,project_name                    
                                          ,project_id                      
                                          ,task_number                     
                                          ,task_name                       
                                          ,task_id                         
                                          ,expenditure_type                
                                          ,expenditure_type_id             
                                          ,organization_name               
                                          ,organization_id                 
                                         -- ,non_labor_resource              
                                          --,non_labor_resource_id           
                                          --,non_labor_resource_org          
                                          --,non_labor_resource_org_id       
                                          ,quantity                        
                                          ,unit_of_measure_name            
                                          ,unit_of_measure                 
                                          ,work_type                       
                                          ,work_type_id                    
                                          ,billable_flag                   
                                          ,capitalizable_flag              
                                          ,accrual_flag                    
                                          ,supplier_number                 
                                          ,supplier_name                   
                                          ,vendor_id                       
                                          --,inventory_item_name             
                                          --,inventory_item_id               
                                          ,orig_transaction_reference      
                                          ,unmatched_negative_txn_flag     
                                          ,reversed_orig_txn_reference     
                                          ,expenditure_comment             
                                          ,gl_date                         
                                          ,denom_currency_code             
                                          ,denom_currency                  
                                          ,denom_raw_cost                  
                                          ,denom_burdened_cost             
                                          ,raw_cost_cr_ccid                
                                          ,raw_cost_cr_account             
                                          ,raw_cost_dr_ccid                
                                          ,raw_cost_dr_account             
                                          ,burdened_cost_cr_ccid           
                                          ,burdened_cost_cr_account        
                                          ,burdened_cost_dr_ccid           
                                          ,burdened_cost_dr_account        
                                          ,burden_cost_cr_ccid             
                                          ,burden_cost_cr_account          
                                          ,burden_cost_dr_ccid             
                                          ,burden_cost_dr_account          
                                          ,acct_currency_code              
                                          ,acct_currency                   
                                          ,acct_raw_cost                   
                                          ,acct_burdened_cost              
                                          ,acct_rate_type                  
                                          ,acct_rate_date                  
                                          ,acct_rate_date_type             
                                          ,acct_exchange_rate              
                                          ,acct_exchange_rounding_limit    
                                          --,receipt_currency_code           
                                          --,receipt_currency                
                                          --,receipt_currency_amount         
                                         -- ,receipt_exchange_rate           
                                          ,converted_flag                  
                                          ,context_category                
                                          ,user_def_attribute1             
                                          ,user_def_attribute2             
                                          ,user_def_attribute3             
                                          ,user_def_attribute4             
                                          ,user_def_attribute5             
                                          ,user_def_attribute6             
                                          ,user_def_attribute7             
                                          ,user_def_attribute8             
                                          ,user_def_attribute9             
                                          ,user_def_attribute10            
                                          ,reserved_attribute1             
                                          ,reserved_attribute2             
                                          ,reserved_attribute3             
                                          ,reserved_attribute4             
                                          ,reserved_attribute5             
                                          ,reserved_attribute6             
                                          ,reserved_attribute7             
                                          ,reserved_attribute8             
                                          ,reserved_attribute9             
                                          ,reserved_attribute10            
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
                                          ,contract_number                 
                                          ,contract_name                   
                                          ,contract_id                     
                                          ,funding_source_number           
                                          ,funding_source_name             
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
                                  ,pa_costs_tb(i).transaction_type                
                                  ,pa_costs_tb(i).business_unit                   
                                  ,pa_costs_tb(i).org_id                          
                                  ,pa_costs_tb(i).user_transaction_source         
                                  ,pa_costs_tb(i).transaction_source_id           
                                  ,pa_costs_tb(i).document_name                   
                                  ,pa_costs_tb(i).document_id                     
                                  ,pa_costs_tb(i).doc_entry_name                  
                                  ,pa_costs_tb(i).doc_entry_id                    
                                  ,pa_costs_tb(i).batch_ending_date               
                                  ,pa_costs_tb(i).batch_description               
                                  ,pa_costs_tb(i).expenditure_item_date           
                                  --,pa_costs_tb(i).person_number                   
                                  --,pa_costs_tb(i).person_name                     
                                  --,pa_costs_tb(i).person_id                       
                                  --,pa_costs_tb(i).hcm_assignment_name             
                                  --,pa_costs_tb(i).hcm_assignment_id               
                                  ,pa_costs_tb(i).project_number                  
                                  ,pa_costs_tb(i).project_name                    
                                  ,pa_costs_tb(i).project_id                      
                                  ,pa_costs_tb(i).task_number                     
                                  ,pa_costs_tb(i).task_name                       
                                  ,pa_costs_tb(i).task_id                         
                                  ,pa_costs_tb(i).expenditure_type                
                                  ,pa_costs_tb(i).expenditure_type_id             
                                  ,pa_costs_tb(i).organization_name               
                                  ,pa_costs_tb(i).organization_id                 
                                  --,pa_costs_tb(i).non_labor_resource              
                                  --,pa_costs_tb(i).non_labor_resource_id           
                                  --,pa_costs_tb(i).non_labor_resource_org          
                                  --,pa_costs_tb(i).non_labor_resource_org_id       
                                  ,pa_costs_tb(i).quantity                        
                                  ,pa_costs_tb(i).unit_of_measure_name            
                                  ,pa_costs_tb(i).unit_of_measure                 
                                  ,pa_costs_tb(i).work_type                       
                                  ,pa_costs_tb(i).work_type_id                    
                                  ,pa_costs_tb(i).billable_flag                   
                                  ,pa_costs_tb(i).capitalizable_flag              
                                  ,pa_costs_tb(i).accrual_flag                    
                                  ,pa_costs_tb(i).supplier_number                 
                                  ,pa_costs_tb(i).supplier_name                   
                                  ,pa_costs_tb(i).vendor_id                       
                                --  ,pa_costs_tb(i).inventory_item_name             
                                --  ,pa_costs_tb(i).inventory_item_id               
                                  ,pa_costs_tb(i).orig_transaction_reference      
                                  ,pa_costs_tb(i).unmatched_negative_txn_flag     
                                  ,pa_costs_tb(i).reversed_orig_txn_reference     
                                  ,pa_costs_tb(i).expenditure_comment             
                                  ,pa_costs_tb(i).gl_date                         
                                  ,pa_costs_tb(i).denom_currency_code             
                                  ,pa_costs_tb(i).denom_currency                  
                                  ,pa_costs_tb(i).denom_raw_cost                  
                                  ,pa_costs_tb(i).denom_burdened_cost             
                                  ,pa_costs_tb(i).raw_cost_cr_ccid                
                                  ,pa_costs_tb(i).raw_cost_cr_account             
                                  ,pa_costs_tb(i).raw_cost_dr_ccid                
                                  ,pa_costs_tb(i).raw_cost_dr_account             
                                  ,pa_costs_tb(i).burdened_cost_cr_ccid           
                                  ,pa_costs_tb(i).burdened_cost_cr_account        
                                  ,pa_costs_tb(i).burdened_cost_dr_ccid           
                                  ,pa_costs_tb(i).burdened_cost_dr_account        
                                  ,pa_costs_tb(i).burden_cost_cr_ccid             
                                  ,pa_costs_tb(i).burden_cost_cr_account           
                                  ,pa_costs_tb(i).burden_cost_dr_ccid             
                                  ,pa_costs_tb(i).burden_cost_dr_account          
                                  ,pa_costs_tb(i).acct_currency_code              
                                  ,pa_costs_tb(i).acct_currency                   
                                  ,pa_costs_tb(i).acct_raw_cost                   
                                  ,pa_costs_tb(i).acct_burdened_cost              
                                  ,pa_costs_tb(i).acct_rate_type                  
                                  ,pa_costs_tb(i).acct_rate_date                  
                                  ,pa_costs_tb(i).acct_rate_date_type             
                                  ,pa_costs_tb(i).acct_exchange_rate              
                                  ,pa_costs_tb(i).acct_exchange_rounding_limit    
                                  --,pa_costs_tb(i).receipt_currency_code           
                                  --,pa_costs_tb(i).receipt_currency                
                                  --,pa_costs_tb(i).receipt_currency_amount         
                                  --,pa_costs_tb(i).receipt_exchange_rate           
                                  ,pa_costs_tb(i).converted_flag                  
                                  ,pa_costs_tb(i).context_category                
                                  ,pa_costs_tb(i).user_def_attribute1             
                                  ,pa_costs_tb(i).user_def_attribute2             
                                  ,pa_costs_tb(i).user_def_attribute3             
                                  ,pa_costs_tb(i).user_def_attribute4             
                                  ,pa_costs_tb(i).user_def_attribute5             
                                  ,pa_costs_tb(i).user_def_attribute6             
                                  ,pa_costs_tb(i).user_def_attribute7             
                                  ,pa_costs_tb(i).user_def_attribute8             
                                  ,pa_costs_tb(i).user_def_attribute9             
                                  ,pa_costs_tb(i).user_def_attribute10            
                                  ,pa_costs_tb(i).reserved_attribute1             
                                  ,pa_costs_tb(i).reserved_attribute2             
                                  ,pa_costs_tb(i).reserved_attribute3             
                                  ,pa_costs_tb(i).reserved_attribute4             
                                  ,pa_costs_tb(i).reserved_attribute5             
                                  ,pa_costs_tb(i).reserved_attribute6             
                                  ,pa_costs_tb(i).reserved_attribute7             
                                  ,pa_costs_tb(i).reserved_attribute8             
                                  ,pa_costs_tb(i).reserved_attribute9             
                                  ,pa_costs_tb(i).reserved_attribute10            
                                  ,pa_costs_tb(i).attribute_category              
                                  ,pa_costs_tb(i).attribute1                      
                                  ,pa_costs_tb(i).attribute2                      
                                  ,pa_costs_tb(i).attribute3                      
                                  ,pa_costs_tb(i).attribute4                      
                                  ,pa_costs_tb(i).attribute5                      
                                  ,pa_costs_tb(i).attribute6                      
                                  ,pa_costs_tb(i).attribute7                      
                                  ,pa_costs_tb(i).attribute8                      
                                  ,pa_costs_tb(i).attribute9                      
                                  ,pa_costs_tb(i).attribute10                     
                                  ,pa_costs_tb(i).contract_number                 
                                  ,pa_costs_tb(i).contract_name                   
                                  ,pa_costs_tb(i).contract_id                     
                                  ,pa_costs_tb(i).funding_source_number           
                                  ,pa_costs_tb(i).funding_source_name             
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
                                    ,pt_i_ModuleMessage       => 'Close the Cursor pa_costs_cur'
                                    ,pt_i_OracleError         => gvt_ReturnMessage       );   
                   --


                   IF pa_costs_cur%ISOPEN
                   THEN
                        --
                           CLOSE pa_costs_cur;
                        --
                   END IF;

            ELSIF ( UPPER(gvv_cost_ext_type) = 'DETAIL')   
            THEN

                  OPEN src_pa_cost_dtl;
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
                         ,pt_i_ModuleMessage       =>'Cursor Open src_pa_cost_dtl'
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
                  FETCH src_pa_cost_dtl  BULK COLLECT INTO pa_costs_dtl_tb LIMIT 1000;
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
                         ,pt_i_ModuleMessage       => 'Cursor src_pa_cost_dtl Fetch into pa_costs_dtl_tb'
                         ,pt_i_OracleError         => gvt_ReturnMessage  );
                  --
                  EXIT WHEN pa_costs_dtl_tb.COUNT=0;
                  --
                  FORALL I IN 1..pa_costs_dtl_tb.COUNT SAVE EXCEPTIONS
                  --
                       INSERT INTO XXMX_PPM_PRJ_SUPCOST_STG (
                                           migration_set_id                 
                                          ,migration_set_name               
                                          ,migration_status                 
                                          ,transaction_type                
                                          ,business_unit                   
                                          ,org_id                          
                                          ,user_transaction_source         
                                          ,transaction_source_id           
                                          ,document_name                   
                                          ,document_id                     
                                          ,doc_entry_name                  
                                          ,doc_entry_id                    
                                          ,batch_ending_date               
                                          ,batch_description               
                                          ,expenditure_item_date           
                                          --,person_number                   
                                          --,person_name                     
                                          --,person_id                       
                                         -- ,hcm_assignment_name             
                                         -- ,hcm_assignment_id               
                                          ,project_number                  
                                          ,project_name                    
                                          ,project_id                      
                                          ,task_number                     
                                          ,task_name                       
                                          ,task_id                         
                                          ,expenditure_type                
                                          ,expenditure_type_id             
                                          ,organization_name               
                                          ,organization_id                 
                                         -- ,non_labor_resource              
                                          --,non_labor_resource_id           
                                          --,non_labor_resource_org          
                                          --,non_labor_resource_org_id       
                                          ,quantity                        
                                          ,unit_of_measure_name            
                                          ,unit_of_measure                 
                                          ,work_type                       
                                          ,work_type_id                    
                                          ,billable_flag                   
                                          ,capitalizable_flag              
                                          ,accrual_flag                    
                                         -- ,supplier_number                 
                                          --,supplier_name                   
                                          --,vendor_id                       
                                          --,inventory_item_name             
                                         -- ,inventory_item_id               
                                          ,orig_transaction_reference      
                                          ,unmatched_negative_txn_flag     
                                          ,reversed_orig_txn_reference     
                                          ,expenditure_comment             
                                          ,gl_date                         
                                          ,denom_currency_code             
                                          ,denom_currency                  
                                          ,denom_raw_cost                  
                                          ,denom_burdened_cost             
                                          ,raw_cost_cr_ccid                
                                          ,raw_cost_cr_account             
                                          ,raw_cost_dr_ccid                
                                          ,raw_cost_dr_account             
                                          ,burdened_cost_cr_ccid           
                                          ,burdened_cost_cr_account        
                                          ,burdened_cost_dr_ccid           
                                          ,burdened_cost_dr_account        
                                          ,burden_cost_cr_ccid             
                                          ,burden_cost_cr_account          
                                          ,burden_cost_dr_ccid             
                                          ,burden_cost_dr_account          
                                          ,acct_currency_code              
                                          ,acct_currency                   
                                          ,acct_raw_cost                   
                                          ,acct_burdened_cost              
                                          ,acct_rate_type                  
                                          ,acct_rate_date                  
                                          ,acct_rate_date_type             
                                          ,acct_exchange_rate              
                                          ,acct_exchange_rounding_limit    
                                          --,receipt_currency_code           
                                          --,receipt_currency                
                                          --,receipt_currency_amount         
                                         -- ,receipt_exchange_rate           
                                          ,converted_flag                  
                                          ,context_category                
                                          ,user_def_attribute1             
                                          ,user_def_attribute2             
                                          ,user_def_attribute3             
                                          ,user_def_attribute4             
                                          ,user_def_attribute5             
                                          ,user_def_attribute6             
                                          ,user_def_attribute7             
                                          ,user_def_attribute8             
                                          ,user_def_attribute9             
                                          ,user_def_attribute10            
                                          ,reserved_attribute1             
                                          ,reserved_attribute2             
                                          ,reserved_attribute3             
                                          ,reserved_attribute4             
                                          ,reserved_attribute5             
                                          ,reserved_attribute6             
                                          ,reserved_attribute7             
                                          ,reserved_attribute8             
                                          ,reserved_attribute9             
                                          ,reserved_attribute10            
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
                                          ,contract_number                 
                                          ,contract_name                   
                                          ,contract_id                     
                                          ,funding_source_number           
                                          ,funding_source_name             
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
                                  ,pa_costs_dtl_tb(i).transaction_type                
                                  ,pa_costs_dtl_tb(i).business_unit                   
                                  ,pa_costs_dtl_tb(i).org_id                          
                                  ,pa_costs_dtl_tb(i).user_transaction_source         
                                  ,pa_costs_dtl_tb(i).transaction_source_id           
                                  ,pa_costs_dtl_tb(i).document_name                   
                                  ,pa_costs_dtl_tb(i).document_id                     
                                  ,pa_costs_dtl_tb(i).doc_entry_name                  
                                  ,pa_costs_dtl_tb(i).doc_entry_id                    
                                  ,pa_costs_dtl_tb(i).batch_ending_date               
                                  ,pa_costs_dtl_tb(i).batch_description               
                                  ,pa_costs_dtl_tb(i).expenditure_item_date           
                                  --,pa_costs_dtl_tb(i).person_number                   
                                  --,pa_costs_dtl_tb(i).person_name                     
                                  --,pa_costs_dtl_tb(i).person_id                       
                                  --,pa_costs_dtl_tb(i).hcm_assignment_name             
                                  --,pa_costs_dtl_tb(i).hcm_assignment_id               
                                  ,pa_costs_dtl_tb(i).project_number                  
                                  ,pa_costs_dtl_tb(i).project_name                    
                                  ,pa_costs_dtl_tb(i).project_id                      
                                  ,pa_costs_dtl_tb(i).task_number                     
                                  ,pa_costs_dtl_tb(i).task_name                       
                                  ,pa_costs_dtl_tb(i).task_id                         
                                  ,pa_costs_dtl_tb(i).expenditure_type                
                                  ,pa_costs_dtl_tb(i).expenditure_type_id             
                                  ,pa_costs_dtl_tb(i).organization_name               
                                  ,pa_costs_dtl_tb(i).organization_id                 
                                  --,pa_costs_dtl_tb(i).non_labor_resource              
                                  --,pa_costs_dtl_tb(i).non_labor_resource_id           
                                  --,pa_costs_dtl_tb(i).non_labor_resource_org          
                                  --,pa_costs_dtl_tb(i).non_labor_resource_org_id       
                                  ,pa_costs_dtl_tb(i).quantity                        
                                  ,pa_costs_dtl_tb(i).unit_of_measure_name            
                                  ,pa_costs_dtl_tb(i).unit_of_measure                 
                                  ,pa_costs_dtl_tb(i).work_type                       
                                  ,pa_costs_dtl_tb(i).work_type_id                    
                                  ,pa_costs_dtl_tb(i).billable_flag                   
                                  ,pa_costs_dtl_tb(i).capitalizable_flag              
                                  ,pa_costs_dtl_tb(i).accrual_flag                    
                                  --,pa_costs_dtl_tb(i).supplier_number                 
                                  --,pa_costs_dtl_tb(i).supplier_name                   
                                  --,pa_costs_dtl_tb(i).vendor_id                       
                                  --,pa_costs_dtl_tb(i).inventory_item_name             
                                  --,pa_costs_dtl_tb(i).inventory_item_id               
                                  ,pa_costs_dtl_tb(i).orig_transaction_reference      
                                  ,pa_costs_dtl_tb(i).unmatched_negative_txn_flag     
                                  ,pa_costs_dtl_tb(i).reversed_orig_txn_reference     
                                  ,pa_costs_dtl_tb(i).expenditure_comment             
                                  ,pa_costs_dtl_tb(i).gl_date                         
                                  ,pa_costs_dtl_tb(i).denom_currency_code             
                                  ,pa_costs_dtl_tb(i).denom_currency                  
                                  ,pa_costs_dtl_tb(i).denom_raw_cost                  
                                  ,pa_costs_dtl_tb(i).denom_burdened_cost             
                                  ,pa_costs_dtl_tb(i).raw_cost_cr_ccid                
                                  ,pa_costs_dtl_tb(i).raw_cost_cr_account             
                                  ,pa_costs_dtl_tb(i).raw_cost_dr_ccid                
                                  ,pa_costs_dtl_tb(i).raw_cost_dr_account             
                                  ,pa_costs_dtl_tb(i).burdened_cost_cr_ccid           
                                  ,pa_costs_dtl_tb(i).burdened_cost_cr_account        
                                  ,pa_costs_dtl_tb(i).burdened_cost_dr_ccid           
                                  ,pa_costs_dtl_tb(i).burdened_cost_dr_account        
                                  ,pa_costs_dtl_tb(i).burden_cost_cr_ccid             
                                  ,pa_costs_dtl_tb(i).burden_cost_cr_account           
                                  ,pa_costs_dtl_tb(i).burden_cost_dr_ccid             
                                  ,pa_costs_dtl_tb(i).burden_cost_dr_account          
                                  ,pa_costs_dtl_tb(i).acct_currency_code              
                                  ,pa_costs_dtl_tb(i).acct_currency                   
                                  ,pa_costs_dtl_tb(i).acct_raw_cost                   
                                  ,pa_costs_dtl_tb(i).acct_burdened_cost              
                                  ,pa_costs_dtl_tb(i).acct_rate_type                  
                                  ,pa_costs_dtl_tb(i).acct_rate_date                  
                                  ,pa_costs_dtl_tb(i).acct_rate_date_type             
                                  ,pa_costs_dtl_tb(i).acct_exchange_rate              
                                  ,pa_costs_dtl_tb(i).acct_exchange_rounding_limit    
                                  --,pa_costs_dtl_tb(i).receipt_currency_code           
                                  --,pa_costs_dtl_tb(i).receipt_currency                
                                  --,pa_costs_dtl_tb(i).receipt_currency_amount         
                                  --,pa_costs_dtl_tb(i).receipt_exchange_rate           
                                  ,pa_costs_dtl_tb(i).converted_flag                  
                                  ,pa_costs_dtl_tb(i).context_category                
                                  ,pa_costs_dtl_tb(i).user_def_attribute1             
                                  ,pa_costs_dtl_tb(i).user_def_attribute2             
                                  ,pa_costs_dtl_tb(i).user_def_attribute3             
                                  ,pa_costs_dtl_tb(i).user_def_attribute4             
                                  ,pa_costs_dtl_tb(i).user_def_attribute5             
                                  ,pa_costs_dtl_tb(i).user_def_attribute6             
                                  ,pa_costs_dtl_tb(i).user_def_attribute7             
                                  ,pa_costs_dtl_tb(i).user_def_attribute8             
                                  ,pa_costs_dtl_tb(i).user_def_attribute9             
                                  ,pa_costs_dtl_tb(i).user_def_attribute10            
                                  ,pa_costs_dtl_tb(i).reserved_attribute1             
                                  ,pa_costs_dtl_tb(i).reserved_attribute2             
                                  ,pa_costs_dtl_tb(i).reserved_attribute3             
                                  ,pa_costs_dtl_tb(i).reserved_attribute4             
                                  ,pa_costs_dtl_tb(i).reserved_attribute5             
                                  ,pa_costs_dtl_tb(i).reserved_attribute6             
                                  ,pa_costs_dtl_tb(i).reserved_attribute7             
                                  ,pa_costs_dtl_tb(i).reserved_attribute8             
                                  ,pa_costs_dtl_tb(i).reserved_attribute9             
                                  ,pa_costs_dtl_tb(i).reserved_attribute10            
                                  ,pa_costs_dtl_tb(i).attribute_category              
                                  ,pa_costs_dtl_tb(i).attribute1                      
                                  ,pa_costs_dtl_tb(i).attribute2                      
                                  ,pa_costs_dtl_tb(i).attribute3                      
                                  ,pa_costs_dtl_tb(i).attribute4                      
                                  ,pa_costs_dtl_tb(i).attribute5                      
                                  ,pa_costs_dtl_tb(i).attribute6                      
                                  ,pa_costs_dtl_tb(i).attribute7                      
                                  ,pa_costs_dtl_tb(i).attribute8                      
                                  ,pa_costs_dtl_tb(i).attribute9                      
                                  ,pa_costs_dtl_tb(i).attribute10                     
                                  ,pa_costs_dtl_tb(i).contract_number                 
                                  ,pa_costs_dtl_tb(i).contract_name                   
                                  ,pa_costs_dtl_tb(i).contract_id                     
                                  ,pa_costs_dtl_tb(i).funding_source_number           
                                  ,pa_costs_dtl_tb(i).funding_source_name             
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
                                    ,pt_i_ModuleMessage       => 'Close the Cursor src_pa_cost_dtl'
                                    ,pt_i_OracleError         => gvt_ReturnMessage       );   
                   --


                   IF src_pa_cost_dtl%ISOPEN
                   THEN
                        --
                           CLOSE src_pa_cost_dtl;
                        --
                   END IF;

               ELSE 
                  --
                  gvv_ProgressIndicator := '0090';
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
                                    ,pt_i_ModuleMessage       => 'Parameter Cost_ext_type is mandatory - Summary or Detail Extract'
                                    ,pt_i_OracleError         => gvt_ReturnMessage       );   
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
        IF pa_costs_cur%ISOPEN
        THEN
            --
            CLOSE pa_costs_cur;
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

         IF pa_costs_cur%ISOPEN
         THEN
             --
             CLOSE pa_costs_cur;
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



     END src_pa_sup_costs;

END XXMX_PPM_PRJ_BILLEVENT_PKG;
/
