CREATE OR REPLACE PACKAGE BODY    xxmx_kit_person_stg AS

--******************************************************************************
--
--**
--**                 Copyright (c) 2022 Version 1
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
--** FILENAME  :  xxmx_kit_person_stg.sql
--**
--** FILEPATH  :  $XXV1_TOP/install/sql
--**
--** VERSION   :  1.4
--**
--** EXECUTE
--** IN SCHEMA :  XXMX_CORE
--**
--** AUTHORS   :  Ian S. Vickerstaff, Robert Murphy
--**
--** PURPOSE   :  This package contains procedures for populating HCM Staging table
--**               Employee from EBS
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
--** 1.0    29/07/2021   Ian S. Vickerstaff  Initial Build
--**                     , Robert Murphy                        
--** 1.1	01-NOV-20    Robert Murphy		 Oracle Collabroation Coexistence (Coex) extended to work a parameterized, multi business group, extraction accelerator.            
--** 1.2    11-NOV-20    Pallavi		     Add Extracts for PaymentMethod, Salary , Work Measure, GradeStep
--** 1.3    11-DEC-20    Pallavi		     Changed Assignment Related Extract
--** 1.4    19-JAN-21    Pallavi		     PersonType as a new parameter
--**
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


   g_entity_name CONSTANT VARCHAR2(100) DEFAULT 'PERSON';


    gvv_memb_cnt_typ            VARCHAR2(1000) DEFAULT   xxmx_KIT_UTIL_stg.get_memb_cnt_typ;
    gvv_ed_lvl_cnt_typ          VARCHAR2(1000) DEFAULT   xxmx_KIT_UTIL_stg.get_edulvl_cnt_typ;
    gvv_deg_cnt_typ             VARCHAR2(1000) DEFAULT   xxmx_KIT_UTIL_stg.get_deg_cnt_typ;
    gvv_hon_cnt_typ             VARCHAR2(1000) DEFAULT   xxmx_KIT_UTIL_stg.get_hon_cnt_typ;
    gvv_cert_cnt_typ            VARCHAR2(1000) DEFAULT   xxmx_KIT_UTIL_stg.get_cert_cnt_typ;
    gvv_perf_rat_cnt_typ        VARCHAR2(1000) DEFAULT   xxmx_KIT_UTIL_stg.get_perf_rat_cnt_typ;
    gvv_per_prof_typ            VARCHAR2(1000) DEFAULT   xxmx_KIT_UTIL_stg.get_per_prof_typ;
    gvv_cmp_cnt_typ             VARCHAR2(1000) DEFAULT   xxmx_KIT_UTIL_stg.get_cmp_cnt_typ;
    gvv_qualifier               VARCHAR2(1000) DEFAULT   xxmx_KIT_UTIL_stg.get_qualifier;
    gvv_leg_code                VARCHAR2(100);-- DEFAULT   xxmx_KIT_UTIL_stg.get_legislation_code;
    gvv_comp_qualifier          VARCHAR2(100)  DEFAULT   xxmx_KIT_UTIL_stg.get_comp_qualifier;


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
    gcv_PackageName                           CONSTANT  VARCHAR2(30)                                 := 'xxmx_kit_person_stg';
    gct_ApplicationSuite                      CONSTANT  xxmx_module_messages.application_suite%TYPE := 'HCM';
    gct_Application                           CONSTANT  xxmx_module_messages.application%TYPE       := 'HR';
    gv_i_BusinessEntity                       CONSTANT  VARCHAR2(100)                                := 'PERSON';
    ct_Phase                                  CONSTANT  xxmx_module_messages.phase%TYPE             := 'EXTRACT';
    cv_i_BusinessEntityLevel                  CONSTANT  VARCHAR2(100)                                := 'ALL';
    gv_hr_date					              DATE                                                        := '31-DEC-4712';

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

    TYPE per_lkp_map_rec IS RECORD (ebs_lookup_type     VARCHAR2(200)
                                   ,ebs_lookup_code    VARCHAR2(200)
                                   ,fusion_lookup_code VARCHAR2(200));

    TYPE per_lkp_map_tab IS TABLE OF per_lkp_map_rec INDEX BY pls_integer;

    g_per_lkp_map per_lkp_map_tab;

    TYPE perf_rat_lvl_map_rec IS RECORD (ebs_lookup_type  VARCHAR2(200)
                                        ,ebs_lookup_code  VARCHAR2(200)
                                        ,guid             VARCHAR2(200));

    TYPE perf_rat_lvl_map_tab IS TABLE OF perf_rat_lvl_map_rec INDEX BY pls_integer;

    g_perf_rat_lvl_map perf_rat_lvl_map_tab;

    e_DateError                         EXCEPTION;
    /**********************************************************
    **** XFM Complex Transform Grade Ladder and Expense Account - for SMBC only
    **********************************************************/
   /* PROCEDURE GradeLadderTransform_xfm(pt_i_MigrationSetID            IN      xxmx_migration_headers.migration_set_id%TYPE)
    IS


      /******************************
      ** Cursor Declartion
      ******************************/
     /* Cursor gl_segments_cur
      IS 
         SELECT DISTINCT 
               ASG.default_code_comb_id,
               GCC.concatenated_segments,
               GL.NAME,
               GCC.segment1,
               GCC.segment2,
               GCC.segment3,
               GCC.segment4,
               GCC.segment5,
               GCC.segment6,
               GCC.segment7,
               GCC.segment8,
               GCC.segment9,
               GCC.segment10,
               GCC.segment11,
               GCC.segment12,
               GCC.segment13,
               GCC.segment14,
               GCC.segment15,
               GCC.segment16,
               GCC.segment17,
               GCC.segment18,
               GCC.segment19,
               GCC.segment20,
               GCC.segment21,
               GCC.segment22,
               GCC.segment23,
               GCC.segment24,
               GCC.segment25,
               GCC.segment26,
               GCC.segment27,
               GCC.segment28,
               GCC.segment29,
               GCC.segment30    
         FROM xxmx_per_assignments_m_stg ASG, 
            gl_code_combinations_kfv@MXDM_NVIS_EXTRACT GCC,
            gl_sets_of_books@MXDM_NVIS_EXTRACT GL
         WHERE GCC.chart_of_accounts_id = GL.chart_of_accounts_id
         AND ASG.default_code_comb_id = GCC.code_combination_id
         AND ASG.default_code_comb_id IS NOT NULL;

        CURSOR cur_Assign
        IS 
        SELECT DISTINCT GRADE_CODE 
        FROM XXMX_per_assignments_m_XFM
        WHERE  Grade_code is not null;

        CURSOR cur_Assign_nostep
        IS 
        SELECT DISTINCT Assignment_number,grade_code
        FROM XXMX_per_assignments_m_XFM asg
        WHERE  Grade_code is not null
        AND grade_ladder_pgm_name is null
        AND NOT EXISTS (SELECT 1
                            FROM xxmx_asg_gradestep_stg stp
                            WHERE stp.assignment_number = asg.assignment_number);


        /*
         ********************
         ** Type Declarations
         ********************
         */
       /*  TYPE gl_segments_tt IS TABLE OF gl_segments_cur%ROWTYPE INDEX BY BINARY_INTEGER;
         TYPE t_assign_tab IS TABLE OF cur_Assign%ROWTYPE INDEX BY BINARY_INTEGER;
         TYPE t_assign_nostp IS TABLE OF cur_Assign_nostep%ROWTYPE INDEX BY BINARY_INTEGER;

        /*
         ****************************
         ** PL/SQL Table Declarations
         ****************************
         */
        /*gl_segments_tbl                    gl_segments_tt;        
        p_assign_nostp t_assign_nostp;
        p_assign_tab t_assign_tab;

        /**********************************
          ** Variables
         **********************************/
      /*vt_NewSegment1                  xxmx_ar_trx_dists_xfm.segment1%TYPE;
      gvt_ReturnMessage               VARCHAR2(2000);
      vt_NewSegment2                  xxmx_ar_trx_dists_xfm.segment2%TYPE;
      vt_NewSegment3                  xxmx_ar_trx_dists_xfm.segment3%TYPE;
      vt_NewSegment4                  xxmx_ar_trx_dists_xfm.segment4%TYPE;
      vt_NewSegment5                  xxmx_ar_trx_dists_xfm.segment5%TYPE;
      vt_NewSegment6                  xxmx_ar_trx_dists_xfm.segment6%TYPE;
      vt_NewSegment7                  xxmx_ar_trx_dists_xfm.segment7%TYPE;
      vt_NewSegment8                  xxmx_ar_trx_dists_xfm.segment8%TYPE;
      vt_NewSegment9                  xxmx_ar_trx_dists_xfm.segment9%TYPE;
      vt_NewSegment10                 xxmx_ar_trx_dists_xfm.segment10%TYPE;
      vt_NewSegment11                 xxmx_ar_trx_dists_xfm.segment11%TYPE;
      vt_NewSegment12                 xxmx_ar_trx_dists_xfm.segment12%TYPE;
      vt_NewSegment13                 xxmx_ar_trx_dists_xfm.segment13%TYPE;
      vt_NewSegment14                 xxmx_ar_trx_dists_xfm.segment14%TYPE;
      vt_NewSegment15                 xxmx_ar_trx_dists_xfm.segment15%TYPE;
      vt_NewSegment16                 xxmx_ar_trx_dists_xfm.segment16%TYPE;
      vt_NewSegment17                 xxmx_ar_trx_dists_xfm.segment17%TYPE;
      vt_NewSegment18                 xxmx_ar_trx_dists_xfm.segment18%TYPE;
      vt_NewSegment19                 xxmx_ar_trx_dists_xfm.segment19%TYPE;
      vt_NewSegment20                 xxmx_ar_trx_dists_xfm.segment20%TYPE;
      vt_NewSegment21                 xxmx_ar_trx_dists_xfm.segment21%TYPE;
      vt_NewSegment22                 xxmx_ar_trx_dists_xfm.segment22%TYPE;
      vt_NewSegment23                 xxmx_ar_trx_dists_xfm.segment23%TYPE;
      vt_NewSegment24                 xxmx_ar_trx_dists_xfm.segment24%TYPE;
      vt_NewSegment25                 xxmx_ar_trx_dists_xfm.segment25%TYPE;
      vt_NewSegment26                 xxmx_ar_trx_dists_xfm.segment26%TYPE;
      vt_NewSegment27                 xxmx_ar_trx_dists_xfm.segment27%TYPE;
      vt_NewSegment28                 xxmx_ar_trx_dists_xfm.segment28%TYPE;
      vt_NewSegment29                 xxmx_ar_trx_dists_xfm.segment29%TYPE;
      vt_NewSegment30                 xxmx_ar_trx_dists_xfm.segment30%TYPE;
      vt_FusionConcatenatedSegments   xxmx_gl_account_transforms.fusion_concatenated_segments%TYPE;
      vt_MigrationStatus              xxmx_per_assignments_m_xfm.migration_status%TYPE;

      cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'GRADELADDERTRANSFORM_XFM';   
      vt_ClientSchemaName                             xxmx_client_config_parameters.config_value%TYPE;
      vt_MigrationSetID                               xxmx_migration_headers.migration_set_id%TYPE;
      ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'TRANSFORM';
      cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'ALL';
     BEGIN

            gvv_ProgressIndicator := '0005';
            xxmx_utilities_pkg.log_module_message(  
                        pt_i_ApplicationSuite     => gct_ApplicationSuite
                        ,pt_i_Application         => gct_Application
                        ,pt_i_BusinessEntity      => 'WORKER'
                        ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                        ,pt_i_Phase               => ct_Phase
                        ,pt_i_Severity            => 'NOTIFICATION'
                        ,pt_i_PackageName         => gcv_PackageName
                        ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                        ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                        ,pt_i_ModuleMessage       => '- Calling Grade Ladder Program Transformation'
                        ,pt_i_OracleError         => NULL   );
            OPEN cur_ASSIGN;
            FETCH cur_ASSIGN BULK COLLECT INTO p_assign_tab;
            CLOSE CUR_ASSIGN;

            FOR i IN 1..p_assign_tab.count
            LOOP

               DBMS_OUTPUT.PUT_LINE(p_assign_tab(i).grade_Code);


               UPDATE XXMX_per_assignments_m_XFM asg_xfm
                SET grade_ladder_pgm_name = (SELECT  map.gradeladdername 
                                       FROM xxmx_asg_gradestep_STG step
                                           ,XXMX_PER_GRADE_LADDER_MAP map
                                       WHERE  map.GRADENAME= asg_xfm.grade_code
                                       AND  map.GRADENAME = p_assign_tab(i).grade_Code
                                       AND  step.assignment_number = asg_xfm.assignment_number
                                       AND map.GRADESTEPNMAE= step.newgradestep
                                       )
               WHERE asg_xfm.GRADE_CODE =p_assign_tab(i).grade_Code
               AND migration_set_id = pt_i_MigrationSetID
               AND GRADE_CODE IS NOT NULL;   


            END LOOP;
         --   COMMIT;
            gvv_ProgressIndicator := '0010';
            xxmx_utilities_pkg.log_module_message(  
                        pt_i_ApplicationSuite    => gct_ApplicationSuite
                        ,pt_i_Application         => gct_Application
                        ,pt_i_BusinessEntity      => 'WORKER'
                        ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                        ,pt_i_Phase               => ct_Phase
                        ,pt_i_Severity            => 'NOTIFICATION'
                        ,pt_i_PackageName         => gcv_PackageName
                        ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                        ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                        ,pt_i_ModuleMessage       => '- Calling Grade Ladder Program Transformation'
                        ,pt_i_OracleError         => NULL   );

           --Assignment with not GradeStep
            OPEN cur_Assign_nostep;
            FETCH cur_Assign_nostep BULK COLLECT INTO p_assign_nostp;
            CLOSE cur_Assign_nostep;
            FOR i IN 1..p_assign_nostp.count
            LOOP

                  DBMS_OUTPUT.PUT_LINE(p_assign_nostp(i).grade_Code);


                  UPDATE XXMX_per_assignments_m_XFM asg_xfm
                   SET grade_ladder_pgm_name = (SELECT  distinct map.gradeladdername 
                                          FROM XXMX_PER_GRADE_LADDER_MAP map
                                          WHERE  map.GRADENAME= asg_xfm.grade_code
                                          AND  map.GRADENAME = p_assign_nostp(i).grade_Code
                                          )
                  WHERE asg_xfm.GRADE_CODE =p_assign_nostp(i).grade_Code
                  AND asg_xfm.assignment_number = p_assign_nostp(i).assignment_number
                  AND migration_set_id = pt_i_MigrationSetID
                  AND GRADE_CODE IS NOT NULL;   


            END LOOP;

            --
            -- Transform GL Accounts;
            --
            OPEN gl_segments_cur;
            FETCH gl_segments_cur BULK COLLECT INTO gl_segments_tbl;
            CLOSE gl_segments_cur;
            --
            --
            gvv_ProgressIndicator := '0015';
            xxmx_utilities_pkg.log_module_message(  
                        pt_i_ApplicationSuite    => gct_ApplicationSuite
                        ,pt_i_Application         => gct_Application
                        ,pt_i_BusinessEntity      => 'WORKER'
                        ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                        ,pt_i_Phase               => ct_Phase
                        ,pt_i_Severity            => 'NOTIFICATION'
                        ,pt_i_PackageName         => gcv_PackageName
                        ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                        ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                        ,pt_i_ModuleMessage       => '- Calling Code Comb Transformation'
                        ,pt_i_OracleError         => NULL   );
            FOR  i 
            IN   1..gl_segments_tbl.COUNT
            LOOP
               --
               --
               vt_NewSegment1  := NULL;
               vt_NewSegment2  := NULL;
               vt_NewSegment3  := NULL;
               vt_NewSegment4  := NULL;
               vt_NewSegment5  := NULL;
               vt_NewSegment6  := NULL;
               vt_NewSegment7  := NULL;
               vt_NewSegment8  := NULL;
               vt_NewSegment9  := NULL;
               vt_NewSegment10 := NULL;
               vt_NewSegment11 := NULL;
               vt_NewSegment12 := NULL;
               vt_NewSegment13 := NULL;
               vt_NewSegment14 := NULL;
               vt_NewSegment15 := NULL;
               vt_NewSegment16 := NULL;
               vt_NewSegment17 := NULL;
               vt_NewSegment18 := NULL;
               vt_NewSegment19 := NULL;
               vt_NewSegment20 := NULL;
               vt_NewSegment21 := NULL;
               vt_NewSegment22 := NULL;
               vt_NewSegment23 := NULL;
               vt_NewSegment24 := NULL;
               vt_NewSegment25 := NULL;
               vt_NewSegment26 := NULL;
               vt_NewSegment27 := NULL;
               vt_NewSegment28 := NULL;
               vt_NewSegment29 := NULL;
               vt_NewSegment30 := NULL;
               vt_FusionConcatenatedSegments := NULL;
               --
               gvv_ReturnStatus := NULL;
               gvt_ReturnMessage := NULL;
               --
               xxmx_gl_utilities_pkg.transform_gl_account
                  (
                   pt_i_ApplicationSuite     => 'FIN'
                  ,pt_i_Application          => 'GL'
                  ,pt_i_BusinessEntity       => 'ALL'
                  ,pt_i_SubEntity            => 'ALL'
                  ,pt_i_SourceLedgerName     => gl_segments_tbl(i).name
                  ,pt_i_SourceSegment1       => gl_segments_tbl(i).segment1
                  ,pt_i_SourceSegment2       => gl_segments_tbl(i).segment2
                  ,pt_i_SourceSegment3       => gl_segments_tbl(i).segment3
                  ,pt_i_SourceSegment4       => gl_segments_tbl(i).segment4
                  ,pt_i_SourceSegment5       => gl_segments_tbl(i).segment5
                  ,pt_i_SourceSegment6       => gl_segments_tbl(i).segment6
                  ,pt_i_SourceSegment7       => gl_segments_tbl(i).segment7
                  ,pt_i_SourceSegment8       => gl_segments_tbl(i).segment8
                  ,pt_i_SourceSegment9       => gl_segments_tbl(i).segment9
                  ,pt_i_SourceSegment10      => gl_segments_tbl(i).segment10
                  ,pt_i_SourceSegment11      => gl_segments_tbl(i).segment11
                  ,pt_i_SourceSegment12      => gl_segments_tbl(i).segment12
                  ,pt_i_SourceSegment13      => gl_segments_tbl(i).segment13
                  ,pt_i_SourceSegment14      => gl_segments_tbl(i).segment14
                  ,pt_i_SourceSegment15      => gl_segments_tbl(i).segment15
                  ,pt_i_SourceSegment16      => gl_segments_tbl(i).segment16
                  ,pt_i_SourceSegment17      => gl_segments_tbl(i).segment17
                  ,pt_i_SourceSegment18      => gl_segments_tbl(i).segment18
                  ,pt_i_SourceSegment19      => gl_segments_tbl(i).segment19
                  ,pt_i_SourceSegment20      => gl_segments_tbl(i).segment20
                  ,pt_i_SourceSegment21      => gl_segments_tbl(i).segment21
                  ,pt_i_SourceSegment22      => gl_segments_tbl(i).segment22
                  ,pt_i_SourceSegment23      => gl_segments_tbl(i).segment23
                  ,pt_i_SourceSegment24      => gl_segments_tbl(i).segment24
                  ,pt_i_SourceSegment25      => gl_segments_tbl(i).segment25
                  ,pt_i_SourceSegment26      => gl_segments_tbl(i).segment26
                  ,pt_i_SourceSegment27      => gl_segments_tbl(i).segment27
                  ,pt_i_SourceSegment28      => gl_segments_tbl(i).segment28
                  ,pt_i_SourceSegment29      => gl_segments_tbl(i).segment29
                  ,pt_i_SourceSegment30      => gl_segments_tbl(i).segment30
                  ,pt_i_SourceConcatSegments => gl_segments_tbl(i).concatenated_segments
                  ,pt_o_FusionSegment1       => vt_NewSegment1
                  ,pt_o_FusionSegment2       => vt_NewSegment2
                  ,pt_o_FusionSegment3       => vt_NewSegment3
                  ,pt_o_FusionSegment4       => vt_NewSegment4
                  ,pt_o_FusionSegment5       => vt_NewSegment5
                  ,pt_o_FusionSegment6       => vt_NewSegment6
                  ,pt_o_FusionSegment7       => vt_NewSegment7
                  ,pt_o_FusionSegment8       => vt_NewSegment8
                  ,pt_o_FusionSegment9       => vt_NewSegment9
                  ,pt_o_FusionSegment10      => vt_NewSegment10
                  ,pt_o_FusionSegment11      => vt_NewSegment11
                  ,pt_o_FusionSegment12      => vt_NewSegment12
                  ,pt_o_FusionSegment13      => vt_NewSegment13
                  ,pt_o_FusionSegment14      => vt_NewSegment14
                  ,pt_o_FusionSegment15      => vt_NewSegment15
                  ,pt_o_FusionSegment16      => vt_NewSegment16
                  ,pt_o_FusionSegment17      => vt_NewSegment17
                  ,pt_o_FusionSegment18      => vt_NewSegment18
                  ,pt_o_FusionSegment19      => vt_NewSegment19
                  ,pt_o_FusionSegment20      => vt_NewSegment20
                  ,pt_o_FusionSegment21      => vt_NewSegment21
                  ,pt_o_FusionSegment22      => vt_NewSegment22
                  ,pt_o_FusionSegment23      => vt_NewSegment23
                  ,pt_o_FusionSegment24      => vt_NewSegment24
                  ,pt_o_FusionSegment25      => vt_NewSegment25
                  ,pt_o_FusionSegment26      => vt_NewSegment26
                  ,pt_o_FusionSegment27      => vt_NewSegment27
                  ,pt_o_FusionSegment28      => vt_NewSegment28
                  ,pt_o_FusionSegment29      => vt_NewSegment29
                  ,pt_o_FusionSegment30      => vt_NewSegment30
                  ,pt_o_FusionConcatSegments => vt_FusionConcatenatedSegments
                  ,pv_o_ReturnStatus         => gvv_ReturnStatus
                  ,pv_o_ReturnMessage        => gvt_ReturnMessage
                  );
                  --
                  IF   gvv_ReturnStatus = 'S'
                  THEN
                     --
                     vt_MigrationStatus := 'TRANSFORMED';
                     --
                  ELSE
                       --
                       vt_MigrationStatus := 'ACCT_TRANSFORM_ERROR';
                       --
                       gvt_Severity := 'ERROR';
                       --
                       gvv_ProgressIndicator := '0020';
                       xxmx_utilities_pkg.log_module_message
                                  (
                                   pt_i_ApplicationSuite  => gct_ApplicationSuite
                                  ,pt_i_Application       => gct_Application
                                  ,pt_i_BusinessEntity      => 'WORKER'
                                  ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                                  ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                                  ,pt_i_Phase             => ct_Phase
                                  ,pt_i_Severity          => gvt_Severity
                                  ,pt_i_PackageName       => gcv_PackageName
                                  ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                                  ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                  ,pt_i_ModuleMessage     => '  - Fusion GL Account Code Transformations complete.'
                                  ,pt_i_OracleError       => NULL
                                  );
                  END IF;
                  --
                  UPDATE xxmx_per_assignments_m_xfm
                  SET migration_status = vt_MigrationStatus
                     ,default_expense_account = vt_FusionConcatenatedSegments
                  WHERE default_code_comb_id = gl_segments_tbl(i).default_code_comb_id;
                  --
               END LOOP;
        END GradeLadderTransform_xfm;
        */


	/********************************************************
	****************Export DFF Segment Value*****************
	DESC: Updates Person_id to Number Identifer
	*********************************************************
	*********************************************************/

	FUNCTION EXPORT_DFF_SEGMENT_VAL 
								(p_identifier1 NUMBER DEFAULT NULL,
								 p_identifier2 VARCHAR2 DEFAULT NULL,
								 p_tblcol1 VARCHAR2 DEFAULT NULL,
								 p_tblcol2 VARCHAR2 DEFAULT NULL,
								 p_table VARCHAR2,
								 p_dffcol VARCHAR2,
								 p_condition VARCHAR2 DEFAULT NULL)
	RETURN VARCHAR2
	IS
	lv_ret VARCHAR2(240);
	lv_sql VARCHAR2(32000);
	lv_condition VARCHAR2(2000);
	BEGIN 
		IF(p_condition IS NULL) THEN 
			lv_condition := '1=1';
		ELSE 
			lv_condition := p_condition;
		END IF;

		IF( p_identifier2 IS NULL AND p_tblcol2 IS NULL ) THEN 
		lv_sql:= 'SELECT  DFF.'||p_dffcol||
				' FROM '||p_table||'@MXDM_NVIS_EXTRACT DFF '||
				' WHERE DFF.'||p_tblcol1||' = '|| p_identifier1 ||
				'AND '||lv_condition;
		ELSE 
		lv_sql:= 'SELECT  DFF.'||p_dffcol||
				' FROM '||p_table||'@MXDM_NVIS_EXTRACT DFF '||
				' WHERE DFF.'||p_tblcol1||' = '|| p_identifier1
				||' AND  DFF.'||p_tblcol2||' = '''|| p_identifier2 ||''''
				||'AND '||lv_condition;
		END IF;

		EXECUTE IMMEDIATE lv_sql INTO lv_ret;

		dbms_output.put_line(lv_sql);

		return lv_ret;
	END;


    FUNCTION get_legislation_code (p_bg_id NUMBER)
    RETURN VARCHAR2
    IS
    BEGIN 
         BEGIN
            SELECT  legislation_code 
			INTO gvv_leg_code                
            FROM    per_business_groups@MXDM_NVIS_EXTRACT
            where   business_group_id= p_bg_id ;

            RETURN gvv_leg_code;
        EXCEPTION
            WHEN no_data_found THEN 
				BEGIN
					SELECT   org_information9
					INTO gvv_leg_code
					FROM hr_organization_information@MXDM_NVIS_EXTRACT
					WHERE org_information_context LIKE 'Business Group Information'
					AND organization_id = p_bg_id;
                    RETURN gvv_leg_code;
				EXCEPTION	
					WHEN OTHERS THEN 
						gvv_leg_code := NULL;
                        RETURN gvv_leg_code;
				END;
        END;

    END;

   PROCEDURE set_parameters (p_bg_id IN NUMBER)

	IS

	BEGIN 
		/***********Set Legislation_code- Harded for SMBC*************/
		 gvv_leg_code:=get_legislation_code (p_bg_id );


        gvv_migration_date_from := xxmx_utilities_pkg.get_single_parameter_value(
                        pt_i_ApplicationSuite           =>     gct_ApplicationSuite
                        ,pt_i_Application                =>     gct_Application
                        ,pt_i_BusinessEntity             =>     'HCMEMPLOYEE'
                        ,pt_i_SubEntity                  =>     'ALL'
                        ,pt_i_ParameterCode              =>     'MIGRATE_DATE_FROM'
        );        
        gvd_migration_date_from := TO_DATE(gvv_migration_date_from,'YYYY-MM-DD');
         --


        gvv_migration_date_to := xxmx_utilities_pkg.get_single_parameter_value(
                        pt_i_ApplicationSuite           =>     gct_ApplicationSuite
                        ,pt_i_Application                =>     gct_Application
                        ,pt_i_BusinessEntity             =>     'HCMEMPLOYEE'
                        ,pt_i_SubEntity                  =>     'ALL'
                        ,pt_i_ParameterCode              =>     'MIGRATE_DATE_TO'
        );        
        gvd_migration_date_to := TO_DATE(gvv_migration_date_to,'YYYY-MM-DD');
         --         

	END;

	/************************************************
	****************Export Procedure*****************
	DESC: Exports All Person Information - Main Proc
	*************************************************
	*************************************************/

    PROCEDURE export
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          number
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export';   
        vt_ClientSchemaName                             xxmx_client_config_parameters.config_value%TYPE;
        vt_MigrationSetID                               xxmx_migration_headers.migration_set_id%TYPE;
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT '';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'PERSON EXPORT';

		l_leg_code VARCHAR2(1000);
        vt_BusinessEntitySeq                            xxmx_migration_metadata.business_entity_seq%TYPE;

		leg_error EXCEPTION;

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
        --1 
            gvv_ProgressIndicator := '0005';
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
                        ,pt_i_ModuleMessage       => '- Calling Procedure "' ||gcv_PackageName ||'.export_lookups".' 
                        ,pt_i_OracleError         => NULL   );
        -- 

	    gvv_ProgressIndicator := '0006';
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
                        ,pt_i_ModuleMessage       => '- Calling Procedure get_legislation_code for  "' ||p_bg_id 
                        ,pt_i_OracleError         => NULL   );

        --main
        --1 
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
                        ,pt_i_ModuleMessage       => '- Calling Procedure "' ||gcv_PackageName ||'.export_lookups".' 
                        ,pt_i_OracleError         => NULL   );
        -- 
		/****************************************************
		----------------Export HR Lookup--------------------
		*****************************************************/

        export_lookups;
        --2 
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
                    ,pt_i_ModuleMessage       => '- Calling Procedure ' ||gcv_PackageName ||'.export_persons' 
                    ,pt_i_OracleError         => NULL   );
        --
		/****************************************************
		----------------Export Person--------------------
		*****************************************************/
		--
        export_persons (p_bg_name, p_bg_id, pt_i_MigrationSetID, pt_i_MigrationSetName);
        --3
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
                    ,pt_i_ModuleMessage       => '- Calling Procedure ' ||gcv_PackageName ||'. export_contacts.' 
                    ,pt_i_OracleError         => NULL   );
        --
		/****************************************************
		----------------Export PersonContact-----------------
		*****************************************************/
		--

        export_contacts (p_bg_name, p_bg_id, pt_i_MigrationSetID, pt_i_MigrationSetName);
        --4
        gvv_ProgressIndicator := '0040';
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
                    ,pt_i_ModuleMessage       => '- Calling Procedure ' ||gcv_PackageName ||'.export_email_addresses' 
                    ,pt_i_OracleError         => NULL   );
        -- 
		/****************************************************
		----------------Export PersonEmail-------------------
		*****************************************************/
		--
        export_email_addresses (p_bg_name, p_bg_id, pt_i_MigrationSetID, pt_i_MigrationSetName);
        --5
        gvv_ProgressIndicator := '0050';
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
                    ,pt_i_ModuleMessage       => '- Calling Procedure ' ||gcv_PackageName ||'.export_national_identifiers' 
                    ,pt_i_OracleError         => NULL   );
        --
		/****************************************************	
		----------------Export PersonNID-------------------
		*****************************************************/	
		--
        export_national_identifiers (p_bg_name, p_bg_id, pt_i_MigrationSetID, pt_i_MigrationSetName);
        --6
        gvv_ProgressIndicator := '0060';
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
                    ,pt_i_ModuleMessage       => '- Calling Procedure ' ||gcv_PackageName ||'.export_phones' 
                    ,pt_i_OracleError         => NULL   );
        -- 
		--
		/****************************************************	
		----------------Export Phones-------------------
		*****************************************************/	
		--
		--
        export_phones (p_bg_name, p_bg_id, pt_i_MigrationSetID, pt_i_MigrationSetName);
        --7
        gvv_ProgressIndicator := '0070';
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
                    ,pt_i_ModuleMessage       => '- Calling Procedure ' ||gcv_PackageName ||'.export_per_names_global_us' 
                    ,pt_i_OracleError         => NULL   );
        -- 
		--
		/****************************************************	
		----------------Export GlobalNames-------------------
		*****************************************************/	
		--
		--
        export_per_names_global_us (p_bg_name, p_bg_id, pt_i_MigrationSetID, pt_i_MigrationSetName);
        --8
        gvv_ProgressIndicator := '0080';
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
                    ,pt_i_ModuleMessage       => '- Calling Procedure ' ||gcv_PackageName ||'.export_per_people_legis_f_us' 
                    ,pt_i_OracleError         => NULL   );
        -- 
		--
		/****************************************************************	
		----------------Export Person Leg Information-------------------
		*****************************************************************/	
		--
		--
        export_per_people_legis_f_us (p_bg_name, p_bg_id, pt_i_MigrationSetID, pt_i_MigrationSetName);
        --9
        gvv_ProgressIndicator := '0090';
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
                    ,pt_i_ModuleMessage       => '- Calling Procedure ' ||gcv_PackageName ||'.export_per_ethnicities_us' 
                    ,pt_i_OracleError         => NULL   );
        -- 
		--
		/****************************************************************	
		----------------Export Person Ethnicities-------------------
		*****************************************************************/	
		--
		--
        export_per_ethnicities_us (p_bg_name, p_bg_id, pt_i_MigrationSetID, pt_i_MigrationSetName);
        --10
        gvv_ProgressIndicator := '0130';
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
                    ,pt_i_ModuleMessage       => '- Calling Procedure "' ||gcv_PackageName ||'.export_per_addr_f_us".' 
                    ,pt_i_OracleError         => NULL   );

		-- 
		--
		/****************************************************************	
		----------------Export Person Address-------------------
		*****************************************************************/	
		--
		--
        export_per_addr_f_us (p_bg_name, p_bg_id, pt_i_MigrationSetID, pt_i_MigrationSetName);
        --11
        gvv_ProgressIndicator := '0140';
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
                    ,pt_i_ModuleMessage       => '- Calling Procedure "' ||gcv_PackageName ||'.export_per_addr_usages_f".' 
                    ,pt_i_OracleError         => NULL   );
        -- 
		-- 
		--
		/****************************************************************	
		----------------Export Person Address Usages-------------------
		*****************************************************************/	
		--
		--
        export_per_addr_usages_f (p_bg_name, p_bg_id, pt_i_MigrationSetID, pt_i_MigrationSetName);
        --12
        gvv_ProgressIndicator := '0150';
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
                    ,pt_i_ModuleMessage       => '- Calling Procedure "' ||gcv_PackageName ||'.export_per_all_people_f".' 
                    ,pt_i_OracleError         => NULL   );
        -- 
		-- 
		--
		/****************************************************************	
		----------------Export People Information------------------------
		*****************************************************************/	
		--
		--
        export_per_all_people_f (p_bg_name, p_bg_id, pt_i_MigrationSetID, pt_i_MigrationSetName);
        --13
        gvv_ProgressIndicator := '0160';
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
                    ,pt_i_ModuleMessage       => '- Calling Procedure "' ||gcv_PackageName ||'.export_per_citizenships".' 
                    ,pt_i_OracleError         => NULL   );
        --
		-- 
		--
		/****************************************************************	
		----------------Export Person Citizenship ------------------------
		*****************************************************************/	
		--
		--		
        export_per_citizenships (p_bg_name, p_bg_id, pt_i_MigrationSetID, pt_i_MigrationSetName);

        --
		gvv_ProgressIndicator := '0170';
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
                    ,pt_i_ModuleMessage       => '- Calling Procedure "' ||gcv_PackageName ||'.export_per_Passport".' 
                    ,pt_i_OracleError         => NULL   );

		-- 
		--
		/****************************************************************	
		----------------Export Person Passport ------------------------
		*****************************************************************/	
		--
		--	
		export_per_Passport(p_bg_name, p_bg_id, pt_i_MigrationSetID, pt_i_MigrationSetName);
		--
	    --
		gvv_ProgressIndicator := '0180';
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
                    ,pt_i_ModuleMessage       => '- Calling Procedure "' ||gcv_PackageName ||'.export_Cont_Addr".' 
                    ,pt_i_OracleError         => NULL   );

		-- 
		--
		/****************************************************************	
		----------------Export Person Contact Address-------------------
		*****************************************************************/	
		--
		export_Cont_Addr(p_bg_name, p_bg_id, pt_i_MigrationSetID, pt_i_MigrationSetName);
		--
    --
		gvv_ProgressIndicator := '0190';
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
                    ,pt_i_ModuleMessage       => '- Calling Procedure "' ||gcv_PackageName ||'.export_Cont_rel".' 
                    ,pt_i_OracleError         => NULL   );

		-- 
		--
		/****************************************************************	
		----------------Export Person Contact Address-------------------
		*****************************************************************/	
		--
		export_Cont_Rel(p_bg_name, p_bg_id, pt_i_MigrationSetID, pt_i_MigrationSetName);
		--			
		    --
		gvv_ProgressIndicator := '0200';
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
                    ,pt_i_ModuleMessage       => '- Calling Procedure "' ||gcv_PackageName ||'.export_Cont_Phone".' 
                    ,pt_i_OracleError         => NULL   );

		-- 
		--
		/****************************************************************	
		----------------Export Person Contact Phone-------------------
		*****************************************************************/	
		--
		export_Cont_Phone(p_bg_name, p_bg_id, pt_i_MigrationSetID, pt_i_MigrationSetName);
		--	
			--
		gvv_ProgressIndicator := '0210';
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
                    ,pt_i_ModuleMessage       => '- Calling Procedure "' ||gcv_PackageName ||'.export_religion".' 
                    ,pt_i_OracleError         => NULL   );

		-- 
		--
		/****************************************************************	
		----------------Export religion-------------------
		*****************************************************************/	
		--
		export_religion(p_bg_name, p_bg_id, pt_i_MigrationSetID, pt_i_MigrationSetName);
		--
		gvv_ProgressIndicator := '0220';
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
                    ,pt_i_ModuleMessage       => '- Calling Procedure "' ||gcv_PackageName ||'.export_disability".' 
                    ,pt_i_OracleError         => NULL   );

		-- 
		--
		/****************************************************************	
		----------------Export disability-------------------
		*****************************************************************/	
		--
		export_disability(p_bg_name, p_bg_id, pt_i_MigrationSetID, pt_i_MigrationSetName);

		--
		gvv_ProgressIndicator := '0230';
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
                    ,pt_i_ModuleMessage       => '- Calling Procedure "' ||gcv_PackageName ||'.export_absence_entry".' 
                    ,pt_i_OracleError         => NULL   );

		-- 
		--
		/****************************************************************	
		----------------Export absence-------------------
		*****************************************************************/	
		--
		export_absence_entry(p_bg_name, p_bg_id, pt_i_MigrationSetID, pt_i_MigrationSetName);

		--
		gvv_ProgressIndicator := '0240';
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
                    ,pt_i_ModuleMessage       => '- Calling Procedure "' ||gcv_PackageName ||'.export_images".' 
                    ,pt_i_OracleError         => NULL   );

		-- 
		--
		/****************************************************************	
		----------------Export Images-------------------
		*****************************************************************/	
		--
		export_Images(p_bg_name, p_bg_id, pt_i_MigrationSetID, pt_i_MigrationSetName);

    EXCEPTION
		WHEN Leg_error THEN 
		--
		ROLLBACK;
			gvt_OracleError := '** ERROR Legislation_code is blank: ';
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
						,pt_i_ModuleMessage       => 'Legislation Code is Blank'  
						,pt_i_OracleError         => gvt_OracleError       );     
        --

        WHEN OTHERS THEN
        --
        ROLLBACK;
        --
        gvt_OracleError := SUBSTR(
                                    SQLERRM ||'** ERROR_BACKTRACE: ' ||dbms_utility.format_error_backtrace
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
    END export;

	/****************************************************************	
	----------------Export Person Profiles ------------------------
	*****************************************************************/	
    PROCEDURE export_profiles_person
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          number
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_profiles_person';   
        vt_ClientSchemaName                             xxmx_client_config_parameters.config_value%TYPE;
        vt_MigrationSetID                               xxmx_migration_headers.migration_set_id%TYPE;
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT '';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'PERSON PROFILE EXPORT';

        vt_BusinessEntitySeq                            xxmx_migration_metadata.business_entity_seq%TYPE;

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
        --main
        --1 
        gvv_ProgressIndicator := '0050';
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
                        ,pt_i_ModuleMessage       => '- Calling Procedure "' ||gcv_PackageName ||'.export_person_profiles_b_1".' 
                        ,pt_i_OracleError         => NULL   );
        -- 
        export_person_profiles_b_1 (p_bg_name, p_bg_id, pt_i_MigrationSetID, pt_i_MigrationSetName);
        --2 
       /* gvv_ProgressIndicator := '0060';
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
                        ,pt_i_ModuleMessage       => '- Calling Procedure "' ||gcv_PackageName ||'.export_person_profiles_tl_1".' 
                        ,pt_i_OracleError         => NULL   );
        -- 
       -- export_person_profiles_tl_1 (p_bg_name, p_bg_id, pt_i_MigrationSetID, pt_i_MigrationSetName);*/
        --3 
        gvv_ProgressIndicator := '0070';
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
                        ,pt_i_ModuleMessage       => '- Calling Procedure "' ||gcv_PackageName ||'.export_profile_items_1".' 
                        ,pt_i_OracleError         => NULL   );
        -- 
        export_profile_items_1 (p_bg_name, p_bg_id, pt_i_MigrationSetID, pt_i_MigrationSetName);
        --4 
        gvv_ProgressIndicator := '0080';
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
                        ,pt_i_ModuleMessage       => '- Calling Procedure "' ||gcv_PackageName ||'.export_profile_items_qual_1".' 
                        ,pt_i_OracleError         => NULL   );
        -- 
        export_profile_items_qual_1 (p_bg_name, p_bg_id, pt_i_MigrationSetID, pt_i_MigrationSetName);
        --5
        gvv_ProgressIndicator := '0090';
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
                        ,pt_i_ModuleMessage       => '- Calling Procedure "' ||gcv_PackageName ||'.export_profile_items_qual_2".' 
                        ,pt_i_OracleError         => NULL   );
        -- 
        export_profile_items_qual_2 (p_bg_name, p_bg_id, pt_i_MigrationSetID, pt_i_MigrationSetName);
        --6
        gvv_ProgressIndicator := '0100';
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
                        ,pt_i_ModuleMessage       => '- Calling Procedure "' ||gcv_PackageName ||'.export_profile_items_qual_3".' 
                        ,pt_i_OracleError         => NULL   );
        -- 
        export_profile_items_qual_3 (p_bg_name, p_bg_id, pt_i_MigrationSetID, pt_i_MigrationSetName);
        --7
        gvv_ProgressIndicator := '0110';
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
                        ,pt_i_ModuleMessage       => '- Calling Procedure "' ||gcv_PackageName ||'.export_profile_items_qual_4".' 
                        ,pt_i_OracleError         => NULL   );
        -- 
        export_profile_items_qual_4 (p_bg_name, p_bg_id, pt_i_MigrationSetID, pt_i_MigrationSetName);
        --8
        gvv_ProgressIndicator := '0120';
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
                        ,pt_i_ModuleMessage       => '- Calling Procedure "' ||gcv_PackageName ||'.export_profile_items_pr_1".' 
                        ,pt_i_OracleError         => NULL   );
        -- 
        export_profile_items_pr_1 (p_bg_name, p_bg_id, pt_i_MigrationSetID, pt_i_MigrationSetName);
        --9
        gvv_ProgressIndicator := '0130';
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
                        ,pt_i_ModuleMessage       => '- Calling Procedure "' ||gcv_PackageName ||'.export_profile_items_pr_2".' 
                        ,pt_i_OracleError         => NULL   );
        -- 
        export_profile_items_pr_2 (p_bg_name, p_bg_id, pt_i_MigrationSetID, pt_i_MigrationSetName);
        --10
        gvv_ProgressIndicator := '0140';
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
                        ,pt_i_ModuleMessage       => '- Calling Procedure "' ||gcv_PackageName ||'.export_profile_items_pr_appr".' 
                        ,pt_i_OracleError         => NULL   );
        -- 
        export_profile_items_pr_appr (p_bg_name, p_bg_id, pt_i_MigrationSetID, pt_i_MigrationSetName);
        --11 
        gvv_ProgressIndicator := '0150';
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
                        ,pt_i_ModuleMessage       => '- Calling Procedure "' ||gcv_PackageName ||'.export_profile_items_pr_cmp".' 
                        ,pt_i_OracleError         => NULL   );
        -- 
        export_profile_items_pr_cmp (p_bg_name, p_bg_id, pt_i_MigrationSetID, pt_i_MigrationSetName);

    COMMIT;
        --  
    EXCEPTION
        WHEN OTHERS THEN
            --
            ROLLBACK;
            --
            gvt_OracleError := SUBSTR(
                                    SQLERRM ||'** ERROR_BACKTRACE: ' ||dbms_utility.format_error_backtrace
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
                    ,pt_i_ModuleMessage       => gvt_ModuleMessage  
                    ,pt_i_OracleError         => gvt_ReturnMessage       );     
            --
            RAISE;
        -- Hr_Utility.raise_error@MXDM_NVIS_EXTRACT;
    END export_profiles_person;

	/****************************************************************	
	----------------Export HR Lookups -------------------------------
	*****************************************************************/	

    PROCEDURE export_lookups IS

        cv_ProcOrFuncName            CONSTANT      VARCHAR2(30) := 'export_lookups'; 
        cv_i_BusinessEntityLevel  CONSTANT      VARCHAR2(30) := 'ALL'; 
        v_cnt number DEFAULT 0;

        TYPE seed_blood_typ_codes IS VARRAY (8) OF VARCHAR2(20);
        v_seed_blood_typ_lkp_codes seed_blood_typ_codes DEFAULT seed_blood_typ_codes ('A+'
                                                                                    ,'A-'
                                                                                    ,'B+'
                                                                                    ,'B-'
                                                                                    ,'O+'
                                                                                    ,'O-'
                                                                                    ,'AB+'
                                                                                    ,'AB-');
        TYPE seed_mar_status_codes IS VARRAY (9) OF VARCHAR2(20);
        v_seed_mar_status_lkp_codes seed_mar_status_codes DEFAULT seed_mar_status_codes ('S'
                                                                                        ,'M'
                                                                                        ,'L'
                                                                                        ,'D'
                                                                                        ,'W'
                                                                                        ,'SE'
                                                                                        ,'BE_WID_PENS'
                                                                                        ,'BE_LIV_TOG'
                                                                                        ,'CL');
        TYPE seed_title_codes IS VARRAY (5) OF VARCHAR2(20);
        v_seed_title_lkp_codes seed_title_codes DEFAULT seed_title_codes ('DR.'
                                                                        ,'MISS'
                                                                        ,'MR.'
                                                                        ,'MRS.'
                                                                        ,'MS.');
        TYPE seed_nationality_codes IS VARRAY (17) OF VARCHAR2(20);
        v_seed_nat_lkp_codes seed_nationality_codes DEFAULT seed_nationality_codes ('AT'
                                                                                ,'BE'
                                                                                ,'DE'
                                                                                ,'DK'
                                                                                ,'ES'
                                                                                ,'FI'
                                                                                ,'FR'
                                                                                ,'GB'
                                                                                ,'GR'
                                                                                ,'IE'
                                                                                ,'IT'
                                                                                ,'LU'
                                                                                ,'NL'
                                                                                ,'NO'
                                                                                ,'PL'
                                                                                ,'PT'
                                                                                ,'SE');
        TYPE seed_us_eth_grp_codes IS VARRAY (8) OF VARCHAR2(264);
        v_seed_us_eth_grp_lkp_codes seed_us_eth_grp_codes DEFAULT seed_us_eth_grp_codes ('1'
                                                                                        ,'2'
                                                                                        ,'3'
                                                                                        ,'4'
                                                                                        ,'5'
                                                                                        ,'6'
                                                                                        ,'9'
                                                                                        ,'13');
    BEGIN
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
                        ,pt_i_ModuleMessage       => '- Begin: Lookup Type ' ||gcv_PackageName||'.'||cv_ProcOrFuncName ||' BLOOD_TYPE' 
                        ,pt_i_OracleError         => NULL   );
            -- 
        FOR i IN 1 .. v_seed_blood_typ_lkp_codes.last LOOP
            v_cnt := i;

            g_per_lkp_map (v_cnt).ebs_lookup_type := 'BLOOD_TYPE';

            g_per_lkp_map (v_cnt).ebs_lookup_code := v_seed_blood_typ_lkp_codes (i);

            g_per_lkp_map (v_cnt).fusion_lookup_code := v_seed_blood_typ_lkp_codes (i);
        END LOOP;

        v_cnt := v_cnt + 1;

        g_per_lkp_map (v_cnt).ebs_lookup_type := 'SEX';

        g_per_lkp_map (v_cnt).ebs_lookup_code := 'M';

        g_per_lkp_map (v_cnt).fusion_lookup_code := 'M';

        v_cnt := v_cnt + 1;

        g_per_lkp_map (v_cnt).ebs_lookup_type := 'SEX';

        g_per_lkp_map (v_cnt).ebs_lookup_code := 'F';

        g_per_lkp_map (v_cnt).fusion_lookup_code := 'F';

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
                        ,pt_i_ModuleMessage       => '- Lookup Type ' ||gcv_PackageName||'.'||cv_ProcOrFuncName ||' MAR_STATUS' 
                        ,pt_i_OracleError         => NULL   );

        FOR i IN 1 .. v_seed_mar_status_lkp_codes.last LOOP
            v_cnt := v_cnt + 1;

            g_per_lkp_map (v_cnt).ebs_lookup_type := 'MAR_STATUS';

            g_per_lkp_map (v_cnt).ebs_lookup_code := v_seed_mar_status_lkp_codes (i);

            g_per_lkp_map (v_cnt).fusion_lookup_code := (CASE
                                                            WHEN v_seed_mar_status_lkp_codes (i) = 'SE' THEN
                                                            'Se'
                                                            ELSE
                                                            v_seed_mar_status_lkp_codes (i)
                                                        END);
        END LOOP;

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
                        ,pt_i_ModuleMessage       => '- Lookup Type ' ||gcv_PackageName||'.'||cv_ProcOrFuncName ||' NATIONALITY'
                        ,pt_i_OracleError         => NULL   );

        FOR i IN 1 .. v_seed_nat_lkp_codes.last LOOP
            v_cnt := v_cnt + 1;

            g_per_lkp_map (v_cnt).ebs_lookup_type := 'NATIONALITY';

            g_per_lkp_map (v_cnt).ebs_lookup_code := 'PQH_'
                                                    || v_seed_nat_lkp_codes (i);

            g_per_lkp_map (v_cnt).fusion_lookup_code := v_seed_nat_lkp_codes (i);
        END LOOP;

                     gvv_ProgressIndicator := '0040';
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
                        ,pt_i_ModuleMessage       => '- Lookup Type ' ||gcv_PackageName||'.'||cv_ProcOrFuncName ||' US_ETHNIC_GROUP'
                        ,pt_i_OracleError         => NULL   );

        FOR i IN 1 .. v_seed_us_eth_grp_lkp_codes.last LOOP
            v_cnt := v_cnt + 1;

            g_per_lkp_map (v_cnt).ebs_lookup_type := 'US_ETHNIC_GROUP';

            g_per_lkp_map (v_cnt).ebs_lookup_code := v_seed_us_eth_grp_lkp_codes (i);

            g_per_lkp_map (v_cnt).fusion_lookup_code := (CASE
                                                            WHEN v_seed_us_eth_grp_lkp_codes (i) = 1 THEN
                                                            v_seed_us_eth_grp_lkp_codes (i)  WHEN v_seed_us_eth_grp_lkp_codes (i) = 9 THEN
                                                            4  WHEN v_seed_us_eth_grp_lkp_codes (i) = 13 THEN
                                                                2
                                                            ELSE
                                                            v_seed_us_eth_grp_lkp_codes (i) + 1
                                                        END);
        END LOOP;

        v_cnt := v_cnt + 1;

        g_per_lkp_map (v_cnt).ebs_lookup_type := 'ADDRESS_TYPE';

        g_per_lkp_map (v_cnt).ebs_lookup_code := 'M';

        g_per_lkp_map (v_cnt).fusion_lookup_code := 'MAIL';

        v_cnt := v_cnt + 1;

        g_per_lkp_map (v_cnt).ebs_lookup_type := 'ADDRESS_TYPE';

        g_per_lkp_map (v_cnt).ebs_lookup_code := 'H';

        g_per_lkp_map (v_cnt).fusion_lookup_code := 'HOME';

                   gvv_ProgressIndicator := '0050';
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
                        ,pt_i_ModuleMessage       => '-Calling load_usr_per_lkp' 
                        ,pt_i_OracleError         => NULL   );

        load_usr_per_lkp ('BLOOD_TYPE');

        load_usr_per_lkp ('ADDRESS_TYPE');

        load_usr_per_lkp ('NATIONALITY');

        load_usr_per_lkp ('MAR_STATUS');

        load_usr_per_lkp ('TITLE');

        load_usr_per_lkp ('SEX');
    END export_lookups;

	/****************************************************************	
	----------------Load HR Lookups -------------------------------
	*****************************************************************/	

    PROCEDURE load_usr_per_lkp
        (p_lkp_type IN VARCHAR2) IS

        v_cnt number DEFAULT 0;

        CURSOR c1
            (c_lkp_type IN VARCHAR2) IS
            SELECT  lookup_type ebs_lookup_type
                    ,lookup_code ebs_lookup_code
                    ,lookup_code target_lookup_code
            FROM    fnd_lookup_values@MXDM_NVIS_EXTRACT flv
            -- fnd_lookup_values_vl@MXDM_NVIS_EXTRACT flv  -- Changed for 1.4
            WHERE   lookup_type = c_lkp_type
            AND     view_application_id = 3;
        v_per_lkp_map per_lkp_map_tab;
        v_src_lkp_type VARCHAR2(200);
        v_src_lkp_code VARCHAR2(200);
        v_tgt_lkp_code VARCHAR2(200);

    BEGIN
      gvv_ProgressIndicator := '0010';
              xxmx_utilities_pkg.log_module_message(  
                        pt_i_ApplicationSuite    => gct_ApplicationSuite
                        ,pt_i_Application         => gct_Application
                        ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                        ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                        ,pt_i_Phase               => ct_Phase
                        ,pt_i_Severity            => 'NOTIFICATION'
                        ,pt_i_PackageName         => gcv_PackageName
                        ,pt_i_ProcOrFuncName      => 'load_usr_per_lkp'
                        ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                        ,pt_i_ModuleMessage       => ' BEGIN load_usr_per_lkp '||p_lkp_type
                        ,pt_i_OracleError         => NULL   );

        v_cnt := g_per_lkp_map.last + 1;

        OPEN c1 (p_lkp_type);

        LOOP
            FETCH c1
                INTO    v_src_lkp_type
                    ,v_src_lkp_code
                    ,v_tgt_lkp_code;

            IF c1%FOUND THEN
                g_per_lkp_map (v_cnt).ebs_lookup_type := v_src_lkp_type;

                g_per_lkp_map (v_cnt).ebs_lookup_code := v_src_lkp_code;

                g_per_lkp_map (v_cnt).fusion_lookup_code := v_tgt_lkp_code;

                v_cnt := v_cnt + 1;
            END IF;

            EXIT WHEN c1%NOTFOUND;
        END LOOP;

        CLOSE c1;

			  gvv_ProgressIndicator := '0020';
              xxmx_utilities_pkg.log_module_message(  
                        pt_i_ApplicationSuite    => gct_ApplicationSuite
                        ,pt_i_Application         => gct_Application
                        ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                        ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                        ,pt_i_Phase               => ct_Phase
                        ,pt_i_Severity            => 'NOTIFICATION'
                        ,pt_i_PackageName         => gcv_PackageName
                        ,pt_i_ProcOrFuncName      => 'load_usr_per_lkp'
                        ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                        ,pt_i_ModuleMessage       => ' END load_usr_per_lkp '||p_lkp_type||' Count '||v_cnt
                        ,pt_i_OracleError         => NULL   );


    EXCEPTION
        WHEN no_data_found THEN
        RETURN;
    END load_usr_per_lkp;

	/****************************************************************	
	----------------Get Target HR Lookups -------------------------------
	*****************************************************************/	

    FUNCTION get_target_lookup_code
        (p_src_lookup_code IN VARCHAR2
        ,p_src_lookup_type IN VARCHAR2) RETURN VARCHAR2 IS
        v_ret VARCHAR2(200);
    BEGIN
        IF g_per_lkp_map IS NULL THEN
            RETURN v_ret;
        END IF;

        IF g_per_lkp_map.count = 0 THEN
            RETURN v_ret;
        END IF;

        FOR i IN g_per_lkp_map.first .. g_per_lkp_map.last LOOP
            IF g_per_lkp_map (i).ebs_lookup_type = p_src_lookup_type THEN
                IF g_per_lkp_map (i).ebs_lookup_code = p_src_lookup_code THEN
                    v_ret := g_per_lkp_map (i).fusion_lookup_code;
                END IF;
            END IF;
        END LOOP;

        RETURN v_ret;
    END get_target_lookup_code;

	/****************************************************************	
	----------------Get Information for Profile----------------------
	*****************************************************************/	


    FUNCTION get_content_type_id
        (p_category IN VARCHAR2) RETURN VARCHAR2 IS
        v_ret VARCHAR2(200);
    BEGIN
        v_ret := NULL;

        SELECT  (CASE
                WHEN    p_category IN ('IE_DIT_CERT','IE_NAT_CERT','LC'
                                    ,'103','104','106'
                                    ,'107','108','112'
                                    ,'CT')
                        THEN    'CERTIFICATION'
                WHEN    p_category IN ('IE_DIPLOMA','IE_DOCT_DEGREE','IE_GRAD_DIPLOMA'
                                    ,'IE_HIGHER_DIPLOMA','IE_MASTER_DEGREE','01'
                                    ,'10','101','102'
                                    ,'109','11','12'
                                    ,'DT','IE_BACH_DEGREE')
                        THEN    'DEGREE'
                WHEN    p_category IN ('AW','AWARD')
                        THEN    'HONOR'
                WHEN    p_category = 'CTB_REG'
                        THEN    'MEMBERSHIP'
                WHEN    p_category IN ('1','110','2'
                                    ,'3','4','5'
                                    ,'6','7','8'
                                    ,'9')
                        THEN    'EDUCATION_LEVEL'
                ELSE    NULL END)
        INTO    v_ret
        FROM    dual;

        RETURN v_ret;
    EXCEPTION
        WHEN no_data_found THEN
        RETURN v_ret;
    END get_content_type_id;

    FUNCTION get_rating_level_id
        (p_cat IN VARCHAR2) RETURN VARCHAR2 IS
        v_ret VARCHAR2(200);
    BEGIN
        v_ret := NULL;
        FOR i IN nvl(g_perf_rat_lvl_map.first, 0) .. nvl(g_perf_rat_lvl_map.last,-1) LOOP
            IF g_perf_rat_lvl_map (i).ebs_lookup_code = p_cat THEN
                v_ret := g_perf_rat_lvl_map (i).guid;
            END IF;
        END LOOP;

        RETURN v_ret;
    EXCEPTION
        WHEN no_data_found THEN
            RETURN v_ret;
    END get_rating_level_id;

	/****************************************************************	
	----------------Performance Rating Model-------------------------
	*****************************************************************/	


    PROCEDURE perf_rating_model_setup
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          number
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'perf_rating_model_setup';   
        vt_ClientSchemaName                             xxmx_client_config_parameters.config_value%TYPE;
        vt_MigrationSetID                               xxmx_migration_headers.migration_set_id%TYPE;
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT '';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'PERF RATING MODEL SETUP';

        vt_BusinessEntitySeq                            xxmx_migration_metadata.business_entity_seq%TYPE;

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
        --main
        --1 
        gvv_ProgressIndicator := '0050';
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
                    ,pt_i_ModuleMessage       => '- Calling Procedure "' ||gcv_PackageName ||'.export_hrt_rating_models_b".' 
                    ,pt_i_OracleError         => NULL   );
        -- 
        export_hrt_rating_models_b (p_bg_name, p_bg_id, pt_i_MigrationSetID, pt_i_MigrationSetName);
        --2
        gvv_ProgressIndicator := '0060';
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
                    ,pt_i_ModuleMessage       => '- Calling Procedure "' ||gcv_PackageName ||'.export_hrt_rating_models_tl".' 
                    ,pt_i_OracleError         => NULL   );
            -- 
        export_hrt_rating_models_tl (p_bg_name, p_bg_id, pt_i_MigrationSetID, pt_i_MigrationSetName);
        --3 
        gvv_ProgressIndicator := '0070';
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
                    ,pt_i_ModuleMessage       => '- Calling Procedure "' ||gcv_PackageName ||'.export_pk_struc_perf_rating_2".' 
                    ,pt_i_OracleError         => NULL   );
            -- 
        export_pk_struc_perf_rating_2 (p_bg_name, p_bg_id, pt_i_MigrationSetID, pt_i_MigrationSetName);
        --4
        gvv_ProgressIndicator := '0080';
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
                    ,pt_i_ModuleMessage       => '- Calling Procedure "' ||gcv_PackageName ||'.export_hrt_rating_levels_b".' 
                    ,pt_i_OracleError         => NULL   );
            -- 
        export_hrt_rating_levels_b (p_bg_name, p_bg_id, pt_i_MigrationSetID, pt_i_MigrationSetName);
        --5
        gvv_ProgressIndicator := '0090';
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
                    ,pt_i_ModuleMessage       => '- Calling Procedure "' ||gcv_PackageName ||'.export_hrt_rating_levels_tl_1".' 
                    ,pt_i_OracleError         => NULL   );
            -- 
        export_hrt_rating_levels_tl_1 (p_bg_name, p_bg_id, pt_i_MigrationSetID, pt_i_MigrationSetName);
        --
    EXCEPTION
        WHEN OTHERS THEN
        --
        ROLLBACK;
        --
        gvt_OracleError := SUBSTR(
                                    SQLERRM ||'** ERROR_BACKTRACE: ' ||dbms_utility.format_error_backtrace
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
    END perf_rating_model_setup;


	/****************************************************************	
	----------------Export Disability Information-------------------------
	*****************************************************************/

    PROCEDURE export_disability
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          number
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_disability'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_PER_DISABILITY_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'PERSON_DISABILITY';

        lvv_migration_date_to                           VARCHAR2(30); 
        lvv_migration_date_from                         VARCHAR2(30); 
        lvv_prev_tax_year_date                          VARCHAR2(30);         
        lvd_migration_date_to                           DATE;  
        lvd_migration_date_from                         DATE;
        lvd_prev_tax_year_date                          DATE;  


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

         set_parameters (p_bg_id);
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
        FROM    XXMX_PER_DISABILITY_STG    
        WHERE   bg_id    = p_bg_id    ;

        COMMIT;
        --

        INSERT  
        INTO    XXMX_PER_DISABILITY_STG
               ( migration_set_id 		,
				migration_set_name 		,
				migration_status		,
				bg_name   				, 
				bg_id            		,			    
				personnumber 			,
				organizationname		,
				organizationclasscode	,
				registrationdate		,
				registrationexpdate		,
				assessmentduedate		,
				category				, 
				description				, 
				degree					, 
				quotafte				, 
				reason					, 
				preregistrationjob		, 
				workrestriction			, 
				status					, 
				legislationcode 		, 
				effectivestartdate 		,
				effectiveenddate		,
				personid		
			)
				--,attribute1) STUDENT 
        SELECT  distinct pt_i_MigrationSetID                               
                ,pt_i_MigrationSetName                               
                ,'EXTRACTED'  
                ,p_bg_name
                ,p_bg_id
				,papf.employee_number
				,NULL
				,NULL
				,pdf.registration_date
				,pdf.registration_exp_date
				--,pdf.assessment_due_date
				,NULL
				,pdf.category
				,pdf.description
				,pdf.degree
				,pdf.quota_fte
				,pdf.reason
				,pdf.pre_registration_job
				,pdf.work_restriction
				,pdf.status
				,gvv_leg_code				
				--,pdf.registration_id
				,NVL(papf.original_date_of_hire , papf.start_date)
				,gv_hr_date
				,papf.person_id
        from per_disabilities_f@MXDM_NVIS_EXTRACT pdf
			,per_All_people_f@MXDM_NVIS_EXTRACT papf
			,fnd_lookup_values@MXDM_NVIS_EXTRACT flv
		where pdf.person_id = papf.person_id
		and   papf.effective_Start_Date BETWEEN pdf.effective_Start_Date and pdf.effective_end_Date
		and flv.lookup_type = 'DISABILITY_CATEGORY'
		and lookup_code = pdf.category
		and papf.business_group_id = p_bg_id
		AND  papf.effective_Start_Date IN    (SELECT max(effective_Start_Date)
                                                          FROM per_all_people_f@MXDM_NVIS_EXTRACT papf1
                                                          WHERE papf1.person_id = papf.person_id
														  AND ((
																TRUNC(papf1.effective_start_date) BETWEEN TRUNC(gvd_migration_date_from) AND TRUNC(gvd_migration_date_to)
															  )
															 OR 
															 (
																TRUNC(papf1.effective_end_date) BETWEEN  TRUNC(gvd_migration_date_from) AND TRUNC(gvd_migration_date_to)
															 )														
															 OR  
															 (
																TRUNC(papf1.effective_start_date)    < TRUNC(gvd_migration_date_from)
																AND TRUNC(papf1.effective_end_date)  > TRUNC(gvd_migration_date_to)
														     ))
														)
		and Exists (select 1
					FROM xxmx_per_persons_stg per
					WHERE per.person_id = papf.person_id)
		;		
        --
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
                        ,pt_i_ModuleMessage       => 'End of extraction at ' || to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS.FF2') || '. Procedure completed'
                        ,pt_i_OracleError         => gvt_ReturnMessage       );     

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
    END export_disability;


	/*********************************************************
			Export Images
	*********************************************************/

	PROCEDURE export_Images	
    (p_bg_name                      IN      varchar2
    ,p_bg_id                        IN      number
    ,pt_i_MigrationSetID            IN      xxmx_migration_headers.migration_set_id%TYPE
    ,pt_i_MigrationSetName          IN      xxmx_migration_headers.migration_set_name%TYPE )
	IS
		cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_Images'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_PER_IMAGES_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'PERSON_IMAGES';

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
        FROM    XXMX_PER_IMAGES_STG    
        WHERE   bg_id    = p_bg_id    ;


		--DELETE FROM XXMX_PER_IMGAES_BLOB_FILE
		--WHERE   bg_id    = p_bg_id ;

        COMMIT;
        --

      /* INSERT INTO XXMX_PER_IMGAES_BLOB_FILE 
       Select parent_id,
              bg_id,
              image 
        from per_images@MXDM_NVIS_EXTRACT PI ,
            XXMX_PER_PERSONS_STG PER 
        WHERE PER.PERSON_ID = PI.PARENT_ID
        and per.bg_id = p_bg_id;
      */


       INSERT  
        INTO    XXMX_PER_IMAGES_STG
               ( migration_set_id 		,
				migration_set_name 		,
				migration_status		,
				bg_name   				, 
				bg_id            		,			    
				personnumber 			,
				imagename				,
				image_ref				,
				imagetype				,
				primary_flag			,
				personid				 
			)
        SELECT  distinct pt_i_MigrationSetID                               
                ,pt_i_MigrationSetName                               
                ,'EXTRACTED'  
                ,p_bg_name
                ,p_bg_id
				,papf.employee_number 
				,PI.Image_id||'_PERSON'||papf.employee_number
				,PN.First_name||'_'||PN.last_name||'_'||PI.Image_id||'.gif'
				,'PROFILE'
				,'Y'
				,papf.person_id
		FROM per_images@MXDM_NVIS_EXTRACT PI
			, per_all_people_f@MXDM_NVIS_EXTRACT papf
            , xxmx_per_names_f_stg pn
		WHERE papf.person_id = to_char(pi.parent_id)
		AND papf.business_group_id    = p_bg_id
        and Trunc(sysdate) between  papf.effective_start_date and papf.effective_end_Date
        AND papf.person_id = pn.person_id   

		;

        COMMIT;

        --
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
                        ,pt_i_ModuleMessage       => 'End of extraction at ' || to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS.FF2') || '. Procedure completed'
                        ,pt_i_OracleError         => gvt_ReturnMessage       );     

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


	END export_Images;


	/*********************************************************
			Export ABSENCE ENTRY
	*********************************************************/

	PROCEDURE export_Absence_entry	
    (p_bg_name                      IN      varchar2
    ,p_bg_id                        IN      number
    ,pt_i_MigrationSetID            IN      xxmx_migration_headers.migration_set_id%TYPE
    ,pt_i_MigrationSetName          IN      xxmx_migration_headers.migration_set_name%TYPE )
	IS
		cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_absence_entry'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_PER_ABSENCE_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'PERSON_ABSENCE';

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
        set_parameters (p_bg_id);
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
        FROM    XXMX_PER_ABSENCE_STG    
        WHERE   bg_id    = p_bg_id    ;

        COMMIT;
        --

       INSERT  
        INTO    XXMX_PER_ABSENCE_STG
               ( migration_set_id 		,
				migration_set_name 		,
				migration_status		,
				bg_name   				, 
				bg_id            		,			    
				PERSONNUMBER 	,
				ABSENCETYPEID	,
				ABSENCESTATUS	,
				APPROVALSTATUS	,
				STARTDATE		,
				STARTTIME		,
				ENDDATE			,
				ENDTIME			,
				ABSENCETYPE		,
				ABSENCENAME		,
				ABSENCECATEGORY	,
				ABSCAT_MEANING,
				DATE_NOTIFICATION,
				ABSENCEREASON	,
				ABSREASON_MEANING,
				CONFIRMEDDATE	,
				COMMENTS		,
				ABSENCE_DAYS 	,
				ABSENCE_HOURS   ,
				LEGISLATIONCODE ,
				LEGAL_EMPLOYER_NAME		,
				INTENDTORETFLAG	,
				ACTUAL_BIRTH_DATE,
				DUE_DATE		,
				SSP1_Issued		,
				EFFECTIVESTARTDATE 	,
				EFFECTIVEENDDATE	,
				ASSIGNMENT_ID 		,
				ASSIGNMENT_NUMBER	,
				PERSONID			,
				ATTRIBUTE1 	,
                StartDateduration, 
                EndDateDuration
			)
	SELECT distinct pt_i_MigrationSetID                               
                ,pt_i_MigrationSetName                               
                ,'EXTRACTED'  
                ,p_bg_name
                ,p_bg_id
				,A.EMPLOYEE_NUMBER 
				,Y.ABSENCE_ATTENDANCE_TYPE_ID
				,NULL
				,x.Approval_status
				,NVL(X.SICKNESS_START_DATE,X.DATE_START )
				,NULL
				,NVL(X.SICKNESS_END_DATE,X.DATE_END)
				,NULL
				,NULL
				,Y.NAME
				,Y.ABSENCE_CATEGORY
				,get_target_lookup_code(Y.ABSENCE_CATEGORY,'ABSENCE_CATEGORY')
				,X.DATE_NOTIFICATION
				,ABSR.name
				,get_target_lookup_code(Y.ABSENCE_CATEGORY,'ABSENCE_REASON')
				,NVL(X.SICKNESS_START_DATE,X.DATE_START )
				--,x.COMMENTS
				,NULL
				,X.ABSENCE_DAYS LeaveDuration
				,X.ABSENCE_Hours TotalHours
				,gvv_leg_code
				,'NULL' Employer
				,NULL
				,NULL
				,NULL
				,NULL
				,NULL
				,NULL
				,B.ASSIGNMENT_ID 
				,B.Assignment_type||B.ASSIGNMENT_NUMBER
				,A.PERSON_ID
				,(SELECT Payroll_name
				  FROM PAY_PAYROLLS_F@MXDM_NVIS_EXTRACT ppf
				  WHERE PAYROLL_ID = B.payroll_id
				  AND trunc(sysdate) BETWEEN ppf.effective_start_date and ppf.effective_end_date)
					  Payroll_name  ,
                      0,0
			FROM    PER_ABSENCE_ATTENDANCES@MXDM_NVIS_EXTRACT X,
				PER_ABS_ATTENDANCE_REASONS@MXDM_NVIS_EXTRACT ABSR,
			  PER_ABSENCE_ATTENDANCE_TYPES@MXDM_NVIS_EXTRACT Y,
			  PER_ALL_PEOPLE_F@MXDM_NVIS_EXTRACT A,
			  PER_ALL_ASSIGNMENTS_F@MXDM_NVIS_EXTRACT B
			WHERE   X.ABSENCE_ATTENDANCE_TYPE_ID = Y.ABSENCE_ATTENDANCE_TYPE_ID
			AND     X.BUSINESS_GROUP_ID = Y.BUSINESS_GROUP_ID
			AND     A.BUSINESS_GROUP_ID = Y.BUSINESS_GROUP_ID
			AND     A.PERSON_ID = X.PERSON_ID
			AND     A.PERSON_ID = B.PERSON_ID
			AND     B.BUSINESS_GROUP_ID = Y.BUSINESS_GROUP_ID
			AND 	A.business_group_id = P_BG_ID
			AND     B.PERSON_ID = X.PERSON_ID
			AND     SYSDATE BETWEEN A.EFFECTIVE_START_DATE AND  A.EFFECTIVE_END_DATE
			AND     SYSDATE BETWEEN B.EFFECTIVE_START_DATE AND  B.EFFECTIVE_END_DATE
			AND 	ABSR.ABS_ATTENDANCE_REASON_ID(+) = X.ABS_ATTENDANCE_REASON_ID
			AND		( X.DATE_START  BETWEEN TRUNC(gvd_migration_date_from) AND TRUNC(gvd_migration_date_to)
			OR 		X.DATE_END BETWEEN TRUNC(gvd_migration_date_from) AND TRUNC(gvd_migration_date_to))
			and UPPER(Y.name) NOT like '%MATERNITY%'
			and Exists (select 1
							FROM xxmx_per_persons_stg per
							WHERE per.person_id = A.person_id)

			ORDER BY 6, 8;     

        --
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
                        ,pt_i_ModuleMessage       => 'End of extraction at ' || to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS.FF2') || '. Procedure completed'
                        ,pt_i_OracleError         => gvt_ReturnMessage       );     

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


	END;

	/*********************************************************
			Export Maternity Absence
	*********************************************************/

	PROCEDURE export_mat_absence	
    (p_bg_name                      IN      varchar2
    ,p_bg_id                        IN      number
    ,pt_i_MigrationSetID            IN      xxmx_migration_headers.migration_set_id%TYPE
    ,pt_i_MigrationSetName          IN      xxmx_migration_headers.migration_set_name%TYPE )
	IS
		cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_mat_absence'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_PER_MAT_ABSENCE_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'PERSON_MAT_ABSENCE';

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
        set_parameters (p_bg_id);
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
        FROM    XXMX_PER_MAT_ABSENCE_STG    
        WHERE   bg_id    = p_bg_id    ;

        COMMIT;
        --

       INSERT  
        INTO    XXMX_PER_MAT_ABSENCE_STG
               ( migration_set_id 		,
				migration_set_name 		,
				migration_status		,
				bg_name   				, 
				bg_id            		,			    
				PERSONNUMBER 	,
				ABSENCETYPEID	,
				ABSENCESTATUS	,
				APPROVALSTATUS	,
				STARTDATE		,
				STARTTIME		,
				ENDDATE			,
				ENDTIME			,
				ABSENCETYPE		,
				ABSENCENAME		,
				ABSENCECATEGORY	,
				ABSCAT_MEANING,
				DATE_NOTIFICATION,
				ABSENCEREASON	,
				ABSREASON_MEANING,
				CONFIRMEDDATE	,
				COMMENTS		,
				ABSENCE_DAYS 	,
				ABSENCE_HOURS   ,
				LEGISLATIONCODE ,
				LEGAL_EMPLOYER_NAME		,
				INTENDTORETFLAG	,
				ACTUAL_BIRTH_DATE,
				DUE_DATE		,
				SSP1_Issued		,
				EFFECTIVESTARTDATE 	,
				EFFECTIVEENDDATE	,
				ASSIGNMENT_ID 		,
				ASSIGNMENT_NUMBER	,
				PERSONID			,
				ATTRIBUTE1 	,
                StartDateduration, 
                EndDateDuration
			)
        SELECT  distinct pt_i_MigrationSetID                               
                ,pt_i_MigrationSetName                               
                ,'EXTRACTED'  
                ,p_bg_name
                ,p_bg_id
				,A.EMPLOYEE_NUMBER 
				,Y.ABSENCE_ATTENDANCE_TYPE_ID
				,NULL
				,x.Approval_status
				,NVL(X.SICKNESS_START_DATE,X.DATE_START )
				,NULL
				,NVL(X.SICKNESS_END_DATE,X.DATE_END)
				,NULL
				,NULL
				,Y.NAME
				,Y.ABSENCE_CATEGORY
				,get_target_lookup_code(Y.ABSENCE_CATEGORY,'ABSENCE_CATEGORY')
				,X.DATE_NOTIFICATION
				,ABSR.name
				,get_target_lookup_code(Y.ABSENCE_CATEGORY,'ABSENCE_REASON')
				,NVL(X.SICKNESS_START_DATE,X.DATE_START )
				--,x.COMMENTS
				,NULL
				,X.ABSENCE_DAYS LeaveDuration
				,X.ABSENCE_Hours TotalHours
				,gvv_leg_code
				,'NULL' Employer
				,SSPM.INTEND_TO_RETURN_FLAG
				,SSPM.ACTUAL_BIRTH_DATE
				,SSPM.DUE_DATE 
				,x.SSP1_Issued
				,NULL
				,NULL
				,B.ASSIGNMENT_ID 
				,B.Assignment_type||B.ASSIGNMENT_NUMBER
				,A.PERSON_ID
				,(SELECT Payroll_name
				  FROM PAY_PAYROLLS_F@MXDM_NVIS_EXTRACT ppf
				  WHERE PAYROLL_ID = B.payroll_id
				  AND trunc(sysdate) BETWEEN ppf.effective_start_date and ppf.effective_end_date)
					  Payroll_name  
                      ,0
                      ,0
			FROM    PER_ABSENCE_ATTENDANCES@MXDM_NVIS_EXTRACT X,
				PER_ABS_ATTENDANCE_REASONS@MXDM_NVIS_EXTRACT ABSR,
			  PER_ABSENCE_ATTENDANCE_TYPES@MXDM_NVIS_EXTRACT Y,
			  PER_ALL_PEOPLE_F@MXDM_NVIS_EXTRACT A,
			  PER_ALL_ASSIGNMENTS_F@MXDM_NVIS_EXTRACT B,
			  SSP_MATERNITIES@MXDM_NVIS_EXTRACT SSPM
			WHERE   X.ABSENCE_ATTENDANCE_TYPE_ID = Y.ABSENCE_ATTENDANCE_TYPE_ID
			AND     X.BUSINESS_GROUP_ID = Y.BUSINESS_GROUP_ID
			AND 	  SSPM.Maternity_id = X.Maternity_id
			AND     A.BUSINESS_GROUP_ID = Y.BUSINESS_GROUP_ID
			AND     A.PERSON_ID = X.PERSON_ID
			AND     A.PERSON_ID = B.PERSON_ID
			AND     B.BUSINESS_GROUP_ID = Y.BUSINESS_GROUP_ID
			AND 	  A.business_group_id = P_BG_ID
			AND     B.PERSON_ID = X.PERSON_ID
			AND     SYSDATE BETWEEN A.EFFECTIVE_START_DATE AND  A.EFFECTIVE_END_DATE
			AND     SYSDATE BETWEEN B.EFFECTIVE_START_DATE AND  B.EFFECTIVE_END_DATE
			and 	  ABSR.ABS_ATTENDANCE_REASON_ID(+) = X.ABS_ATTENDANCE_REASON_ID
			AND	 ( X.DATE_START  BETWEEN TRUNC(gvd_migration_date_from) AND TRUNC(gvd_migration_date_to)
			OR 	  X.DATE_END BETWEEN TRUNC(gvd_migration_date_from) AND TRUNC(gvd_migration_date_to))
			and UPPER(Y.name)  like '%MATERNITY%'
			and Exists (select 1
							FROM xxmx_per_persons_stg per
							WHERE per.person_id = A.person_id)
			ORDER BY 6, 8;     

        --
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
                        ,pt_i_ModuleMessage       => 'End of extraction at ' || to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS.FF2') || '. Procedure completed'
                        ,pt_i_OracleError         => gvt_ReturnMessage       );     

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


	END;

	/****************************************************************	
	----------------Export Religion  ------------------------
	*****************************************************************/	
    PROCEDURE export_religion
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          number
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

		cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_religion'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_PER_RELIGION_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'PERSON_RELIGION';


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
        set_parameters (p_bg_id);
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
        FROM    XXMX_PER_RELIGION_STG    
        WHERE   bg_id    = p_bg_id    ;

        COMMIT;
        --

       INSERT  
        INTO    XXMX_PER_RELIGION_STG
               ( migration_set_id 		,
				migration_set_name 		,
				migration_status		,
				bg_name   				, 
				bg_id            		,			    
				personnumber 			,			
				legislationcode 		, 
				effectivestartdate 		,
				effectiveenddate		,
				religion 				,
				primary_flag			,
				personid				
			)
        SELECT  distinct pt_i_MigrationSetID                               
                ,pt_i_MigrationSetName                               
                ,'EXTRACTED'  
                ,p_bg_name
                ,p_bg_id
				,employee_number
				,gvv_leg_code
				,c1_effective_Start_date
				,gv_hr_date
				,Religion
				,'Y'
				,person_id
		FROM ( SELECT papf.employee_number			
				,NVL(papf.original_date_of_hire , papf.start_date) c1_effective_Start_date
				,'Y'
				,papf.person_id
				,XXMX_KIT_PERSON_STG.EXPORT_DFF_SEGMENT_VAL(person_id
                                                ,ffc.descriptive_flex_context_code
                                                ,'Person_id'
                                                ,'PER_INFORMATION_CATEGORY'
                                                ,'PER_ALL_PEOPLE_F'
                                                ,att.APPLICATION_COLUMN_NAME
                                                ,'trunc(sysdate) between effective_start_date and effective_end_date')
												Religion		
				from FND_DESCRIPTIVE_FLEXS@MXDM_NVIS_EXTRACT  ffv 
					,fnd_descr_flex_contexts@MXDM_NVIS_EXTRACT ffc
					,fnd_application@MXDM_NVIS_EXTRACT ap
					,FND_DESCR_FLEX_COL_USAGE_TL@MXDM_NVIS_EXTRACT att
					,per_all_people_f@MXDM_NVIS_EXTRACT papf
				where 
				--UPPER(ffc.DESCRIPTIVE_FLEX_CONTEXT_CODE) like 'BUSINESS%'
				   ffv.descriptive_flexfield_name = ffc.descriptive_flexfield_name
				and papf.PER_INFORMATION_CATEGORY = ffc.descriptive_flex_Context_code 
				AND ffv.application_id = ffc.application_id
				AND ap.application_id = ffc.application_id
				and att.application_id = ffc.application_id
				AND ffc.descriptive_flex_context_code=att.descriptive_flex_context_code
				and att.descriptive_flexfield_name = ffv.descriptive_flexfield_name
				and ffv.application_table_name like 'PER_ALL_PEOPLE_F'
				and form_left_prompt = 'Religion'
				AND  papf.business_group_id = p_bg_id
				AND  papf.effective_Start_Date IN    (SELECT max(effective_Start_Date)
																  FROM per_all_people_f@MXDM_NVIS_EXTRACT papf1
																  WHERE papf1.person_id = papf.person_id
																  AND ((
																		TRUNC(papf1.effective_start_date) BETWEEN TRUNC(gvd_migration_date_from) AND TRUNC(gvd_migration_date_to)
																	  )
																	 OR 
																	 (
																		TRUNC(papf1.effective_end_date) BETWEEN  TRUNC(gvd_migration_date_from) AND TRUNC(gvd_migration_date_to)
																	 )														
																	 OR  
																	 (
																		TRUNC(papf1.effective_start_date)    < TRUNC(gvd_migration_date_from)
																		AND TRUNC(papf1.effective_end_date)  > TRUNC(gvd_migration_date_to)
																	 ))
																)
				and Exists (select 1
							FROM xxmx_per_persons_stg per
							WHERE per.person_id = papf.person_id)
				) rel
		WHERE rel.religion is NOT NULL;

		INSERT  
        INTO    XXMX_PER_RELIGION_STG
               ( migration_set_id 		,
				migration_set_name 		,
				migration_status		,
				bg_name   				, 
				bg_id            		,			    
				personnumber 			,			
				legislationcode 		, 
				effectivestartdate 		,
				effectiveenddate		,
				religion 				,
				primary_flag			,
				personid				
			)
        SELECT  distinct pt_i_MigrationSetID                               
                ,pt_i_MigrationSetName                               
                ,'EXTRACTED'  
                ,p_bg_name
                ,p_bg_id
				,employee_number
				,gvv_leg_code
				,c1_effective_Start_date
				,gv_hr_date
				,Religion
				,'Y'
				,person_id
		FROM ( 
		SELECT   papf.employee_number			
				,NVL(papf.original_date_of_hire , papf.start_date) c1_effective_Start_date
				,'Y'
				,papf.person_id
				,papf.attribute8 Religion
		FROM PER_ALL_PEOPLE_F@MXDM_NVIS_EXTRACT papf
		WHERE   papf.business_group_id = p_bg_id 
		AND attribute8 is not null
		AND  papf.effective_Start_Date IN    (SELECT max(effective_Start_Date)
											  FROM per_all_people_f@MXDM_NVIS_EXTRACT papf1
											  WHERE papf1.person_id = papf.person_id
											  AND ((
													TRUNC(papf1.effective_start_date) BETWEEN TRUNC(gvd_migration_date_from) AND TRUNC(gvd_migration_date_to)
												  )
												 OR 
												 (
													TRUNC(papf1.effective_end_date) BETWEEN  TRUNC(gvd_migration_date_from) AND TRUNC(gvd_migration_date_to)
												 )														
												 OR  
												 (
													TRUNC(papf1.effective_start_date)    < TRUNC(gvd_migration_date_from)
													AND TRUNC(papf1.effective_end_date)  > TRUNC(gvd_migration_date_to)
												 ))
											)
		AND Exists (select 1
							FROM xxmx_per_persons_stg per
							WHERE per.person_id = papf.person_id)
		)rel


		;

        --
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
                        ,pt_i_ModuleMessage       => 'End of extraction at ' || to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS.FF2') || '. Procedure completed'
                        ,pt_i_OracleError         => gvt_ReturnMessage       );     

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
	END export_religion; 



	/****************************************************************	
	----------------Export Person Information-------------------------
	*****************************************************************/

    PROCEDURE export_persons
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          number
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

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
        FROM    xxmx_per_persons_stg    
        WHERE   bg_id    = p_bg_id    ;

        COMMIT;
        --
        
        Set_parameters(p_bg_id);
        --

        INSERT  
        INTO    XXMX_PER_PERSONS_STG
                (migration_set_id
                ,migration_set_name                   
                ,migration_status
                ,bg_name
                ,bg_id
                ,start_date
                ,party_id
                ,correspondence_language
                ,blood_type
                ,date_of_birth
                ,date_of_death
                ,country_of_birth
                ,region_of_birth
                ,town_of_birth
                ,person_id
				,PERSON_TYPE
				,personnumber)  
        SELECT  distinct pt_i_MigrationSetID                               
                ,pt_i_MigrationSetName                               
                ,'EXTRACTED'  
                ,p_bg_name
                ,p_bg_id
                ,NVL(per_all_people_f.original_date_of_hire , per_all_people_f.start_date)
                ,per_all_people_f.party_id party_id
                ,per_all_people_f.correspondence_language correspondence_language
                ,nvl2 (per_all_people_f.blood_type
                        ,get_target_lookup_code (per_all_people_f.blood_type
                                                ,'BLOOD_TYPE')
                        ,NULL) blood_type
                ,per_all_people_f.date_of_birth date_of_birth
                ,per_all_people_f.date_of_death date_of_death
                ,per_all_people_f.country_of_birth country_of_birth
                ,per_all_people_f.region_of_birth region_of_birth
                ,per_all_people_f.town_of_birth town_of_birth
                ,per_all_people_f.person_id
                ,ppt.SYSTEM_PERSON_TYPE 
				,per_all_people_f.employee_number
        FROM     per_all_people_f@MXDM_NVIS_EXTRACT per_all_people_f
                ,per_person_type_usages_f@MXDM_NVIS_EXTRACT  pptu
                ,per_person_types@MXDM_NVIS_EXTRACT  ppt
        WHERE   1 = 1
        AND per_all_people_f.person_id = pptu.person_id
        and ppt.person_type_id  = pptu.person_type_id
        AND per_all_people_f.business_group_id  = p_bg_id
		AND per_all_people_f.effective_start_date BETWEEN  pptu.effective_Start_Date and pptu.effective_end_date
		AND  per_all_people_f.effective_Start_Date IN    (SELECT max(effective_Start_Date)
                                                          FROM per_all_people_f@MXDM_NVIS_EXTRACT papf
                                                          WHERE papf.person_id = per_all_people_f.person_id
														  AND ((
																TRUNC(per_all_people_f.effective_start_date) BETWEEN TRUNC(gvd_migration_date_from) AND TRUNC(gvd_migration_date_to)
															  )
															 OR 
															 (
																TRUNC(per_all_people_f.effective_end_date) BETWEEN  TRUNC(gvd_migration_date_from) AND TRUNC(gvd_migration_date_to)
															 )														
															 OR  
															 (
																TRUNC(per_all_people_f.effective_start_date)    < TRUNC(gvd_migration_date_from)
																AND TRUNC(per_all_people_f.effective_end_date)  > TRUNC(gvd_migration_date_to)
														     ))
														)
		AND UPPER(ppt.user_person_type) IN( SELECT TRIM (PARAMETER_VALUE)
									FROM xxmx_migration_parameters 
									WHERE application_suite = 'HCM' 
									AND business_entity = 'HCMEMPLOYEE'
									AND parameter_code = 'PERSON_TYPE'
									and Enabled_flag = 'Y')
        --Adding New Parameter - PAYROLL
        AND EXISTS (SELECT 1 
                    FROM  per_all_Assignments_f@MXDM_NVIS_EXTRACT paaf
                        , pay_payrolls_f@MXDM_NVIS_EXTRACT ppf
                    WHERE paaf.payroll_id = ppf.payroll_id
                    AND paaf.person_id = per_all_people_f.person_id
                    AND (TRUNC(paaf.effective_start_date)  BETWEEN  TRUNC(gvd_migration_date_from) AND TRUNC(gvd_migration_date_to)
															 OR 
                        TRUNC(paaf.effective_end_date)  BETWEEN  TRUNC(gvd_migration_date_from) AND TRUNC(gvd_migration_date_to))
                    AND Trunc(sysdate) BETWEEN ppf.effective_start_date AND ppf.effective_end_Date
                    AND UPPER(PPF.PAYROLL_NAME) IN (SELECT UPPER(PARAMETER_VALUE )
                                                    FROM xxmx_migration_parameters 
                                                    WHERE parameter_code like 'PAYROLL_NAME'
                                                    AND ENABLED_FLAG='Y'))
		UNION 
		        SELECT  distinct pt_i_MigrationSetID                               
                ,pt_i_MigrationSetName                               
                ,'EXTRACTED'  
                ,p_bg_name
                ,p_bg_id
                ,NVL(per_all_people_f.original_date_of_hire , per_all_people_f.start_date)
                ,per_all_people_f.party_id party_id
                ,per_all_people_f.correspondence_language correspondence_language
                ,nvl2 (per_all_people_f.blood_type
                        ,get_target_lookup_code (per_all_people_f.blood_type
                                                ,'BLOOD_TYPE')
                        ,NULL) blood_type
                ,per_all_people_f.date_of_birth date_of_birth
                ,per_all_people_f.date_of_death date_of_death
                ,per_all_people_f.country_of_birth country_of_birth
                ,per_all_people_f.region_of_birth region_of_birth
                ,per_all_people_f.town_of_birth town_of_birth
                ,per_all_people_f.person_id
                ,'EX_EMP' attribute1
				,per_all_people_f.employee_number
        FROM     per_all_people_f@MXDM_NVIS_EXTRACT per_all_people_f
				,per_periods_of_service@MXDM_NVIS_EXTRACT  ppos
        WHERE   1 = 1
        AND per_all_people_f.business_group_id  = p_bg_id
		AND ppos.person_id = per_all_people_f.person_id
		and ppos.actual_termination_date is not null
		AND ppos.actual_termination_date BETWEEN  TRUNC(gvd_migration_date_from) AND gv_hr_date
		AND  per_all_people_f.effective_Start_Date IN    (SELECT max(effective_Start_Date)
                                                          FROM per_all_people_f@MXDM_NVIS_EXTRACT papf
                                                          WHERE papf.person_id = per_all_people_f.person_id
														  AND ((
																TRUNC(per_all_people_f.effective_start_date) BETWEEN TRUNC(gvd_migration_date_from) AND TRUNC(gvd_migration_date_to)
															  )
															 OR 
															 (
																TRUNC(per_all_people_f.effective_end_date) BETWEEN  TRUNC(gvd_migration_date_from) AND TRUNC(gvd_migration_date_to)
															 )														
															 OR  
															 (
																TRUNC(per_all_people_f.effective_start_date)    < TRUNC(gvd_migration_date_from)
																AND TRUNC(per_all_people_f.effective_end_date)  > TRUNC(gvd_migration_date_to)
														     ))
														)
        --Adding New Parameter - PAYROLL
         AND EXISTS (SELECT 1 
                    FROM  per_all_Assignments_f@MXDM_NVIS_EXTRACT paaf
                        , pay_payrolls_f@MXDM_NVIS_EXTRACT ppf
                    WHERE paaf.payroll_id = ppf.payroll_id
                    AND paaf.person_id = per_all_people_f.person_id
                    AND (TRUNC(paaf.effective_start_date)  BETWEEN  TRUNC(gvd_migration_date_from) AND TRUNC(gvd_migration_date_to)
															 OR 
                        TRUNC(paaf.effective_end_date)  BETWEEN  TRUNC(gvd_migration_date_from) AND TRUNC(gvd_migration_date_to))
                    AND Trunc(sysdate) BETWEEN ppf.effective_start_date AND ppf.effective_end_Date
                    AND UPPER(PPF.PAYROLL_NAME) IN (SELECT UPPER(PARAMETER_VALUE )
                                                    FROM xxmx_migration_parameters 
                                                    WHERE parameter_code like 'PAYROLL_NAME'
                                                    AND ENABLED_FLAG='Y'))

		;		
        --
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
                        ,pt_i_ModuleMessage       => 'End of extraction at ' || to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS.FF2') || '. Procedure completed'
                        ,pt_i_OracleError         => gvt_ReturnMessage       );     

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
    END export_persons;

    PROCEDURE export_contacts
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          number
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_contacts'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'xxmx_per_contacts_stg';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'PERSON_CONTACTS';



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
        set_parameters (p_bg_id);
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
        FROM    xxmx_per_contacts_stg    
        WHERE   bg_id    = p_bg_id    ;

        COMMIT;
        
        Set_parameters(p_bg_id);
        --

        INSERT  
        INTO    xxmx_per_contacts_stg
                (migration_set_id
                ,migration_set_name                   
                ,migration_status
                ,bg_name
                ,bg_id
                ,start_date
                ,party_id
                ,correspondence_language
                ,blood_type
                ,date_of_birth
                ,date_of_death
                ,country_of_birth
                ,region_of_birth
                ,town_of_birth
                ,person_id
               ,nametype 
               ,last_name
               ,first_name	
               ,middle_names
               ,legislation_code
               ,title
               ,pre_name_adjunct
               ,suffix
               ,known_as
               ,previous_last_name
               ,CNTPERSONNUMBER
                ,personnumber)
        SELECT   pt_i_MigrationSetID                               
                ,pt_i_MigrationSetName                               
                ,'EXTRACTED'  
                ,p_bg_name
                ,p_bg_id
                , per_all_people_f.start_date start_date
                ,per_all_people_f.party_id party_id
                ,per_all_people_f.correspondence_language correspondence_language
                ,nvl2 (per_all_people_f.blood_type
                        ,get_target_lookup_code (per_all_people_f.blood_type
                                                ,'BLOOD_TYPE')
                        ,NULL) blood_type
                ,per_all_people_f.date_of_birth date_of_birth
                ,per_all_people_f.date_of_death date_of_death
                ,per_all_people_f.country_of_birth country_of_birth
                ,per_all_people_f.region_of_birth region_of_birth
                ,per_all_people_f.town_of_birth town_of_birth
                ,per_all_people_f.person_id|| '_PERSON'
				,'GLOBAL'
				,per_all_people_f.last_name 
				,per_all_people_f.first_name
				,per_all_people_f.middle_names
				,gvv_leg_Code
				,per_all_people_f.title
				,per_all_people_f.pre_name_adjunct
				,per_all_people_f.suffix
				,per_all_people_f.known_as
				,per_all_people_f.previous_last_name
				,'CNT_'||papf.employee_number||'_'||pcr.contact_person_id
                ,papf.employee_number
        FROM    per_all_people_f@MXDM_NVIS_EXTRACT per_all_people_f
                ,per_all_people_f@MXDM_NVIS_EXTRACT papf
                ,per_person_types@MXDM_NVIS_EXTRACT ppt
                ,hr_all_organization_units@MXDM_NVIS_EXTRACT horg
				,per_contact_relationships@MXDM_NVIS_EXTRACT PCR
        WHERE   1 = 1
		and PCR.contact_person_id= per_All_people_f.person_id
        AND papf.person_id = PCR.PERSON_ID
        and Trunc(sysdate) between papf.effective_start_Date and papf.effective_end_date
        AND     (
                    (
                    TRUNC(per_all_people_f.effective_start_date) BETWEEN 
                                        TRUNC(gvd_migration_date_from) AND TRUNC(gvd_migration_date_to)
                    )
                OR  (
                    TRUNC(per_all_people_f.effective_end_date) BETWEEN 
                                        TRUNC(gvd_migration_date_from) AND TRUNC(gvd_migration_date_to)
                    )
                OR  (
                        TRUNC(per_all_people_f.effective_start_date)    < TRUNC(gvd_migration_date_from)
                    AND TRUNC(per_all_people_f.effective_end_date)      > TRUNC(gvd_migration_date_to)
                    )
                ) 
            --    (trunc (sysdate) BETWEEN per_all_people_f.effective_start_date
            --                     AND     per_all_people_f.effective_end_date
            --     )                  
        AND     per_all_people_f.person_type_id = ppt.person_type_id    
        and     ppt.SYSTEM_PERSON_TYPE in ('OTHER')          
        AND     horg.organization_id = per_all_people_f.business_group_id
        AND     horg.name = p_bg_name
		AND exists ( Select 1
					 FROM xxmx_per_persons_stg xxper
					 WHERE xxper.person_id = PCR.person_id)
		;
        --
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
                        ,pt_i_ModuleMessage       => 'End of extraction at ' || to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS.FF2') || '. Procedure completed'
                        ,pt_i_OracleError         => gvt_ReturnMessage       );     

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
    END export_contacts;

    PROCEDURE export_email_addresses
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          number
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_email_addresses'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'xxmx_per_email_f_stg';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'PERSON_EMAIL';

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
        FROM    xxmx_per_email_f_stg    
        WHERE   bg_id    = p_bg_id    ;

        COMMIT;   

         Set_parameters(p_bg_id);
        --
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
        --

        INSERT  
        INTO    xxmx_per_email_f_stg
                (migration_set_id
                ,migration_set_name                   
                ,migration_status
                ,bg_name
                ,bg_id
                ,person_id
                ,email_type
                ,date_from
                ,date_to
                ,email_address
                ,primary_flag
                ,email_address_id
				,personnumber)
				--changed the code to remove dependency
        SELECT   pt_i_MigrationSetID                               
                ,pt_i_MigrationSetName                               
                ,'EXTRACTED'  
                ,p_bg_name
                ,p_bg_id
                ,per_all_people_f.person_id person_id           
                ,'W1' email_type
                ,(
                        per_all_people_F.effective_start_date

                 ) date_from
                ,(
                        per_all_people_F.effective_end_date
                 )        date_to
                ,per_all_people_f.email_address 
                ,'Y' primary_flag
                ,person_id|| '_EMAIL'    
				,per_all_people_f.employee_number				
		FROM    per_all_people_f@MXDM_NVIS_EXTRACT per_all_people_f
			,hr_all_organization_units@MXDM_NVIS_EXTRACT horg
		WHERE   1 = 1
		AND    per_all_people_f.effective_Start_Date IN    (SELECT max(effective_Start_Date)
                                                          FROM per_all_people_f@MXDM_NVIS_EXTRACT papf
                                                          WHERE papf.person_id = per_all_people_f.person_id
														  AND ((
																TRUNC(papf.effective_start_date) BETWEEN TRUNC(gvd_migration_date_from) AND TRUNC(gvd_migration_date_to)
															  )
															 OR 
															 (
																TRUNC(papf.effective_end_date) BETWEEN  TRUNC(gvd_migration_date_from) AND TRUNC(gvd_migration_date_to)
															 )														
															 OR  
															 (
																TRUNC(papf.effective_start_date)    < TRUNC(gvd_migration_date_from)
																AND TRUNC(papf.effective_end_date)  > TRUNC(gvd_migration_date_to)
														     ))
														)
	    AND     per_all_people_f.email_address IS NOT NULL
		AND     horg.organization_id = per_all_people_f.business_group_id
		AND     horg.name = p_bg_name
		AND exists ( Select 1
					 FROM xxmx_per_persons_stg xxper
					 WHERE xxper.person_id = per_all_people_f.person_id)
        ;
        --
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
                        ,pt_i_ModuleMessage       => 'End of extraction at ' || to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS.FF2') || '. Procedure completed'
                ,pt_i_OracleError         => gvt_ReturnMessage       );     

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
    END export_email_addresses;

    PROCEDURE export_national_identifiers
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          number
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_national_identifiers'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_PER_NID_F_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'PERSON_NID';

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

        set_parameters (p_bg_id);     

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
        FROM    xxmx_per_nid_f_stg    
        WHERE   bg_id    = p_bg_id    ;         

        COMMIT;
        --
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
        -- 
        INSERT  
        INTO    xxmx_per_nid_f_stg
                (migration_set_id
                ,migration_set_name                   
                ,migration_status
                ,bg_name
                ,bg_id
                ,person_id
                ,legislation_code
                ,national_identifier_type
                ,national_identifier_number
                ,primary_flag
                ,national_identifier_id
				,personnumber)  --Changed the Query to remove dependency
		SELECT distinct  -- Added Distinct to remove multiple Date Track Records V1.1
				 pt_i_MigrationSetID                               
                ,pt_i_MigrationSetName                               
                ,'EXTRACTED'  
                ,p_bg_name
                ,p_bg_id
				,per_all_people_f.person_id||'_PERSON' 
                ,gvv_leg_code
				,CASE WHEN gvv_leg_code='CN' THEN 'CIN'
				  WHEN gvv_leg_code='GB' THEN  'NINO'
				  WHEN gvv_leg_code='US' THEN 'SSN'
				  WHEN gvv_leg_code='IE' THEN 'PPS'
				  Else 'NID' 
				 END national_identifier_type
				,per_all_people_f.national_identifier c1_national_identifier_number
				,'Y'
				,per_all_people_f.person_id|| '_NATIONAL_IDENTIFIER'
				,per_all_people_f.employee_number
        FROM    per_all_people_f@MXDM_NVIS_EXTRACT per_all_people_f
               ,hr_all_organization_units@MXDM_NVIS_EXTRACT horg
		WHERE   per_all_people_f.effective_end_date =  
				(
				SELECT  max (effective_end_date)
				FROM    per_all_people_f@MXDM_NVIS_EXTRACT papf
				WHERE   papf.person_id = per_all_people_f.person_id
				)
		AND     per_all_people_f.national_identifier IS NOT NULL
		AND     horg.organization_id = per_all_people_f.business_group_id
		AND     horg.name = p_bg_name
		AND exists ( Select 1
					 FROM xxmx_per_persons_stg xxper
					 WHERE xxper.person_id = per_all_people_f.person_id)

        ;
        --
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
                        ,pt_i_ModuleMessage       => 'End of extraction at ' || to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS.FF2') || '. Procedure completed'
                        ,pt_i_OracleError         => gvt_ReturnMessage       );     

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
    END export_national_identifiers;

    PROCEDURE export_phones
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          number
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_phones'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'xxmx_per_phones_stg';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'PERSON_PHONE';



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
            set_parameters (p_bg_id);      

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
        FROM    xxmx_per_phones_stg    
        WHERE   bg_id    = p_bg_id    ;

        COMMIT;         
        --
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
        --
		/* Code Changed V1.1*/

        INSERT  
        INTO    xxmx_per_phones_stg
                (migration_set_id
                ,migration_set_name                   
                ,migration_status
                ,bg_name
                ,bg_id
                ,date_from
                ,date_to
                ,phone_type
                ,phone_number
                ,primary_flag
                ,validity
                ,person_id
                ,legislation_code
                ,phone_id
				,meaning
				,personnumber)
        SELECT   distinct pt_i_MigrationSetID                               
                ,pt_i_MigrationSetName                               
                ,'EXTRACTED'  
                ,p_bg_name
                ,p_bg_id
				,date_from
				,NVL(PP.date_to, '31-DEC-4712')
				,phone_type
				,phone_number
				,'Y' primary_flag
				,validity
				,parent_id|| '_PERSON' person_id
				,gvv_leg_code
				-- Added Phone Type also in Source System Key Field
				,phone_id|| '_PHONE'||'_'||phone_type
				,lkp.meaning 
				,PAPF.employee_number
		FROM per_all_people_f@MXDM_NVIS_EXTRACT PAPF,
			 per_phones@MXDM_NVIS_EXTRACT PP,
			 fnd_lookup_values@MXDM_NVIS_EXTRACT lkp     
		WHERE PAPF.business_group_id = p_bg_id
		AND PAPF.person_id = PP.parent_id
		and lkp.lookup_type(+) = 'PHONE_TYPE'
		And lkp.lookup_code(+) = PP.phone_type
		and Trunc(sysdate) between pp.date_from and NVL(PP.date_to, '31-DEC-4712')
		AND   PAPF.effective_Start_Date IN    (SELECT max(effective_Start_Date)
                                                          FROM per_all_people_f@MXDM_NVIS_EXTRACT papf1
                                                          WHERE papf1.person_id = papf.person_id
														  AND ((
																TRUNC(papf1.effective_start_date) BETWEEN TRUNC(gvd_migration_date_from) AND TRUNC(gvd_migration_date_to)															  )
															 OR 
															 (
																TRUNC(papf1.effective_end_date) BETWEEN  TRUNC(gvd_migration_date_from) AND TRUNC(gvd_migration_date_to)
															 )														
															 OR  
															 (
																TRUNC(papf1.effective_start_date)    < TRUNC(gvd_migration_date_from)
																AND TRUNC(papf1.effective_end_date)  > TRUNC(gvd_migration_date_to)
														     ))
														)

		AND exists ( Select 1
					 FROM xxmx_per_persons_stg xxper
					 WHERE xxper.person_id = PAPF.person_id)
        ;
		/*AND    (
						(
						TRUNC(pp.date_from) BETWEEN 
											  TRUNC(lvd_migration_date_from) AND TRUNC(lvd_migration_date_to)
						)
					OR  (
						TRUNC(nvl (pp.date_to ,to_date ('4712-31-12','YYYY-DD-MM'))) BETWEEN 
											  TRUNC(lvd_migration_date_from) AND TRUNC(lvd_migration_date_to)
						)
					OR  (
							TRUNC(pp.date_from)    <   TRUNC(lvd_migration_date_from)
						AND TRUNC(nvl (pp.date_to ,to_date ('4712-31-12','YYYY-DD-MM')))      > TRUNC(lvd_migration_date_to)
						)
				)  
		AND   (
						(
						TRUNC(papf.effective_start_date) BETWEEN 
											  TRUNC(lvd_migration_date_from) AND TRUNC(lvd_migration_date_to)
						)
					OR  (
						TRUNC(nvl (papf.effective_end_date ,to_date ('4712-31-12','YYYY-DD-MM'))) BETWEEN 
											  TRUNC(lvd_migration_date_from) AND TRUNC(lvd_migration_date_to)
						)
					OR  (
							TRUNC(papf.effective_start_date)    <   TRUNC(lvd_migration_date_from)
						AND TRUNC(nvl (papf.effective_end_date ,to_date ('4712-31-12','YYYY-DD-MM')))      > TRUNC(lvd_migration_date_to)
						)
			  )  */


		--
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
                        ,pt_i_ModuleMessage       => 'End of extraction at ' || to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS.FF2') || '. Procedure completed'
                ,pt_i_OracleError         => gvt_ReturnMessage       );     

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
    END export_phones;
	/**************************************************
	****************Contact Relationship***************
	**************************************************/
	PROCEDURE export_Cont_rel
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          number
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_Cont_rel'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_PER_CONTACT_REL_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'CONTACT_RELATIONSHIP';



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
        Set_parameters(p_bg_id);
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
        FROM    XXMX_PER_CONTACT_REL_STG    
        WHERE   bg_id    = p_bg_id    ;

        COMMIT;         
        --
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
        --
		/* Code Changed V1.1*/

        INSERT  
        INTO    XXMX_PER_CONTACT_REL_STG
                (migration_set_id
                ,migration_set_name                   
                ,migration_status
                ,bg_name
                ,bg_id
				,effectivestartdate	
				,effectiveenddate
				,contpersonid	
				,relatedpersonid
			    ,relatedpersonnum				
				,contacttype		
				,emergencycontactflag
				,primarycontactflag	
				,existingperson		
				,personalflag		
				,sequencenumber	
				,CONTACT_PERSONNUM
				)
        SELECT  distinct  pt_i_MigrationSetID                               
                ,pt_i_MigrationSetName                               
                ,'EXTRACTED'  
                ,p_bg_name
                ,p_bg_id
				,papf1.effective_start_date	
				,papf1.effective_end_date
				,CONTACT_PERSON_ID	
				,papf.person_id	
				,NVL(papf.employee_number, papf.applicant_number)
				,contact_type		
				,decode ( CONTACT_TYPE, 'EC','Y','N')emergencycontactflag
				,PRIMARY_CONTACT_FLAG	
				,'Y' existingperson		
				,personal_flag		
				,sequence_number	
				,'CNT_'||papf.employee_number||'_'||pcr.contact_person_id
			FROM
				 per_all_people_f@MXDM_NVIS_EXTRACT  papf,
				 per_contact_relationships@MXDM_NVIS_EXTRACT pcr,
				 per_all_people_f@MXDM_NVIS_EXTRACT  papf1,
				 fnd_lookup_values@MXDM_NVIS_EXTRACT  fcl,
				 per_person_type_usages_f@MXDM_NVIS_EXTRACT ppu,
				 per_person_types@MXDM_NVIS_EXTRACT  ppt
			WHERE
			 papf.business_group_id  = p_bg_id
			 AND  papf.current_employee_flag = 'Y'
			 AND pcr.person_id  = papf.person_id
			 AND TRUNC(PAPF.effective_start_date) BETWEEN papf1.effective_start_date AND papf1.effective_end_date
			 AND papf1.person_id  = pcr.contact_person_id
			 AND UPPER(fcl.lookup_type) = UPPER('CONTACT')
			 AND fcl.lookup_code  = pcr.contact_type
			 AND papf1.person_id  = ppu.person_id
			 AND ppu.person_type_id  = ppt.person_type_id
			 AND TRUNC(SYSDATE) BETWEEN ppu.effective_start_date AND ppu.effective_end_date
			 AND   (
						(
						TRUNC(papf.effective_start_date) BETWEEN 
											  TRUNC(gvd_migration_date_from) AND TRUNC(gvd_migration_date_to)
						)
					OR  (
						TRUNC(nvl (papf.effective_end_date ,to_date ('4712-31-12','YYYY-DD-MM'))) BETWEEN 
											  TRUNC(gvd_migration_date_from) AND TRUNC(gvd_migration_date_to)
						)
					OR  (
							TRUNC(papf.effective_start_date)    <   TRUNC(gvd_migration_date_from)
						AND TRUNC(nvl (papf.effective_end_date ,to_date ('4712-31-12','YYYY-DD-MM')))      > TRUNC(gvd_migration_date_to)
						)
			  )
			 AND exists ( Select 1
					 FROM xxmx_per_persons_stg xxper
					 WHERE xxper.person_id = pcr.person_id)


		;
		--
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
                        ,pt_i_ModuleMessage       => 'End of extraction at ' || to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS.FF2') || '. Procedure completed'
                ,pt_i_OracleError         => gvt_ReturnMessage       );     

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
    END export_Cont_rel;


	/**************************************************
	****************Contact Address***************
	**************************************************/
	PROCEDURE export_Cont_Addr
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          number
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_Cont_Addr'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_PER_CONTACT_ADDR_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'CONTACT_ADDRESS';



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
         set_parameters (p_bg_id);     
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
        FROM    XXMX_PER_CONTACT_ADDR_STG    
        WHERE   bg_id    = p_bg_id    ;

        COMMIT;         
        --
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
        --
		/* Code Changed V1.1*/

        INSERT  
        INTO    XXMX_PER_CONTACT_ADDR_STG
                (migration_set_id
                ,migration_set_name                   
                ,migration_status
                ,bg_name
                ,bg_id
				,effectivestartdate	
				,effectiveenddate
				,contpersonid	
				,addresstype	
				,addressline1	
				,addressline2	
				,addressline3	
				,townorcity		
				,region1		
				,country		
				,postalcode		
				,primaryflag	
				,Contact_personnum
				,RELATEDPERSONNUM
				)
        SELECT   distinct pt_i_MigrationSetID                               
                ,pt_i_MigrationSetName                               
                ,'EXTRACTED'  
                ,p_bg_name
                ,p_bg_id
				,Date_from
				,Date_to
				,papf.person_id
				,NVL(address_type,'H')
				,address_line1
				,Address_line2
				,Address_line3
				,TOWN_OR_CITY
				,Region_1
				,Country
				,NVL(postal_code,'NOPOSTALCODE')
				,Primary_flag
				,'CNT_'||papf.employee_number||'_'||pcr.contact_person_id
				,papf.employee_number
		FROM
			 per_all_people_f@MXDM_NVIS_EXTRACT  papf,
			 per_contact_relationships@MXDM_NVIS_EXTRACT pcr,
			 per_all_people_f@MXDM_NVIS_EXTRACT  papf1,
			 fnd_lookup_values@MXDM_NVIS_EXTRACT  fcl,
			 per_person_type_usages_f@MXDM_NVIS_EXTRACT ppu,
			 per_person_types@MXDM_NVIS_EXTRACT  ppt,
			 per_addresses@MXDM_NVIS_EXTRACT a
			WHERE  trunc(sysdate) between a.date_From and NVL(a.date_to,'31-DEC-4712')
			AND a.person_id = papf1.person_id
			AND  papf.business_group_id  = p_bg_id
			AND  papf.current_employee_flag = 'Y'
			AND pcr.person_id  = papf.person_id
			AND TRUNC(papf.effective_start_date) BETWEEN papf1.effective_start_date AND papf1.effective_end_date
			AND papf1.person_id  = pcr.contact_person_id
			AND UPPER(fcl.lookup_type) = UPPER('CONTACT')
			AND fcl.lookup_code  = pcr.contact_type
			AND papf1.person_id  = ppu.person_id
			AND ppu.person_type_id  = ppt.person_type_id
			AND TRUNC(SYSDATE) BETWEEN ppu.effective_start_date AND ppu.effective_end_date
			AND   (
			(
			TRUNC(papf.effective_start_date) BETWEEN 
							  TRUNC(gvd_migration_date_from) AND TRUNC(gvd_migration_date_to)
			)
			OR  (
			TRUNC(nvl (papf.effective_end_date ,to_date ('4712-31-12','YYYY-DD-MM'))) BETWEEN 
							  TRUNC(gvd_migration_date_from) AND TRUNC(gvd_migration_date_to)
			)
			OR  (
			TRUNC(papf.effective_start_date)    <   TRUNC(gvd_migration_date_from)
			AND TRUNC(nvl (papf.effective_end_date ,to_date ('4712-31-12','YYYY-DD-MM')))      > TRUNC(gvd_migration_date_to)
			)
			) 
			AND exists ( Select 1
					FROM xxmx_per_persons_stg xxper
					WHERE xxper.person_id = pcr.person_id)


		;
		--
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
                        ,pt_i_ModuleMessage       => 'End of extraction at ' || to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS.FF2') || '. Procedure completed'
                ,pt_i_OracleError         => gvt_ReturnMessage       );     

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
    END export_Cont_Addr;


	/**************************************************
	****************Contact Phone***************
	**************************************************/
	PROCEDURE export_Cont_phone
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          number
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_Cont_phone'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_PER_CONTACT_PHONE_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'CONTACT_PHONE';


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
           set_parameters (p_bg_id);      
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
        FROM    XXMX_PER_CONTACT_PHONE_STG    
        WHERE   bg_id    = p_bg_id    ;

        COMMIT;         
        --
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
        --
		/* Code Changed V1.1*/

        INSERT  
        INTO    XXMX_PER_CONTACT_PHONE_STG
                (migration_set_id
                ,migration_set_name                   
                ,migration_status
                ,bg_name
                ,bg_id
				,datefrom		
				,dateto			
				,contpersonid		
				,legislationcode		
				,countrycodenumber   
				,phonetype			
				,phonenumber			
				,primaryflag
				,CONTACT_PERSONNUM	
				,RELATEDPERSONNUM				
				)
        SELECT   pt_i_MigrationSetID                               
                ,pt_i_MigrationSetName                               
                ,'EXTRACTED'  
                ,p_bg_name
				,p_bg_id
				,date_from			
				,date_to				
				,Parent_id				
				,gvv_leg_code
				,NULL   
				,NVL(phone_type	,'H1')
				,phone_number			
				,'Y'
				,'CNT_'||papf.employee_number||'_'||pcr.contact_person_id
				,papf.employee_number				
				FROM
					 per_all_people_f@MXDM_NVIS_EXTRACT  papf,
					 per_contact_relationships@MXDM_NVIS_EXTRACT pcr,
					 per_all_people_f@MXDM_NVIS_EXTRACT  papf1,
					 fnd_lookup_values@MXDM_NVIS_EXTRACT  fcl,
					 per_person_type_usages_f@MXDM_NVIS_EXTRACT ppu,
					 per_person_types@MXDM_NVIS_EXTRACT  ppt,
                 per_phones@MXDM_NVIS_EXTRACT pp
				where pp.parent_id = papf1.person_id
				 AND papf.business_group_id  = p_bg_id
				 AND  papf.current_employee_flag = 'Y'
				 AND pcr.person_id  = papf.person_id
				 AND TRUNC(papf.effective_start_date) BETWEEN papf1.effective_start_date AND papf1.effective_end_date
				 AND papf1.person_id  = pcr.contact_person_id
				 AND UPPER(fcl.lookup_type) = UPPER('CONTACT')
				 AND fcl.lookup_code  = pcr.contact_type
				 AND papf1.person_id  = ppu.person_id
				 AND ppu.person_type_id  = ppt.person_type_id
				 AND TRUNC(SYSDATE) BETWEEN ppu.effective_start_date AND ppu.effective_end_date
				 AND   (
				(
				TRUNC(papf.effective_start_date) BETWEEN 
									  TRUNC(gvd_migration_date_from) AND TRUNC(gvd_migration_date_to)
				)
				OR  (
				TRUNC(nvl (papf.effective_end_date ,to_date ('4712-31-12','YYYY-DD-MM'))) BETWEEN 
									  TRUNC(gvd_migration_date_from) AND TRUNC(gvd_migration_date_to)
				)
				OR  (
					TRUNC(papf.effective_start_date)    <   TRUNC(gvd_migration_date_from)
				AND TRUNC(nvl (papf.effective_end_date ,to_date ('4712-31-12','YYYY-DD-MM')))      > TRUNC(gvd_migration_date_to)
				)
				)
				AND exists ( Select 1
							FROM xxmx_per_persons_stg xxper
							WHERE xxper.person_id = pcr.person_id)


		;
		--
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
                        ,pt_i_ModuleMessage       => 'End of extraction at ' || to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS.FF2') || '. Procedure completed'
                ,pt_i_OracleError         => gvt_ReturnMessage       );     

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
    END export_Cont_phone;



    PROCEDURE export_per_addr_f_us
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          number
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_per_addr_f_us'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'xxmx_per_address_f_stg';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'PERSON_ADDRESS';


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
         Set_parameters(p_bg_id);
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
        FROM    XXMX_STG.xxmx_per_address_f_stg
        WHERE   bg_id    = p_bg_id    ;

        COMMIT;     
        --
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
        --Commented by Pallavi V1.1
        /*INSERT  
        INTO    xxmx_addr_f_stg
                (migration_set_id
                ,migration_set_name                   
                ,migration_status
                ,bg_name
                ,bg_id
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
				,personnumber				) -- New Column Added 
        SELECT   pt_i_MigrationSetID                               
                ,pt_i_MigrationSetName                               
                ,'EXTRACTED'  
                ,p_bg_name
                ,p_bg_id
                , c33_effective_start_date effective_start_date
                ,c27_effective_end_date effective_end_date
                ,c31_address_line_1 address_line_1
                ,c30_address_line_2 address_line_2
                ,c29_address_line_3 address_line_3
                ,c22_town_or_city town_or_city
                ,c25_region_1 region_1
                ,c23_region_2 region_2
                ,c39_style country
                ,c28_postal_code postal_code
                ,c24_derived_locale derived_locale
                ,s0_address_id
                    || '_PERSON_ADDRESS'
				,s0_person_id|| '_PERSON' person_id  -- Added by Pallavi V1.1
				,xxmx_per_persons_stg.personnumber
        FROM    xxmx_per_persons_stg xxmx_per_persons_stg
            ,
                (
                SELECT  per_addresses.town_or_city c22_town_or_city
                    ,per_addresses.region_2 c23_region_2
                    ,per_addresses.derived_locale c24_derived_locale
                    ,per_addresses.region_1 c25_region_1
                    ,per_addresses.addr_attribute20 c26_addr_attribute20
                    ,to_date ('31-12-4712'
                                ,'DD-MM-YYYY') c27_effective_end_date
                    ,per_addresses.postal_code c28_postal_code
                    ,per_addresses.address_line3 c29_address_line_3
                    ,per_addresses.address_line2 c30_address_line_2
                    ,per_addresses.address_line1 c31_address_line_1
                    ,per_addresses.date_from c33_effective_start_date
                    ,per_addresses.country c37_country
                    ,per_addresses.style c39_style
                    ,per_addresses.address_type c40_address_type
                    ,per_addresses.address_id s0_address_id
                    ,per_addresses.person_id s0_person_id
                FROM    per_addresses@MXDM_NVIS_EXTRACT per_addresses
                    ,hr_all_organization_units@MXDM_NVIS_EXTRACT horg
                WHERE   
				--per_addresses.style = 'US'  -- Commented by Pallavi V1.1
                     per_addresses.primary_flag = 'Y'
                -- AND     trunc (sysdate) BETWEEN per_addresses.date_from
                --                         AND     nvl (per_addresses.date_to,to_date ('4712-31-12','YYYY-DD-MM'))
                AND     (
                            (
                            TRUNC(per_addresses.date_from) BETWEEN 
                                                TRUNC(lvd_migration_date_from) AND TRUNC(lvd_migration_date_to)
                            )
                        OR  (
                            TRUNC(nvl (per_addresses.date_to,to_date ('4712-31-12','YYYY-DD-MM'))) BETWEEN 
                                                TRUNC(lvd_migration_date_from) AND TRUNC(lvd_migration_date_to)
                            )
                        OR  (
                                TRUNC(per_addresses.date_from)    < TRUNC(lvd_migration_date_from)
                            AND TRUNC(nvl (per_addresses.date_to,to_date ('4712-31-12','YYYY-DD-MM')))      > TRUNC(lvd_migration_date_to)
                            )
                        ) 	
                AND     horg.organization_id = per_addresses.business_group_id
                AND     horg.name = p_bg_name
                ) c_per_addresses_f
        WHERE   (
                        xxmx_per_persons_stg.person_id = c_per_addresses_f.s0_person_id

                )
        ;*/

		-- New Table for Person Addresses Created
		INSERT  
        INTO    xxmx_per_address_f_stg
                (migration_set_id
                ,migration_set_name                   
                ,migration_status
                ,bg_name
                ,bg_id
                ,effective_start_date
                ,effective_end_date
                ,address_line_1
                ,address_line_2
                ,address_line_3
                ,town_or_city
                ,region_1
                ,region_2
                ,country
				,country_code
                ,postal_code
                ,derived_locale
                ,address_id
				,Person_id
				,Primary_flag
				,Telephone_number_1
				,TELEPHONE_NUMBER_2
				,TELEPHONE_NUMBER_3
				,ADDRESS_STYLE
				,address_type
				,addl_address_attribute1
				,addl_address_attribute2
				,addl_address_attribute3
				,addl_address_attribute4
				,addl_address_attribute5
				,personnumber
				) -- New Column Added
		SELECT  distinct pt_i_MigrationSetID                               
                ,pt_i_MigrationSetName                               
                ,'EXTRACTED'  
                ,p_bg_name
                ,p_bg_id
				,pa.date_from
				,NVL(pa.date_to,'31-DEC-4712')
				,pa.address_line1
				,pa.address_line2
				,pa.address_line3
				,pa.town_or_city
				,pa.region_1 
				,pa.region_2
				,NVL(NVL(T.TERRITORY_SHORT_NAME,T.Territory_code),pa.country) COUNTRY 
				,NVL(T.TERRITORY_CODE ,pa.country) 
				,NVL(pa.postal_code,'NOPOSTCODE')
				,pa.derived_locale
				,pa.address_id||'_'||'PERSON_ADDRESS'
				,papf.person_id							
				,pa.primary_flag
				,pa.telephone_number_1
				,pa.telephone_number_2
				,pa.telephone_number_3
				,TL.DESCRIPTIVE_FLEX_CONTEXT_NAME Address_STYLE 
				,nvl (get_target_lookup_code (pa.address_type 
                                            ,'ADDRESS_TYPE')
                      ,'MAIL') address_type
				,addr_attribute1
				,addr_attribute2
				,addr_attribute3
				,addr_attribute4
				,addr_attribute5
				,papf.employee_number
		FROM  	per_all_people_f@MXDM_NVIS_EXTRACT PAPF
			   ,per_addresses@MXDM_NVIS_EXTRACT PA
			   ,fnd_territories_tl@MXDM_NVIS_EXTRACT T 
			   ,fnd_descr_flex_contexts_tl@MXDM_NVIS_EXTRACT TL 
		WHERE  PAPF.PERSON_ID                = PA.PERSON_ID
		AND  PAPF.business_group_id = p_bg_id
		AND PA.COUNTRY                    = T.TERRITORY_CODE (+)
		AND PA.STYLE                      =      TL.DESCRIPTIVE_FLEX_CONTEXT_CODE
		AND TL.DESCRIPTIVE_FLEXFIELD_NAME = 'Address Structure'
		--AND TL.LANGUAGE                   = USERENV('LANG')
		/*AND   (
						(
						TRUNC(papf.effective_start_date) BETWEEN 
											  TRUNC(gvd_migration_date_from) AND TRUNC(gvd_migration_date_to)
						)
						OR  (
						TRUNC(nvl (papf.effective_end_date ,to_date ('4712-31-12','YYYY-DD-MM'))) BETWEEN 
											  TRUNC(gvd_migration_date_from) AND TRUNC(gvd_migration_date_to)
						)
			/*			OR  (
							TRUNC(papf.effective_start_date)    <   TRUNC(lvd_migration_date_from)
						AND TRUNC(nvl (papf.effective_end_date ,to_date ('4712-31-12','YYYY-DD-MM')))      > TRUNC(lvd_migration_date_to)
						)*/
			 /* )*/
		AND       TRUNC(SYSDATE) BETWEEN pa.date_from AND NVL(pa.date_to,'31-DEC-4712')
        AND       TRUNC(SYSDATE) BETWEEN papf.effective_start_date AND papf.effective_end_date
		AND exists ( Select 1
					FROM xxmx_per_persons_stg xxper
					WHERE xxper.person_id = PAPF.person_id)

		;
        --
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
                        ,pt_i_ModuleMessage       => 'End of extraction at ' || to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS.FF2') || '. Procedure completed'
                ,pt_i_OracleError         => gvt_ReturnMessage       );     

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

    END export_per_addr_f_us;

    PROCEDURE export_per_addr_usages_f
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          number
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_per_addr_usages_f'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'xxmx_per_addr_usg_f_stg';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'PERSON_ADDRESS_USAGE';



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
        Set_parameters(p_bg_id);
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
        FROM    xxmx_per_addr_usg_f_stg    
        WHERE   bg_id    = p_bg_id    ;

        COMMIT;        
        --
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
            --
        INSERT  
        INTO    xxmx_per_addr_usg_f_stg            
                (migration_set_id
                ,migration_set_name                   
                ,migration_status
                ,bg_name
                ,bg_id
                ,effective_start_date
                ,effective_end_date
                ,person_id
                ,address_id
                ,address_type
                ,person_addr_usage_id
                ,personnumber)
				--Removed Dependency table by Pallavi 
        SELECT   pt_i_MigrationSetID                               
                ,pt_i_MigrationSetName                               
                ,'EXTRACTED'  
                ,p_bg_name
                ,p_bg_id
                , per_addresses.date_from c3_effective_start_date
                ,to_date ('31-12-4712'
                            ,'DD-MM-YYYY') effective_end_date
                ,PER_aDDRESSES.person_id person_id
                ,per_addresses.address_id ||'_PERSON_ADDRESS'
               ,nvl (get_target_lookup_code (per_addresses.address_type 
                                            ,'ADDRESS_TYPE')
                      ,'HOME') address_type
                ,per_addresses.address_id 
                    || '_ADDRESS_USAGE'
                ,'NOTUSED'
        FROM    per_addresses@MXDM_NVIS_EXTRACT per_addresses
               ,hr_all_organization_units@MXDM_NVIS_EXTRACT horg
        WHERE   per_addresses.primary_flag = 'Y'
        AND     trunc (sysdate) BETWEEN per_addresses.date_from
                                         AND     nvl (per_addresses.date_to,to_date ('4712-31-12','YYYY-DD-MM'))
                -- AND     (
                --             (
                --             TRUNC(per_addresses.date_from) BETWEEN 
                --                                 TRUNC(lvd_migration_date_from) AND TRUNC(lvd_migration_date_to)
                --             )
                --         OR  (
                --             TRUNC(nvl (per_addresses.date_to,to_date ('4712-31-12','YYYY-DD-MM'))) BETWEEN 
                --                                 TRUNC(lvd_migration_date_from) AND TRUNC(lvd_migration_date_to)
                --             )
                --         OR  (
                --                 TRUNC(per_addresses.date_from)    < TRUNC(lvd_migration_date_from)
                --             AND TRUNC(nvl (per_addresses.date_to,to_date ('4712-31-12','YYYY-DD-MM')))      > TRUNC(lvd_migration_date_to)
                --             )
                --         ) 	                                                            
        AND     horg.organization_id = per_addresses.business_group_id
        AND     horg.name = p_bg_name
		AND exists ( Select 1
					FROM xxmx_per_persons_stg xxper
					WHERE xxper.person_id = per_addresses.person_id)

		;

        --
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
                        ,pt_i_ModuleMessage       => 'End of extraction at ' || to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS.FF2') || '. Procedure completed'
                        ,pt_i_OracleError         => gvt_ReturnMessage       );     

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

    END export_per_addr_usages_f;

    PROCEDURE export_per_all_people_f
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          number
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_per_all_people_f'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'xxmx_per_people_f_stg';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'PERSON_PEOPLE_F';

        v_fir_insert                                    number;
        v_sec_insert                                    number;


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
         Set_parameters(p_bg_id);
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
        FROM    xxmx_per_people_f_stg    
        WHERE   bg_id    = p_bg_id    ;

        COMMIT;        
        --
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
        --

        INSERT  
        INTO    xxmx_per_people_f_stg            
                (migration_set_id
                ,migration_set_name                   
                ,migration_status
                ,bg_name
                ,bg_id
                ,person_id
                ,effective_start_date
                ,effective_end_date
                ,start_date
                ,applicant_number
                ,personnumber
                ,waive_data_protect)
        SELECT   pt_i_MigrationSetID                               
                ,pt_i_MigrationSetName                               
                ,'EXTRACTED'  
                ,p_bg_name
                ,p_bg_id
                ,papf.person_id||'_PERSON' person_id
                ,papf.effective_start_date
                ,NVL(papf.effective_end_Date,'31-DEC-4712') effective_end_date
                ,NVL(papf.original_date_of_hire , papf.start_date)
                ,papf.applicant_number applicant_number
                ,DECODE(per.attribute1,'EMP',papf.employee_number,'EX_EMP',papf.employee_number,papf.npw_number) personnumber
            ,'N' waive_data_protect
         FROM    Per_all_people_f@MXDM_NVIS_EXTRACT papf
                ,xxmx_per_persons_stg per
        WHERE      papf.business_group_id = p_bg_id
        and per.person_id = papf.person_id
		and trunc(sysdate) BETWEEN papf.effective_Start_Date and papf.effective_end_date

;
       /* AND 
		(
                    (
                    TRUNC(papf.effective_start_Date) BETWEEN 
                                        TRUNC(lvd_migration_date_from) AND TRUNC(lvd_migration_date_to)
                    )
                OR  (
                    TRUNC(nvl (papf.effective_end_Date,to_date ('4712-31-12','YYYY-DD-MM'))) BETWEEN 
                                        TRUNC(lvd_migration_date_from) AND TRUNC(lvd_migration_date_to)
                    )
                OR  (
                        TRUNC(papf.effective_start_Date)    < TRUNC(lvd_migration_date_from)
                    AND TRUNC(nvl (papf.effective_end_Date,to_date ('4712-31-12','YYYY-DD-MM')))      > TRUNC(lvd_migration_date_to)
                    )
                )*/

       /* v_fir_insert := sql%ROWCOUNT;

        IF (v_fir_insert > 0) THEN
        UPDATE  xxmx_per_people_f_stg ou
        SET     ou.effective_end_date = 
                                        (
                                        SELECT  min (inn.effective_start_date) - 1
                                        FROM    xxmx_per_people_f_stg inn
                                        WHERE   inn.person_id = ou.person_id
                                        AND     inn.effective_start_date > ou.effective_start_date
                                        )
        WHERE   EXISTS
                (
                SELECT  1
                FROM    xxmx_per_people_f_stg
                        ,xxmx_per_persons_stg
                WHERE   xxmx_per_people_f_stg.effective_start_date > ou.effective_start_date
                AND     xxmx_per_people_f_stg.person_id = ou.person_id
                AND     xxmx_per_persons_stg.person_id = xxmx_per_people_f_stg.person_id
                );
        END IF;*/

        --
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
                        ,pt_i_ModuleMessage       => 'End of extraction at ' || to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS.FF2') || '. Procedure completed'
                ,pt_i_OracleError         => gvt_ReturnMessage       );     

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

    END export_per_all_people_f;

    PROCEDURE export_per_ethnicities_us
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          number
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_per_ethnicities_us'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_PER_ETHNICITIES_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'PERSON_ETHNICITIES';


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
           set_parameters (p_bg_id);       

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
        FROM    xxmx_per_ethnicities_stg    
        WHERE   bg_id    = p_bg_id    ;

        COMMIT;     
        --
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
        --
        INSERT  
        INTO    xxmx_per_ethnicities_stg
                (migration_set_id
                ,migration_set_name                   
                ,migration_status
                ,bg_name
                ,bg_id
                ,person_id
                ,legislation_code
                ,ethnicity
                ,primary_flag
                ,declarer_id
                ,ethnicity_id
				,personnumber)
			-- Changed by Pallavi to remove dependency
        SELECT   pt_i_MigrationSetID                               
                ,pt_i_MigrationSetName                               
                ,'EXTRACTED'  
                ,p_bg_name
                ,p_bg_id
                ,per_all_people_f.person_id person_id
                ,gvv_leg_code
                ,nvl (get_target_lookup_code (per_all_people_f.per_information1
                                                ,'US_ETHNIC_GROUP') --ETH_TYPE get clarification
                        ,per_all_people_f.per_information1) ethnicity
                ,'Y' primary_flag
                ,per_all_people_f.per_information14 declarer_id
                ,per_all_people_f.person_id
                    || '_ETHNICITY'
				,per_all_people_f.employee_number
        FROM 	per_all_people_f@MXDM_NVIS_EXTRACT per_all_people_f
                ,hr_all_organization_units@MXDM_NVIS_EXTRACT horg
        WHERE    trunc (sysdate) BETWEEN per_all_people_f.effective_start_date AND  per_all_people_f.effective_end_date
        AND      per_all_people_f.business_group_id = horg.organization_id         
        AND      horg.name = p_bg_name
		AND exists ( Select 1
					FROM xxmx_per_persons_stg xxper
					WHERE xxper.person_id = per_all_people_f.person_id)

		;
        --
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
                        ,pt_i_ModuleMessage       => 'End of extraction at ' || to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS.FF2') || '. Procedure completed'
                ,pt_i_OracleError         => gvt_ReturnMessage       );     

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

    END export_per_ethnicities_us;

    PROCEDURE export_per_people_legis_f_us
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          number
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_per_people_legis_f_us'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'xxmx_per_leg_f_stg';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'PERSON_LEGISLATIVE';

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
             set_parameters (p_bg_id);     

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
        FROM    xxmx_per_leg_f_stg    
        WHERE   bg_id    = p_bg_id    ;

        COMMIT;        
        --
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
        --   

        INSERT  
        INTO    xxmx_per_leg_f_stg
                (migration_set_id
                ,migration_set_name                   
                ,migration_status
                ,bg_name
                ,bg_id
                ,person_legislative_id
                ,effective_start_date
                ,effective_end_date
                ,person_id
                ,legislation_code
                ,sex
                ,marital_status
				,marital_status_Date
                ,per_information_category
                ,per_information1
                ,per_information2
                ,per_information3
                ,per_information4
                ,per_information5
                ,per_information6
                ,per_information7
                ,per_information8
                ,per_information9
                ,per_information10
				,   per_information11   
				,   per_information12   
				,   per_information13   
				,   per_information14   
				,   per_information15   
				,   per_information16   
				,   per_information17   
				,   per_information18   
				,   per_information19   
				,   per_information20   
				,   per_information21   
				,   per_information22   
				,   per_information23   
				,   per_information24   
				,   per_information25   
				,   per_information26   
				,   per_information27   
				,   per_information28   
				,   per_information29   
				,   per_information30 
				,personnumber)
        SELECT   pt_i_MigrationSetID                               
                ,pt_i_MigrationSetName                               
                ,'EXTRACTED'  
                ,p_bg_name
                ,p_bg_id
                , person_id
                    || '_LEGISLATIVE' person_legislative_id
                ,c5_effective_start_date effective_start_date
                ,c4_effective_end_date effective_end_date
                ,xxmx_per_persons_stg.person_id person_id
                ,gvv_leg_Code
                ,get_target_lookup_code (c24_sex
                                        ,'SEX') sex
                ,get_target_lookup_code (c21_marital_status
                                        ,'MAR_STATUS') marital_status
				,DECODE(c21_marital_status,NULL,NULL,
					                      'S', NULL,
										  c5_effective_start_date)
				,c3_per_information_category
				,c16_per_information1
                ,c22_per_information2
				,c13_per_information3
				,c11_per_information4
				,c12_per_information5
				,c15_per_information6
				,c23_per_information7
				,c17_per_information8
				,c14_per_information9
				,c18_per_information10
				,   per_information11   
				,   per_information12   
				,   per_information13   
				,   per_information14   
				,   per_information15   
				,   per_information16   
				,   per_information17   
				,   per_information18   
				,   per_information19   
				,   per_information20   
				,   per_information21   
				,   per_information22   
				,   per_information23   
				,   per_information24   
				,   per_information25   
				,   per_information26   
				,   per_information27   
				,   per_information28   
				,   per_information29   
				,   per_information30 
				,   employee_number
        FROM    xxmx_per_persons_stg xxmx_per_persons_stg
            ,
                (
                SELECT  decode (per_all_people_f.per_information25
                            ,'NOTVET'
                            ,'Y'
                            ,'N') c1_per_information10
                    ,per_all_people_f.per_information_category c3_per_information_category
                    ,per_all_people_f.effective_end_date c4_effective_end_date
                    ,per_all_people_f.effective_start_date c5_effective_start_date
                    ,per_all_people_f.per_information8 c7_per_information8
                    ,per_all_people_f.per_information4 c11_per_information4
                    ,per_all_people_f.per_information5 c12_per_information5
                    ,per_all_people_f.per_information3 c13_per_information3
                    ,per_all_people_f.per_information9 c14_per_information9
                    ,per_all_people_f.per_information6 c15_per_information6
                    ,per_all_people_f.per_information1 c16_per_information1
                    ,per_all_people_f.person_id c19_person_id
                    ,per_all_people_f.marital_status c21_marital_status
                    ,per_all_people_f.sex c24_sex
                    ,per_all_people_f.per_information2 c22_per_information2
                    ,per_all_people_f.per_information8 c17_per_information8
                    ,per_all_people_f.per_information7 c23_per_information7
                    ,per_all_people_f.per_information10 c18_per_information10
					,per_all_people_f.per_information11   
                    ,per_all_people_f.per_information12   
                    ,per_all_people_f.per_information13   
                    ,per_all_people_f.per_information14   
                    ,per_all_people_f.per_information15   
                    ,per_all_people_f.per_information16   
                    ,per_all_people_f.per_information17   
                    ,per_all_people_f.per_information18   
                    ,per_all_people_f.per_information19   
                    ,per_all_people_f.per_information20   
                    ,per_all_people_f.per_information21   
                    ,per_all_people_f.per_information22   
                    ,per_all_people_f.per_information23   
                    ,per_all_people_f.per_information24   
                    ,per_all_people_f.per_information25   
                    ,per_all_people_f.per_information26   
                    ,per_all_people_f.per_information27   
                    ,per_all_people_f.per_information28   
                    ,per_all_people_f.per_information29   
                    ,per_all_people_f.per_information30 
					,per_all_people_f.employee_number
                FROM    per_all_people_f@MXDM_NVIS_EXTRACT per_all_people_f
                    ,hr_all_organization_units@MXDM_NVIS_EXTRACT horg
                WHERE  trunc(SYSDATE) BETWEEN per_all_people_f.effective_Start_Date and per_All_people_f.effective_end_Date
				AND    horg.organization_id = per_all_people_f.business_group_id
                AND     horg.name = p_bg_name

                ) c_per_people_leg_us
        WHERE   (
                        xxmx_per_persons_stg.person_id = c19_person_id

                )
        ;
        --
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
                        ,pt_i_ModuleMessage       => 'End of extraction at ' || to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS.FF2') || '. Procedure completed'
                        ,pt_i_OracleError         => gvt_ReturnMessage       );     

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

    END export_per_people_legis_f_us;

    PROCEDURE export_per_names_global_us
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          number
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_per_names_global_us'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_PER_NAMES_F_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'PERSON_NAMES';

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
        set_parameters (p_bg_id);

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
        FROM    XXMX_PER_NAMES_F_STG    
        WHERE   bg_id    = p_bg_id    ;

        COMMIT;         
        --
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
        --   

        INSERT  
        INTO    XXMX_PER_NAMES_F_STG
                (migration_set_id
                ,migration_set_name                   
                ,migration_status
                ,bg_name
                ,bg_id
                ,person_name_id
                ,effective_start_date
                ,effective_end_date
                ,person_id
                ,legislation_code
                ,last_name
                ,first_name
                ,middle_names
                ,title
                ,pre_name_adjunct
                ,suffix
                ,known_as
                ,previous_last_name
                ,honors
                ,full_name
                ,order_name
                ,name_type
				,personnumber)
				--Changed Done to remove Dependencies
		SELECT distinct  pt_i_MigrationSetID                               
                ,pt_i_MigrationSetName                               
                ,'EXTRACTED'  
                ,p_bg_name
                ,p_bg_id
                , person_id
                    || '_NAME' person_name_id
                ,per_all_people_f.effective_start_date
                ,per_all_people_f.effective_end_date c8_effective_end_date
                ,per_all_people_f.person_id person_id
                ,gvv_leg_code
                ,TRIM(per_all_people_f.last_name)
                ,TRIM(per_all_people_f.first_name)
                ,TRIM(per_all_people_f.middle_names)
                ,get_target_lookup_code (per_all_people_f.title
                                        ,'TITLE') title
                ,per_all_people_f.pre_name_adjunct 
                ,per_all_people_f.suffix
                ,per_all_people_f.known_as
                ,per_all_people_f.previous_last_name
                ,per_all_people_f.honors  
                ,per_all_people_f.full_name
                ,NULL  
                ,'GLOBAL' name_type
				,employee_number
        FROM    per_all_people_f@MXDM_NVIS_EXTRACT per_all_people_f
		WHERE  per_all_people_f.business_Group_id = p_bg_id
		AND trunc(sysdate) between per_all_people_f.effective_Start_Date and per_all_people_F.effective_end_Date
		aND exists ( Select 1
					FROM xxmx_per_persons_stg xxper
					WHERE xxper.person_id = per_all_people_f.person_id);

		/*AND  per_all_people_f.effective_start_date IN( select max(papf.effective_start_date )
                                          FROM per_all_people_f@MXDM_NVIS_EXTRACT papf
                                          where papf.person_id = per_all_people_f.person_id
										  AND ((
																			TRUNC(paaf.effective_start_date) BETWEEN TRUNC(lvd_migration_date_from) AND TRUNC(lvd_migration_date_to)
																		   )
																			OR  
																		  (
																			TRUNC(paaf.effective_end_date) BETWEEN  TRUNC(lvd_migration_date_from) AND TRUNC(lvd_migration_date_to)
																		   )
																			OR
																		  (
																			TRUNC(paaf.effective_start_date)    < TRUNC(lvd_migration_date_from)
																			AND TRUNC(paaf.EFFECTIVE_END_DATE)  >  TRUNC(lvd_migration_date_to)
																		  ))           
                                    ) */


		/*AND 		(
						NOT EXISTS
							(
							SELECT  1
							FROM    per_all_people_f@MXDM_NVIS_EXTRACT c
							WHERE   c.person_id = per_all_people_f.person_id
							AND     c.effective_end_date = (per_all_people_f.effective_start_date - 1)
							)
				OR      EXISTS
						(
						SELECT  1
						FROM    per_all_people_f@MXDM_NVIS_EXTRACT c
						WHERE   c.person_id = per_all_people_f.person_id
						AND     c.effective_end_date = (per_all_people_f.effective_start_date - 1)
						AND     (
										nvl (c.last_name
											,'~NULL~') <> nvl (per_all_people_f.last_name
															,'~NULL~')
								OR      nvl (c.first_name
											,'~NULL~') <> nvl (per_all_people_f.first_name
															,'~NULL~')
								OR      nvl (c.known_as
											,'~NULL~') <> nvl (per_all_people_f.known_as
															,'~NULL~')
								OR      nvl (c.middle_names
											,'~NULL~') <> nvl (per_all_people_f.middle_names
															,'~NULL~')
								OR      nvl (c.previous_last_name
											,'~NULL~') <> nvl (per_all_people_f.previous_last_name
															,'~NULL~')
								OR      nvl (c.title
											,'~NULL~') <> nvl (per_all_people_f.title
															,'~NULL~')
								OR      nvl (c.suffix
											,'~NULL~') <> nvl (per_all_people_f.suffix
															,'~NULL~')
								OR      nvl (c.pre_name_adjunct
											,'~NULL~') <> nvl (per_all_people_f.pre_name_adjunct
															,'~NULL~')
								OR      nvl (c.honors
											,'~NULL~') <> nvl (per_all_people_f.honors
															,'~NULL~')
								)
						)
				)        
        ;
		*/
				/*
        SELECT   pt_i_MigrationSetID                               
                ,pt_i_MigrationSetName                               
                ,'EXTRACTED'  
                ,p_bg_name
                ,p_bg_id
                , person_id
                    || '_NAME' person_name_id
                ,c10_effective_start_date effective_start_date
                ,c8_effective_end_date effective_end_date
                ,xxmx_per_persons_stg.person_id person_id
                ,gvv_leg_code legislation_code
                ,c6_last_name last_name
                ,c2_first_name first_name
                ,c4_middle_names middle_names
                ,get_target_lookup_code (c21_title
                                        ,'TITLE') title
                ,c18_pre_name_adjunct pre_name_adjunct
                ,c5_suffix suffix
                ,c12_known_as known_as
                ,c1_previous_last_name previous_last_name
                ,c7_honors honors
                ,c13_full_name full_name
                ,c16_order_name order_name
                ,'GLOBAL' name_type
        FROM    xxmx_per_persons_stg xxmx_per_persons_stg
                ,
                (
                SELECT  per_all_people_f.previous_last_name c1_previous_last_name
                    ,per_all_people_f.first_name c2_first_name
                    ,'MAXIMISE' c3_last_updated_by
                    ,per_all_people_f.middle_names c4_middle_names
                    ,per_all_people_f.suffix c5_suffix
                    ,per_all_people_f.last_name c6_last_name
                    ,per_all_people_f.honors c7_honors
                    ,per_all_people_f.effective_end_date
                        c8_effective_end_date
                    ,'MAXIMISE' c9_created_by
                    ,per_all_people_f.effective_start_date c10_effective_start_date
                    ,nvl (per_all_people_f.object_version_number
                            ,1) c11_object_version_number
                    ,per_all_people_f.known_as c12_known_as
                    ,per_all_people_f.full_name c13_full_name
                    ,nvl (per_all_people_f.last_update_date
                            ,CAST (current_timestamp AT TIME ZONE tz_offset (dbtimezone) AS timestamp) ) c14_last_update_date
                    ,nvl (per_all_people_f.creation_date
                            ,CAST (current_timestamp AT TIME ZONE tz_offset (dbtimezone) AS timestamp) ) c15_creation_date
                    ,nvl (per_all_people_f.order_name
                            ,per_all_people_f.last_name
                            || ', '
                            || per_all_people_f.first_name
                            || '('
                            || per_all_people_f.known_as
                            || ')') c16_order_name
                    ,NULL c17_nam_information1
                    ,per_all_people_f.pre_name_adjunct c18_pre_name_adjunct
                    ,per_all_people_f.person_id c20_person_id
                    ,per_all_people_f.title c21_title
                FROM    per_all_people_f@MXDM_NVIS_EXTRACT per_all_people_f
                WHERE   (
                                NOT EXISTS
                                    (
                                    SELECT  1
                                    FROM    per_all_people_f@MXDM_NVIS_EXTRACT c
                                    WHERE   c.person_id = per_all_people_f.person_id
                                    AND     c.effective_end_date = (per_all_people_f.effective_start_date - 1)
                                    )
                        OR      EXISTS
                                (
                                SELECT  1
                                FROM    per_all_people_f@MXDM_NVIS_EXTRACT c
                                WHERE   c.person_id = per_all_people_f.person_id
                                AND     c.effective_end_date = (per_all_people_f.effective_start_date - 1)
                                AND     (
                                                nvl (c.last_name
                                                    ,'~NULL~') <> nvl (per_all_people_f.last_name
                                                                    ,'~NULL~')
                                        OR      nvl (c.first_name
                                                    ,'~NULL~') <> nvl (per_all_people_f.first_name
                                                                    ,'~NULL~')
                                        OR      nvl (c.known_as
                                                    ,'~NULL~') <> nvl (per_all_people_f.known_as
                                                                    ,'~NULL~')
                                        OR      nvl (c.middle_names
                                                    ,'~NULL~') <> nvl (per_all_people_f.middle_names
                                                                    ,'~NULL~')
                                        OR      nvl (c.previous_last_name
                                                    ,'~NULL~') <> nvl (per_all_people_f.previous_last_name
                                                                    ,'~NULL~')
                                        OR      nvl (c.title
                                                    ,'~NULL~') <> nvl (per_all_people_f.title
                                                                    ,'~NULL~')
                                        OR      nvl (c.suffix
                                                    ,'~NULL~') <> nvl (per_all_people_f.suffix
                                                                    ,'~NULL~')
                                        OR      nvl (c.pre_name_adjunct
                                                    ,'~NULL~') <> nvl (per_all_people_f.pre_name_adjunct
                                                                    ,'~NULL~')
                                        OR      nvl (c.honors
                                                    ,'~NULL~') <> nvl (per_all_people_f.honors
                                                                    ,'~NULL~')
                                        )
                                )
                        )
                ) c_per_person_names
        WHERE   (
                        xxmx_per_persons_stg.person_id = c20_person_id
                )
		AND  xxmx_per_persons_stg.bg_name = p_bg_name
        ;*/

        --
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
                        ,pt_i_ModuleMessage       => 'End of extraction at ' || to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS.FF2') || '. Procedure completed'
                ,pt_i_OracleError         => gvt_ReturnMessage       );     

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

    END export_per_names_global_us;

PROCEDURE export_per_Passport
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          number
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_per_passport'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_PER_PASSPORT_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'PERSON_PASSPORT';

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
                set_parameters (p_bg_id);
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
        FROM    XXMX_PER_PASSPORT_STG    
        WHERE   bg_id    = p_bg_id    ;

        COMMIT;         
        --
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
        --   

        INSERT  
        INTO    XXMX_PER_PASSPORT_STG
                (
				 migration_set_id
				,migration_set_name
				,migration_status
				,bg_name
				,bg_id      
				,personnumber
				,legislationcode
				,personid
				,passporttype
				,passportnumber
				,issuedate
				,expirationdate
				,issuingauthority
				,issuingcountry 
				,IssuingLocation
				,profession 
                ,name
				)
		SELECT   pt_i_MigrationSetID                               
                ,pt_i_MigrationSetName                               
                ,'EXTRACTED'  
                ,p_bg_name
                ,p_bg_id
                ,employee_number
				,gvv_leg_code
                ,to_number(person_id)
				,information_type
				,to_char(PASSPORT_NUMBER)
				,Issue_Date
				,Expiry_Date
				,''
				,ISSUING_COUNTRY
				,PLACE_OF_ISSUE
				,profession
                ,name
        FROM (Select 
					 papf.employee_number
					,pei.Person_id
					,PEI.information_type
					,(SELECT EXPORT_DFF_SEGMENT_VAL 
												(pei.person_id
												,pei.information_type
												,'person_id'
												,'information_type'
												,'per_people_extra_info'
												,att.application_column_name)
					FROM apps.fnd_descriptive_flexs_vl@MXDM_NVIS_EXTRACT ffv,
						apps.fnd_descr_flex_contexts_vl@MXDM_NVIS_EXTRACT ffc,
						apps.fnd_descr_flex_col_usage_vl@MXDM_NVIS_EXTRACT att,
						apps.fnd_flex_value_sets@MXDM_NVIS_EXTRACT fvs,
						apps.fnd_application_vl@MXDM_NVIS_EXTRACT ap
					WHERE ffv.descriptive_flexfield_name = att.descriptive_flexfield_name
					AND ap.application_id=ffv.application_id
					AND ffv.descriptive_flexfield_name = ffc.descriptive_flexfield_name
					AND ffv.application_id = ffc.application_id
					AND ffc.descriptive_flex_context_code=att.descriptive_flex_context_code
					AND fvs.flex_value_set_id=att.flex_value_set_id
					AND ffv.title like 'Extra Person Information'
					AND ffc.descriptive_flex_context_code = pei.information_type
					and UPPER(att.form_left_prompt) IN( 'ISSUE DATE', 'DATE OF ISSUE')) "ISSUE_DATE"
					,(SELECT EXPORT_DFF_SEGMENT_VAL 
												(pei.person_id
												,pei.information_type
												,'person_id'
												,'information_type'
												,'per_people_extra_info'
												,att.application_column_name)
					FROM apps.fnd_descriptive_flexs_vl@MXDM_NVIS_EXTRACT ffv,
						apps.fnd_descr_flex_contexts_vl@MXDM_NVIS_EXTRACT ffc,
						apps.fnd_descr_flex_col_usage_vl@MXDM_NVIS_EXTRACT att,
						apps.fnd_flex_value_sets@MXDM_NVIS_EXTRACT fvs,
						apps.fnd_application_vl@MXDM_NVIS_EXTRACT ap
					WHERE ffv.descriptive_flexfield_name = att.descriptive_flexfield_name
					AND ap.application_id=ffv.application_id
					AND ffv.descriptive_flexfield_name = ffc.descriptive_flexfield_name
					AND ffv.application_id = ffc.application_id
					AND ffc.descriptive_flex_context_code=att.descriptive_flex_context_code
					AND fvs.flex_value_set_id=att.flex_value_set_id
					AND ffv.title like 'Extra Person Information'
					AND ffc.descriptive_flex_context_code = pei.information_type
					and UPPER(att.form_left_prompt) IN( 'EXPIRY DATE', 'DATE OF EXPIRY'))"EXPIRY_DATE"
					,(SELECT EXPORT_DFF_SEGMENT_VAL 
												(pei.person_id
												,pei.information_type
												,'person_id'
												,'information_type'
												,'per_people_extra_info'
												,att.application_column_name)
					FROM apps.fnd_descriptive_flexs_vl@MXDM_NVIS_EXTRACT ffv,
						apps.fnd_descr_flex_contexts_vl@MXDM_NVIS_EXTRACT ffc,
						apps.fnd_descr_flex_col_usage_vl@MXDM_NVIS_EXTRACT att,
						apps.fnd_flex_value_sets@MXDM_NVIS_EXTRACT fvs,
						apps.fnd_application_vl@MXDM_NVIS_EXTRACT ap
					WHERE ffv.descriptive_flexfield_name = att.descriptive_flexfield_name
					AND ap.application_id=ffv.application_id
					AND ffv.descriptive_flexfield_name = ffc.descriptive_flexfield_name
					AND ffv.application_id = ffc.application_id
					AND ffc.descriptive_flex_context_code=att.descriptive_flex_context_code
					AND fvs.flex_value_set_id=att.flex_value_set_id
					AND ffv.title like 'Extra Person Information'
					AND ffc.descriptive_flex_context_code = pei.information_type
					and UPPER(att.form_left_prompt) IN( 'PASSPORT NUMBER')) "PASSPORT_NUMBER"
					,(SELECT EXPORT_DFF_SEGMENT_VAL 
												(pei.person_id
												,pei.information_type
												,'person_id'
												,'information_type'
												,'per_people_extra_info'
												,att.application_column_name)
					FROM apps.fnd_descriptive_flexs_vl@MXDM_NVIS_EXTRACT ffv,
						apps.fnd_descr_flex_contexts_vl@MXDM_NVIS_EXTRACT ffc,
						apps.fnd_descr_flex_col_usage_vl@MXDM_NVIS_EXTRACT att,
						apps.fnd_flex_value_sets@MXDM_NVIS_EXTRACT fvs,
						apps.fnd_application_vl@MXDM_NVIS_EXTRACT ap
					WHERE ffv.descriptive_flexfield_name = att.descriptive_flexfield_name
					AND ap.application_id=ffv.application_id
					AND ffv.descriptive_flexfield_name = ffc.descriptive_flexfield_name
					AND ffv.application_id = ffc.application_id
					AND ffc.descriptive_flex_context_code=att.descriptive_flex_context_code
					AND fvs.flex_value_set_id=att.flex_value_set_id
					AND ffv.title like 'Extra Person Information'
					AND ffc.descriptive_flex_context_code = pei.information_type
					and UPPER(att.form_left_prompt) IN( 'ISSUING COUNTRY')) "ISSUING_COUNTRY"
					,(SELECT EXPORT_DFF_SEGMENT_VAL 
												(pei.person_id
												,pei.information_type
												,'person_id'
												,'information_type'
												,'per_people_extra_info'
												,att.application_column_name)
					FROM apps.fnd_descriptive_flexs_vl@MXDM_NVIS_EXTRACT ffv,
						apps.fnd_descr_flex_contexts_vl@MXDM_NVIS_EXTRACT ffc,
						apps.fnd_descr_flex_col_usage_vl@MXDM_NVIS_EXTRACT att,
						apps.fnd_flex_value_sets@MXDM_NVIS_EXTRACT fvs,
						apps.fnd_application_vl@MXDM_NVIS_EXTRACT ap
					WHERE ffv.descriptive_flexfield_name = att.descriptive_flexfield_name
					AND ap.application_id=ffv.application_id
					AND ffv.descriptive_flexfield_name = ffc.descriptive_flexfield_name
					AND ffv.application_id = ffc.application_id
					AND ffc.descriptive_flex_context_code=att.descriptive_flex_context_code
					AND fvs.flex_value_set_id=att.flex_value_set_id
					AND ffv.title like 'Extra Person Information'
					AND ffc.descriptive_flex_context_code = pei.information_type
					and UPPER(att.form_left_prompt) IN( 'PLACE OF ISSUE'))	"PLACE_OF_ISSUE"
					,(SELECT EXPORT_DFF_SEGMENT_VAL 
												(pei.person_id
												,pei.information_type
												,'person_id'
												,'information_type'
												,'per_people_extra_info'
												,att.application_column_name)
					FROM apps.fnd_descriptive_flexs_vl@MXDM_NVIS_EXTRACT ffv,
						apps.fnd_descr_flex_contexts_vl@MXDM_NVIS_EXTRACT ffc,
						apps.fnd_descr_flex_col_usage_vl@MXDM_NVIS_EXTRACT att,
						apps.fnd_flex_value_sets@MXDM_NVIS_EXTRACT fvs,
						apps.fnd_application_vl@MXDM_NVIS_EXTRACT ap
					WHERE ffv.descriptive_flexfield_name = att.descriptive_flexfield_name
					AND ap.application_id=ffv.application_id
					AND ffv.descriptive_flexfield_name = ffc.descriptive_flexfield_name
					AND ffv.application_id = ffc.application_id
					AND ffc.descriptive_flex_context_code=att.descriptive_flex_context_code
					AND fvs.flex_value_set_id=att.flex_value_set_id
					AND ffv.title like 'Extra Person Information'
					AND ffc.descriptive_flex_context_code = pei.information_type
					and UPPER(att.form_left_prompt) IN( 'ISSUING AUTHORITY')) "ISSUING_AUTHORITY"
					,(SELECT EXPORT_DFF_SEGMENT_VAL 
												(pei.person_id
												,pei.information_type
												,'person_id'
												,'information_type'
												,'per_people_extra_info'
												,att.application_column_name)
					FROM apps.fnd_descriptive_flexs_vl@MXDM_NVIS_EXTRACT ffv,
						apps.fnd_descr_flex_contexts_vl@MXDM_NVIS_EXTRACT ffc,
						apps.fnd_descr_flex_col_usage_vl@MXDM_NVIS_EXTRACT att,
						apps.fnd_flex_value_sets@MXDM_NVIS_EXTRACT fvs,
						apps.fnd_application_vl@MXDM_NVIS_EXTRACT ap
					WHERE ffv.descriptive_flexfield_name = att.descriptive_flexfield_name
					AND ap.application_id=ffv.application_id
					AND ffv.descriptive_flexfield_name = ffc.descriptive_flexfield_name
					AND ffv.application_id = ffc.application_id
					AND ffc.descriptive_flex_context_code=att.descriptive_flex_context_code
					AND fvs.flex_value_set_id=att.flex_value_set_id
					AND ffv.title like 'Extra Person Information'
					AND ffc.descriptive_flex_context_code = pei.information_type
					and UPPER(att.form_left_prompt) IN( 'PROFESSION'))		"PROFESSION"
                    ,substr(papf.full_name,1,100) name
			  FROM per_people_extra_info@MXDM_NVIS_EXTRACT pei,
				   per_All_people_f@MXDM_NVIS_EXTRACT papf
			  where papf.person_id = pei.person_id
		      and trunc(sysdate)between papf.effective_start_date and papf.effective_end_date
			  AND papf.business_group_id = p_bg_id
			  and pei.information_type like '%PASSPORT%'
			  AND exists ( Select 1
					FROM xxmx_per_persons_stg xxper
					WHERE xxper.person_id = papf.person_id)
			)
		;     
		--
		COMMIT;
        --
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
                        ,pt_i_ModuleMessage       => 'End of extraction at ' || to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS.FF2') || '. Procedure completed'
                ,pt_i_OracleError         => gvt_ReturnMessage       );     

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

    END export_per_Passport;


    PROCEDURE export_per_visa
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          number
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_per_visa'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_PER_VISA_F_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'PERSON_VISA';

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
        set_parameters (p_bg_id);     

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
        FROM    XXMX_PER_VISA_F_STG    
        WHERE   bg_id    = p_bg_id    ;

        COMMIT;         
        --
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
        --   

        INSERT  
        INTO    XXMX_PER_VISA_F_STG
                (
				 migration_set_id
				,migration_set_name
				,migration_status
				,bg_name
				,bg_id      
				,EFFECTIVESTARTDATE  
				,EFFECTIVEENDDATE    
				,PERSONNUMBER        
				,PERSON_ID
				,LEGISLATIONCODE  
				,ENTRYDATE        
				,EXPIRATIONDATE   
				,CURRENTVISAPERMIT 
				,ISSUEDATE         
				,ISSUINGAUTHORITY  
				,ISSUINGCOUNTRY    
				,ISSUINGLOCATION   
				,PROFESSION        
				,VISAPERMITCATEGORY
				,VISAPERMITNUMBER  
				,VISAPERMITSTATUS  
				,VISAPERMITSTATUSDATE 
				      )
		SELECT   pt_i_MigrationSetID                               
                ,pt_i_MigrationSetName                               
                ,'EXTRACTED'  
                ,p_bg_name
                ,p_bg_id
				,effective_Start_Date
				,effective_end_Date
                ,employee_number
                ,to_number(person_id)
				,gvv_leg_code
				,NULL
				,EXPIRY_DATE
				,''
				,ISSUE_DATE
				,''
				,''
				,''
				,''
				,VISA_CATEGORY
				,VISA_NUMBER
				,''
				,''
        FROM (SELECT 
					 papf.employee_number
					,pei.Person_id
					,papf.effective_Start_Date
					,papf.effective_end_Date
					,PEI.information_type
					,(SELECT EXPORT_DFF_SEGMENT_VAL 
												(pei.person_id
												,pei.PEI_INFORMATION_CATEGORY
												,'person_id'
												,'PEI_INFORMATION_CATEGORY'
												,'PER_PEOPLE_EXTRA_INFO'
												,att.application_column_name)
					FROM apps.fnd_descriptive_flexs_vl@MXDM_NVIS_EXTRACT ffv,
						apps.fnd_descr_flex_contexts_vl@MXDM_NVIS_EXTRACT ffc,
						apps.fnd_descr_flex_col_usage_vl@MXDM_NVIS_EXTRACT att,
						apps.fnd_flex_value_sets@MXDM_NVIS_EXTRACT fvs,
						apps.fnd_application_vl@MXDM_NVIS_EXTRACT ap
					WHERE ffv.descriptive_flexfield_name = att.descriptive_flexfield_name
					AND ap.application_id=ffv.application_id
					AND ffv.descriptive_flexfield_name = ffc.descriptive_flexfield_name
					AND ffv.application_id = ffc.application_id
					AND ffc.descriptive_flex_context_code=att.descriptive_flex_context_code
					AND fvs.flex_value_set_id=att.flex_value_set_id
					AND ffv.title like 'Extra Person Information'
					AND ffc.descriptive_flex_context_code = pei.PEI_INFORMATION_CATEGORY
					and UPPER(att.form_left_prompt) like 'VISA%NUMBER')"VISA_NUMBER"
					,(SELECT EXPORT_DFF_SEGMENT_VAL 
												(pei.person_id
												,pei.PEI_INFORMATION_CATEGORY
												,'person_id'
												,'PEI_INFORMATION_CATEGORY'
												,'PER_PEOPLE_EXTRA_INFO'
												,att.application_column_name)
					FROM apps.fnd_descriptive_flexs_vl@MXDM_NVIS_EXTRACT ffv,
						apps.fnd_descr_flex_contexts_vl@MXDM_NVIS_EXTRACT ffc,
						apps.fnd_descr_flex_col_usage_vl@MXDM_NVIS_EXTRACT att,
						apps.fnd_flex_value_sets@MXDM_NVIS_EXTRACT fvs,
						apps.fnd_application_vl@MXDM_NVIS_EXTRACT ap
					WHERE ffv.descriptive_flexfield_name = att.descriptive_flexfield_name
					AND ap.application_id=ffv.application_id
					AND ffv.descriptive_flexfield_name = ffc.descriptive_flexfield_name
					AND ffv.application_id = ffc.application_id
					AND ffc.descriptive_flex_context_code=att.descriptive_flex_context_code
					AND fvs.flex_value_set_id=att.flex_value_set_id
					AND ffv.title like 'Extra Person Information'
					AND ffc.descriptive_flex_context_code = pei.PEI_INFORMATION_CATEGORY
					and UPPER(att.form_left_prompt) LIKE  'VISA%TYPE') "VISA_TYPE"
					,(SELECT EXPORT_DFF_SEGMENT_VAL 
												(pei.person_id
												,pei.PEI_INFORMATION_CATEGORY
												,'person_id'
												,'PEI_INFORMATION_CATEGORY'
												,'PER_PEOPLE_EXTRA_INFO'
												,att.application_column_name)
					FROM apps.fnd_descriptive_flexs_vl@MXDM_NVIS_EXTRACT ffv,
						apps.fnd_descr_flex_contexts_vl@MXDM_NVIS_EXTRACT ffc,
						apps.fnd_descr_flex_col_usage_vl@MXDM_NVIS_EXTRACT att,
						apps.fnd_flex_value_sets@MXDM_NVIS_EXTRACT fvs,
						apps.fnd_application_vl@MXDM_NVIS_EXTRACT ap
					WHERE ffv.descriptive_flexfield_name = att.descriptive_flexfield_name
					AND ap.application_id=ffv.application_id
					AND ffv.descriptive_flexfield_name = ffc.descriptive_flexfield_name
					AND ffv.application_id = ffc.application_id
					AND ffc.descriptive_flex_context_code=att.descriptive_flex_context_code
					AND fvs.flex_value_set_id=att.flex_value_set_id
					AND ffv.title like 'Extra Person Information'
					AND ffc.descriptive_flex_context_code = pei.PEI_INFORMATION_CATEGORY
					and UPPER(att.form_left_prompt) LIKE 'EXPIRY%DATE') "EXPIRY_DATE"
					,(SELECT EXPORT_DFF_SEGMENT_VAL 
												(pei.person_id
												,pei.PEI_INFORMATION_CATEGORY
												,'person_id'
                                                ,'PEI_INFORMATION_CATEGORY'
												,'PER_PEOPLE_EXTRA_INFO'
												,att.application_column_name)
					FROM apps.fnd_descriptive_flexs_vl@MXDM_NVIS_EXTRACT ffv,
						apps.fnd_descr_flex_contexts_vl@MXDM_NVIS_EXTRACT ffc,
						apps.fnd_descr_flex_col_usage_vl@MXDM_NVIS_EXTRACT att,
						apps.fnd_flex_value_sets@MXDM_NVIS_EXTRACT fvs,
						apps.fnd_application_vl@MXDM_NVIS_EXTRACT ap
					WHERE ffv.descriptive_flexfield_name = att.descriptive_flexfield_name
					AND ap.application_id=ffv.application_id
					AND ffv.descriptive_flexfield_name = ffc.descriptive_flexfield_name
					AND ffv.application_id = ffc.application_id
					AND ffc.descriptive_flex_context_code=att.descriptive_flex_context_code
					AND fvs.flex_value_set_id=att.flex_value_set_id
					AND ffv.title like 'Extra Person Information'
					AND ffc.descriptive_flex_context_code = pei.PEI_INFORMATION_CATEGORY
					and UPPER(att.form_left_prompt) like  '%ISSUE%DATE')	"ISSUE_DATE"
					,(SELECT EXPORT_DFF_SEGMENT_VAL 
												(pei.person_id
												,pei.PEI_INFORMATION_CATEGORY
												,'person_id'
												,'PEI_INFORMATION_CATEGORY'
												,'PER_PEOPLE_EXTRA_INFO'
												,att.application_column_name)
					FROM apps.fnd_descriptive_flexs_vl@MXDM_NVIS_EXTRACT ffv,
						apps.fnd_descr_flex_contexts_vl@MXDM_NVIS_EXTRACT ffc,
						apps.fnd_descr_flex_col_usage_vl@MXDM_NVIS_EXTRACT att,
						apps.fnd_flex_value_sets@MXDM_NVIS_EXTRACT fvs,
						apps.fnd_application_vl@MXDM_NVIS_EXTRACT ap
					WHERE ffv.descriptive_flexfield_name = att.descriptive_flexfield_name
					AND ap.application_id=ffv.application_id
					AND ffv.descriptive_flexfield_name = ffc.descriptive_flexfield_name
					AND ffv.application_id = ffc.application_id
					AND ffc.descriptive_flex_context_code=att.descriptive_flex_context_code
					AND fvs.flex_value_set_id=att.flex_value_set_id
					AND ffv.title like 'Extra Person Information'
					AND ffc.descriptive_flex_context_code = pei.PEI_INFORMATION_CATEGORY
					and UPPER(att.form_left_prompt) like  '%VISA%CATEGORY') "VISA_CATEGORY"
					,(SELECT EXPORT_DFF_SEGMENT_VAL 
												(pei.person_id
												,pei.PEI_INFORMATION_CATEGORY
												,'person_id'
												,'PEI_INFORMATION_CATEGORY'
												,'PER_PEOPLE_EXTRA_INFO'
												,att.application_column_name)
					FROM apps.fnd_descriptive_flexs_vl@MXDM_NVIS_EXTRACT ffv,
						apps.fnd_descr_flex_contexts_vl@MXDM_NVIS_EXTRACT ffc,
						apps.fnd_descr_flex_col_usage_vl@MXDM_NVIS_EXTRACT att,
						apps.fnd_flex_value_sets@MXDM_NVIS_EXTRACT fvs,
						apps.fnd_application_vl@MXDM_NVIS_EXTRACT ap
					WHERE ffv.descriptive_flexfield_name = att.descriptive_flexfield_name
					AND ap.application_id=ffv.application_id
					AND ffv.descriptive_flexfield_name = ffc.descriptive_flexfield_name
					AND ffv.application_id = ffc.application_id
					AND ffc.descriptive_flex_context_code=att.descriptive_flex_context_code
					AND fvs.flex_value_set_id=att.flex_value_set_id
					AND ffv.title like 'Extra Person Information'
					AND ffc.descriptive_flex_context_code = pei.PEI_INFORMATION_CATEGORY
					and UPPER(att.form_left_prompt) LIKE 'CURRENT%VISA')		"CURRENT_VISA"
			  FROM PER_PEOPLE_EXTRA_INFO@MXDM_NVIS_EXTRACT pei,
				   per_All_people_f@MXDM_NVIS_EXTRACT papf
			  where papf.person_id = pei.person_id
		      and trunc(sysdate)between papf.effective_start_date and papf.effective_end_date
			  AND papf.business_group_id = p_bg_id
			  and pei.PEI_INFORMATION_CATEGORY like '%VISA%'                         
			  AND exists ( Select 1
					FROM xxmx_per_persons_stg xxper
					WHERE xxper.person_id = papf.person_id)        

			)
		;     
		--
		COMMIT;
        --
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
                        ,pt_i_ModuleMessage       => 'End of extraction at ' || to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS.FF2') || '. Procedure completed'
                ,pt_i_OracleError         => gvt_ReturnMessage       );     

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

    END export_per_visa;

    PROCEDURE export_per_citizenships
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          number
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_per_citizenships'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_CITIZENSHIPS_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'PER_CITIZENSHIPS';

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
         Set_parameters(p_bg_id);
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
        FROM    xxmx_citizenships_stg    
        WHERE   bg_id    = p_bg_id    ;

        COMMIT;

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
                ,pt_i_ModuleMessage       => 'Deleting from " xxmx_per_documentation_stg' || cv_StagingTable   || '".'
                ,pt_i_OracleError         => gvt_ReturnMessage  );
        --   
        DELETE 
        FROM    xxmx_per_documentation_stg    
        WHERE   bg_id    = p_bg_id    ;

        COMMIT;
        --
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
        --   
        INSERT  
        INTO    xxmx_citizenships_stg
                (migration_set_id
                ,migration_set_name                   
                ,migration_status
                ,bg_name
                ,bg_id
                ,date_from
                ,date_to
                ,person_id
                ,legislation_code
                ,citizenship_status
                ,citizenship_id
				,personnumber)
        SELECT   pt_i_MigrationSetID                               
                ,pt_i_MigrationSetName                               
                ,'EXTRACTED'  
                ,p_bg_name
                ,p_bg_id
                ,per_all_people_f.effective_start_date 
                , per_All_people_f.effective_end_date date_to
                ,per_all_people_f.person_id person_id
                --,per_all_people_f.nationality legislation_code
				-- Changed to get only 2 char Legislation_code by Pallavi  17NOV
				,SUBSTR(per_all_people_f.nationality,INSTR( per_all_people_f.nationality,'_',-1)+1) legislation_code
                ,'A'
                ,person_id|| '_CITIZENSHIP' 
				,employee_number
		FROM    per_all_people_f@MXDM_NVIS_EXTRACT per_all_people_f
				,hr_all_organization_units@MXDM_NVIS_EXTRACT horg
		WHERE   per_all_people_f.effective_Start_Date IN    (SELECT max(effective_Start_Date)
                                                          FROM per_all_people_f@MXDM_NVIS_EXTRACT papf
                                                          WHERE papf.person_id = per_all_people_f.person_id
														  AND ((
																TRUNC(papf.effective_start_date) BETWEEN TRUNC(gvd_migration_date_from) AND TRUNC(gvd_migration_date_to)
															  )
															 OR 
															 (
																TRUNC(papf.effective_end_date) BETWEEN  TRUNC(gvd_migration_date_from) AND TRUNC(gvd_migration_date_to)
															 )														
															 OR  
															 (
																TRUNC(papf.effective_start_date)    < TRUNC(gvd_migration_date_from)
																AND TRUNC(papf.effective_end_date)  > TRUNC(gvd_migration_date_to)
														     ))
														)
		AND    	per_all_people_f.nationality IS NOT NULL
		AND   horg.organization_id = per_all_people_f.business_group_id
		AND     horg.name = p_bg_name
		AND exists ( Select 1
					FROM xxmx_per_persons_stg xxper
					WHERE xxper.person_id = per_all_people_f.person_id)

        ;
        --
        gvv_ProgressIndicator := '0050';
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
                ,pt_i_ModuleMessage       => 'Extracting data into "xxmx_per_documentation_stg".'   
                        ,pt_i_OracleError         => gvt_ReturnMessage       );
        --
        INSERT  
        INTO    xxmx_per_documentation_stg
                (migration_set_id
                ,migration_set_name                   
                ,migration_status
                ,bg_name
                ,bg_id
                ,person_id,
                personnumber)
        SELECT  DISTINCT
                NULL
                ,NULL
                ,NULL
                ,p_bg_name
                ,p_bg_id
                ,xxmx_citizenships_stg.person_id
                ,xxmx_citizenships_stg.personnumber
        FROM    xxmx_citizenships_stg xxmx_citizenships_stg
            ,xxmx_per_persons_stg xxmx_per_persons_stg
        WHERE   xxmx_citizenships_stg.person_id = xxmx_per_persons_stg.person_id;
        --
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
                        ,pt_i_ModuleMessage       => 'End of extraction at ' || to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS.FF2') || '. Procedure completed'
                        ,pt_i_OracleError         => gvt_ReturnMessage       );     

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

    END export_per_citizenships;

    PROCEDURE export_profile_items_1
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          number
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_profile_items_1'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'xxmx_hrt_pfl_items_stg';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'PROFILE_ITEMS_1';

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
        FROM    xxmx_hrt_pfl_items_stg
        WHERE      bg_id    = p_bg_id    ;

        COMMIT;        
        --
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
        --   
        INSERT  
        INTO    xxmx_hrt_pfl_items_stg
                (migration_set_id
                ,migration_set_name                   
                ,migration_status
                ,bg_name
                ,bg_id
                ,profile_id
                ,content_type_id
                ,content_item_id
                ,date_from
                ,date_to
                ,rating_model_id1
                ,rating_level_id1
                ,mandatory
                ,importance
                ,item_text2000_1
                ,item_number_2
                ,qualifier_id1
                ,profile_item_id)
        SELECT   pt_i_MigrationSetID                               
                ,pt_i_MigrationSetName                               
                ,'EXTRACTED'  
                ,p_bg_name
                ,p_bg_id
                , xxmx_extract_hrt_profiles_b.profile_id profile_id
                ,gvv_cmp_cnt_typ content_type_id
                ,xxmx_hrt_cnt_items_b_stg.content_item_id content_item_id
                ,c26_date_from date_from
                ,c3_date_to date_to
                ,xxmx_hrt_cnt_items_b_stg.rating_model_id rating_model_id1
                ,xxmx_hrt_rating_lvl_b_stg.rating_level_id rating_level_id1
                ,c24_mandatory mandatory
                ,2 importance
                ,c29_item_text2000_1 item_text2000_1
                ,c14_item_number_2 item_number_2
                ,gvv_comp_qualifier qualifier_id1
                ,s0_competence_element_id
                || '_PROFILE_ITEM' profile_item_id
        FROM    xxmx_hrt_cnt_items_b_stg xxmx_hrt_cnt_items_b_stg
                ,xxmx_hrt_rating_lvl_b_stg xxmx_hrt_rating_lvl_b_stg
                ,xxmx_hrt_profile_b_stg xxmx_extract_hrt_profiles_b
                ,xxmx_per_persons_stg xxmx_per_persons_stg
                ,
                (
                SELECT  per_competence_elements.effective_date_to c3_date_to
                    ,to_number (to_char (per_competence_elements.achieved_date
                                        ,'YYYY')) c14_item_number_2
                    ,decode (per_competence_elements.mandatory
                            ,'Y'
                            ,'true'
                            ,'false') c24_mandatory
                    ,per_competence_elements.effective_date_from c26_date_from
                    ,per_competence_elements.comments c29_item_text2000_1
                    ,per_competence_elements.competence_id c53_competence_id
                    ,per_competence_elements.proficiency_level_id c54_proficiency_level_id
                    ,per_competence_elements.person_id c55_person_id
                    ,per_competence_elements.competence_element_id s0_competence_element_id
                FROM    per_competence_elements@MXDM_NVIS_EXTRACT per_competence_elements
                    ,hr_all_organization_units@MXDM_NVIS_EXTRACT horg
                WHERE   (
                                (
                                        (
                                                per_competence_elements.person_id IS NOT NULL
                                        )
                                AND     (
                                                per_competence_elements.type = 'PERSONAL'
                                        )
                                )
                        )
                AND     (
                                horg.organization_id = per_competence_elements.business_group_id
                        AND     horg.name = p_bg_name
                        )
                ) c_hrt_profile_items
        WHERE   (
                        xxmx_hrt_cnt_items_b_stg.content_item_id = c53_competence_id
                                                                || '_CMP_CNT_ITEM'
                )
        AND     (
                        xxmx_hrt_rating_lvl_b_stg.rating_level_id (+) = c54_proficiency_level_id
                                                                    || '_RATING_LEVEL'
                )
        AND     (
                        xxmx_per_persons_stg.person_id = xxmx_extract_hrt_profiles_b.person_id
                )
        AND     (
                        xxmx_per_persons_stg.person_id = c55_person_id
                )
        ;
        --
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
                        ,pt_i_ModuleMessage       => 'End of extraction at ' || to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS.FF2') || '. Procedure completed'
                ,pt_i_OracleError         => gvt_ReturnMessage       );     

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

    END export_profile_items_1;

    PROCEDURE export_profile_items_qual_1
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          number
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_profile_items_qual_1'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'xxmx_hrt_pfl_items_stg';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'PROFILE_ITEMS_QUAL_1';

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
        --   
        INSERT  
        INTO    xxmx_hrt_pfl_items_stg
                (migration_set_id
                ,migration_set_name                   
                ,migration_status
                ,bg_name
                ,bg_id
                ,profile_id
                ,content_type_id
                ,content_item_id
                ,date_from
                ,date_to
                ,importance
                ,item_text240_2
                ,item_text240_4
                ,item_date_6
                ,profile_item_id
                ,title)
        SELECT   pt_i_MigrationSetID                               
                ,pt_i_MigrationSetName                               
                ,'EXTRACTED'  
                ,p_bg_name
                ,p_bg_id
                ,per_ri_ig_profiles_b_per.profile_id profile_id
                ,gvv_cert_cnt_typ content_type_id
                ,per_ri_ig_hrt_cntitem_qual.content_item_id content_item_id
                ,nvl (c51_start_date
                        ,to_date ('01-01-1900'
                                ,'DD-MM-YYYY')) date_from
                ,c5_date_to date_to
                ,2 importance
                ,c2_item_text240_2 item_text240_2
                ,c4_item_text240_4 item_text240_4
                ,c26_item_date_6 item_date_6
                ,c_hrt_profile_items.s0_qualification_id
                    || '_ITEM'
                , title
        FROM    xxmx_hrt_cnt_items_b_stg per_ri_ig_hrt_cntitem_qual
                ,xxmx_hrt_profile_b_stg per_ri_ig_profiles_b_per
                ,xxmx_per_persons_stg per_ri_ig_persons
                ,
                (
                SELECT  'MAXIMISE' c1_last_updated_by
                    ,per_qualifications.license_number c2_item_text240_2
                    ,per_qualifications.qua_information_category c3_information_category
                    ,per_qualifications_tl.awarding_body c4_item_text240_4
                    ,per_qualifications.end_date c5_date_to
                    ,per_qualifications.awarded_date c26_item_date_6
                    ,per_qualifications.title
                    ,per_establishment_attendances.person_id c54_person_id
                    ,per_qualification_types.category c57_category
                    ,get_content_type_id (per_qualification_types.category) s0_category
                    ,per_qualifications.person_id c52_person_id
                    ,per_qualifications.start_date c51_start_date
                    ,per_qualifications.qualification_type_id c56_qualification_type_id
                    ,per_qualifications.attendance_id c53_attendance_id
                    ,per_qualifications.qualification_id s0_qualification_id
                FROM    per_qualifications_tl@MXDM_NVIS_EXTRACT per_qualifications_tl
                    ,per_establishment_attendances@MXDM_NVIS_EXTRACT per_establishment_attendances
                    ,per_qualifications@MXDM_NVIS_EXTRACT per_qualifications
                    ,per_qualification_types@MXDM_NVIS_EXTRACT per_qualification_types
                    ,hr_all_organization_units@MXDM_NVIS_EXTRACT horg
                WHERE   (
                                per_qualifications_tl.language = 'US'
                        )
                AND     (
                                per_qualifications.qualification_type_id = per_qualification_types.qualification_type_id
                        )
                AND     (
                                per_qualifications.attendance_id = per_establishment_attendances.attendance_id
                        )
                AND     (
                                per_qualifications.qualification_id = per_qualifications_tl.qualification_id
                        )
                AND     (
                                horg.organization_id = per_establishment_attendances.business_group_id
                        AND     horg.name = p_bg_name
                        )
                AND     get_content_type_id (per_qualification_types.category) = 'CERTIFICATION'
                ) c_hrt_profile_items
        WHERE   (
                        per_ri_ig_persons.person_id = c54_person_id
                )
        AND     (
                        per_ri_ig_hrt_cntitem_qual.content_item_id = c56_qualification_type_id
                                                                    || '_QUAL_CNT_ITEM'
                )
        AND     (
                        per_ri_ig_profiles_b_per.person_id = per_ri_ig_persons.person_id
                )
        ;
        --
        gvv_ProgressIndicator := '0030';
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
                ,pt_i_ModuleMessage       => 'Extracting data into "xxmx_hrt_pfl_items_stg".'   
                        ,pt_i_OracleError         => gvt_ReturnMessage       );
        --
        INSERT  
        INTO    xxmx_hrt_pfl_items_stg
                (migration_set_id
                ,migration_set_name                   
                ,migration_status
                ,bg_name
                ,bg_id
                ,profile_id
                ,content_type_id
                ,content_item_id
                ,date_from
                ,date_to
                ,importance
                ,item_text240_2
                ,item_text240_4
                ,item_date_6
                ,profile_item_id
                ,title)
        SELECT   pt_i_MigrationSetID                               
                ,pt_i_MigrationSetName                               
                ,'EXTRACTED'  
                ,p_bg_name
                ,p_bg_id
                ,per_ri_ig_profiles_b_per.profile_id profile_id
                ,gvv_cert_cnt_typ content_type_id
                ,per_ri_ig_hrt_cntitem_qual.content_item_id content_item_id
                ,nvl (c51_start_date
                        ,to_date ('01-01-1900'
                                ,'DD-MM-YYYY')) date_from
                ,c5_date_to date_to
                ,2 importance
                ,c2_item_text240_2 item_text240_2
                ,c4_item_text240_4 item_text240_4
                ,c26_item_date_6 item_date_6
                ,s0_qualification_id
                    || '_ITEM'
                ,title
        FROM    xxmx_hrt_cnt_items_b_stg per_ri_ig_hrt_cntitem_qual
                ,xxmx_hrt_profile_b_stg per_ri_ig_profiles_b_per
                ,xxmx_per_persons_stg per_ri_ig_persons
                ,
                (
                SELECT  'MAXIMISE' c1_last_updated_by
                    ,per_qualifications.license_number c2_item_text240_2
                    ,per_qualifications.qua_information_category c3_information_category
                    ,per_qualifications_tl.awarding_body c4_item_text240_4
                    ,per_qualifications.end_date c5_date_to
                    ,per_qualifications.awarded_date c26_item_date_6
                    ,per_qualification_types.category c57_category
                    ,fvl.meaning s0_category
                    ,per_qualifications.person_id c52_person_id
                    ,per_qualifications.start_date c51_start_date
                    ,per_qualifications.qualification_type_id c56_qualification_type_id
                    ,per_qualifications.attendance_id c53_attendance_id
                    ,per_qualifications.qualification_id s0_qualification_id
                    ,per_qualifications.title
                FROM    per_qualifications_tl@MXDM_NVIS_EXTRACT per_qualifications_tl
                    ,per_qualifications@MXDM_NVIS_EXTRACT per_qualifications
                    ,per_qualification_types@MXDM_NVIS_EXTRACT per_qualification_types
                    , fnd_lookup_values@MXDM_NVIS_EXTRACT fvl
                WHERE  per_qualifications_tl.language = 'US'
				AND per_qualifications.qualification_type_id = per_qualification_types.qualification_type_id
                AND per_qualifications.attendance_id IS NULL
                AND per_qualifications.qualification_id = per_qualifications_tl.qualification_id
                AND per_qualifications.business_group_id= p_bg_id

                --AND     get_content_type_id (per_qualification_types.category) = 'CERTIFICATION'
				AND lookup_type = 'PER_CATEGORIES'
				and lookup_code = per_qualification_types.category
				and meaning = 'Certificate'
                ) c_hrt_profile_items
        WHERE   (
                        per_ri_ig_persons.person_id = c52_person_id
                )
        AND     (
                        per_ri_ig_hrt_cntitem_qual.content_item_id = c56_qualification_type_id
                                                                    || '_QUAL_CNT_ITEM'
                )
        AND     (
                        per_ri_ig_profiles_b_per.person_id = per_ri_ig_persons.person_id
                )
        ;
        --
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
                        ,pt_i_ModuleMessage       => 'End of extraction at ' || to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS.FF2') || '. Procedure completed'
                ,pt_i_OracleError         => gvt_ReturnMessage       );     

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

    END export_profile_items_qual_1;

    PROCEDURE export_profile_items_qual_2
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          number
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_profile_items_qual_2'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'xxmx_hrt_pfl_items_stg';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'PROFILE_ITEMS_QUAL_2';

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
        --   
        INSERT  
        INTO    xxmx_hrt_pfl_items_stg
                (migration_set_id
                ,migration_set_name                   
                ,migration_status
                ,bg_name
                ,bg_id
                ,profile_id
                ,content_type_id
                ,content_item_id
                ,date_from
                ,date_to
                ,importance
                ,item_text2000_1
                ,item_text30_1
                ,item_date_6
                ,item_number_8
                ,item_number_9_guid
                ,item_text240_1
                ,profile_item_id)
        SELECT   pt_i_MigrationSetID                               
                ,pt_i_MigrationSetName                               
                ,'EXTRACTED'  
                ,p_bg_name
                ,p_bg_id
                ,per_ri_ig_profiles_b_per.profile_id profile_id
                ,gvv_deg_cnt_typ content_type_id
                ,per_ri_ig_hrt_cntitem_qual.content_item_id content_item_id
                ,nvl (c50_start_date
                        ,to_date ('01-01-1900'
                                ,'DD-MM-YYYY')) date_from
                ,c3_date_to date_to
                ,2 importance
                ,c_hrt_profile_items.c27_item_text2000_1 item_text2000_1
                ,nvl2 (c24_item_date_6
                        ,(CASE
                        WHEN    c24_item_date_6 > trunc (sysdate)
                                THEN    'N'
                        WHEN    c24_item_date_6 < trunc (sysdate)
                                THEN    'Y'
                        ELSE    'N' END)
                        ,'N') item_text30_1
                ,c24_item_date_6 item_date_6
                ,decode (nvl (c24_item_date_6
                                ,sysdate)
                        ,sysdate
                        ,NULL
                        ,to_number (to_char (c24_item_date_6
                                            ,'YYYY'))) item_number_8
                ,per_ri_ig_establishments_b.establishment_id item_number_9_guid
                ,c57_title item_text240_1
                ,s0_qualification_id
                    || '_ITEM'
        FROM    xxmx_hrt_cnt_items_b_stg per_ri_ig_hrt_cntitem_qual
            ,xxmx_hrt_estb_b_stg per_ri_ig_establishments_b
            ,xxmx_hrt_profile_b_stg per_ri_ig_profiles_b_per
            ,xxmx_per_persons_stg per_ri_ig_persons
            ,
                (
                SELECT  'MAXIMISE' c1_last_updated_by
                    ,per_qualifications.qua_information_category c2_information_category
                    ,per_qualifications.end_date c3_date_to
                    ,per_qualifications.awarded_date c24_item_date_6
                    ,per_establishment_attendances.establishment c27_item_text2000_1
                    ,per_establishment_attendances.person_id c51_person_id
                    ,per_qualification_types.category c57_category
                    ,per_qualifications.person_id c53_person_id
                    ,per_establishment_attendances.establishment_id c56_establishment_id
                    ,per_qualifications.start_date c50_start_date
                    ,per_qualifications.qualification_type_id c55_qualification_type_id
                    ,per_qualifications.attendance_id c52_attendance_id
                    ,per_qualifications.qualification_id s0_qualification_id
                    ,per_qualifications.title c57_title
                FROM    per_qualifications_tl@MXDM_NVIS_EXTRACT per_qualifications_tl
                    ,per_establishment_attendances@MXDM_NVIS_EXTRACT per_establishment_attendances
                    ,per_qualifications@MXDM_NVIS_EXTRACT per_qualifications
                    ,per_qualification_types@MXDM_NVIS_EXTRACT per_qualification_types
                    ,hr_all_organization_units@MXDM_NVIS_EXTRACT horg
                WHERE   (
                                per_qualifications_tl.language = 'US'
                        )
                AND     (
                                per_qualifications.qualification_type_id = per_qualification_types.qualification_type_id
                        )
                AND     (
                                per_qualifications.attendance_id = per_establishment_attendances.attendance_id
                        )
                AND     (
                                per_qualifications.qualification_id = per_qualifications_tl.qualification_id
                        )
                AND     (
                                horg.organization_id = per_establishment_attendances.business_group_id
                        AND     horg.name = p_bg_name
                        )
                AND     get_content_type_id (per_qualification_types.category) = 'DEGREE'
                ) c_hrt_profile_items
        WHERE   (
                        per_ri_ig_persons.person_id = c51_person_id
                )
        AND     (
                        per_ri_ig_hrt_cntitem_qual.content_item_id = c55_qualification_type_id
                                                                    || '_QUAL_CNT_ITEM'
                )
        AND     (
                        per_ri_ig_establishments_b.establishment_id (+) = c56_establishment_id
                                                                        || '_ESTABLISHMENT'
                )
        AND     (
                        per_ri_ig_profiles_b_per.person_id = per_ri_ig_persons.person_id
                )
        ;
        --
        gvv_ProgressIndicator := '0030';
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
                        ,pt_i_ModuleMessage       => 'Extracting data into "xxmx_hrt_pfl_items_stg".'   
                        ,pt_i_OracleError         => gvt_ReturnMessage       );

        INSERT  
        INTO    xxmx_hrt_pfl_items_stg
                (migration_set_id
                ,migration_set_name                   
                ,migration_status
                ,bg_name
                ,bg_id
                ,profile_id
                ,content_type_id
                ,content_item_id
                ,date_from
                ,date_to
                ,importance
                ,item_text2000_1
                ,item_text30_1
                ,item_date_6
                ,item_number_8
                ,item_number_9
                ,item_text240_1
                ,profile_item_id
                ,title)
        SELECT   pt_i_MigrationSetID                               
                ,pt_i_MigrationSetName                               
                ,'EXTRACTED'  
                ,p_bg_name
                ,p_bg_id
                ,per_ri_ig_profiles_b_per.profile_id profile_id
                ,gvv_deg_cnt_typ content_type_id
                ,per_ri_ig_hrt_cntitem_qual.content_item_id content_item_id
                ,nvl (c50_start_date
                        ,to_date ('01-01-1900'
                                ,'DD-MM-YYYY')) date_from
                ,c3_date_to date_to
                ,2 importance
                ,c27_item_text2000_1 item_text2000_1
                ,nvl2 (c24_item_date_6
                        ,(CASE
                        WHEN    c24_item_date_6 > trunc (sysdate)
                                THEN    'N'
                        WHEN    c24_item_date_6 < trunc (sysdate)
                                THEN    'Y'
                        ELSE    'N' END)
                        ,'N') item_text30_1
                ,c24_item_date_6 item_date_6
                ,decode (nvl (c24_item_date_6
                                ,sysdate)
                        ,sysdate
                        ,NULL
                        ,to_number (to_char (c24_item_date_6
                                            ,'YYYY'))) item_number_8
                ,NULL item_number_9
                ,c57_title item_text240_1
                ,s0_qualification_id
                    || '_ITEM'
                    ,title
        FROM    xxmx_hrt_cnt_items_b_stg per_ri_ig_hrt_cntitem_qual
                ,xxmx_hrt_profile_b_stg per_ri_ig_profiles_b_per
                ,xxmx_per_persons_stg per_ri_ig_persons
                ,
                (
                SELECT  per_qualifications.qua_information_category c2_information_category
                    ,per_qualifications.end_date c3_date_to
                    ,per_qualifications.awarded_date c24_item_date_6
                    ,fvl.meaning c57_category
                    ,per_qualifications.person_id c53_person_id
                    ,NULL c27_item_text2000_1
                    ,per_qualifications.start_date c50_start_date
                    ,per_qualifications.qualification_type_id c55_qualification_type_id
                    ,per_qualifications.attendance_id c52_attendance_id
                    ,per_qualifications.title c57_title
                    ,per_qualifications.qualification_id s0_qualification_id
                    ,per_qualifications.title
                FROM    per_qualifications_tl@MXDM_NVIS_EXTRACT per_qualifications_tl
                    ,per_qualifications@MXDM_NVIS_EXTRACT per_qualifications
                    ,per_qualification_types@MXDM_NVIS_EXTRACT per_qualification_types
                    , fnd_lookup_values@MXDM_NVIS_EXTRACT fvl
                WHERE per_qualifications_tl.language = 'US'
                AND  per_qualifications.qualification_type_id = per_qualification_types.qualification_type_id
                AND  per_qualifications.attendance_id IS NULL
                AND  per_qualifications.qualification_id = per_qualifications_tl.qualification_id
                AND   per_qualifications.business_group_id = p_bg_id
               -- AND     get_content_type_id (per_qualification_types.category) = 'DEGREE'
				AND lookup_type = 'PER_CATEGORIES'
				and lookup_code = per_qualification_types.category
				and UPPER(meaning) = 'DEGREE'
                ) c_hrt_profile_items
        WHERE   (
                        per_ri_ig_persons.person_id = c53_person_id

                )
        AND     (
                        per_ri_ig_hrt_cntitem_qual.content_item_id = c55_qualification_type_id
                                                                    || '_QUAL_CNT_ITEM'
                )
        AND     (
                        per_ri_ig_profiles_b_per.person_id = per_ri_ig_persons.person_id
                )
        ;
        --
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
                        ,pt_i_ModuleMessage       => 'End of extraction at ' || to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS.FF2') || '. Procedure completed'
                ,pt_i_OracleError         => gvt_ReturnMessage       );     

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

    END export_profile_items_qual_2;

    PROCEDURE export_profile_items_qual_3
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          number
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_profile_items_qual_3'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'xxmx_hrt_pfl_items_stg';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'PROFILE_ITEMS_QUAL_3';

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
        --   
        INSERT  
        INTO    xxmx_hrt_pfl_items_stg
                (migration_set_id
                ,migration_set_name                   
                ,migration_status
                ,bg_name
                ,bg_id
                ,profile_id
                ,content_type_id
                ,content_item_id
                ,date_from
                ,date_to
                ,importance
                ,item_text240_4
                ,item_date_3
                ,item_date_6
                ,item_number_9_guid
                ,item_text2000_1
                ,item_text240_6
                ,item_text30_1
                ,profile_item_id
                ,title)
        SELECT   pt_i_MigrationSetID                               
                ,pt_i_MigrationSetName                               
                ,'EXTRACTED'  
                ,p_bg_name
                ,p_bg_id
                , per_ri_ig_profiles_b_per.profile_id profile_id
                ,decode (c56_category
                        ,'HONOR'
                        ,gvv_hon_cnt_typ
                        ,gvv_ed_lvl_cnt_typ) content_type_id
                ,per_ri_ig_hrt_cntitem_qual.content_item_id content_item_id
                ,nvl (c50_start_date
                        ,to_date ('01-01-1900'
                                ,'DD-MM-YYYY')) date_from
                ,c4_date_to date_to
                ,2 importance
                ,decode (c56_category
                        ,'HONOR'
                        ,c3_item_text240_4
                        ,NULL) item_text240_4
                ,decode (c56_category
                        ,'HONOR'
                        ,c25_item_date_3
                        ,NULL) item_date_3
                ,decode (c56_category
                        ,'HONOR'
                        ,nvl (c62_expiry_date
                                ,to_date ('31-12-4712'
                                        ,'DD-MM-YYYY'))
                        ,NULL) item_date_6
                ,decode (c56_category
                        ,'EDUCATION_LEVEL'
                        ,per_ri_ig_establishments_b.establishment_id
                        ,NULL) item_number_9_guid
                ,decode (c56_category
                        ,'EDUCATION_LEVEL'
                        ,c57_item_text2000_1
                        ,NULL) item_text2000_1
                ,decode (c56_category
                        ,'EDUCATION_LEVEL'
                        ,c58_grade_attained
                        ,NULL) item_text240_6
                ,decode (c56_category
                        ,'EDUCATION_LEVEL'
                        ,(nvl2 (c25_item_date_3
                                ,(CASE
                                WHEN    c25_item_date_3 > trunc (sysdate)
                                        THEN    'N'
                                WHEN    c25_item_date_3 < trunc (sysdate)
                                        THEN    'Y'
                                ELSE    'N' END)
                                ,'N'))
                        ,NULL) item_text30_1
                ,s0_qualification_id
                    || '_ITEM'
                    ,title
        FROM    xxmx_hrt_cnt_items_b_stg per_ri_ig_hrt_cntitem_qual
                ,xxmx_hrt_profile_b_stg per_ri_ig_profiles_b_per
                ,xxmx_per_persons_stg per_ri_ig_persons
                ,xxmx_hrt_estb_b_stg per_ri_ig_establishments_b
                ,
                (
                SELECT  'MAXIMISE' c1_last_updated_by
                    ,per_qualifications.qua_information_category c2_information_category
                    ,per_qualifications_tl.awarding_body c3_item_text240_4
                    ,per_qualifications.end_date c4_date_to
                    ,per_qualifications.awarded_date c25_item_date_3
                    ,per_establishment_attendances.person_id c51_person_id
                    ,per_establishment_attendances.establishment_id c56_establishment_id
                    ,per_establishment_attendances.establishment c57_item_text2000_1
                    ,get_content_type_id (per_qualification_types.category) c56_category
                    ,per_qualifications.person_id c53_person_id
                    ,per_qualifications.start_date c50_start_date
                    ,per_qualifications.qualification_type_id c55_qualification_type_id
                    ,per_qualifications.attendance_id c52_attendance_id
                    ,per_qualifications.grade_attained c58_grade_attained
                    ,per_qualifications.expiry_date c62_expiry_date
                    ,per_qualifications.qualification_id s0_qualification_id
                    ,per_qualifications.title
                FROM    per_qualifications_tl@MXDM_NVIS_EXTRACT per_qualifications_tl
                    ,per_establishment_attendances@MXDM_NVIS_EXTRACT per_establishment_attendances
                    ,per_qualifications@MXDM_NVIS_EXTRACT per_qualifications
                    ,per_qualification_types@MXDM_NVIS_EXTRACT per_qualification_types
                    ,hr_all_organization_units@MXDM_NVIS_EXTRACT horg
                WHERE   (
                                per_qualifications_tl.language = 'US'
                        )
                AND     (
                                per_qualifications.qualification_type_id = per_qualification_types.qualification_type_id
                        )
                AND     (
                                per_qualifications.attendance_id = per_establishment_attendances.attendance_id
                        )
                AND     (
                                per_qualifications.qualification_id = per_qualifications_tl.qualification_id
                        )
                AND     (
                                horg.organization_id = per_establishment_attendances.business_group_id
                        AND     horg.name = p_bg_name
                        )
                AND     (
                                get_content_type_id (per_qualification_types.category) IN( 'HONOR')
                        OR      get_content_type_id (per_qualification_types.category) = 'EDUCATION_LEVEL'
                        )
                ) c_hrt_profile_items
        WHERE   (
                        per_ri_ig_persons.person_id = c51_person_id
                )
        AND     (
                        per_ri_ig_hrt_cntitem_qual.content_item_id = c55_qualification_type_id
                                                                    || '_QUAL_CNT_ITEM'
                )
        AND     (
                        per_ri_ig_profiles_b_per.person_id = per_ri_ig_persons.person_id
                )
        AND     (
                        per_ri_ig_establishments_b.establishment_id (+) = c56_establishment_id
                                                                        || '_ESTABLISHMENT'
                )
        ;
        --
        gvv_ProgressIndicator := '0030';
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
                ,pt_i_ModuleMessage       => 'Extracting data into "xxmx_hrt_pfl_items_stg".'   
                        ,pt_i_OracleError         => gvt_ReturnMessage       );
        --
        INSERT  
        INTO    xxmx_hrt_pfl_items_stg
                (migration_set_id
                ,migration_set_name                   
                ,migration_status
                ,bg_name
                ,bg_id
                ,profile_id
                ,content_type_id
                ,content_item_id
                ,date_from
                ,date_to
                ,importance
                ,item_text240_4
                ,item_date_3
                ,item_date_6
                ,item_number_9
                ,item_text2000_1
                ,item_text240_6
                ,item_text30_1
                ,profile_item_id
                ,title)
        SELECT   pt_i_MigrationSetID                               
                ,pt_i_MigrationSetName                               
                ,'EXTRACTED'  
                ,p_bg_name
                ,p_bg_id
                , per_ri_ig_profiles_b_per.profile_id profile_id
                ,decode (c56_category
                        ,'HONOR'
                        ,gvv_hon_cnt_typ
                        ,gvv_ed_lvl_cnt_typ) content_type_id
                ,per_ri_ig_hrt_cntitem_qual.content_item_id content_item_id
                ,nvl (c50_start_date
                        ,to_date ('01-01-1900'
                                ,'DD-MM-YYYY')) date_from
                ,c4_date_to date_to
                ,2 importance
                ,decode (c56_category
                        ,'HONOR'
                        ,c3_item_text240_4
                        ,NULL) item_text240_4
                ,decode (c56_category
                        ,'HONOR'
                        ,c25_item_date_3
                        ,NULL) item_date_3
                ,decode (c56_category
                        ,'HONOR'
                        ,nvl (c62_expiry_date
                                ,to_date ('31-12-4712'
                                        ,'DD-MM-YYYY'))
                        ,NULL) item_date_6
                ,NULL item_number_9
                ,NULL item_text2000_1
                ,decode (c56_category
                        ,'EDUCATION_LEVEL'
                        ,c58_grade_attained
                        ,NULL) item_text240_6
                ,decode (c56_category
                        ,'EDUCATION_LEVEL'
                        ,(nvl2 (c25_item_date_3
                                ,(CASE
                                WHEN    c25_item_date_3 > trunc (sysdate)
                                        THEN    'N'
                                WHEN    c25_item_date_3 < trunc (sysdate)
                                        THEN    'Y'
                                ELSE    'N' END)
                                ,'N'))
                        ,NULL) item_text30_1
                ,s0_qualification_id
                    || '_ITEM'
                    ,title
        FROM    xxmx_hrt_cnt_items_b_stg per_ri_ig_hrt_cntitem_qual
                ,xxmx_hrt_profile_b_stg per_ri_ig_profiles_b_per
                ,xxmx_per_persons_stg per_ri_ig_persons
                ,
                (
                SELECT  'MAXIMISE' c1_last_updated_by
                    ,per_qualifications.qua_information_category c2_information_category
                    ,per_qualifications_tl.awarding_body c3_item_text240_4
                    ,per_qualifications.end_date c4_date_to
                    ,per_qualifications.awarded_date c25_item_date_3
                    ,fvl.meaning c56_category
                    ,per_qualifications.person_id c53_person_id
                    ,per_qualifications.start_date c50_start_date
                    ,per_qualifications.qualification_type_id c55_qualification_type_id
                    ,per_qualifications.attendance_id c52_attendance_id
                    ,per_qualifications.grade_attained c58_grade_attained
                    ,per_qualifications.expiry_date c62_expiry_date
                    ,per_qualifications.qualification_id s0_qualification_id
                    ,per_qualifications.title
                FROM    per_qualifications_tl@MXDM_NVIS_EXTRACT per_qualifications_tl
                    ,per_qualifications@MXDM_NVIS_EXTRACT per_qualifications
                    ,per_qualification_types@MXDM_NVIS_EXTRACT per_qualification_types
                    , fnd_lookup_values@MXDM_NVIS_EXTRACT fvl
                WHERE   (
                                per_qualifications_tl.language = 'US'
                        )
                AND     (
                                per_qualifications.qualification_type_id = per_qualification_types.qualification_type_id
                        )
                AND     (
                                per_qualifications.attendance_id IS NULL
                        )
                AND     (
                                per_qualifications.qualification_id = per_qualifications_tl.qualification_id
                        )
                AND     (
                                 per_qualifications.business_group_id = p_bg_id

                        )
               /* AND     (
                                get_content_type_id (per_qualification_types.category) IN('AWARD','HONOUR')
                        OR      get_content_type_id (per_qualification_types.category) = 'EDUCATION_LEVEL'
                        )*/
			   AND lookup_type = 'PER_CATEGORIES'
               and lookup_code = per_qualification_types.category
               and UPPER(meaning) = 'AWARD'
                ) c_hrt_profile_items
        WHERE   (
                        per_ri_ig_persons.person_id = c53_person_id
                )
        AND     (
                        per_ri_ig_hrt_cntitem_qual.content_item_id = c55_qualification_type_id
                                                                    || '_QUAL_CNT_ITEM'
                )
        AND     (
                        per_ri_ig_profiles_b_per.person_id = per_ri_ig_persons.person_id
                )
        ;
        --
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
                        ,pt_i_ModuleMessage       => 'End of extraction at ' || to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS.FF2') || '. Procedure completed'
                ,pt_i_OracleError         => gvt_ReturnMessage       );     

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

    END export_profile_items_qual_3;

    PROCEDURE export_profile_items_qual_4
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          number
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_profile_items_qual_4'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'xxmx_hrt_pfl_items_stg';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'PROFILE_ITEMS_QUAL_4';

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
        --   
        INSERT  
        INTO    xxmx_hrt_pfl_items_stg
                (migration_set_id
                ,migration_set_name                   
                ,migration_status
                ,bg_name
                ,bg_id
                ,profile_id
                ,content_type_id
                ,content_item_id
                ,date_from
                ,date_to
                ,importance
                ,item_date_2
                ,item_date_3
                ,item_date_6
                ,profile_item_id
                ,title)
        SELECT   pt_i_MigrationSetID                               
                ,pt_i_MigrationSetName                               
                ,'EXTRACTED'  
                ,p_bg_name
                ,p_bg_id
                ,per_ri_ig_profiles_b_per.profile_id profile_id
                ,gvv_memb_cnt_typ content_type_id
                ,per_ri_ig_hrt_cntitem_qual.content_item_id content_item_id
                ,nvl (c14_item_date_2
                        ,to_date ('01-01-1900'
                                ,'DD-MM-YYYY')) date_from
                ,c3_date_to date_to
                ,2 importance
                ,c14_item_date_2 item_date_2
                ,c15_item_date_3 item_date_3
                ,c26_item_date_6 item_date_6
                ,s0_qualification_id
                    || '_ITEM'
                    ,title
        FROM    xxmx_hrt_cnt_items_b_stg per_ri_ig_hrt_cntitem_qual
                ,xxmx_hrt_profile_b_stg per_ri_ig_profiles_b_per
                ,xxmx_per_persons_stg per_ri_ig_persons
                ,
                (
                SELECT  'MAXIMISE' c1_last_updated_by
                    ,per_qualifications.qua_information_category c2_information_category
                    ,per_qualifications.end_date c3_date_to
                    ,per_qualifications.start_date c14_item_date_2
                    ,per_qualifications.end_date c15_item_date_3
                    ,per_qualifications.awarded_date c26_item_date_6
                    ,per_establishment_attendances.person_id c53_person_id
                    ,per_qualification_types.category c56_category
                    ,per_qualifications.person_id c54_person_id
                    ,per_qualifications.qualification_type_id c52_qualification_type_id
                    ,per_qualifications.attendance_id c55_attendance_id
                    ,per_qualifications.qualification_id s0_qualification_id
                    ,per_qualifications.title
                FROM    per_qualifications_tl@MXDM_NVIS_EXTRACT per_qualifications_tl
                    ,per_establishment_attendances@MXDM_NVIS_EXTRACT per_establishment_attendances
                    ,per_qualifications@MXDM_NVIS_EXTRACT per_qualifications
                    ,per_qualification_types@MXDM_NVIS_EXTRACT per_qualification_types
                    ,hr_all_organization_units@MXDM_NVIS_EXTRACT horg
                WHERE   (
                                per_qualifications_tl.language = 'US'
                        )
                AND     (
                                per_qualifications.qualification_type_id = per_qualification_types.qualification_type_id
                        )
                AND     (
                                per_qualifications.attendance_id = per_establishment_attendances.attendance_id
                        )
                AND     (
                                per_qualifications.qualification_id = per_qualifications_tl.qualification_id
                        )
                AND     (
                                horg.organization_id = per_establishment_attendances.business_group_id
                        AND     horg.name = p_bg_name
                        )
                AND     get_content_type_id (per_qualification_types.category) = 'MEMBERSHIP'
                ) c_hrt_profile_items
        WHERE   (
                        per_ri_ig_hrt_cntitem_qual.content_item_id = c52_qualification_type_id
                                                                    || '_QUAL_CNT_ITEM'
                )
        AND     (
                        per_ri_ig_profiles_b_per.person_id = per_ri_ig_persons.person_id
                )
        AND     (
                        per_ri_ig_persons.person_id = c53_person_id

                )
        ;

        gvv_ProgressIndicator := '0030';
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
                ,pt_i_ModuleMessage       => 'Extracting data into "xxmx_hrt_pfl_items_stg".'   
                        ,pt_i_OracleError         => gvt_ReturnMessage       );

        INSERT 
        INTO    xxmx_hrt_pfl_items_stg
                (migration_set_id
                ,migration_set_name                   
                ,migration_status
                ,bg_name
                ,bg_id
                ,profile_id
                ,content_type_id
                ,content_item_id
                ,date_from
                ,date_to
                ,importance
                ,item_date_2
                ,item_date_3
                ,item_date_6
                ,profile_item_id
                ,title)
        SELECT   pt_i_MigrationSetID                               
                ,pt_i_MigrationSetName                               
                ,'EXTRACTED'  
                ,p_bg_name
                ,p_bg_id
                ,per_ri_ig_profiles_b_per.profile_id profile_id
                ,gvv_memb_cnt_typ content_type_id
                ,per_ri_ig_hrt_cntitem_qual.content_item_id content_item_id
                ,nvl (c14_item_date_2
                        ,to_date ('01-01-1900'
                                ,'DD-MM-YYYY')) date_from
                ,c3_date_to date_to
                ,2 importance
                ,c14_item_date_2 item_date_2
                ,c15_item_date_3 item_date_3
                ,c26_item_date_6 item_date_6
                ,s0_qualification_id
                    || '_ITEM'
                    ,title
        FROM    xxmx_hrt_cnt_items_b_stg per_ri_ig_hrt_cntitem_qual
                ,xxmx_hrt_profile_b_stg per_ri_ig_profiles_b_per
                ,xxmx_per_persons_stg per_ri_ig_persons
                ,
                (
                SELECT  'MAXIMISE' c1_last_updated_by
                    ,per_qualifications.qua_information_category c2_information_category
                    ,per_qualifications.end_date c3_date_to
                    ,per_qualifications.start_date c14_item_date_2
                    ,per_qualifications.end_date c15_item_date_3
                    ,per_qualifications.awarded_date c26_item_date_6
                    ,per_qualification_types.category c56_category
                    ,per_qualifications.person_id c54_person_id
                    ,per_qualifications.qualification_type_id c52_qualification_type_id
                    ,per_qualifications.attendance_id c55_attendance_id
                    ,per_qualifications.qualification_id s0_qualification_id
                    ,per_qualifications.title
                FROM    per_qualifications_tl@MXDM_NVIS_EXTRACT per_qualifications_tl
                    ,per_qualifications@MXDM_NVIS_EXTRACT per_qualifications
                    ,per_qualification_types@MXDM_NVIS_EXTRACT per_qualification_types
                    ,hr_all_organization_units@MXDM_NVIS_EXTRACT horg
                WHERE   (
                                per_qualifications_tl.language = 'US'
                        )
                AND     (
                                per_qualifications.qualification_type_id = per_qualification_types.qualification_type_id
                        )
                AND     (
                                per_qualifications.attendance_id IS NULL
                        )
                AND     (
                                per_qualifications.qualification_id = per_qualifications_tl.qualification_id
                        )
                AND     (
                                horg.organization_id = per_qualifications.business_group_id
                        AND     horg.name = p_bg_name
                        )
                AND     get_content_type_id (per_qualification_types.category) = 'MEMBERSHIP'
                ) c_hrt_profile_items
        WHERE   (
                        per_ri_ig_hrt_cntitem_qual.content_item_id = c52_qualification_type_id
                                                                    || '_QUAL_CNT_ITEM'
                )
        AND     (
                        per_ri_ig_profiles_b_per.person_id = per_ri_ig_persons.person_id
                )
        AND     (
                        per_ri_ig_persons.person_id = c54_person_id

                )
        ;

		COMMIT;
        --
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
                        ,pt_i_ModuleMessage       => 'End of extraction at ' || to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS.FF2') || '. Procedure completed'
                ,pt_i_OracleError         => gvt_ReturnMessage       );     

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

    END export_profile_items_qual_4;

    PROCEDURE export_person_profiles_b_1
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          number
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_person_profiles_b_1'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'xxmx_hrt_profile_b_stg';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'PERSON_PROFILES_B_1';

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
        FROM    xxmx_hrt_profile_b_stg
        WHERE   bg_id    = p_bg_id    ;

        COMMIT;
        --
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
        --   
        INSERT  
        INTO    xxmx_hrt_profile_b_stg
                (migration_set_id
                ,migration_set_name                   
                ,migration_status
                ,bg_name
                ,bg_id
                ,profile_id
                ,profile_type_id
                ,profile_code
                ,profile_status_code
                ,profile_usage_code
                ,person_id)
        SELECT   pt_i_MigrationSetID                               
                ,pt_i_MigrationSetName                               
                ,'EXTRACTED'  
                ,p_bg_name
                ,p_bg_id
                , per_all_people_f.person_id  profile_id
                ,gvv_per_prof_typ profile_type_id
                ,substrb ('PERSON_'
                            || per_all_people_f.person_id
                            ,1
                            ,30) profile_code
                ,'A' profile_status_code
                ,'P' profile_usage_code
                ,xxmx_per_persons_stg.person_id person_id
        FROM    xxmx_per_persons_stg xxmx_per_persons_stg
                ,per_all_people_f@MXDM_NVIS_EXTRACT per_all_people_f
        WHERE   (
                        xxmx_per_persons_stg.person_id = per_all_people_f.person_id

                AND     per_all_people_f.effective_end_date =  
                        (
                        SELECT  max (effective_end_date)
                        FROM    per_all_people_f@MXDM_NVIS_EXTRACT papf
                        WHERE   person_id = per_all_people_f.person_id
                        )
                )
        AND     per_all_people_f.business_group_id = p_bg_id
        AND     NOT EXISTS
                    (
                    SELECT  1
                    FROM    xxmx_hrt_profile_b_stg inn
                    WHERE   inn.profile_id = per_all_people_f.person_id

                    );
        --
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
                        ,pt_i_ModuleMessage       => 'End of extraction at ' || to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS.FF2') || '. Procedure completed'
                ,pt_i_OracleError         => gvt_ReturnMessage       );     

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

    END export_person_profiles_b_1;

    PROCEDURE export_person_profiles_tl_1
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          number
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_person_profiles_tl_1'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'xxmx_hrt_profile_tl_stg';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'PERSON_PROFILES_TL_1';

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
        FROM    xxmx_hrt_profile_tl_stg
        WHERE   bg_id    = p_bg_id    ;


        COMMIT;    
        --
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
        --   
        INSERT  
        INTO    xxmx_hrt_profile_tl_stg
                (    migration_set_id
                    ,migration_set_name                   
                    ,migration_status
                    ,bg_name
                    ,bg_id
                    ,profile_id
                    ,language
                    ,source_lang)
        SELECT       pt_i_MigrationSetID                               
                    ,pt_i_MigrationSetName                               
                    ,'EXTRACTED'  
                    ,p_bg_name
                    ,p_bg_id
                    , xxmx_extract_hrt_profiles_b.profile_id profile_id
                    ,'US' language
                    ,'US' source_lang
        FROM    xxmx_hrt_profile_b_stg xxmx_extract_hrt_profiles_b
            ,per_all_people_f@MXDM_NVIS_EXTRACT per_all_people_f
            ,hr_all_organization_units@MXDM_NVIS_EXTRACT horg
        WHERE   (
                    per_all_people_f.effective_end_date =  
                    (
                    SELECT  max (papf.effective_end_date)
                    FROM    per_all_people_f@MXDM_NVIS_EXTRACT papf
                    WHERE   papf.person_id = per_all_people_f.person_id
                    )
                AND     per_all_people_f.business_group_id = horg.organization_id
                AND     horg.name = p_bg_name
                )
        AND     (
                        xxmx_extract_hrt_profiles_b.person_id = per_all_people_f.person_id

                )
        ;
        --
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
                        ,pt_i_ModuleMessage       => 'End of extraction at ' || to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS.FF2') || '. Procedure completed'
                ,pt_i_OracleError         => gvt_ReturnMessage       );     

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

    END export_person_profiles_tl_1;

    PROCEDURE export_hrt_rating_models_b
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          number
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_hrt_rating_models_b'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_HRT_RATING_MDL_B_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'HRT_RATING_MODELS_B';

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
        FROM    XXMX_HRT_RATING_MDL_B_STG
        WHERE   rating_model_id = 'EBS_PERF_RATING_MOD'
                                || '_PERFORMANCE_RATING_MODEL'    
        AND     bg_id    = p_bg_id    ;    

        COMMIT;        
        --
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
        --    

        INSERT  
        INTO    XXMX_HRT_RATING_MDL_B_STG
                (migration_set_id
                ,migration_set_name                   
                ,migration_status
                ,bg_name
                ,bg_id
                ,rating_model_id
                ,rating_model_code
                ,date_from)
        SELECT   pt_i_MigrationSetID                               
                ,pt_i_MigrationSetName                               
                ,'EXTRACTED'  
                ,p_bg_name
                ,p_bg_id
                ,'EBS_PERF_RATING_MOD'
                    || '_PERFORMANCE_RATING_MODEL' rating_model_id
                ,'EBS_PERF_RATING_MOD' rating_model_code
                ,to_date ('1900-01-01 00:00:00'
                            ,'YYYY-MM-DD HH24:MI:SS') date_from
        FROM    dual;

        COMMIT;
        --
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
                        ,pt_i_ModuleMessage       => 'End of extraction at ' || to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS.FF2') || '. Procedure completed'
                ,pt_i_OracleError         => gvt_ReturnMessage       );     

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

    END export_hrt_rating_models_b;

    PROCEDURE export_hrt_rating_models_tl
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          number
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_hrt_rating_models_tl'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'xxmx_hrt_rating_mdl_tl_stg';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'HRT_RATING_MODELS_TL';

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
        FROM    xxmx_hrt_rating_mdl_tl_stg
        WHERE   rating_model_id = 'EBS_PERF_RATING_MOD'
                                || '_PERFORMANCE_RATING_MODEL'    
        AND     bg_id    = p_bg_id    ;   

        COMMIT;        
        --
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
        --   

        INSERT  
        INTO    xxmx_hrt_rating_mdl_tl_stg
                (migration_set_id
                ,migration_set_name                   
                ,migration_status
                ,bg_name
                ,bg_id
                ,rating_model_id
                ,language
                ,source_lang
                ,rating_name
                ,rating_description)
        SELECT   pt_i_MigrationSetID                               
                ,pt_i_MigrationSetName                               
                ,'EXTRACTED'  
                ,p_bg_name
                ,p_bg_id
                , 'EBS_PERF_RATING_MOD'
                    || '_PERFORMANCE_RATING_MODEL' rating_model_id
                ,'US' language
                ,'US' source_lang
                ,'EBS Performance Rating Model' rating_name
                ,'Rating model for Performance Review Content Type migration' rating_description
        FROM    dual;

        COMMIT;
        --
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
                        ,pt_i_ModuleMessage       => 'End of extraction at ' || to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS.FF2') || '. Procedure completed'
                ,pt_i_OracleError         => gvt_ReturnMessage       );     

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

    END export_hrt_rating_models_tl;

    PROCEDURE export_pk_struc_perf_rating_2
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          number
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

        CURSOR c1 IS
            SELECT  fnd_lookup_values.lookup_code c1_lookup_code
            FROM    fnd_lookup_values@MXDM_NVIS_EXTRACT fnd_lookup_values
            WHERE   (
                            fnd_lookup_values.lookup_type = 'PERFORMANCE_RATING'
                    AND     fnd_lookup_values.view_application_id = 3
                    AND     fnd_lookup_values.language = userenv ('LANG')
                    )
        ;

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_struc_perf_rating_2'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT '';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'STRUC_PERF_RATING_2';

        v_src_lkp_code                                  VARCHAR2(1000);
        v_cnt                                           number          DEFAULT 0;
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

        v_cnt := 1;

        OPEN c1;

        LOOP
            FETCH c1
                INTO    v_src_lkp_code;

            IF c1%FOUND THEN
                g_perf_rat_lvl_map (v_cnt).ebs_lookup_type := 'PERFORMANCE_RATING';

                g_perf_rat_lvl_map (v_cnt).ebs_lookup_code := v_src_lkp_code;

                g_perf_rat_lvl_map (v_cnt).guid := v_cnt;

                v_cnt := v_cnt + 1;
            END IF;

            EXIT WHEN c1%NOTFOUND;
        END LOOP;

        CLOSE c1;
    EXCEPTION
        WHEN no_data_found THEN
            RETURN;

            COMMIT;

    END export_pk_struc_perf_rating_2;

    PROCEDURE export_hrt_rating_levels_b
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          number
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_hrt_rating_levels_b'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'xxmx_hrt_rating_lvl_b_stg';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'HRT_RATING_LEVELS_B';

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
        FROM    xxmx_hrt_rating_lvl_b_stg
        WHERE   rating_model_id = 'EBS_PERF_RATING_MOD'
                                || '_PERFORMANCE_RATING_MODEL'    
        AND     bg_id    = p_bg_id    ;

        COMMIT;       
        --
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
        --   

        FOR i IN 1 .. nvl(g_perf_rat_lvl_map.last,-1) LOOP
            INSERT  
            INTO    xxmx_hrt_rating_lvl_b_stg
                    (migration_set_id
                    ,migration_set_name                   
                    ,migration_status
                    ,bg_name
                    ,bg_id
                    ,rating_level_id
                    ,rating_model_id
                    ,rating_level_code
                    ,date_from)
            VALUES 
                    (
                    NULL
                    ,NULL
                    ,NULL
                    ,p_bg_name
                    ,p_bg_id
                    ,g_perf_rat_lvl_map (i).guid
                    ,'EBS_PERF_RATING_MOD'
                    || '_PERFORMANCE_RATING_MODEL'
                    ,g_perf_rat_lvl_map (i).ebs_lookup_code
                    ,to_date ('1900-01-01'
                            ,'YYYY-MM-DD'));
        END LOOP;

        COMMIT;
        --
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
                        ,pt_i_ModuleMessage       => 'End of extraction at ' || to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS.FF2') || '. Procedure completed'
                ,pt_i_OracleError         => gvt_ReturnMessage       );     

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

  END export_hrt_rating_levels_b;

  PROCEDURE export_hrt_rating_levels_tl_1
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          number
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_hrt_rating_levels_tl_1'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'xxmx_hrt_rating_lvl_tl_stg';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'HRT_RATING_LEVELS_TL_1';

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
        FROM    xxmx_hrt_rating_lvl_tl_stg
        WHERE   rating_level_id IN
                (
                SELECT  rating_level_id
                FROM    xxmx_hrt_rating_lvl_b_stg
                WHERE   rating_model_id = 'EBS_PERF_RATING_MOD'
                                        || '_PERFORMANCE_RATING_MODEL'
                )    
        AND     bg_id    = p_bg_id    ;

        COMMIT;        
        --
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
        --   

        INSERT  
        INTO    xxmx_hrt_rating_lvl_tl_stg
                (migration_set_id
                ,migration_set_name                   
                ,migration_status
                ,bg_name
                ,bg_id
                ,rating_level_id
                ,language
                ,source_lang
                ,rating_description
                ,rating_short_descr)
        SELECT   pt_i_MigrationSetID                               
                ,pt_i_MigrationSetName                               
                ,'EXTRACTED'  
                ,p_bg_name
                ,p_bg_id
                , xxmx_hrt_rating_lvl_b_stg.rating_level_id rating_level_id
                ,'US' language
                ,'US' source_lang
                ,c2_rating_description rating_description
                ,c1_rating_short_descr rating_short_descr
        FROM    xxmx_hrt_rating_lvl_b_stg xxmx_hrt_rating_lvl_b_stg
            ,
                (
                SELECT  fnd_lookup_values.meaning c1_rating_short_descr
                    ,nvl (fnd_lookup_values.description
                            ,fnd_lookup_values.meaning) c2_rating_description
                    ,fnd_lookup_values.language c4_language
                    ,fnd_lookup_values.lookup_code c3_lookup_code
                    ,fnd_lookup_values.source_lang c5_source_lang
                FROM    fnd_lookup_values@MXDM_NVIS_EXTRACT fnd_lookup_values
                WHERE   (
                                fnd_lookup_values.view_application_id = 3
                        AND     fnd_lookup_values.language = userenv ('LANG')
                        AND     fnd_lookup_values.lookup_type = 'PERFORMANCE_RATING'
                        )
                ) hrt_rating_level
        WHERE   xxmx_hrt_rating_lvl_b_stg.rating_level_code = c3_lookup_code
        AND     rating_model_id = 'EBS_PERF_RATING_MOD'
                                || '_PERFORMANCE_RATING_MODEL';

        COMMIT;
        --
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
                        ,pt_i_ModuleMessage       => 'End of extraction at ' || to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS.FF2') || '. Procedure completed'
                ,pt_i_OracleError         => gvt_ReturnMessage       );     

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

    END export_hrt_rating_levels_tl_1;

    PROCEDURE export_profile_items_pr_1
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          number
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_profile_items_pr_1'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'xxmx_hrt_pfl_items_stg';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'PROFILE_ITEMS_PR_1';

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
        --   
        INSERT  
        INTO    xxmx_hrt_pfl_items_stg
                (migration_set_id
                ,migration_set_name                   
                ,migration_status
                ,bg_name
                ,bg_id
                ,profile_id
                ,content_type_id
                ,date_from
                ,date_to
                ,qualifier_id1
                ,rating_model_id1
                ,rating_level_id1
                ,item_number_1_guid
                ,profile_item_id)
        SELECT   pt_i_MigrationSetID                               
                ,pt_i_MigrationSetName                               
                ,'EXTRACTED'  
                ,p_bg_name
                ,p_bg_id
                ,xxmx_extract_hrt_profiles_b.profile_id profile_id
                ,gvv_perf_rat_cnt_typ content_type_id
                ,c2_date_from date_from
                ,to_date ('31-12-4712'
                            ,'DD-MM-YYYY') date_to
                ,gvv_qualifier
                ,xxmx_hrt_rating_lvl_b_stg.rating_model_id rating_model_id1
                ,xxmx_hrt_rating_lvl_b_stg.rating_level_id rating_level_id1
                ,decode(c11_assignment_type,'E',c6_assignment_id || '_EMP_ASSIGNMENT',c6_assignment_id || '_CWK_ASSIGNMENT')  item_number_1_guid
                ,s0_performance_review_id
                    || '_PERF_RATING_PROFILE_ITEM'
        FROM    xxmx_hrt_rating_lvl_b_stg xxmx_hrt_rating_lvl_b_stg
                ,xxmx_per_persons_stg xxmx_per_persons_stg
                ,xxmx_hrt_profile_b_stg xxmx_extract_hrt_profiles_b
                ,
                (
                SELECT  'MAXIMISE' c1_last_updated_by
                    ,per_performance_reviews.review_date c2_date_from
                    ,'MAXIMISE' c3_created_by
                    ,NULL c4_creation_date
                    ,NULL c5_last_update_date
                    ,per_all_assignments_f.assignment_id c6_assignment_id
                    ,per_all_assignments_f.assignment_type  c11_assignment_type
                    ,per_performance_reviews.person_id c8_person_id
                    ,per_performance_reviews.performance_rating c9_performance_rating
                    ,per_events.type c10_type
                    ,per_performance_reviews.performance_review_id s0_performance_review_id
                FROM    per_performance_reviews@MXDM_NVIS_EXTRACT per_performance_reviews
                    ,per_all_assignments_f@MXDM_NVIS_EXTRACT per_all_assignments_f
                    ,per_events@MXDM_NVIS_EXTRACT per_events
                    ,hr_all_organization_units@MXDM_NVIS_EXTRACT horg
                WHERE   (
                                per_all_assignments_f.primary_flag = 'Y'
                        )
                AND     (
                                per_all_assignments_f.assignment_type IN ('E','C')
                        )
                AND     (
                                per_performance_reviews.person_id = per_all_assignments_f.person_id
                        AND     per_performance_reviews.review_date BETWEEN per_all_assignments_f.effective_start_date
                                                                    AND     per_all_assignments_f.effective_end_date
                        )
                AND     (
                                per_performance_reviews.event_id = per_events.event_id
                        )
                AND     (
                                horg.organization_id = per_all_assignments_f.business_group_id
                        AND     horg.name = p_bg_name
                        )
                ) c_hrt_profile_item
        WHERE   (
                        xxmx_per_persons_stg.person_id = xxmx_extract_hrt_profiles_b.person_id
                )
        AND     (
                        xxmx_per_persons_stg.person_id = c8_person_id

                )
        AND     (
                        xxmx_hrt_rating_lvl_b_stg.rating_level_id = get_rating_level_id (c9_performance_rating)
                )
        ;
        --
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
                        ,pt_i_ModuleMessage       => 'End of extraction at ' || to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS.FF2') || '. Procedure completed'
                ,pt_i_OracleError         => gvt_ReturnMessage       );     

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

    END export_profile_items_pr_1;

    PROCEDURE export_profile_items_pr_2
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          number
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_profile_items_pr_2'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'xxmx_hrt_pfl_items_stg';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'PROFILE_ITEMS_PR_2';

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
        --   
        INSERT  
        INTO    xxmx_hrt_pfl_items_stg
                (migration_set_id
                ,migration_set_name                   
                ,migration_status
                ,bg_name
                ,bg_id
                ,profile_id
                ,content_type_id
                ,date_from
                ,date_to
                ,qualifier_id1
                ,rating_model_id1
                ,rating_level_id1
                ,item_number_1_guid
                ,profile_item_id)
        SELECT   pt_i_MigrationSetID                               
                ,pt_i_MigrationSetName                               
                ,'EXTRACTED'  
                ,p_bg_name
                ,p_bg_id
                , xxmx_extract_hrt_profiles_b.profile_id profile_id
                ,gvv_perf_rat_cnt_typ content_type_id
                ,c2_date_from date_from
                ,to_date ('31-12-4712'
                            ,'DD-MM-YYYY') date_to
                ,gvv_qualifier qualifier_id1
                ,xxmx_hrt_rating_lvl_b_stg.rating_model_id rating_model_id1
                ,xxmx_hrt_rating_lvl_b_stg.rating_level_id rating_level_id1
                ,decode(c11_assignment_type,'E',c6_assignment_id || '_EMP_ASSIGNMENT',c6_assignment_id || '_CWK_ASSIGNMENT')  item_number_1_guid
                ,s0_performance_review_id
                    || '_PERF_RATING_PROFILE_ITEM'
        FROM    xxmx_hrt_rating_lvl_b_stg xxmx_hrt_rating_lvl_b_stg
                ,xxmx_per_persons_stg xxmx_per_persons_stg
                ,xxmx_hrt_profile_b_stg xxmx_extract_hrt_profiles_b
                ,
                (
                SELECT  'MAXIMISE' c1_last_updated_by
                    ,per_performance_reviews.review_date c2_date_from
                    ,'MAXIMISE' c3_created_by
                    ,NULL c4_creation_date
                    ,NULL c5_last_update_date
                    ,per_all_assignments_f.assignment_id c6_assignment_id
                    ,per_all_assignments_f.assignment_type  c11_assignment_type
                    ,per_performance_reviews.person_id c8_person_id
                    ,per_performance_reviews.performance_rating c9_performance_rating
                    ,per_performance_reviews.performance_review_id s0_performance_review_id
                FROM    per_performance_reviews@MXDM_NVIS_EXTRACT per_performance_reviews
                    ,per_all_assignments_f@MXDM_NVIS_EXTRACT per_all_assignments_f
                    ,hr_all_organization_units@MXDM_NVIS_EXTRACT horg
                WHERE   (
                                per_all_assignments_f.primary_flag = 'Y'
                        )
                AND     (
                                per_all_assignments_f.assignment_type IN ('E','C')
                        )
                AND     (
                                per_performance_reviews.event_id IS NULL
                        )
                AND     (
                                per_performance_reviews.person_id = per_all_assignments_f.person_id
                        AND     per_performance_reviews.review_date BETWEEN per_all_assignments_f.effective_start_date
                                                                    AND     per_all_assignments_f.effective_end_date
                        )
                AND     (
                                horg.organization_id = per_all_assignments_f.business_group_id
                        AND     horg.name = p_bg_name
                        )
                ) c_hrt_profile_item
        WHERE   (
                        xxmx_per_persons_stg.person_id = xxmx_extract_hrt_profiles_b.person_id
                )
        AND     (
                        xxmx_per_persons_stg.person_id = c8_person_id

                )
        AND     (
                        xxmx_hrt_rating_lvl_b_stg.rating_level_id = get_rating_level_id (c9_performance_rating)
                )
        ;
        --
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
                        ,pt_i_ModuleMessage       => 'End of extraction at ' || to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS.FF2') || '. Procedure completed'
                ,pt_i_OracleError         => gvt_ReturnMessage       );     

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

    END export_profile_items_pr_2;

    PROCEDURE export_profile_items_pr_appr
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          number
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_profile_items_pr_appr'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT '';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'PROFILE_ITEMS_PR_APPR';

    BEGIN
        NULL;
    END export_profile_items_pr_appr;

    PROCEDURE export_profile_items_pr_cmp
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          number
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_profile_items_pr_cmp'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT '';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'PROFILE_ITEMS_PR_CMP';

    BEGIN
        NULL;
    END export_profile_items_pr_cmp;

    --*******************
    --** PROCEDURE: purge
    --*******************
    --
    PROCEDURE purge
                    (
                    pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    )
    IS
        --
        --
        cv_ProcOrFuncName                   CONSTANT      VARCHAR2(30) := 'purge'; 
        ct_Phase                            CONSTANT      xxmx_module_messages.phase%TYPE  := 'CORE';
        cv_i_BusinessEntityLevel            CONSTANT      VARCHAR2(100) DEFAULT 'PERSON PURGE';
        --
        e_ModuleError                   EXCEPTION;
        --

    BEGIN
        --
        --
        gvv_ProgressIndicator := '0010';
        --
        --
        gvv_ReturnStatus  := '';
        gvt_ReturnMessage := '';
        --
        --
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
        --
        IF   gvv_ReturnStatus = 'F'
        THEN
                --
                --
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
                    ,pt_i_ModuleMessage       => '- Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
                    ,pt_i_OracleError         => gvt_ReturnMessage
                    );
                --
                --
                RAISE e_ModuleError;
                --
                --
        END IF;
        --
        --
        gvv_ProgressIndicator := '0020';
        --
        --
        xxmx_utilities_pkg.log_module_message
            (pt_i_ApplicationSuite    => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
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
        IF   pt_i_MigrationSetID IS NULL
        THEN
                --
                --
                gvt_Severity      := 'ERROR';
                gvt_ModuleMessage := '- "pt_i_MigrationSetID" parameter is mandatory.';
                --
                --
                RAISE e_ModuleError;
                --
                --
        END IF;
        --
        --
        xxmx_utilities_pkg.log_module_message
            (pt_i_ApplicationSuite    => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_Phase               => ct_Phase
            ,pt_i_Severity            => 'NOTIFICATION'
            ,pt_i_PackageName         => gcv_PackageName
            ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
            ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
            ,pt_i_ModuleMessage       => '- Purging tables.'
            ,pt_i_OracleError         => NULL
            );
        --
        --
        gvv_ProgressIndicator := '0030';
        --
        --
        DELETE
        FROM   xxmx_per_persons_stg
        WHERE  migration_set_id = pt_i_MigrationSetID;
        --
        --
        gvn_RowCount := SQL%ROWCOUNT;
        --
        --
        xxmx_utilities_pkg.log_module_message
            (pt_i_ApplicationSuite    => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_Phase               => ct_Phase
            ,pt_i_Severity            => 'NOTIFICATION'
            ,pt_i_PackageName         => gcv_PackageName
            ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
            ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
            ,pt_i_ModuleMessage       => '  - Records purged from "xxmx_per_persons_stg" table: '    ||gvn_RowCount
            ,pt_i_OracleError         => NULL
                );
        --
        --
        gvv_ProgressIndicator := '0040';
        --
        --          
        DELETE
        FROM   xxmx_per_email_f_stg
        WHERE  migration_set_id = pt_i_MigrationSetID;
        --
        --
        gvn_RowCount := SQL%ROWCOUNT;
        --
        --
        xxmx_utilities_pkg.log_module_message
            (pt_i_ApplicationSuite    => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_Phase               => ct_Phase
            ,pt_i_Severity            => 'NOTIFICATION'
            ,pt_i_PackageName         => gcv_PackageName
            ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
            ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
            ,pt_i_ModuleMessage       => '  - Records purged from "xxmx_per_email_f_stg" table: '    ||gvn_RowCount
            ,pt_i_OracleError         => NULL
                );
        --
        --
        gvv_ProgressIndicator := '0050';
        --
        --          
        DELETE
        FROM   xxmx_per_nid_f_stg
        WHERE  migration_set_id = pt_i_MigrationSetID;
        --
        --
        gvn_RowCount := SQL%ROWCOUNT;
        --
        --
        xxmx_utilities_pkg.log_module_message
            (pt_i_ApplicationSuite    => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_Phase               => ct_Phase
            ,pt_i_Severity            => 'NOTIFICATION'
            ,pt_i_PackageName         => gcv_PackageName
            ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
            ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
            ,pt_i_ModuleMessage       => '  - Records purged from "xxmx_per_nid_f_stg" table: '    ||gvn_RowCount
            ,pt_i_OracleError         => NULL
                );
        --
        --
        gvv_ProgressIndicator := '0060';
        --
        --          
        DELETE
        FROM   xxmx_per_phones_stg
        WHERE  migration_set_id = pt_i_MigrationSetID;
        --
        --
        gvn_RowCount := SQL%ROWCOUNT;
        --
        --
        xxmx_utilities_pkg.log_module_message
            (pt_i_ApplicationSuite    => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_Phase               => ct_Phase
            ,pt_i_Severity            => 'NOTIFICATION'
            ,pt_i_PackageName         => gcv_PackageName
            ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
            ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
            ,pt_i_ModuleMessage       => '  - Records purged from "xxmx_per_phones_stg" table: '    ||gvn_RowCount
            ,pt_i_OracleError         => NULL
                );
        --
        --
        gvv_ProgressIndicator := '0070';
        --
        --          
        DELETE
        FROM   xxmx_per_address_f_stg
        WHERE  migration_set_id = pt_i_MigrationSetID;
        --
        --
        gvn_RowCount := SQL%ROWCOUNT;
        --
        --
        xxmx_utilities_pkg.log_module_message
            (pt_i_ApplicationSuite    => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_Phase               => ct_Phase
            ,pt_i_Severity            => 'NOTIFICATION'
            ,pt_i_PackageName         => gcv_PackageName
            ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
            ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
            ,pt_i_ModuleMessage       => '  - Records purged from "xxmx_per_address_f_stg" table: '    ||gvn_RowCount
            ,pt_i_OracleError         => NULL
                );
        --
        --
        gvv_ProgressIndicator := '0080';
        --
        --          
        DELETE
        FROM   xxmx_per_addr_usg_f_stg
        WHERE  migration_set_id = pt_i_MigrationSetID;
        --
        --
        gvn_RowCount := SQL%ROWCOUNT;
        --
        --
        xxmx_utilities_pkg.log_module_message
            (pt_i_ApplicationSuite    => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_Phase               => ct_Phase
            ,pt_i_Severity            => 'NOTIFICATION'
            ,pt_i_PackageName         => gcv_PackageName
            ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
            ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
            ,pt_i_ModuleMessage       => '  - Records purged from "xxmx_per_addr_usg_f_stg" table: '    ||gvn_RowCount
            ,pt_i_OracleError         => NULL
                );
        --
        --
        gvv_ProgressIndicator := '0090';
        --
        --          
        DELETE
        FROM   xxmx_per_people_f_stg
        WHERE  migration_set_id = pt_i_MigrationSetID;
        --
        --
        gvn_RowCount := SQL%ROWCOUNT;
        --
        --
        xxmx_utilities_pkg.log_module_message
            (pt_i_ApplicationSuite    => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_Phase               => ct_Phase
            ,pt_i_Severity            => 'NOTIFICATION'
            ,pt_i_PackageName         => gcv_PackageName
            ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
            ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
            ,pt_i_ModuleMessage       => '  - Records purged from "xxmx_per_people_f_stg" table: '    ||gvn_RowCount
            ,pt_i_OracleError         => NULL
                );
        --
        --
        gvv_ProgressIndicator := '0100';
        --
        --          
        DELETE
        FROM   xxmx_per_ethnicities_stg
        WHERE  migration_set_id = pt_i_MigrationSetID;
        --
        --
        gvn_RowCount := SQL%ROWCOUNT;
        --
        --
        xxmx_utilities_pkg.log_module_message
            (pt_i_ApplicationSuite    => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_Phase               => ct_Phase
            ,pt_i_Severity            => 'NOTIFICATION'
            ,pt_i_PackageName         => gcv_PackageName
            ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
            ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
            ,pt_i_ModuleMessage       => '  - Records purged from "xxmx_per_ethnicities_stg" table: '    ||gvn_RowCount
            ,pt_i_OracleError         => NULL
                );
        --
        --
        --
        gvv_ProgressIndicator := '0110';
        --
        --
        DELETE
        FROM   xxmx_per_leg_f_stg
        WHERE  migration_set_id = pt_i_MigrationSetID;
        --
        --
        gvn_RowCount := SQL%ROWCOUNT;
        --
        --
        xxmx_utilities_pkg.log_module_message
            (pt_i_ApplicationSuite    => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_Phase               => ct_Phase
            ,pt_i_Severity            => 'NOTIFICATION'
            ,pt_i_PackageName         => gcv_PackageName
            ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
            ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
            ,pt_i_ModuleMessage       => '  - Records purged from "xxmx_per_leg_f_stg" table: '    ||gvn_RowCount
            ,pt_i_OracleError         => NULL
                );
        --
        --
        gvv_ProgressIndicator := '0120';
        --
        --          
        DELETE
        FROM   XXMX_PER_NAMES_F_STG
        WHERE  migration_set_id = pt_i_MigrationSetID;
        --
        --
        gvn_RowCount := SQL%ROWCOUNT;
        --
        --
        xxmx_utilities_pkg.log_module_message
            (pt_i_ApplicationSuite    => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_Phase               => ct_Phase
            ,pt_i_Severity            => 'NOTIFICATION'
            ,pt_i_PackageName         => gcv_PackageName
            ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
            ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
            ,pt_i_ModuleMessage       => '  - Records purged from "XXMX_PER_NAMES_F_STG" table: '    ||gvn_RowCount
            ,pt_i_OracleError         => NULL
                );
        --
        --
        gvv_ProgressIndicator := '0130';
        --
        --          
        DELETE
        FROM   xxmx_citizenships_stg
        WHERE  migration_set_id = pt_i_MigrationSetID;
        --
        --
        gvn_RowCount := SQL%ROWCOUNT;
        --
        --
        xxmx_utilities_pkg.log_module_message
            (pt_i_ApplicationSuite    => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_Phase               => ct_Phase
            ,pt_i_Severity            => 'NOTIFICATION'
            ,pt_i_PackageName         => gcv_PackageName
            ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
            ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
            ,pt_i_ModuleMessage       => '  - Records purged from "xxmx_citizenships_stg" table: '    ||gvn_RowCount
            ,pt_i_OracleError         => NULL
                );
        --
        --
        gvv_ProgressIndicator := '0140';
        --
        --          
        DELETE
        FROM   xxmx_per_documentation_stg
        WHERE  migration_set_id = pt_i_MigrationSetID;
        --
        --
        gvn_RowCount := SQL%ROWCOUNT;
        --
        --
        xxmx_utilities_pkg.log_module_message
            (pt_i_ApplicationSuite    => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_Phase               => ct_Phase
            ,pt_i_Severity            => 'NOTIFICATION'
            ,pt_i_PackageName         => gcv_PackageName
            ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
            ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
            ,pt_i_ModuleMessage       => '  - Records purged from "xxmx_per_documentation_stg" table: '    ||gvn_RowCount
            ,pt_i_OracleError         => NULL
                );
        --
        --
        gvv_ProgressIndicator := '0150';
        --
        --          
        DELETE
        FROM   xxmx_hrt_pfl_items_stg
        WHERE  migration_set_id = pt_i_MigrationSetID;
        --
        --
        gvn_RowCount := SQL%ROWCOUNT;
        --
        --
        xxmx_utilities_pkg.log_module_message
            (pt_i_ApplicationSuite    => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_Phase               => ct_Phase
            ,pt_i_Severity            => 'NOTIFICATION'
            ,pt_i_PackageName         => gcv_PackageName
            ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
            ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
            ,pt_i_ModuleMessage       => '  - Records purged from "xxmx_hrt_pfl_items_stg" table: '    ||gvn_RowCount
            ,pt_i_OracleError         => NULL
                );
        --
        --
        gvv_ProgressIndicator := '0160';
        --
        --          
        DELETE
        FROM   xxmx_hrt_profile_b_stg
        WHERE  migration_set_id = pt_i_MigrationSetID;
        --
        --
        gvn_RowCount := SQL%ROWCOUNT;
        --
        --
        xxmx_utilities_pkg.log_module_message
            (pt_i_ApplicationSuite    => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_Phase               => ct_Phase
            ,pt_i_Severity            => 'NOTIFICATION'
            ,pt_i_PackageName         => gcv_PackageName
            ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
            ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
            ,pt_i_ModuleMessage       => '  - Records purged from "xxmx_hrt_profile_b_stg" table: '    ||gvn_RowCount
            ,pt_i_OracleError         => NULL
                );
        --
        --
        gvv_ProgressIndicator := '0170';
        --
        --          
        DELETE
        FROM   xxmx_hrt_profile_tl_stg
        WHERE  migration_set_id = pt_i_MigrationSetID;
        --
        --
        gvn_RowCount := SQL%ROWCOUNT;
        --
        --
        xxmx_utilities_pkg.log_module_message
            (pt_i_ApplicationSuite    => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_Phase               => ct_Phase
            ,pt_i_Severity            => 'NOTIFICATION'
            ,pt_i_PackageName         => gcv_PackageName
            ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
            ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
            ,pt_i_ModuleMessage       => '  - Records purged from "xxmx_hrt_profile_tl_stg" table: '    ||gvn_RowCount
            ,pt_i_OracleError         => NULL
                );
        --
        --
        --
        --
        gvv_ProgressIndicator := '0180';
        --
        --          
        DELETE
        FROM   XXMX_HRT_RATING_MDL_B_STG
        WHERE  migration_set_id = pt_i_MigrationSetID;
        --
        --
        gvn_RowCount := SQL%ROWCOUNT;
        --
        --
        xxmx_utilities_pkg.log_module_message
            (pt_i_ApplicationSuite    => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_Phase               => ct_Phase
            ,pt_i_Severity            => 'NOTIFICATION'
            ,pt_i_PackageName         => gcv_PackageName
            ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
            ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
            ,pt_i_ModuleMessage       => '  - Records purged from "XXMX_HRT_RATING_MDL_B_STG" table: '    ||gvn_RowCount
            ,pt_i_OracleError         => NULL
                );
        --
        --
        --
        --
        gvv_ProgressIndicator := '0190';
        --
        --          
        DELETE
        FROM   xxmx_hrt_rating_mdl_tl_stg
        WHERE  migration_set_id = pt_i_MigrationSetID;
        --
        --
        gvn_RowCount := SQL%ROWCOUNT;
        --
        --
        xxmx_utilities_pkg.log_module_message
            (pt_i_ApplicationSuite    => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_Phase               => ct_Phase
            ,pt_i_Severity            => 'NOTIFICATION'
            ,pt_i_PackageName         => gcv_PackageName
            ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
            ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
            ,pt_i_ModuleMessage       => '  - Records purged from "xxmx_hrt_rating_mdl_tl_stg" table: '    ||gvn_RowCount
            ,pt_i_OracleError         => NULL
                );
        --
        --
        --
        --
        gvv_ProgressIndicator := '0200';
        --
        --          
        DELETE
        FROM   xxmx_hrt_rating_lvl_b_stg
        WHERE  migration_set_id = pt_i_MigrationSetID;
        --
        --
        gvn_RowCount := SQL%ROWCOUNT;
        --
        --
        xxmx_utilities_pkg.log_module_message
            (pt_i_ApplicationSuite    => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_Phase               => ct_Phase
            ,pt_i_Severity            => 'NOTIFICATION'
            ,pt_i_PackageName         => gcv_PackageName
            ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
            ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
            ,pt_i_ModuleMessage       => '  - Records purged from "xxmx_hrt_rating_lvl_b_stg" table: '    ||gvn_RowCount
            ,pt_i_OracleError         => NULL
                );
        --
        --
        --
        --
        gvv_ProgressIndicator := '0210';
        --
        --          
        DELETE
        FROM   xxmx_hrt_rating_lvl_tl_stg
        WHERE  migration_set_id = pt_i_MigrationSetID;
        --
        --
        gvn_RowCount := SQL%ROWCOUNT;
        --
        --
        xxmx_utilities_pkg.log_module_message
            (pt_i_ApplicationSuite    => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_Phase               => ct_Phase
            ,pt_i_Severity            => 'NOTIFICATION'
            ,pt_i_PackageName         => gcv_PackageName
            ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
            ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
            ,pt_i_ModuleMessage       => '  - Records purged from "xxmx_hrt_rating_lvl_tl_stg" table: '    ||gvn_RowCount
            ,pt_i_OracleError         => NULL
                );
        --
        --
        gvv_ProgressIndicator := '0220';
        --
        --          
        DELETE
        FROM   xxmx_migration_details
        WHERE  migration_set_id = pt_i_MigrationSetID;
        --
        --
        gvn_RowCount := SQL%ROWCOUNT;
        --
        --
        xxmx_utilities_pkg.log_module_message
            (pt_i_ApplicationSuite    => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_Phase               => ct_Phase
            ,pt_i_Severity            => 'NOTIFICATION'
            ,pt_i_PackageName         => gcv_PackageName
            ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
            ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
            ,pt_i_ModuleMessage       => '  - Records purged from "XXMX_MIGRATION_DETAILS" table: '    ||gvn_RowCount
            ,pt_i_OracleError         => NULL
                );
        --
        --
        gvv_ProgressIndicator := '0230';
        --
        --          
        DELETE
        FROM   xxmx_migration_headers
        WHERE  migration_set_id = pt_i_MigrationSetID;
        --
        --
        gvn_RowCount := SQL%ROWCOUNT;
        --
        --
        xxmx_utilities_pkg.log_module_message
            (pt_i_ApplicationSuite    => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_Phase               => ct_Phase
            ,pt_i_Severity            => 'NOTIFICATION'
            ,pt_i_PackageName         => gcv_PackageName
            ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
            ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
            ,pt_i_ModuleMessage       => '  - Records purged from "XXMX_MIGRATION_HEADERS" table: '    ||gvn_RowCount
            ,pt_i_OracleError         => NULL
                );
        --
		gvv_ProgressIndicator := '0240';
		--          
        DELETE
        FROM   XXMX_PER_PASSPORT_STG
        WHERE  migration_set_id = pt_i_MigrationSetID;
        --
        --
        gvn_RowCount := SQL%ROWCOUNT;
        --
        --
        xxmx_utilities_pkg.log_module_message
            (pt_i_ApplicationSuite    => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_Phase               => ct_Phase
            ,pt_i_Severity            => 'NOTIFICATION'
            ,pt_i_PackageName         => gcv_PackageName
            ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
            ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
            ,pt_i_ModuleMessage       => '  - Records purged from "xxmx_per_passport_stg" table: '    ||gvn_RowCount
            ,pt_i_OracleError         => NULL
                );
        --
		gvv_ProgressIndicator := '0250';
		--          
        DELETE
        FROM   XXMX_PER_RELIGION_STG
        WHERE  migration_set_id = pt_i_MigrationSetID;
        --
        --
        gvn_RowCount := SQL%ROWCOUNT;
        --
        --
        xxmx_utilities_pkg.log_module_message
            (pt_i_ApplicationSuite    => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_Phase               => ct_Phase
            ,pt_i_Severity            => 'NOTIFICATION'
            ,pt_i_PackageName         => gcv_PackageName
            ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
            ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
            ,pt_i_ModuleMessage       => '  - Records purged from "xxmx_per_religion_stg" table: '    ||gvn_RowCount
            ,pt_i_OracleError         => NULL);
        --
		--
		gvv_ProgressIndicator := '0260';
		--          
        DELETE
        FROM   XXMX_PER_DISABILITY_STG
        WHERE  migration_set_id = pt_i_MigrationSetID;
        --
        --
        gvn_RowCount := SQL%ROWCOUNT;
        --
        --
        xxmx_utilities_pkg.log_module_message
            (pt_i_ApplicationSuite    => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_Phase               => ct_Phase
            ,pt_i_Severity            => 'NOTIFICATION'
            ,pt_i_PackageName         => gcv_PackageName
            ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
            ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
            ,pt_i_ModuleMessage       => '  - Records purged from "XXMX_PER_DISABILITY_STG" table: '    ||gvn_RowCount
            ,pt_i_OracleError         => NULL);
		--
		--
		gvv_ProgressIndicator := '0270';
		--          
        DELETE
        FROM   XXMX_PER_IMAGES_STG
        WHERE  migration_set_id = pt_i_MigrationSetID;
        --
        --
        gvn_RowCount := SQL%ROWCOUNT;
        --
        --
        xxmx_utilities_pkg.log_module_message
            (pt_i_ApplicationSuite    => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_Phase               => ct_Phase
            ,pt_i_Severity            => 'NOTIFICATION'
            ,pt_i_PackageName         => gcv_PackageName
            ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
            ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
            ,pt_i_ModuleMessage       => '  - Records purged from "XXMX_PER_IMAGES_STG" table: '    ||gvn_RowCount
            ,pt_i_OracleError         => NULL);

		--
		gvv_ProgressIndicator := '0280';
		--          
        DELETE
        FROM   XXMX_PER_ABSENCE_STG
        WHERE  migration_set_id = pt_i_MigrationSetID;
        --
        --
        gvn_RowCount := SQL%ROWCOUNT;
        --
        --
        xxmx_utilities_pkg.log_module_message
            (pt_i_ApplicationSuite    => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_Phase               => ct_Phase
            ,pt_i_Severity            => 'NOTIFICATION'
            ,pt_i_PackageName         => gcv_PackageName
            ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
            ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
            ,pt_i_ModuleMessage       => '  - Records purged from "XXMX_PER_ABSENCE_STG" table: '    ||gvn_RowCount
            ,pt_i_OracleError         => NULL);
		--
		--
		--
        xxmx_utilities_pkg.log_module_message
            (pt_i_ApplicationSuite    => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_Phase               => ct_Phase
            ,pt_i_Severity            => 'NOTIFICATION'
            ,pt_i_PackageName         => gcv_PackageName
            ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
            ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
            ,pt_i_ModuleMessage       => '- Purging complete.'
                ,pt_i_OracleError         => NULL
                );
        --
        --
        COMMIT;
        --
        --
        xxmx_utilities_pkg.log_module_message
            (pt_i_ApplicationSuite    => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
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
        --
        EXCEPTION
                --
                --
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
                    --
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
    END purge;
END xxmx_kit_person_stg;
/
SHOW ERRORS PACKAGE BODY xxmx_kit_person_stg;
/