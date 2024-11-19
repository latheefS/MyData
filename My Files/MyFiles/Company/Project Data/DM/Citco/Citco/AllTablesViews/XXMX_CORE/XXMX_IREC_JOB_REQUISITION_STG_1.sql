--------------------------------------------------------
--  DDL for Package Body XXMX_IREC_JOB_REQUISITION_STG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "XXMX_CORE"."XXMX_IREC_JOB_REQUISITION_STG" AS

--******************************************************************************
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
--** FILENAME  :  xxmx_irec_job_requisition_stg.sql
--**
--** FILEPATH  :  $XXV1_TOP/install/sql
--**
--** VERSION   :  1.0
--**
--** EXECUTE
--** IN SCHEMA :  XXMX_CORE
--**
--** AUTHORS   :  Shireesha T.R
--**
--** PURPOSE   :  This package contains procedures for extracting IRecruitment into Staging tables
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
--**   1.0  05/12/2021    Shireesha T.R       Created for Maximise.
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
--**   1.0  25/11/2021   Shireesha T.R       Created for Maximise.
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

	/****************************************************************
	----------------Export IRecruitment Information-------------------------
	*****************************************************************/
    gvv_ReturnStatus                          VARCHAR2(1);
    gvt_ReturnMessage                         xxmx_module_messages.module_message%TYPE;
    gvv_ProgressIndicator                     VARCHAR2(100);
    gcv_PackageName                           CONSTANT  VARCHAR2(30)                                := 'xxmx_irec_job_requisition_stg';
    gct_ApplicationSuite                      CONSTANT  xxmx_module_messages.application_suite%TYPE := 'HCM';
    gct_Application                           CONSTANT  xxmx_module_messages.application%TYPE       := 'IREC';
    gv_i_BusinessEntity                       CONSTANT  VARCHAR2(100)                               := 'JOB_REQUISITION';
    ct_Phase                                  CONSTANT  xxmx_module_messages.phase%TYPE             := 'EXTRACT';
    cv_i_BusinessEntityLevel                  CONSTANT  VARCHAR2(100)                               := 'ALL';
    gv_hr_date					              DATE                                                  := '31-DEC-4712';
	--pt_i_MigrationSetName                     VARCHAR2(100)                                         := 'IRecruitment '||to_char(SYSDATE, 'DD/MM/YYYY');  --no hard code
	--p_bg_name								  VARCHAR2(100)                                         := 'TEST_BG';
    gvt_Severity                              xxmx_module_messages.severity%TYPE;
    gvt_ModuleMessage                         xxmx_module_messages.module_message%TYPE;
    gvt_OracleError                           xxmx_module_messages.oracle_error%TYPE;
    gvv_leg_code                VARCHAR2(100);

    E_MODULEERROR                              EXCEPTION;
    gvv_migration_date_from                    VARCHAR2(30);
	gvv_prev_tax_year_date                     VARCHAR2(30);
	gvd_migration_date_from                    DATE;
	gvd_prev_tax_year_date                     DATE;
	gvv_migration_date_to                      VARCHAR2(30);
	gvd_migration_date_to                      DATE;
   -- gvt_user_person_type                       xxmx_migration_parameters.PARAMETER_VALUE%TYPE;

PROCEDURE   stg_main (    pt_i_ClientCode                 IN      xxmx_client_config_parameters.client_code%TYPE
                            ,pt_i_MigrationSetName           IN      xxmx_migration_headers.migration_set_name%TYPE )
IS

        CURSOR METADATA_CUR
        IS
            SELECT  Entity_package_name,Stg_procedure_name, BUSINESS_ENTITY,SUB_ENTITY_SEQ
			FROM     xxmx_migration_metadata a
			WHERE application_suite = gct_ApplicationSuite
            AND Application = gct_Application
            AND business_entity = gv_i_BusinessEntity
			AND a.enabled_flag = 'Y'
            Order by Business_entity_seq, Sub_entity_seq;

        CURSOR BG_CUR
        IS
         SELECT DISTINCT
                    haou.organization_id,
                    haou.name
            FROM    apps.hr_all_organization_units@MXDM_NVIS_EXTRACT    haou
                  ,apps.hr_organization_information@MXDM_NVIS_EXTRACT  hoi
           WHERE   1 = 1
           AND     hoi.organization_id   = haou.organization_id
           AND     hoi.org_information1  = 'HR_BG'
           AND     haou.name            IN (
                                            SELECT xp.parameter_value
                                            FROM   xxmx_migration_parameters  xp
                                            WHERE  1 = 1
                                            AND    xp.application_suite      = 'HCM'
                                            AND    xp.application            = 'HR'
                                            AND    xp.business_entity        = 'ALL'
                                            AND    xp.sub_entity             = 'ALL'
                                            AND    xp.parameter_code         = 'BUSINESS_GROUP_NAME'
                                            AND    NVL(xp.enabled_flag, 'N') = 'Y'
                        		);

    lv_sql VARCHAR2(32000);
    e_DateError                         EXCEPTION;

    l_leg_code VARCHAR2(1000);
    l_bg_name VARCHAR2(1000);
    l_bg_id NUMBER;

    cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'run_extract';
    ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
    cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT '';
    cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'JOB_REQUISITION';

    vt_MigrationSetID                           xxmx_migration_headers.migration_set_id%TYPE;
    pt_i_MigrationSetID                         xxmx_migration_headers.migration_set_id%TYPE;
    vt_BusinessEntitySeq                        xxmx_migration_metadata.business_entity_seq%TYPE;


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
            ,pt_i_ModuleMessage       => 'Parameter for Irec Extract',
             pt_i_OracleError         => NULL
        );

      --
        gvv_migration_date_from := xxmx_utilities_pkg.get_single_parameter_value(
                        pt_i_ApplicationSuite           =>     gct_ApplicationSuite
                        ,pt_i_Application                =>     gct_Application
                        ,pt_i_BusinessEntity             =>     'ALL'
                        ,pt_i_SubEntity                  =>     'ALL'
                        ,pt_i_ParameterCode              =>     'MIGRATE_DATE_FROM');


        gvd_migration_date_from := TO_DATE(gvv_migration_date_from,'YYYY-MM-DD');

        gvv_ProgressIndicator := '0021';
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
            ,pt_i_ModuleMessage       => 'Parameter for Irec Extract'||gvd_migration_date_from,
             pt_i_OracleError         => NULL
        );
         --
        gvv_migration_date_to := xxmx_utilities_pkg.get_single_parameter_value(
                        pt_i_ApplicationSuite           =>     gct_ApplicationSuite
                        ,pt_i_Application               =>     gct_Application
                        ,pt_i_BusinessEntity            =>     'ALL'
                        ,pt_i_SubEntity                 =>     'ALL'
                        ,pt_i_ParameterCode             =>     'MIGRATE_DATE_TO');

        gvd_migration_date_to := TO_DATE(gvv_migration_date_to,'YYYY-MM-DD');

        gvv_ProgressIndicator := '0021';
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
            ,pt_i_ModuleMessage       => 'Parameter for Irec Extract'||gvd_migration_date_to,
             pt_i_OracleError         => NULL
        );

      	/*gvt_user_person_type := xxmx_utilities_pkg.get_single_parameter_value(
                        pt_i_ApplicationSuite            =>     gct_ApplicationSuite
                        ,pt_i_Application                =>     gct_Application
                        ,pt_i_BusinessEntity             =>     'CANDIDATE'
                        ,pt_i_SubEntity                  =>     'ALL'
                        ,pt_i_ParameterCode              =>     'PERSON_TYPE');  */


        gvv_ProgressIndicator := '0025';
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
            ,pt_i_ModuleMessage       => 'Call to IREC Extracts- Job Requisition',
             pt_i_OracleError         => NULL
        );

    FOR BG_REC IN BG_CUR LOOP -- 10

        l_bg_name := NULL;
        l_bg_id := NULL;
        l_bg_name := BG_REC.name;
        l_bg_id := BG_REC.organization_id;

        FOR METADATA_REC IN METADATA_CUR -- 2
        LOOP

--                dbms_output.put_line(' #' ||r_package_name.v_package ||' #'|| l_bg_name || '  #' || l_bg_id || '  #' || vt_MigrationSetID || '  #' || pt_i_MigrationSetName  );

                    lv_sql:= 'BEGIN '
                            ||METADATA_REC.Entity_package_name
                            ||'.'||METADATA_REC.Stg_procedure_name
                            ||'('||''''|| l_bg_name
                            ||''','
                            ||l_bg_id
                            ||','
                            ||vt_MigrationSetID
                            ||','''
                            ||pt_i_MigrationSetName
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
                        ,pt_i_ModuleMessage       => lv_sql       ,
                        pt_i_OracleError         => NULL
                     );
                    DBMS_OUTPUT.PUT_LINE(lv_sql);

        END LOOP;

    END LOOP;
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


END stg_main;

PROCEDURE export_irec_job_requisition
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          number
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE )  IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(80) := 'export_irec_job_requisition';
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_HCM_IREC_JOB_REQ_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'JOB_REQUISITION';

        lvv_migration_date_to                           VARCHAR2(30);
        lvv_migration_date_from                         VARCHAR2(30);
        lvv_prev_tax_year_date                          VARCHAR2(30);
        lvd_migration_date_to                           DATE;
        lvd_migration_date_from                         DATE;
        lvd_prev_tax_year_date                          DATE;

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
        FROM    XXMX_HCM_IREC_JOB_REQ_STG
        WHERE   bg_id    = p_bg_id    ;

        COMMIT;

		INSERT
        INTO    XXMX_HCM_IREC_JOB_REQ_STG
               (
			   FILE_SET_ID			    ,
			   MIGRATION_SET_ID 	    ,
			   MIGRATION_SET_NAME 	    ,
			   MIGRATION_STATUS	        ,
			   BG_NAME   			    ,
			   BG_ID            	    ,
			   METADATA			        ,
			   OBJECTNAME			    ,
			   REQUISITION_ID			,
			   REQUISITION_NUMBER		,
			   RECRUITING_TYPE			,
			   JOB_ID					,
			   NUMBER_OF_OPENINGS		  ,
			   UNLIMITED_OPENINGS_FLAG		,
			   REQUISITION_TITLE			,
			   INTERNAL_REQUISITION_TITLE ,
			   BUSINESS_JUSTIFICATION	,
			   HIRING_MANAGER_ID		,
			   RECRUITER_ID				,
			   PRIMARY_WORK_LOCATION_ID	,
			   GRADE_ID					,
			   ORGANIZATION_ID			,
			   JOB_FAMILY_ID			,
			   JOB_FUNCTION				,
			   LEGAL_EMPLOYER_ID		,
			   BUSINESS_UNIT_ID			,
			   DEPARTMENT_ID			,
			   SOURCING_BUDGET			,
			   TRAVEL_BUDGET			,
			   RELOCATION_BUDGET		,
			   EMPLOYEE_REFERRAL_BONUS	,
			   BUDGET_CURRENCY			,
			   MAXIMUM_SALARY			,
			   MINIMUM_SALARY			,
			   PAY_FREQUENCY			,
			   SALARY_CURRENCY			,
			   WORKER_TYPE				,
			   REGULAR_OR_TEMPORARY		,
			   MANAGEMENT_LEVEL			,
			   FULLTIME_OR_PARTTIME		,
			   JOB_SHIFT				,
			   JOB_TYPE					,
			   EDUCATION_LEVEL			,
			   CONTACT_NAME_EXTERNAL	,
			   CONTACT_EMAIL_EXTERNAL			,
/*			   EXTERNAL_SHORT_DESCRIPTION		*/
/*			   EXTERNAL_DESCRIPTION				*/
			   EXTERNAL_EMPLOYER_DESCRIPTION_ID	,
			   EXTERNAL_ORG_DESCRIPTION_ID,
			   CONTACT_NAME_INTERNAL				,
			   CONTACT_EMAIL_INTERNAL				,
/*	   INTERNAL_SHORT_DESCRIPTION			*/
/*		   INTERNAL_DESCRIPTION			    */
			   INTERNAL_EMPLOYER_DESCRIPTION_ID	    ,
			   INTERNAL_ORG_DESCRIPTION_ID ,
			   DISPLAY_IN_ORG_CHART_FLAG			,
			   CURRENT_PHASE_ID					,
			   CURRENT_STATE_ID					,
/*COMMENTS						*/
			   JOB_CODE							,
			   HIRING_MANAGER_PERSON_NUMBER		,
			   HIRING_MANAGER_ASSIGNMENT_NUMBER	,
			   RECRUITER_PERSON_NUMBER			,
			   RECRUITER_ASSIGNMENT_NUMBER		,
			   PRIMARY_LOCATION_NAME			,
			   GRADE_CODE						,
			   ORGANIZATION_CODE				,
			   JOB_FAMILY_NAME					,
			   LEGAL_EMPLOYER_NAME				,
			   BUSINESS_UNIT_SHORT_CODE			,
			   DEPARTMENT_NAME					,
			   CURRENT_PHASE_CODE				,
			   CURRENT_STATE_CODE				,
			   PRIMARY_WORK_LOCATION_CODE		,
			   BUDGET_CURRENCY_NAME				,
			   SALARY_CURRENCY_NAME	            ,
			   EXTERNAL_EMP_DESCRIPTION_CODE	   ,
			   EXTERNAL_ORG_DESCRIPTION_CODE  ,
			   INTERNAL_EMP_DESCRIPTION_CODE	   ,
			   INTERNAL_ORG_DESCRIPTION_CODE  ,
			   SUBMISSIONS_PROCESS_TEMPLATE_ID	,
			   ORGANIZATION_NAME				,
			   CLASSIFICATION_CODE				,
			   PRIMARY_LOCATION_ID				,
			   BASE_LANGUAGE_CODE				,
			   CANDIDATE_SELECTION_PROCESS_CODE ,
			   JOB_FAMILY_CODE					,
			   EXTERNAL_APPLY_FLOW_ID			,
			   EXTERNAL_APPLY_FLOW_CODE		,
			   PIPELINE_REQUISITION_FLAG	,
			   PIPELINE_REQUISITION_ID		,
			   APPLY_WHEN_NOT_POSTED_FLAG	,
			   PIPELINE_REQUISITION_NUMBER	,
			   POSITION_ID					,
			   POSITION_CODE				,
			   REQUISITION_TEMPLATE_ID		,
			   CODE							,
			   AUTOMATIC_FILL_FLAG			,
			   SEND_NOTIFICATIONS_FLAG		,
			   EXTERNAL_DESCRIPTION_ID		,
			   INTERNAL_DESCRIPTION_ID		,
			   EXTERNAL_DESCRIPTION_CODE	,
			   INTERNAL_DESCRIPTION_CODE	,
			   AUTO_OPEN_REQUISITION		,
			   POSTING_EXPIRE_IN_DAYS		,
			   AUTO_UNPOST_REQUISITION		,
			   UNPOST_FORMULA_ID			,
			   UNPOST_FORMULA_CODE			,
			   GUID							,
			   SOURCE_SYSTEM_ID				,
			   SOURCE_SYSTEM_OWNER			,
			   ATTRIBUTE_CATEGORY 			,
			   ATTRIBUTE1 					,
			   ATTRIBUTE2 					,
			   ATTRIBUTE3 					,
			   ATTRIBUTE4 					,
			   ATTRIBUTE5 					,
			   ATTRIBUTE6 					,
			   ATTRIBUTE7 					,
			   ATTRIBUTE8 					,
			   ATTRIBUTE9 					,
			   ATTRIBUTE10 					,
			   ATTRIBUTE_NUMBER1 			,
			   ATTRIBUTE_NUMBER2 			,
			   ATTRIBUTE_NUMBER3 			,
			   ATTRIBUTE_NUMBER4 			,
			   ATTRIBUTE_NUMBER5 			,
			   ATTRIBUTE_DATE1 				,
			   ATTRIBUTE_DATE2 				,
			   ATTRIBUTE_DATE3 				,
			   ATTRIBUTE_DATE4 				,
			   ATTRIBUTE_DATE5 				)
          SELECT
               NULL,
				pt_i_MigrationSetID  ,
				pt_i_MigrationSetName,
				'EXTRACTED'          ,
		        p_bg_name            ,
				p_bg_id              ,
                'MERGE'              ,
                'Job_Requisition'    ,
				NULL,
				'REQ' || req.requisition_id,
				NULL AS recruitingtype,
				NULL AS jobid,
				pav.number_of_openings   AS number_of_openings,
				'No' AS unlimitedopenings_flag,
				req.name  AS requisition_title,
				NULL AS internal_requisition_title,
				SUBSTR(pav.description,1,30) AS business_justification,
				NULL AS hiring_manager_id,
				NULL AS recruiter_id,
				NULL AS prim_work_loc_id,
				NULL AS grade_id,
				NULL AS organization_id,
				NULL AS job_family_id,
				pjo.name AS job_function,
				NULL AS legal_employer_id,
				NULL AS business_unit_id,
				NULL AS department_id,
				NULL AS sourcing_budget,
				NULL AS travel_budget,
				NULL AS relocation_budget,
				NULL AS empl_referral_bonus,
				NULL AS budget_currency,
				NULL AS maximum_salary,
				NULL AS minimum_salary,
				NULL AS pay_frequency,
				NULL AS salary_currency,
				NULL AS wroker_type,
				'REGULAR' AS regular_or_temporary,
				NULL AS management_level,
				'FULL TIME' AS fulltime_or_parttime,
				NULL AS job_shift,
				NULL AS job_type,
				NULL AS education_level,
				NULL AS contact_name_external,
				NULL AS contact_email_external,
				--NULL AS external_short_description,
				--NULL AS external_description,
				NULL AS external_empl_desc_id,
				NULL AS external_orga_desc_id,
				NULL AS contact_name_internal,
				NULL AS contact_email_internal,
				--NULL AS internal_short_desc,
				--NULL AS internal_desc,
				NULL AS internal_employer_desc_id,
				NULL AS internal_organization_desc_id,
				'N' AS display_in_org_chart_flag,
				NULL AS current_phase_id,
				NULL AS current_state_id,
				--req.comments   AS comments,
				NULL AS job_code,
				ppf.employee_number      AS hiring_manager_person_number,
				reqppf.employee_number      AS hiring_manager_assign_number,
				pavppf.employee_number      AS recruiter_person_number,
				NULL AS recruiter_assignment_num,
				hla.description          AS primary_loc_name,
				NULL AS grade_code,
				NULL AS organization_code,
				pjg.displayed_name   AS jobfamilyname,
				NULL AS legalemployername,
				NULL AS business_unit_short_code,
				hor.name AS department_name,
				NULL AS current_phase_code,
				NULL AS current_state_code,
				hla.location_code   AS primary_work_location_code,
				NULL AS budget_currency_name,
				NULL AS salary_currency_name,
				NULL AS ext_empl_desc_code,
				NULL AS ext_orga_desc_code,
				NULL AS inter_employer_desc_code,
				NULL AS internal_org_desc_code,
				NULL AS submissions_procs_temp_id,
				hor.name  AS organization_name,
				NULL AS classification_code,
				NULL AS primary_location_id,
				'US' AS base_language_code,
				NULL AS cand_selection_procss_code,
				NULL AS job_family_code,
				NULL AS external_apply_flow_id,
				NULL AS external_apply_flow_code,
				NULL AS pipeline_requisition_flag,
				NULL AS pipeline_requisition_id,
				'YES' AS apply_when_not_posted_flag,
				NULL AS pipeline_requisition_number,
				NULL AS position_id,
				NULL AS position_code,
				NULL AS requisition_template_id,
				NULL AS code,
				'No' AS automatic_fill_flag,
				'YES' AS send_notifications_flag,
				NULL AS external_description_id,
				NULL AS internal_description_id,
				NULL AS external_description_code,
				NULL AS internal_description_code,
				'No' AS auto_open_requisition,
				NULL AS posting_expire_in_days,
				NULL AS auto_unpost_requisition,
				NULL AS unpost_formula_id,
				NULL AS unpost_formula_code,
				NULL AS guid,
				NULL AS source_system_id,
				NULL AS source_system_owner,
				NULL AS attribute_category,
				NULL AS attribute1,
				NULL AS attribute2,
				NULL AS attribute3,
				NULL AS attribute4,
				NULL AS attribute5,
				NULL AS attribute6,
				NULL AS attribute7,
				NULL AS attribute8,
				NULL AS attribute9,
				NULL AS attribute10,
				NULL AS attribute_number1,
				NULL AS attribute_number2,
				NULL AS attribute_number3,
				NULL AS attribute_number4,
				NULL AS attribute_number5,
				NULL AS attribute_date1,
				NULL AS attribute_date2,
				NULL AS attribute_date3,
				NULL AS attribute_date4,
				NULL AS attribute_date5
        FROM
				per_requisitions@MXDM_NVIS_EXTRACT            req,
				per_all_vacancies@MXDM_NVIS_EXTRACT           pav,
				hr_all_organization_units@MXDM_NVIS_EXTRACT   hor,
				per_all_people_f@MXDM_NVIS_EXTRACT            ppf,
                per_all_people_f@MXDM_NVIS_EXTRACT            pavppf,
                per_all_people_f@MXDM_NVIS_EXTRACT            reqppf,
				per_jobs@MXDM_NVIS_EXTRACT                    pjo,
				per_job_groups@MXDM_NVIS_EXTRACT              pjg,
				hr_locations_all@MXDM_NVIS_EXTRACT            hla
        WHERE
				req.requisition_id = pav.requisition_id
				AND pav.organization_id = hor.organization_id
				AND pav.manager_id = ppf.person_id
				AND req.person_id = reqppf.person_id
				AND pjo.job_id = pav.job_id
				AND pjo.job_group_id = pjg.job_group_id
				AND pav.location_id = hla.location_id
				AND pav.recruiter_id = pavppf.person_id
                AND ppf.business_Group_id = p_bg_id
                AND reqppf.business_Group_id = p_bg_id
                AND pavppf.business_Group_id = p_bg_id
                AND trunc(sysdate) between ppf.effective_start_Date and ppf.effective_end_date
                AND trunc(sysdate) between reqppf.effective_start_Date and reqppf.effective_end_date
                AND trunc(sysdate) between pavppf.effective_start_Date and pavppf.effective_end_date;


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
	END export_irec_job_requisition;



PROCEDURE export_irec_jR_hiring_team
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          number
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE )  IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_irec_jR_hiring_team';
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_HCM_IREC_JR_HIRE_TEAM_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'JR_HIRING_TEAM';

        lvv_migration_date_to                           VARCHAR2(30);
        lvv_migration_date_from                         VARCHAR2(30);
        lvv_prev_tax_year_date                          VARCHAR2(30);
        lvd_migration_date_to                           DATE;
        lvd_migration_date_from                         DATE;
        lvd_prev_tax_year_date                          DATE;

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
        FROM    XXMX_HCM_IREC_JR_HIRE_TEAM_STG
        WHERE   bg_id    = p_bg_id    ;

        COMMIT;

		INSERT
        INTO    XXMX_HCM_IREC_JR_HIRE_TEAM_STG
               (
				   FILE_SET_ID			,
				   MIGRATION_SET_ID 	,
				   MIGRATION_SET_NAME 	,
				   MIGRATION_STATUS	    ,
				   BG_NAME   			,
				   BG_ID            	,
				   METADATA			    ,
				   OBJECTNAME			,
				   --
				   TEAM_MEMBER_ID	,
				   COLLABORATOR_TYPE,
				   REQUISITION_NUMBER,
				   MEMBER_TYPE,
				   PERSON_NUMBER,
				   REQUISITION_ID,
				   ASSIGNMENT_ID	,
				   ASSIGNMENT_NUMBER,
				   PERSON_ID,
				   GUID	 ,
				   SOURCE_SYSTEM_ID	    ,
				   SOURCE_SYSTEM_OWNER	,
			       ---
			       ATTRIBUTE_CATEGORY,
			       ATTRIBUTE1 ,
			       ATTRIBUTE2 ,
			       ATTRIBUTE3 ,
			       ATTRIBUTE4 ,
			       ATTRIBUTE5 ,
			       ATTRIBUTE6 ,
			       ATTRIBUTE7 ,
			       ATTRIBUTE8 ,
			       ATTRIBUTE9 ,
			       ATTRIBUTE10   ,
			       ATTRIBUTE_NUMBER1 ,
			       ATTRIBUTE_NUMBER2 ,
			       ATTRIBUTE_NUMBER3 ,
			       ATTRIBUTE_NUMBER4 ,
			       ATTRIBUTE_NUMBER5 ,
			       ATTRIBUTE_DATE1  ,
			       ATTRIBUTE_DATE2  ,
			       ATTRIBUTE_DATE3  ,
			       ATTRIBUTE_DATE4  ,
			       ATTRIBUTE_DATE5
			   )SELECT

                    NULL,
                    pt_i_MigrationSetID  ,
                    pt_i_MigrationSetName,
                    'EXTRACTED'          ,
                    p_bg_name            ,
                    p_bg_id              ,
                    'MERGE'              ,
                    'JR_HIRING_TEAM'    ,
                    NULL AS teammemberid,
					'ORA_HIRING_TEAM_COLLABORATOR' AS collaboratortype,
					'REQ' || per.requisition_id AS requisitionnumber,
					'Hiring Manager' AS membertype,
					papf.employee_number AS personnumber,
					NULL requisitionid,
					NULL AS assignmentid,
					NULL AS assignmentnumber,
					NULL AS personid,
                    Null,
                    Null,
                    NUll,
                    NULL as ATTRIBUTE_CATEGORY,
                    NULL as ATTRIBUTE1 ,
                    NULL as ATTRIBUTE2 ,
                    NULL as ATTRIBUTE3 ,
                    NULL as ATTRIBUTE4 ,
                    NULL as ATTRIBUTE5 ,
                    NULL as ATTRIBUTE6 ,
                    NULL as ATTRIBUTE7 ,
                    NULL as ATTRIBUTE8 ,
                    NULL as ATTRIBUTE9 ,
                    NULL as ATTRIBUTE10   ,
                    NULL as ATTRIBUTE_NUMBER1 ,
                    NULL as ATTRIBUTE_NUMBER2 ,
                    NULL as ATTRIBUTE_NUMBER3 ,
                    NULL as ATTRIBUTE_NUMBER4 ,
                    NULL as ATTRIBUTE_NUMBER5 ,
                    NULL as ATTRIBUTE_DATE1  ,
                    NULL as ATTRIBUTE_DATE2  ,
                    NULL as ATTRIBUTE_DATE3  ,
                    NULL as ATTRIBUTE_DATE4  ,
                    NULL as ATTRIBUTE_DATE5

             FROM
					per_requisitions@MXDM_NVIS_EXTRACT     per,
					per_all_vacancies@MXDM_NVIS_EXTRACT    pav,
					per_all_people_f@MXDM_NVIS_EXTRACT     papf
--per_all_people_f ppf_recruiter,
			WHERE
				   per.requisition_id = pav.requisition_id
			AND pav.manager_id = papf.person_id
			AND trunc(sysdate) BETWEEN papf.effective_start_date AND papf.effective_end_date
			AND papf.business_Group_id = p_bg_id

			UNION
			SELECT
                    NULL,
                    pt_i_MigrationSetID  ,
                    pt_i_MigrationSetName,
                    'EXTRACTED'          ,
                    p_bg_name            ,
                    p_bg_id              ,
                    'MERGE'              ,
                    'JR_HIRING_TEAM'    ,
					null AS teammemberid,
					'ORA_HIRING_TEAM_COLLABORATOR' AS collaboratortype,
					'REQ' || per.requisition_id AS requisitionnumber,
					'Recruiter' AS membertype,
					papf.employee_number AS personnumber,
					NULL requisitionid,
					NULL AS assignmentid,
					NULL AS assignmentnumber,
					NULL AS personid,
                    Null,
                    Null,
                    NUll,
                    NULL as ATTRIBUTE_CATEGORY,
                    NULL as ATTRIBUTE1 ,
                    NULL as ATTRIBUTE2 ,
                    NULL as ATTRIBUTE3 ,
                    NULL as ATTRIBUTE4 ,
                    NULL as ATTRIBUTE5 ,
                    NULL as ATTRIBUTE6 ,
                    NULL as ATTRIBUTE7 ,
                    NULL as ATTRIBUTE8 ,
                    NULL as ATTRIBUTE9 ,
                    NULL as ATTRIBUTE10   ,
                    NULL as ATTRIBUTE_NUMBER1 ,
                    NULL as ATTRIBUTE_NUMBER2 ,
                    NULL as ATTRIBUTE_NUMBER3 ,
                    NULL as ATTRIBUTE_NUMBER4 ,
                    NULL as ATTRIBUTE_NUMBER5 ,
                    NULL as ATTRIBUTE_DATE1  ,
                    NULL as ATTRIBUTE_DATE2  ,
                    NULL as ATTRIBUTE_DATE3  ,
                    NULL as ATTRIBUTE_DATE4  ,
                    NULL as ATTRIBUTE_DATE5
			FROM
					per_requisitions@MXDM_NVIS_EXTRACT     per,
					per_all_vacancies@MXDM_NVIS_EXTRACT    pav,
					per_all_people_f@MXDM_NVIS_EXTRACT     papf

			WHERE
					per.requisition_id = pav.requisition_id
					AND pav.recruiter_id = papf.person_id
                    AND papf.business_Group_id = p_bg_id
					AND trunc(sysdate) BETWEEN papf.effective_start_date AND papf.effective_end_date
					;

            INSERT
        INTO    XXMX_HCM_IREC_JR_HIRE_TEAM_STG
               (
				   FILE_SET_ID			,
				   MIGRATION_SET_ID 	,
				   MIGRATION_SET_NAME 	,
				   MIGRATION_STATUS	    ,
				   BG_NAME   			,
				   BG_ID            	,
				   METADATA			    ,
				   OBJECTNAME			,
				   --
				   TEAM_MEMBER_ID	,
				   COLLABORATOR_TYPE,
				   REQUISITION_NUMBER,
				   MEMBER_TYPE,
				   PERSON_NUMBER,
				   REQUISITION_ID,
				   ASSIGNMENT_ID	,
				   ASSIGNMENT_NUMBER,
				   PERSON_ID,
				   GUID	 ,
				   SOURCE_SYSTEM_ID	    ,
				   SOURCE_SYSTEM_OWNER	,
			       ---
			       ATTRIBUTE_CATEGORY,
			       ATTRIBUTE1 ,
			       ATTRIBUTE2 ,
			       ATTRIBUTE3 ,
			       ATTRIBUTE4 ,
			       ATTRIBUTE5 ,
			       ATTRIBUTE6 ,
			       ATTRIBUTE7 ,
			       ATTRIBUTE8 ,
			       ATTRIBUTE9 ,
			       ATTRIBUTE10   ,
			       ATTRIBUTE_NUMBER1 ,
			       ATTRIBUTE_NUMBER2 ,
			       ATTRIBUTE_NUMBER3 ,
			       ATTRIBUTE_NUMBER4 ,
			       ATTRIBUTE_NUMBER5 ,
			       ATTRIBUTE_DATE1  ,
			       ATTRIBUTE_DATE2  ,
			       ATTRIBUTE_DATE3  ,
			       ATTRIBUTE_DATE4  ,
			       ATTRIBUTE_DATE5
			   )
			SELECT
                    NULL,
                    pt_i_MigrationSetID  ,
                    pt_i_MigrationSetName,
                    'EXTRACTED'          ,
                    p_bg_name            ,
                    p_bg_id              ,
                    'MERGE'              ,
                    'JR_HIRING_TEAM'    ,
					null AS teammemberid,
					'ORA_HIRING_TEAM_COLLABORATOR' AS collaboratortype,
					'REQ' || per.requisition_id AS requisitionnumber,
					'Collaborator' AS membertype,
					papf.employee_number AS personnumber,
					NULL requisitionid,
					NULL AS assignmentid,
					NULL AS assignmentnumber,
					NULL AS personid,
                     Null,
                    Null,
                    NUll,
                    NULL as ATTRIBUTE_CATEGORY,
                    NULL as ATTRIBUTE1 ,
                    NULL as ATTRIBUTE2 ,
                    NULL as ATTRIBUTE3 ,
                    NULL as ATTRIBUTE4 ,
                    NULL as ATTRIBUTE5 ,
                    NULL as ATTRIBUTE6 ,
                    NULL as ATTRIBUTE7 ,
                    NULL as ATTRIBUTE8 ,
                    NULL as ATTRIBUTE9 ,
                    NULL as ATTRIBUTE10   ,
                    NULL as ATTRIBUTE_NUMBER1 ,
                    NULL as ATTRIBUTE_NUMBER2 ,
                    NULL as ATTRIBUTE_NUMBER3 ,
                    NULL as ATTRIBUTE_NUMBER4 ,
                    NULL as ATTRIBUTE_NUMBER5 ,
                    NULL as ATTRIBUTE_DATE1  ,
                    NULL as ATTRIBUTE_DATE2  ,
                    NULL as ATTRIBUTE_DATE3  ,
                    NULL as ATTRIBUTE_DATE4  ,
                    NULL as ATTRIBUTE_DATE5
			FROM
					per_requisitions@MXDM_NVIS_EXTRACT        per,
					per_all_vacancies@MXDM_NVIS_EXTRACT       pav,
					hz_parties@MXDM_NVIS_EXTRACT              par,
					per_all_people_f@MXDM_NVIS_EXTRACT        papf,
					irc_rec_team_members@MXDM_NVIS_EXTRACT    rec
			WHERE
					par.party_id = papf.party_id
			AND     party_type = 'PERSON'
			AND 	per.requisition_id = pav.requisition_id
			AND 	rec.party_id = par.party_id
			AND 	rec.vacancy_id = pav.vacancy_id
            AND NOT  exists (SELECT
					        papf.employee_number
					FROM
							xxmx_hcm_irec_jr_hire_team_stg xrec

					WHERE
							papf.EMPLOYEE_NUMBER = xrec.person_number
							  )
			AND papf.business_Group_id = p_bg_id
			AND trunc(sysdate) BETWEEN papf.effective_start_date AND papf.effective_end_date;


--        and ppf.effective_Start_date  IN ( Select max(papf1.effective_start_date)
--                                            FROM 	per_all_people_f@MXDM_NVIS_EXTRACT   papf1
--                                            WHERE   ppf.person_id = papf1.person_id
--                                            AND(
--                                                (  trunc(papf1.effective_start_Date) BETWEEN trunc(gvd_migration_Date_From) and trunc(gvd_migration_Date_to)
--                                                    OR trunc(papf1.effective_end_Date) BETWEEN trunc(gvd_migration_Date_From) and trunc(gvd_migration_Date_to)
--                                                )
--
--                                                OR
--                                                ( trunc(gvd_migration_Date_From) BETWEEN trunc(papf1.effective_start_Date) AND trunc(papf1.effective_end_Date)
--                                                OR trunc(gvd_migration_Date_to) BETWEEN trunc(papf1.effective_start_Date) AND trunc(papf1.effective_end_Date))
--                                                )
--                                            );


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
	END export_irec_jR_hiring_team;

--JR Posting Details
PROCEDURE export_irec_jR_posting_detail
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          number
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE )  IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_irec_jR_posting_detail';
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_HCM_IREC_JR_POST_DET_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'JR_POSTING_DETAIL';

        lvv_migration_date_to                           VARCHAR2(30);
        lvv_migration_date_from                         VARCHAR2(30);
        lvv_prev_tax_year_date                          VARCHAR2(30);
        lvd_migration_date_to                           DATE;
        lvd_migration_date_from                         DATE;
        lvd_prev_tax_year_date                          DATE;

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
        FROM    XXMX_HCM_IREC_JR_POST_DET_STG
        ;

        COMMIT;

		INSERT
        INTO    XXMX_HCM_IREC_JR_POST_DET_STG
               (
				   FILE_SET_ID			,
				   MIGRATION_SET_ID 	,
				   MIGRATION_SET_NAME 	,
				   MIGRATION_STATUS	    ,
				   BG_NAME   			,
				   BG_ID            	,
				   METADATA			    ,
				   OBJECTNAME			,
				   --
				   PUBLISHED_JOB_ID     ,
				   EXTERNAL_OR_INTERNAL ,
				   REQUISITION_NUMBER	,
				   REQUISITION_ID       ,
				   END_DATE				,
				   START_DATE			,
				   POSTING_STATUS		,
                   ATTRIBUTE_CATEGORY 	,
                    ATTRIBUTE1 			,
                    ATTRIBUTE2 			,
                    ATTRIBUTE3 			,
                    ATTRIBUTE4 			,
                    ATTRIBUTE5 			,
                    ATTRIBUTE6 			,
                    ATTRIBUTE7 			,
                    ATTRIBUTE8 			,
                    ATTRIBUTE9 			,
                    ATTRIBUTE10 		,
                    ATTRIBUTE_NUMBER1 	,
                    ATTRIBUTE_NUMBER2 	,
                    ATTRIBUTE_NUMBER3 	,
                    ATTRIBUTE_NUMBER4 	,
                    ATTRIBUTE_NUMBER5 	,
                    ATTRIBUTE_DATE1 	,
                    ATTRIBUTE_DATE2 	,
                    ATTRIBUTE_DATE3 	,
                    ATTRIBUTE_DATE4 	,
                    ATTRIBUTE_DATE5

			   )
			   SELECT
               NULL,
				pt_i_MigrationSetID  ,
				pt_i_MigrationSetName,
				'EXTRACTED'          ,
		        p_bg_name            ,
				p_bg_id              ,
                'MERGE'              ,
                'JR_POSTING_DETAIL'    ,
				NULL AS PUBLISHED_JOB_ID,
				NULL AS external_or_internal,
				'REQ' || per.requisition_id AS requisition_number,
                NULL AS REQUISITION_ID,
				NULL AS end_date,
				SYSDATE start_date,
					(
					CASE
						WHEN sysdate BETWEEN per.date_from AND per.date_to THEN
							'POSTED'
						WHEN per.date_to IS NULL THEN
							'POSTED'
						ELSE
							'EXPIRED'
					END
				)as POSTING_STATUS,
                NULL AS	ATTRIBUTE_CATEGORY ,
                NULL AS	ATTRIBUTE1         ,
                NULL AS	ATTRIBUTE2         ,
                NULL AS	ATTRIBUTE3         ,
                NULL AS	ATTRIBUTE4         ,
                NULL AS	ATTRIBUTE5         ,
                NULL AS	ATTRIBUTE6         ,
                NULL AS	ATTRIBUTE7         ,
                NULL AS	ATTRIBUTE8         ,
                NULL AS	ATTRIBUTE9         ,
                NULL AS	ATTRIBUTE10        ,
                NULL AS	ATTRIBUTE_NUMBER1  ,
                NULL AS	ATTRIBUTE_NUMBER2  ,
                NULL AS	ATTRIBUTE_NUMBER3  ,
                NULL AS	ATTRIBUTE_NUMBER4  ,
                NULL AS	ATTRIBUTE_NUMBER5  ,
                NULL AS	ATTRIBUTE_DATE1    ,
                NULL AS	ATTRIBUTE_DATE2    ,
                NULL AS	ATTRIBUTE_DATE3    ,
                NULL AS	ATTRIBUTE_DATE4    ,
                NULL AS	ATTRIBUTE_DATE5

				FROM
					per_requisitions@MXDM_NVIS_EXTRACT per
               ,per_all_vacancies@MXDM_NVIS_EXTRACT   pav
            where per.requisition_id = pav.requisition_id
            and pav.business_group_id = p_bg_id;

--        and ppf.effective_Start_date  IN ( Select max(papf1.effective_start_date)
--                                            FROM 	per_all_people_f@MXDM_NVIS_EXTRACT   papf1
--                                            WHERE   ppf.person_id = papf1.person_id
--                                            AND(
--                                                (  trunc(papf1.effective_start_Date) BETWEEN trunc(gvd_migration_Date_From) and trunc(gvd_migration_Date_to)
--                                                    OR trunc(papf1.effective_end_Date) BETWEEN trunc(gvd_migration_Date_From) and trunc(gvd_migration_Date_to)
--                                                )
--
--                                                OR
--                                                ( trunc(gvd_migration_Date_From) BETWEEN trunc(papf1.effective_start_Date) AND trunc(papf1.effective_end_Date)
--                                                OR trunc(gvd_migration_Date_to) BETWEEN trunc(papf1.effective_start_Date) AND trunc(papf1.effective_end_Date))
--                                                )
--                                            );


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
	END export_irec_jR_posting_detail;

END xxmx_irec_job_requisition_stg;

/
