CREATE OR REPLACE PACKAGE xxmx_hr_location_pkg 
AS
     --
     --
     /*
     *****************************************************************************
     **
     **                 Copyright (c) 2022 Version 1
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
     ** FILENAME  :  xxmx_hr_location_pkg.sql
     **
     ** FILEPATH  :  $XXMX_TOP/install/sql
     **
     ** VERSION   :  1.3
     **
     ** EXECUTE
     ** IN SCHEMA :  APPS
     **
     ** AUTHORS   :  Soundarya Kamatagi
     **
     ** PURPOSE   :  This script installs the package for the Maximise PO Receipts
     **              Data Migration.
     **
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
     **            $XXMX_TOP/install/sql/ xxmx_hcm_hr_location_xfm_dbi.sql
     **            $XXMX_TOP/install/sql/ xxmx_hcm_hr_location_stg_dbi.sql
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
     **   1.0  22-MAY-2023  Soundarya Kamatagi     Created for Maximise.
     **
     **   1.1  22-MAY-2023  Soundarya Kamatagi     Extract logic updates.
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
     **       pn_i_LocationID
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
     ******************************************************************************
     */
     --
     --
     /*

     **********************
     ** PROCEDURE: stg_main
     **********************
     */


    PROCEDURE stg_main 
        (
         pt_i_ClientCode                    IN          xxmx_client_config_parameters.client_code%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) ;


 --
 --
     /*
*/
     --
     --
     /*
     ********************************
     ** PROCEDURE: export_hr_location
     ********************************
     */
     --

    PROCEDURE export_hr_location_stg
    (p_bg_name                      IN      varchar2
    ,p_bg_id                        IN      number
    ,pt_i_MigrationSetID            IN      xxmx_migration_headers.migration_set_id%TYPE
    ,pt_i_MigrationSetName          IN      xxmx_migration_headers.migration_set_name%TYPE ) ;


	 --
     --
     /*
     *******************
     ** PROCEDURE: purge
     *******************
     */
     --

	/* PROCEDURE purge
                   (
                    pt_i_ClientCode                 IN      xxmx_client_config_parameters.client_code%TYPE
                   ,pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                   );*/
      --   


	  /*
     *******************
     ** PROCEDURE: set_parameters
     *******************
     */
     --
	  /*PROCEDURE set_parameters
	 (p_bg_name                      IN      varchar2
    ,p_bg_id                        IN      number
    ,pt_i_MigrationSetID            IN      xxmx_migration_headers.migration_set_id%TYPE
    ,pt_i_MigrationSetName          IN      xxmx_migration_headers.migration_set_name%TYPE ) ;*/

      --
END xxmx_hr_location_pkg;

/


CREATE OR REPLACE PACKAGE body xxmx_hr_location_pkg 
AS
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
    gcv_PackageName                           CONSTANT VARCHAR2(30)                                := 'xxmx_hr_location_pkg';
    gct_ApplicationSuite                      CONSTANT xxmx_module_messages.application_suite%TYPE := 'HCM';
    gct_Application                           CONSTANT xxmx_module_messages.application%TYPE       := 'HR';
    gv_i_BusinessEntity                       CONSTANT VARCHAR2(100) DEFAULT 'LOCATION';
    gvv_leg_code                                VARCHAR2(100);

    gvv_ReturnStatus                            VARCHAR2(1); 
    gvv_ProgressIndicator                       VARCHAR2(100); 
    gvn_RowCount                                NUMBER;
    gvt_ReturnMessage                           xxmx_module_messages .module_message%TYPE;
    gvt_Severity                                xxmx_module_messages .severity%TYPE;
    gvt_OracleError                             xxmx_module_messages .oracle_error%TYPE;
    gvt_ModuleMessage                           xxmx_module_messages .module_message%TYPE;
    e_ModuleError                               EXCEPTION;
	--E_MODULEERROR                             EXCEPTION;
    e_DateError                               EXCEPTION;

    TYPE wrk_lkp_map_rec IS RECORD (ebs_lookup_type     VARCHAR2(200)
                                    ,ebs_lookup_code     VARCHAR2(200)
                                    ,fusion_lookup_code  VARCHAR2(200));

    TYPE wrk_lkp_map_tab IS TABLE OF wrk_lkp_map_rec INDEX BY pls_integer;

    g_wrk_lkp_map wrk_lkp_map_tab;

    l_bu_id VARCHAR2(4000);
---------

/*PROCEDURE set_parameters (p_bg_id IN NUMBER)

	IS

	BEGIN 
		--Set Legislation_code- Harded for SMBC
		 gvv_leg_code:=get_legislation_code (p_bg_id );


        gvv_migration_date_from := xxmx_utilities_pkg.get_single_parameter_value(
                        pt_i_ApplicationSuite           =>     gct_ApplicationSuite
                        ,pt_i_Application                =>     gct_Application
                        ,pt_i_BusinessEntity             =>     'LOCATION'
                        ,pt_i_SubEntity                  =>     'LOCATION'
                        ,pt_i_ParameterCode              =>     'MIGRATE_DATE_FROM'
        );        
        gvd_migration_date_from := TO_DATE(gvv_migration_date_from,'YYYY-MM-DD');
         --


        gvv_migration_date_to := xxmx_utilities_pkg.get_single_parameter_value(
                        pt_i_ApplicationSuite           =>     gct_ApplicationSuite
                        ,pt_i_Application                =>     gct_Application
                        ,pt_i_BusinessEntity             =>     'LOCATION'
                        ,pt_i_SubEntity                  =>     'LOCATION'
                        ,pt_i_ParameterCode              =>     'MIGRATE_DATE_TO'
        );        
        gvd_migration_date_to := TO_DATE(gvv_migration_date_to,'YYYY-MM-DD');
         --         
END; 
*/
PROCEDURE stg_main (pt_i_ClientCode                 IN      xxmx_client_config_parameters.client_code%TYPE
                   ,pt_i_MigrationSetName           IN      xxmx_migration_headers.migration_set_name%TYPE ) 
IS 

        CURSOR METADATA_CUR
        IS
            SELECT	Entity_package_name,Stg_procedure_name, BUSINESS_ENTITY,SUB_ENTITY_SEQ,sub_entity
			FROM	xxmx_migration_metadata a 
			WHERE	application_suite = gct_ApplicationSuite
            AND		Application = gct_Application
			AND 	BUSINESS_ENTITY = gv_i_BusinessEntity
			AND 	a.enabled_flag = 'Y'
            Order by Business_entity_seq, Sub_entity_seq;

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'stg_main'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_HCM_HR_LOCATION_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'LOCATION';
        vt_MigrationSetID                               xxmx_migration_headers.migration_set_id%TYPE;
        lv_sql                                          VARCHAR2(32000);

	BEGIN 

-- setup
        --
        gvv_ReturnStatus  := '';
        gvv_ProgressIndicator := '0000';
        xxmx_utilities_pkg.clear_messages
            (
             pt_i_ApplicationSuite    => gct_ApplicationSuite
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
                        ,pt_i_migrationsetid      => vt_MigrationSetID
                        ,pt_i_Phase               => ct_Phase
                        ,pt_i_Severity            => 'NOTIFICATION'
                        ,pt_i_PackageName         => gcv_PackageName
                        ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                        ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                        ,pt_i_ModuleMessage       => 'Migration Set "'
                                    ||pt_i_MigrationSetName
                                    ||'" initialized (Generated Migration Set ID = '
                                    ||vt_MigrationSetID
                                    ||').  Processing extracts:'       
                        ,pt_i_OracleError         => NULL
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
            ,pt_i_migrationsetid      => vt_MigrationSetID
            ,pt_i_Phase               => ct_Phase
            ,pt_i_Severity            => 'NOTIFICATION'
            ,pt_i_PackageName         => gcv_PackageName
            ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
            ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
            ,pt_i_ModuleMessage       => 'Parameter for Irec Extract'
            ,pt_i_OracleError         => NULL
        );

      --


        gvv_ProgressIndicator := '0025';
        xxmx_utilities_pkg.log_module_message(  
             pt_i_ApplicationSuite    => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_migrationsetid      => vt_MigrationSetID
            ,pt_i_Phase               => ct_Phase
            ,pt_i_Severity            => 'NOTIFICATION'
            ,pt_i_PackageName         => gcv_PackageName
            ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
            ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
            ,pt_i_ModuleMessage       => 'Call to Irecruitment Extracts'
            ,pt_i_OracleError         => NULL
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
                        ,pt_i_migrationsetid      => vt_MigrationSetID
                        ,pt_i_Phase               => ct_Phase
                        ,pt_i_Severity            => 'NOTIFICATION'
                        ,pt_i_PackageName         => gcv_PackageName
                        ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                        ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                        ,pt_i_ModuleMessage       => lv_sql 
                        ,pt_i_OracleError         => NULL
                     );
                    DBMS_OUTPUT.PUT_LINE(lv_sql);

        END LOOP; 

		COMMIT;

    EXCEPTION
        WHEN e_ModuleError THEN
                --
        xxmx_utilities_pkg.log_module_message(  
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                    ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                    ,pt_i_migrationsetid      => vt_MigrationSetID
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
                    ,pt_i_migrationsetid      => vt_MigrationSetID
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
                    ,pt_i_migrationsetid      => vt_MigrationSetID
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



PROCEDURE export_hr_location_stg
    (p_bg_name                      IN      varchar2
    ,p_bg_id                        IN      number
    ,pt_i_MigrationSetID            IN      xxmx_migration_headers.migration_set_id%TYPE
    ,pt_i_MigrationSetName          IN      xxmx_migration_headers.migration_set_name%TYPE ) IS

    cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_hr_location'; 
    ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
    cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_HCM_HR_LOCATION_STG';
    cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'LOCATION';

	BEGIN
        --
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
        --
        --
        --set_parameters(p_bg_id);
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
        FROM    XXMX_HCM_HR_LOCATION_STG;
        --WHERE   bg_id    = p_bg_id    ; 

        COMMIT;   

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
                        ,pt_i_ModuleMessage       => 'Extracting data into "' || cv_StagingTable   || '".'   
                        ,pt_i_OracleError         => gvt_ReturnMessage       );

			INSERT  
				INTO    XXMX_HCM_HR_LOCATION_STG(
				        MIGRATION_SET_ID                           ,                            
                        MIGRATION_SET_NAME                          ,
                        MIGRATION_STATUS                            ,
                        BG_ID            			                ,
                        METADATA					                ,
                        OBJECTNAME					                ,
                        LOCATION_ID									,
                        SET_ID										,
                        SET_CODE									,
                        EFFECTIVE_START_DATE						,
                        LOCATION_IMAGE_URL							,
                        ACTIVE_STATUS								,
                        EMPLOYEE_LOCATION_FLAG						,
                        MAIN_PHONE_AREA_CODE					    ,
                        MAIN_PHONE_COUNTRY_CODE						,
                        MAIN_PHONE_EXTENSION						,
                        MAIN_PHONE_SUBSCRIBER_NUMBER  				,
                        FAX_AREA_CODE								,
                        FAX_COUNTRY_CODE							,
                        FAX_EXTENSION								,
                        FAX_SUBSCRIBER_NUMBER						,
                        OTHER_PHONE_AREA_CODE                       ,
                        OTHER_PHONE_COUNTRY_CODE					,
                        OTHER_PHONE_EXTENSION						,
                        OTHER_PHONE_SUBSCRIBER_NUMBER				,
                        OFFICIAL_LANGUAGE_CODE						,
                        EMAIL_ADDRESS								,
                        SHIP_TO_SITE_FLAG							,
                        SHIP_TO_LOCATION_SET_CODE					,
                        SHIP_TO_LOCATION_CODE						,
                        SHIP_TO_LOCATION_ID							,
                        RECEIVING_SITE_FLAG                         ,
                        BILL_TO_SITE_FLAG							,
                        OFFICE_SITE_FLAG               				,
                        DESIGNATED_RECEIVER_ID                      ,
                        DESIGNATED_PERSON_NUMBER                    ,
                        INVENTORY_ORGANIZATION_ID                   ,
                        INVENTORY_ORGANIZATION_NAME                 ,
                        GEO_HIERARCHY_NODE_ID                       ,
                        GEO_HIERARCHY_NODE_CODE                     ,
                        STANDARD_WORKING_HOURS						,
                        STANDARD_WORKING_FREQUENCY                  ,
                        STANDARD_ANNUAL_WORKING_DURATION			,
                        ANNUAL_WORKING_DURATION_UNITS               ,
                        LOCATION_CODE								,
                        LOCATION_NAME								,
                        DESCRIPTION									,
                        ADDRESS_LINE1								,
                        ADDRESS_LINE2                               ,
                        ADDRESS_LINE3                               ,
                        ADDRESS_LINE4                               ,
                        BUILDING									,
                        COUNTRY										,
                        FLOOR_NUMBER                                ,
                        LONG_POSTAL_CODE                            ,
                        POSTAL_CODE              					,
                        REGION1                                     ,
                        REGION2                                     ,
                        REGION3                                     ,
                        TIME_ZONE_NAME                              ,
                        TOWN_OR_CITY                                ,
                        ADDL_ADDRESS_ATTRIBUTE1                     ,
                        ADDL_ADDRESS_ATTRIBUTE2                     ,
                        ADDL_ADDRESS_ATTRIBUTE3                     ,
                        ADDL_ADDRESS_ATTRIBUTE4                     ,
                        ADDL_ADDRESS_ATTRIBUTE5                     ,
                        EFFECTIVE_END_DATE                          ,
                        ACTION_REASON_CODE							,
                        SOURCE_SYSTEM_OWNER                         ,
                        SOURCE_SYSTEM_ID                            ,
                        GUID										
					)

                SELECT  distinct      									                      
                pt_i_MigrationSetID                         				--MIGRATION_SET_ID                       
                ,pt_i_MigrationSetName                      				--MIGRATION_SET_NAME                     
                ,'EXTRACTED'                        				   --MIGRATION_STATUS                       
			    ,'' BG_ID            			            				--BG_ID            			            
                ,'' METADATA					                            --METADATA					            
                ,'' OBJECTNAME					            				--OBJECTNAME					            
                ,LOCATION_ID											--LOCATION_ID							
                ,'' SET_ID													--SET_ID									
                ,'' SET_CODE								                --SET_CODE								
                ,SYSDATE EFFECTIVE_START_DATE								    --EFFECTIVE_START_DATE					
                ,'' LOCATION_IMAGE_URL										--LOCATION_IMAGE_URL						
                ,'' ACTIVE_STATUS											--ACTIVE_STATUS							
                ,'' EMPLOYEE_LOCATION_FLAG					                --EMPLOYEE_LOCATION_FLAG					
                ,'' MAIN_PHONE_AREA_CODE					                --MAIN_PHONE_AREA_CODE					
                ,'' MAIN_PHONE_COUNTRY_CODE					            --MAIN_PHONE_COUNTRY_CODE				
                ,'' MAIN_PHONE_EXTENSION					                --MAIN_PHONE_EXTENSION					
                ,'' MAIN_PHONE_SUBSCRIBER_NUMBER  			                --MAIN_PHONE_SUBSCRIBER_NUMBER  			
                ,'' FAX_AREA_CODE											--FAX_AREA_CODE							
                ,'' FAX_COUNTRY_CODE						                --FAX_COUNTRY_CODE						
                ,'' FAX_EXTENSION							                --FAX_EXTENSION							
                ,'' FAX_SUBSCRIBER_NUMBER					                --FAX_SUBSCRIBER_NUMBER					
                ,'' OTHER_PHONE_AREA_CODE                                  --OTHER_PHONE_AREA_CODE                  
                ,'' OTHER_PHONE_COUNTRY_CODE				                --OTHER_PHONE_COUNTRY_CODE				
                ,'' OTHER_PHONE_EXTENSION					                --OTHER_PHONE_EXTENSION					
                ,'' OTHER_PHONE_SUBSCRIBER_NUMBER			                --OTHER_PHONE_SUBSCRIBER_NUMBER			
                ,'' OFFICIAL_LANGUAGE_CODE					                --OFFICIAL_LANGUAGE_CODE					
                ,'' EMAIL_ADDRESS							                --EMAIL_ADDRESS							
                ,SHIP_TO_SITE_FLAG						                --SHIP_TO_SITE_FLAG						
                ,'' SHIP_TO_LOCATION_SET_CODE				                --SHIP_TO_LOCATION_SET_CODE				
                ,'' SHIP_TO_LOCATION_CODE					                --SHIP_TO_LOCATION_CODE					
                ,SHIP_TO_LOCATION_ID						            --SHIP_TO_LOCATION_ID					
                ,RECEIVING_SITE_FLAG                                    --RECEIVING_SITE_FLAG                    
                ,BILL_TO_SITE_FLAG						                --BILL_TO_SITE_FLAG						
                ,OFFICE_SITE_FLAG               			            --OFFICE_SITE_FLAG               		
                ,DESIGNATED_RECEIVER_ID                                 --DESIGNATED_RECEIVER_ID                 
                ,'' DESIGNATED_PERSON_NUMBER                               --DESIGNATED_PERSON_NUMBER               
                ,INVENTORY_ORGANIZATION_ID                              --INVENTORY_ORGANIZATION_ID              
                ,'' INVENTORY_ORGANIZATION_NAME                            --INVENTORY_ORGANIZATION_NAME            
                ,'' GEO_HIERARCHY_NODE_ID                                  --GEO_HIERARCHY_NODE_ID                  
                ,'' GEO_HIERARCHY_NODE_CODE                                --GEO_HIERARCHY_NODE_CODE                
                ,'' STANDARD_WORKING_HOURS					                --STANDARD_WORKING_HOURS					
                ,'' STANDARD_WORKING_FREQUENCY                             --STANDARD_WORKING_FREQUENCY             
                ,'' STANDARD_ANNUAL_WORKING_DURATION					    --STANDARD_ANNUAL_WORKING_DURATION		
                ,'' ANNUAL_WORKING_DURATION_UNITS                          --ANNUAL_WORKING_DURATION_UNITS          
                ,LOCATION_CODE							                --LOCATION_CODE							
                ,'' LOCATION_NAME							                --LOCATION_NAME							
                ,DESCRIPTION								            --DESCRIPTION							
                ,ADDRESS_LINE_1							                --ADDRESS_LINE1							
                ,ADDRESS_LINE_2                                          --ADDRESS_LINE2                          
                ,ADDRESS_LINE_3                                          --ADDRESS_LINE3                          
                ,'' ADDRESS_LINE4                                          --ADDRESS_LINE4                          
                ,'' BUILDING								                --BUILDING								
                ,COUNTRY									            --COUNTRY								
                ,'' FLOOR_NUMBER                                           --FLOOR_NUMBER                           
                ,'' LONG_POSTAL_CODE                                       --LONG_POSTAL_CODE                       
                ,POSTAL_CODE              				                --POSTAL_CODE              				
                ,REGION_1                                                --REGION1                                
                ,REGION_2                                                --REGION2                                
                ,REGION_3                                                --REGION3                                
                ,''TIME_ZONE_NAME                                         --TIME_ZONE_NAME                         
                ,TOWN_OR_CITY                                           --TOWN_OR_CITY                           
                ,'' ADDL_ADDRESS_ATTRIBUTE1                                --ADDL_ADDRESS_ATTRIBUTE1                
                ,'' ADDL_ADDRESS_ATTRIBUTE2                                --ADDL_ADDRESS_ATTRIBUTE2                
                ,'' ADDL_ADDRESS_ATTRIBUTE3                                --ADDL_ADDRESS_ATTRIBUTE3                
                ,'' ADDL_ADDRESS_ATTRIBUTE4                                --ADDL_ADDRESS_ATTRIBUTE4                
                ,'' ADDL_ADDRESS_ATTRIBUTE5                                --ADDL_ADDRESS_ATTRIBUTE5                
                ,'' EFFECTIVE_END_DATE                                     --EFFECTIVE_END_DATE                     
                ,'' ACTION_REASON_CODE						                --ACTION_REASON_CODE						
                ,'' SOURCE_SYSTEM_OWNER                                    --SOURCE_SYSTEM_OWNER                    
                ,'' SOURCE_SYSTEM_ID                                       --SOURCE_SYSTEM_ID                       
                ,'' GUID									                --GUID									
               FROM 
			     HR_LOCATIONS_ALL@mxdm_nvis_extract
			            WHERE  1 = 1 ;


	COMMIT;

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

         --** END e_ModuleError Exception;

  EXCEPTION
     WHEN OTHERS 
     THEN
     --
            --ROLLBACK;
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
            RAISE ; 
         --Hr_Utility.raise_error@MXDM_NVIS_EXTRACT;

    END export_hr_location_stg;		
END xxmx_hr_location_pkg;


/
