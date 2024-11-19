CREATE OR REPLACE PACKAGE BODY xxmx_hcm_hdl_file_gen_pkg
AS
     
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
   --** FILENAME  :  xxmx_hcm_hdl_file_gen_pkg.sql
   --**
   --** FILEPATH  :  $XXV1_TOP/install/sql
   --**
   --** VERSION   :  1.10
   --**
   --** EXECUTE
   --** IN SCHEMA :  XXMX_CORE
   --**
   --** AUTHORS   :  Jay McNeill
   --**
   --** PURPOSE   :  This package contains procedures FOR generating HCM 
   --**              components FOR person Migration 
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
   --**  1.0    11/11/2020    Jay McNeill       Initial Build
   --**  1.1    26/03/2021    Pallavi Kanajar	 Added People Group Name, Supervisor and all Other attributes (location
   --**     									   Department, Position to Assignment File
   --**  1.2	 29/03/2021	   Pallavi Kanajar	 Contact File ISsue Fix
   --**  1.3    10/05/2021    Pallavi Kanajar   Visa & Third Party Org , People Group 
   --**  1.4    19/05/2021    Pallavi           Changed Cursor for GradeladderProgram, Salary and Payroll.
   --**  1.5    20/05/2021    Pallavi           Fix for WorkRelationship Date Start
   --**  1.6 	 24/05/2021	   Kirti			 Added Changes for Assignment DFF 
   --**  1.7 	 07/06/2021	   Pallavi			 Added Changes for Absences HDL
   --**  1.8    24/06/2021    Pallavi           Added Default Expense Account in Both Current and Add_Assign File
   --**  1.9    08/07/2021    Pallavi           Additional Assignments WorkMeasure and Gradesteps
   --**  1.10   20/07/2021    Pallavi           Open End Date Flag is added for absence - attribute2
   --**
   --**--******************************************************************************
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
   --*/
	
     --
     /*
     **********************
     ** Global Declarations
     **********************
     --
     /* Maximise Integration Globals */
     --
     /* Global Constants FOR use in all xxmx_utilities_pkg Procedure/Function Calls within this package */
     --
     gct_PackageName             CONSTANT xxmx_migration_metadata.entity_package_name%TYPE := 'xxmx_hcm_hdl_file_gen_pkg';
     gct_ApplicationSuite        CONSTANT xxmx_migration_metadata.application_suite%TYPE   := 'HCM';
     gct_Application             CONSTANT xxmx_migration_metadata.application%TYPE         := 'HR';
     gcv_SourceSystem            CONSTANT VARCHAR2(30)                                     := 'EBS';
     ct_file_location_type       CONSTANT xxmx_file_locations.file_location_type%TYPE      := 'OIC_INTERNAL';
     gct_phase                   CONSTANT xxmx_module_messages.phase%TYPE                  := 'EXPORT'; --'HCM_HDL_FILE_GEN';
     -- In case the delimitter of the file creation changes
     gv_delim                   CONSTANT  VARCHAR2(4) := '|';
     -- have to add this to SELECT  from client config table   -- JEM
     gv_ClientCode      VARCHAR2(40) := 'MAXIMISE';

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

     --
     /**********************************
     ** FUNCTION: 
     **********************************/
     --
     --
     --
     /*********************************
     ** End of FUNCTIONS 
     **********************************/
     --
     --
     /*****************************************
     ** PROCEDURE: gen_worker_hire_file
     ******************************************/
	PROCEDURE gen_worker_hire_file
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_migration_metadata.business_entity%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    ,pt_i_FileName                   IN      xxmx_migration_metadata.data_file_name%TYPE                    
                   )
     IS
          --

--WORKER		WORKER_HIRE	WorkerHire

          --
          /**********************
          ** CURSOR Declarations
          ***********************/
          -- WORKER
                CURSOR c_get_per_worker IS
                 SELECT DISTINCT  
                   'Worker-'||fs.person_number||gv_delim||
                    per.pps_start_date||gv_delim||  --per.effective_start_date||gv_delim||
                    --per.effective_end_date||gv_delim||
					to_CHAR(to_date('31-DEC-4712','DD-MON-RRRR'),'RRRR/MM/DD')||gv_delim||
                    fs.person_number||gv_delim||
                    per.pps_start_date||gv_delim||
                    per.dob||gv_delim||
                    fs.action_code||gv_delim||
                    ''  
                FROM XXMX_HR_HCM_PERSON_V per,
                    XXMX_HR_HCM_FILE_SET_V1 fs
              WHERE fs.person_id = per.person_id
                AND UPPER(fs.action_code) = 'HIRE'
                order by 1; 



          -- WORKER NAME 
                CURSOR c_get_per_name IS
               SELECT DISTINCT 
                       fs.person_number||gv_delim
                    ||'Worker-'||fs.person_number||gv_delim 
                    ||per.pps_start_date||gv_delim  --||per.effective_start_date||gv_delim
                    --||per.effective_end_date||gv_delim
					||to_CHAR(to_date('31-DEC-4712','DD-MON-RRRR'),'RRRR/MM/DD')||gv_delim
                    ||per.pns_legislation_code||gv_delim
                    ||per.pns_name_type||gv_delim
                    ||per.pns_first_name||gv_delim
                    ||per.pns_middle_names||gv_delim
                    ||per.pns_last_name||gv_delim
                    ||per.pns_honors||gv_delim
                    ||per.pns_known_as||gv_delim
                    ||per.pns_pre_name_adjunct||gv_delim
                    ||per.pns_military_rank||gv_delim
                    ||per.pns_previous_last_name||gv_delim
                    ||per.pns_suffix||gv_delim
                    ||INITCAP(per.pns_title)
               FROM XXMX_HR_HCM_PERSON_V per,
                    XXMX_HR_HCM_FILE_SET_V1 fs
              WHERE fs.person_id = per.person_id
                AND UPPER(fs.action_code) = 'HIRE'
                AND per.pns_last_name IS NOT NULL
                order by 1; 


               -- Worker Ethnicity
                CURSOR c_get_per_ethnicity is
               SELECT DISTINCT   fs.person_number||gv_delim
                    ||'Worker-'||fs.person_number||gv_delim 
                    ||per.pe_legislation_code||gv_delim
                    ||per.pe_ethnicity||gv_delim
                    ||per.pe_primary_flag 
               FROM XXMX_HR_HCM_PERSON_V per,
                    XXMX_HR_HCM_FILE_SET_V1 fs
              WHERE fs.person_id = per.person_id
                AND UPPER(fs.action_code) = 'HIRE'
                AND per.pe_ethnicity IS NOT NULL
                order by 1; 


               -- Worker Legislative Data
                CURSOR c_get_per_legis_data IS
               SELECT  DISTINCT 
                         fs.person_number||gv_delim
                    ||'Worker-'||fs.person_number||gv_delim
                    ||per.pps_start_date||gv_delim      --||per.effective_start_date||gv_delim
                    --||per.effective_end_date||gv_delim
					||to_CHAR(to_date('31-DEC-4712','DD-MON-RRRR'),'RRRR/MM/DD')||gv_delim
                    ||fs.person_number||gv_delim
                    ||per.pld_legislation_code||gv_delim
                    ||per.pld_highest_education_level||gv_delim
                    ||per.pld_marital_status||gv_delim
                    ||per.pld_marital_status_date||gv_delim
                    ||per.pld_sex
               FROM XXMX_HR_HCM_PERSON_V per,
                    XXMX_HR_HCM_FILE_SET_V1 fs
              WHERE fs.person_id = per.person_id
                AND UPPER(fs.action_code) = 'HIRE'
                AND per.pps_start_date IS NOT NULL    --per.effective_start_date IS NOT NULL
                AND per.pld_legislation_code IS NOT NULL
                order by 1; 



               --
               -- Worker Address
                CURSOR c_get_per_address is
               SELECT DISTINCT
                      fs.person_number||'-'||per.paf_address_type||gv_delim
                    ||'Worker-'||fs.person_number||gv_delim
                    ||per.pps_start_date||gv_delim          --    ||per.effective_start_date||gv_delim
                    --||per.effective_end_date||gv_delim
                    ||to_CHAR(to_date('31-DEC-4712','DD-MON-RRRR'),'RRRR/MM/DD')||gv_delim
                    ||fs.person_number||gv_delim
                    ||per.paf_address_type||gv_delim
                    ||per.paf_address_line_1||gv_delim
                    ||per.paf_address_line_2||gv_delim
                    ||per.paf_address_line_3||gv_delim
                    ||per.paf_town_or_city||gv_delim
                    ||per.paf_region_1||gv_delim
                    ||per.paf_region_2||gv_delim
                    ||per.paf_country_code||gv_delim
                    ||per.paf_postal_code||gv_delim
                    ||per.paf_primary_flag
               FROM XXMX_HR_HCM_PERSON_V per,
                    XXMX_HR_HCM_FILE_SET_V1 fs
              WHERE fs.person_id = per.person_id
                AND UPPER(fs.action_code) = 'HIRE'
                AND per.paf_address_line_1 IS NOT NULL
                order by 1; 


               -- Worker Phone
                CURSOR c_get_per_phone is
               SELECT DISTINCT  
                         fs.person_number||'-'||per.phone_phone_type||gv_delim
                    ||'Worker-'||fs.person_number||gv_delim
                    ||per.phone_phone_type||gv_delim
                    ||per.pps_start_date||gv_delim  ----||per.phone_date_from||gv_delim
                    ||per.phone_date_to||gv_delim
                    ||fs.person_number||gv_delim
                    ||per.phone_legislation_code||gv_delim
                    ||per.phone_phone_number||gv_delim
                    ||per.phone_primary_flag
               FROM XXMX_HR_HCM_PERSON_V per,
                    XXMX_HR_HCM_FILE_SET_V1 fs
              WHERE fs.person_id = per.person_id
                AND UPPER(fs.action_code) = 'HIRE'
                AND per.phone_phone_number IS NOT NULL
                order by 1; 



               -- Worker Email
                CURSOR c_get_per_email is
               SELECT DISTINCT 
                      fs.person_number||'-'||per.pemail_email_type||gv_delim
                    ||'Worker-'||fs.person_number||gv_delim
                    ||per.pps_start_date||gv_delim  --||per.pemail_date_from||gv_delim
                    ||per.pemail_date_to||gv_delim
                    ||fs.person_number||gv_delim
                    ||per.pemail_email_type||gv_delim
                    ||per.pemail_email_address||gv_delim
                    ||per.pemail_primary_flag
               FROM XXMX_HR_HCM_PERSON_V per,
                    XXMX_HR_HCM_FILE_SET_V1 fs
              WHERE fs.person_id = per.person_id
                AND UPPER(fs.action_code) = 'HIRE'
                AND per.pemail_email_address IS NOT NULL
                order by 1; 


               -- Worker National Identifier
               CURSOR c_get_per_national_id is
                    SELECT  DISTINCT 
                    fs.person_number||gv_delim
                    ||'Worker-'||fs.person_number||gv_delim
                    ||fs.person_number||gv_delim
                    ||per.nid_legislation_code||gv_delim
                    ||per.nid_issue_date||gv_delim
                    ||per.nid_expiration_date||'||'
                    ||'NINO'||gv_delim
               --      ||Substr(nid_national_identifier_type,2,5)||gv_delim
                    ||per.nid_national_identifier_number||gv_delim
                    ||per.nid_primary_flag
               FROM XXMX_HR_HCM_PERSON_V per,
                    XXMX_HR_HCM_FILE_SET_V1 fs
              WHERE fs.person_id = per.person_id
                AND UPPER(fs.action_code) = 'HIRE'
                AND per.nid_national_identifier_number IS NOT NULL
                order by 1; 



               -- Worker Citizenship
                CURSOR c_get_per_citizenship is
               SELECT  DISTINCT 
                         fs.person_number||gv_delim
                    ||'Worker-'||fs.person_number||gv_delim
                    ||per.pps_start_date||gv_delim  --||per.cit_date_from||gv_delim
                    ||per.cit_date_to||gv_delim
                    ||per.cit_legislation_code||gv_delim
                    ||per.cit_citizenship_status
               FROM XXMX_HR_HCM_PERSON_V per,
                    XXMX_HR_HCM_FILE_SET_V1 fs
              WHERE fs.person_id = per.person_id
                AND UPPER(fs.action_code) = 'HIRE'
                AND per.cit_date_from IS NOT NULL
                order by 1; 


               -- Worker Passport
               CURSOR c_get_per_passport is
                    SELECT  DISTINCT 
                           fs.person_number||gv_delim
                         ||'Worker-'||fs.person_number||gv_delim
                         ||fs.person_number||gv_delim
                         ||per.pass_legislationcode||gv_delim
                         ||per.pass_passportnumber||gv_delim
                         ||per.pass_expiration_date||gv_delim
                         ||per.pass_issuing_country
                      FROM xxmx_hr_hcm_person_v per,
                           XXMX_HR_HCM_FILE_SET_V1 fs
                     WHERE fs.person_id = per.person_id
                       AND UPPER(fs.action_code) = 'HIRE'
                       AND per.pass_passportnumber IS NOT NULL 
                       order by 1; 


				-- Worker Religion
				CURSOR c_get_per_religion
				IS
					SELECT DISTINCT 
						  fs.person_number||gv_delim
						||'Worker-'||fs.person_number||gv_delim
						--||fs.person_number||gv_delim
						||per.pns_legislation_code||gv_delim
						||per.religion||gv_delim
						||per.rel_primary_flag
					FROM XXMX_HR_HCM_PERSON_V per,
						XXMX_HR_HCM_FILE_SET_V1 fs
					WHERE fs.person_id = per.person_id
					AND UPPER(fs.action_code) = 'HIRE'
					AND per.religion IS NOT NULL
					order by 1; 


                -- Worker Visa
				CURSOR c_get_per_visa
				IS
					SELECT DISTINCT 
				        fs.person_number||gv_delim
						||'Worker-'||fs.person_number||gv_delim                        
                        ||TO_CHAR(EffectiveStartDate,'RRRR/MM/DD') ||gv_delim
                        ||TO_CHAR(EffectiveEndDate,'RRRR/MM/DD')||gv_delim
                        ||VisaPermitType||gv_delim
                        ||fs.person_number||gv_delim
                        ||LegislationCode||gv_delim
                        ||EntryDate||gv_delim
                        ||ExpirationDate||gv_delim
                        ||CurrentVisaPermit||gv_delim
                        ||IssueDate||gv_delim
                        ||IssuingAuthority||gv_delim
                        ||IssuingCountry||gv_delim
                        ||IssuingLocation||gv_delim
                        ||Profession||gv_delim
                        ||VisaPermitCategory||gv_delim
                        ||VisaPermitNumber||gv_delim
                        ||VisaPermitStatus||gv_delim
                        ||VisaPermitStatusDate||gv_delim
                    from xxmx_per_visa_f_xfm visa,
                         XXMX_HR_HCM_File_set_V1 fs
                    where fs.person_id =visa.person_id
                    and fs.action_Code = 'HIRE'
                    order by 1;



         -- Work Relationship
                CURSOR c_per_work_relation IS
                    SELECT  DISTINCT 
                           fs.person_number||gv_delim
                         ||'Worker-'||fs.person_number||gv_delim
                         ||fs.person_number||gv_delim               --||w.wrs_person_number||gv_delim 
                         --||w.wrs_date_start||gv_delim -- 1.23
                         ||fs.per_start_date||gv_delim
                         ||w.wrs_worker_type||gv_delim
                         ||NVL( wrs_legal_employer_name,fs.legal_emp_name)||gv_delim  -- Fix for Legal_employer is null
                         ||fs.action_code||gv_delim
                         ||''||gv_delim
                         ||w.wrs_primary_flag
                     FROM XXMX_HR_HCM_WORK_REL_V w,
                          XXMX_HR_HCM_FILE_SET_V1 fs
                    WHERE fs.person_id = w.wrs_person_id
                       AND UPPER(fs.action_code) = 'HIRE'
                       and w.wrs_ppos = fs.ppos
                      AND w.wrs_date_start IS NOT NULL
                      order by 1; 


            -- Worker WorkTerms
                CURSOR c_per_workterms IS
                     SELECT DISTINCT 
                           wa.asg_work_terms_assignment_id||gv_delim  -- Assignment Number
                         ||wa.asg_work_terms_assignment_id||gv_delim  -- Assignment Name
                         ||'EBS'||gv_delim          -- SourceSystemId
                         ||'Workterms-'||wa.asg_work_terms_assignment_id||gv_delim
                         ||'WorkRelationship-'||fs.person_number||gv_delim
                         ||'Worker-'||fs.person_number||gv_delim
                         --||wa.asg_effective_start_date||gv_delim -- Commented for backlog 916 
                         ||fs.per_start_date||gv_delim -- 916 
                         ||wa.asg_effective_end_date||gv_delim
                         ||fs.person_number||gv_delim
                         ||wa.asg_effective_sequence||gv_delim   --||wa.asg_assignment_sequence||gv_delim 
                         ||'Y'||gv_delim -- Placeholder default
                         ||wa.pps_start_date||gv_delim
                         ||fs.action_code||gv_delim
                         ||''||gv_delim      -- Reason Code
                         ||NVL(wa.asg_assignment_status_type,'ACTIVE_PROCESS')||gv_delim
                   --      ||DECODE(wa.asg_assignment_status_type_id,'ACTIVE_ASSIGN',1,2)||gv_delim
                   --||wa.asg_effective_sequence||gv_delim
                         ||RTRIM(wa.asg_business_unit_name)||gv_delim --BusinessUnitShortCode <<BLNK>>
                         ||''      -- ||RTRIM(wa.asg_legal_employer_name) --TaxReportingUnit <<BLANK>>
                     FROM XXMX_HR_HCM_WORK_ASSIGN_V wa,
                          XXMX_HR_HCM_FILE_SET_V1 fs
                    WHERE fs.person_id = wa.asg_person_id
                      AND fs.assignment_number  =wa.asg_assignment_number
                      AND UPPER(fs.action_code) = UPPER(asg_action_code)
                      AND UPPER(fs.action_code) = 'HIRE'
                      AND wa.asg_effective_start_date IS NOT NULL
                      order by 1; 


               -- ASSIGNMENT
                CURSOR c_per_assignment IS
                    SELECT  DISTINCT 
                           fs.assignment_number||gv_delim -- Assignment Number
                         ||fs.assignment_number||gv_delim -- Assignment Name
                         ||wa.asg_work_terms_assignment_id||gv_delim   
                         ||'EBS'||gv_delim          -- SourceSystemId
                         ||'Assignment-'||fs.assignment_number||gv_delim
                         ||'Workterms-'||wa.asg_work_terms_assignment_id||gv_delim     
                         ||'WorkRelationship-'||fs.person_number||gv_delim
                         ||'Worker-'||fs.person_number||gv_delim
                         --||wa.asg_effective_start_date||gv_delim -- Commented for backlog 916 
                         ||fs.per_start_date||gv_delim -- 916 
                         ||wa.asg_effective_end_date||gv_delim
                         ||fs.person_number||gv_delim
                         ||wa.asg_effective_sequence||gv_delim     --||wa.asg_assignment_sequence||gv_delim 
                         ||wa.asg_effective_latest_change||gv_delim --  ||'Y'||gv_delim -- Placeholder default
                         ||wa.pps_start_date||gv_delim   
                         ||fs.action_code||gv_delim
                         ||''||gv_delim
                         ||DECODE(wa.asg_system_person_type,'CWK','C',wa.asg_proposed_worker_type)||gv_delim      -- worker type
                         ||RTRIM(wa.asg_legal_employer_name)||gv_delim
                         ||wa.asg_primary_assignment_flag||gv_delim    -- should be 'Y'
                         ||NVL(wa.asg_assignment_status_type,'ACTIVE_PROCESS')||gv_delim
                   --      ||DECODE(NVL(wa.asg_assignment_status_type_id,'ACTIVE_ASSIGN'),'ACTIVE_ASSIGN',1,2)||gv_delim
                         ||RTRIM(wa.asg_business_unit_name)||gv_delim    --||RTRIM(business_unit_name)||gv_delim Busness Unit Short Code
                         ||wa.asg_assignment_type||gv_delim
                         ||wa.asg_workercategory||gv_delim  -- WORKER CATEGORY
                         ||DECODE(wa.asg_system_person_type,'EX_EMP','EMP',wa.asg_system_person_type)||gv_delim  
                         ||RTRIM(wa.asg_legal_employer_name)||gv_delim  -- TaxReportingUnit
                         ||wa.asg_employment_category  -- Assignment Category
                      FROM XXMX_HR_HCM_WORK_ASSIGN_V wa,
                           XXMX_HR_HCM_FILE_SET_V1 fs
                     WHERE fs.person_id          = wa.asg_person_id
                       AND fs.assignment_number  = wa.asg_assignment_number
                       AND UPPER(fs.action_code) = UPPER(asg_action_code)
                       AND UPPER(fs.action_code) = 'HIRE'
                       AND asg_effective_start_date IS NOT NULL
                       order by 1; 


          --
          /************************
          ** Constant Declarations
          *************************/
          --
          cv_ProcOrFuncName           CONSTANT  VARCHAR2(30)                                := 'gen_worker_hire_file';
          --ct_file_location_type       CONSTANT xxmx_file_locations.file_location_type%TYPE  := 'HCM_INTERNAL';
          ct_StgTable                 CONSTANT xxmx_migration_metadata.stg_table%TYPE       := 'dat';

          cv_metadata              CONSTANT VARCHAR2(30) := 'METADATA';

          cv_title_line            CONSTANT VARCHAR2(20) := 'T'; 
          cv_data_line             CONSTANT VARCHAR2(20) := 'D'; 

          -- Line Name
          cv_worker                CONSTANT VARCHAR2(30) := 'Worker';
          cv_person_name           CONSTANT VARCHAR2(30) := 'PersonName';
          cv_per_religion          CONSTANT VARCHAR2(30) := 'PersonReligion';         -- Not required JEM 
          cv_per_visa              CONSTANT VARCHAR2(30) := 'PersonVisa';  -- Visa
          cv_per_ethnicity         CONSTANT VARCHAR2(30) := 'PersonEthnicity'; 
          cv_per_legistlation      CONSTANT VARCHAR2(30) := 'PersonLegislativeData';        
          cv_per_address           CONSTANT VARCHAR2(30) := 'PersonAddress';        
          cv_per_phone             CONSTANT VARCHAR2(30) := 'PersonPhone';        
          cv_per_email             CONSTANT VARCHAR2(30) := 'PersonEmail';        
          cv_per_nat_ident         CONSTANT VARCHAR2(30) := 'PersonNationalIdentifier';        
          cv_per_Citizenship       CONSTANT VARCHAR2(30) := 'PersonCitizenship';        
          cv_per_Passport          CONSTANT VARCHAR2(30) := 'PersonPassport';        
          cv_wrk_relation          CONSTANT VARCHAR2(30) := 'WorkRelationship';

          cv_wrk_terms             CONSTANT VARCHAR2(30) := 'WorkTerms';        
          cv_work_assignment       CONSTANT VARCHAR2(30) := 'Assignment';  
          cv_wrk_measure           CONSTANT VARCHAR2(30) := 'AssignmentWorkMeasure';          
          cv_assign_grade          CONSTANT VARCHAR2(30) := 'AssignmentGradeSteps'; 



          --
          /*************************
          ** Variable Declarations
          *************************/
          --
          vv_FusionAsgNumber             VARCHAR2(100);
          vd_BeginDate                   DATE;

          vv_file_type              VARCHAR2(10) := 'M';
          vv_file_type_name         VARCHAR2(20) := 'MERGE';

          vv_file_dir              xxmx_file_locations.file_location%TYPE;
          vv_line                  VARCHAR2(3000);


		  -- Code added by Kirti
		  vvv_legislative_dff_mode	VARCHAR2(10):= 'N';
		  -- Kirti Code ends


          --
          /****************************
          ** Record Table Declarations
          *****************************/
          --
          type type_per_data is table of varchar2(30000) index by binary_integer;
          g_per_data                 type_per_data;
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
               ,pt_i_ModuleMessage     => 'Procedure "'
                                        ||gct_PackageName
                                        ||'.'
                                        ||cv_ProcOrFuncName
                                        ||'" initiated.'
               ,pt_i_OracleError       => NULL
               );

                     gvt_MigrationSetName := xxmx_utilities_pkg.get_migration_set_name(pt_i_MigrationSetID);

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
                              ,pt_i_ModuleMessage     => 'Migration Set Name '
                                                       ||gvt_MigrationSetName
                              ,pt_i_OracleError       => NULL
                              );

                       vv_file_dir := xxmx_hdl_utilities_pkg.get_directory_path
                                                        (gct_ApplicationSuite
                                                        ,gct_Application
                                                        ,pt_i_BusinessEntity
                                                        ,ct_file_location_type);

                       DELETE FROM xxmx_hdl_file_temp WHERE  UPPER(file_name) = UPPER(pt_i_FileName);

                        gvv_ProgressIndicator := '0050';            

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
                              ,pt_i_ModuleMessage     => 'Calling OPEN_hdl '
                                                        ||gvt_MigrationSetName
                                                        ||' File Name          '||pt_i_FileName
                                                        ||' ORA File Directory '||vv_file_dir
                                                        ||' vv_file_type       '||vv_file_type
                              ,pt_i_OracleError       => NULL
                              );

                 -- Start generating the HDL data file
                 -- OPEN the Merge file, main header will be automatically written
                    xxmx_hdl_utilities_pkg.OPEN_hdl (gv_ClientCode
                                                    ,pt_i_BusinessEntity
                                                    ,pt_i_FileName
                                                    ,vv_file_dir
                                                    ,vv_file_type
                                                    );
                 --

                 -- Worker Main
                 OPEN c_get_per_worker; 
                 FETCH c_get_per_worker BULK COLLECT INTO g_per_data; 
                 CLOSE c_get_per_worker;

                DBMS_OUTPUT.PUT_LINE('TEST_FILE');
                 -- write the header
                 IF g_per_data.COUNT > 0 THEN
                   --  -- Write the Business Entity header
                     DBMS_OUTPUT.PUT_LINE('TEST_FILE');
                     xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'T',cv_worker,NULL,'M');
                 END IF;

                 FOR i IN 1..g_per_data.COUNT LOOP
                     DBMS_OUTPUT.PUT_LINE('TEST_FILE');
                     xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'D',cv_worker,g_per_data(i),'M');
                 END LOOP; 
                 g_per_data.DELETE;
                 commit;

                 -- Worker Name
                 OPEN c_get_per_name; 
                 FETCH c_get_per_name BULK COLLECT INTO g_per_data;
                 CLOSE c_get_per_name;

                 IF g_per_data.COUNT > 0 THEN
                   -- Write the Business Entity header
                     xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'T',cv_person_name,NULL,'M');
                 END IF;

                 FOR i IN 1..g_per_data.COUNT LOOP
                     xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'D',cv_person_name,g_per_data(i),'M');
                 END LOOP; 
                 g_per_data.DELETE;
                 commit;
               --
               -- Worker Religion
               --  NO STAGING table gathering this inFORmation
               --  NOT NECESSARY AS PART OF MAXIMISE DM

               -- Worker Ethnicity
                  OPEN c_get_per_ethnicity; 
                 FETCH c_get_per_ethnicity BULK COLLECT INTO g_per_data;
                 CLOSE c_get_per_ethnicity;


                 IF g_per_data.COUNT > 0 THEN
                   -- Write the Business Entity header
                     xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'T',cv_per_ethnicity,NULL,'M');
                 END IF;

                 FOR i IN 1..g_per_data.COUNT LOOP
                     xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'D',cv_per_ethnicity,g_per_data(i),'M');
                 END LOOP; 
                 g_per_data.DELETE;
                 commit;  


               -- Worker Legislative Data
                  OPEN c_get_per_legis_data;
                 FETCH c_get_per_legis_data BULK COLLECT INTO g_per_data;
                 CLOSE c_get_per_legis_data;

                 IF g_per_data.COUNT > 0 THEN
                   -- Write the Business Entity header
                     xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'T',cv_per_legistlation,NULL,'M');
                 END IF;

                 FOR i IN 1..g_per_data.COUNT LOOP
                     xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'D',cv_per_legistlation,g_per_data(i),'M');
                 END LOOP; 
                 g_per_data.DELETE;
                 commit;


                 -- Worker Address
                  OPEN c_get_per_address; 
                 FETCH c_get_per_address BULK COLLECT INTO g_per_data; 
                 CLOSE c_get_per_address;

                 IF g_per_data.COUNT > 0 THEN
                   -- Write the Business Entity header
                     xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'T',cv_per_address,NULL,'M');
                 END IF;

                 FOR i IN 1..g_per_data.COUNT LOOP
                     xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'D',cv_per_address,g_per_data(i),'M');
                 END LOOP; 
                 g_per_data.DELETE;
                 commit;
                 --
                 --
                 -- Worker Phone
                  OPEN c_get_per_phone; 
                 FETCH c_get_per_phone BULK COLLECT INTO g_per_data;
                 CLOSE c_get_per_phone;

                 IF g_per_data.COUNT > 0 THEN
                   -- Write the Business Entity header
                     xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'T',cv_per_phone,NULL,'M');
                 END IF;

                 FOR i IN 1..g_per_data.COUNT LOOP
                     xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'D',cv_per_phone,g_per_data(i),'M');
                 END LOOP; 
                 g_per_data.DELETE;
            commit;
                 --
                 --
                 -- Worker Email
                  OPEN c_get_per_email; 
                 FETCH c_get_per_email BULK COLLECT INTO g_per_data;
                 CLOSE c_get_per_email;

                 IF g_per_data.COUNT > 0 THEN
                  -- Write the Business Entity header
                     xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'T',cv_per_email,NULL,'M');
                 END IF;

                 FOR i IN 1..g_per_data.COUNT LOOP
                     xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'D',cv_per_email,g_per_data(i),'M');
                 END LOOP; 
                 g_per_data.DELETE;
            commit;
                 --
                 --
                 -- Worker National Identifier
                  OPEN c_get_per_national_id; 
                 FETCH c_get_per_national_id BULK COLLECT INTO g_per_data; 
                 CLOSE c_get_per_national_id;

                 IF g_per_data.COUNT > 0 THEN
                   -- Write the Business Entity header
                     xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'T',cv_per_nat_ident,NULL,'M');
                 END IF;

                 FOR i IN 1..g_per_data.COUNT LOOP
                     xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'D',cv_per_nat_ident,g_per_data(i),'M');
                 END LOOP; 
                 g_per_data.DELETE;
            commit;
                 --
                 --
                 -- Worker Citizenship
                  OPEN c_get_per_citizenship; 
                 FETCH c_get_per_citizenship BULK COLLECT INTO g_per_data;
                 CLOSE c_get_per_citizenship;

                 IF g_per_data.COUNT > 0 THEN
                   -- Write the Business Entity header
                     xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'T',cv_per_Citizenship,NULL,'M');
                 END IF;

                 FOR i IN 1..g_per_data.COUNT LOOP
                     xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'D',cv_per_Citizenship,g_per_data(i),'M');
                 END LOOP; 
                 g_per_data.DELETE;
            commit;                 
                 --
                 --
                 -- Worker Passport
                 OPEN c_get_per_passport; 
                 FETCH c_get_per_passport BULK COLLECT INTO g_per_data;
                 CLOSE c_get_per_passport;

                 IF g_per_data.COUNT > 0 THEN
                   -- Write the Business Entity header
                     xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'T',cv_per_passport,NULL,'M');
                 END IF;

                 FOR i IN 1..g_per_data.COUNT LOOP
                     xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'D',cv_per_passport,g_per_data(i),'M');
                 END LOOP; 
                 g_per_data.DELETE;
            commit;
				--
				--
				-- Worker Religion
                 OPEN c_get_per_religion; 
                 FETCH c_get_per_religion BULK COLLECT INTO g_per_data;
                 CLOSE c_get_per_religion;

                 IF g_per_data.COUNT > 0 THEN
                   -- Write the Business Entity header
                     xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'T',cv_per_religion,NULL,'M');
                 END IF;

                 FOR i IN 1..g_per_data.COUNT LOOP
                     xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'D',cv_per_religion,g_per_data(i),'M');
                 END LOOP; 
                 g_per_data.DELETE;
            commit;

                --Person Visa
                OPEN c_get_per_visa; 
                FETCH c_get_per_visa BULK COLLECT INTO g_per_data;
                CLOSE c_get_per_visa;

                 IF g_per_data.COUNT > 0 THEN
                   -- Write the Business Entity header
                     xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'T',cv_per_visa,NULL,'M');
                 END IF;

                 FOR i IN 1..g_per_data.COUNT LOOP
                     xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'D',cv_per_visa,g_per_data(i),'M');
                 END LOOP; 
                 g_per_data.DELETE;
                commit;

               -- Work Relationship
                 OPEN c_per_work_relation; 
                 FETCH c_per_work_relation BULK COLLECT INTO g_per_data; 
                 CLOSE c_per_work_relation;

                 IF g_per_data.COUNT > 0 THEN
                   -- Write the Business Entity header
                     xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'T',cv_wrk_relation,NULL,'M');
                 END IF;

                 FOR i IN 1..g_per_data.COUNT LOOP
                     xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'D',cv_wrk_relation,g_per_data(i),'M');
                 END LOOP; 
                 g_per_data.DELETE;
            commit;

               -- Work Terms
                 OPEN c_per_workterms; 
                 FETCH c_per_workterms BULK COLLECT INTO g_per_data; 
                 CLOSE c_per_workterms;
                   IF g_per_data.COUNT > 0 THEN
                   -- Write the Business Entity header
                     xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'T',cv_wrk_terms,NULL,'M');
                 END IF;

                 FOR i IN 1..g_per_data.COUNT LOOP
                     xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'D',cv_wrk_terms,g_per_data(i),'M');
                 END LOOP; 
                 g_per_data.DELETE;
                commit;

                -- Worker Assignment
                 OPEN c_per_assignment; 
                 FETCH c_per_assignment BULK COLLECT INTO g_per_data; 
                 CLOSE c_per_assignment;

                 IF g_per_data.COUNT > 0 THEN
                   -- Write the Business Entity header
                     xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'T',cv_work_assignment,NULL,'M');
                 END IF;

                 FOR i IN 1..g_per_data.COUNT LOOP
                     xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'D',cv_work_assignment,g_per_data(i),'M');
                 END LOOP; 
                 g_per_data.DELETE;
                 --
                 --  
                commit;
                 --
                 -- CLOSE the file handler
                  --  xxmx_hdl_utilities_pkg.CLOSE_hdl;
 --
  END gen_worker_hire_file;

     /*****************************************
     ** PROCEDURE: gen_worker_current_file
     ******************************************/
	PROCEDURE gen_worker_current_file
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_migration_metadata.business_entity%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    ,pt_i_FileName                   IN      xxmx_migration_metadata.data_file_name%TYPE                    
                   )
     IS
          --
          --
          /**********************
          ** CURSOR Declarations
          ***********************/
           -- Worker WorkTerms
               /*CURSOR c_per_workterms IS
                     SELECT  DISTINCT 
                           wa.asg_work_terms_assignment_id||gv_delim  -- Assignment Number
                         ||wa.asg_work_terms_assignment_id||gv_delim  -- Assignment Name
                         ||'EBS'||gv_delim          -- SourceSystemId
                         ||'Workterms-'||wa.asg_work_terms_assignment_id||gv_delim
                         ||'WorkRelationship-'||fs.person_number||gv_delim
                         ||'Worker-'||fs.person_number||gv_delim
                         ||wa.asg_effective_start_date||gv_delim
                         ||wa.asg_effective_end_date||gv_delim
                         ||fs.person_number||gv_delim
                         ||wa.asg_effective_sequence||gv_delim 
                         ||'Y'||gv_delim -- Placeholder default
                         ||wa.pps_start_date||gv_delim
                         ||'ASG_CHANGE'||gv_delim
                         ||''||gv_delim
                         ||NVL(wa.asg_assignment_status_type,'ACTIVE_PROCESS')||gv_delim
                       --  ||DECODE(NVL(wa.asg_assignment_status_type_id,'ACTIVE_ASSIGN'),'ACTIVE_ASSIGN',1,2)||gv_delim
                         ||DECODE(SUBSTR(wa.asg_work_terms_assignment_id,1,2),'ET','ET','CT','CT','ET')||gv_delim
                         ||RTRIM(wa.asg_business_unit_name)||gv_delim  --BusinessUnitShortCode <<BLNK>>
                         ||''||gv_delim   -- ||RTRIM(wa.asg_legal_employer_name) --TaxReportingUnit <<BLANK>>
                         ||wa.asg_people_group_name||gv_delim
                         ||wa.asg_grade_ladder_pgm_name
                     FROM XXMX_HR_HCM_WORK_ASSIGN_V wa,
                          XXMX_HR_HCM_FILE_SET_V1 fs
                    WHERE fs.person_id = wa.asg_person_id
                      AND  UPPER(fs.action_code) = UPPER(wa.asg_action_code) 
                      AND fs.assignment_number  = wa.asg_assignment_number
                      AND UPPER(fs.action_code) = 'CURRENT'
                      AND wa.asg_effective_start_date IS NOT NULL
                      order by 1; */

                CURSOR c_per_workterms IS
               WITH WRK_DEDUPE AS
				(
					SELECT DISTINCT 
						p.NID_NATIONAL_IDENTIFIER_NUMBER
						, p.PPS_PERSON_NUMBER
						, p.PERSON_ID
						, p.PPS_START_DATE
						, p.pns_legislation_code
						, RANK() OVER(PARTITION BY p.NID_NATIONAL_IDENTIFIER_NUMBER ORDER BY p.PPS_START_DATE) RANKING
					FROM XXMX_HR_HCM_PERSON_V p
						, XXMX_HR_HCM_FILE_SET_V1 fs
					WHERE fs.person_id = p.person_id
						AND UPPER(fs.action_code) = 'HIRE'
						AND p.NID_NATIONAL_IDENTIFIER_NUMBER IN (SELECT NID_NATIONAL_IDENTIFIER_NUMBER 
															FROM XXMX_HR_HCM_PERSON_V
															GROUP BY NID_NATIONAL_IDENTIFIER_NUMBER
															HAVING COUNT(*) > 1)
						AND EXISTS (SELECT 1 FROM XXMX_HR_HCM_PERSON_V p2 
									WHERE p2.NID_NATIONAL_IDENTIFIER_NUMBER = p.NID_NATIONAL_IDENTIFIER_NUMBER 
										AND p2.PPS_PERSON_NUMBER <> p.PPS_PERSON_NUMBER)
				),
				WRK_NUMBER AS
				(
					SELECT DISTINCT 
						p.NID_NATIONAL_IDENTIFIER_NUMBER
						, p.PPS_PERSON_NUMBER
						, p.PERSON_ID
						, wk.PPS_PERSON_NUMBER WK_PERSON_NUMBER
						, p.PPS_START_DATE
						, RANK() OVER(PARTITION BY p.NID_NATIONAL_IDENTIFIER_NUMBER ORDER BY p.PPS_START_DATE) RANKING
					FROM XXMX_HR_HCM_PERSON_V p
						, (SELECT * FROM WRK_DEDUPE WHERE RANKING = 1) wk
					WHERE p.NID_NATIONAL_IDENTIFIER_NUMBER = wk.NID_NATIONAL_IDENTIFIER_NUMBER
				)
				SELECT  DISTINCT 
					wa.asg_work_terms_assignment_id||gv_delim  -- Assignment Number
					||wa.asg_work_terms_assignment_id||gv_delim  -- Assignment Name
					||'EBS'||gv_delim          -- SourceSystemId
					||'Workterms-'||wa.asg_work_terms_assignment_id||gv_delim
					||'WorkRelationship-'||fs.person_number||gv_delim
					||'Worker-'||NVL(wrk.WK_PERSON_NUMBER, fs.PERSON_NUMBER)||gv_delim
					||wa.asg_effective_start_date||gv_delim
					||wa.asg_effective_end_date||gv_delim
					||NVL(wrk.WK_PERSON_NUMBER, fs.PERSON_NUMBER)||gv_delim
					||wa.asg_effective_sequence||gv_delim 
					||'Y'||gv_delim -- Placeholder default
					||wa.pps_start_date||gv_delim
					||'ASG_CHANGE'||gv_delim
					||''||gv_delim
					||NVL(wa.asg_assignment_status_type,'ACTIVE_PROCESS')||gv_delim
					-- ||DECODE(NVL(wa.asg_assignment_status_type_id,'ACTIVE_ASSIGN'),'ACTIVE_ASSIGN',1,2)||gv_delim
					||DECODE(SUBSTR(wa.asg_work_terms_assignment_id,1,2),'ET','ET','CT','CT','ET')||gv_delim
					||RTRIM(wa.asg_business_unit_name)||gv_delim  --BusinessUnitShortCode <<BLNK>>
					||''||gv_delim   -- ||RTRIM(wa.asg_legal_employer_name) --TaxReportingUnit <<BLANK>>
					||wa.asg_people_group_name||gv_delim
					||wa.asg_grade_ladder_pgm_name
				FROM XXMX_HR_HCM_WORK_ASSIGN_V wa,
					XXMX_HR_HCM_FILE_SET_V1 fs,
					WRK_NUMBER wrk
				WHERE fs.person_id = wa.asg_person_id
					AND  UPPER(fs.action_code) = UPPER(wa.asg_action_code) 
					AND fs.assignment_number  = wa.asg_assignment_number
					AND UPPER(fs.action_code) = 'CURRENT'
					AND wa.asg_effective_start_date IS NOT NULL
					AND wa.asg_person_id = wrk.PERSON_ID (+)
				ORDER BY 1;

               -- ASSIGNMENT
               /* CURSOR c_per_assignment IS
			   --'WorkTermsAssignmentId(SourceSystemId)|PeriodOfServiceId(SourceSystemId)|PersonId(SourceSystemId)|EffectiveStartDate|EffectiveEndDate|PersonNumber|EffectiveSequence|EffectiveLatestChange|DateStart|ActionCode|ReasonCode|WorkerType|LegalEmployerName|PrimaryAssignmentFlag|AssignmentStatusTypeCode|BusinessUnitShortCode|AssignmentType|PersonTypeCode|WorkerCategory|AssignmentCategory|FullPartTime|DateProbationEnd|NormalHours|Frequency|PermanentTemporary|JobCode|LocationCode|DepartmentName|NoticePeriod|NoticePeriodUOM|PrimaryFlag|HourlySalariedCode|PositionCode|GradeCode|BargainingUnitCode|LabourUnionMemberFlag|ManagerFlag|SystemPersonType|TaxReportingUnit';
                  SELECT  DISTINCT 
                           fs.assignment_number||gv_delim -- Assignment Number
                         ||fs.assignment_number||gv_delim -- Assignment Name
                         ||wa.asg_work_terms_assignment_id||gv_delim   
                         ||'EBS'||gv_delim          -- SourceSystemId
                         ||'Assignment-'||fs.assignment_number||gv_delim                          
                         ||'Workterms-'||wa.asg_work_terms_assignment_id||gv_delim                           
                         ||'WorkRelationship-'||fs.person_number||gv_delim
                         ||'Worker-'||fs.person_number||gv_delim
                         ||wa.asg_effective_start_date||gv_delim
                         ||wa.asg_effective_end_date||gv_delim
                         ||fs.person_number||gv_delim
                         ||wa.asg_effective_sequence||gv_delim 
                         ||wa.asg_Primary_assignment_flag||gv_delim --  ||'Y'||gv_delim -- Placeholder default
                         ||wa.pps_start_date||gv_delim   
                         ||'ASG_CHANGE'||gv_delim
                         ||''||gv_delim
                         ||DECODE(wa.asg_system_person_type,'CWK','C',wa.asg_proposed_worker_type)||gv_delim      -- worker type
                         ||RTRIM(wa.asg_legal_employer_name)||gv_delim
                         ||wa.asg_primary_assignment_flag||gv_delim    -- should be 'Y'
                         ||wa.asg_assignment_status_type||gv_delim
                        -- ||DECODE(wa.asg_assignment_status_type_id,'ACTIVE_ASSIGN',1,2)||gv_delim  -- ACTIVE_ASSIGN 1 TERM_ASSIGN  2
                         ||RTRIM(wa.asg_business_unit_name)||gv_delim    --||RTRIM(business_unit_name)||gv_delim Busness Unit Short Code
                         ||wa.asg_assignment_type||gv_delim
                         ||wa.asg_person_type_id||gv_delim
                         --||wa.asg_employee_category||gv_delim  -- WORKER CATEGORY
						       ||wa.asg_workercategory||gv_delim  -- WORKER CATEGORY		- Kirti
						       ||wa.asg_employment_category||gv_delim  -- EMPLOYMENT CATEGORY  - Kirti
                         ||decode (wa.asg_employment_category,'FR','FULL_TIME','PR','PART_TIME','')||gv_delim
                         ||wa.asg_DATE_PROBATION_END||gv_delim
                         ||wa.asg_NORMAL_HOURS||gv_delim
                         ||wa.asg_FREQUENCY||gv_delim
                         ||decode (wa.asg_system_person_type,'EMP','R','T')||gv_delim   -- PermanentTemporary
                         ||wa.asg_job_code||gv_delim   
                         ||wa.asg_location_code||gv_delim 
                         ||wa.asg_organization_id||gv_delim         -- DepartmentName
                         ||wa.asg_notice_period||gv_delim
                         ||wa.asg_notice_period_uom||gv_delim
                         ||wa.asg_primary_flag||gv_delim  
                         ||wa.asg_hourly_salaried_code||gv_delim 
                         ||wa.asg_position_code||gv_delim 
                         ||wa.asg_grade_code||gv_delim    
                         ||wa.asg_bargaining_unit_code||gv_delim         
                         ||wa.asg_labour_union_member_flag||gv_delim 
                         ||wa.asg_manager_flag||gv_delim  
                         ||DECODE(wa.asg_system_person_type,'EX_EMP','EMP',wa.asg_system_person_type)||gv_delim  
                         ||RTRIM(wa.asg_legal_employer_name)||gv_delim 
                         ||wa.asg_people_group_name||gv_delim
                         ||wa.asg_grade_ladder_pgm_name||gv_delim
                         ||wa.asg_establishment_id||gv_delim
                         ||wa.default_expense_account||gv_delim -- Default Exepnse Account 1.26
                         ||wa.asg_position_override_flag -- postion_override_flag
                      FROM XXMX_HR_HCM_WORK_ASSIGN_V wa,
                           XXMX_HR_HCM_FILE_SET_V1 fs
                     WHERE fs.person_id = wa.asg_person_id
                       AND fs.assignment_number  = wa.asg_assignment_number
                       AND UPPER(fs.action_code) = UPPER(asg_action_code)
                       AND UPPER(fs.action_code) = 'CURRENT'
                       AND asg_effective_start_date IS NOT NULL
                       order by 1; */

                CURSOR c_per_assignment IS
			   --'WorkTermsAssignmentId(SourceSystemId)|PeriodOfServiceId(SourceSystemId)|PersonId(SourceSystemId)|EffectiveStartDate|EffectiveEndDate|PersonNumber|EffectiveSequence|EffectiveLatestChange|DateStart|ActionCode|ReasonCode|WorkerType|LegalEmployerName|PrimaryAssignmentFlag|AssignmentStatusTypeCode|BusinessUnitShortCode|AssignmentType|PersonTypeCode|WorkerCategory|AssignmentCategory|FullPartTime|DateProbationEnd|NormalHours|Frequency|PermanentTemporary|JobCode|LocationCode|DepartmentName|NoticePeriod|NoticePeriodUOM|PrimaryFlag|HourlySalariedCode|PositionCode|GradeCode|BargainingUnitCode|LabourUnionMemberFlag|ManagerFlag|SystemPersonType|TaxReportingUnit';
               WITH WRK_DEDUPE AS
				(
					SELECT DISTINCT 
						p.NID_NATIONAL_IDENTIFIER_NUMBER
						, p.PPS_PERSON_NUMBER
						, p.PERSON_ID
						, p.PPS_START_DATE
						, p.pns_legislation_code
						, RANK() OVER(PARTITION BY p.NID_NATIONAL_IDENTIFIER_NUMBER ORDER BY p.PPS_START_DATE) RANKING
					FROM XXMX_HR_HCM_PERSON_V p
						, XXMX_HR_HCM_FILE_SET_V1 fs
					WHERE fs.person_id = p.person_id
						AND UPPER(fs.action_code) = 'HIRE'
						AND p.NID_NATIONAL_IDENTIFIER_NUMBER IN (SELECT NID_NATIONAL_IDENTIFIER_NUMBER 
															FROM XXMX_HR_HCM_PERSON_V
															GROUP BY NID_NATIONAL_IDENTIFIER_NUMBER
															HAVING COUNT(*) > 1)
						AND EXISTS (SELECT 1 FROM XXMX_HR_HCM_PERSON_V p2 
									WHERE p2.NID_NATIONAL_IDENTIFIER_NUMBER = p.NID_NATIONAL_IDENTIFIER_NUMBER 
										AND p2.PPS_PERSON_NUMBER <> p.PPS_PERSON_NUMBER)
				),
				WRK_NUMBER AS
				(
					SELECT DISTINCT 
						p.NID_NATIONAL_IDENTIFIER_NUMBER
						, p.PPS_PERSON_NUMBER
						, p.PERSON_ID
						, wk.PPS_PERSON_NUMBER WK_PERSON_NUMBER
						, p.PPS_START_DATE
						, RANK() OVER(PARTITION BY p.NID_NATIONAL_IDENTIFIER_NUMBER ORDER BY p.PPS_START_DATE) RANKING
					FROM XXMX_HR_HCM_PERSON_V p
						, (SELECT * FROM WRK_DEDUPE WHERE RANKING = 1) wk
					WHERE p.NID_NATIONAL_IDENTIFIER_NUMBER = wk.NID_NATIONAL_IDENTIFIER_NUMBER
				)
				SELECT  DISTINCT 
					fs.assignment_number||gv_delim -- Assignment Number
					||fs.assignment_number||gv_delim -- Assignment Name
					||wa.asg_work_terms_assignment_id||gv_delim   
					||'EBS'||gv_delim          -- SourceSystemId
					||'Assignment-'||fs.assignment_number||gv_delim                          
					||'Workterms-'||wa.asg_work_terms_assignment_id||gv_delim                           
					||'WorkRelationship-'||fs.person_number||gv_delim
					||'Worker-'||NVL(wrk.WK_PERSON_NUMBER, fs.PERSON_NUMBER)||gv_delim
					||wa.asg_effective_start_date||gv_delim
					||wa.asg_effective_end_date||gv_delim
					||NVL(wrk.WK_PERSON_NUMBER, fs.PERSON_NUMBER)||gv_delim
					||wa.asg_effective_sequence||gv_delim 
					||wa.asg_Primary_assignment_flag||gv_delim --  ||'Y'||gv_delim -- Placeholder default
					||wa.pps_start_date||gv_delim   
					||'ASG_CHANGE'||gv_delim
					||''||gv_delim
					||DECODE(wa.asg_system_person_type,'CWK','C',wa.asg_proposed_worker_type)||gv_delim      -- worker type
					||RTRIM(wa.asg_legal_employer_name)||gv_delim
					||wa.asg_primary_assignment_flag||gv_delim    -- should be 'Y'
					||wa.asg_assignment_status_type||gv_delim
					-- ||DECODE(wa.asg_assignment_status_type_id,'ACTIVE_ASSIGN',1,2)||gv_delim  -- ACTIVE_ASSIGN 1 TERM_ASSIGN  2
					||RTRIM(wa.asg_business_unit_name)||gv_delim    --||RTRIM(business_unit_name)||gv_delim Busness Unit Short Code
					||wa.asg_assignment_type||gv_delim
					||wa.asg_person_type_id||gv_delim
					--||wa.asg_employee_category||gv_delim  -- WORKER CATEGORY
					||wa.asg_workercategory||gv_delim  -- WORKER CATEGORY		- Kirti
					||wa.asg_employment_category||gv_delim  -- EMPLOYMENT CATEGORY  - Kirti
					||decode (wa.asg_employment_category,'FR','FULL_TIME','PR','PART_TIME','')||gv_delim
					||wa.asg_DATE_PROBATION_END||gv_delim
					||wa.asg_NORMAL_HOURS||gv_delim
					||wa.asg_FREQUENCY||gv_delim
					||decode (wa.asg_system_person_type,'EMP','R','T')||gv_delim   -- PermanentTemporary
					||wa.asg_job_code||gv_delim   
					||wa.asg_location_code||gv_delim 
					||wa.asg_organization_id||gv_delim         -- DepartmentName
					||wa.asg_notice_period||gv_delim
					||wa.asg_notice_period_uom||gv_delim
					--||wa.asg_primary_flag||gv_delim
                    ||CASE 
						WHEN NVL(wrk.RANKING, 1) = 1 THEN wa.asg_primary_flag
						ELSE 'N'
					END||gv_delim
					||wa.asg_hourly_salaried_code||gv_delim 
					||wa.asg_position_code||gv_delim 
					||wa.asg_grade_code||gv_delim    
					||wa.asg_bargaining_unit_code||gv_delim         
					||wa.asg_labour_union_member_flag||gv_delim 
					||wa.asg_manager_flag||gv_delim  
					||DECODE(wa.asg_system_person_type,'EX_EMP','EMP',wa.asg_system_person_type)||gv_delim  
					||RTRIM(wa.asg_legal_employer_name)||gv_delim 
					||wa.asg_people_group_name||gv_delim
					||wa.asg_grade_ladder_pgm_name||gv_delim
					||wa.asg_establishment_id||gv_delim
					||wa.default_expense_account||gv_delim -- Default Exepnse Account 1.26
					||wa.asg_position_override_flag -- postion_override_flag
				FROM XXMX_HR_HCM_WORK_ASSIGN_V wa,
					XXMX_HR_HCM_FILE_SET_V1 fs,
					WRK_NUMBER wrk
				WHERE fs.person_id = wa.asg_person_id
					AND fs.assignment_number  = wa.asg_assignment_number
					AND UPPER(fs.action_code) = UPPER(asg_action_code)
					AND UPPER(fs.action_code) = 'CURRENT'
					AND asg_effective_start_date IS NOT NULL
					AND wa.asg_person_id = wrk.PERSON_ID (+)
				ORDER BY 1;


				/* CURSOR c_per_assign_ins IS
                  SELECT  DISTINCT 
                           fs.assignment_number||gv_delim -- Assignment Number
                         ||fs.assignment_number||gv_delim -- Assignment Name
                         ||wa.asg_work_terms_assignment_id||gv_delim   
                         ||'EBS'||gv_delim          -- SourceSystemId
                         ||'Assignment-'||fs.assignment_number||gv_delim                          
                         ||'Workterms-'||wa.asg_work_terms_assignment_id||gv_delim                           
                         ||'WorkRelationship-'||fs.person_number||gv_delim
                         ||'Worker-'||fs.person_number||gv_delim
                         ||wa.asg_effective_start_date||gv_delim
                         ||wa.asg_effective_end_date||gv_delim
                         ||fs.person_number||gv_delim
                         ||wa.asg_effective_sequence||gv_delim 
                         ||wa.asg_Primary_assignment_flag||gv_delim --  ||'Y'||gv_delim -- Placeholder default
                         ||wa.pps_start_date||gv_delim   
                         ||'ASG_CHANGE'||gv_delim
                         ||''||gv_delim
                         ||DECODE(wa.asg_system_person_type,'CWK','C',wa.asg_proposed_worker_type)||gv_delim      -- worker type
                         ||RTRIM(wa.asg_legal_employer_name)||gv_delim
                         ||wa.asg_primary_assignment_flag||gv_delim    -- should be 'Y'
                         ||wa.asg_assignment_status_type||gv_delim
                        -- ||DECODE(wa.asg_assignment_status_type_id,'ACTIVE_ASSIGN',1,2)||gv_delim  -- ACTIVE_ASSIGN 1 TERM_ASSIGN  2
                         ||RTRIM(wa.asg_business_unit_name)||gv_delim    --||RTRIM(business_unit_name)||gv_delim Busness Unit Short Code
                         ||wa.asg_assignment_type||gv_delim
                         ||wa.asg_person_type_id||gv_delim
                         --||wa.asg_employee_category||gv_delim  -- WORKER CATEGORY
                         ||wa.asg_workercategory||gv_delim  -- WORKER CATEGORY  - Kirti
						       ||wa.asg_employment_category||gv_delim  -- EMPLOYMENT CATEGORY   - Kirti
                         ||decode (wa.asg_employment_category,'FR','FULL_TIME','PR','PART_TIME','')||gv_delim
                         ||wa.asg_DATE_PROBATION_END||gv_delim
                         ||wa.asg_NORMAL_HOURS||gv_delim
                         ||wa.asg_FREQUENCY||gv_delim
                         ||decode (wa.asg_system_person_type,'EMP','R','T')||gv_delim   -- PermanentTemporary
                         ||wa.asg_job_code||gv_delim   
                         ||wa.asg_location_code||gv_delim 
                         ||wa.asg_organization_id||gv_delim         -- DepartmentName
                         ||wa.asg_notice_period||gv_delim
                         ||wa.asg_notice_period_uom||gv_delim
                         ||wa.asg_primary_flag||gv_delim  
                         ||wa.asg_hourly_salaried_code||gv_delim 
                         ||wa.asg_position_code||gv_delim 
                         ||wa.asg_grade_code||gv_delim    
                         ||wa.asg_bargaining_unit_code||gv_delim         
                         ||wa.asg_labour_union_member_flag||gv_delim 
                         ||wa.asg_manager_flag||gv_delim  
                         ||DECODE(wa.asg_system_person_type,'EX_EMP','EMP',wa.asg_system_person_type)||gv_delim  
                         ||RTRIM(wa.asg_legal_employer_name)||gv_delim 
                         ||wa.asg_people_group_name||gv_delim 
                         ||wa.asg_grade_ladder_pgm_name||gv_delim
                         ||wa.asg_establishment_id||gv_delim   -- REPORTING ESTABLISHMENT ADDED BY KIRTI
                         ||wa.default_expense_account||gv_delim -- Default Expense Account 1.26
                         ||wa.asg_position_override_flag||gv_delim-- postion_override_flag
                         -- Pradeep-Added DFF headers - Change to Attribute fields
                         ||'Global Data Elements'||gv_delim
                         ||wa.ASS_ATTRIBUTE1||gv_delim 
                         ||wa.ASS_ATTRIBUTE2||gv_delim 
                         ||wa.ASS_ATTRIBUTE_DATE1||gv_delim 
                         ||wa.ASS_ATTRIBUTE_DATE2||gv_delim 
                         ||wa.ASS_ATTRIBUTE3||gv_delim
                         ||DECODE(wa.ASS_ATTRIBUTE_NUMBER1,0,'',wa.ASS_ATTRIBUTE_NUMBER1)||gv_delim 
                         ||wa.ASS_ATTRIBUTE4||gv_delim 
                         ||wa.ASS_ATTRIBUTE5||gv_delim 
                         ||wa.ASS_ATTRIBUTE_DATE3||gv_delim 
                         ||wa.ASS_ATTRIBUTE6
					FROM XXMX_HR_HCM_WORK_ASSIGN_V wa,
                           XXMX_HR_HCM_FILE_SET_V1 fs
                     WHERE fs.person_id = wa.asg_person_id
                       AND fs.assignment_number  = wa.asg_assignment_number
                       AND UPPER(fs.action_code) = UPPER(asg_action_code)
                       AND UPPER(fs.action_code) = 'CURRENT'
                       AND asg_effective_start_date IS NOT NULL
                       order by 1; */

                CURSOR c_per_assign_ins IS
                WITH WRK_DEDUPE AS
				(
					SELECT DISTINCT 
						p.NID_NATIONAL_IDENTIFIER_NUMBER
						, p.PPS_PERSON_NUMBER
						, p.PERSON_ID
						, p.PPS_START_DATE
						, p.pns_legislation_code
						, RANK() OVER(PARTITION BY p.NID_NATIONAL_IDENTIFIER_NUMBER ORDER BY p.PPS_START_DATE) RANKING
					FROM XXMX_HR_HCM_PERSON_V p
						, XXMX_HR_HCM_FILE_SET_V1 fs
					WHERE fs.person_id = p.person_id
						AND UPPER(fs.action_code) = 'HIRE'
						AND p.NID_NATIONAL_IDENTIFIER_NUMBER IN (SELECT NID_NATIONAL_IDENTIFIER_NUMBER 
															FROM XXMX_HR_HCM_PERSON_V
															GROUP BY NID_NATIONAL_IDENTIFIER_NUMBER
															HAVING COUNT(*) > 1)
						AND EXISTS (SELECT 1 FROM XXMX_HR_HCM_PERSON_V p2 
									WHERE p2.NID_NATIONAL_IDENTIFIER_NUMBER = p.NID_NATIONAL_IDENTIFIER_NUMBER 
										AND p2.PPS_PERSON_NUMBER <> p.PPS_PERSON_NUMBER)
				),
				WRK_NUMBER AS
				(
					SELECT DISTINCT 
						p.NID_NATIONAL_IDENTIFIER_NUMBER
						, p.PPS_PERSON_NUMBER
						, p.PERSON_ID
						, wk.PPS_PERSON_NUMBER WK_PERSON_NUMBER
						, p.PPS_START_DATE
						, RANK() OVER(PARTITION BY p.NID_NATIONAL_IDENTIFIER_NUMBER ORDER BY p.PPS_START_DATE) RANKING
					FROM XXMX_HR_HCM_PERSON_V p
						, (SELECT * FROM WRK_DEDUPE WHERE RANKING = 1) wk
					WHERE p.NID_NATIONAL_IDENTIFIER_NUMBER = wk.NID_NATIONAL_IDENTIFIER_NUMBER
				)
				SELECT  DISTINCT 
					fs.assignment_number||gv_delim -- Assignment Number
					||fs.assignment_number||gv_delim -- Assignment Name
					||wa.asg_work_terms_assignment_id||gv_delim   
					||'EBS'||gv_delim          -- SourceSystemId
					||'Assignment-'||fs.assignment_number||gv_delim                          
					||'Workterms-'||wa.asg_work_terms_assignment_id||gv_delim                           
					||'WorkRelationship-'||fs.person_number||gv_delim
					||'Worker-'||NVL(wrk.WK_PERSON_NUMBER, fs.PERSON_NUMBER)||gv_delim
					||wa.asg_effective_start_date||gv_delim
					||wa.asg_effective_end_date||gv_delim
					||NVL(wrk.WK_PERSON_NUMBER, fs.PERSON_NUMBER)||gv_delim
					||wa.asg_effective_sequence||gv_delim 
					||wa.asg_Primary_assignment_flag||gv_delim --  ||'Y'||gv_delim -- Placeholder default
					||wa.pps_start_date||gv_delim   
					||'ASG_CHANGE'||gv_delim
					||''||gv_delim
					||DECODE(wa.asg_system_person_type,'CWK','C',wa.asg_proposed_worker_type)||gv_delim      -- worker type
					||RTRIM(wa.asg_legal_employer_name)||gv_delim
					||wa.asg_primary_assignment_flag||gv_delim    -- should be 'Y'
					||wa.asg_assignment_status_type||gv_delim
					-- ||DECODE(wa.asg_assignment_status_type_id,'ACTIVE_ASSIGN',1,2)||gv_delim  -- ACTIVE_ASSIGN 1 TERM_ASSIGN  2
					||RTRIM(wa.asg_business_unit_name)||gv_delim    --||RTRIM(business_unit_name)||gv_delim Busness Unit Short Code
					||wa.asg_assignment_type||gv_delim
					||wa.asg_person_type_id||gv_delim
					--||wa.asg_employee_category||gv_delim  -- WORKER CATEGORY
					||wa.asg_workercategory||gv_delim  -- WORKER CATEGORY  - Kirti
					||wa.asg_employment_category||gv_delim  -- EMPLOYMENT CATEGORY   - Kirti
					||decode (wa.asg_employment_category,'FR','FULL_TIME','PR','PART_TIME','')||gv_delim
					||wa.asg_DATE_PROBATION_END||gv_delim
					||wa.asg_NORMAL_HOURS||gv_delim
					||wa.asg_FREQUENCY||gv_delim
					||decode (wa.asg_system_person_type,'EMP','R','T')||gv_delim   -- PermanentTemporary
					||wa.asg_job_code||gv_delim   
					||wa.asg_location_code||gv_delim 
					||wa.asg_organization_id||gv_delim         -- DepartmentName
					||wa.asg_notice_period||gv_delim
					||wa.asg_notice_period_uom||gv_delim
					--||wa.asg_primary_flag||gv_delim
                    ||CASE 
						WHEN NVL(wrk.RANKING, 1) = 1 THEN wa.asg_primary_flag
						ELSE 'N'
					END||gv_delim
					||wa.asg_hourly_salaried_code||gv_delim 
					||wa.asg_position_code||gv_delim 
					||wa.asg_grade_code||gv_delim    
					||wa.asg_bargaining_unit_code||gv_delim         
					||wa.asg_labour_union_member_flag||gv_delim 
					||wa.asg_manager_flag||gv_delim  
					||DECODE(wa.asg_system_person_type,'EX_EMP','EMP',wa.asg_system_person_type)||gv_delim  
					||RTRIM(wa.asg_legal_employer_name)||gv_delim 
					||wa.asg_people_group_name||gv_delim 
					||wa.asg_grade_ladder_pgm_name||gv_delim
					||wa.asg_establishment_id||gv_delim   -- REPORTING ESTABLISHMENT ADDED BY KIRTI
					||wa.default_expense_account||gv_delim -- Default Expense Account 1.26
					||wa.asg_position_override_flag||gv_delim-- postion_override_flag
					-- Pradeep-Added DFF headers - Change to Attribute fields
					||'Global Data Elements'||gv_delim
					||wa.ASS_ATTRIBUTE1||gv_delim 
					||wa.ASS_ATTRIBUTE2||gv_delim 
					--||wa.ASS_ATTRIBUTE_DATE1||gv_delim 
                    ||TO_CHAR(wa.ASS_ATTRIBUTE_DATE1,'RRRR/MM/DD') ||gv_delim 
					--||wa.ASS_ATTRIBUTE_DATE2||gv_delim 
                    ||TO_CHAR(wa.ASS_ATTRIBUTE_DATE2,'RRRR/MM/DD') ||gv_delim 
					||wa.ASS_ATTRIBUTE3||gv_delim
					||DECODE(wa.ASS_ATTRIBUTE_NUMBER1,0,'',wa.ASS_ATTRIBUTE_NUMBER1)||gv_delim 
					||wa.ASS_ATTRIBUTE4||gv_delim 
					||wa.ASS_ATTRIBUTE5||gv_delim 
					--||wa.ASS_ATTRIBUTE_DATE3||gv_delim 
                    ||TO_CHAR(wa.ASS_ATTRIBUTE_DATE3,'RRRR/MM/DD') ||gv_delim 
					||wa.ASS_ATTRIBUTE6
				FROM XXMX_HR_HCM_WORK_ASSIGN_V wa,
					XXMX_HR_HCM_FILE_SET_V1 fs,
					WRK_NUMBER wrk
				WHERE fs.person_id = wa.asg_person_id
					AND fs.assignment_number  = wa.asg_assignment_number
					AND UPPER(fs.action_code) = UPPER(asg_action_code)
					AND UPPER(fs.action_code) = 'CURRENT'
					AND asg_effective_start_date IS NOT NULL
					AND wa.asg_person_id = wrk.PERSON_ID (+)
				ORDER BY 1;


                /* CURSOR c_per_assign_update IS
                  SELECT  DISTINCT 
                          fs.assignment_number||gv_delim -- Assignment Number
                         ||fs.assignment_number||gv_delim -- Assignment Name
                         ||wa.asg_work_terms_assignment_id||gv_delim     
                         ||'EBS'||gv_delim          -- SourceSystemId
                         ||'Assignment-'||fs.assignment_number||gv_delim                          
                         ||'Workterms-'||wa.asg_work_terms_assignment_id||gv_delim                           
                         ||'WorkRelationship-'||fs.person_number||gv_delim
                         ||'Worker-'||fs.person_number||gv_delim
                         ||wa.asg_effective_start_date||gv_delim
                         ||wa.asg_effective_end_date||gv_delim
                         ||fs.person_number||gv_delim
                         ||wa.asg_effective_sequence||gv_delim 
                         ||wa.asg_Primary_assignment_flag||gv_delim --  ||'Y'||gv_delim -- Placeholder default
                         ||wa.pps_start_date||gv_delim   
						 ||'ASG_CHANGE'||gv_delim
                         ||''||gv_delim
                         ||DECODE(wa.asg_system_person_type,'CWK','C',wa.asg_proposed_worker_type)||gv_delim      -- worker type
                         ||RTRIM(wa.asg_legal_employer_name)||gv_delim
                         ||wa.asg_primary_assignment_flag||gv_delim    -- should be 'Y'
                         ||wa.asg_assignment_status_type||gv_delim
                        -- ||DECODE(wa.asg_assignment_status_type_id,'ACTIVE_ASSIGN',1,2)||gv_delim  -- ACTIVE_ASSIGN 1 TERM_ASSIGN  2
                         ||RTRIM(wa.asg_business_unit_name)||gv_delim    --||RTRIM(business_unit_name)||gv_delim Busness Unit Short Code
						 ||wa.asg_assignment_type||gv_delim
						 ||wa.asg_workercategory||gv_delim  -- WORKER CATEGORY   - Kirti
						 ||wa.asg_employment_category||gv_delim  -- EMPLOYMENT CATEGORY   - Kirti
                         ||wa.asg_establishment_id||gv_delim -- REPORTING ESTABLISHMENT     - Kirti
                         ||wa.asg_position_override_flag||gv_delim
                         ||'Global Data Elements'||gv_delim
                   ||wa.ASS_ATTRIBUTE1||gv_delim 
						 ||wa.ASS_ATTRIBUTE2||gv_delim 
						 ||wa.ASS_ATTRIBUTE_DATE1||gv_delim 
						 ||wa.ASS_ATTRIBUTE_DATE2||gv_delim 
						 ||wa.ASS_ATTRIBUTE3||gv_delim
						 ||DECODE(wa.ASS_ATTRIBUTE_NUMBER1,0,'',wa.ASS_ATTRIBUTE_NUMBER1)||gv_delim 
						 ||wa.ASS_ATTRIBUTE4||gv_delim 
						 ||wa.ASS_ATTRIBUTE5||gv_delim 
						 ||wa.ASS_ATTRIBUTE_DATE3||gv_delim 
						 ||wa.ASS_ATTRIBUTE6 
					FROM XXMX_HR_HCM_WORK_ASSIGN_V wa,
                           XXMX_HR_HCM_FILE_SET_V1 fs
                     WHERE fs.person_id = wa.asg_person_id
                       AND fs.assignment_number  = wa.asg_assignment_number
                       AND UPPER(fs.action_code) = UPPER(asg_action_code)
                       AND UPPER(fs.action_code) = 'CURRENT'
                       AND asg_effective_start_date IS NOT NULL
                       order by 1; */

                CURSOR c_per_assign_update IS
                WITH WRK_DEDUPE AS
				(
					SELECT DISTINCT 
						p.NID_NATIONAL_IDENTIFIER_NUMBER
						, p.PPS_PERSON_NUMBER
						, p.PERSON_ID
						, p.PPS_START_DATE
						, p.pns_legislation_code
						, RANK() OVER(PARTITION BY p.NID_NATIONAL_IDENTIFIER_NUMBER ORDER BY p.PPS_START_DATE) RANKING
					FROM XXMX_HR_HCM_PERSON_V p
						, XXMX_HR_HCM_FILE_SET_V1 fs
					WHERE fs.person_id = p.person_id
						AND UPPER(fs.action_code) = 'HIRE'
						AND p.NID_NATIONAL_IDENTIFIER_NUMBER IN (SELECT NID_NATIONAL_IDENTIFIER_NUMBER 
															FROM XXMX_HR_HCM_PERSON_V
															GROUP BY NID_NATIONAL_IDENTIFIER_NUMBER
															HAVING COUNT(*) > 1)
						AND EXISTS (SELECT 1 FROM XXMX_HR_HCM_PERSON_V p2 
									WHERE p2.NID_NATIONAL_IDENTIFIER_NUMBER = p.NID_NATIONAL_IDENTIFIER_NUMBER 
										AND p2.PPS_PERSON_NUMBER <> p.PPS_PERSON_NUMBER)
				),
				WRK_NUMBER AS
				(
					SELECT DISTINCT 
						p.NID_NATIONAL_IDENTIFIER_NUMBER
						, p.PPS_PERSON_NUMBER
						, p.PERSON_ID
						, wk.PPS_PERSON_NUMBER WK_PERSON_NUMBER
						, p.PPS_START_DATE
						, RANK() OVER(PARTITION BY p.NID_NATIONAL_IDENTIFIER_NUMBER ORDER BY p.PPS_START_DATE) RANKING
					FROM XXMX_HR_HCM_PERSON_V p
						, (SELECT * FROM WRK_DEDUPE WHERE RANKING = 1) wk
					WHERE p.NID_NATIONAL_IDENTIFIER_NUMBER = wk.NID_NATIONAL_IDENTIFIER_NUMBER
				)
				SELECT  DISTINCT 
					fs.assignment_number||gv_delim -- Assignment Number
					||fs.assignment_number||gv_delim -- Assignment Name
					||wa.asg_work_terms_assignment_id||gv_delim     
					||'EBS'||gv_delim          -- SourceSystemId
					||'Assignment-'||fs.assignment_number||gv_delim                          
					||'Workterms-'||wa.asg_work_terms_assignment_id||gv_delim                           
					||'WorkRelationship-'||fs.person_number||gv_delim
					||'Worker-'||NVL(wrk.WK_PERSON_NUMBER, fs.PERSON_NUMBER)||gv_delim
					||wa.asg_effective_start_date||gv_delim
					||wa.asg_effective_end_date||gv_delim
					||NVL(wrk.WK_PERSON_NUMBER, fs.PERSON_NUMBER)||gv_delim
					||wa.asg_effective_sequence||gv_delim 
					||wa.asg_Primary_assignment_flag||gv_delim --  ||'Y'||gv_delim -- Placeholder default
					||wa.pps_start_date||gv_delim   
					||'ASG_CHANGE'||gv_delim
					||''||gv_delim
					||DECODE(wa.asg_system_person_type,'CWK','C',wa.asg_proposed_worker_type)||gv_delim      -- worker type
					||RTRIM(wa.asg_legal_employer_name)||gv_delim
					||wa.asg_primary_assignment_flag||gv_delim    -- should be 'Y'
					||wa.asg_assignment_status_type||gv_delim
					-- ||DECODE(wa.asg_assignment_status_type_id,'ACTIVE_ASSIGN',1,2)||gv_delim  -- ACTIVE_ASSIGN 1 TERM_ASSIGN  2
					||RTRIM(wa.asg_business_unit_name)||gv_delim    --||RTRIM(business_unit_name)||gv_delim Busness Unit Short Code
					||wa.asg_assignment_type||gv_delim
					||wa.asg_workercategory||gv_delim  -- WORKER CATEGORY   - Kirti
					||wa.asg_employment_category||gv_delim  -- EMPLOYMENT CATEGORY   - Kirti
					||wa.asg_establishment_id||gv_delim -- REPORTING ESTABLISHMENT     - Kirti
					||wa.asg_position_override_flag||gv_delim
					||'Global Data Elements'||gv_delim
					||wa.ASS_ATTRIBUTE1||gv_delim 
					||wa.ASS_ATTRIBUTE2||gv_delim 
					--||wa.ASS_ATTRIBUTE_DATE1||gv_delim 
                    ||TO_CHAR(wa.ASS_ATTRIBUTE_DATE1,'RRRR/MM/DD') ||gv_delim 
					--||wa.ASS_ATTRIBUTE_DATE2||gv_delim 
                    ||TO_CHAR(wa.ASS_ATTRIBUTE_DATE2,'RRRR/MM/DD') ||gv_delim 
					||wa.ASS_ATTRIBUTE3||gv_delim
					||DECODE(wa.ASS_ATTRIBUTE_NUMBER1,0,'',wa.ASS_ATTRIBUTE_NUMBER1)||gv_delim 
					||wa.ASS_ATTRIBUTE4||gv_delim 
					||wa.ASS_ATTRIBUTE5||gv_delim 
					--||wa.ASS_ATTRIBUTE_DATE3||gv_delim 
                    ||TO_CHAR(wa.ASS_ATTRIBUTE_DATE3,'RRRR/MM/DD') ||gv_delim                     
					||wa.ASS_ATTRIBUTE6 
				FROM XXMX_HR_HCM_WORK_ASSIGN_V wa,
					XXMX_HR_HCM_FILE_SET_V1 fs,
					WRK_NUMBER wrk
				WHERE fs.person_id = wa.asg_person_id
					AND fs.assignment_number  = wa.asg_assignment_number
					AND UPPER(fs.action_code) = UPPER(asg_action_code)
					AND UPPER(fs.action_code) = 'CURRENT'
					AND asg_effective_start_date IS NOT NULL
					AND wa.asg_person_id = wrk.PERSON_ID (+)
				ORDER BY 1;


               -- Assignment Grade Step      
               CURSOR c_get_asg_grade_steps IS
                    SELECT  DISTINCT 
                         fs.person_number
                         ||gv_delim||'Assignment-'||fs.assignment_number
                         ||gv_delim||fs.assignment_number
                         ||gv_delim||gs.gds_effective_start_date
                         ||gv_delim||gs.gds_effective_end_date
                         ||gv_delim||RTRIM(gds_gradestepname)
                         ||gv_delim||'ASG_CHANGE' --fs.action_code     -- ActionCode - Leave blank if value does not exist
                         ||gv_delim||NULL
                    FROM XXMX_HR_HCM_ASSIGN_GRADE_STEP_V gs,
                         XXMX_HR_HCM_FILE_SET_V1 fs
                   WHERE fs.person_id = gs.gds_person_id
                     AND gs.gds_assignment_number  = fs.assignment_number
                     AND  UPPER(fs.action_code) = 'CURRENT'
                     AND  gs.gds_effective_start_date IS NOT NULL
                     order by 1;

               -- Assignment Work Measure
               CURSOR c_get_work_measure IS
                    SELECT  DISTINCT 
                         fs.person_number||'-'||RTRIM(wm.wm_unit)
                         ||gv_delim||'Assignment-'||fs.assignment_number
                         ||gv_delim||wm.wm_effective_start_date
                         ||gv_delim||wm.wm_effective_end_date
                         ||gv_delim||RTRIM(wm.wm_unit)
                         ||gv_delim||wm.wm_value
                    FROM XXMX_HR_HCM_ASSIGN_WORK_MEAS_V wm,
                         XXMX_HR_HCM_FILE_SET_V1 fs
                   WHERE fs.person_id = wm.wm_person_id
                    AND  UPPER(fs.action_code) = 'CURRENT'
					and wm.wm_assignment_number =fs.assignment_number -- Condition added
                    AND  wm.wm_effective_start_date IS NOT NULL
                    order by 1;

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
          cv_ProcOrFuncName           CONSTANT  VARCHAR2(30)                                := 'gen_per_worker';
          ct_file_location_type       CONSTANT xxmx_file_locations.file_location_type%TYPE  := 'OIC_INTERNAL';
          ct_StgTable                 CONSTANT xxmx_migration_metadata.stg_table%TYPE       := 'dat';

          cv_metadata              CONSTANT VARCHAR2(30) := 'METADATA';

          cv_title_line            CONSTANT VARCHAR2(20) := 'T'; 
          cv_data_line             CONSTANT VARCHAR2(20) := 'D'; 

          -- Line Name
          cv_worker                CONSTANT VARCHAR2(30) := 'Worker';
          cv_person_name           CONSTANT VARCHAR2(30) := 'PersonName';
          cv_per_religion          CONSTANT VARCHAR2(30) := 'PersonReligion';         -- Not required JEM 
          cv_per_ethnicity         CONSTANT VARCHAR2(30) := 'PersonEthnicity'; 
          cv_per_legistlation      CONSTANT VARCHAR2(30) := 'PersonLegislativeData';        
          cv_per_address           CONSTANT VARCHAR2(30) := 'PersonAddress';        
          cv_per_phone             CONSTANT VARCHAR2(30) := 'PersonPhone';        
          cv_per_email             CONSTANT VARCHAR2(30) := 'PersonEmail';        
          cv_per_nat_ident         CONSTANT VARCHAR2(30) := 'PersonNationalIdentifier';        
          cv_per_Citizenship       CONSTANT VARCHAR2(30) := 'PersonCitizenship';        
          cv_per_Passport          CONSTANT VARCHAR2(30) := 'PersonPassport';        
          cv_wrk_relation          CONSTANT VARCHAR2(30) := 'WorkRelationship';

          cv_wrk_terms             CONSTANT VARCHAR2(30) := 'WorkTerms';        
          cv_work_assignment       CONSTANT VARCHAR2(30) := 'Assignment';  
          cv_wrk_measure           CONSTANT VARCHAR2(30) := 'AssignmentWorkMeasure';          
          cv_assign_grade          CONSTANT VARCHAR2(30) := 'AssignmentGradeSteps';        


          --
          /*************************
          ** Variable Declarations
          *************************/
          --
          vv_FusionAsgNumber             VARCHAR2(100);
          vd_BeginDate                   DATE;

          vv_file_type              VARCHAR2(10) := 'M';
          vv_file_type_name         VARCHAR2(20) := 'MERGE';

          vv_file_dir              xxmx_file_locations.file_location%TYPE;
          vv_line                  VARCHAR2(3000);
		  vvv_assignment_dff_mode	VARCHAR2(10):= 'N';


          --
          /****************************
          ** Record Table Declarations
          *****************************/
          --
          type type_per_data is table of varchar2(30000) index by binary_integer;
          g_per_data                 type_per_data;
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
               ,pt_i_ModuleMessage     => 'Procedure "'
                                        ||gct_PackageName
                                        ||'.'
                                        ||cv_ProcOrFuncName
                                        ||'" initiated.'
               ,pt_i_OracleError       => NULL
               );

                     gvt_MigrationSetName := xxmx_utilities_pkg.get_migration_set_name(pt_i_MigrationSetID);

					 vvv_assignment_dff_mode := xxmx_utilities_pkg.get_single_parameter_value(
																	pt_i_ApplicationSuite           =>     gct_ApplicationSuite
																	,pt_i_Application                =>     gct_Application
																	,pt_i_BusinessEntity             =>     'ALL'
																	,pt_i_SubEntity                  =>     'ALL'
																	,pt_i_ParameterCode              =>     'ASSIGNMENT_DFF'
																	);


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
                              ,pt_i_ModuleMessage     => 'Migration Set Name '
                                                       ||gvt_MigrationSetName
                              ,pt_i_OracleError       => NULL
                              );

                       vv_file_dir := xxmx_hdl_utilities_pkg.get_directory_path
                                                        (gct_ApplicationSuite
                                                        ,gct_Application
                                                        ,pt_i_BusinessEntity
                                                        ,ct_file_location_type);

                       DELETE FROM xxmx_hdl_file_temp  WHERE  UPPER(file_name) = UPPER(pt_i_FileName);

                        gvv_ProgressIndicator := '0050';            

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
                              ,pt_i_ModuleMessage     => 'Calling OPEN_hdl '
                                                        ||gvt_MigrationSetName
                                                        ||' File Name          '||pt_i_FileName
                                                        ||' ORA File Directory '||vv_file_dir
                                                        ||' vv_file_type       '||vv_file_type
                              ,pt_i_OracleError       => NULL
                              );

                 -- Start generating the HDL data file
                 -- OPEN the Merge file, main header will be automatically written
                    xxmx_hdl_utilities_pkg.OPEN_hdl (gv_ClientCode
                                                    ,pt_i_BusinessEntity
                                                    ,pt_i_FileName
                                                    ,vv_file_dir
                                                    ,vv_file_type
                                                    );
                 --
                 -- Work Terms
                  OPEN c_per_workterms; 
                 FETCH c_per_workterms BULK COLLECT INTO g_per_data; 
                 CLOSE c_per_workterms;
                   IF g_per_data.COUNT > 0 THEN
                   -- Write the Business Entity header
                     xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'T',cv_wrk_terms,NULL,'M');
                 END IF;

                 FOR i IN 1..g_per_data.COUNT LOOP
                     xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'D',cv_wrk_terms,g_per_data(i),'M');
                 END LOOP; 
                 g_per_data.DELETE;
               commit;
                 --
                 --
                 -- Worker Assignment
				 IF( vvv_assignment_dff_mode = 'U')
				 THEN 
					 -- To Generate HDL in Update Mode
					 OPEN c_per_assign_update;
					 FETCH c_per_assign_update BULK COLLECT INTO g_per_data; 
					 CLOSE c_per_assign_update;

					 IF g_per_data.COUNT > 0 THEN
					   -- Write the Business Entity header
						 xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'T',cv_work_assignment,NULL,'M',vvv_assignment_dff_mode);
					 END IF;

					 FOR i IN 1..g_per_data.COUNT LOOP
						 xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'D',cv_work_assignment,g_per_data(i),'M',vvv_assignment_dff_mode);
					 END LOOP; 
					 g_per_data.DELETE;
					 commit;
				 ELSIF vvv_assignment_dff_mode = 'I'
				 THEN 
				 -- To Generate HDL in Insert Mode
					 OPEN c_per_assign_ins; 
					 FETCH c_per_assign_ins BULK COLLECT INTO g_per_data; 
					 CLOSE c_per_assign_ins;

					 IF g_per_data.COUNT > 0 THEN
					   -- Write the Business Entity header
						 xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'T',cv_work_assignment,NULL,'M',vvv_assignment_dff_mode);
					 END IF;

					 FOR i IN 1..g_per_data.COUNT LOOP
						 xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'D',cv_work_assignment,g_per_data(i),'M',vvv_assignment_dff_mode);
					 END LOOP; 
					 g_per_data.DELETE;
					 commit;
				 ELSE
					-- Mode is not set 
					 OPEN c_per_assignment; 
					 FETCH c_per_assignment BULK COLLECT INTO g_per_data; 
					 CLOSE c_per_assignment;

					 IF g_per_data.COUNT > 0 THEN
					   -- Write the Business Entity header
						 xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'T',cv_work_assignment,NULL,'M');
					 END IF;

					 FOR i IN 1..g_per_data.COUNT LOOP
						 xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'D',cv_work_assignment,g_per_data(i),'M');
					 END LOOP; 
					 g_per_data.DELETE;
					 commit;
				 END IF;
				 --
                 --
                 -- Assignment Work Measure
                 OPEN c_get_work_measure; 
                 FETCH c_get_work_measure BULK COLLECT INTO g_per_data; 
                 CLOSE c_get_work_measure;

                 IF g_per_data.COUNT > 0 THEN
                   -- Write the Business Entity header
                     xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'T',cv_wrk_measure,NULL,'M');
                 END IF;

                 FOR i IN 1..g_per_data.COUNT LOOP
                     xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'D',cv_wrk_measure,g_per_data(i),'M');
                 END LOOP; 
                 g_per_data.DELETE;
                      commit;
                 --
                 --  
                 -- Assignment Grade Step
                 OPEN c_get_asg_grade_steps; 
                 FETCH c_get_asg_grade_steps BULK COLLECT INTO g_per_data; 
                 CLOSE c_get_asg_grade_steps;

                 IF g_per_data.COUNT > 0 THEN
                   -- Write the Business Entity header
                     xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'T',cv_assign_grade,NULL,'M');
                 END IF;

                 FOR i IN 1..g_per_data.COUNT LOOP
                     xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'D',cv_assign_grade,g_per_data(i),'M');
                 END LOOP; 
                 g_per_data.DELETE;
                        commit;         
                 --
               /*
                 -- Worker Assignment Extra Info
                 OPEN c_per_work_extra_info; FETCH c_per_work_extra_info BULK COLLECT INTO g_hdl_data; CLOSE c_per_work_extra_info;
                   IF g_per_data.COUNT > 0 THEN
                   -- Write the Business Entity header
                     xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'T','WorkerExtraInfo',NULL,'M');
                 END IF;

                 FOR i IN 1..g_per_data.COUNT LOOP
                     xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'D','WorkerExtraInfo',g_per_data(i),'M');
                 END LOOP; 
                 g_per_data.DELETE;

                 */
                   commit;
                 --
                 -- CLOSE the file handler
                  --  xxmx_hdl_utilities_pkg.CLOSE_hdl;

     END gen_worker_current_file;

     /*****************************************
     ** PROCEDURE: gen_worker_termination_file
     ******************************************/
	PROCEDURE gen_worker_termination_file
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_migration_metadata.business_entity%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    ,pt_i_FileName                   IN      xxmx_migration_metadata.data_file_name%TYPE                    
                   )
     IS
          --
           --
          /**********************
          ** CURSOR Declarations
          ***********************/
            -- Work Relationship
    --   ActionCode|TerminateWorkRelationshipFlag|ActualTerminationDate|LastWorkingDate
               CURSOR c_per_work_relation IS
                    SELECT  DISTINCT 
                         fs.person_number||gv_delim
                         ||'Worker-'||fs.person_number||gv_delim
                         ||fs.action_code||gv_delim
                         ||'Y'||gv_delim
                         ||w.wrs_actual_termination_date||gv_delim
                         ||w.wrs_actual_termination_date
                     FROM XXMX_HR_HCM_WORK_REL_V w,
                          XXMX_HR_HCM_FILE_SET_V1 fs
                    WHERE fs.person_id = w.wrs_person_id
                      AND UPPER(fs.action_code) = 'TERMINATION'
                      AND w.wrs_date_start IS NOT NULL
                      and w.wrs_ppos = fs.ppos
                  --    AND w.wrs_legal_employer_name IS NOT NULL
                  order by 1;


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
          cv_ProcOrFuncName           CONSTANT  VARCHAR2(30)                                := 'gen_per_worker';
         -- ct_file_location_type       CONSTANT xxmx_file_locations.file_location_type%TYPE  := 'HCM_INTERNAL';
          ct_StgTable                 CONSTANT xxmx_migration_metadata.stg_table%TYPE       := 'dat';

          cv_metadata              CONSTANT VARCHAR2(30) := 'METADATA';

          cv_title_line            CONSTANT VARCHAR2(20) := 'T'; 
          cv_data_line             CONSTANT VARCHAR2(20) := 'D'; 

          -- Line Name
          cv_worker                CONSTANT VARCHAR2(30) := 'Worker';
          cv_person_name           CONSTANT VARCHAR2(30) := 'PersonName';
          cv_per_religion          CONSTANT VARCHAR2(30) := 'PersonReligion';         -- Not required JEM 
          cv_per_ethnicity         CONSTANT VARCHAR2(30) := 'PersonEthnicity'; 
          cv_per_legistlation      CONSTANT VARCHAR2(30) := 'PersonLegislativeData';        
          cv_per_address           CONSTANT VARCHAR2(30) := 'PersonAddress';        
          cv_per_phone             CONSTANT VARCHAR2(30) := 'PersonPhone';        
          cv_per_email             CONSTANT VARCHAR2(30) := 'PersonEmail';        
          cv_per_nat_ident         CONSTANT VARCHAR2(30) := 'PersonNationalIdentifier';        
          cv_per_Citizenship       CONSTANT VARCHAR2(30) := 'PersonCitizenship';        
          cv_per_Passport          CONSTANT VARCHAR2(30) := 'PersonPassport';        
          cv_wrk_relation          CONSTANT VARCHAR2(30) := 'WorkRelationship';

          cv_wrk_terms             CONSTANT VARCHAR2(30) := 'WorkTerms';        
          cv_work_assignment       CONSTANT VARCHAR2(30) := 'Assignment';  
          cv_wrk_measure           CONSTANT VARCHAR2(30) := 'AssignmentWorkMeasure';          
          cv_assign_grade          CONSTANT VARCHAR2(30) := 'AssignmentGradeSteps';        
          --
          /*************************
          ** Variable Declarations
          *************************/
          --
          vv_FusionAsgNumber             VARCHAR2(100);
          vd_BeginDate                   DATE;

          vv_file_type              VARCHAR2(10) := 'M';
          vv_file_type_name         VARCHAR2(20) := 'MERGE';

          vv_file_dir              xxmx_file_locations.file_location%TYPE;
          vv_line                  VARCHAR2(3000);

          --
          /****************************
          ** Record Table Declarations
          *****************************/
          --
          type type_per_data is table of varchar2(30000) index by binary_integer;
          g_per_data                 type_per_data;
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
               ,pt_i_ModuleMessage     => 'Procedure "'
                                        ||gct_PackageName
                                        ||'.'
                                        ||cv_ProcOrFuncName
                                        ||'" initiated.'
               ,pt_i_OracleError       => NULL
               );

                     gvt_MigrationSetName := xxmx_utilities_pkg.get_migration_set_name(pt_i_MigrationSetID);

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
                              ,pt_i_ModuleMessage     => 'Migration Set Name '
                                                       ||gvt_MigrationSetName
                              ,pt_i_OracleError       => NULL
                              );

                       vv_file_dir := xxmx_hdl_utilities_pkg.get_directory_path
                                                        (gct_ApplicationSuite
                                                        ,gct_Application
                                                        ,pt_i_BusinessEntity
                                                        ,ct_file_location_type);

                       DELETE FROM xxmx_hdl_file_temp WHERE UPPER(file_name) = UPPER(pt_i_FileName);

                        gvv_ProgressIndicator := '0050';            

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
                              ,pt_i_ModuleMessage     => 'Calling OPEN_hdl '
                                                        ||gvt_MigrationSetName
                                                        ||' File Name          '||pt_i_FileName
                                                        ||' ORA File Directory '||vv_file_dir
                                                        ||' vv_file_type       '||vv_file_type
                              ,pt_i_OracleError       => NULL
                              );

                 -- Start generating the HDL data file
                 -- OPEN the Merge file, main header will be automatically written
                    xxmx_hdl_utilities_pkg.OPEN_hdl (gv_ClientCode
                                                    ,pt_i_BusinessEntity
                                                    ,pt_i_FileName
                                                    ,vv_file_dir
                                                    ,vv_file_type
                                                    );
                 --
      -- Work Relationship
                  OPEN c_per_work_relation; 
                 FETCH c_per_work_relation BULK COLLECT INTO g_per_data; 
                 CLOSE c_per_work_relation;

                 IF g_per_data.COUNT > 0 THEN
                   -- Write the Business Entity header
                     xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'T',cv_wrk_relation,NULL,'M');
                 END IF;

                 FOR i IN 1..g_per_data.COUNT LOOP
                     xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'D',cv_wrk_relation,g_per_data(i),'M');
                 END LOOP; 
                 g_per_data.DELETE;
                   commit;
                 --
                 -- CLOSE the file handler
                  --  xxmx_hdl_utilities_pkg.CLOSE_hdl;

     END gen_worker_termination_file;

     /*****************************************
     ** PROCEDURE: gen_bank_file
     ******************************************/
	PROCEDURE gen_bank_file
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_migration_metadata.business_entity%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    ,pt_i_FileName                   IN      xxmx_migration_metadata.data_file_name%TYPE                    
                   )
     IS
          --
          /**********************
          ** CURSOR Declarations
          ***********************/
          -- BANKS
          CURSOR c_get_banks IS
             SELECT DISTINCT 
                    institution_level||'-'||RTRIM(bank_name)||gv_delim||
                    country||gv_delim||
                    RTRIM(bank_name)
               FROM xxmx_xfm.xxmx_banks_xfm
               order by 1;
          -- ORDER BY bank_name


          /************************
          ** Constant Declarations
          *************************/
          --
          -- write function to get these variables.
          cv_ProcOrFuncName               CONSTANT  VARCHAR2(30)                          := 'gen_bank_file';
         -- ct_file_location_type       CONSTANT xxmx_file_locations.file_location_type%TYPE  := 'HCM_INTERNAL';

          ct_StgTable                     CONSTANT xxmx_migration_metadata.stg_table%TYPE := 'dat';

          cv_metadata              CONSTANT VARCHAR2(30) := 'METADATA';

          cv_file_prefix           CONSTANT VARCHAR2(20) := 'BANK'; 

          -- Line Types
          cv_bank                VARCHAR2(30) := 'Bank';

          vv_file_dir              xxmx_file_locations.file_location%TYPE;
          vv_line                  VARCHAR2(3000);

          --
          /*************************
          ** Variable Declarations
          *************************/
          --
          vv_FusionAsgNumber             VARCHAR2(100);
          vd_BeginDate                   DATE;

          vv_file_type              VARCHAR2(10) := 'M';
          vv_file_type_name         VARCHAR2(20) := 'MERGE';

          --
          /****************************
          ** Record Table Declarations
          *****************************/
          --
          type type_bank_data is table of varchar2(30000) index by binary_integer;
          g_bank_data                 type_bank_data;
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
          /** Initialise Procedure Global Variables   */
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
          /** Delete any DATA messages FROM previous executions
          ** FOR the Business Entity and Business Entity Level.
          ***/
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
               ,pt_i_ModuleMessage     => 'Procedure "'
                                        ||gct_PackageName
                                        ||'.'
                                        ||cv_ProcOrFuncName
                                        ||'" initiated.'
               ,pt_i_OracleError       => NULL
               );

      gvt_MigrationSetName := xxmx_utilities_pkg.get_migration_set_name(pt_i_MigrationSetID);

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
               ,pt_i_ModuleMessage     => 'Migration Set Name'
                                        ||gvt_MigrationSetName
               ,pt_i_OracleError       => NULL
               );


        vv_file_dir := xxmx_hdl_utilities_pkg.get_directory_path
                                         (gct_ApplicationSuite
                                         ,gct_Application
                                         ,pt_i_BusinessEntity
                                         ,ct_file_location_type);

        DELETE FROM xxmx_hdl_file_temp WHERE UPPER(file_name) = UPPER(pt_i_FileName);

        gvv_ProgressIndicator := '0050';

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
               ,pt_i_ModuleMessage     => 'Calling OPEN_hdl '
                                         ||gvt_MigrationSetName
                                         ||' File Name          '||pt_i_FileName
                                         ||' ORA File Directory '||vv_file_dir
                                         ||' vv_file_type       '||vv_file_type
               ,pt_i_OracleError       => NULL
               );

  -- Start generating the HDL data file
  -- OPEN the Merge file, main header will be automatically written
     xxmx_hdl_utilities_pkg.OPEN_hdl (gv_ClientCode
                                     ,pt_i_BusinessEntity
                                     ,pt_i_FileName
                                     ,vv_file_dir
                                     ,vv_file_type
                                     );

  --
  -- Worker Main
  OPEN c_get_banks; 
  FETCH c_get_banks BULK COLLECT INTO g_bank_data; 
  CLOSE c_get_banks;

  IF g_bank_data.COUNT > 0 THEN
    -- Write the Business Entity header
      xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'T',cv_bank,NULL,'M');
  END IF;

  FOR i IN 1..g_bank_data.COUNT LOOP
      xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'D',cv_bank,g_bank_data(i),'M');
  END LOOP; 
  g_bank_data.DELETE;

    commit;
  -- CLOSE the file handler
  xxmx_hdl_utilities_pkg.CLOSE_hdl;
 --
     END gen_bank_file;

     /*****************************************
     ** PROCEDURE: gen_bank_branches_file
     ******************************************/
	PROCEDURE gen_bank_branches_file
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_migration_metadata.business_entity%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    ,pt_i_FileName                   IN      xxmx_migration_metadata.data_file_name%TYPE                    
                   )
     IS
          --
          /**********************
          ** CURSOR Declarations
          ***********************/
          -- BANK BRANCHES
          CURSOR c_get_bank_branch IS
             SELECT 
                    institution_level||'-'||bank_branch_number||gv_delim||
                    country||gv_delim||
                    RTRIM(bank_name)||gv_delim||
                    RTRIM(bank_branch_name)||gv_delim||
                    bank_branch_number
               FROM xxmx_xfm.xxmx_bank_branches_xfm
     --         WHERE bank_branch_name IS NOT NULL
           ORDER BY bank_branch_name;

          /************************
          ** Constant Declarations
          *************************/
          --
          -- write function to get these variables.
          cv_ProcOrFuncName               CONSTANT  VARCHAR2(30)                          := 'gen_bank_branches_file';
         -- ct_file_location_type       CONSTANT xxmx_file_locations.file_location_type%TYPE  := 'HCM_INTERNAL';

          ct_StgTable                     CONSTANT xxmx_migration_metadata.stg_table%TYPE := 'dat';

          cv_metadata              CONSTANT VARCHAR2(30) := 'METADATA';
          cv_file_prefix           CONSTANT VARCHAR2(20) := 'BANKBRANCHES'; 

          -- Line Types
          cv_bank_branch          VARCHAR2(30) := 'BankBranch';

          vv_file_dir              xxmx_file_locations.file_location%TYPE;
          vv_line                  VARCHAR2(3000);
          --
          /*************************
          ** Variable Declarations
          *************************/
          --
          vv_FusionAsgNumber             VARCHAR2(100);
          vd_BeginDate                   DATE;

          vv_file_type              VARCHAR2(10) := 'M';
          vv_file_type_name         VARCHAR2(20) := 'MERGE';

          --
          /****************************
          ** Record Table Declarations
          *****************************/
          --
          type type_bank_data is table of varchar2(30000) index by binary_integer;
          g_bank_data                 type_bank_data;
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
          /** Initialise Procedure Global Variables   */
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
          /** Delete any DATA messages FROM previous executions
          ** FOR the Business Entity and Business Entity Level.
          ***/
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
               ,pt_i_ModuleMessage     => 'Procedure "'
                                        ||gct_PackageName
                                        ||'.'
                                        ||cv_ProcOrFuncName
                                        ||'" initiated.'
               ,pt_i_OracleError       => NULL
               );

      gvt_MigrationSetName := xxmx_utilities_pkg.get_migration_set_name(pt_i_MigrationSetID);

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
               ,pt_i_ModuleMessage     => 'Migration Set Name'
                                        ||gvt_MigrationSetName
               ,pt_i_OracleError       => NULL
               );


        vv_file_dir := xxmx_hdl_utilities_pkg.get_directory_path
                                         (gct_ApplicationSuite
                                         ,gct_Application
                                         ,pt_i_BusinessEntity
                                         ,ct_file_location_type);

        DELETE FROM xxmx_hdl_file_temp WHERE  UPPER(file_name) = UPPER(pt_i_FileName);

        gvv_ProgressIndicator := '0050';

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
               ,pt_i_ModuleMessage     => 'Calling OPEN_hdl '
                                         ||gvt_MigrationSetName
                                         ||' File Name          '||pt_i_FileName
                                         ||' ORA File Directory '||vv_file_dir
                                         ||' vv_file_type       '||vv_file_type
               ,pt_i_OracleError       => NULL
               );
   -- Start generating the HDL data file
  -- OPEN the Merge file, main header will be automatically written
      xxmx_hdl_utilities_pkg.OPEN_hdl (gv_ClientCode
                                     ,pt_i_BusinessEntity
                                     ,pt_i_FileName
                                     ,vv_file_dir
                                     ,vv_file_type
                                     );
     --
     -- Bank Branch
      OPEN c_get_bank_branch; 
     FETCH c_get_bank_branch BULK COLLECT INTO g_bank_data; 
     CLOSE c_get_bank_branch;

     IF g_bank_data.COUNT > 0 THEN
       -- Write the Business Entity header
         xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'T',cv_bank_branch,NULL,'M');
     END IF;

     FOR i IN 1..g_bank_data.COUNT LOOP
         xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'D',cv_bank_branch,g_bank_data(i),'M');
     END LOOP; 
     g_bank_data.DELETE;


     commit;
     -- CLOSE the file handler
       xxmx_hdl_utilities_pkg.CLOSE_hdl;
    --
   END gen_bank_branches_file;

     /*****************************************
     ** PROCEDURE: gen_work_assign_superv_file
     ******************************************/
	PROCEDURE gen_work_assign_superv_file
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_migration_metadata.business_entity%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    ,pt_i_FileName                   IN      xxmx_migration_metadata.data_file_name%TYPE                    
                    )
     IS
          -- HCM	HR	WORKER		WORKER_ASSIGN_SUPERVISOR	          WorkerAssignmentSupervisor   
          --
          --**********************
          --** CURSOR AssignmentSupervisor
          --***********************
          -- AssignmentSupervisor --
      CURSOR c_assign_supervisor IS
          SELECT DISTINCT    
                fs.person_number||'-'||fs.assignment_number||gv_delim||  -- changed for sourcesystemID
               'Assignment-'||fs.assignment_number||gv_delim|| 
                TO_CHAR(effective_start_date,'RRRR/MM/DD')||gv_delim||        
                TO_CHAR(effective_end_date,'RRRR/MM/DD')||gv_delim||        
                manager_type||gv_delim||
                NVL(primary_flag,'Y')||gv_delim||   
               (SELECT MAX(fss.person_number) from XXMX_HR_HCM_FILE_SET_V1 fss 
                 WHERE fss.person_id       =  s.manager_id)
           FROM xxmx_per_asg_sup_f_stg s,   -- No xfm table
                XXMX_HR_HCM_FILE_SET_V1 fs
          WHERE fs.person_id       = s.person_id
          AND Action_code IN( 'CURRENT','ADD_ASSIGN')
          order by 1;
          --
          /************************
          ** Constant Declarations
          *************************/
          --
          --
          cv_ProcOrFuncName           CONSTANT  VARCHAR2(30)                                := 'gen_work_assign_superv_file';
        --  ct_file_location_type       CONSTANT xxmx_file_locations.file_location_type%TYPE  := 'HCM_INTERNAL';
          ct_StgTable                 CONSTANT xxmx_migration_metadata.stg_table%TYPE       := 'dat';

          cv_metadata              CONSTANT VARCHAR2(30) := 'METADATA';

          cv_title_line            CONSTANT VARCHAR2(20) := 'T'; 
          cv_data_line             CONSTANT VARCHAR2(20) := 'D'; 

          -- Line Name
          cv_assign_supervisor       VARCHAR2(40) := 'AssignmentSupervisor';
          --
          /*************************
          ** Variable Declarations
          *************************/
          --
          vv_FusionAsgNumber             VARCHAR2(100);
          vd_BeginDate                   DATE;

          vv_file_type              VARCHAR2(10) := 'M';
          vv_file_type_name         VARCHAR2(20) := 'MERGE';

          vv_file_dir              xxmx_file_locations.file_location%TYPE;
          vv_line                  VARCHAR2(3000);

          --
          /****************************
          ** Record Table Declarations
          *****************************/
          --
          type type_per_data is table of varchar2(30000) index by binary_integer;
          g_per_data                 type_per_data;
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

    BEGIN  

         --** Initialise Procedure Global Variables
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
          -- Delete any DATA messages FROM previous executions
          -- FOR the Business Entity and Business Entity Level.
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
               ,pt_i_ModuleMessage     => 'Procedure "'
                                        ||gct_PackageName
                                        ||'.'
                                        ||cv_ProcOrFuncName
                                        ||'" initiated.'
               ,pt_i_OracleError       => NULL
               );

          gvt_MigrationSetName := xxmx_utilities_pkg.get_migration_set_name(pt_i_MigrationSetID);

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
                              ,pt_i_ModuleMessage     => 'Migration Set Name '
                                                       ||gvt_MigrationSetName
                              ,pt_i_OracleError       => NULL
                              );

                       vv_file_dir := xxmx_hdl_utilities_pkg.get_directory_path
                                                        (gct_ApplicationSuite
                                                        ,gct_Application
                                                        ,pt_i_BusinessEntity
                                                        ,ct_file_location_type);

                       DELETE FROM xxmx_hdl_file_temp  WHERE  UPPER(file_name) = UPPER(pt_i_FileName);

                        gvv_ProgressIndicator := '0050';            

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
                              ,pt_i_ModuleMessage     => 'Calling OPEN_hdl '
                                                        ||gvt_MigrationSetName
                                                        ||' File Name          '||pt_i_FileName
                                                        ||' ORA File Directory '||vv_file_dir
                                                        ||' vv_file_type       '||vv_file_type
                              ,pt_i_OracleError       => NULL
                              );

                 -- Start generating the HDL data file
                 -- OPEN the Merge file, main header will be automatically written
                    xxmx_hdl_utilities_pkg.OPEN_hdl (gv_ClientCode
                                                    ,pt_i_BusinessEntity
                                                    ,pt_i_FileName
                                                    ,vv_file_dir
                                                    ,vv_file_type
                                                    );
                 --
                 -- Assign Supervisor
                  OPEN c_assign_supervisor; 
                 FETCH c_assign_supervisor BULK COLLECT INTO g_per_data; 
                 CLOSE c_assign_supervisor;

                   IF g_per_data.COUNT > 0 THEN
                     xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'T',cv_assign_supervisor,NULL,'M');
                   END IF;

                 FOR i IN 1..g_per_data.COUNT LOOP
                     xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'D',cv_assign_supervisor,g_per_data(i),'M');
                 END LOOP; 
                 g_per_data.DELETE;
               commit;
     END gen_work_assign_superv_file;

     /*****************************************
     ** PROCEDURE: gen_extern_bank_acct_file
     ******************************************/
	PROCEDURE gen_extern_bank_acct_file
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_migration_metadata.business_entity%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    ,pt_i_FileName                   IN      xxmx_migration_metadata.data_file_name%TYPE                    
                   )
     IS
          --
          --
          /**********************
          ** CURSOR Declarations
          ***********************/
          -- ExternalBankAccount --
      CURSOR c_extern_bank_acct IS
       /*SELECT DISTINCT
            '-'||fs.person_number
           ||gv_delim||bank_name
           ||gv_delim||branch_name
           ||gv_delim||bank_account_number
           ||gv_delim||country_code
           ||gv_delim||currency_code
           ||gv_delim||sec_account_ref
           ||gv_delim||ext_bank_acc_owner
        FROM xxmx_ext_bank_acc_xfm b, 
             XXMX_HR_HCM_FILE_SET_V1 fs
       WHERE b.person_id = fs.person_id
         AND  UPPER(fs.action_code) = 'HIRE'
         order by 1;*/

       WITH WRK_DEDUPE AS
        (
            SELECT DISTINCT 
                p.NID_NATIONAL_IDENTIFIER_NUMBER
                , p.PPS_PERSON_NUMBER
                , p.PERSON_ID
                , p.PPS_START_DATE
                , p.pns_legislation_code
                , RANK() OVER(PARTITION BY p.NID_NATIONAL_IDENTIFIER_NUMBER ORDER BY p.PPS_START_DATE) RANKING
            FROM XXMX_HR_HCM_PERSON_V p
                , XXMX_HR_HCM_FILE_SET_V1 fs
            WHERE fs.person_id = p.person_id
                AND UPPER(fs.action_code) = 'HIRE'
                AND p.NID_NATIONAL_IDENTIFIER_NUMBER IN (SELECT NID_NATIONAL_IDENTIFIER_NUMBER 
                                                    FROM XXMX_HR_HCM_PERSON_V
                                                    GROUP BY NID_NATIONAL_IDENTIFIER_NUMBER
                                                    HAVING COUNT(*) > 1)
                AND EXISTS (SELECT 1 FROM XXMX_HR_HCM_PERSON_V p2 
                            WHERE p2.NID_NATIONAL_IDENTIFIER_NUMBER = p.NID_NATIONAL_IDENTIFIER_NUMBER 
                                AND p2.PPS_PERSON_NUMBER <> p.PPS_PERSON_NUMBER)
        ),
        WRK_NUMBER AS
        (
            SELECT DISTINCT 
                p.NID_NATIONAL_IDENTIFIER_NUMBER
                , p.PPS_PERSON_NUMBER
                , p.PERSON_ID
                , wk.PPS_PERSON_NUMBER WK_PERSON_NUMBER
                , p.PPS_START_DATE
                , RANK() OVER(PARTITION BY p.NID_NATIONAL_IDENTIFIER_NUMBER ORDER BY p.PPS_START_DATE) RANKING
            FROM XXMX_HR_HCM_PERSON_V p
                , (SELECT * FROM WRK_DEDUPE WHERE RANKING = 1) wk
            WHERE p.NID_NATIONAL_IDENTIFIER_NUMBER = wk.NID_NATIONAL_IDENTIFIER_NUMBER
        )
        SELECT DISTINCT
           '-'||NVL(wrk.WK_PERSON_NUMBER, fs.PERSON_NUMBER) || '_' || bank_account_number || '_' || branch_name
           ||gv_delim|| bank_name
           ||gv_delim|| branch_name
           ||gv_delim|| bank_account_number
           ||gv_delim|| country_code
           ||gv_delim|| currency_code
           ||gv_delim|| sec_account_ref
           ||gv_delim|| ext_bank_acc_owner
        FROM xxmx_ext_bank_acc_xfm b, 
             XXMX_HR_HCM_FILE_SET_V1 fs,
             WRK_NUMBER wrk
        WHERE b.person_id = fs.person_id
            AND b.person_id = wrk.PERSON_ID (+)
            AND  UPPER(fs.action_code) = 'HIRE'
            AND NOT EXISTS (SELECT 1 FROM xxmx_ext_bank_acc_xfm b2
                            WHERE LOWER(b.bank_account_number) = LOWER(b2.bank_account_number)
                                AND LOWER(b.branch_name) = LOWER(b2.branch_name)
                                AND b.PERSONNUMBER <> b2.PERSONNUMBER
                                AND NVL(wrk.WK_PERSON_NUMBER, fs.PERSON_NUMBER) = b2.PERSONNUMBER)
        order by 1; 

     -- ExternalBankAccountOwner --
     CURSOR c_extern_bank_acct_owner IS 
         /*SELECT DISTINCT 
              '-'||fs.person_number
            ||gv_delim||bank_name
            ||gv_delim||branch_name
            ||gv_delim||bank_account_number
            ||gv_delim||Country_Code
            ||gv_delim||currency_code
            ||gv_delim||sec_account_ref
            ||gv_delim||fs.person_number
        FROM  xxmx_ext_bank_acc_xfm b, 
              XXMX_HR_HCM_FILE_SET_V1 fs
        WHERE b.person_id = fs.person_id
          AND  UPPER(fs.action_code) = 'HIRE'
          order by 1;*/

        WITH WRK_DEDUPE AS
        (
            SELECT DISTINCT 
                p.NID_NATIONAL_IDENTIFIER_NUMBER
                , p.PPS_PERSON_NUMBER
                , p.PERSON_ID
                , p.PPS_START_DATE
                , p.pns_legislation_code
                , RANK() OVER(PARTITION BY p.NID_NATIONAL_IDENTIFIER_NUMBER ORDER BY p.PPS_START_DATE) RANKING
            FROM XXMX_HR_HCM_PERSON_V p
                , XXMX_HR_HCM_FILE_SET_V1 fs
            WHERE fs.person_id = p.person_id
                AND UPPER(fs.action_code) = 'HIRE'
                AND p.NID_NATIONAL_IDENTIFIER_NUMBER IN (SELECT NID_NATIONAL_IDENTIFIER_NUMBER 
                                                    FROM XXMX_HR_HCM_PERSON_V
                                                    GROUP BY NID_NATIONAL_IDENTIFIER_NUMBER
                                                    HAVING COUNT(*) > 1)
                AND EXISTS (SELECT 1 FROM XXMX_HR_HCM_PERSON_V p2 
                            WHERE p2.NID_NATIONAL_IDENTIFIER_NUMBER = p.NID_NATIONAL_IDENTIFIER_NUMBER 
                                AND p2.PPS_PERSON_NUMBER <> p.PPS_PERSON_NUMBER)
        ),
        WRK_NUMBER AS
        (
            SELECT DISTINCT 
                p.NID_NATIONAL_IDENTIFIER_NUMBER
                , p.PPS_PERSON_NUMBER
                , p.PERSON_ID
                , wk.PPS_PERSON_NUMBER WK_PERSON_NUMBER
                , p.PPS_START_DATE
                , RANK() OVER(PARTITION BY p.NID_NATIONAL_IDENTIFIER_NUMBER ORDER BY p.PPS_START_DATE) RANKING
            FROM XXMX_HR_HCM_PERSON_V p
                , (SELECT * FROM WRK_DEDUPE WHERE RANKING = 1) wk
            WHERE p.NID_NATIONAL_IDENTIFIER_NUMBER = wk.NID_NATIONAL_IDENTIFIER_NUMBER
        )
        SELECT DISTINCT 
              '-'||NVL(wrk.WK_PERSON_NUMBER, fs.PERSON_NUMBER) || '_' || bank_account_number || '_' || branch_name
            ||gv_delim||bank_name
            ||gv_delim||branch_name
            ||gv_delim||bank_account_number
            ||gv_delim||Country_Code
            ||gv_delim||currency_code
            ||gv_delim||sec_account_ref
            ||gv_delim||NVL(wrk.WK_PERSON_NUMBER, fs.PERSON_NUMBER)
        FROM  xxmx_ext_bank_acc_xfm b, 
              XXMX_HR_HCM_FILE_SET_V1 fs,
              WRK_NUMBER wrk
        WHERE b.person_id = fs.person_id
            AND b.person_id = wrk.PERSON_ID (+)
            AND  UPPER(fs.action_code) = 'HIRE'
            AND NOT EXISTS (SELECT 1 FROM xxmx_ext_bank_acc_xfm b2
                            WHERE LOWER(b.bank_account_number) = LOWER(b2.bank_account_number)
                                AND LOWER(b.branch_name) = LOWER(b2.branch_name)
                                AND b.PERSONNUMBER <> b2.PERSONNUMBER
                                AND NVL(wrk.WK_PERSON_NUMBER, fs.PERSON_NUMBER) = b2.PERSONNUMBER)
        order by 1; 

          --************************
          --** Constant Declarations
          --*************************
          cv_ProcOrFuncName           CONSTANT  VARCHAR2(30)                                := 'gen_extern_bank_acct_file';
        --  ct_file_location_type       CONSTANT xxmx_file_locations.file_location_type%TYPE  := 'HCM_INTERNAL';
          ct_StgTable                 CONSTANT xxmx_migration_metadata.stg_table%TYPE       := 'dat';

          cv_metadata              CONSTANT VARCHAR2(30) := 'METADATA';

          cv_title_line            CONSTANT VARCHAR2(20) := 'T'; 
          cv_data_line             CONSTANT VARCHAR2(20) := 'D'; 

          -- Line Name
          cv_ext_bank_acct         CONSTANT VARCHAR2(30) := 'ExternalBankAccount';   
          cv_ext_bank_acct_owner      CONSTANT VARCHAR2(30) := 'ExternalBankAccountOwner';   
          --
          /*************************
          ** Variable Declarations
          *************************/
          --
          vv_FusionAsgNumber             VARCHAR2(100);
          vd_BeginDate                   DATE;

          vv_file_type              VARCHAR2(10) := 'M';
          vv_file_type_name         VARCHAR2(20) := 'MERGE';

          vv_file_dir              xxmx_file_locations.file_location%TYPE;
          vv_line                  VARCHAR2(3000);

          --
          /****************************
          ** Record Table Declarations
          *****************************/
          --
          type type_per_data is table of varchar2(30000) index by binary_integer;
          g_per_data                 type_per_data;
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
               ,pt_i_ModuleMessage     => 'Procedure "'
                                        ||gct_PackageName
                                        ||'.'
                                        ||cv_ProcOrFuncName
                                        ||'" initiated.'
               ,pt_i_OracleError       => NULL
               );

          gvt_MigrationSetName := xxmx_utilities_pkg.get_migration_set_name(pt_i_MigrationSetID);

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
                              ,pt_i_ModuleMessage     => 'Migration Set Name '
                                                       ||gvt_MigrationSetName
                              ,pt_i_OracleError       => NULL
                              );

                       vv_file_dir := xxmx_hdl_utilities_pkg.get_directory_path
                                                        (gct_ApplicationSuite
                                                        ,gct_Application
                                                        ,pt_i_BusinessEntity
                                                        ,ct_file_location_type);

                       DELETE FROM xxmx_hdl_file_temp  WHERE  UPPER(file_name) = UPPER(pt_i_FileName);

                        gvv_ProgressIndicator := '0050';            

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
                              ,pt_i_ModuleMessage     => 'Calling OPEN_hdl '
                                                        ||gvt_MigrationSetName
                                                        ||' File Name          '||pt_i_FileName
                                                        ||' ORA File Directory '||vv_file_dir
                                                        ||' vv_file_type       '||vv_file_type
                              ,pt_i_OracleError       => NULL
                              );

                 -- Start generating the HDL data file
                 -- OPEN the Merge file, main header will be automatically written
                    xxmx_hdl_utilities_pkg.OPEN_hdl (gv_ClientCode
                                                    ,pt_i_BusinessEntity
                                                    ,pt_i_FileName
                                                    ,vv_file_dir
                                                    ,vv_file_type
                                                    );
                 --
                 -- External Bank Account
                  OPEN c_extern_bank_acct; 
                 FETCH c_extern_bank_acct BULK COLLECT INTO g_per_data; 
                 CLOSE c_extern_bank_acct;

                   IF g_per_data.COUNT > 0 THEN
                   -- Write the Business Entity header
                     xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'T',cv_ext_bank_acct,NULL,'M');
                 END IF;

                 FOR i IN 1..g_per_data.COUNT LOOP
                     xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'D',cv_ext_bank_acct,g_per_data(i),'M');
                 END LOOP; 
                 g_per_data.DELETE;
                 commit;
                 --
                 --
                 -- External Bank Account Owner
                  OPEN c_extern_bank_acct_owner; 
                 FETCH c_extern_bank_acct_owner BULK COLLECT INTO g_per_data; 
                 CLOSE c_extern_bank_acct_owner;

                 IF g_per_data.COUNT > 0 THEN
                   -- Write the Business Entity header
                     xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'T',cv_ext_bank_acct_owner,NULL,'M');
                 END IF;

                 FOR i IN 1..g_per_data.COUNT LOOP
                     xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'D',cv_ext_bank_acct_owner,g_per_data(i),'M');
                 END LOOP; 
                 g_per_data.DELETE;
                 --
                   commit;
                 --
                 -- CLOSE the file handler
                    xxmx_hdl_utilities_pkg.CLOSE_hdl;

  END gen_extern_bank_acct_file;

     /*****************************************
     ** PROCEDURE: gen_per_pay_method_file
     ******************************************/
	PROCEDURE gen_per_pay_method_file
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_migration_metadata.business_entity%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    ,pt_i_FileName                   IN      xxmx_migration_metadata.data_file_name%TYPE                    
                   )
     IS
                 --
          --
          /**********************
          ** CURSOR Declarations
          ***********************/
          -- PersonalPaymentMethod --
      CURSOR c_per_pay_method IS
        SELECT DISTINCT
               fs.assignment_number||'-'||fs.person_number||gv_delim||
               --   DECODE(instr(fs.assignment_number,'-')
               --       ,0,fs.assignment_number
               --       , substr(fs.assignment_number,1,instr(fs.assignment_number,'-')-1))
              pm.attribute2||gv_delim||                                 -- LegislativeDataGroupName
              fs.assignment_number||gv_delim||                          -- AssignmentNumber   
              pm.PERSONAL_PAYMENT_NAME||gv_delim||                      -- OrganizationPaymentMethodCode,
              'PersonalPaymentMethod-'||fs.person_number||gv_delim||    -- PersonalPaymentMethodCode
              TO_CHAR(pm.EFFECTIVE_START_DATE,'RRRR/MM/DD')||gv_delim|| -- EffectiveStartDate
              pm.PRIORITY||gv_delim||                                   -- ProcessingOrder
              NVL(pm.PAYMENT_AMOUNT_TYPE,'P')||gv_delim||               -- PaymentAmountType
              pm.PERCENTAGE||gv_delim||        -- Percentage
              pm.BANK_NAME||gv_delim||       -- BankName
              pm.BRANCH_NAME||gv_delim||      -- BankBranchName
              pm.BANK_ACCOUNT_NUMBER||gv_delim||     -- BankAccountNumber
              pm.SEC_ACCOUNT_REF||gv_delim||           --SecondaryAccountReference
              'GB'    -- BankCountryCode
        FROM  xxmx_per_pay_method_xfm pm,
              XXMX_HR_HCM_FILE_SET_V1 fs
       WHERE  fs.person_id = pm.person_id
         AND UPPER(fs.action_code) = 'HIRE'
         order by 1;

          --
          /************************
          ** Constant Declarations
          *************************/
          --
          --
          cv_ProcOrFuncName           CONSTANT  VARCHAR2(30)                                := 'gen_per_pay_method_file';
       --   ct_file_location_type       CONSTANT xxmx_file_locations.file_location_type%TYPE  := 'HCM_INTERNAL';
          ct_StgTable                 CONSTANT xxmx_migration_metadata.stg_table%TYPE       := 'dat';

          cv_metadata              CONSTANT VARCHAR2(30) := 'METADATA';

          cv_title_line            CONSTANT VARCHAR2(20) := 'T'; 
          cv_data_line             CONSTANT VARCHAR2(20) := 'D'; 

          -- Line Name
          cv_per_pay_method        VARCHAR2(40) := 'PersonalPaymentMethod';
          --
          /*************************
          ** Variable Declarations
          *************************/
          --
          vv_FusionAsgNumber             VARCHAR2(100);
          vd_BeginDate                   DATE;

          vv_file_type              VARCHAR2(10) := 'M';
          vv_file_type_name         VARCHAR2(20) := 'MERGE';

          vv_file_dir              xxmx_file_locations.file_location%TYPE;
          vv_line                  VARCHAR2(3000);

          --
          /****************************
          ** Record Table Declarations
          *****************************/
          --
          type type_per_data is table of varchar2(30000) index by binary_integer;
          g_per_data                 type_per_data;
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

    BEGIN  

         --** Initialise Procedure Global Variables

          --
          gvv_ProgressIndicator := '0010';
          --
          gvv_ReturnStatus  := '';
          --
          --** Delete any MODULE messages FROM previous executions
          --** FOR the Business Entity and Business Entity Level

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
          -- Delete any DATA messages FROM previous executions
          -- FOR the Business Entity and Business Entity Level.
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
               ,pt_i_ModuleMessage     => 'Procedure "'
                                        ||gct_PackageName
                                        ||'.'
                                        ||cv_ProcOrFuncName
                                        ||'" initiated.'
               ,pt_i_OracleError       => NULL
               );

          gvt_MigrationSetName := xxmx_utilities_pkg.get_migration_set_name(pt_i_MigrationSetID);

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
                              ,pt_i_ModuleMessage     => 'Migration Set Name '
                                                       ||gvt_MigrationSetName
                              ,pt_i_OracleError       => NULL
                              );

                       vv_file_dir := xxmx_hdl_utilities_pkg.get_directory_path
                                                        (gct_ApplicationSuite
                                                        ,gct_Application
                                                        ,pt_i_BusinessEntity
                                                        ,ct_file_location_type);

                       DELETE FROM xxmx_hdl_file_temp  WHERE  UPPER(file_name) = UPPER(pt_i_FileName);

                        gvv_ProgressIndicator := '0050';            

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
                              ,pt_i_ModuleMessage     => 'Calling OPEN_hdl '
                                                        ||gvt_MigrationSetName
                                                        ||' File Name          '||pt_i_FileName
                                                        ||' ORA File Directory '||vv_file_dir
                                                        ||' vv_file_type       '||vv_file_type
                              ,pt_i_OracleError       => NULL
                              );

                 -- Start generating the HDL data file
                 -- OPEN the Merge file, main header will be automatically written
                    xxmx_hdl_utilities_pkg.OPEN_hdl (gv_ClientCode
                                                    ,pt_i_BusinessEntity
                                                    ,pt_i_FileName
                                                    ,vv_file_dir
                                                    ,vv_file_type
                                                    );
                 --
                 -- Personal Payment Method
                  OPEN c_per_pay_method; 
                 FETCH c_per_pay_method BULK COLLECT INTO g_per_data; 
                 CLOSE c_per_pay_method;

                   IF g_per_data.COUNT > 0 THEN
                     xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'T',cv_per_pay_method,NULL,'M');
                 END IF;

                 FOR i IN 1..g_per_data.COUNT LOOP
                     xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'D',cv_per_pay_method,g_per_data(i),'M');
                 END LOOP; 
                 g_per_data.DELETE;
                 commit;
                 --
   END gen_per_pay_method_file;

     /*****************************************
     ** PROCEDURE: gen_salary_file
     ******************************************/
	PROCEDURE gen_salary_file
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_migration_metadata.business_entity%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    ,pt_i_FileName                   IN      xxmx_migration_metadata.data_file_name%TYPE                    
                    )
     IS
           /**********************
          ** CURSOR Declarations
          ***********************/
          -- Salary --
      CURSOR c_salary IS
        SELECT DISTINCT
              s.assignment_number||'-'||TO_CHAR(effective_start_date,'RRRRMMDD')||gv_delim||       -- Assignment_number|
              s.assignment_number||gv_delim|| 
              TO_CHAR(effective_start_date,'RRRR/MM/DD')||gv_delim||   -- DateFrom|
              TO_CHAR(effective_end_date,'RRRR/MM/DD')||gv_delim||     -- DateTo|
              name ||gv_delim||                   -- SalaryBasisName|
              proposed_salary||gv_delim||        -- SalaryAmount|
              NVL(attribute3,'CHANGE_SALARY')||gv_delim|| --'ActionCode'       
              multiple_components||gv_delim||     --MultipleComponents
              approved                -- SalaryApproved
        FROM  xxmx_per_asg_salary_xfm s,
              XXMX_HR_HCM_FILE_SET_V1 fs
        WHERE fs.assignment_number  = s.assignment_number
         -- AND proposed_salary <> 0
          order by 1;
          --
          /************************
          ** Constant Declarations
          *************************/
          --
          --
          cv_ProcOrFuncName           CONSTANT  VARCHAR2(30)                                := 'gen_salary_file';
         -- ct_file_location_type       CONSTANT xxmx_file_locations.file_location_type%TYPE  := 'HCM_INTERNAL';
          ct_StgTable                 CONSTANT xxmx_migration_metadata.stg_table%TYPE       := 'dat';

          cv_metadata              CONSTANT VARCHAR2(30) := 'METADATA';

          cv_title_line            CONSTANT VARCHAR2(20) := 'T'; 
          cv_data_line             CONSTANT VARCHAR2(20) := 'D'; 

          -- Line Name
          cv_salary                VARCHAR2(40) := 'Salary';
          --
          /*************************
          ** Variable Declarations
          *************************/
          --
          vv_FusionAsgNumber             VARCHAR2(100);
          vd_BeginDate                   DATE;

          vv_file_type              VARCHAR2(10) := 'M';
          vv_file_type_name         VARCHAR2(20) := 'MERGE';

          vv_file_dir              xxmx_file_locations.file_location%TYPE;
          vv_line                  VARCHAR2(3000);

          --
          /****************************
          ** Record Table Declarations
          *****************************/
          --
          type type_per_data is table of varchar2(30000) index by binary_integer;
          g_per_data                 type_per_data;
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

    BEGIN  

         --** Initialise Procedure Global Variables
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
          -- Delete any DATA messages FROM previous executions
          -- FOR the Business Entity and Business Entity Level.
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
               ,pt_i_ModuleMessage     => 'Procedure "'
                                        ||gct_PackageName
                                        ||'.'
                                        ||cv_ProcOrFuncName
                                        ||'" initiated.'
               ,pt_i_OracleError       => NULL
               );

          gvt_MigrationSetName := xxmx_utilities_pkg.get_migration_set_name(pt_i_MigrationSetID);

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
                              ,pt_i_ModuleMessage     => 'Migration Set Name '
                                                       ||gvt_MigrationSetName
                              ,pt_i_OracleError       => NULL
                              );

                       vv_file_dir := xxmx_hdl_utilities_pkg.get_directory_path
                                                        (gct_ApplicationSuite
                                                        ,gct_Application
                                                        ,pt_i_BusinessEntity
                                                        ,ct_file_location_type);

                       DELETE FROM xxmx_hdl_file_temp  WHERE  UPPER(file_name) = UPPER(pt_i_FileName);

                        gvv_ProgressIndicator := '0050';            

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
                              ,pt_i_ModuleMessage     => 'Calling OPEN_hdl '
                                                        ||gvt_MigrationSetName
                                                        ||' File Name          '||pt_i_FileName
                                                        ||' ORA File Directory '||vv_file_dir
                                                        ||' vv_file_type       '||vv_file_type
                              ,pt_i_OracleError       => NULL
                              );

                 -- Start generating the HDL data file
                 -- OPEN the Merge file, main header will be automatically written
                    xxmx_hdl_utilities_pkg.OPEN_hdl (gv_ClientCode
                                                    ,pt_i_BusinessEntity
                                                    ,pt_i_FileName
                                                    ,vv_file_dir
                                                    ,vv_file_type
                                                    );
                 --
                 -- Salary
                  OPEN c_salary; 
                 FETCH c_salary BULK COLLECT INTO g_per_data; 
                 CLOSE c_salary;

                   IF g_per_data.COUNT > 0 THEN
                     xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'T',cv_salary,NULL,'M');
                   END IF;

                 FOR i IN 1..g_per_data.COUNT LOOP
                     xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'D',cv_salary,g_per_data(i),'M');
                 END LOOP; 
                 g_per_data.DELETE;
                 commit;

     END gen_salary_file;


     /*****************************************
     ** PROCEDURE: gen_contacts_file
     ******************************************/
	PROCEDURE gen_contacts_file
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_migration_metadata.business_entity%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    ,pt_i_FileName                   IN      xxmx_migration_metadata.data_file_name%TYPE                    
                   )
     IS
          --
          --
          /**********************
          ** CURSOR Declarations
          ***********************/
		  --Changed by Pallavi
              -- Contact
               CURSOR c_contact IS
                   SELECT DISTINCT 
                           fs.person_number||'-'||cr_contpersonid||gv_delim|| 
                           c_start_date||gv_delim||
                           cr_effectivestartdate||gv_delim||
                           cr_effectiveenddate||gv_delim||
                           'CNT_'||fs.person_number||'_'||cr_contpersonid
                      FROM XXMX_HR_HCM_CONTACTS_V cv,
                           XXMX_HR_HCM_FILE_SET_V1 fs
                      WHERE fs.person_id   = cv.cr_relatedpersonid
                      order by 1;

               -- ContactAddress
               CURSOR c_contact_addr IS
                    SELECT  DISTINCT 
                      fs.person_number||'-'||cr_contpersonid||gv_delim|| 
                      'Contact-'||fs.person_number||'-'||cr_contpersonid||gv_delim|| 
                      --ca_effectivestartdate||gv_delim|| 
					  c_start_date||gv_delim|| 
                      NVL(ca_effectiveenddate,'4712/12/31')||gv_delim||   
                      --ca_contpersonid||gv_delim||       
                      'CNT_'||fs.person_number||'_'||cr_contpersonid||gv_delim||
                      DECODE (ca_addresstype,'H','HOME','W','WORK',ca_addresstype)||gv_delim||        
                      ca_addressline1||gv_delim||       
                      ca_addressline2||gv_delim||       
                      ca_addressline3||gv_delim||       
                      ca_townorcity||gv_delim||         
                      ca_region1||gv_delim||            
                      ca_country||gv_delim||            
                      ca_postalcode||gv_delim||         
                      ca_primaryflag        
                 FROM XXMX_HR_HCM_CONTACTS_V cv,
                      XXMX_HR_HCM_FILE_SET_V1 fs
                WHERE fs.person_id       = cv.cr_relatedpersonid
                  AND cv.ca_addressline1 IS NOT NULL
                  order by 1;

               -- ContactPhone
               CURSOR c_contact_phone IS
                   SELECT  DISTINCT 
                      fs.person_number||'-'||cr_contpersonid||'-'||cp_phonetype||gv_delim|| 
                      'Contact-'||fs.person_number||'-'||cr_contpersonid||gv_delim|| 
                      cp_datefrom||gv_delim||          
                      NVL(cp_dateto,'4712/12/31')||gv_delim||            
                      'CNT_'||fs.person_number||'_'||cp_contpersonid||gv_delim||      
                      cp_legislationcode||gv_delim||   
                      cp_countrycodenumber||gv_delim|| 
                      cp_phonetype||gv_delim||         
                      cp_phonenumber||gv_delim||       
                      cp_primaryflag
                 FROM XXMX_HR_HCM_CONTACTS_V cv,
                      XXMX_HR_HCM_FILE_SET_V1 fs
                WHERE fs.person_id       = cv.cr_relatedpersonid
                  AND cv.cp_phonenumber IS NOT NULL
                  order by 1;

               -- ContactName
               CURSOR c_contact_name IS
                     SELECT  DISTINCT 
                      fs.person_number||'-'||cr_contpersonid||gv_delim|| 
                      'Contact-'||fs.person_number||'-'||cr_contpersonid||gv_delim|| 
                     --ca_effectivestartdate||gv_delim|| 
                          c_start_date||gv_delim||
                          NVL(ca_effectiveenddate,'4712/12/31')||gv_delim|| 
                          --fs.person_number||gv_delim|| 
                          'CNT_'||fs.person_number||'_'||cr_contpersonid||gv_delim||
                          c_legislation_code||gv_delim||         
                          'GLOBAL'||gv_delim||         
                          c_first_name||gv_delim|| 
                          c_last_name
                     FROM XXMX_HR_HCM_CONTACTS_V cv,
                          XXMX_HR_HCM_FILE_SET_V1 fs
                    WHERE fs.person_id       = cv.cr_relatedpersonid
                    order by 1;

               -- ContactRelationship
               CURSOR c_contact_relationship IS
                    SELECT  DISTINCT 
                           fs.person_number||'-'||cr_contpersonid||'-'||cr_contacttype||gv_delim|| 
                          'Contact-'||fs.person_number||'-'||cr_contpersonid||gv_delim|| 
                          cr_effectivestartdate||gv_delim||  
                          cr_effectiveenddate||gv_delim||
                          --fs.person_number||gv_delim|| 
                          'CNT_'||fs.person_number||'_'||cr_contpersonid||gv_delim||
                          cr_relatedpersonnum||gv_delim||
                          cr_contacttype||gv_delim||
                          cr_emergencycontactflag||gv_delim||
                          cr_primarycontactflag||gv_delim||
                          cr_existingperson||gv_delim||
                          cr_personalflag||gv_delim||
                          cr_sequencenumber
                     FROM XXMX_HR_HCM_CONTACTS_V cv,
                          XXMX_HR_HCM_FILE_SET_V1 fs
                    WHERE fs.person_id       = cv.cr_relatedpersonid
                    order by 1;
			--Changed by Pallavi

          --
          --************************
          -- Constant Declarations
          --************************
          --
          --
          cv_ProcOrFuncName        CONSTANT  VARCHAR2(30)                                := 'gen_per_worker';
        --  ct_file_location_type    CONSTANT xxmx_file_locations.file_location_type%TYPE  := 'HCM_INTERNAL';
          ct_StgTable              CONSTANT xxmx_migration_metadata.stg_table%TYPE       := 'dat';

          cv_metadata              CONSTANT VARCHAR2(30) := 'METADATA';

          cv_title_line            CONSTANT VARCHAR2(20) := 'T'; 
          cv_data_line             CONSTANT VARCHAR2(20) := 'D'; 

          -- Line Name
          cv_contact               VARCHAR2(40) := 'Contact';
          cv_contact_addr          VARCHAR2(40) := 'ContactAddress';
          cv_contact_phone         VARCHAR2(40) := 'ContactPhone';
          cv_contact_name          VARCHAR2(40) := 'ContactName';
          cv_contact_relationship  VARCHAR2(40) := 'ContactRelationship';

          --
          /*************************
          ** Variable Declarations
          *************************/
          --
          vv_FusionAsgNumber             VARCHAR2(100);
          vd_BeginDate                   DATE;

          vv_file_type              VARCHAR2(10) := 'M';
          vv_file_type_name         VARCHAR2(20) := 'MERGE';

          vv_file_dir              xxmx_file_locations.file_location%TYPE;
          vv_line                  VARCHAR2(3000);

          --
          /****************************
          ** Record Table Declarations
          *****************************/
          --
          type type_per_data is table of varchar2(30000) index by binary_integer;
          g_per_data                 type_per_data;
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
          -- Initialise Procedure Global Variables
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
               ,pt_i_ModuleMessage     => 'Procedure "'
                                        ||gct_PackageName
                                        ||'.'
                                        ||cv_ProcOrFuncName
                                        ||'" initiated.'
               ,pt_i_OracleError       => NULL
               );

                     gvt_MigrationSetName := xxmx_utilities_pkg.get_migration_set_name(pt_i_MigrationSetID);

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
                              ,pt_i_ModuleMessage     => 'Migration Set Name '
                                                       ||gvt_MigrationSetName
                              ,pt_i_OracleError       => NULL
                              );

                       vv_file_dir := xxmx_hdl_utilities_pkg.get_directory_path
                                                        (gct_ApplicationSuite
                                                        ,gct_Application
                                                        ,pt_i_BusinessEntity
                                                        ,ct_file_location_type);

                       DELETE FROM xxmx_hdl_file_temp  WHERE  UPPER(file_name) = UPPER(pt_i_FileName);

                        gvv_ProgressIndicator := '0050';            

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
                              ,pt_i_ModuleMessage     => 'Calling OPEN_hdl '
                                                        ||gvt_MigrationSetName
                                                        ||' File Name          '||pt_i_FileName
                                                        ||' ORA File Directory '||vv_file_dir
                                                        ||' vv_file_type       '||vv_file_type
                              ,pt_i_OracleError       => NULL
                              );

                 -- Start generating the HDL data file
                 -- OPEN the Merge file, main header will be automatically written
                    xxmx_hdl_utilities_pkg.OPEN_hdl (gv_ClientCode
                                                    ,pt_i_BusinessEntity
                                                    ,pt_i_FileName
                                                    ,vv_file_dir
                                                    ,vv_file_type
                                                    );
                 --
                -- Contact
                  OPEN c_contact; 
                 FETCH c_contact BULK COLLECT INTO g_per_data; 
                 CLOSE c_contact;

                 IF g_per_data.COUNT > 0 THEN
                    dbms_output.put_line('contacthdr:'||cv_contact);
                     xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'T',cv_contact,NULL,'M');
                 END IF;

                 FOR i IN 1..g_per_data.COUNT LOOP
                     xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'D',cv_contact,g_per_data(i),'M');
                 END LOOP; 
                 g_per_data.DELETE;
                    commit;
                --
                -- ContactAddress
                  OPEN c_contact_addr; 
                 FETCH c_contact_addr BULK COLLECT INTO g_per_data; 
                 CLOSE c_contact_addr;

                 IF g_per_data.COUNT > 0 THEN
                     xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'T',cv_contact_addr,NULL,'M');
                 END IF;

                 FOR i IN 1..g_per_data.COUNT LOOP
                     xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'D',cv_contact_addr,g_per_data(i),'M');
                 END LOOP; 
                 g_per_data.DELETE;
                 commit;
                 --
                 --  
               -- ContactPhone
                 OPEN c_contact_phone; 
                 FETCH c_contact_phone BULK COLLECT INTO g_per_data; 
                 CLOSE c_contact_phone;

                 IF g_per_data.COUNT > 0 THEN
                     xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'T',cv_contact_phone,NULL,'M');
                 END IF;

                 FOR i IN 1..g_per_data.COUNT LOOP
                     xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'D',cv_contact_phone,g_per_data(i),'M');
                 END LOOP; 
                 g_per_data.DELETE;
                 commit;

                -- ContactName
                  OPEN c_contact_name; 
                 FETCH c_contact_name BULK COLLECT INTO g_per_data; 
                 CLOSE c_contact_name;

                   IF g_per_data.COUNT > 0 THEN
                     xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'T',cv_contact_name,NULL,'M');
                 END IF;

                 FOR i IN 1..g_per_data.COUNT LOOP
                     xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'D',cv_contact_name,g_per_data(i),'M');
                 END LOOP; 
                 g_per_data.DELETE;
                 commit;
              -- ContactRelationship
                  OPEN c_contact_relationship; 
                 FETCH c_contact_relationship BULK COLLECT INTO g_per_data; 
                 CLOSE c_contact_relationship;

                   IF g_per_data.COUNT > 0 THEN
                     xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'T',cv_contact_relationship,NULL,'M');
                   END IF;

                 FOR i IN 1..g_per_data.COUNT LOOP
                     xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'D',cv_contact_relationship,g_per_data(i),'M');
                 END LOOP; 
                 g_per_data.DELETE;
                 --
                 commit;
                 --
                 -- CLOSE the file handler
                  --  xxmx_hdl_utilities_pkg.CLOSE_hdl;

     END gen_contacts_file;     

     /*****************************************
     ** PROCEDURE: gen_assignment_add_file
     ******************************************/
	PROCEDURE gen_assignment_add_file
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_migration_metadata.business_entity%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    ,pt_i_FileName                   IN      xxmx_migration_metadata.data_file_name%TYPE                    
                   )
     IS
          --
          /**********************
          ** CURSOR Declarations
          ***********************/
            -- Worker WorkTerms
               CURSOR c_per_workterms IS
                   SELECT  DISTINCT 
                           wa.asg_work_terms_assignment_id||gv_delim  -- Assignment Number
                         ||wa.asg_work_terms_assignment_id||gv_delim  -- Assignment Name
                         ||'EBS'||gv_delim          -- SourceSystemId
                         ||'Workterms-'||wa.asg_work_terms_assignment_id||gv_delim
                         ||'WorkRelationship-'||fs.person_number||gv_delim
                         ||'Worker-'||fs.person_number||gv_delim
                         ||fs.action_code||gv_delim
                         --||SUBSTR(wa.asg_work_terms_assignment_id,1,2)||gv_delim
                         ||wa.asg_assignment_status_type||gv_delim
                        -- ||DECODE(wa.asg_assignment_status_type_id,'ACTIVE_ASSIGN',1,2)||gv_delim  -- ACTIVE_ASSIGN 1 TERM_ASSIGN  2
                         ||DECODE(SUBSTR(wa.asg_work_terms_assignment_id,1,2),'ET','ET','CT','CT','ET')||gv_delim
                         ||RTRIM(wa.asg_business_unit_name)||gv_delim  --BusinessUnitShortCode <<BLNK>>                         
                         ||wa.pps_start_date||gv_delim
						 --||wa.asg_effective_start_date||gv_delim
                         ||wa.asg_effective_end_date||gv_delim
                         ||wa.asg_effective_latest_change||gv_delim
                         ||wa.asg_effective_sequence||gv_delim
                         ||wa.asg_min_eff_start_date||gv_delim
                         ||RTRIM(wa.asg_legal_employer_name)||gv_delim
                         ||fs.person_number||gv_delim
                         ||asg_primary_work_terms_flag||gv_delim
                         ||DECODE(SUBSTR(wa.asg_work_terms_assignment_id,1,2),'ET','E','CT','C',wa.asg_proposed_worker_type)||gv_delim
                         ||wa.asg_people_group_name||gv_delim
                         ||wa.asg_grade_ladder_pgm_name
                     FROM XXMX_HR_HCM_WORK_ASSIGN_V wa,
                          XXMX_HR_HCM_FILE_SET_V1 fs
                    WHERE fs.person_id = wa.asg_person_id
                      AND fs.assignment_number  =wa.asg_assignment_number
                      AND UPPER(fs.action_code) = UPPER(asg_action_code)
                      AND UPPER(fs.action_code) = 'ADD_ASSIGN'
                      AND wa.asg_assignment_status_type_id IS NOT NULL
                      AND wa.asg_effective_start_date IS NOT NULL
                      order by 1;

              /* Added new for ADD_ASSIGN Effective_Start_Date V1.31*/
               CURSOR c_per_assignment_add IS
                    SELECT  DISTINCT 
                           fs.assignment_number||gv_delim -- Assignment Number
                         ||fs.assignment_number||gv_delim -- Assignment Name
                         ||wa.asg_work_terms_assignment_id||gv_delim   
                         ||'EBS'||gv_delim          -- SourceSystemId
                         ||'Assignment-'||fs.assignment_number||gv_delim
                         ||'Workterms-'||wa.asg_work_terms_assignment_id||gv_delim     
                         ||'WorkRelationship-'||fs.person_number||gv_delim
                         ||'Worker-'||fs.person_number||gv_delim
                         --||wa.asg_effective_start_date||gv_delim -- Commented for backlog 916 
                         ||wa.asg_min_eff_start_date||gv_delim 
                         ||wa.asg_effective_end_date||gv_delim
                         ||fs.person_number||gv_delim
                         ||wa.asg_effective_sequence||gv_delim     --||wa.asg_assignment_sequence||gv_delim 
                         ||wa.asg_effective_latest_change||gv_delim --  ||'Y'||gv_delim -- Placeholder default
                         ||wa.pps_start_date||gv_delim   
                         ||fs.action_code||gv_delim
                         ||''||gv_delim
                         ||DECODE(wa.asg_system_person_type,'CWK','C',wa.asg_proposed_worker_type)||gv_delim      -- worker type
                         ||RTRIM(wa.asg_legal_employer_name)||gv_delim
                         ||wa.asg_primary_assignment_flag||gv_delim    -- should be 'Y'
                         ||NVL(wa.asg_assignment_status_type,'ACTIVE_PROCESS')||gv_delim
                   --      ||DECODE(NVL(wa.asg_assignment_status_type_id,'ACTIVE_ASSIGN'),'ACTIVE_ASSIGN',1,2)||gv_delim
                         ||RTRIM(wa.asg_business_unit_name)||gv_delim    --||RTRIM(business_unit_name)||gv_delim Busness Unit Short Code
                         ||wa.asg_assignment_type||gv_delim
                         ||wa.asg_workercategory||gv_delim  -- WORKER CATEGORY
                         ||DECODE(wa.asg_system_person_type,'EX_EMP','EMP',wa.asg_system_person_type)||gv_delim  
                         ||RTRIM(wa.asg_legal_employer_name)||gv_delim  -- TaxReportingUnit
                         ||wa.asg_employment_category  -- Assignment Category
                      FROM XXMX_HR_HCM_WORK_ASSIGN_V wa,
                           XXMX_HR_HCM_FILE_SET_V1 fs
                     WHERE fs.person_id          = wa.asg_person_id
                       AND fs.assignment_number  = wa.asg_assignment_number
                       AND UPPER(fs.action_code) = UPPER(asg_action_code)
                       AND UPPER(fs.action_code) = 'ADD_ASSIGN'
                       AND asg_effective_start_date IS NOT NULL
                       order by 1; 
               /* End of Added new for ADD_ASSIGN Effective_Start_Date V1.31*/



          --
          /************************
          ** Constant Declarations
          *************************/
          --
          cv_ProcOrFuncName           CONSTANT  VARCHAR2(30)                                := 'gen_assignment_add_file';
        --  ct_file_location_type       CONSTANT xxmx_file_locations.file_location_type%TYPE  := 'HCM_INTERNAL';
          ct_StgTable                 CONSTANT xxmx_migration_metadata.stg_table%TYPE       := 'dat';

          cv_metadata              CONSTANT VARCHAR2(30) := 'METADATA';

          cv_title_line            CONSTANT VARCHAR2(20) := 'T'; 
          cv_data_line             CONSTANT VARCHAR2(20) := 'D'; 


          -- Line Name
          cv_wrk_terms             CONSTANT VARCHAR2(30) := 'WorkTerms';        
          cv_work_assignment       CONSTANT VARCHAR2(30) := 'Assignment';  

          --
          /*************************
          ** Variable Declarations
          *************************/
          --
          vv_FusionAsgNumber             VARCHAR2(100);
          vd_BeginDate                   DATE;

          vv_file_type              VARCHAR2(10) := 'M';
          vv_file_type_name         VARCHAR2(20) := 'MERGE';

          vv_file_dir              xxmx_file_locations.file_location%TYPE;
          vv_line                  VARCHAR2(3000);

          --
          /****************************
          ** Record Table Declarations
          *****************************/
          --
          type type_per_data is table of varchar2(30000) index by binary_integer;
          g_per_data                 type_per_data;
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
               ,pt_i_ModuleMessage     => 'Procedure "'
                                        ||gct_PackageName
                                        ||'.'
                                        ||cv_ProcOrFuncName
                                        ||'" initiated.'
               ,pt_i_OracleError       => NULL
               );

                     gvt_MigrationSetName := xxmx_utilities_pkg.get_migration_set_name(pt_i_MigrationSetID);

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
                              ,pt_i_ModuleMessage     => 'Migration Set Name '
                                                       ||gvt_MigrationSetName
                              ,pt_i_OracleError       => NULL
                              );

                       vv_file_dir := xxmx_hdl_utilities_pkg.get_directory_path
                                                        (gct_ApplicationSuite
                                                        ,gct_Application
                                                        ,pt_i_BusinessEntity
                                                        ,ct_file_location_type);

                       DELETE FROM xxmx_hdl_file_temp WHERE  UPPER(file_name) = UPPER(pt_i_FileName);

                        gvv_ProgressIndicator := '0050';            

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
                              ,pt_i_ModuleMessage     => 'Calling OPEN_hdl '
                                                        ||gvt_MigrationSetName
                                                        ||' File Name          '||pt_i_FileName
                                                        ||' ORA File Directory '||vv_file_dir
                                                        ||' vv_file_type       '||vv_file_type
                              ,pt_i_OracleError       => NULL
                              );

                 -- Start generating the HDL data file
                 -- OPEN the Merge file, main header will be automatically written
                    xxmx_hdl_utilities_pkg.OPEN_hdl (gv_ClientCode
                                                    ,pt_i_BusinessEntity
                                                    ,pt_i_FileName
                                                    ,vv_file_dir
                                                    ,vv_file_type
                                                    );
                 --

               -- Work Terms
                 OPEN c_per_workterms; 
                 FETCH c_per_workterms BULK COLLECT INTO g_per_data; 
                 CLOSE c_per_workterms;
                 IF g_per_data.COUNT > 0 THEN
                   -- Write the Business Entity header
                     xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'T',cv_wrk_terms,NULL,'M');
                 END IF;

                 FOR i IN 1..g_per_data.COUNT LOOP
                     xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'D',cv_wrk_terms,g_per_data(i),'M');
                 END LOOP; 
                 g_per_data.DELETE;
                 commit;
                 --
                 -- Worker Assignment
                 OPEN c_per_assignment_add; 
                 FETCH c_per_assignment_add BULK COLLECT INTO g_per_data; 
                 CLOSE c_per_assignment_add;

                 IF g_per_data.COUNT > 0 THEN
                   -- Write the Business Entity header
                     xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'T',cv_work_assignment,NULL,'M');
                 END IF;

                 FOR i IN 1..g_per_data.COUNT LOOP
                     xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'D',cv_work_assignment,g_per_data(i),'M');
                 END LOOP; 
                 g_per_data.DELETE;
                 commit;
                 --
                 --  
                 --
                 -- CLOSE the file handler
                  --  xxmx_hdl_utilities_pkg.CLOSE_hdl;
 --
  END gen_assignment_add_file;


     /*****************************************
     ** PROCEDURE: gen_assignment_Change_file
     ******************************************/
	PROCEDURE gen_assignment_chg_file
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_migration_metadata.business_entity%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    ,pt_i_FileName                   IN      xxmx_migration_metadata.data_file_name%TYPE                    
                   )
     IS
          --
          /**********************
          ** CURSOR Declarations
          ***********************/
            -- Worker WorkTerms
               CURSOR c_per_workterms IS
                   SELECT  DISTINCT 
                           wa.asg_work_terms_assignment_id||gv_delim  -- Assignment Number
                         ||wa.asg_work_terms_assignment_id||gv_delim  -- Assignment Name
                         ||'EBS'||gv_delim          -- SourceSystemId
                         ||'Workterms-'||wa.asg_work_terms_assignment_id||gv_delim
                         ||'WorkRelationship-'||fs.person_number||gv_delim
                         ||'Worker-'||fs.person_number||gv_delim
                         --||fs.action_code||gv_delim commented V1.31
                         ||'ASG_CHANGE'||gv_delim  --V1.31
                         --||SUBSTR(wa.asg_work_terms_assignment_id,1,2)||gv_delim
                         ||wa.asg_assignment_status_type||gv_delim
                        -- ||DECODE(wa.asg_assignment_status_type_id,'ACTIVE_ASSIGN',1,2)||gv_delim  -- ACTIVE_ASSIGN 1 TERM_ASSIGN  2
                         ||DECODE(SUBSTR(wa.asg_work_terms_assignment_id,1,2),'ET','ET','CT','CT','ET')||gv_delim
                         ||RTRIM(wa.asg_business_unit_name)||gv_delim  --BusinessUnitShortCode <<BLNK>>                         
                         ||wa.pps_start_date||gv_delim
						 --||wa.asg_effective_start_date||gv_delim
                         ||wa.asg_effective_end_date||gv_delim
                         ||wa.asg_effective_latest_change||gv_delim
                         ||wa.asg_effective_sequence||gv_delim
                         ||wa.asg_effective_start_date||gv_delim
                         ||RTRIM(wa.asg_legal_employer_name)||gv_delim
                         ||fs.person_number||gv_delim
                         ||asg_primary_work_terms_flag||gv_delim
                         ||DECODE(SUBSTR(wa.asg_work_terms_assignment_id,1,2),'ET','E','CT','C',wa.asg_proposed_worker_type)||gv_delim
                         ||wa.asg_people_group_name||gv_delim
                         ||wa.asg_grade_ladder_pgm_name
                     FROM XXMX_HR_HCM_WORK_ASSIGN_V wa,
                          XXMX_HR_HCM_FILE_SET_V1 fs
                    WHERE fs.person_id = wa.asg_person_id
                      AND fs.assignment_number  =wa.asg_assignment_number
                      AND UPPER(fs.action_code) = UPPER(asg_action_code)
                      AND UPPER(fs.action_code) = 'ADD_ASSIGN'
                      AND wa.asg_assignment_status_type_id IS NOT NULL
                      AND wa.asg_effective_start_date IS NOT NULL
                      order by 1;


               -- ASSIGNMENT
              CURSOR c_per_assignment IS
                  SELECT  DISTINCT 
                           fs.assignment_number||gv_delim -- Assignment Number
                         ||fs.assignment_number||gv_delim -- Assignment Name
                         ||wa.asg_work_terms_assignment_id||gv_delim   
                         ||'EBS'||gv_delim          -- SourceSystemId
                         ||'Assignment-'||fs.assignment_number||gv_delim                          
                         ||'Workterms-'||wa.asg_work_terms_assignment_id||gv_delim                           
                         ||'WorkRelationship-'||fs.person_number||gv_delim
                         ||'Worker-'||fs.person_number||gv_delim
                         ||wa.asg_effective_start_date||gv_delim
                         ||wa.asg_effective_end_date||gv_delim
                         ||fs.person_number||gv_delim
                         ||wa.asg_effective_sequence||gv_delim 
                         ||wa.asg_effective_latest_change||gv_delim --  ||'Y'||gv_delim -- Placeholder default
                         ||wa.pps_start_date||gv_delim   
                         --||fs.action_code||gv_delim commented V1.31
                         ||'ASG_CHANGE'||gv_delim  --V1.31
                         ||''||gv_delim
                         ||DECODE(wa.asg_system_person_type,'CWK','C',wa.asg_proposed_worker_type)||gv_delim      -- worker type
                         ||RTRIM(wa.asg_legal_employer_name)||gv_delim
                         ||wa.asg_primary_assignment_flag||gv_delim    -- should be 'Y'
                         ||wa.asg_assignment_status_type||gv_delim
                        -- ||DECODE(wa.asg_assignment_status_type_id,'ACTIVE_ASSIGN',1,2)||gv_delim  -- ACTIVE_ASSIGN 1 TERM_ASSIGN  2
                         ||RTRIM(wa.asg_business_unit_name)||gv_delim    --||RTRIM(business_unit_name)||gv_delim Busness Unit Short Code
                         ||wa.asg_assignment_type||gv_delim
                         ||wa.asg_person_type_id||gv_delim
                         ||wa.asg_employee_category||gv_delim  -- WORKER CATEGORY
                         ||decode (wa.asg_employment_category,'FR','FULL_TIME','PR','PART_TIME','')||gv_delim
                         ||wa.asg_DATE_PROBATION_END||gv_delim
                         ||wa.asg_NORMAL_HOURS||gv_delim
                         ||wa.asg_FREQUENCY||gv_delim
                         ||decode (wa.asg_system_person_type,'EMP','R','T')||gv_delim   -- PermanentTemporary
                         ||wa.asg_job_code||gv_delim   
                         ||wa.asg_location_code||gv_delim
                         ||wa.asg_organization_id ||gv_delim  -- DepartmentName
                         ||wa.asg_notice_period||gv_delim
                         ||wa.asg_notice_period_uom||gv_delim
                         ||wa.asg_primary_flag||gv_delim  
                         ||wa.asg_hourly_salaried_code||gv_delim 
                         --||''||gv_delim                        -- Position Code  Now Null.
                         ||wa.asg_position_code||gv_delim 
                         ||wa.asg_grade_code||gv_delim    
                         ||wa.asg_bargaining_unit_code||gv_delim         
                         ||wa.asg_labour_union_member_flag||gv_delim 
                         ||wa.asg_manager_flag||gv_delim  
                         ||DECODE(wa.asg_system_person_type,'EX_EMP','EMP',wa.asg_system_person_type)||gv_delim  
                         ||RTRIM(wa.asg_legal_employer_name)||gv_delim
                         ||wa.asg_people_group_name||gv_delim
                         ||wa.asg_grade_ladder_pgm_name||gv_delim
                         ||wa.default_expense_account||gv_delim -- Default Expense Account 1.26
                         ||wa.asg_position_override_flag
                      FROM XXMX_HR_HCM_WORK_ASSIGN_V wa,
                           XXMX_HR_HCM_FILE_SET_V1 fs
                     WHERE fs.person_id = wa.asg_person_id
                       AND fs.assignment_number  = wa.asg_assignment_number
                       AND UPPER(fs.action_code) = UPPER(asg_action_code)
                       AND UPPER(fs.action_code) = 'ADD_ASSIGN'
                       AND wa.asg_assignment_status_type_id IS NOT NULL
                       AND asg_effective_start_date IS NOT NULL
                       order by 1;



                -- Assignment Grade Step      
               CURSOR c_get_asg_grade_steps IS
                     SELECT  DISTINCT 
                         fs.assignment_number
                         ||gv_delim||'Assignment-'||fs.assignment_number
                         ||gv_delim||fs.assignment_number
                         ||gv_delim||gs.gds_effective_start_date
                         ||gv_delim||gs.gds_effective_end_date
                         ||gv_delim||RTRIM(gds_gradestepname)
                         --||gv_delim||'ADD_ASSIGN' --fs.action_code     -- commented V1.31
                         ||gv_delim||'ASG_CHANGE' --fs.action_code     -- V1.31
                         ||gv_delim||NULL
                     FROM XXMX_HR_HCM_ASSIGN_GRADE_STEP_V gs,
                         XXMX_HR_HCM_FILE_SET_V1 fs
                     WHERE fs.person_id = gs.gds_person_id
                     AND gs.gds_assignment_number  = fs.assignment_number
                     AND  UPPER(fs.action_code) = 'ADD_ASSIGN'
                     AND  gs.gds_effective_start_date IS NOT NULL
                     ORDER BY 1;

               -- Assignment Work Measure
               CURSOR c_get_work_measure IS
                    SELECT  DISTINCT 
                         fs.assignment_number||'-'||RTRIM(wm.wm_unit)
                         ||gv_delim||'Assignment-'||fs.assignment_number
                         ||gv_delim||wm.wm_effective_start_date
                         ||gv_delim||wm.wm_effective_end_date
                         ||gv_delim||RTRIM(wm.wm_unit)
                         ||gv_delim||wm.wm_value
                    FROM XXMX_HR_HCM_ASSIGN_WORK_MEAS_V wm,
                         XXMX_HR_HCM_FILE_SET_V1 fs
                    WHERE fs.person_id = wm.wm_person_id
                    AND  UPPER(fs.action_code) = 'ADD_ASSIGN'
					     And wm.wm_assignment_number =fs.assignment_number -- Condition added
                    AND  wm.wm_effective_start_date IS NOT NULL
                    Order By 1;


          --
          /************************
          ** Constant Declarations
          *************************/
          --
          cv_ProcOrFuncName           CONSTANT  VARCHAR2(30)                                := 'gen_assignment_add_file';
        --  ct_file_location_type       CONSTANT xxmx_file_locations.file_location_type%TYPE  := 'HCM_INTERNAL';
          ct_StgTable                 CONSTANT xxmx_migration_metadata.stg_table%TYPE       := 'dat';

          cv_metadata              CONSTANT VARCHAR2(30) := 'METADATA';

          cv_title_line            CONSTANT VARCHAR2(20) := 'T'; 
          cv_data_line             CONSTANT VARCHAR2(20) := 'D'; 


          -- Line Name
          cv_wrk_terms             CONSTANT VARCHAR2(30) := 'WorkTerms';        
          cv_work_assignment       CONSTANT VARCHAR2(30) := 'Assignment';  
          cv_wrk_measure           CONSTANT VARCHAR2(30) := 'AssignmentWorkMeasure';          
          cv_assign_grade          CONSTANT VARCHAR2(30) := 'AssignmentGradeSteps';        

          --
          /*************************
          ** Variable Declarations
          *************************/
          --
          vv_FusionAsgNumber             VARCHAR2(100);
          vd_BeginDate                   DATE;

          vv_file_type              VARCHAR2(10) := 'M';
          vv_file_type_name         VARCHAR2(20) := 'MERGE';

          vv_file_dir              xxmx_file_locations.file_location%TYPE;
          vv_line                  VARCHAR2(3000);

          --
          /****************************
          ** Record Table Declarations
          *****************************/
          --
          type type_per_data is table of varchar2(30000) index by binary_integer;
          g_per_data                 type_per_data;
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
               ,pt_i_ModuleMessage     => 'Procedure "'
                                        ||gct_PackageName
                                        ||'.'
                                        ||cv_ProcOrFuncName
                                        ||'" initiated.'
               ,pt_i_OracleError       => NULL
               );

                     gvt_MigrationSetName := xxmx_utilities_pkg.get_migration_set_name(pt_i_MigrationSetID);

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
                              ,pt_i_ModuleMessage     => 'Migration Set Name '
                                                       ||gvt_MigrationSetName
                              ,pt_i_OracleError       => NULL
                              );

                       vv_file_dir := xxmx_hdl_utilities_pkg.get_directory_path
                                                        (gct_ApplicationSuite
                                                        ,gct_Application
                                                        ,pt_i_BusinessEntity
                                                        ,ct_file_location_type);

                       DELETE FROM xxmx_hdl_file_temp WHERE  UPPER(file_name) = UPPER(pt_i_FileName);

                        gvv_ProgressIndicator := '0050';            

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
                              ,pt_i_ModuleMessage     => 'Calling OPEN_hdl '
                                                        ||gvt_MigrationSetName
                                                        ||' File Name          '||pt_i_FileName
                                                        ||' ORA File Directory '||vv_file_dir
                                                        ||' vv_file_type       '||vv_file_type
                              ,pt_i_OracleError       => NULL
                              );

                 -- Start generating the HDL data file
                 -- OPEN the Merge file, main header will be automatically written
                    xxmx_hdl_utilities_pkg.OPEN_hdl (gv_ClientCode
                                                    ,pt_i_BusinessEntity
                                                    ,pt_i_FileName
                                                    ,vv_file_dir
                                                    ,vv_file_type
                                                    );
                 --

               -- Work Terms
                 OPEN c_per_workterms; 
                 FETCH c_per_workterms BULK COLLECT INTO g_per_data; 
                 CLOSE c_per_workterms;
                 IF g_per_data.COUNT > 0 THEN
                   -- Write the Business Entity header
                     xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'T',cv_wrk_terms,NULL,'M');
                 END IF;

                 FOR i IN 1..g_per_data.COUNT LOOP
                     xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'D',cv_wrk_terms,g_per_data(i),'M');
                 END LOOP; 
                 g_per_data.DELETE;
                 commit;
                 --
                 -- Worker Assignment
                 OPEN c_per_assignment; 
                 FETCH c_per_assignment BULK COLLECT INTO g_per_data; 
                 CLOSE c_per_assignment;

                 IF g_per_data.COUNT > 0 THEN
                   -- Write the Business Entity header
                     xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'T',cv_work_assignment,NULL,'M');
                 END IF;

                 FOR i IN 1..g_per_data.COUNT LOOP
                     xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'D',cv_work_assignment,g_per_data(i),'M');
                 END LOOP; 
                 g_per_data.DELETE;
                 commit;
                 --
                 --  
                 --
                 -- Assignment Work Measure
                 OPEN c_get_work_measure; 
                 FETCH c_get_work_measure BULK COLLECT INTO g_per_data; 
                 CLOSE c_get_work_measure;

                 IF g_per_data.COUNT > 0 THEN
                   -- Write the Business Entity header
                     xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'T',cv_wrk_measure,NULL,'M');
                 END IF;

                 FOR i IN 1..g_per_data.COUNT LOOP
                     xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'D',cv_wrk_measure,g_per_data(i),'M');
                 END LOOP; 
                 g_per_data.DELETE;
                 commit;
                 --
                 --  
                 -- Assignment Grade Step
                 OPEN c_get_asg_grade_steps; 
                 FETCH c_get_asg_grade_steps BULK COLLECT INTO g_per_data; 
                 CLOSE c_get_asg_grade_steps;

                 IF g_per_data.COUNT > 0 THEN
                   -- Write the Business Entity header
                     xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'T',cv_assign_grade,NULL,'M');
                 END IF;

                 FOR i IN 1..g_per_data.COUNT LOOP
                     xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'D',cv_assign_grade,g_per_data(i),'M');
                 END LOOP; 
                 g_per_data.DELETE;
                  commit; 
                 --

                 --
                 -- CLOSE the file handler
                  --  xxmx_hdl_utilities_pkg.CLOSE_hdl;
 --
  END gen_assignment_chg_file;


     /*****************************************
     ** PROCEDURE: gen_third_party_per_paym_file
     ******************************************/
  PROCEDURE gen_third_party_per_paym_file
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_migration_metadata.business_entity%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    ,pt_i_FileName                   IN      xxmx_migration_metadata.data_file_name%TYPE                    
                   )
     IS
    BEGIN 
            NULL;
     END gen_third_party_per_paym_file;

     /*****************************************
     ** PROCEDURE: gen_third_party_org_paym_file
     ******************************************/
	PROCEDURE gen_third_party_org_paym_file
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_migration_metadata.business_entity%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    ,pt_i_FileName                   IN      xxmx_migration_metadata.data_file_name%TYPE                    
                   )
     IS
          /**********************
          ** CURSOR Declarations
          ***********************/
          -- Third Party Org Payment Method --


            CURSOR c_third_org_pay IS
            SELECT distinct
                        to_CHAR(SYSDATE,'RRRR/MM/DD') ||gv_delim||
                        to_CHAR(to_date('31-DEC-4712','DD-MON-RRRR'),'RRRR/MM/DD')||gv_delim||
                        'GB Legislative Data Group' ||gv_delim||
                        TRIM(a.ORGANIZATION_NAME)||gv_delim||
                        a.BANK_NAME||gv_delim||
                        a.BRANCH_NAME||gv_delim||
                        a.BANK_ACCOUNT_NUMBER||gv_delim||
                        a.COUNTRY||gv_delim||
                        a.ORGANIZATION_PAYMENT_METHOD
             from xxmx_third_paymthd_XFM a, xxmx_third_org_xfm b            
            where a.party_id = b.object_id
            and party_usage_code <> 'RELATED_PERSON'
            order by 1;
            --
          /************************
          ** Constant Declarations
          *************************/
          --
          --
          cv_ProcOrFuncName           CONSTANT  VARCHAR2(30)                                := 'gen_third_party_org_paym_file';
        --  ct_file_location_type       CONSTANT xxmx_file_locations.file_location_type%TYPE  := 'HCM_INTERNAL';
          ct_StgTable                 CONSTANT xxmx_migration_metadata.stg_table%TYPE       := 'dat';

          cv_metadata              CONSTANT VARCHAR2(30) := 'METADATA';

          cv_title_line            CONSTANT VARCHAR2(20) := 'T'; 
          cv_data_line             CONSTANT VARCHAR2(20) := 'D'; 

          -- Line Name
          cv_third_org_pay                VARCHAR2(100) := 'ThirdPartyOrganizationPaymentMethod';

          --
          /*************************
          ** Variable Declarations
          *************************/
          --
          vv_FusionAsgNumber             VARCHAR2(100);
          vd_BeginDate                   DATE;

          vv_file_type              VARCHAR2(10) := 'M';
          vv_file_type_name         VARCHAR2(20) := 'MERGE';

          vv_file_dir              xxmx_file_locations.file_location%TYPE;
          vv_line                  VARCHAR2(3000);

          --
          /****************************
          ** Record Table Declarations
          *****************************/
          --
          type type_per_data is table of varchar2(30000) index by binary_integer;
          g_per_data                 type_per_data;
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

    BEGIN  

         --** Initialise Procedure Global Variables
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
          -- Delete any DATA messages FROM previous executions
          -- FOR the Business Entity and Business Entity Level.
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
               ,pt_i_ModuleMessage     => 'Procedure "'
                                        ||gct_PackageName
                                        ||'.'
                                        ||cv_ProcOrFuncName
                                        ||'" initiated.'
               ,pt_i_OracleError       => NULL
               );

          gvt_MigrationSetName := xxmx_utilities_pkg.get_migration_set_name(pt_i_MigrationSetID);

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
                              ,pt_i_ModuleMessage     => 'Migration Set Name '
                                                       ||gvt_MigrationSetName
                              ,pt_i_OracleError       => NULL
                              );

                       vv_file_dir := xxmx_hdl_utilities_pkg.get_directory_path
                                                        (gct_ApplicationSuite
                                                        ,gct_Application
                                                        ,pt_i_BusinessEntity
                                                        ,ct_file_location_type);

                       DELETE FROM xxmx_hdl_file_temp  WHERE  UPPER(file_name) = UPPER(pt_i_FileName);

                        gvv_ProgressIndicator := '0050';            

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
                              ,pt_i_ModuleMessage     => 'Calling OPEN_hdl '
                                                        ||gvt_MigrationSetName
                                                        ||' File Name          '||pt_i_FileName
                                                        ||' ORA File Directory '||vv_file_dir
                                                        ||' vv_file_type       '||vv_file_type
                              ,pt_i_OracleError       => NULL
                              );

                 -- Start generating the HDL data file
                 -- OPEN the Merge file, main header will be automatically written
                    xxmx_hdl_utilities_pkg.OPEN_hdl (gv_ClientCode
                                                    ,pt_i_BusinessEntity
                                                    ,pt_i_FileName
                                                    ,vv_file_dir
                                                    ,vv_file_type
                                                    );

                gvv_ProgressIndicator := '0060';            

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
                              ,pt_i_ModuleMessage     => 'Cursor for ThirdParty'
                              ,pt_i_OracleError       => NULL
                              );

                 --
                 -- Third Party Org Payment Method
                 OPEN c_third_org_pay; 
                 FETCH c_third_org_pay BULK COLLECT INTO g_per_data; 
                 CLOSE c_third_org_pay;

                   IF g_per_data.COUNT > 0 THEN
                     xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'T',cv_third_org_pay,NULL,'M');
                   END IF;

                 FOR i IN 1..g_per_data.COUNT LOOP
                     xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'D',cv_third_org_pay,g_per_data(i),'M');

                 END LOOP; 
                 g_per_data.DELETE;
                 commit;

   END gen_third_party_org_paym_file;

    /*****************************************
     ** PROCEDURE: gen_assigned_payroll_file
     ******************************************/
	PROCEDURE gen_assigned_payroll_file
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_migration_metadata.business_entity%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    ,pt_i_FileName                   IN      xxmx_migration_metadata.data_file_name%TYPE                    
                    )
     IS
               /**********************
          ** CURSOR Declarations
          ***********************/
          -- WORKER
               CURSOR c_assigned_payroll IS
                   /*SELECT DISTINCT  
                       fs.person_number||gv_delim|| 
                       TO_CHAR(fs.per_start_date,'RRRR/MM/DD')||gv_delim||  -- Start_date      
                       TO_CHAR(fs.per_start_date,'RRRR/MM/DD')||gv_delim||  
                       TO_CHAR(p.effective_end_date,'RRRR/MM/DD')||gv_delim||        
                       p.attribute2||gv_delim|| 
                       p.payroll_name||gv_delim|| 
                       fs.assignment_number 
                  FROM xxmx_asg_payroll_xfm p,
                        XXMX_HR_HCM_FILE_SET_V1 fs
                 WHERE fs.person_id = p.person_id
                 and p.assignment_number = fs.assignment_number  -- fix for issue
                   AND UPPER(fs.action_code) IN('ADD_ASSIGN', 'CURRENT')
                   order by 1;*/
                   SELECT DISTINCT  
                       fs.person_number||'-'|| fs.assignment_number||gv_delim||
                       fs.per_start_date||gv_delim|| 
                       TO_CHAR(p.effective_end_date,'RRRR/MM/DD')||gv_delim|| 
                       p.attribute2||gv_delim|| 
                       p.payroll_name||gv_delim|| 
                       fs.assignment_number 
                  FROM xxmx_asg_payroll_xfm p,
                        XXMX_HR_HCM_FILE_SET_V1 fs
                 WHERE fs.person_id = p.person_id
                 and p.assignment_number = fs.assignment_number  -- fix for issue
                 AND UPPER(fs.action_code) IN('CURRENT')
                   UNION 
                SELECT DISTINCT  
                       fs.person_number||'-'|| fs.assignment_number||gv_delim|| 
                       TO_CHAR(p.effective_start_date,'RRRR/MM/DD')||gv_delim||   -- Start_date      
                       TO_CHAR(p.effective_start_date,'RRRR/MM/DD')||gv_delim|| 
                       TO_CHAR(p.effective_end_date,'RRRR/MM/DD')||gv_delim|| 
                       p.attribute2||gv_delim|| 
                       p.payroll_name||gv_delim|| 
                       fs.assignment_number 
                  FROM xxmx_asg_payroll_xfm p,
                        XXMX_HR_HCM_FILE_SET_V1 fs
                 WHERE fs.person_id = p.person_id
                 and p.assignment_number = fs.assignment_number  -- fix for issue
                   AND UPPER(fs.action_code) IN('ADD_ASSIGN')
                   order by 1;


          /************************
          ** Constant Declarations
          *************************/
          cv_ProcOrFuncName           CONSTANT  VARCHAR2(30)                                := 'gen_assigned_payroll_file';
        --  ct_file_location_type       CONSTANT xxmx_file_locations.file_location_type%TYPE  := 'HCM_INTERNAL';
          ct_StgTable                 CONSTANT xxmx_migration_metadata.stg_table%TYPE       := 'dat';

          cv_metadata              CONSTANT VARCHAR2(30) := 'METADATA';

          cv_title_line            CONSTANT VARCHAR2(20) := 'T'; 
          cv_data_line             CONSTANT VARCHAR2(20) := 'D'; 

          -- Line Name
          cv_assigned_payroll         CONSTANT VARCHAR2(30) := 'AssignedPayroll';   
          --
          /*************************
          ** Variable Declarations
          *************************/
          --
          vv_FusionAsgNumber             VARCHAR2(100);
          vd_BeginDate                   DATE;

          vv_file_type              VARCHAR2(10) := 'M';
          vv_file_type_name         VARCHAR2(20) := 'MERGE';

          vv_file_dir              xxmx_file_locations.file_location%TYPE;
          vv_line                  VARCHAR2(3000);

          --
          /****************************
          ** Record Table Declarations
          *****************************/
          --
          type type_per_data is table of varchar2(30000) index by binary_integer;
          g_per_data                 type_per_data;
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
               ,pt_i_ModuleMessage     => 'Procedure "'
                                        ||gct_PackageName
                                        ||'.'
                                        ||cv_ProcOrFuncName
                                        ||'" initiated.'
               ,pt_i_OracleError       => NULL
               );

          gvt_MigrationSetName := xxmx_utilities_pkg.get_migration_set_name(pt_i_MigrationSetID);

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
                              ,pt_i_ModuleMessage     => 'Migration Set Name '
                                                       ||gvt_MigrationSetName
                              ,pt_i_OracleError       => NULL
                              );

                       vv_file_dir := xxmx_hdl_utilities_pkg.get_directory_path
                                                        (gct_ApplicationSuite
                                                        ,gct_Application
                                                        ,pt_i_BusinessEntity
                                                        ,ct_file_location_type);

                       DELETE FROM xxmx_hdl_file_temp  WHERE  UPPER(file_name) = UPPER(pt_i_FileName);

                        gvv_ProgressIndicator := '0050';            

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
                              ,pt_i_ModuleMessage     => 'Calling OPEN_hdl '
                                                        ||gvt_MigrationSetName
                                                        ||' File Name          '||pt_i_FileName
                                                        ||' ORA File Directory '||vv_file_dir
                                                        ||' vv_file_type       '||vv_file_type
                              ,pt_i_OracleError       => NULL
                              );

                 -- Start generating the HDL data file
                 -- OPEN the Merge file, main header will be automatically written
                    xxmx_hdl_utilities_pkg.OPEN_hdl (gv_ClientCode
                                                    ,pt_i_BusinessEntity
                                                    ,pt_i_FileName
                                                    ,vv_file_dir
                                                    ,vv_file_type
                                                    );
                 --
                 -- Assigned Payroll
                  OPEN c_assigned_payroll; 
                 FETCH c_assigned_payroll BULK COLLECT INTO g_per_data; 
                 CLOSE c_assigned_payroll;

                   IF g_per_data.COUNT > 0 THEN
                   -- Write the Business Entity header
                     xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'T',cv_assigned_payroll,NULL,'M');
                 END IF;

                 FOR i IN 1..g_per_data.COUNT LOOP
                     xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'D',cv_assigned_payroll,g_per_data(i),'M');
                 END LOOP; 
                 g_per_data.DELETE;
                 commit;
                 --
                 --
                 --
                 -- CLOSE the file handler
                    xxmx_hdl_utilities_pkg.CLOSE_hdl;

    END gen_assigned_payroll_file;

    /***************************************
    ** PROCEDURE : Gen_Disability
    ***************************************/
	PROCEDURE gen_disability_file
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_migration_metadata.business_entity%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    ,pt_i_FileName                   IN      xxmx_migration_metadata.data_file_name%TYPE                    
                    )
     IS
           /**********************
          ** CURSOR Declarations
          ***********************/
          -- disability --
      CURSOR c_disability IS
        SELECT DISTINCT
              s.PERSONNUMBER||'-'||to_char(to_date(s.EFFECTIVESTARTDATE,'DD-MON-RR'),'RRRRMMDD')||'-'||s.CATEGORY||gv_delim||       -- Assignment_number|
              to_char(to_date(effectivestartdate,'DD-MON-RR'),'RRRR/MM/DD')||gv_delim||   -- DateFrom|
              --to_char(to_date('31-DEC-4721','DD-MON-RR'),'RRRR/MM/DD')||gv_delim||     -- DateTo|
              to_char(to_date('31-DEC-4712','DD-MON-RR'),'RRRR/MM/DD')||gv_delim||     -- DateTo|
              s.LEGISLATIONCODE ||gv_delim||                   -- SalaryBasisName|
              s.personnumber||gv_delim|| 
              s.REGISTRATIONDATE||gv_delim||   -- DateFrom|
              s.REGISTRATIONEXPDATE||gv_delim||   -- DateFrom|
              s.Category||gv_delim||   -- DateFrom|
              s.description||gv_delim||   -- DateFrom|
              s.degree||gv_delim||   -- DateFrom|
              s.QuotaFTE||gv_delim||   -- DateFrom|
              s.Reason||gv_delim||   -- DateFrom|
              s.WorkRestriction||gv_delim||   -- DateFrom|
              s.Status   -- DateFrom|
        FROM  xxmx_per_disability_xfm s,
              XXMX_HR_HCM_FILE_SET_V1 fs
        WHERE fs.person_number  = s.personnumber
        AND fs.action_Code = 'HIRE'
        ORDER BY 1;
          --
          /************************
          ** Constant Declarations
          *************************/
          --
          --
          cv_ProcOrFuncName           CONSTANT  VARCHAR2(30)                                := 'gen_disability_file';
         -- ct_file_location_type       CONSTANT xxmx_file_locations.file_location_type%TYPE  := 'HCM_INTERNAL';
          ct_StgTable                 CONSTANT xxmx_migration_metadata.stg_table%TYPE       := 'dat';

          cv_metadata              CONSTANT VARCHAR2(30) := 'METADATA';

          cv_title_line            CONSTANT VARCHAR2(20) := 'T'; 
          cv_data_line             CONSTANT VARCHAR2(20) := 'D'; 

          -- Line Name
          cv_disability                VARCHAR2(40) := 'PersonDisability';
          --
          /*************************
          ** Variable Declarations
          *************************/
          --
          vv_FusionAsgNumber             VARCHAR2(100);
          vd_BeginDate                   DATE;

          vv_file_type              VARCHAR2(10) := 'M';
          vv_file_type_name         VARCHAR2(20) := 'MERGE';

          vv_file_dir              xxmx_file_locations.file_location%TYPE;
          vv_line                  VARCHAR2(3000);

          --
          /****************************
          ** Record Table Declarations
          *****************************/
          --
          type type_per_data is table of varchar2(30000) index by binary_integer;
          g_per_data                 type_per_data;
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

    BEGIN  

         --** Initialise Procedure Global Variables
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
          -- Delete any DATA messages FROM previous executions
          -- FOR the Business Entity and Business Entity Level.
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
               ,pt_i_ModuleMessage     => 'Procedure "'
                                        ||gct_PackageName
                                        ||'.'
                                        ||cv_ProcOrFuncName
                                        ||'" initiated.'
               ,pt_i_OracleError       => NULL
               );

          gvt_MigrationSetName := xxmx_utilities_pkg.get_migration_set_name(pt_i_MigrationSetID);

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
                              ,pt_i_ModuleMessage     => 'Migration Set Name '
                                                       ||gvt_MigrationSetName
                              ,pt_i_OracleError       => NULL
                              );

                       vv_file_dir := xxmx_hdl_utilities_pkg.get_directory_path
                                                        (gct_ApplicationSuite
                                                        ,gct_Application
                                                        ,pt_i_BusinessEntity
                                                        ,ct_file_location_type);

                       DELETE FROM xxmx_hdl_file_temp  WHERE  UPPER(file_name) = UPPER(pt_i_FileName);

                        gvv_ProgressIndicator := '0050';            

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
                              ,pt_i_ModuleMessage     => 'Calling OPEN_hdl '
                                                        ||gvt_MigrationSetName
                                                        ||' File Name          '||pt_i_FileName
                                                        ||' ORA File Directory '||vv_file_dir
                                                        ||' vv_file_type       '||vv_file_type
                              ,pt_i_OracleError       => NULL
                              );

                 -- Start generating the HDL data file
                 -- OPEN the Merge file, main header will be automatically written
                    xxmx_hdl_utilities_pkg.OPEN_hdl (gv_ClientCode
                                                    ,pt_i_BusinessEntity
                                                    ,pt_i_FileName
                                                    ,vv_file_dir
                                                    ,vv_file_type
                                                    );
                 --
                 -- disability
                  OPEN c_disability; 
                 FETCH c_disability BULK COLLECT INTO g_per_data; 
                 CLOSE c_disability;

                   IF g_per_data.COUNT > 0 THEN
                     xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'T',cv_disability,NULL,'M');
                   END IF;

                 FOR i IN 1..g_per_data.COUNT LOOP
                     xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'D',cv_disability,g_per_data(i),'M');
                 END LOOP; 
                 g_per_data.DELETE;
                 commit;

     END gen_disability_file;

    /***************************************
    ** PROCEDURE : Gen_maternity_Absence_Entry
    ***************************************/
	PROCEDURE gen_abs_maternity_file
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_migration_metadata.business_entity%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    ,pt_i_FileName                   IN      xxmx_migration_metadata.data_file_name%TYPE                    
                    )
     IS
           /**********************
          ** CURSOR Declarations
          ***********************/
          -- Sickness Absence --
      CURSOR c_abs_sickness IS
        SELECT DISTINCT
            --METADATA|PersonAbsenceEntry|SourceSystemOwner|SourceSystemId|Employer|PersonNumber|AbsenceType|AbsenceReason|AbsenceStatus|ApprovalStatus|NotificationDate|ConfirmedDate|Comments|StartDate|StartTime|EndDate|EndTime|AssignmentNumber|StartDateDuration|EndDateDuration
            'PersonAbsenceEntry-'||abs.personnumber||'-'||abs.absencecategory||'-'||to_char(to_date(abs.startdate,'DD-MON-RRRR'),'RRRRMMDD')||gv_delim||
            abs.Legal_employer_name||gv_delim||
            abs.personnumber||gv_delim||
            abs.absencename||gv_delim||
            abs.absencereason||gv_delim||
            'SUBMITTED'||gv_delim||
            'APPROVED'||gv_delim||
            to_char(to_date(abs.date_notification,'DD-MON-RRRR'),'RRRR/MM/DD')||gv_delim||
            to_char(to_date(abs.ConfirmedDate,'DD-MON-RRRR'),'RRRR/MM/DD')||gv_delim||
            abs.Comments||gv_delim||
            to_char(to_date(abs.StartDate,'DD-MON-RRRR'),'RRRR/MM/DD')||gv_delim||
            abs.StartTime||gv_delim||
            to_char(to_date(abs.EndDate,'DD-MON-RRRR'),'RRRR/MM/DD')||gv_delim||
            DECODE (abs.EndDate, NULL, NULL, abs.EndTime)||gv_delim||
            ''||gv_delim||
            NVL(abs.StartDateDuration,0)||gv_delim||
            NVL(abs.EndDateDuration,0)
            FROM XXMX_XFM.xxmx_per_absence_xfm abs
            WHERE  (           UPPER(abs.absencename) like '%SICK%'           )
            UNION 
        SELECT DISTINCT
            --METADATA|PersonAbsenceEntry|SourceSystemOwner|SourceSystemId|Employer|PersonNumber|AbsenceType|AbsenceReason|AbsenceStatus|ApprovalStatus|NotificationDate|ConfirmedDate|Comments|StartDate|StartTime|EndDate|EndTime|AssignmentNumber|StartDateDuration|EndDateDuration
            'PersonAbsenceEntry-'||abs.personnumber||'-'||abs.absencecategory||'-'||to_char(to_date(abs.startdate,'DD-MON-RRRR'),'RRRRMMDD')||gv_delim||
            abs.legal_employer_name||gv_delim||
            abs.personnumber||gv_delim||
            abs.absencename||gv_delim||
            ''||gv_delim||
            'SUBMITTED'||gv_delim||
            'APPROVED'||gv_delim||
            to_char(to_date(abs.date_notification,'DD-MON-RRRR'),'RRRR/MM/DD')||gv_delim||
            to_char(to_date(abs.ConfirmedDate,'DD-MON-RRRR'),'RRRR/MM/DD')||gv_delim||
            abs.Comments||gv_delim||
            to_char(to_date(abs.StartDate,'DD-MON-RRRR'),'RRRR/MM/DD')||gv_delim||
            abs.StartTime||gv_delim||
            to_char(to_date(abs.EndDate,'DD-MON-RRRR'),'RRRR/MM/DD')||gv_delim||
            DECODE (abs.EndDate, NULL, NULL, abs.EndTime)||gv_delim||
            ''||gv_delim||
            NVL(abs.StartDateDuration,0)||gv_delim||
            NVL(abs.EndDateDuration,0)
            FROM XXMX_XFM.xxmx_per_absence_xfm abs
            WHERE  (UPPER(abs.absencename) like '%MATERNITY%')            
            ORDER BY 1;

          --
          --Maternity
        CURSOR c_abs_maternity IS
       SELECT DISTINCT
            --METADATA|PersonAbsenceEntry|SourceSystemOwner|SourceSystemId|Employer|PersonNumber|AbsenceType|AbsenceReason|AbsenceStatus|ApprovalStatus|NotificationDate|ConfirmedDate|Comments|StartDate|StartTime|EndDate|EndTime|AssignmentNumber|StartDateDuration|EndDateDuration
            abs.personnumber||'_'||abs.absencecategory||'_'||to_char(to_date(abs.startdate,'DD-MON-RRRR'),'RRRRMMDD')||gv_delim||
            'PersonAbsenceEntry-'||abs.personnumber||'-'||abs.absencecategory||'-'||to_char(to_date(abs.startdate,'DD-MON-RRRR'),'RRRRMMDD')||gv_delim||
            abs.personnumber||gv_delim||
            --to_char(to_date(abs.StartDate,'DD-MON-RRRR'),'RRRR/MM/DD')||gv_delim||
            ''||gv_delim||
            ''||gv_delim||
            to_char(to_date(abs.startdate,'DD-MON-RRRR'),'RRRR/MM/DD')||gv_delim||
            to_char(to_date(abs.enddate,'DD-MON-RRRR'),'RRRR/MM/DD')||gv_delim||
            abs.intendtoretflag||gv_delim||
            to_char(to_date(abs.due_date,'DD-MON-RRRR'),'RRRR/MM/DD')||gv_delim||
            to_char(to_date(abs.EndDate,'DD-MON-RRRR'),'RRRR/MM/DD')||gv_delim||
            to_char(to_date(abs.StartDate,'DD-MON-RRRR'),'RRRR/MM/DD')||gv_delim||
            to_char(to_date(abs.EndDate,'DD-MON-RRRR'),'RRRR/MM/DD')||gv_delim||
            to_char(to_date(abs.actual_birth_date,'DD-MON-RRRR'),'RRRR/MM/DD')||gv_delim||
            abs.ATTRIBUTE2 -- Open End Date Flag
            FROM XXMX_XFM.xxmx_per_absence_xfm abs
            WHERE  UPPER(abs.absencename) like '%MATERNITY%'
            ORDER BY 1;


          /************************
          ** Constant Declarations
          *************************/
          --
          --
          cv_ProcOrFuncName           CONSTANT  VARCHAR2(30)                                := 'gen_abs_maternity_file';
       --   ct_file_location_type       CONSTANT xxmx_file_locations.file_location_type%TYPE  := 'HCM_INTERNAL';
          ct_StgTable                 CONSTANT xxmx_migration_metadata.stg_table%TYPE       := 'dat';

          cv_metadata              CONSTANT VARCHAR2(30) := 'METADATA';

          cv_title_line            CONSTANT VARCHAR2(20) := 'T'; 
          cv_data_line             CONSTANT VARCHAR2(20) := 'D'; 

          -- Line Name
          cv_abs_sickness                VARCHAR2(40) := 'PersonAbsenceEntry';
          cv_abs_maternity                VARCHAR2(40) := 'PersonMaternityAbsenceEntry';
          --
          /*************************
          ** Variable Declarations
          *************************/
          --
          vv_FusionAsgNumber             VARCHAR2(100);
          vd_BeginDate                   DATE;

          vv_file_type              VARCHAR2(10) := 'M';
          vv_file_type_name         VARCHAR2(20) := 'MERGE';

          vv_file_dir              xxmx_file_locations.file_location%TYPE;
          vv_line                  VARCHAR2(3000);

          --
          /****************************
          ** Record Table Declarations
          *****************************/
          --
          type type_per_data is table of varchar2(30000) index by binary_integer;
          g_per_data                 type_per_data;
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

    BEGIN  

         --** Initialise Procedure Global Variables
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
          -- Delete any DATA messages FROM previous executions
          -- FOR the Business Entity and Business Entity Level.
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
               ,pt_i_ModuleMessage     => 'Procedure "'
                                        ||gct_PackageName
                                        ||'.'
                                        ||cv_ProcOrFuncName
                                        ||'" initiated.'
               ,pt_i_OracleError       => NULL
               );

          gvt_MigrationSetName := xxmx_utilities_pkg.get_migration_set_name(pt_i_MigrationSetID);

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
                              ,pt_i_ModuleMessage     => 'Migration Set Name '
                                                       ||gvt_MigrationSetName
                              ,pt_i_OracleError       => NULL
                              );

                       vv_file_dir := xxmx_hdl_utilities_pkg.get_directory_path
                                                        (gct_ApplicationSuite
                                                        ,gct_Application
                                                        ,pt_i_BusinessEntity
                                                        ,ct_file_location_type);

                       DELETE FROM xxmx_hdl_file_temp  WHERE  UPPER(file_name) = UPPER(pt_i_FileName);

                        gvv_ProgressIndicator := '0050';            

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
                              ,pt_i_ModuleMessage     => 'Calling OPEN_hdl '
                                                        ||gvt_MigrationSetName
                                                        ||' File Name          '||pt_i_FileName
                                                        ||' ORA File Directory '||vv_file_dir
                                                        ||' vv_file_type       '||vv_file_type
                              ,pt_i_OracleError       => NULL
                              );

                 -- Start generating the HDL data file
                 -- OPEN the Merge file, main header will be automatically written
                    xxmx_hdl_utilities_pkg.OPEN_hdl (gv_ClientCode
                                                    ,pt_i_BusinessEntity
                                                    ,pt_i_FileName
                                                    ,vv_file_dir
                                                    ,vv_file_type
                                                    );
                 --
                 -- absence sickness
                 OPEN c_abs_sickness; 
                 FETCH c_abs_sickness BULK COLLECT INTO g_per_data; 
                 CLOSE c_abs_sickness;

                   IF g_per_data.COUNT > 0 THEN
                     xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'T',cv_abs_sickness,NULL,'M');
                   END IF;

                 FOR i IN 1..g_per_data.COUNT LOOP
                     xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'D',cv_abs_sickness,g_per_data(i),'M');
                 END LOOP; 
                 g_per_data.DELETE;
                 commit;

                -- absence maternity
                 OPEN c_abs_maternity; 
                 FETCH c_abs_maternity BULK COLLECT INTO g_per_data; 
                 CLOSE c_abs_maternity;

                   IF g_per_data.COUNT > 0 THEN
                     xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'T',cv_abs_maternity,NULL,'M');
                   END IF;

                 FOR i IN 1..g_per_data.COUNT LOOP
                     xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'D',cv_abs_maternity,g_per_data(i),'M');
                 END LOOP; 
                 g_per_data.DELETE;
                 commit;

     END gen_abs_maternity_file;


    /***************************************
    ** PROCEDURE : Gen_talent_profile_file
    ***************************************/
	PROCEDURE gen_tal_prf_file
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_migration_metadata.business_entity%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    ,pt_i_FileName                   IN      xxmx_migration_metadata.data_file_name%TYPE                    
                    )
     IS
           /**********************
          ** CURSOR Declarations
          ***********************/
          -- Talent Profile --

      CURSOR c_talent_profile IS
        --METADATA|TalentProfile|SourceSystemOwner|SourceSystemId|Description|ProfileCode|ProfileStatusCode|ProfileUsageCode|PersonNumber|ProfileTypeCode
        --MERGE|TalentProfile|HRC_SQLLOADER|TalentProfile_14841_PERSON_PROFILE|M Meachin|PERS_14841|A|P|14841|PERSON

            SELECT distinct
                 'TalentProfile_'||fs.person_number||'_'||PROFILE_ID||gv_delim||
                prf.person_name||gv_delim||
                'PERS_'||fs.person_number||gv_delim||
                PROFILE_STATUS_CODE||gv_delim||
                PROFILE_USAGE_CODE||gv_delim||
                fs.person_number ||gv_delim||
                PROFILE_TYPE_ID
            From XXMX_HR_HCM_TAL_PRF_V PRF,
            XXMX_HR_HCM_FILE_SET_V1 fs
            where fs.person_id = PRF.person_id
            and fs.action_code = 'HIRE'
            order by 1;
  --
          --Profile Item
        CURSOR c_profile_item IS

            --METADATA|ProfileItem|SourceSystemOwner|SourceSystemId|ProfileCode|ContentType|DateFrom|DateTo|ContentItem|SectionId
            --MERGE|ProfileItem|EBS|ProfileItem-14841-Master of Arts|PERS_14841|DEGREE|2021/04/21|4712/12/31|Master of Arts|300000097808250
            Select 
                fs.person_number||'_'||PROFILE_ITEM_ID||gv_delim||
                'PERS_'||fs.person_number||gv_delim||
                CONTENT_TYPE_ID||gv_delim||
                DATE_FROM||gv_delim||
                DATE_TO ||gv_delim||
                NAME||gv_delim||
                SOURCE_ID
            From XXMX_HR_HCM_TAL_PRF_V PRF,
            XXMX_HR_HCM_FILE_SET_V1 fs
            where fs.person_id = PRF.person_id
            and fs.action_code = 'HIRE'
            order by 1;
          /************************
          ** Constant Declarations
          *************************/
          --
          --
          cv_ProcOrFuncName           CONSTANT  VARCHAR2(30)                                := 'gen_tal_prf_file';
        --  ct_file_location_type       CONSTANT xxmx_file_locations.file_location_type%TYPE  := 'HCM_INTERNAL';
          ct_StgTable                 CONSTANT xxmx_migration_metadata.stg_table%TYPE       := 'dat';

          cv_metadata              CONSTANT VARCHAR2(30) := 'METADATA';

          cv_title_line            CONSTANT VARCHAR2(20) := 'T'; 
          cv_data_line             CONSTANT VARCHAR2(20) := 'D'; 

          -- Line Name
          cv_tal_prf                VARCHAR2(40) := 'TalentProfile';
          cv_prf_item               VARCHAR2(40) := 'ProfileItem';
          --
          /*************************
          ** Variable Declarations
          *************************/
          --
          vv_FusionAsgNumber             VARCHAR2(100);
          vd_BeginDate                   DATE;

          vv_file_type              VARCHAR2(10) := 'M';
          vv_file_type_name         VARCHAR2(20) := 'MERGE';

          vv_file_dir              xxmx_file_locations.file_location%TYPE;
          vv_line                  VARCHAR2(3000);

          --
          /****************************
          ** Record Table Declarations
          *****************************/
          --
          type type_per_data is table of varchar2(30000) index by binary_integer;
          g_per_data                 type_per_data;
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

    BEGIN  

         --** Initialise Procedure Global Variables
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
          -- Delete any DATA messages FROM previous executions
          -- FOR the Business Entity and Business Entity Level.
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
               ,pt_i_ModuleMessage     => 'Procedure "'
                                        ||gct_PackageName
                                        ||'.'
                                        ||cv_ProcOrFuncName
                                        ||'" initiated.'
               ,pt_i_OracleError       => NULL
               );

          gvt_MigrationSetName := xxmx_utilities_pkg.get_migration_set_name(pt_i_MigrationSetID);

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
                              ,pt_i_ModuleMessage     => 'Migration Set Name '
                                                       ||gvt_MigrationSetName
                              ,pt_i_OracleError       => NULL
                              );

                       vv_file_dir := xxmx_hdl_utilities_pkg.get_directory_path
                                                        (gct_ApplicationSuite
                                                        ,gct_Application
                                                        ,pt_i_BusinessEntity
                                                        ,ct_file_location_type);

                       DELETE FROM xxmx_hdl_file_temp  WHERE  UPPER(file_name) = UPPER(pt_i_FileName);

                        gvv_ProgressIndicator := '0050';            

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
                              ,pt_i_ModuleMessage     => 'Calling OPEN_hdl '
                                                        ||gvt_MigrationSetName
                                                        ||' File Name          '||pt_i_FileName
                                                        ||' ORA File Directory '||vv_file_dir
                                                        ||' vv_file_type       '||vv_file_type
                              ,pt_i_OracleError       => NULL
                              );

                 -- Start generating the HDL data file
                 -- OPEN the Merge file, main header will be automatically written
                    xxmx_hdl_utilities_pkg.OPEN_hdl (gv_ClientCode
                                                    ,pt_i_BusinessEntity
                                                    ,pt_i_FileName
                                                    ,vv_file_dir
                                                    ,vv_file_type
                                                    );
                 --
                 -- talent profile
                 OPEN c_talent_profile; 
                 FETCH c_talent_profile BULK COLLECT INTO g_per_data; 
                 CLOSE c_talent_profile;

                   IF g_per_data.COUNT > 0 THEN
                     xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'T',cv_tal_prf,NULL,'M');
                   END IF;

                 FOR i IN 1..g_per_data.COUNT LOOP
                     xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'D',cv_tal_prf,g_per_data(i),'M');
                 END LOOP; 
                 g_per_data.DELETE;
                 commit;

                --Profile Item
                 OPEN c_profile_item; 
                 FETCH c_profile_item BULK COLLECT INTO g_per_data; 
                 CLOSE c_profile_item;

                   IF g_per_data.COUNT > 0 THEN
                     xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'T',cv_prf_item,NULL,'M');
                   END IF;

                 FOR i IN 1..g_per_data.COUNT LOOP
                     xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'D',cv_prf_item,g_per_data(i),'M');
                 END LOOP; 
                 g_per_data.DELETE;
                 commit;

     END gen_tal_prf_file;

/***************************************
    ** PROCEDURE : gen_images_file
    ***************************************/
	PROCEDURE gen_images_file
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_migration_metadata.business_entity%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    ,pt_i_FileName                   IN      xxmx_migration_metadata.data_file_name%TYPE                    
                    )
     IS
           /**********************
          ** CURSOR Declarations
          ***********************/
          -- Images --

      CURSOR c_images IS
        --METADATA|PersonImage|SourceSystemOwner|SourceSystemId|PersonNumber|ImageName|Image|PrimaryFlag
        --MERGE|PersonImage|EBS|PersonImage_276043_PERSON28297|28297|Anne_Wells_276043|Anne_Wells_276043.gif|Y
            SELECT distinct
                fs.person_number||'_'||imagename||gv_delim||
                fs.person_number||gv_delim||
                'Image_'||imagename||gv_delim||
                image_ref||gv_delim||
                PRIMARY_FLAG
            From XXMX_PER_IMAGES_STG IMG,
            XXMX_HR_HCM_FILE_SET_V1 fs
            where fs.person_number = IMG.personnumber
            and fs.action_code = 'HIRE'
            order by 1;
            --
          /************************
          ** Constant Declarations
          *************************/
          --
          --
          cv_ProcOrFuncName           CONSTANT  VARCHAR2(30)                                := 'gen_images_file';
       --   ct_file_location_type       CONSTANT xxmx_file_locations.file_location_type%TYPE  := 'HCM_INTERNAL';
          ct_StgTable                 CONSTANT xxmx_migration_metadata.stg_table%TYPE       := 'dat';

          cv_metadata              CONSTANT VARCHAR2(30) := 'METADATA';

          cv_title_line            CONSTANT VARCHAR2(20) := 'T'; 
          cv_data_line             CONSTANT VARCHAR2(20) := 'D'; 

          -- Line Name
          cv_images                VARCHAR2(40) := 'PersonImage';

          --
          /*************************
          ** Variable Declarations
          *************************/
          --
          vv_FusionAsgNumber             VARCHAR2(100);
          vd_BeginDate                   DATE;

          vv_file_type              VARCHAR2(10) := 'M';
          vv_file_type_name         VARCHAR2(20) := 'MERGE';

          vv_file_dir              xxmx_file_locations.file_location%TYPE;
          vv_line                  VARCHAR2(3000);

          --
          /****************************
          ** Record Table Declarations
          *****************************/
          --
          type type_per_data is table of varchar2(30000) index by binary_integer;
          g_per_data                 type_per_data;
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

    BEGIN  

         --** Initialise Procedure Global Variables
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
          -- Delete any DATA messages FROM previous executions
          -- FOR the Business Entity and Business Entity Level.
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
               ,pt_i_ModuleMessage     => 'Procedure "'
                                        ||gct_PackageName
                                        ||'.'
                                        ||cv_ProcOrFuncName
                                        ||'" initiated.'
               ,pt_i_OracleError       => NULL
               );

          gvt_MigrationSetName := xxmx_utilities_pkg.get_migration_set_name(pt_i_MigrationSetID);

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
                              ,pt_i_ModuleMessage     => 'Migration Set Name '
                                                       ||gvt_MigrationSetName
                              ,pt_i_OracleError       => NULL
                              );

                       vv_file_dir := xxmx_hdl_utilities_pkg.get_directory_path
                                                        (gct_ApplicationSuite
                                                        ,gct_Application
                                                        ,pt_i_BusinessEntity
                                                        ,ct_file_location_type);

                       DELETE FROM xxmx_hdl_file_temp  WHERE  UPPER(file_name) = UPPER(pt_i_FileName);

                        gvv_ProgressIndicator := '0050';            

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
                              ,pt_i_ModuleMessage     => 'Calling OPEN_hdl '
                                                        ||gvt_MigrationSetName
                                                        ||' File Name          '||pt_i_FileName
                                                        ||' ORA File Directory '||vv_file_dir
                                                        ||' vv_file_type       '||vv_file_type
                              ,pt_i_OracleError       => NULL
                              );

                 -- Start generating the HDL data file
                 -- OPEN the Merge file, main header will be automatically written
                    xxmx_hdl_utilities_pkg.OPEN_hdl (gv_ClientCode
                                                    ,pt_i_BusinessEntity
                                                    ,pt_i_FileName
                                                    ,vv_file_dir
                                                    ,vv_file_type
                                                    );
                 --
                 -- images
                 OPEN c_images; 
                 FETCH c_images BULK COLLECT INTO g_per_data; 
                 CLOSE c_images;

                   IF g_per_data.COUNT > 0 THEN
                     xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'T',cv_images,NULL,'M');
                   END IF;

                 FOR i IN 1..g_per_data.COUNT LOOP
                     xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'D',cv_images,g_per_data(i),'M');
                 END LOOP; 
                 g_per_data.DELETE;
                 commit;


     END gen_images_file;   

    -- Code added by Kirti
	/***************************************
    ** PROCEDURE : Gen_Leg_DFF
    ***************************************/
	PROCEDURE Gen_Leg_DFF
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_migration_metadata.business_entity%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    ,pt_i_FileName                   IN      xxmx_migration_metadata.data_file_name%TYPE                    
                    )
     IS
           /**********************
          ** CURSOR Declarations
          ***********************/
          -- Legislative DF --
      CURSOR c_legdff IS
        SELECT  DISTINCT 
                         fs.person_number||gv_delim
                    ||'Worker-'||fs.person_number||gv_delim
                    ||per.pps_start_date||gv_delim      --||per.effective_start_date||gv_delim
                    --||per.effective_end_date||gv_delim
					||to_CHAR(to_date('31-DEC-4712','DD-MON-RRRR'),'RRRR/MM/DD')||gv_delim
                    ||fs.person_number||gv_delim
                    ||per.pld_legislation_code||gv_delim
					||'GB'||gv_delim
                    ||'Global Data Elements'||gv_delim
					||per.pld_per_information14||gv_delim
					||per.pld_per_information_date3||gv_delim
					||per.pld_attribute1||gv_delim
					||per.pld_attribute2||gv_delim
					||per.pld_attribute3||gv_delim
                    ||per.pld_attribute7

               FROM XXMX_HR_HCM_PERSON_V per,
                    XXMX_HR_HCM_FILE_SET_V1 fs
              WHERE fs.person_id = per.person_id
                AND UPPER(fs.action_code) = 'HIRE'
                AND per.pps_start_date IS NOT NULL    --per.effective_start_date IS NOT NULL
                AND per.pld_legislation_code IS NOT NULL
                order by 1;
          --
          /************************
          ** Constant Declarations
          *************************/
          --
          --
          cv_ProcOrFuncName           CONSTANT  VARCHAR2(30)                                := 'Gen_Leg_DFF';
        --  ct_file_location_type       CONSTANT xxmx_file_locations.file_location_type%TYPE  := 'HCM_INTERNAL';
          ct_StgTable                 CONSTANT xxmx_migration_metadata.stg_table%TYPE       := 'dat';

          cv_metadata              CONSTANT VARCHAR2(30) := 'METADATA';

          cv_title_line            CONSTANT VARCHAR2(20) := 'T'; 
          cv_data_line             CONSTANT VARCHAR2(20) := 'D'; 

          -- Line Name
          cv_legdff                VARCHAR2(40) := 'PersonLegislativeData';
          --
          /*************************
          ** Variable Declarations
          *************************/
          --
          vv_FusionAsgNumber             VARCHAR2(100);
          vd_BeginDate                   DATE;

          vv_file_type              VARCHAR2(10) := 'M';
          vv_file_type_name         VARCHAR2(20) := 'MERGE';

          vv_file_dir              xxmx_file_locations.file_location%TYPE;
          vv_line                  VARCHAR2(3000);

          --
          /****************************
          ** Record Table Declarations
          *****************************/
          --
          type type_per_data is table of varchar2(30000) index by binary_integer;
          g_per_data                 type_per_data;
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

    BEGIN  

         --** Initialise Procedure Global Variables
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
          -- Delete any DATA messages FROM previous executions
          -- FOR the Business Entity and Business Entity Level.
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
               ,pt_i_ModuleMessage     => 'Procedure "'
                                        ||gct_PackageName
                                        ||'.'
                                        ||cv_ProcOrFuncName
                                        ||'" initiated.'
               ,pt_i_OracleError       => NULL
               );

          gvt_MigrationSetName := xxmx_utilities_pkg.get_migration_set_name(pt_i_MigrationSetID);

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
                              ,pt_i_ModuleMessage     => 'Migration Set Name '
                                                       ||gvt_MigrationSetName
                              ,pt_i_OracleError       => NULL
                              );

                       vv_file_dir := xxmx_hdl_utilities_pkg.get_directory_path
                                                        (gct_ApplicationSuite
                                                        ,gct_Application
                                                        ,pt_i_BusinessEntity
                                                        ,ct_file_location_type);

                       DELETE FROM xxmx_hdl_file_temp  WHERE  UPPER(file_name) = UPPER(pt_i_FileName);

                        gvv_ProgressIndicator := '0050';            

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
                              ,pt_i_ModuleMessage     => 'Calling OPEN_hdl '
                                                        ||gvt_MigrationSetName
                                                        ||' File Name          '||pt_i_FileName
                                                        ||' ORA File Directory '||vv_file_dir
                                                        ||' vv_file_type       '||vv_file_type
                              ,pt_i_OracleError       => NULL
                              );

                 -- Start generating the HDL data file
                 -- OPEN the Merge file, main header will be automatically written
                    xxmx_hdl_utilities_pkg.OPEN_hdl (gv_ClientCode
                                                    ,pt_i_BusinessEntity
                                                    ,pt_i_FileName
                                                    ,vv_file_dir
                                                    ,vv_file_type
                                                    );
                 --
                 -- Legislative DFF update only
                  OPEN c_legdff; 
                 FETCH c_legdff BULK COLLECT INTO g_per_data; 
                 CLOSE c_legdff;

                   IF g_per_data.COUNT > 0 THEN
                     xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'T',cv_legdff,NULL,'M');
                   END IF;

                 FOR i IN 1..g_per_data.COUNT LOOP
                     xxmx_hdl_utilities_pkg.write_hdl_line (pt_i_FileName,'D',cv_legdff,g_per_data(i),'M');
                 END LOOP; 
                 g_per_data.DELETE;
                 commit;

     END Gen_Leg_DFF;
	-- Kirti Code Ends


     /*****************************************
     ** PROCEDURE: gen_main
     ******************************************/
     PROCEDURE gen_main
                    (
                     pt_i_ClientCode                 IN      xxmx_client_config_parameters.client_code%TYPE
                    ,pt_i_MigrationSetName           IN      xxmx_migration_headers.migration_set_name%TYPE
                   )
     IS
          --
          --
          --**********************
          --** CURSOR Declarations
          --**********************
          --
          CURSOR StagingMetadata_cur
          IS
               --
               --
               SELECT  
                       xmm.business_entity
                      ,xmm.sub_entity
                      ,xmm.file_gen_procedure_name
                   --    ,xmm.exp_procedure_name
                      ,xmm.data_file_name
                      ,xmm.data_file_extension
               FROM    xxmx_migration_metadata  xmm
               WHERE   1 = 1
               AND     xmm.application_suite            = gct_ApplicationSuite
               AND     xmm.application                  = gct_Application
               AND     LOWER(xmm.entity_package_name)   = gct_PackageName
               AND     UPPER(xmm.enabled_flag)          = 'Y'
               ORDER BY xmm.sub_entity_seq;
               --
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
          cv_ProcOrFuncName           CONSTANT  VARCHAR2(30)                                := 'gen_main';
          ct_BusinessEntity           CONSTANT  xxmx_migration_metadata.business_entity%TYPE     := 'ALL';
          ct_SubEntity                CONSTANT  xxmx_migration_metadata.sub_entity%TYPE     := 'ALL';
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
          e_ModuleError                   EXCEPTION;
          --
     --** END Declarations **
     --
     BEGIN
          --
          gvv_ProgressIndicator := '0000';
          --
          IF   pt_i_ClientCode       IS NULL
          OR   pt_i_MigrationSetName IS NULL
          THEN
               --
               gvt_Severity      := 'ERROR';
               gvt_ModuleMessage := '- "pt_i_ClientCode" and "pt_i_MigrationSetName" parameters are mandatory.';
               --
               RAISE e_ModuleError;
               --
          END IF;
          --
          --
          /*
          ** Clear Module Messages
          */
          --
          gvv_ReturnStatus  := '';
          --
          xxmx_utilities_pkg.clear_messages
               (
                pt_i_ApplicationSuite => gct_ApplicationSuite
               ,pt_i_Application      => gct_Application
               ,pt_i_BusinessEntity   => 'ALL'
               ,pt_i_SubEntity        => 'ALL'
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
                    ,pt_i_BusinessEntity    =>  'ALL'
                    ,pt_i_SubEntity         =>  'ALL'
                    ,pt_i_Phase             => gct_phase
                    ,pt_i_Severity          => 'ERROR'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
                    ,pt_i_OracleError       => gvt_ReturnMessage
                    );
               --
               RAISE e_ModuleError;
               --
          END IF;
          --
          gvv_ProgressIndicator := '0020';
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    =>  'ALL'
               ,pt_i_SubEntity         =>  'ALL'
               ,pt_i_Phase             => gct_phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gct_PackageName
               ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => ' START Procedure "'
                                        ||gct_PackageName
                                        ||'.'
                                        ||cv_ProcOrFuncName
                                        ||'" initiated.'
               ,pt_i_OracleError       => NULL
               );

          /*
          ** Initialize the Migration Set FOR the Business Entity retrieving
          ** a new Migration Set ID.
          */
          gvv_ProgressIndicator := '0030';
          --
          xxmx_utilities_pkg.init_migration_set
               (
                pt_i_ApplicationSuite => gct_ApplicationSuite
               ,pt_i_Application      => gct_Application
               ,pt_i_BusinessEntity   =>  'ALL'
               ,pt_i_MigrationSetName => pt_i_MigrationSetName
               ,pt_o_MigrationSetID   => vt_MigrationSetID
               );
         --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    =>  'ALL'
               ,pt_i_SubEntity         =>  'ALL'
               ,pt_i_Phase             => gct_phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gct_PackageName
               ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => '- Migration Set "'
                                        ||pt_i_MigrationSetName
                                        ||'" initialized (Generated Migration Set ID = '
                                        ||vt_MigrationSetID
                                        ||').  Processing extracts:'
               ,pt_i_OracleError       => NULL
               );
          --
          /*
          ** Loop through the Migration Metadata table to retrieve
          ** the Staging Package Name, Procedure Name and table name
          ** FOR each extract requied FOR the current Business Entity.
          */
          --
          gvv_ProgressIndicator := '0040';
          --
          FOR  StagingMetadata_rec
          IN   StagingMetadata_cur
          LOOP
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => StagingMetadata_rec.business_entity
                    ,pt_i_SubEntity         => StagingMetadata_rec.sub_entity
                    ,pt_i_Phase             => gct_phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Calling Procedure "'
                          --        ||gct_PackageName||'.'||StagingMetadata_rec.exp_procedure_name
                                             ||gct_PackageName||'.'||StagingMetadata_rec.file_gen_procedure_name
                                             ||' File Generation '
                                             ||StagingMetadata_rec.data_file_name||'.'||StagingMetadata_rec.data_file_extension
                    ,pt_i_OracleError       => NULL
                    );
               --
               --
              gvv_SQLStatement := 'BEGIN '
                                 ||gct_PackageName
                                 ||'.'
                                 ||StagingMetadata_rec.file_gen_procedure_name  
                             --    ||StagingMetadata_rec.exp_procedure_name
                                 ||gcv_SQLSpace
                                 ||'('
                                 ||' pt_i_MigrationSetID          => '
                                 ||vt_MigrationSetID
                                 ||', pt_i_BusinessEntity          => '''
                                 ||StagingMetadata_rec.business_entity
                                 ||''''
                                 ||',pt_i_SubEntity               => '''
                                 ||StagingMetadata_rec.sub_entity
                                 ||''''
                                 ||',pt_i_FileName               => '''
                                 ||StagingMetadata_rec.data_file_name
                                 ||''''
                                 ||'); END;';
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => StagingMetadata_rec.business_entity
                    ,pt_i_SubEntity         => StagingMetadata_rec.sub_entity
                    ,pt_i_Phase             => gct_phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => SUBSTR(
                                                      '- Generated SQL Statement: '
                                                    ||gvv_SQLStatement
                                                     ,1
                                                     ,4000
                                                     )
                    ,pt_i_OracleError       => NULL
                    );
               -- Calls the procedure(s) 
               EXECUTE IMMEDIATE gvv_SQLStatement;
               --
          END LOOP;
          --
          gvv_ProgressIndicator := '0050';
          -- To update the table to completed.
          --xxmx_utilities_pkg.CLOSE_extragct_phase
          --     (
          --      vt_MigrationSetID
          --     );
          --
          COMMIT;
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => 'ALL'
               ,pt_i_SubEntity         =>  'ALL'
               ,pt_i_Phase             => gct_phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gct_PackageName
               ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'HDL File Extaction '
                                        ||gct_PackageName
                                        ||' completed.'
               ,pt_i_OracleError       => NULL
               );
          --
          EXCEPTION
               --
               WHEN e_ModuleError
               THEN
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    =>  'ALL'
                         ,pt_i_SubEntity         =>  'ALL'
                         ,pt_i_Phase             => gct_phase
                         ,pt_i_Severity          => gvt_Severity
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => gvt_ModuleMessage
                         ,pt_i_OracleError       => NULL
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
                                           ||dbms_utility.FORmat_error_backtrace
                                            ,1
                                            ,4000
                                            );
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    =>  'ALL'
                         ,pt_i_SubEntity         =>  'ALL'
                         ,pt_i_Phase             => gct_phase
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => 'Oracle error encounted after Progress Indicator.'
                         ,pt_i_OracleError       => gvt_OracleError
                         ); 
                    --
                    RAISE;
                    --
               --** END OTHERS Exception
               --
          --** END Exception Handler
          --
      END gen_main;

END xxmx_hcm_hdl_file_gen_pkg;
/
SHOW ERRORS PACKAGE BODY xxmx_hcm_hdl_file_gen_pkg;
/