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
--** FILENAME  :  xxmx_validate_code_comb_cvr_pkg.sql
--**
--** FILEPATH  :  $XXV1_TOP/install/sql
--**
--** VERSION   :  1.0
--**
--** EXECUTE
--** IN SCHEMA :  XXMX_CORE
--**
--** AUTHORS   :  Soundarya Kamatagi
--**
--** PURPOSE   :   This script validate the code combination against CVR for all the entities during
--**               Data Migration.
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
--** 1.0     20/07/2023   Soundarya Kamatagi        Initial Build
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
create or replace PACKAGE xxmx_validate_code_comb_cvr_pkg
AS
     PROCEDURE gl_code_comb_cvr (
        p_xfm_tbl IN              varchar2,
        x_status      OUT varchar2);
        
        PROCEDURE tot_count (
        p_xfm_tbl IN varchar2,
        x_count      OUT number,
        x_status      OUT varchar2);
        
        PROCEDURE acct_combination (p_xfm_tbl IN varchar2,
        p_cur      OUT sys_refcursor,
        x_status      OUT varchar2,
        p_var_skip     IN number);
     --
     --
     --
     --
END xxmx_validate_code_comb_cvr_pkg ;
/

/

----------------*******************************************-------------------------------------------------------------------------
create or replace PACKAGE BODY xxmx_validate_code_comb_cvr_pkg
AS
        PROCEDURE gl_code_comb_cvr ( p_xfm_tbl IN varchar2,
        x_status OUT varchar2 ) IS          
        --
        --
        --**********************
        --** CURSOR Declarations
        --**********************
        --
        --<<Cursor to get the detail ??>>
        --
        CURSOR  get_code_comb_cur        IS
                select 1  S_NO            ,
                        xfm_table          , --xfm_table
                        xfm_table_column   , --xfm_table_column
                        gl_acccount_desc   , --gl_acccount_desc
                        segment1           , -- FUSION_SEGMENT1
                        segment2           , -- FUSION_SEGMENT2
                        segment3           , -- FUSION_SEGMENT3
                        segment4           , -- FUSION_SEGMENT4
                        segment5           , -- FUSION_SEGMENT5
                        segment6           , -- FUSION_SEGMENT6
                        segment7           , -- FUSION_SEGMENT7
                        segment8           , -- FUSION_SEGMENT8
                        segment9           , -- FUSION_SEGMENT9
                        --'' segment10     , 
                        status             ,   --status 
                        --'' error_code    ,
                        --'' error_message ,
                        creation_date      ,   --creation_date
                        last_update_date   ,   --last_update_date
                        --'' future1       ,
                        --'' future2       ,
                        --'' future3       ,
                        ledger_name            --ledger_name
                from
                        (
                                SELECT
                                        'XXMX_GL_OPENING_BALANCES_XFM' xfm_table ,
                                        'GL_CODE_COMBINATIONS' xfm_table_column  ,
                                        'GL_CODE_COMBINATIONS' gl_acccount_desc  ,
                                        a.segment1 segment1                      ,
                                        a.segment2 segment2                      ,
                                        a.segment3 segment3                      ,
                                        a.segment4 segment4                      ,
                                        a.segment5 segment5                      ,
                                        a.segment6 segment6                      ,
                                        a.segment7 segment7                      ,
										a.segment8 segment8                      ,
										a.segment9 segment9                      ,
                                        'NEW' status                             ,
                                        sysdate creation_date                    ,
                                        sysdate last_update_date                 ,
                                        a.ledger_name ledger_name
                                FROM
                                        xxmx_gl_opening_balances_xfm a
                                where not exists
                                        (
                                                select
                                                        1
                                                from
                                                        XXMX_GL_ACCOUNT_TRANSFORMS xglat
                                                where
                                                        a.segment1   =xglat.FUSION_SEGMENT1
                                                and     a.segment2   =xglat.FUSION_SEGMENT2
                                                and     a.segment3   =xglat.FUSION_SEGMENT3
                                                and     a.segment4   =xglat.FUSION_SEGMENT4
                                                and     a.segment5   =xglat.FUSION_SEGMENT5
                                                and     a.segment6   =xglat.FUSION_SEGMENT6
                                                and     a.segment7   =xglat.FUSION_SEGMENT7
												and     a.segment8   =xglat.FUSION_SEGMENT8
												and     a.segment9   =xglat.FUSION_SEGMENT9
                                                and     a.ledger_name=xglat.ledger_name)
                                GROUP BY
                                        a.segment1,
                                        a.segment2,
                                        a.segment3,
                                        a.segment4,
                                        a.segment5,
                                        a.segment6,
                                        a.segment7,
										a.segment8,
                                        a.segment9,
										a.ledger_name
                                
                                UNION
                                
                                SELECT
                                        'XXMX_GL_SUMMARY_BALANCES_XFM' xfm_table ,
                                        'GL_CODE_COMBINATIONS' xfm_table_column  ,
                                        'GL_CODE_COMBINATIONS' gl_acccount_desc  ,
                                        b.segment1                               ,
                                        b.segment2                               ,
                                        b.segment3                               ,
                                        b.segment4                               ,
                                        b.segment5                               ,
                                        b.segment6                               ,
                                        b.segment7                               ,
										b.segment8                               ,
										b.segment9                               ,
                                        'NEW' status                             ,
                                        sysdate                                  ,
                                        sysdate                                  ,
                                        b.ledger_name
                                FROM
                                        xxmx_gl_summary_balances_xfm b
                                where not exists
                                        (
                                                select
                                                        1
                                                from
                                                        XXMX_GL_ACCOUNT_TRANSFORMS xglat
                                                where
                                                        b.segment1   =xglat. FUSION_SEGMENT1
                                                and     b.segment2   =xglat. FUSION_SEGMENT2
                                                and     b.segment3   =xglat. FUSION_SEGMENT3
                                                and     b.segment4   =xglat. FUSION_SEGMENT4
                                                and     b.segment5   =xglat. FUSION_SEGMENT5
                                                and     b.segment6   =xglat. FUSION_SEGMENT6
                                                and     b.segment7   =xglat. FUSION_SEGMENT7
												and     b.segment8   =xglat. FUSION_SEGMENT8
												and     b.segment9   =xglat. FUSION_SEGMENT9
                                                and     b.ledger_name=xglat.ledger_name)
                                GROUP BY
                                        b.segment1,
                                        b.segment2,
                                        b.segment3,
                                        b.segment4,
                                        b.segment5,
                                        b.segment6,
                                        b.segment7,
										b.segment8,
										b.segment9,
                                        b.ledger_name
                                
                                UNION
                                
                                SELECT
                                        'XXMX_GL_HISTORICAL_RATES_XFM' xfm_table ,
                                        'GL_CODE_COMBINATIONS' xfm_table_column  ,
                                        'GL_CODE_COMBINATIONS' gl_acccount_desc  ,
                                        a.segment1                               ,
                                        a.segment2                               ,
                                        a.segment3                               ,
                                        a.segment4                               ,
                                        a.segment5                               ,
                                        a.segment6                               ,
                                        a.segment7                               ,
										a.segment8                               ,
										a.segment9                               ,
                                        'NEW' status                             ,
                                        sysdate creation_date                    ,
                                        sysdate last_update_date                 ,
                                        a.ledger_name
                                FROM
                                        xxmx_gl_historical_rates_xfm a
                                where not exists
                                        (
                                                select
                                                        1
                                                from
                                                        XXMX_GL_ACCOUNT_TRANSFORMS xglat
                                                where
                                                        a.segment1   =xglat. FUSION_SEGMENT1
                                                and     a.segment2   =xglat. FUSION_SEGMENT2
                                                and     a.segment3   =xglat. FUSION_SEGMENT3
                                                and     a.segment4   =xglat. FUSION_SEGMENT4
                                                and     a.segment5   =xglat. FUSION_SEGMENT5
                                                and     a.segment6   =xglat. FUSION_SEGMENT6
                                                and     a.segment7   =xglat. FUSION_SEGMENT7
												and     a.segment8   =xglat. FUSION_SEGMENT8
												and     a.segment9   =xglat. FUSION_SEGMENT9
                                                and     a.ledger_name=xglat.ledger_name)
                                GROUP BY
                                        a.segment1,
                                        a.segment2,
                                        a.segment3,
                                        a.segment4,
                                        a.segment5,
                                        a.segment6,
                                        a.segment7,
										a.segment8,
										a.segment9,
                                        a.ledger_name
                                
                                UNION
                                
                                SELECT
                                        'XXMX_SCM_PO_DISTRIBUTIONS_STD_XFM' AS xfm_table ,
                                        'GL_CODE_COMBINATIONS' xfm_table_column       ,
                                        'GL_CODE_COMBINATIONS' gl_acccount_desc       ,
                                        charge_account_segment1                       ,
                                        charge_account_segment2                       ,
                                        charge_account_segment3                       ,
                                        charge_account_segment4                       ,
                                        charge_account_segment5                       ,
                                        charge_account_segment6                       ,
                                        charge_account_segment7                       ,
										charge_account_segment8                       ,
										charge_account_segment9                       ,
                                        'NEW' status                                  ,
                                        sysdate creation_date                         ,
                                        sysdate last_update_date                      ,
                                        c.ledger_name
                                FROM
                                        xxmx_scm_po_headers_std_xfm a      ,
                                        xxmx_scm_po_distributions_std_xfm b,
                                        xxmx_dm_fusion_das c
                                WHERE
                                        a.po_header_id = b.po_header_id
                                AND     a.prc_bu_name  = c.bu_name
                                AND     not exists
                                        (
                                                select
                                                        1
                                                from
                                                        XXMX_GL_ACCOUNT_TRANSFORMS xglat
                                                where
                                                        b.charge_account_segment1=xglat. FUSION_SEGMENT1
                                                and     b.charge_account_segment2=xglat. FUSION_SEGMENT2
                                                and     b.charge_account_segment3=xglat. FUSION_SEGMENT3
                                                and     b.charge_account_segment4=xglat. FUSION_SEGMENT4
                                                and     b.charge_account_segment5=xglat. FUSION_SEGMENT5
                                                and     b.charge_account_segment6=xglat. FUSION_SEGMENT6
                                                and     b.charge_account_segment7=xglat. FUSION_SEGMENT7
												and     b.charge_account_segment8=xglat. FUSION_SEGMENT8
												and     b.charge_account_segment9=xglat. FUSION_SEGMENT9
                                                and     c.ledger_name            =xglat.ledger_name)
                                GROUP BY
                                        charge_account_segment1,
                                        charge_account_segment2,
                                        charge_account_segment3,
                                        charge_account_segment4,
                                        charge_account_segment5,
                                        charge_account_segment6,
                                        charge_account_segment7,
										charge_account_segment8,
										charge_account_segment9,
                                        c.ledger_name
                                
                                UNION
                                
                                select
                                        *
                                from
                                        (
                                                select
                                                        'XXMX_AP_SUPP_SITE_ASSIGNS_XFM' xfm_table                                                                                                                     ,
                                                        'LIABILITY_DISTRIBUTION' xfm_table_column                                                                                                                     ,
                                                        'GL_CODE_COMBINATIONS' gl_acccount_desc                                                                                                                       ,
                                                        substr(LIABILITY_DISTRIBUTION,1,instr(LIABILITY_DISTRIBUTION,'.',1,1)-1) segment1                                                                             ,
                                                        substr(LIABILITY_DISTRIBUTION,instr(LIABILITY_DISTRIBUTION,'.',1,1)+1,instr(LIABILITY_DISTRIBUTION,'.',1,2)-instr(LIABILITY_DISTRIBUTION,'.',1,1)-1) segment2 ,
                                                        substr(LIABILITY_DISTRIBUTION,instr(LIABILITY_DISTRIBUTION,'.',1,2)+1,instr(LIABILITY_DISTRIBUTION,'.',1,3)-instr(LIABILITY_DISTRIBUTION,'.',1,2)-1) segment3 ,
                                                        substr(LIABILITY_DISTRIBUTION,instr(LIABILITY_DISTRIBUTION,'.',1,3)+1,instr(LIABILITY_DISTRIBUTION,'.',1,4)-instr(LIABILITY_DISTRIBUTION,'.',1,3)-1) segment4 ,
                                                        substr(LIABILITY_DISTRIBUTION,instr(LIABILITY_DISTRIBUTION,'.',1,4)+1,instr(LIABILITY_DISTRIBUTION,'.',1,5)-instr(LIABILITY_DISTRIBUTION,'.',1,4)-1) segment5 ,
                                                        substr(LIABILITY_DISTRIBUTION,instr(LIABILITY_DISTRIBUTION,'.',1,5)+1,instr(LIABILITY_DISTRIBUTION,'.',1,6)-instr(LIABILITY_DISTRIBUTION,'.',1,5)-1) segment6 ,
                                                        substr(LIABILITY_DISTRIBUTION,instr(LIABILITY_DISTRIBUTION,'.',1,6)+1,instr(LIABILITY_DISTRIBUTION,'.',1,7)-instr(LIABILITY_DISTRIBUTION,'.',1,6)-1) segment7 ,
												        substr(LIABILITY_DISTRIBUTION,instr(LIABILITY_DISTRIBUTION,'.',1,7)+1,instr(LIABILITY_DISTRIBUTION,'.',1,8)-instr(LIABILITY_DISTRIBUTION,'.',1,7)-1) segment8 ,
                                                        substr(LIABILITY_DISTRIBUTION,instr(LIABILITY_DISTRIBUTION,'.',1,8)+1) segment9                                                                               , 														
                                                        'NEW' status                                                                                                                                                  ,
                                                        sysdate creation_date                                                                                                                                         ,
                                                        sysdate last_update_date                                                                                                                                      ,
                                                        c.ledger_name
                                                from
                                                        xxmx_ap_supp_site_assigns_xfm a,
                                                        xxmx_dm_fusion_das c
                                                where
                                                        a.procurement_bu = c.bu_name
                                                GROUP BY
                                                        LIABILITY_DISTRIBUTION,
                                                        c.ledger_name) d
                                where not exists
                                        (
                                                select
                                                        1
                                                from
                                                        XXMX_GL_ACCOUNT_TRANSFORMS xglat
                                                where
                                                        d.segment1   =xglat. FUSION_SEGMENT1
                                                and     d.segment2   =xglat. FUSION_SEGMENT2
                                                and     d.segment3   =xglat. FUSION_SEGMENT3
                                                and     d.segment4   =xglat. FUSION_SEGMENT4
                                                and     d.segment5   =xglat. FUSION_SEGMENT5
                                                and     d.segment6   =xglat. FUSION_SEGMENT6
                                                and     d.segment7   =xglat. FUSION_SEGMENT7
												and     d.segment8   =xglat. FUSION_SEGMENT8
												and     d.segment9   =xglat. FUSION_SEGMENT9
                                                and     d.ledger_name=xglat.ledger_name)
                                
                                UNION
                                
                                select
                                        *
                                from
                                        (
                                                select
                                                        'XXMX_AP_SUPP_SITE_ASSIGNS_XFM' xfm_table                                                                                                                         ,
                                                        'PREPAYMENT_DISTRIBUTION' xfm_table_column                                                                                                                        ,
                                                        'GL_CODE_COMBINATIONS' gl_acccount_desc                                                                                                                           ,
                                                        substr(PREPAYMENT_DISTRIBUTION,1,instr(PREPAYMENT_DISTRIBUTION,'.',1,1)-1) segment1                                                                               ,
                                                        substr(PREPAYMENT_DISTRIBUTION,instr(PREPAYMENT_DISTRIBUTION,'.',1,1)+1,instr(PREPAYMENT_DISTRIBUTION,'.',1,2)-instr(PREPAYMENT_DISTRIBUTION,'.',1,1)-1) segment2 ,
                                                        substr(PREPAYMENT_DISTRIBUTION,instr(PREPAYMENT_DISTRIBUTION,'.',1,2)+1,instr(PREPAYMENT_DISTRIBUTION,'.',1,3)-instr(PREPAYMENT_DISTRIBUTION,'.',1,2)-1) segment3 ,
                                                        substr(PREPAYMENT_DISTRIBUTION,instr(PREPAYMENT_DISTRIBUTION,'.',1,3)+1,instr(PREPAYMENT_DISTRIBUTION,'.',1,4)-instr(PREPAYMENT_DISTRIBUTION,'.',1,3)-1) segment4 ,
                                                        substr(PREPAYMENT_DISTRIBUTION,instr(PREPAYMENT_DISTRIBUTION,'.',1,4)+1,instr(PREPAYMENT_DISTRIBUTION,'.',1,5)-instr(PREPAYMENT_DISTRIBUTION,'.',1,4)-1) segment5 ,
                                                        substr(PREPAYMENT_DISTRIBUTION,instr(PREPAYMENT_DISTRIBUTION,'.',1,5)+1,instr(PREPAYMENT_DISTRIBUTION,'.',1,6)-instr(PREPAYMENT_DISTRIBUTION,'.',1,5)-1) segment6 ,
                                                        substr(PREPAYMENT_DISTRIBUTION,instr(PREPAYMENT_DISTRIBUTION,'.',1,6)+1,instr(PREPAYMENT_DISTRIBUTION,'.',1,7)-instr(PREPAYMENT_DISTRIBUTION,'.',1,6)-1) segment7 ,
														substr(PREPAYMENT_DISTRIBUTION,instr(PREPAYMENT_DISTRIBUTION,'.',1,7)+1,instr(PREPAYMENT_DISTRIBUTION,'.',1,8)-instr(PREPAYMENT_DISTRIBUTION,'.',1,7)-1) segment8 ,
														substr(PREPAYMENT_DISTRIBUTION,instr(PREPAYMENT_DISTRIBUTION,'.',1,8)+1) segment9                                                                                   ,
                                                        'NEW' status                                                                                                                                                      ,
                                                        sysdate creation_date                                                                                                                                             ,
                                                        sysdate last_update_date                                                                                                                                          ,
                                                        c.ledger_name                                                                                                                                      
                                                from
                                                        xxmx_ap_supp_site_assigns_xfm a,
                                                        xxmx_dm_fusion_das c
                                                where
                                                        a.procurement_bu = c.bu_name
                                                GROUP BY
                                                        PREPAYMENT_DISTRIBUTION,
                                                        c.ledger_name ) d
                                where not exists
                                        (
                                                select
                                                        1
                                                from
                                                        XXMX_GL_ACCOUNT_TRANSFORMS xglat
                                                where
                                                        d.segment1   =xglat. FUSION_SEGMENT1
                                                and     d.segment2   =xglat. FUSION_SEGMENT2
                                                and     d.segment3   =xglat. FUSION_SEGMENT3
                                                and     d.segment4   =xglat. FUSION_SEGMENT4
                                                and     d.segment5   =xglat. FUSION_SEGMENT5
                                                and     d.segment6   =xglat. FUSION_SEGMENT6
                                                and     d.segment7   =xglat. FUSION_SEGMENT7
												and     d.segment8   =xglat. FUSION_SEGMENT8
												and     d.segment9   =xglat. FUSION_SEGMENT9
                                                and     d.ledger_name=xglat.ledger_name)
                                
                                UNION
                                
                                select
                                        *
                                from
                                        (
                                                select
                                                        'XXMX_FA_MASS_ADDITIONS_XFM' xfm_table ,
                                                        'GL_CODE_COMBINATIONS' xfm_table_column,
                                                        'GL_CODE_COMBINATIONS' gl_acccount_desc,
                                                        CLEARING_ACCT_SEGMENT1 segment1        ,
                                                        CLEARING_ACCT_SEGMENT2 segment2        ,
                                                        CLEARING_ACCT_SEGMENT3 segment3        ,
                                                        CLEARING_ACCT_SEGMENT4 segment4        ,
                                                        CLEARING_ACCT_SEGMENT5 segment5        ,
                                                        CLEARING_ACCT_SEGMENT6 segment6        ,
                                                        CLEARING_ACCT_SEGMENT7 segment7        ,
														CLEARING_ACCT_SEGMENT8 segment8        ,
														CLEARING_ACCT_SEGMENT9 segment9        ,
                                                        'NEW' status                           ,
                                                        sysdate creation_date                  ,
                                                        sysdate last_update_date               ,
                                                        b.name ledger_name
                                                from
                                                        xxmx_fa_mass_additions_xfm a,
                                                        xxmx_dm_asset_books_in_scope b
                                                where
                                                        a.book_type_code=b.book_type_code
                                                group by
                                                        CLEARING_ACCT_SEGMENT1,
                                                        CLEARING_ACCT_SEGMENT2,
                                                        CLEARING_ACCT_SEGMENT3,
                                                        CLEARING_ACCT_SEGMENT4,
                                                        CLEARING_ACCT_SEGMENT5,
                                                        CLEARING_ACCT_SEGMENT6,
                                                        CLEARING_ACCT_SEGMENT7,
														CLEARING_ACCT_SEGMENT8,
														CLEARING_ACCT_SEGMENT9,
                                                        b.name) d
                                where not exists
                                        (
                                                select
                                                        1
                                                from
                                                        XXMX_GL_ACCOUNT_TRANSFORMS xglat
                                                where
                                                        d.segment1   =xglat. FUSION_SEGMENT1
                                                and     d.segment2   =xglat. FUSION_SEGMENT2
                                                and     d.segment3   =xglat. FUSION_SEGMENT3
                                                and     d.segment4   =xglat. FUSION_SEGMENT4
                                                and     d.segment5   =xglat. FUSION_SEGMENT5
                                                and     d.segment6   =xglat. FUSION_SEGMENT6
                                                and     d.segment7   =xglat. FUSION_SEGMENT7
												and     d.segment8   =xglat. FUSION_SEGMENT8
												and     d.segment9   =xglat. FUSION_SEGMENT9
                                                and     d.ledger_name=xglat.ledger_name)
                                
                                UNION
                                
                                select
                                        *
                                from
                                        (
                                                select
                                                        'XXMX_PPM_PRJ_LBRCOST_XFM' xfm_table                                                                                                              ,
                                                        'RAW_COST_CR_ACCOUNT' xfm_table_column                                                                                                            ,
                                                        'GL_CODE_COMBINATIONS' gl_acccount_desc                                                                                                           ,
                                                        substr(RAW_COST_CR_ACCOUNT,1,instr(RAW_COST_CR_ACCOUNT,'.',1,1)-1) segment1                                                                       ,
                                                        substr(RAW_COST_CR_ACCOUNT,instr(RAW_COST_CR_ACCOUNT,'.',1,1)+1,instr(RAW_COST_CR_ACCOUNT,'.',1,2)-instr(RAW_COST_CR_ACCOUNT,'.',1,1)-1) segment2 ,
                                                        substr(RAW_COST_CR_ACCOUNT,instr(RAW_COST_CR_ACCOUNT,'.',1,2)+1,instr(RAW_COST_CR_ACCOUNT,'.',1,3)-instr(RAW_COST_CR_ACCOUNT,'.',1,2)-1) segment3 ,
                                                        substr(RAW_COST_CR_ACCOUNT,instr(RAW_COST_CR_ACCOUNT,'.',1,3)+1,instr(RAW_COST_CR_ACCOUNT,'.',1,4)-instr(RAW_COST_CR_ACCOUNT,'.',1,3)-1) segment4 ,
                                                        substr(RAW_COST_CR_ACCOUNT,instr(RAW_COST_CR_ACCOUNT,'.',1,4)+1,instr(RAW_COST_CR_ACCOUNT,'.',1,5)-instr(RAW_COST_CR_ACCOUNT,'.',1,4)-1) segment5 ,
                                                        substr(RAW_COST_CR_ACCOUNT,instr(RAW_COST_CR_ACCOUNT,'.',1,5)+1,instr(RAW_COST_CR_ACCOUNT,'.',1,6)-instr(RAW_COST_CR_ACCOUNT,'.',1,5)-1) segment6 ,
                                                        substr(RAW_COST_CR_ACCOUNT,instr(RAW_COST_CR_ACCOUNT,'.',1,6)+1,instr(RAW_COST_CR_ACCOUNT,'.',1,7)-instr(RAW_COST_CR_ACCOUNT,'.',1,6)-1) segment7 ,
														substr(RAW_COST_CR_ACCOUNT,instr(RAW_COST_CR_ACCOUNT,'.',1,7)+1,instr(RAW_COST_CR_ACCOUNT,'.',1,8)-instr(RAW_COST_CR_ACCOUNT,'.',1,7)-1) segment8 ,
														substr(RAW_COST_CR_ACCOUNT,instr(RAW_COST_CR_ACCOUNT,'.',1,8)+1) segment9                                                                         ,
                                                        'NEW' status                                                                                                                                      ,
                                                        sysdate creation_date                                                                                                                             ,
                                                        sysdate last_update_date                                                                                                                          ,
                                                        c.ledger_name
                                                from
                                                        xxmx_ppm_prj_lbrcost_xfm a ,
                                                        xxmx_dm_fusion_das c
                                                where
                                                        a.business_unit = c.bu_name
                                                GROUP BY
                                                        RAW_COST_CR_ACCOUNT,
                                                        c.ledger_name) d
                                where not exists
                                        (
                                                select
                                                        1
                                                from
                                                        XXMX_GL_ACCOUNT_TRANSFORMS xglat
                                                where
                                                        d.segment1   =xglat. FUSION_SEGMENT1
                                                and     d.segment2   =xglat. FUSION_SEGMENT2
                                                and     d.segment3   =xglat. FUSION_SEGMENT3
                                                and     d.segment4   =xglat. FUSION_SEGMENT4
                                                and     d.segment5   =xglat. FUSION_SEGMENT5
                                                and     d.segment6   =xglat. FUSION_SEGMENT6
                                                and     d.segment7   =xglat. FUSION_SEGMENT7
												and     d.segment8   =xglat. FUSION_SEGMENT8
												and     d.segment9   =xglat. FUSION_SEGMENT9
                                                and     d.ledger_name=xglat.ledger_name)
                                
                                UNION
                                
                                select
                                        *
                                from
                                        (
                                                select
                                                        'XXMX_PPM_PRJ_LBRCOST_XFM' xfm_table                                                                                                              ,
                                                        'RAW_COST_DR_ACCOUNT' xfm_table_column                                                                                                            ,
                                                        'GL_CODE_COMBINATIONS' gl_acccount_desc                                                                                                           ,
                                                        substr(RAW_COST_DR_ACCOUNT,1,instr(RAW_COST_DR_ACCOUNT,'.',1,1)-1) segment1                                                                       ,
                                                        substr(RAW_COST_DR_ACCOUNT,instr(RAW_COST_DR_ACCOUNT,'.',1,1)+1,instr(RAW_COST_DR_ACCOUNT,'.',1,2)-instr(RAW_COST_DR_ACCOUNT,'.',1,1)-1) segment2 ,
                                                        substr(RAW_COST_DR_ACCOUNT,instr(RAW_COST_DR_ACCOUNT,'.',1,2)+1,instr(RAW_COST_DR_ACCOUNT,'.',1,3)-instr(RAW_COST_DR_ACCOUNT,'.',1,2)-1) segment3 ,
                                                        substr(RAW_COST_DR_ACCOUNT,instr(RAW_COST_DR_ACCOUNT,'.',1,3)+1,instr(RAW_COST_DR_ACCOUNT,'.',1,4)-instr(RAW_COST_DR_ACCOUNT,'.',1,3)-1) segment4 ,
                                                        substr(RAW_COST_DR_ACCOUNT,instr(RAW_COST_DR_ACCOUNT,'.',1,4)+1,instr(RAW_COST_DR_ACCOUNT,'.',1,5)-instr(RAW_COST_DR_ACCOUNT,'.',1,4)-1) segment5 ,
                                                        substr(RAW_COST_DR_ACCOUNT,instr(RAW_COST_DR_ACCOUNT,'.',1,5)+1,instr(RAW_COST_DR_ACCOUNT,'.',1,6)-instr(RAW_COST_DR_ACCOUNT,'.',1,5)-1) segment6 ,
                                                        substr(RAW_COST_DR_ACCOUNT,instr(RAW_COST_DR_ACCOUNT,'.',1,6)+1,instr(RAW_COST_DR_ACCOUNT,'.',1,7)-instr(RAW_COST_DR_ACCOUNT,'.',1,6)-1) segment7 ,
														substr(RAW_COST_DR_ACCOUNT,instr(RAW_COST_DR_ACCOUNT,'.',1,7)+1,instr(RAW_COST_DR_ACCOUNT,'.',1,8)-instr(RAW_COST_DR_ACCOUNT,'.',1,8)-1) segment8 ,
														substr(RAW_COST_DR_ACCOUNT,instr(RAW_COST_DR_ACCOUNT,'.',1,8)+1)                                                                         segment9 ,
                                                        'NEW' status                                                                                                                                      ,
                                                        sysdate creation_date                                                                                                                             ,
                                                        sysdate last_update_date                                                                                                                          ,
                                                        c.ledger_name
                                                from
                                                        xxmx_ppm_prj_lbrcost_xfm a ,
                                                        xxmx_dm_fusion_das c
                                                where
                                                        a.business_unit = c.bu_name
                                                GROUP BY
                                                        RAW_COST_DR_ACCOUNT,
                                                        c.ledger_name ) d
                                where not exists
                                        (
                                                select
                                                        1
                                                from
                                                        XXMX_GL_ACCOUNT_TRANSFORMS xglat
                                                where
                                                        d.segment1   =xglat. FUSION_SEGMENT1
                                                and     d.segment2   =xglat. FUSION_SEGMENT2
                                                and     d.segment3   =xglat. FUSION_SEGMENT3
                                                and     d.segment4   =xglat. FUSION_SEGMENT4
                                                and     d.segment5   =xglat. FUSION_SEGMENT5
                                                and     d.segment6   =xglat. FUSION_SEGMENT6
                                                and     d.segment7   =xglat. FUSION_SEGMENT7
												and     d.segment8   =xglat. FUSION_SEGMENT8
												and     d.segment9   =xglat. FUSION_SEGMENT9
                                                and     d.ledger_name=xglat.ledger_name)
                                
                                UNION
                                
                                select
                                        *
                                from
                                        (
                                                select
                                                        'XXMX_PPM_PRJ_MISCCOST_XFM' xfm_table                                                                                                             ,
                                                        'RAW_COST_DR_ACCOUNT' xfm_table_column                                                                                                            ,
                                                        'GL_CODE_COMBINATIONS' gl_acccount_desc                                                                                                           ,
                                                        substr(RAW_COST_DR_ACCOUNT,1,instr(RAW_COST_DR_ACCOUNT,'.',1,1)-1) segment1                                                                       ,
                                                        substr(RAW_COST_DR_ACCOUNT,instr(RAW_COST_DR_ACCOUNT,'.',1,1)+1,instr(RAW_COST_DR_ACCOUNT,'.',1,2)-instr(RAW_COST_DR_ACCOUNT,'.',1,1)-1) segment2 ,
                                                        substr(RAW_COST_DR_ACCOUNT,instr(RAW_COST_DR_ACCOUNT,'.',1,2)+1,instr(RAW_COST_DR_ACCOUNT,'.',1,3)-instr(RAW_COST_DR_ACCOUNT,'.',1,2)-1) segment3 ,
                                                        substr(RAW_COST_DR_ACCOUNT,instr(RAW_COST_DR_ACCOUNT,'.',1,3)+1,instr(RAW_COST_DR_ACCOUNT,'.',1,4)-instr(RAW_COST_DR_ACCOUNT,'.',1,3)-1) segment4 ,
                                                        substr(RAW_COST_DR_ACCOUNT,instr(RAW_COST_DR_ACCOUNT,'.',1,4)+1,instr(RAW_COST_DR_ACCOUNT,'.',1,5)-instr(RAW_COST_DR_ACCOUNT,'.',1,4)-1) segment5 ,
                                                        substr(RAW_COST_DR_ACCOUNT,instr(RAW_COST_DR_ACCOUNT,'.',1,5)+1,instr(RAW_COST_DR_ACCOUNT,'.',1,6)-instr(RAW_COST_DR_ACCOUNT,'.',1,5)-1) segment6 ,
                                                        substr(RAW_COST_DR_ACCOUNT,instr(RAW_COST_DR_ACCOUNT,'.',1,6)+1,instr(RAW_COST_DR_ACCOUNT,'.',1,7)-instr(RAW_COST_DR_ACCOUNT,'.',1,6)-1) segment7 ,
														substr(RAW_COST_DR_ACCOUNT,instr(RAW_COST_DR_ACCOUNT,'.',1,7)+1,instr(RAW_COST_DR_ACCOUNT,'.',1,8)-instr(RAW_COST_DR_ACCOUNT,'.',1,7)-1) segment8 ,
														substr(RAW_COST_DR_ACCOUNT,instr(RAW_COST_DR_ACCOUNT,'.',1,8)+1) segment9                                                                         ,
                                                        'NEW' status                                                                                                                                      ,
                                                        sysdate creation_date                                                                                                                             ,
                                                        sysdate last_update_date                                                                                                                          ,
                                                        c.ledger_name
                                                from
                                                        xxmx_ppm_prj_misccost_xfm a ,
                                                        xxmx_dm_fusion_das c
                                                where
                                                        a.business_unit = c.bu_name
                                                GROUP BY
                                                        RAW_COST_DR_ACCOUNT,
                                                        c.ledger_name ) d
                                where not exists
                                        (
                                                select
                                                        1
                                                from
                                                        XXMX_GL_ACCOUNT_TRANSFORMS xglat
                                                where
                                                        d.segment1   =xglat. FUSION_SEGMENT1
                                                and     d.segment2   =xglat. FUSION_SEGMENT2
                                                and     d.segment3   =xglat. FUSION_SEGMENT3
                                                and     d.segment4   =xglat. FUSION_SEGMENT4
                                                and     d.segment5   =xglat. FUSION_SEGMENT5
                                                and     d.segment6   =xglat. FUSION_SEGMENT6
                                                and     d.segment7   =xglat. FUSION_SEGMENT7
												and     d.segment8   =xglat. FUSION_SEGMENT8
												and     d.segment9   =xglat. FUSION_SEGMENT9
                                                and     d.ledger_name=xglat.ledger_name)
                                
                                UNION
                                
                                select
                                        *
                                from
                                        (
                                                Select
                                                        'XXMX_PPM_PRJ_MISCCOST_XFM' xfm_table                                                                                                             ,
                                                        'RAW_COST_CR_ACCOUNT' xfm_table_column                                                                                                            ,
                                                        'GL_CODE_COMBINATIONS' gl_acccount_desc                                                                                                           ,
                                                        substr(RAW_COST_CR_ACCOUNT,1,instr(RAW_COST_CR_ACCOUNT,'.',1,1)-1) segment1                                                                       ,
                                                        substr(RAW_COST_CR_ACCOUNT,instr(RAW_COST_CR_ACCOUNT,'.',1,1)+1,instr(RAW_COST_CR_ACCOUNT,'.',1,2)-instr(RAW_COST_CR_ACCOUNT,'.',1,1)-1) segment2 ,
                                                        substr(RAW_COST_CR_ACCOUNT,instr(RAW_COST_CR_ACCOUNT,'.',1,2)+1,instr(RAW_COST_CR_ACCOUNT,'.',1,3)-instr(RAW_COST_CR_ACCOUNT,'.',1,2)-1) segment3 ,
                                                        substr(RAW_COST_CR_ACCOUNT,instr(RAW_COST_CR_ACCOUNT,'.',1,3)+1,instr(RAW_COST_CR_ACCOUNT,'.',1,4)-instr(RAW_COST_CR_ACCOUNT,'.',1,3)-1) segment4 ,
                                                        substr(RAW_COST_CR_ACCOUNT,instr(RAW_COST_CR_ACCOUNT,'.',1,4)+1,instr(RAW_COST_CR_ACCOUNT,'.',1,5)-instr(RAW_COST_CR_ACCOUNT,'.',1,4)-1) segment5 ,
                                                        substr(RAW_COST_CR_ACCOUNT,instr(RAW_COST_CR_ACCOUNT,'.',1,5)+1,instr(RAW_COST_CR_ACCOUNT,'.',1,6)-instr(RAW_COST_CR_ACCOUNT,'.',1,5)-1) segment6 ,
                                                        substr(RAW_COST_CR_ACCOUNT,instr(RAW_COST_CR_ACCOUNT,'.',1,6)+1,instr(RAW_COST_CR_ACCOUNT,'.',1,7)-instr(RAW_COST_CR_ACCOUNT,'.',1,6)-1) segment7 ,
														substr(RAW_COST_CR_ACCOUNT,instr(RAW_COST_CR_ACCOUNT,'.',1,7)+1,instr(RAW_COST_CR_ACCOUNT,'.',1,8)-instr(RAW_COST_CR_ACCOUNT,'.',1,7)-1) segment8 ,
														substr(RAW_COST_CR_ACCOUNT,instr(RAW_COST_CR_ACCOUNT,'.',1,8)+1) segment9                                                                         ,
														'NEW' status                                                                                                                                      ,
                                                        sysdate creation_date                                                                                                                             ,
                                                        sysdate last_update_date                                                                                                                          ,
                                                        c.ledger_name
                                                from
                                                        xxmx_ppm_prj_misccost_xfm a ,
                                                        xxmx_dm_fusion_das c
                                                where
                                                        a.business_unit = c.bu_name
                                                GROUP BY
                                                        RAW_COST_CR_ACCOUNT,
                                                        c.ledger_name) d
                                where not exists
                                        (
                                                select
                                                        1
                                                from
                                                        XXMX_GL_ACCOUNT_TRANSFORMS xglat
                                                where
                                                        d.segment1   =xglat. FUSION_SEGMENT1
                                                and     d.segment2   =xglat. FUSION_SEGMENT2
                                                and     d.segment3   =xglat. FUSION_SEGMENT3
                                                and     d.segment4   =xglat. FUSION_SEGMENT4
                                                and     d.segment5   =xglat. FUSION_SEGMENT5
                                                and     d.segment6   =xglat. FUSION_SEGMENT6
                                                and     d.segment7   =xglat. FUSION_SEGMENT7
												and     d.segment8   =xglat. FUSION_SEGMENT8
												and     d.segment9   =xglat. FUSION_SEGMENT9
                                                and     d.ledger_name=xglat.ledger_name)
                                
                                UNION
                                
                                select
                                        *
                                from
                                        (
                                                select
                                                        'XXMX_FA_MASS_ADDITION_DIST_XFM' xfm_table ,
                                                        'GL_CODE_COMBINATIONS' xfm_table_column    ,
                                                        'GL_CODE_COMBINATIONS' gl_acccount_desc    ,
                                                        c.DEPRN_EXPENSE_SEGMENT1 segment1          ,
                                                        c.DEPRN_EXPENSE_SEGMENT2 segment2          ,
                                                        c.DEPRN_EXPENSE_SEGMENT3 segment3          ,
                                                        c.DEPRN_EXPENSE_SEGMENT4 segment4          ,
                                                        c.DEPRN_EXPENSE_SEGMENT5 segment5          ,
                                                        c.DEPRN_EXPENSE_SEGMENT6 segment6          ,
                                                        c.DEPRN_EXPENSE_SEGMENT7 segment7          ,
														c.DEPRN_EXPENSE_SEGMENT7 segment8          ,
														c.DEPRN_EXPENSE_SEGMENT7 segment9          ,
                                                        'NEW' status                               ,
                                                        sysdate creation_date                      ,
                                                        sysdate last_update_date                   ,
                                                        b.name ledger_name
                                                from
                                                        xxmx_fa_mass_addition_dist_xfm c,
                                                        xxmx_dm_asset_books_in_scope b  ,
                                                        xxmx_fa_mass_additions_xfm a
                                                where
                                                        a.MASS_ADDITION_ID=c.MASS_ADDITION_ID
                                                and     a.book_type_code  =b.book_type_code
                                                group by
                                                        c.DEPRN_EXPENSE_SEGMENT1,
                                                        c.DEPRN_EXPENSE_SEGMENT2,
                                                        c.DEPRN_EXPENSE_SEGMENT3,
                                                        c.DEPRN_EXPENSE_SEGMENT4,
                                                        c.DEPRN_EXPENSE_SEGMENT5,
                                                        c.DEPRN_EXPENSE_SEGMENT6,
                                                        c.DEPRN_EXPENSE_SEGMENT7,
														c.DEPRN_EXPENSE_SEGMENT8,
														c.DEPRN_EXPENSE_SEGMENT9,
                                                        b.name) d
                                where not exists
                                        (
                                                select
                                                        1
                                                from
                                                        XXMX_GL_ACCOUNT_TRANSFORMS xglat
                                                where
                                                        d.segment1   =xglat. FUSION_SEGMENT1
                                                and     d.segment2   =xglat. FUSION_SEGMENT2
                                                and     d.segment3   =xglat. FUSION_SEGMENT3
                                                and     d.segment4   =xglat. FUSION_SEGMENT4
                                                and     d.segment5   =xglat. FUSION_SEGMENT5
                                                and     d.segment6   =xglat. FUSION_SEGMENT6
                                                and     d.segment7   =xglat. FUSION_SEGMENT7
												and     d.segment8   =xglat. FUSION_SEGMENT8
												and     d.segment9   =xglat. FUSION_SEGMENT9
                                                and     d.ledger_name=xglat.ledger_name)
                                
                                UNION
                                
                                select
                                        *
                                from
                                        (
                                                select
                                                        'XXMX_PER_ASSIGNMENTS_M_XFM' xfm_table                                                                                                                            ,
                                                        'GL_CODE_COMBINATIONS' xfm_table_column                                                                                                                           ,
                                                        'GL_CODE_COMBINATIONS' gl_acccount_desc                                                                                                                           ,
                                                        substr(default_expense_account,1,instr(default_expense_account,'.',1,1)-1) segment1                                                                               ,
                                                        substr(default_expense_account,instr(default_expense_account,'.',1,1)+1,instr(default_expense_account,'.',1,2)-instr(default_expense_account,'.',1,1)-1) segment2 ,
                                                        substr(default_expense_account,instr(default_expense_account,'.',1,2)+1,instr(default_expense_account,'.',1,3)-instr(default_expense_account,'.',1,2)-1) segment3 ,
                                                        substr(default_expense_account,instr(default_expense_account,'.',1,3)+1,instr(default_expense_account,'.',1,4)-instr(default_expense_account,'.',1,3)-1) segment4 ,
                                                        substr(default_expense_account,instr(default_expense_account,'.',1,4)+1,instr(default_expense_account,'.',1,5)-instr(default_expense_account,'.',1,4)-1) segment5 ,
                                                        substr(default_expense_account,instr(default_expense_account,'.',1,5)+1,instr(default_expense_account,'.',1,6)-instr(default_expense_account,'.',1,5)-1) segment6 ,
                                                        substr(default_expense_account,instr(default_expense_account,'.',1,6)+1,instr(default_expense_account,'.',1,7)-instr(default_expense_account,'.',1,6)-1) segment7 , 
                                                        substr(default_expense_account,instr(default_expense_account,'.',1,7)+1,instr(default_expense_account,'.',1,8)-instr(default_expense_account,'.',1,7)-1) segment8 ,	
														substr(default_expense_account,instr(default_expense_account,'.',1,8)+1) segment9                                                                                 ,
                                                        'NEW' status                                                                                                                                                      ,
                                                        sysdate creation_date                                                                                                                                             ,
                                                        sysdate last_update_date                                                                                                                                          ,
                                                        c.ledger_name
                                                from
                                                        XXMX_PER_ASSIGNMENTS_M_XFM a,
                                                        xxmx_dm_fusion_das c
                                                where
                                                        a.business_unit_name = c.bu_name
                                                and     a.default_expense_account is not null
                                                GROUP BY
                                                        default_expense_account,
                                                        c.ledger_name )d
                                where not exists
                                        (
                                                select
                                                        1
                                                from
                                                        XXMX_GL_ACCOUNT_TRANSFORMS xglat
                                                where
                                                        d.segment1   =xglat. FUSION_SEGMENT1
                                                and     d.segment2   =xglat. FUSION_SEGMENT2
                                                and     d.segment3   =xglat. FUSION_SEGMENT3
                                                and     d.segment4   =xglat. FUSION_SEGMENT4
                                                and     d.segment5   =xglat. FUSION_SEGMENT5
                                                and     d.segment6   =xglat. FUSION_SEGMENT6
                                                and     d.segment7   =xglat. FUSION_SEGMENT7
												and     d.segment8   =xglat. FUSION_SEGMENT8
												and     d.segment9   =xglat. FUSION_SEGMENT9
                                                and     d.ledger_name=xglat.ledger_name))main
                where
                        xfm_table in
                        (
                                select
                                        regexp_substr(upper(p_xfm_tbl),'[^,]+',1,level)
                                from
                                        dual
                                connect by regexp_substr(upper(p_xfm_tbl),'[^,]+',1,level) is not null)
                        OR least(p_xfm_tbl) is null;
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
                        TYPE get_code_comb_tt 
                                        IS TABLE OF get_code_comb_cur%rowtype INDEX BY BINARY_INTEGER;
                        --V_S_NO             XXMX_GL_ACCOUNT_TRANSFORMS.S_NO%type;
                        --V_xfm_table        XXMX_GL_ACCOUNT_TRANSFORMS.xfm_table%type;
                        --V_xfm_table_column XXMX_GL_ACCOUNT_TRANSFORMS.xfm_table_column%type ;
                        --V_gl_acccount_desc XXMX_GL_ACCOUNT_TRANSFORMS.gl_acccount_desc%type ;
                        --V_ FUSION_SEGMENT1  XXMX_GL_ACCOUNT_TRANSFORMS. FUSION_SEGMENT1%type  ;
                        --V_ FUSION_SEGMENT2  XXMX_GL_ACCOUNT_TRANSFORMS. FUSION_SEGMENT2%type  ;
                        --V_ FUSION_SEGMENT3  XXMX_GL_ACCOUNT_TRANSFORMS. FUSION_SEGMENT3%type  ;
                        --V_ FUSION_SEGMENT4  XXMX_GL_ACCOUNT_TRANSFORMS. FUSION_SEGMENT4%type  ;
                        --V_ FUSION_SEGMENT5  XXMX_GL_ACCOUNT_TRANSFORMS. FUSION_SEGMENT5%type  ;
                        --V_ FUSION_SEGMENT6  XXMX_GL_ACCOUNT_TRANSFORMS. FUSION_SEGMENT6%type  ;
                        --V_ FUSION_SEGMENT7  XXMX_GL_ACCOUNT_TRANSFORMS. FUSION_SEGMENT7%type  ;
                        --V_status           XXMX_GL_ACCOUNT_TRANSFORMS.status%type           ;
                        --V_creation_date    XXMX_GL_ACCOUNT_TRANSFORMS.creation_date%type    ;
                        --V_last_update_date XXMX_GL_ACCOUNT_TRANSFORMS.last_update_date%type ;
                        --V_ledger_name      XXMX_GL_ACCOUNT_TRANSFORMS.ledger_name%type      ;
                        --
                        --
                        --************************
                        --** Constant Declarations
                        --************************
                        --
                        --
                        --
                        --************************
                        --** Variable Declarations
                        --************************
                         V_APPLICATION_SUITE                XXMX_MIGRATION_METADATA.APPLICATION_SUITE%TYPE;
                         V_APPLICATION                      XXMX_MIGRATION_METADATA.APPLICATION%TYPE;
                         V_BUSINESS_ENTITY                  XXMX_MIGRATION_METADATA.BUSINESS_ENTITY%TYPE;
		                 V_SUB_ENTITY                       XXMX_MIGRATION_METADATA.SUB_ENTITY%TYPE;
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
                        get_code_comb_tbl get_code_comb_tt;
                        --
                        --
                        --*************************
                        --** Exception Declarations
                        --*************************
                        --
                        E_LOADERROR EXCEPTION;
                        --
                        --** END Declarations
                        --
                                BEGIN
                                        --
                                        --
										BEGIN 
                                         		 SELECT             APPLICATION_SUITE,
                                         		                    APPLICATION,
                                         			                BUSINESS_ENTITY,
                                         			                SUB_ENTITY
                                         			   INTO
                                                                    V_APPLICATION_SUITE,   			   
                                                                    V_APPLICATION,         
                                                                    V_BUSINESS_ENTITY,     
                                                                    V_SUB_ENTITY  
                                                 FROM         
                                                       XXMX_MIGRATION_METADATA
                                            WHERE XFM_TABLE = p_xfm_tbl;
                                          
                                         EXCEPTION
                                                     WHEN OTHERS THEN 
                                                         RAISE E_LOADERROR;
                                                 END;

                                        --
                                        OPEN get_code_comb_cur;
                                        --
                                        LOOP
                                        --
										FETCH   get_code_comb_cur
										BULK COLLECT
                                        INTO    get_code_comb_tbl
										LIMIT   xxmx_utilities_pkg.gcn_bulkcollectlimit;
                                       
                                        --
                                                           --
                                                --
                                                EXIT WHEN get_code_comb_tbl.count = 0;
                                                --
                                                --
                                                FORALL i IN 1..get_code_comb_tbl.count                         --
                                                INSERT INTO
                                                        XXMX_GL_ACCOUNT_TRANSFORMS
                                                                (
                                                                        APPLICATION_SUITE ,       
                                                                        APPLICATION,              
                                                                        BUSINESS_ENTITY ,         
                                                                        SUB_ENTITY,               
                                                                        xfm_table,
                                                                        xfm_table_column,
                                                                        gl_acccount_desc,
                                                                         FUSION_SEGMENT1 ,
                                                                         FUSION_SEGMENT2 ,
                                                                         FUSION_SEGMENT3 ,
                                                                         FUSION_SEGMENT4 ,
                                                                         FUSION_SEGMENT5 ,
                                                                         FUSION_SEGMENT6 ,
                                                                         FUSION_SEGMENT7 ,
																		 FUSION_SEGMENT8 ,
																		 FUSION_SEGMENT9 ,
                                                                        status          ,
                                                                        creation_date   ,
                                                                        last_update_date,
                                                                        ledger_name
                                                                )
                                                VALUES
                                                        (
                                                                V_APPLICATION_SUITE ,    
															    V_APPLICATION,           
															    V_BUSINESS_ENTITY ,      
															    V_SUB_ENTITY,            
                                                                get_code_comb_tbl(i).xfm_table
															   ,get_code_comb_tbl(i).xfm_table_column
															   ,get_code_comb_tbl(i).gl_acccount_desc
															   ,get_code_comb_tbl(i).segment1
															   ,get_code_comb_tbl(i).segment2
															   ,get_code_comb_tbl(i).segment3
															   ,get_code_comb_tbl(i).segment4
															   ,get_code_comb_tbl(i).segment5
															   ,get_code_comb_tbl(i).segment6
															   ,get_code_comb_tbl(i).segment7
															   ,get_code_comb_tbl(i).segment8
															   ,get_code_comb_tbl(i).segment9
															   ,get_code_comb_tbl(i).status
															   ,get_code_comb_tbl(i).creation_date
															   ,get_code_comb_tbl(i).last_update_date
															   ,get_code_comb_tbl(i).ledger_name 
												        );
                                                --
                                                --** END FORALL
                                                --
                                        END LOOP;
                                        --
                                        --
                                        COMMIT;
                                        --
                                        --
                                        CLOSE get_code_comb_cur; 
                                        --
                                        x_status:= 'SUCCESS';
                                        --
                                        --
                                EXCEPTION               --
                                        WHEN OTHERS THEN                    --
                                        IF
                                                get_code_comb_cur%isopen
                                        THEN
                                                --
                                                CLOSE get_code_comb_cur;
                                                --
                                        END IF;
                                        --
                                        ROLLBACK;
                                        x_status:= 'ERROR: '||SQLERRM||' '||SQLCODE;
                                        --
                                        --
                                        --** END OTHERS Exception
                                        --
                                        --** END Exception Handler
                                        --
                                END gl_code_comb_cvr;
                        --
                        PROCEDURE tot_count ( p_xfm_tbl IN varchar2, x_count OUT number, x_status OUT varchar2) IS
                                BEGIN
                                        SELECT
                                                count(1)
                                        into
                                                x_count
                                        from
                                                XXMX_GL_ACCOUNT_TRANSFORMS
                                        where
                                                xfm_table in
                                                (
                                                        select
                                                                regexp_substr(upper(p_xfm_tbl),'[^,]+',1,level)
                                                        from
                                                                dual
                                                        connect by regexp_substr(upper(p_xfm_tbl),'[^,]+',1,level) is not null)
                                                OR least(p_xfm_tbl) is null
                                                --and status in ('NEW', 'Invalid')
                                                ;
                                EXCEPTION WHEN OTHERS THEN x_status:= 'ERROR: '||SQLERRM||' '||SQLCODE;
                                END tot_count;

                        PROCEDURE acct_combination(p_xfm_tbl IN varchar2, 
                        p_cur OUT sys_refcursor, 
                        x_status OUT varchar2, 
                        p_var_skip IN number) is
                                begin
                                        open p_cur for
                                        select
                                    
                                                 FUSION_SEGMENT1,
                                                 FUSION_SEGMENT2,
                                                 FUSION_SEGMENT3,
                                                 FUSION_SEGMENT4,
                                                 FUSION_SEGMENT5,
                                                 FUSION_SEGMENT6,
                                                 FUSION_SEGMENT7,
												 FUSION_SEGMENT8,
												 FUSION_SEGMENT9,
                                                 ledger_name
                                        from
                                                XXMX_GL_ACCOUNT_TRANSFORMS
                                        where
                                                xfm_table in
                                                (
                                                        select
                                                                regexp_substr(upper(p_xfm_tbl),'[^,]+',1,level)
                                                        from
                                                                dual
                                                        connect by regexp_substr(upper(p_xfm_tbl),'[^,]+',1,level) is not null)OR least(p_xfm_tbl) is null
                                                        and status in ('NEW', 'Invalid')
                                                        order by S_NO offset p_var_skip rows fetch next 800 rows only;
                                                
                                EXCEPTION 
                                 WHEN OTHERS THEN                    
                                        IF
                                                p_cur%isopen
                                        THEN
                                                --
                                                CLOSE p_cur;
                                                --
                                        END IF;
                                        --
                                        x_status:= 'ERROR: '||SQLERRM||' '||SQLCODE;
                                END acct_combination;
                        --
END xxmx_validate_code_comb_cvr_pkg;
/

SHOW ERRORS PACKAGE BODY xxmx_validate_code_comb_cvr_pkg;
/
