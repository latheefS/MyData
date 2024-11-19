create or replace PACKAGE BODY xxmx_hdl_utilities_pkg
IS
--
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
--** FILENAME  :  xxmx_hdl_utilities_pkg.sql
--**
--** FILEPATH  :  $XXV1_TOP/install/sql
--**
--** VERSION   :  1.12
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
--**   1.0 	 11/11/2020   Jay McNeill         Initial Build
--**   1.1   26/03/2021   Pallavi Kanajar	  Added People Group Name, Supervisor and all Other attributes (location	
--**   	    									            Department, Position to Assignment File
--**   1.2   29/03/2021	  Pallavi Kanajar	  Contact File Issue Fix
--**   1.3   10/05/2021   Pallavi Kanajar     Visa & Third Party Org
--**   1.4   19/05/2021	  Pallavi Kanajar     GradeLadderProgram/PeopleGroupName
--**   1.5   19/05/2021   Kirti				  Changes to include Assignment DFF
--**   1.6   27/05/2021   Pallavi Kanajar     Mapping changes for Region in Address
--**   1.7   31/05/2021   Kirti				  Changes to include Legislative DFF
--**   1.8   24/06/2021   Pallavi             Added DefaultExpenseAccount in both Current and Add_Assign
--**   1.9   08/07/2021   Pallavi             Additional Assignmens WorkMeasure and Gradesteps
--**   1.10  26/07/2021   Pallavi             Assignment Category in Hire Row.
--**   1.11  29/07/2021   Pallavi             Add Assignment Changes to generate two files.
--**   1.12  23/08/2021   Pallavi             External Account Holder Name
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
--*/
     --
     --
     --*******************
     --** GLOBAL VARIABLES
     --*******************
     --
     gcv_PackageName              CONSTANT VARCHAR2(30)                                 := 'xxmx_hdl_utilities_pkg';
     ct_ApplicationSuite         CONSTANT xxmx_module_messages.application_suite%TYPE  := 'HCM';
     ct_Application              CONSTANT xxmx_module_messages.application%TYPE        := 'HR';

   -- In case the delimitter of the file creation changes
     gv_delim                   CONSTANT  VARCHAR2(4) := '|';

     gvv_ProgressIndicator                              VARCHAR2(100);
     gvv_UserName                                       VARCHAR2(100)   := UPPER(sys_context('userenv','OS_USER'));
     gvt_ModuleMessage                                  xxmx_module_messages.module_message%TYPE;
     gvt_OracleError                                    xxmx_module_messages.oracle_error%TYPE;

     gcv_sourcesystem   VARCHAR2(10) :=     'EBS';
     g_file_id        UTL_FILE.FILE_TYPE; 
     --
     --**************************************
     --** PROCEDURE AND FUNCTION DECLARATIONS
     --**************************************
     --
     --**************************************************************
     --** The following PROCEDURE returns all the filenames and 
	 --** directories required for migrating the data associated
	 --** associated with the related business/sub entity.
     --*************************************************************
     --
-- ----------------------------------------------------------------------------
-- |------------------------------< DIR_PATH >--------------------------------|
-- ----------------------------------------------------------------------------
  FUNCTION get_directory_path
            (pv_i_application_suite IN VARCHAR2
            ,pv_i_application IN VARCHAR2
            ,pv_i_business_entity IN VARCHAR2
            ,pv_i_file_location_type IN VARCHAR2
            ,pv_ftp_enabled IN VARCHAR2 DEFAULT 'N'
            ) RETURN VARCHAR2 
            AS 

    CURSOR get_dir_path IS 
       SELECT file_location
         FROM xxmx_file_locations
        WHERE application_suite = pv_i_application_suite
          AND application       = pv_i_application
          AND business_entity   = pv_i_business_entity
          AND used_by   = 'OIC'
          AND file_location_type = pv_i_file_location_type;

    vv_file_directory  VARCHAR2(300);

    exp_dir_NotFound  EXCEPTION;

   BEGIN 
  -- DBMS_OUTPUT.PUT_LINE(pv_i_application_suite||' '||pv_i_application||' '||pv_i_file_location_type||' '||pv_i_business_entity);
     OPEN get_dir_path;
     FETCH get_dir_path INTO vv_file_directory;
     CLOSE get_dir_path;

    -- DBMS_OUTPUT.PUT_LINE('TEST DIR '|| vv_file_directory);

     IF vv_file_directory IS NULL THEN 
        -- put in message handler to rais error.
       -- DBMS_OUTPUT.PUT_LINE('TEST DIR '|| vv_file_directory);
        RAISE exp_dir_NotFound;
     END IF;
     RETURN vv_file_directory;
 EXCEPTION
 when exp_dir_NotFound THEN
 --   print_log ('Error: Unexpected Error');
    raise; 

 when others THEN
    utl_file.fclose_all;
 --   print_log ('Error: Unexpected Error');
    raise; 
end get_directory_path;

-- ----------------------------------------------------------------------------
-- |------------------------------< GET_FILENAME >--------------------------------|
-- ----------------------------------------------------------------------------
  FUNCTION get_filename
            (pv_i_application_suite IN VARCHAR2
            ,pv_i_application       IN VARCHAR2
            ,pv_i_business_entity   IN VARCHAR2
            ,pv_i_sub_entity        IN VARCHAR2
            ,pv_ftp_enabled IN VARCHAR2 DEFAULT 'N'
            ) RETURN VARCHAR2 
            AS 

    CURSOR get_file_name IS 
       SELECT data_file_name
         FROM xxmx_migration_metadata
        WHERE UPPER(application_suite) = UPPER(pv_i_application_suite)
          AND UPPER(application)       = UPPER(pv_i_application)  
          AND UPPER(business_entity)   = UPPER(pv_i_business_entity)
          AND UPPER(sub_entity)        = UPPER(pv_i_sub_entity)  
          AND UPPER(enabled_flag)      = 'Y';

    vv_file_name  VARCHAR2(60);

    exp_filename_NotFound  EXCEPTION;

   BEGIN 
     OPEN  get_file_name;
     FETCH get_file_name INTO vv_file_name;
     CLOSE get_file_name;

     IF vv_file_name IS NULL THEN 
        -- put in message handler to rais error.
        RAISE exp_filename_NotFound;
     END IF;
     RETURN vv_file_name;
 EXCEPTION
 when exp_filename_NotFound THEN
 --   print_log ('Error: Unexpected Error');
    raise; 

 when others THEN
    utl_file.fclose_all;
 --   print_log ('Error: Unexpected Error');
    raise; 
end get_filename;


-- ----------------------------------------------------------------------------
-- |------------------------------< OPEN_HDL >--------------------------------|
-- ----------------------------------------------------------------------------
PROCEDURE open_hdl (pv_i_client_code    IN VARCHAR2
                   ,pv_i_business_entity  IN VARCHAR2
                   ,pv_i_file_name      IN VARCHAR2
                   ,pv_i_directory_name IN VARCHAR2
                   ,pv_i_file_type      IN VARCHAR2 DEFAULT 'M'
                   ,pv_ftp_enabled IN VARCHAR2 DEFAULT 'N') IS

  --
  -- Local Variables
  --
  vv_file_name     VARCHAR2(80); 
  vv_file_dir      VARCHAR2(80);
  e_ModuleError    EXCEPTION;

BEGIN

   IF( pv_ftp_enabled = 'Y') THEN
      --Get Directory Name
          BEGIN 
              SELECT directory_name, 
                      case when instr(pv_i_file_name,'.dat',1)=0  then
                          pv_i_file_name||'.dat'
                      else
                          pv_i_file_name
                      end
              INTO vv_file_dir,vv_file_name
              from all_directories
              WHERE (directory_path like '%'||pv_i_directory_name||'%'
              OR directory_name like '%'||pv_i_directory_name||'%');
          EXCEPTION
              WHEN OTHERS THEN 
             -- dbms_output.put_line ('Calling write_hdr File Name '||pv_i_directory_name||' '||vv_file_dir||' '||vv_file_name);
                 -- gvt_ModuleMessage := SQLERRM;
                  raise e_ModuleError;
          END;

      -- Open the File
      g_file_id := utl_file.fopen (vv_file_dir , vv_file_name,  'W', 10000);

   END IF;
 -- dbms_output.put_line ('Calling write_hdr File Name '||pv_i_file_name||' '||pv_i_client_code||' '||pv_i_business_entity);

  -- Write the main header
      write_hdr (pv_i_client           =>   pv_i_client_code
                    ,pv_i_business_entity  =>   pv_i_business_entity
                    ,pv_i_file_name        =>   vv_file_name);

  --
exception
    when e_ModuleError THEN
  --  DBMS_OUTPUT.PUT_LINE(SQLERRM);
    raise;
  --
  when utl_file.invalid_path THEN
    utl_file.fclose_all;
  --  print_log ('Error: Invalid File Path');
    raise;
    --
  when utl_file.invalid_mode THEN
    utl_file.fclose_all;
 --   print_log ('Error: Invalid File Mode');
    raise;
    --
  when utl_file.internal_error THEN
    utl_file.fclose_all;
 --   print_log ('Error: Internal Error');
    raise;
    --
  when utl_file.invalid_operation THEN
    utl_file.fclose_all;
 --   print_log ('Error: Invalid File Operation');
    raise;
    --
  when utl_file.invalid_filehandle THEN
    utl_file.fclose_all;
 --   print_log ('Error: Invalid File Handler');
    raise;
    --
  when others THEN
    utl_file.fclose_all;
 --   print_log ('Error: Unexpected Error');
    raise;
  --
END open_hdl;

--Added by Kirti
-- ----------------------------------------------------------------------------
-- |-----------------------------< FETCH_LEGISLATIVE_DFF_MODE >----------------|
-- ----------------------------------------------------------------------------
--

Procedure get_paramval_leg_dff (vvv_legislative_dff_mode OUT VARCHAR2
									)
	IS	

	BEGIN
		 SELECT PARAMETER_VALUE 
         INTO vvv_legislative_dff_mode 
         FROM XXMX_MIGRATION_PARAMETERS
         WHERE PARAMETER_CODE = 'LEGISLATIVE_DFF';
         EXCEPTION 
            WHEN No_Data_Found THEN 
                vvv_legislative_dff_mode := 'N';

END get_paramval_leg_dff;
--Kirti Code ends

--
-- ----------------------------------------------------------------------------
-- |-----------------------------< WRITE_HDR_HEADER >-------------------------|
-- ----------------------------------------------------------------------------
--
PROCEDURE write_hdr (pv_i_client           IN VARCHAR2
                    ,pv_i_business_entity  IN VARCHAR2
                    ,pv_i_file_name        IN VARCHAR2
                    ,pv_i_file_type        IN VARCHAR2 DEFAULT 'M'
                    ,pv_ftp_enabled IN VARCHAR2 DEFAULT 'N') IS
  --
  -- Local Variables
     l_file_id                  utl_file.file_type;

  vc_comment     VARCHAR2(400) := 'COMMENT ##############################################################################';
--
begin
  --
  l_file_id := g_file_id;

   IF( pv_ftp_enabled = 'Y')
   THEN 
         -- Write the HDL file header contents
         utl_file.put_line (l_file_id, vc_comment);
         utl_file.put_line (l_file_id, 'COMMENT HDL Data -  '||pv_i_client||' File: '||pv_i_file_name);
         utl_file.put_line (l_file_id, 'COMMENT Generated by Version 1 ');
         utl_file.put_line (l_file_id, 'COMMENT Date: '||to_char(sysdate, 'DD-MON-RRRR HH24:MI:SS'));
         utl_file.put_line (l_file_id, 'COMMENT Please DO NOT edit this file manually');
         utl_file.put_line (l_file_id, vc_comment);
         utl_file.put_line (l_file_id, '');
         utl_file.put_line (l_file_id, vc_comment);
         utl_file.put_line (l_file_id, 'COMMENT Business Entity : '||pv_i_business_entity);
         utl_file.put_line (l_file_id, vc_comment);
   END IF;

      INSERT INTO  xxmx_hdl_file_temp (file_name,line_type,line_content)
           VALUES (pv_i_file_name,'File Header', vc_comment);
      INSERT INTO  xxmx_hdl_file_temp (file_name,line_type,line_content)
           VALUES (pv_i_file_name,'File Header','COMMENT HDL Data -  '||pv_i_client||' File: '||pv_i_file_name);
      INSERT INTO  xxmx_hdl_file_temp (file_name,line_type,line_content)
           VALUES (pv_i_file_name,'File Header','COMMENT Generated by Version 1 ');
      INSERT INTO  xxmx_hdl_file_temp (file_name,line_type,line_content) 
           VALUES (pv_i_file_name,'File Header','COMMENT Date: '||to_char(sysdate, 'DD-MON-RRRR HH24:MI:SS'));
      INSERT INTO  xxmx_hdl_file_temp (file_name,line_type,line_content)
           VALUES (pv_i_file_name,'File Header','COMMENT Please DO NOT edit this file manually');
      INSERT INTO  xxmx_hdl_file_temp (file_name,line_type,line_content) 
           VALUES (pv_i_file_name,'File Header', vc_comment);
      INSERT INTO  xxmx_hdl_file_temp (file_name,line_type,line_content) 
           VALUES (pv_i_file_name,'File Header',' ');
      INSERT INTO  xxmx_hdl_file_temp (file_name,line_type,line_content) 
           VALUES (pv_i_file_name,'File Header',  vc_comment);
      INSERT INTO  xxmx_hdl_file_temp (file_name,line_type,line_content) 
           VALUES (pv_i_file_name,'File Header', 'COMMENT Business Entity : '||pv_i_business_entity);
      INSERT INTO  xxmx_hdl_file_temp (file_name,line_type,line_content) 
           VALUES (pv_i_file_name,'File Header',  vc_comment);
        commit;

  --
exception
  --
  when utl_file.write_error THEN
    utl_file.fclose_all;
 --   print_log ('Error: Invalid Operation');
    raise;
    --
  when others THEN
    utl_file.fclose_all;
--    print_log ('Error: Unexpected Error');
    raise;
  --
END write_hdr;
--
-- ----------------------------------------------------------------------------
-- |-----------------------------< WRITE_HDL_LINE >--------------------------------|
-- ----------------------------------------------------------------------------
--
PROCEDURE write_hdl_line (pv_i_file_name      IN VARCHAR2  -- 'WORKER' / 'BANK' / 'BANKBRANCHES'
                    ,pv_i_line_type      IN VARCHAR2  -- T/D  Title / Data
                    ,pv_line_name        IN VARCHAR2  -- Name of the Line ie 'PersonPhone'
                    ,pv_i_line_content   IN VARCHAR2
                    ,pv_i_file_type      IN VARCHAR2 DEFAULT 'M'
                    ,pv_mode             IN VARCHAR2 DEFAULT 'N'
                    ,pv_ftp_enabled IN VARCHAR2 DEFAULT 'N') IS
  --

           cv_title_line            CONSTANT VARCHAR2(20) := 'T'; 
           cv_data_line             CONSTANT VARCHAR2(20) := 'D'; 
           cv_metadata              CONSTANT VARCHAR2(30) := 'METADATA';

           cv_ProcOrFuncName           CONSTANT  VARCHAR2(30)           := 'write_hdl_line';
          -- Line Title Data   Look to put this in a parmater setup table.
          cv_sourcesystem_hdr     CONSTANT  VARCHAR2(400) := 'SourceSystemOwner|SourceSystemId|';
          cv_assignment_hdr       CONSTANT  VARCHAR2(400) := 'AssignmentId(SourceSystemId)|';
          cv_workterms_name_hdr   CONSTANT  VARCHAR2(400) := 'AssignmentNumber|AssignmentName';
          cv_assignment_name_hdr  CONSTANT  VARCHAR2(400) := 'AssignmentNumber|AssignmentName|WorkTermsNumber';
          cv_worker_hdr           CONSTANT  VARCHAR2(400) := 'EffectiveStartDate|EffectiveEndDate|PersonNumber|StartDate|DateOfBirth|ActionCode|ReasonCode';
          cv_worker_name_hdr      CONSTANT  VARCHAR2(400) := 'PersonId(SourceSystemId)|EffectiveStartDate|EffectiveEndDate|LegislationCode|NameType|FirstName|MiddleNames|LastName|Honors|KnownAs|PreNameAdjunct|MilitaryRank|PreviousLastName|Suffix|Title';
          cv_religion_hdr         CONSTANT  VARCHAR2(400) := 'PersonId(SourceSystemId)|LegislationCode|Religion|PrimaryFlag';   -- removed PersonNumber
          cv_visa_hdr             CONSTANT  VARCHAR2(400) := 'PersonId(SourceSystemId)|EffectiveStartDate|EffectiveEndDate|VisaPermitType|PersonNumber|LegislationCode|EntryDate|ExpirationDate|CurrentVisaPermit|IssueDate|IssuingAuthority|IssuingCountry|IssuingLocation|Profession|VisaPermitCategory|VisaPermitNumber|VisaPermitStatus|VisaPermitStatusDate';
          cv_third_party_org      CONSTANT  VARCHAR2(2000):= 'EffectiveStartDate|EffectiveEndDate|LegislativeDataGroupName|PartyNumber|BankName|BankBranchNumber|BankAccountNumber|BankCountryCode|OrganizationPaymentMethodCode';
          cv_ethnicity_hdr        CONSTANT  VARCHAR2(400) := 'PersonId(SourceSystemId)|LegislationCode|Ethnicity|PrimaryFlag';
          cv_legistlation_hdr     CONSTANT  VARCHAR2(400) := 'PersonId(SourceSystemId)|EffectiveStartDate|EffectiveEndDate|PersonNumber|LegislationCode|HighestEducationLevel|MaritalStatus|MaritalStatusDate|Sex';
          cv_address_hdr          CONSTANT  VARCHAR2(400) := 'PersonId(SourceSystemId)|EffectiveStartDate|EffectiveEndDate|PersonNumber|AddressType|AddressLine1|AddressLine2|AddressLine3|TownOrCity|Region1|Region2|Country|PostalCode|PrimaryFlag';
          cv_phone_hdr            CONSTANT  VARCHAR2(400) := 'PersonId(SourceSystemId)|PhoneType|DateFrom|DateTo|PersonNumber|LegislationCode|PhoneNumber|PrimaryFlag';
          cv_email_hdr            CONSTANT  VARCHAR2(400) := 'PersonId(SourceSystemId)|DateFrom|DateTo|PersonNumber|EmailType|EmailAddress|PrimaryFlag';
          cv_nat_ident_hdr        CONSTANT  VARCHAR2(400) := 'PersonId(SourceSystemId)|PersonNumber|LegislationCode|IssueDate|ExpirationDate|PlaceOfIssue|NationalIdentifierType|NationalIdentifierNumber|PrimaryFlag';
          cv_citizenship_hdr      CONSTANT  VARCHAR2(400) := 'PersonId(SourceSystemId)|DateFrom|DateTo|LegislationCode|CitizenshipStatus';
          cv_per_passport_hdr     CONSTANT  VARCHAR2(400) := 'PersonId(SourceSystemId)|LegislationCode|PassportNumber|ExpirationDate|IssuingCountry';
          cv_wrk_hire_relation_hdr CONSTANT VARCHAR2(400) := 'PersonId(SourceSystemId)|PersonNumber|DateStart|WorkerType|LegalEmployerName|ActionCode|ReasonCode|PrimaryFlag'; --LegalEmployerSeniorityDate|EnterpriseSeniorityDate|
          cv_wrk_relation_hdr      CONSTANT VARCHAR2(400) := 'PersonId(SourceSystemId)|ActionCode|TerminateWorkRelationshipFlag|ActualTerminationDate|LastWorkingDate';


         --Changes for Raised Issue
         --cv_wrk_terms_hdr        CONSTANT  VARCHAR2(400) := 'PeriodOfServiceId(SourceSystemId)|PersonId(SourceSystemId)|EffectiveStartDate|EffectiveEndDate|PersonNumber|EffectiveSequence|EffectiveLatestChange|DateStart|ActionCode|ReasonCode|AssignmentStatusTypeCode|AssignmentStatusTypeId|BusinessUnitShortCode|TaxReportingUnit';
         -- HIRE WORKTERMS
         cv_wrk_terms_hdr        CONSTANT  VARCHAR2(400) := 'PeriodOfServiceId(SourceSystemId)|PersonId(SourceSystemId)|EffectiveStartDate|EffectiveEndDate|PersonNumber|EffectiveSequence|EffectiveLatestChange|DateStart|ActionCode|ReasonCode|AssignmentStatusTypeCode|BusinessUnitShortCode|TaxReportingUnit';
         -- cv_wrk_assign_hdr       CONSTANT  VARCHAR2(800) := 'WorkTermsAssignmentId(SourceSystemId)|PeriodOfServiceId(SourceSystemId)|PersonId(SourceSystemId)|EffectiveStartDate|EffectiveEndDate|PersonNumber|EffectiveSequence|EffectiveLatestChange|DateStart|ActionCode|ReasonCode|WorkerType|LegalEmployerName|PrimaryAssignmentFlag|AssignmentStatusTypeCode|AssignmentStatusTypeId|BusinessUnitShortCode|AssignmentType|PersonTypeCode|WorkerCategory|FullPartTime|DateProbationEnd|NormalHours|Frequency|PermanentTemporary|JobCode|LocationCode|DepartmentName|NoticePeriod|NoticePeriodUOM|PrimaryFlag|HourlySalariedCode|PositionCode|GradeCode|BargainingUnitCode|LabourUnionMemberFlag|ManagerFlag|SystemPersonType|TaxReportingUnit';
         -- cv_wrk_hire_assign_hdr  CONSTANT  VARCHAR2(800) := 'WorkTermsAssignmentId(SourceSystemId)|PeriodOfServiceId(SourceSystemId)|PersonId(SourceSystemId)|EffectiveStartDate|EffectiveEndDate|PersonNumber|EffectiveSequence|EffectiveLatestChange|DateStart|ActionCode|ReasonCode|WorkerType|LegalEmployerName|PrimaryAssignmentFlag|AssignmentStatusTypeCode|AssignmentStatusTypeId|BusinessUnitShortCode|AssignmentType|WorkerCategory|SystemPersonType|TaxReportingUnit';

         -- workerCurrent Assignment
         /* Added by Kirti */
         --cv_wrk_assign_hdr       CONSTANT  VARCHAR2(800) := 'WorkTermsAssignmentId(SourceSystemId)|PeriodOfServiceId(SourceSystemId)|PersonId(SourceSystemId)|EffectiveStartDate|EffectiveEndDate|PersonNumber|EffectiveSequence|EffectiveLatestChange|DateStart|ActionCode|ReasonCode|WorkerType|LegalEmployerName|PrimaryAssignmentFlag|AssignmentStatusTypeCode|BusinessUnitShortCode|AssignmentType|PersonTypeCode|WorkerCategory|AssignmentCategory|FullPartTime|DateProbationEnd|NormalHours|Frequency|PermanentTemporary|JobCode|LocationCode|DepartmentName|NoticePeriod|NoticePeriodUOM|PrimaryFlag|HourlySalariedCode|PositionCode|GradeCode|BargainingUnitCode|LabourUnionMemberFlag|ManagerFlag|SystemPersonType|TaxReportingUnit|PeopleGroup|GradeLadderPgmName';

         cv_wrk_assign_hdr       CONSTANT  VARCHAR2(800) := 'WorkTermsAssignmentId(SourceSystemId)|PeriodOfServiceId(SourceSystemId)|PersonId(SourceSystemId)|EffectiveStartDate|EffectiveEndDate|PersonNumber|EffectiveSequence|EffectiveLatestChange|DateStart|ActionCode|ReasonCode|WorkerType|LegalEmployerName|PrimaryAssignmentFlag|AssignmentStatusTypeCode|BusinessUnitShortCode|AssignmentType|PersonTypeCode|WorkerCategory|AssignmentCategory|FullPartTime|DateProbationEnd|NormalHours|Frequency|PermanentTemporary|JobCode|LocationCode|DepartmentName|NoticePeriod|NoticePeriodUOM|PrimaryFlag|HourlySalariedCode|PositionCode|GradeCode|BargainingUnitCode|LabourUnionMemberFlag|ManagerFlag|SystemPersonType|TaxReportingUnit|PeopleGroup|GradeLadderPgmName|ReportingEstablishment|DefaultExpenseAccount|PositionOverrideFlag'; -- 1.7
         /* Kirti code ends */
         -- HIRE Assignment
         cv_wrk_hire_assign_hdr  CONSTANT  VARCHAR2(800) := 'WorkTermsAssignmentId(SourceSystemId)|PeriodOfServiceId(SourceSystemId)|PersonId(SourceSystemId)|EffectiveStartDate|EffectiveEndDate|PersonNumber|EffectiveSequence|EffectiveLatestChange|DateStart|ActionCode|ReasonCode|WorkerType|LegalEmployerName|PrimaryAssignmentFlag|AssignmentStatusTypeCode|BusinessUnitShortCode|AssignmentType|WorkerCategory|SystemPersonType|TaxReportingUnit|AssignmentCategory'; -- Assignment Category in Hire


         cv_wrk_measure_hdr      CONSTANT  VARCHAR2(400) := 'AssignmentId(SourceSystemId)|EffectiveStartDate|EffectiveEndDate|Unit|Value';
         cv_assign_grade_hdr     CONSTANT  VARCHAR2(400) := 'AssignmentId(SourceSystemId)|AssignmentNumber|EffectiveStartDate|EffectiveEndDate|GradeStepName|ActionCode|ReasonCode';

         -- Bank Bank Branches Line Headers  
         cv_bank_hdr             CONSTANT  VARCHAR2(400) := 'CountryCode|BankName';
         cv_bank_branch_hdr      CONSTANT  VARCHAR2(400) := 'CountryCode|BankName|BankBranchName|BankBranchNumber';

         -- External Bank Account Headers
         cv_ext_bank_acct_hdr        CONSTANT  VARCHAR2(400) := 'BankName|BankBranchName|AccountNumber|CountryCode|CurrencyCode|SecondaryAccountReference|AccountName'; -- Account Holder Name
         cv_ext_bank_acct_owner_hdr  CONSTANT  VARCHAR2(400) := 'BankName|BankBranchName|AccountNumber|CountryCode|CurrencyCode|SecondaryAccountReference|PersonNumber';

         --  Worker Assignment Supervisor Header
         cv_assign_supervisor_hdr CONSTANT  VARCHAR2(400) := 'EffectiveStartDate|EffectiveEndDate|ManagerType|PrimaryFlag|ManagerPersonNumber';

         -- Assigned Payroll Header
         cv_assigned_payroll_hdr  CONSTANT  VARCHAR2(400) := 'StartDate|EffectiveStartDate|EffectiveEndDate|LegislativeDataGroupName|PayrollDefinitionCode|AssignmentNumber';

         -- Salary Header
         cv_salary_hdr            CONSTANT  VARCHAR2(400) := 'AssignmentNumber|DateFrom|DateTo|SalaryBasisName|SalaryAmount|ActionCode|MultipleComponents|SalaryApproved';

         -- PersonalPaymentMethod
         cv_per_pay_method_hrd      CONSTANT  VARCHAR2(400) := 'LegislativeDataGroupName|AssignmentNumber|OrganizationPaymentMethodCode|PersonalPaymentMethodCode|EffectiveStartDate|ProcessingOrder|PaymentAmountType|Percentage|BankName|BankBranchName|BankAccountNumber|SecondaryAccountReference|BankCountryCode';

         -- Contacts Header
         cv_contact_hrd           CONSTANT  VARCHAR2(400) := 'StartDate|EffectiveStartDate|EffectiveEndDate|PersonNumber';
         cv_contact_addr_hdr      CONSTANT  VARCHAR2(400) := 'PersonId(SourceSystemId)|EffectiveStartDate|EffectiveEndDate|PersonNumber|AddressType|AddressLine1|AddressLine2|AddressLine3|TownOrCity|Region1|Country|PostalCode|PrimaryFlag';
         cv_contact_phone         CONSTANT  VARCHAR2(400) := 'PersonId(SourceSystemId)|DateFrom|DateTo|PersonNumber|LegislationCode|CountryCodeNumber|PhoneType|PhoneNumber|PrimaryFlag';
         cv_contact_name_hdr      CONSTANT  VARCHAR2(400) := 'PersonId(SourceSystemId)|EffectiveStartDate|EffectiveEndDate|PersonNumber|LegislationCode|NameType|FirstName|LastName';
         cv_contact_relation_hdr  CONSTANT  VARCHAR2(400) := 'PersonId(SourceSystemId)|EffectiveStartDate|EffectiveEndDate|PersonNumber|RelatedPersonNumber|ContactType|EmergencyContactFlag|PrimaryContactFlag|ExistingPerson|PersonalFlag|SequenceNumber';

         --AssignmetnAdd
         --  cv_wrk_terms_add_assign_hdr  CONSTANT  VARCHAR2(800) := 'PeriodOfServiceId(SourceSystemId)|PersonId(SourceSystemId)|ActionCode|AssignmentStatusTypeCode|AssignmentStatusTypeId|AssignmentType|BusinessUnitShortCode| DateStart|EffectiveEndDate|EffectiveLatestChange|EffectiveSequence|EffectiveStartDate|LegalEmployerName|PersonNumber|PrimaryWorkTermsFlag|WorkerType';
         --          cv_wrk_add_assign_hdr        CONSTANT  VARCHAR2(800) := 'WorkTermsAssignmentId(SourceSystemId)|PeriodOfServiceId(SourceSystemId)|PersonId(SourceSystemId)|EffectiveStartDate|EffectiveEndDate|PersonNumber|EffectiveSequence|EffectiveLatestChange|DateStart|ActionCode|ReasonCode|WorkerType|LegalEmployerName|PrimaryAssignmentFlag|AssignmentStatusTypeCode|AssignmentStatusTypeId|BusinessUnitShortCode|AssignmentType|PersonTypeCode|WorkerCategory|FullPartTime|DateProbationEnd|NormalHours|Frequency|PermanentTemporary|JobCode|LocationCode|DepartmentName|NoticePeriod|NoticePeriodUOM|PrimaryFlag|HourlySalariedCode|PositionCode|GradeCode|BargainingUnitCode|LabourUnionMemberFlag|ManagerFlag|SystemPersonType|TaxReportingUnit';

         -- Add Assign WorkTerms
         cv_wrk_terms_add_assign_hdr  CONSTANT  VARCHAR2(800) := 'PeriodOfServiceId(SourceSystemId)|PersonId(SourceSystemId)|ActionCode|AssignmentStatusTypeCode|AssignmentType|BusinessUnitShortCode|DateStart|EffectiveEndDate|EffectiveLatestChange|EffectiveSequence|EffectiveStartDate|LegalEmployerName|PersonNumber|PrimaryWorkTermsFlag|WorkerType|PeopleGroup|GradeLadderPgmName';

         -- Add Assign Change WorkTerms  V1.10
         cv_wrk_terms_add_asg_chg_hdr  CONSTANT  VARCHAR2(800) := 'PeriodOfServiceId(SourceSystemId)|PersonId(SourceSystemId)|ActionCode|AssignmentStatusTypeCode|AssignmentType|BusinessUnitShortCode|DateStart|EffectiveEndDate|EffectiveLatestChange|EffectiveSequence|EffectiveStartDate|LegalEmployerName|PersonNumber|PrimaryWorkTermsFlag|WorkerType|PeopleGroup|GradeLadderPgmName';

         -- Current WorkTerms
         cv_wrk_terms_cur_assign_hdr  CONSTANT  VARCHAR2(400) := 'PeriodOfServiceId(SourceSystemId)|PersonId(SourceSystemId)|EffectiveStartDate|EffectiveEndDate|PersonNumber|EffectiveSequence|EffectiveLatestChange|DateStart|ActionCode|ReasonCode|AssignmentStatusTypeCode|AssignmentType|BusinessUnitShortCode|TaxReportingUnit|PeopleGroup|GradeLadderPgmName';

         -- Add Assign Assignment V1.10
         cv_wrk_add_assign_hdr        CONSTANT  VARCHAR2(800) := 'WorkTermsAssignmentId(SourceSystemId)|PeriodOfServiceId(SourceSystemId)|PersonId(SourceSystemId)|EffectiveStartDate|EffectiveEndDate|PersonNumber|EffectiveSequence|EffectiveLatestChange|DateStart|ActionCode|ReasonCode|WorkerType|LegalEmployerName|PrimaryAssignmentFlag|AssignmentStatusTypeCode|BusinessUnitShortCode|AssignmentType|WorkerCategory|SystemPersonType|TaxReportingUnit|AssignmentCategory'; 


         --Add Assignment Change Line V1.10
         cv_wrk_add_assign_chg_hdr    CONSTANT  VARCHAR2(800) := 'WorkTermsAssignmentId(SourceSystemId)|PeriodOfServiceId(SourceSystemId)|PersonId(SourceSystemId)|EffectiveStartDate|EffectiveEndDate|PersonNumber|EffectiveSequence|EffectiveLatestChange|DateStart|ActionCode|ReasonCode|WorkerType|LegalEmployerName|PrimaryAssignmentFlag|AssignmentStatusTypeCode|BusinessUnitShortCode|AssignmentType|PersonTypeCode|WorkerCategory|FullPartTime|DateProbationEnd|NormalHours|Frequency|PermanentTemporary|JobCode|LocationCode|DepartmentName|NoticePeriod|NoticePeriodUOM|PrimaryFlag|HourlySalariedCode|PositionCode|GradeCode|BargainingUnitCode|LabourUnionMemberFlag|ManagerFlag|SystemPersonType|TaxReportingUnit|PeopleGroup|GradeLadderPgmName|DefaultExpenseAccount|PositionOverrideFlag';  -- 1.7

         cv_disability_hdr     CONSTANT  VARCHAR2(800) := 'EffectiveStartDate|EffectiveEndDate|LegislationCode|PersonNumber|RegistrationDate|RegistrationExpDate|Category|Description|Degree|QuotaFTE|Reason|WorkRestriction|Status';
         --Absence
         cv_abs_sickness_hdr   CONSTANT  VARCHAR2(2000) :='Employer|PersonNumber|AbsenceType|AbsenceReason|AbsenceStatus|ApprovalStatus|NotificationDate|ConfirmedDate|Comments|StartDate|StartTime|EndDate|EndTime|AssignmentNumber|StartDateDuration|EndDateDuration';
         cv_abs_maternity_hdr  CONSTANT  VARCHAR2(2000) :='PerAbsenceEntryId(SourceSystemId)|PersonNumber|StartDate|StartTime|PlannedStartDate|PlannedReturnDate|IntendToWork|ExpectedDateOfChildBirth|ExpectedEndDate|ActualStartDate|ActualReturnDate|ActualChildBirthDate|OpenEndedFlag';

         --talent profile
         cv_talent_profile_hdr     CONSTANT  VARCHAR2(800) :='Description|ProfileCode|ProfileStatusCode|ProfileUsageCode|PersonNumber|ProfileTypeCode';
         cv_profile_item_hdr       CONSTANT  VARCHAR2(800) :='ProfileCode|ContentType|DateFrom|DateTo|ContentItem|SectionId';

         --Images
         cv_images_hdr     CONSTANT  VARCHAR2(800) := 'PersonNumber|ImageName|Image|PrimaryFlag';

         -- Kirti DFF columns added to assignment
         -- cv_wrk_assign_dff_hdr has current row columns with dff columns appended. This should be used only for Insert.
         -- Added DefaultExpenseAccount for 1.7
         cv_wrk_assign_dff_hdr   CONSTANT  VARCHAR2(1500) := 'WorkTermsAssignmentId(SourceSystemId)|PeriodOfServiceId(SourceSystemId)|PersonId(SourceSystemId)|EffectiveStartDate|EffectiveEndDate|PersonNumber|EffectiveSequence|EffectiveLatestChange|DateStart|ActionCode|ReasonCode|WorkerType|LegalEmployerName|PrimaryAssignmentFlag|AssignmentStatusTypeCode|BusinessUnitShortCode|AssignmentType|PersonTypeCode|WorkerCategory|AssignmentCategory|FullPartTime|DateProbationEnd|NormalHours|Frequency|PermanentTemporary|JobCode|LocationCode|DepartmentName|NoticePeriod|NoticePeriodUOM|PrimaryFlag|HourlySalariedCode|PositionCode|GradeCode|BargainingUnitCode|LabourUnionMemberFlag|ManagerFlag|SystemPersonType|TaxReportingUnit|PeopleGroup|GradeLadderPgmName|ReportingEstablishment|DefaultExpenseAccount|PositionOverrideFlag|FLEX:PER_ASG_DF|qtsRoute(PER_ASG_DF=Global Data Elements)|apprentice(PER_ASG_DF=Global Data Elements)|apprenticeStartDate(PER_ASG_DF=Global Data Elements)|apprenticeEndDate(PER_ASG_DF=Global Data Elements)|ContractType(PER_ASG_DF=Global Data Elements)|TermTimecontractedWeeks(PER_ASG_DF=Global Data Elements)|smbc10YearIncrease(PER_ASG_DF=Global Data Elements)|MileageStatusAsg(PER_ASG_DF=Global Data Elements)|excessMileageExpiryDate(PER_ASG_DF=Global Data Elements)|payPoint(PER_ASG_DF=Global Data Elements)';

         -- cv_wrk_assign_only_dff_hdr has current row columns with selective mandatory columns and dff columns appended. This should be used only for Update.
         cv_wrk_assign_only_dff_hdr   CONSTANT  VARCHAR2(1000) := 'WorkTermsAssignmentId(SourceSystemId)|PeriodOfServiceId(SourceSystemId)|PersonId(SourceSystemId)|EffectiveStartDate|EffectiveEndDate|PersonNumber|EffectiveSequence|EffectiveLatestChange|DateStart|ActionCode|ReasonCode|WorkerType|LegalEmployerName|PrimaryAssignmentFlag|AssignmentStatusTypeCode|BusinessUnitShortCode|AssignmentType|WorkerCategory|AssignmentCategory|ReportingEstablishment|PositionOverrideFlag|FLEX:PER_ASG_DF|qtsRoute(PER_ASG_DF=Global Data Elements)|apprentice(PER_ASG_DF=Global Data Elements)|apprenticeStartDate(PER_ASG_DF=Global Data Elements)|apprenticeEndDate(PER_ASG_DF=Global Data Elements)|ContractType(PER_ASG_DF=Global Data Elements)|TermTimecontractedWeeks(PER_ASG_DF=Global Data Elements)|smbc10YearIncrease(PER_ASG_DF=Global Data Elements)|MileageStatusAsg(PER_ASG_DF=Global Data Elements)|excessMileageExpiryDate(PER_ASG_DF=Global Data Elements)|payPoint(PER_ASG_DF=Global Data Elements)';

         -- Kirti DFF code ends

         -- Kirti DFF columns added to legislative
         -- cv_legislation_dff_hdr has current row columns with dff columns appended. This should be used only for Insert.
         cv_legislation_dff_hdr     CONSTANT  VARCHAR2(1000) := 'PersonId(SourceSystemId)|EffectiveStartDate|EffectiveEndDate|PersonNumber|LegislationCode|HighestEducationLevel|MaritalStatus|MaritalStatusDate|Sex|FLEX:PER_PERSON_LEGISLATIVE_DATA_LEG_DDF|FLEX:PER_PERSON_LEGISLATIVE_DFF|oraHrxGbPsTpsTrn(PER_PERSON_LEGISLATIVE_DATA_LEG_DDF=GB)|civilServiceJoiningDate(PER_PERSON_LEGISLATIVE_DATA_LEG_DDF=GB)|originOfStarter(PER_PERSON_LEGISLATIVE_DFF=Global Data Elements)|socialServOriginOfStarter(PER_PERSON_LEGISLATIVE_DFF=Global Data Elements)|supervisionType(PER_PERSON_LEGISLATIVE_DFF=Global Data Elements)|_SEXUAL_ORIENTATION(PER_PERSON_LEGISLATIVE_DATA_LEG_DDF=GB)';

         -- cv_legistlation_only_dff_hdr has current row columns with selective mandatory columns and dff columns appended. This should be used only for Update.
         cv_legislation_only_dff_hdr     CONSTANT  VARCHAR2(1000) := 'PersonId(SourceSystemId)|EffectiveStartDate|EffectiveEndDate|PersonNumber|LegislationCode|FLEX:PER_PERSON_LEGISLATIVE_DATA_LEG_DDF|FLEX:PER_PERSON_LEGISLATIVE_DFF|oraHrxGbPsTpsTrn(PER_PERSON_LEGISLATIVE_DATA_LEG_DDF=GB)|civilServiceJoiningDate(PER_PERSON_LEGISLATIVE_DATA_LEG_DDF=GB)|originOfStarter(PER_PERSON_LEGISLATIVE_DFF=Global Data Elements)|socialServOriginOfStarter(PER_PERSON_LEGISLATIVE_DFF=Global Data Elements)|supervisionType(PER_PERSON_LEGISLATIVE_DFF=Global Data Elements)|_SEXUAL_ORIENTATION(PER_PERSON_LEGISLATIVE_DATA_LEG_DDF=GB)';
         vvv_legislative_dff_mode	VARCHAR2(10) := NULL;
         -- Kirti DFF code ends


          vv_file_type            VARCHAR2(10) := 'MERGE';
          lv_data                 VARCHAR2(4000) := NULL;
		  vvv_assignment_dff_mode	VARCHAR2(10) := NULL;
BEGIN

  IF pv_i_file_type = 'D' THEN
     vv_file_type := 'DELETE';
  END IF;
  --dbms_output.put_line(pv_i_file_name);

   -- **************************************************
   -- FILE WorkerHire   
   -- **************************************************
  IF UPPER(pv_i_file_name) LIKE 'WORKERHIRE%' THEN

     IF  UPPER(pv_line_name) = 'WORKER' THEN
         IF pv_i_line_type = cv_title_line  THEN
            lv_data := cv_metadata||gv_delim||pv_line_name||gv_delim||cv_sourcesystem_hdr||cv_worker_hdr;
         ELSE -- Data Line
            lv_data := vv_file_type||gv_delim||pv_line_name||gv_delim||gcv_sourcesystem||gv_delim||pv_i_line_content;
         END IF;         

      ELSIF  UPPER(pv_line_name) = 'PERSONNAME' THEN  --'PersonName'
         IF pv_i_line_type = cv_title_line  THEN
            lv_data := cv_metadata||gv_delim||pv_line_name||gv_delim||cv_sourcesystem_hdr||cv_worker_name_hdr;
         ELSE -- Data Line
            lv_data := vv_file_type||gv_delim||pv_line_name||gv_delim||gcv_sourcesystem||gv_delim||pv_line_name||'-'||pv_i_line_content;
         END IF;         

      ELSIF UPPER(pv_line_name) =  'PERSONETHNICITY'  THEN  --'PersonEthnicity'
         IF pv_i_line_type = cv_title_line  THEN
            lv_data := cv_metadata||gv_delim||pv_line_name||gv_delim||cv_sourcesystem_hdr||cv_ethnicity_hdr;
         ELSE -- Data Line
            lv_data := vv_file_type||gv_delim||pv_line_name||gv_delim||gcv_sourcesystem||gv_delim||pv_line_name||'-'||pv_i_line_content;
         END IF;         

      ELSIF UPPER(pv_line_name) = 'PERSONLEGISLATIVEDATA' THEN -- 'PersonLegislativeData'
	  -- Added by Kirti
			get_paramval_leg_dff (vvv_legislative_dff_mode);
		 IF vvv_legislative_dff_mode = 'N' THEN
	  -- Kirti Code ends
         IF pv_i_line_type = cv_title_line  THEN
            lv_data := cv_metadata||gv_delim||pv_line_name||gv_delim||cv_sourcesystem_hdr||cv_legistlation_hdr;
         ELSE -- Data Line
            lv_data := vv_file_type||gv_delim||pv_line_name||gv_delim||gcv_sourcesystem||gv_delim||pv_line_name||'-'||pv_i_line_content;
         END IF;
	  -- Added by Kirti
			ELSIF vvv_legislative_dff_mode = 'I' THEN
			IF pv_i_line_type = cv_title_line  THEN
            lv_data := cv_metadata||gv_delim||pv_line_name||gv_delim||cv_sourcesystem_hdr||cv_legislation_dff_hdr;
         ELSE -- Data Line
            lv_data := vv_file_type||gv_delim||pv_line_name||gv_delim||gcv_sourcesystem||gv_delim||pv_line_name||'-'||pv_i_line_content;
         END IF;
	  -- Kirti Code ends
			END IF;


      ELSIF UPPER(pv_line_name) =  'PERSONADDRESS' THEN     --   'PersonAddress'
         IF pv_i_line_type = cv_title_line  THEN
            lv_data := cv_metadata||gv_delim||pv_line_name||gv_delim||cv_sourcesystem_hdr||cv_address_hdr;
         ELSE -- Data Line
            lv_data := vv_file_type||gv_delim||pv_line_name||gv_delim||gcv_sourcesystem||gv_delim||pv_line_name||'-'||pv_i_line_content;
         END IF;         

      ELSIF UPPER(pv_line_name) = 'PERSONPHONE' THEN  --'PersonPhone'
         IF pv_i_line_type = cv_title_line  THEN
            lv_data := cv_metadata||gv_delim||pv_line_name||gv_delim||cv_sourcesystem_hdr||cv_phone_hdr;
         ELSE -- Data Line
            lv_data := vv_file_type||gv_delim||pv_line_name||gv_delim||gcv_sourcesystem||gv_delim||pv_line_name||'-'||pv_i_line_content;
         END IF;         

      ELSIF UPPER(pv_line_name) = 'PERSONEMAIL' THEN  -- 'PersonEmail'
         IF pv_i_line_type = cv_title_line  THEN
            lv_data := cv_metadata||gv_delim||pv_line_name||gv_delim||cv_sourcesystem_hdr||cv_email_hdr;
         ELSE -- Data Line
            lv_data := vv_file_type||gv_delim||pv_line_name||gv_delim||gcv_sourcesystem||gv_delim||pv_line_name||'-'||pv_i_line_content;
         END IF;         

      ELSIF UPPER(pv_line_name) =  'PERSONNATIONALIDENTIFIER' THEN -- 'PersonNationalIdentifier'
         IF pv_i_line_type = cv_title_line  THEN
            lv_data := cv_metadata||gv_delim||pv_line_name||gv_delim||cv_sourcesystem_hdr||cv_nat_ident_hdr;
         ELSE -- Data Line
            lv_data := vv_file_type||gv_delim||pv_line_name||gv_delim||gcv_sourcesystem||gv_delim||pv_line_name||'-'||pv_i_line_content;
         END IF;         

      ELSIF UPPER(pv_line_name) =  'PERSONCITIZENSHIP' THEN -- 'PersonCitizenship'
         IF pv_i_line_type = cv_title_line  THEN
            lv_data := cv_metadata||gv_delim||pv_line_name||gv_delim||cv_sourcesystem_hdr||cv_citizenship_hdr;
         ELSE -- Data Line
            lv_data := vv_file_type||gv_delim||pv_line_name||gv_delim||gcv_sourcesystem||gv_delim||pv_line_name||'-'||pv_i_line_content;
         END IF;         

      ELSIF UPPER(pv_line_name) =  'PERSONPASSPORT' THEN  --'PersonPassport' 
         IF pv_i_line_type = cv_title_line  THEN
            lv_data := cv_metadata||gv_delim||pv_line_name||gv_delim||cv_sourcesystem_hdr||cv_per_passport_hdr;
         ELSE -- Data Line
            lv_data := vv_file_type||gv_delim||pv_line_name||gv_delim||gcv_sourcesystem||gv_delim||pv_line_name||'-'||pv_i_line_content;
         END IF;   

      ELSIF UPPER(pv_line_name) =  'PERSONRELIGION' THEN  --'PersonReligion' 
         IF pv_i_line_type = cv_title_line  THEN
            lv_data := cv_metadata||gv_delim||pv_line_name||gv_delim||cv_sourcesystem_hdr||cv_religion_hdr;
         ELSE -- Data Line
            lv_data := vv_file_type||gv_delim||pv_line_name||gv_delim||gcv_sourcesystem||gv_delim||pv_line_name||'-'||pv_i_line_content;
         END IF; 



     ELSIF UPPER(pv_line_name) =  'PERSONVISA' THEN  --'PersonVisa' 
         IF pv_i_line_type = cv_title_line  THEN
            lv_data := cv_metadata||gv_delim||pv_line_name||gv_delim||cv_sourcesystem_hdr||cv_visa_hdr;
         ELSE -- Data Line
            lv_data := vv_file_type||gv_delim||pv_line_name||gv_delim||gcv_sourcesystem||gv_delim||pv_line_name||'-'||pv_i_line_content;
         END IF;

      ELSIF UPPER(pv_line_name) =  'WORKRELATIONSHIP' THEN  -- 'WorkRelationship'
         IF pv_i_line_type = cv_title_line  THEN
            lv_data := cv_metadata||gv_delim||pv_line_name||gv_delim||cv_sourcesystem_hdr||cv_wrk_hire_relation_hdr;
         ELSE -- Data Line
            lv_data := vv_file_type||gv_delim||pv_line_name||gv_delim||gcv_sourcesystem||gv_delim||pv_line_name||'-'||pv_i_line_content;
         END IF;         

      ELSIF UPPER(pv_line_name) =   'WORKTERMS' THEN  -- 'WorkTerms'
         IF pv_i_line_type = cv_title_line  THEN
            lv_data := cv_metadata||gv_delim||pv_line_name||gv_delim||cv_workterms_name_hdr||gv_delim||cv_sourcesystem_hdr||cv_wrk_terms_hdr;
         ELSE -- Data Line
            lv_data := vv_file_type||gv_delim||pv_line_name||gv_delim||pv_i_line_content;
         END IF;         

      ELSIF UPPER(pv_line_name) =  'ASSIGNMENT' THEN  -- 'Assignment'
         IF pv_i_line_type = cv_title_line  THEN
            lv_data := cv_metadata||gv_delim||pv_line_name||gv_delim||cv_assignment_name_hdr||gv_delim||cv_sourcesystem_hdr||cv_wrk_hire_assign_hdr;
         ELSE -- Data Line
            lv_data := vv_file_type||gv_delim||pv_line_name||gv_delim||pv_i_line_content;
         END IF;

      END IF; -- pv_line_name

  -- **************************************************
  -- FILE WorkerCurrent
  -- **************************************************
      ELSIF UPPER(pv_i_file_name) LIKE 'WORKERCURRENT%' THEN   

       IF UPPER(pv_line_name) =   'WORKTERMS' THEN  -- 'WorkTerms'
         IF pv_i_line_type = cv_title_line  THEN
            lv_data := cv_metadata||gv_delim||pv_line_name||gv_delim||cv_workterms_name_hdr||gv_delim||cv_sourcesystem_hdr||cv_wrk_terms_cur_assign_hdr;
         ELSE -- Data Line
            lv_data := vv_file_type||gv_delim||pv_line_name||gv_delim||pv_i_line_content;
         END IF;         

		 -- Added by Kirti
       BEGIN
         SELECT PARAMETER_VALUE 
         INTO vvv_assignment_dff_mode 
         FROM XXMX_MIGRATION_PARAMETERS
         WHERE PARAMETER_CODE = 'ASSIGNMENT_DFF';
         EXCEPTION 
            WHEN OTHERS THEN 
                vvv_assignment_dff_mode := 'N';
        END ;                



        

		ELSIF UPPER(pv_line_name) =  'ASSIGNMENT' THEN  -- 'Assignment'
        				-- Kirti DFF columns added to assignment         
                
                IF pv_mode = 'N' THEN
                
                    IF pv_i_line_type = cv_title_line  THEN
                        lv_data := cv_metadata||gv_delim||pv_line_name||gv_delim||cv_assignment_name_hdr||gv_delim||cv_sourcesystem_hdr||cv_wrk_assign_hdr;
                    ELSE -- Data Line
                        lv_data := vv_file_type||gv_delim||pv_line_name||gv_delim||pv_i_line_content;
                    END IF;
                -- Kirti DFF code ends
                END IF;
				IF pv_mode = 'I' THEN
                
                    IF pv_i_line_type = cv_title_line  THEN
					-- Insert mode for DFF. All Assignment DFF columns appended to assignment header
						lv_data := cv_metadata||gv_delim||pv_line_name||gv_delim||cv_assignment_name_hdr||gv_delim||cv_sourcesystem_hdr||cv_wrk_assign_dff_hdr;
                    ELSE -- Data Line
                        lv_data := vv_file_type||gv_delim||pv_line_name||gv_delim||pv_i_line_content;
                    END IF;
                END IF;
				IF pv_mode = 'U' THEN
                
					IF pv_i_line_type = cv_title_line  THEN
                    -- Update mode for DFF. Only DFF columns as part of header
                        lv_data := cv_metadata||gv_delim||pv_line_name||gv_delim||cv_assignment_name_hdr||gv_delim||cv_sourcesystem_hdr||cv_wrk_assign_only_dff_hdr;
                    ELSE -- Data Line
                        lv_data := vv_file_type||gv_delim||pv_line_name||gv_delim||pv_i_line_content;
                    END IF;
                END IF;

		-- Kirti DFF code ends



     /* Old Code Commented
		 ELSIF UPPER(pv_line_name) =  'ASSIGNMENT' THEN  -- 'Assignment'
         IF pv_i_line_type = cv_title_line  THEN
            lv_data := cv_metadata||gv_delim||pv_line_name||gv_delim||cv_assignment_name_hdr||gv_delim||cv_sourcesystem_hdr||cv_wrk_assign_hdr;
         ELSE -- Data Line
            lv_data := vv_file_type||gv_delim||pv_line_name||gv_delim||pv_i_line_content;
         END IF;
      */

		ELSIF UPPER(pv_line_name) =  'ASSIGNMENTWORKMEASURE' THEN -- 'AssignmentWorkMeasure'
         IF pv_i_line_type = cv_title_line  THEN
            lv_data := cv_metadata||gv_delim||pv_line_name||gv_delim||cv_sourcesystem_hdr||cv_wrk_measure_hdr;
         ELSE -- Data Line
            lv_data := vv_file_type||gv_delim||pv_line_name||gv_delim||gcv_sourcesystem||gv_delim||pv_line_name||'-'||pv_i_line_content;
         END IF;         

		ELSIF UPPER(pv_line_name) =  'ASSIGNMENTGRADESTEPS' THEN  -- 'AssignmentGradeSteps'
         IF pv_i_line_type = cv_title_line  THEN
            lv_data := cv_metadata||gv_delim||pv_line_name||gv_delim||cv_sourcesystem_hdr||cv_assign_grade_hdr;
         ELSE -- Data Line
            lv_data := vv_file_type||gv_delim||pv_line_name||gv_delim||gcv_sourcesystem||gv_delim||pv_line_name||'-'||pv_i_line_content;
         END IF;         
      END IF;  -- pv_line_name

  -- **************************************************
  -- FILE WorkerTermination 
  -- **************************************************
  ELSIF UPPER(pv_i_file_name) LIKE 'WORKERTERMINATION%' THEN  -- 'WorkerTermination'
     IF UPPER(pv_line_name) =  'WORKRELATIONSHIP' THEN  -- 'WorkRelationship'
         IF pv_i_line_type = cv_title_line  THEN
            lv_data := cv_metadata||gv_delim||pv_line_name||gv_delim||cv_sourcesystem_hdr||cv_wrk_relation_hdr;
         ELSE -- Data Line
            lv_data := vv_file_type||gv_delim||pv_line_name||gv_delim||gcv_sourcesystem||gv_delim||pv_line_name||'-'||pv_i_line_content;
         END IF;         
     END IF;     

  -- **************************************************
  -- FILE Bank
  -- **************************************************
  ELSIF UPPER(pv_i_file_name) LIKE 'BANK%' THEN  -- 'Bank'
         IF pv_i_line_type = cv_title_line  THEN
           lv_data := cv_metadata||gv_delim||pv_line_name||gv_delim||cv_sourcesystem_hdr||cv_bank_hdr;
         ELSE 
           lv_data := vv_file_type||gv_delim||pv_line_name||gv_delim||gcv_sourcesystem||gv_delim||pv_i_line_content;
         END IF;

  -- **************************************************
  -- FILE BankBranches
  -- **************************************************
  ELSIF UPPER(pv_i_file_name) LIKE 'BANKBRANCH%'  THEN  -- BankBranch
         IF pv_i_line_type = cv_title_line  THEN
            lv_data := cv_metadata||gv_delim||pv_line_name||gv_delim||cv_sourcesystem_hdr||cv_bank_branch_hdr;
         ELSE 
            lv_data := vv_file_type||gv_delim||pv_line_name||gv_delim||gcv_sourcesystem||gv_delim||pv_i_line_content;
         END IF;

  -- **************************************************
  -- FILE WorkerAssignmentSupervisor
  -- **************************************************
  ELSIF UPPER(pv_i_file_name) LIKE 'WORKERASSIGNMENTSUPERVISOR%' THEN   

      IF UPPER(pv_line_name) =  'ASSIGNMENTSUPERVISOR' THEN  -- 'AssignmentSupervisor'
         IF pv_i_line_type = cv_title_line  THEN
            lv_data := cv_metadata||gv_delim||pv_line_name||gv_delim||cv_sourcesystem_hdr||cv_assignment_hdr||cv_assign_supervisor_hdr;
         ELSE -- Data Line
            lv_data := vv_file_type||gv_delim||pv_line_name||gv_delim||gcv_sourcesystem||gv_delim||pv_line_name||'-'||pv_i_line_content;
         END IF;         
      END IF;  -- pv_line_name

  -- **************************************************
  -- FILE ExternalBankAccount
  -- **************************************************
  ELSIF UPPER(pv_i_file_name)  LIKE 'EXTERNALBANKACCOUNT%' THEN   

      IF UPPER(pv_line_name) =   'EXTERNALBANKACCOUNT' THEN  -- 'ExternalBankAccount'
         IF pv_i_line_type = cv_title_line  THEN
            lv_data := cv_metadata||gv_delim||pv_line_name||gv_delim||cv_sourcesystem_hdr||cv_ext_bank_acct_hdr;
         ELSE -- Data Line
            lv_data := vv_file_type||gv_delim||pv_line_name||gv_delim||gcv_sourcesystem||gv_delim||pv_line_name||'-'||pv_i_line_content;
         END IF;         

      ELSIF UPPER(pv_line_name) =  'EXTERNALBANKACCOUNTOWNER' THEN  -- 'ExternalBankAccountOwner'
         IF pv_i_line_type = cv_title_line  THEN
            lv_data := cv_metadata||gv_delim||pv_line_name||gv_delim||cv_sourcesystem_hdr||cv_ext_bank_acct_owner_hdr;
         ELSE -- Data Line
            lv_data := vv_file_type||gv_delim||pv_line_name||gv_delim||gcv_sourcesystem||gv_delim||pv_line_name||'-'||pv_i_line_content;
         END IF;   
	  END IF;  -- pv_line_name

  -- **************************************************
  -- FILE ABSENCE
  -- **************************************************
  ELSIF UPPER(pv_i_file_name) LIKE 'PERSONABSENCEENTRY%' THEN

     IF  UPPER(pv_line_name) = 'PERSONABSENCEENTRY' THEN
         IF pv_i_line_type = cv_title_line  THEN
            lv_data := cv_metadata||gv_delim||pv_line_name||gv_delim||cv_sourcesystem_hdr||cv_abs_sickness_hdr;
         ELSE -- Data Line
            lv_data := vv_file_type||gv_delim||pv_line_name||gv_delim||gcv_sourcesystem||gv_delim||pv_i_line_content;
         END IF;         

      ELSIF  UPPER(pv_line_name) = 'PERSONMATERNITYABSENCEENTRY' THEN  --'MaternityAbsence'
         IF pv_i_line_type = cv_title_line  THEN
            lv_data := cv_metadata||gv_delim||pv_line_name||gv_delim||cv_sourcesystem_hdr||cv_abs_maternity_hdr;
         ELSE -- Data Line
            lv_data := vv_file_type||gv_delim||pv_line_name||gv_delim||gcv_sourcesystem||gv_delim||pv_line_name||'-'||pv_i_line_content;
         END IF;         

    END IF;

 -- **************************************************
  -- Images
  -- **************************************************
  ELSIF UPPER(pv_i_file_name) LIKE 'PERSONIMAGES%' THEN

     IF  UPPER(pv_line_name) = 'PERSONIMAGES' THEN
         IF pv_i_line_type = cv_title_line  THEN
            lv_data := cv_metadata||gv_delim||pv_line_name||gv_delim||cv_sourcesystem_hdr||cv_images_hdr;
         ELSE -- Data Line
            lv_data := vv_file_type||gv_delim||pv_line_name||gv_delim||gcv_sourcesystem||gv_delim||pv_i_line_content;
         END IF;         

    END IF;

  -- **************************************************
  -- FILE TALENT PROFILE
  -- **************************************************
  ELSIF UPPER(pv_i_file_name) LIKE 'TALENTPROFILE%' THEN

     IF  UPPER(pv_line_name) = 'TALENTPROFILE' THEN
         IF pv_i_line_type = cv_title_line  THEN
            lv_data := cv_metadata||gv_delim||pv_line_name||gv_delim||cv_sourcesystem_hdr||cv_talent_profile_hdr;
         ELSE -- Data Line
            lv_data := vv_file_type||gv_delim||pv_line_name||gv_delim||gcv_sourcesystem||gv_delim||pv_i_line_content;
         END IF;         

      ELSIF  UPPER(pv_line_name) = 'PROFILEITEM' THEN  --'PersonName'
         IF pv_i_line_type = cv_title_line  THEN
            lv_data := cv_metadata||gv_delim||pv_line_name||gv_delim||cv_sourcesystem_hdr||cv_profile_item_hdr;
         ELSE -- Data Line
            lv_data := vv_file_type||gv_delim||pv_line_name||gv_delim||gcv_sourcesystem||gv_delim||pv_line_name||'-'||pv_i_line_content;
         END IF;         

    END IF;

 -- **************************************************
  -- FILE PersonalPaymentMethod
  -- **************************************************
  ELSIF UPPER(pv_i_file_name) LIKE 'PERSONALPAYMENTMETHOD%' THEN   

      IF UPPER(pv_line_name) =  'PERSONALPAYMENTMETHOD' THEN  -- 'PersonalPaymentMethod'
         IF pv_i_line_type = cv_title_line  THEN
            lv_data := cv_metadata||gv_delim||pv_line_name||gv_delim||cv_sourcesystem_hdr||cv_per_pay_method_hrd;
         ELSE -- Data Line
            lv_data := vv_file_type||gv_delim||pv_line_name||gv_delim||gcv_sourcesystem||gv_delim||pv_line_name||'-'||pv_i_line_content;
         END IF;         

      END IF;  -- pv_line_name

  -- **************************************************
  -- FILE AssignedPayroll
  -- **************************************************
  ELSIF UPPER(pv_i_file_name) LIKE 'ASSIGNEDPAYROLL%' THEN   

      IF UPPER(pv_line_name) =  'ASSIGNEDPAYROLL' THEN  -- 'AssignedPayroll'
         IF pv_i_line_type = cv_title_line  THEN
            lv_data := cv_metadata||gv_delim||pv_line_name||gv_delim||cv_sourcesystem_hdr||cv_assigned_payroll_hdr;
         ELSE -- Data Line
            lv_data := vv_file_type||gv_delim||pv_line_name||gv_delim||gcv_sourcesystem||gv_delim||pv_line_name||'-'||pv_i_line_content;
         END IF;         
      END IF;  -- pv_line_name


  -- **************************************************
  -- FILE ThirdPartyOrganizationPaymentMethod
  -- **************************************************
  ELSIF UPPER(pv_i_file_name) LIKE 'THIRDPARTYORGANIZATIONPAYMENTMETHOD%' THEN 

      IF UPPER(pv_line_name) =  'THIRDPARTYORGANIZATIONPAYMENTMETHOD' THEN  -- 'ThirdPartyOrganizationPaymentMethod'
         IF pv_i_line_type = cv_title_line  THEN

            lv_data := cv_metadata||gv_delim||pv_line_name||gv_delim||cv_third_party_org;

         ELSE -- Data Line
            lv_data := vv_file_type||gv_delim||pv_line_name||gv_delim||pv_i_line_content;

         END IF;         
      END IF;  -- pv_line_name


  -- **************************************************
  -- FILE Salary
  -- **************************************************
  ELSIF UPPER(pv_i_file_name) LIKE 'SALARY%' THEN   

     IF UPPER(pv_line_name) =  'SALARY' THEN  -- 'Salary'
         IF pv_i_line_type = cv_title_line  THEN
            lv_data := cv_metadata||gv_delim||pv_line_name||gv_delim||cv_sourcesystem_hdr||cv_salary_hdr;
         ELSE -- Data Line
            lv_data := vv_file_type||gv_delim||pv_line_name||gv_delim||gcv_sourcesystem||gv_delim||pv_line_name||'-'||pv_i_line_content;
         END IF;         
      END IF;  -- pv_line_name


  -- **************************************************
  -- FILE Disability
  -- **************************************************
  ELSIF UPPER(pv_i_file_name) LIKE 'PERSONDISABILITY%' THEN   

     IF UPPER(pv_line_name) =  'PERSONDISABILITY' THEN  -- 'Disability'
         IF pv_i_line_type = cv_title_line  THEN
            lv_data := cv_metadata||gv_delim||pv_line_name||gv_delim||cv_sourcesystem_hdr||cv_disability_hdr;
         ELSE -- Data Line
            lv_data := vv_file_type||gv_delim||pv_line_name||gv_delim||gcv_sourcesystem||gv_delim||pv_line_name||'-'||pv_i_line_content;
         END IF;         
      END IF;  -- pv_line_name
  -- **************************************************
  -- FILE Contact
  -- **************************************************

  ELSIF UPPER(pv_i_file_name) LIKE 'CONTACTS%' THEN   

     --   dbms_output.put_line('contact1');
      IF UPPER(pv_line_name) =   'CONTACT' THEN  -- 'Contact'
         IF pv_i_line_type = cv_title_line  THEN
       --  dbms_output.put_line('contact3:'||cv_contact_hrd);
            lv_data := cv_metadata||gv_delim||pv_line_name||gv_delim||cv_sourcesystem_hdr||cv_contact_hrd;
         ELSE -- Data Line
            lv_data := vv_file_type||gv_delim||pv_line_name||gv_delim||gcv_sourcesystem||gv_delim||pv_line_name||'-'||pv_i_line_content;
         END IF;         
         --dbms_output.put_line('contact2');

      ELSIF UPPER(pv_line_name) =  'CONTACTADDRESS' THEN  -- 'ContactAddress'
         IF pv_i_line_type = cv_title_line  THEN
            lv_data := cv_metadata||gv_delim||pv_line_name||gv_delim||cv_sourcesystem_hdr||cv_contact_addr_hdr;
         ELSE -- Data Line
            lv_data := vv_file_type||gv_delim||pv_line_name||gv_delim||gcv_sourcesystem||gv_delim||pv_line_name||'-'||pv_i_line_content;
         END IF;         

      ELSIF UPPER(pv_line_name) =  'CONTACTPHONE' THEN -- 'ContactPhone'
         IF pv_i_line_type = cv_title_line  THEN
            lv_data := cv_metadata||gv_delim||pv_line_name||gv_delim||cv_sourcesystem_hdr||cv_contact_phone;
         ELSE -- Data Line
            lv_data := vv_file_type||gv_delim||pv_line_name||gv_delim||gcv_sourcesystem||gv_delim||pv_line_name||'-'||pv_i_line_content;
         END IF;         

      ELSIF UPPER(pv_line_name) =  'CONTACTNAME' THEN  -- 'ContactName'
         IF pv_i_line_type = cv_title_line  THEN
            lv_data := cv_metadata||gv_delim||pv_line_name||gv_delim||cv_sourcesystem_hdr||cv_contact_name_hdr;
         ELSE -- Data Line
            lv_data := vv_file_type||gv_delim||pv_line_name||gv_delim||gcv_sourcesystem||gv_delim||pv_line_name||'-'||pv_i_line_content;
         END IF;         

      ELSIF UPPER(pv_line_name) =  'CONTACTRELATIONSHIP' THEN  -- 'ContactRelationship'
         IF pv_i_line_type = cv_title_line  THEN
            lv_data := cv_metadata||gv_delim||pv_line_name||gv_delim||cv_sourcesystem_hdr||cv_contact_relation_hdr;
         ELSE -- Data Line
            lv_data := vv_file_type||gv_delim||pv_line_name||gv_delim||gcv_sourcesystem||gv_delim||pv_line_name||'-'||pv_i_line_content;
         END IF;         
      END IF;  -- pv_line_name

   -- **************************************************
   -- FILE AddAssignment
   -- **************************************************
  ELSIF UPPER(pv_i_file_name) LIKE 'ADDASSIGNMENT%' THEN
      IF UPPER(pv_line_name) =   'WORKTERMS' THEN  -- 'WorkTerms'
         IF pv_i_line_type = cv_title_line  THEN
            lv_data := cv_metadata||gv_delim||pv_line_name||gv_delim||cv_workterms_name_hdr||gv_delim||cv_sourcesystem_hdr||cv_wrk_terms_add_assign_hdr;
         ELSE -- Data Line
            lv_data := vv_file_type||gv_delim||pv_line_name||gv_delim||pv_i_line_content;
         END IF;         

      ELSIF UPPER(pv_line_name) =  'ASSIGNMENT' THEN  -- 'Assignment'
         IF pv_i_line_type = cv_title_line  THEN
            lv_data := cv_metadata||gv_delim||pv_line_name||gv_delim||cv_assignment_name_hdr||gv_delim||cv_sourcesystem_hdr||cv_wrk_add_assign_hdr;
         ELSE -- Data Line
            lv_data := vv_file_type||gv_delim||pv_line_name||gv_delim||pv_i_line_content;
         END IF;

/* Added for Additional Assignment */
      END IF; -- pv_line_name

--V1.10
-- **************************************************
   -- FILE AddAssignment Change
   -- **************************************************
  ELSIF UPPER(pv_i_file_name) LIKE 'ADDASSIGNCHANGE%' THEN
      IF UPPER(pv_line_name) =   'WORKTERMS' THEN  -- 'WorkTerms'
         IF pv_i_line_type = cv_title_line  THEN
            lv_data := cv_metadata||gv_delim||pv_line_name||gv_delim||cv_workterms_name_hdr||gv_delim||cv_sourcesystem_hdr||cv_wrk_terms_add_asg_chg_hdr;
         ELSE -- Data Line
            lv_data := vv_file_type||gv_delim||pv_line_name||gv_delim||pv_i_line_content;
         END IF;         

      ELSIF UPPER(pv_line_name) =  'ASSIGNMENT' THEN  -- 'Assignment'
         IF pv_i_line_type = cv_title_line  THEN
            lv_data := cv_metadata||gv_delim||pv_line_name||gv_delim||cv_assignment_name_hdr||gv_delim||cv_sourcesystem_hdr||cv_wrk_add_assign_chg_hdr;
         ELSE -- Data Line
            lv_data := vv_file_type||gv_delim||pv_line_name||gv_delim||pv_i_line_content;
         END IF;

/* Added for Additional Assignment */
      ELSIF UPPER(pv_line_name) =  'ASSIGNMENTWORKMEASURE%' THEN -- 'AssignmentWorkMeasure'
         IF pv_i_line_type = cv_title_line  THEN
            lv_data := cv_metadata||gv_delim||pv_line_name||gv_delim||cv_sourcesystem_hdr||cv_wrk_measure_hdr;
         ELSE -- Data Line
            lv_data := vv_file_type||gv_delim||pv_line_name||gv_delim||gcv_sourcesystem||gv_delim||pv_line_name||'-'||pv_i_line_content;
         END IF;         

		ELSIF UPPER(pv_line_name) =  'ASSIGNMENTGRADESTEPS' THEN  -- 'AssignmentGradeSteps'
         IF pv_i_line_type = cv_title_line  THEN
            lv_data := cv_metadata||gv_delim||pv_line_name||gv_delim||cv_sourcesystem_hdr||cv_assign_grade_hdr;
         ELSE -- Data Line
            lv_data := vv_file_type||gv_delim||pv_line_name||gv_delim||gcv_sourcesystem||gv_delim||pv_line_name||'-'||pv_i_line_content;
         END IF;             
/* Added for Additional Assignment */
      END IF; -- pv_line_name
      --V1.10
   -- Code added by Kirti for Legislative Data Update only file
   -- **************************************************
   -- FILE WORKER only Legislative Data Update
   -- **************************************************
  ELSIF UPPER(pv_i_file_name) LIKE 'WORKERHIRELEGDFF%' THEN
     IF UPPER(pv_line_name) = 'PERSONLEGISLATIVEDATA' THEN -- 'PersonLegislativeData'
		get_paramval_leg_dff (vvv_legislative_dff_mode);
	IF vvv_legislative_dff_mode = 'U' THEN
        	 IF pv_i_line_type = cv_title_line  THEN
	            lv_data := cv_metadata||gv_delim||pv_line_name||gv_delim||cv_sourcesystem_hdr||cv_legislation_only_dff_hdr;
	         ELSE -- Data Line
        	    lv_data := vv_file_type||gv_delim||pv_line_name||gv_delim||gcv_sourcesystem||gv_delim||pv_line_name||'-'||pv_i_line_content;
	         END IF;
	END IF;
     END IF;
   -- Kirti Code ends		

   -- Code added by Michal for Benefits/Learning Load.
   -- **************************************************
   -- FILE Generation for Benefits and Learning only
   -- **************************************************
    ELSE 

     IF pv_i_line_type = cv_title_line  THEN
            lv_data := pv_i_line_content;
     ELSE -- Data Line
            lv_data := pv_i_line_content;
     END IF;
  END IF;  -- pv_i_file_name




   INSERT INTO xxmx_hdl_file_temp(file_name, line_type, line_content) VALUES (pv_i_file_name,pv_line_name,lv_data);

   IF( pv_ftp_enabled = 'Y')
   THEN 
      utl_file.put_line (g_file_id, lv_data);
   END IF;
  --


EXCEPTION
  --
  WHEN utl_file.write_error THEN
    utl_file.fclose_all;
  --  print_log ('Error: Invalid Operation');
    raise;
    --
  WHEN OTHERS THEN
    utl_file.fclose_all;
 --   print_log ('Error: Unexpected Error');
    raise;
  --
END write_hdl_line;

-- ----------------------------------------------------------------------------
-- |------------------------------< CLOSE_HDL >-------------------------------|
-- ----------------------------------------------------------------------------
PROCEDURE close_hdl (p_file_type in varchar2 default 'M'
                    ,pv_ftp_enabled IN VARCHAR2 DEFAULT 'N') is
  --
  -- Local Variables
  l_file_id                  utl_file.file_type;
  --
begin
NULL;
  -- Get the file handler
   l_file_id := g_file_id;
  IF( pv_ftp_enabled = 'Y') THEN
     -- Write the EOF
     utl_file.put_line (l_file_id, '');
     utl_file.put_line (l_file_id, '');
     utl_file.put_line (l_file_id, 'COMMENT ############################## END of the File ###############################');
     -- Close File
     utl_file.fclose (l_file_id);
   END IF;
  --dbms_output.put_line('Close Complete');
  --
exception
  --
  when utl_file.invalid_filehandle THEN
    utl_file.fclose_all;
 --   print_log ('Error: Invalid File Handler');
    raise;
    --
  when others THEN
    utl_file.fclose_all;
 --   print_log ('Error: Unexpected Error');
    raise;
  --*/
END close_hdl;

     --
     --
END xxmx_hdl_utilities_pkg;
/

SHOW ERRORS PACKAGE BODY xxmx_hdl_utilities_pkg;
/