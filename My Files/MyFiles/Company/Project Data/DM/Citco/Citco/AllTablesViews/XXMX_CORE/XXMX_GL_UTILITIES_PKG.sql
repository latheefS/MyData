--------------------------------------------------------
--  DDL for Package XXMX_GL_UTILITIES_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "XXMX_CORE"."XXMX_GL_UTILITIES_PKG" AUTHID CURRENT_USER
AS
     --
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
     ** FILENAME  :  xxmx_gl_utilities_pkg.sql
     **
     ** FILEPATH  :  $XXV1_TOP/install/sql
     **
     ** VERSION   :  1.0
     **
     ** EXECUTE
     ** IN SCHEMA :  APPS
     **
     ** AUTHORS   :  Ian S. Vickerstaff
     **
     ** PURPOSE   :  This script installs the package specification for the Maximise
     **              GL Utilities Procedures and Functions package.
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
     **            $XXV1_TOP/install/sql/xxv1_mxdm_utilities_1_dbi.sql
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
     **   1.0  27-NOV-2020  Ian S. Vickerstaff  Created for Maximise.
     **
     **   1.1  20-DEC-2020  Ian S. Vickerstaff  Logic Enhancements.
     **
     **   1.2  30-DEC-2020  Ian S. Vickerstaff  Logic Enhancements.
     **
     **   1.3  08-JAN-2021  Ian S. Vickerstaff  Logic Enhancements.
     **
     **   1.4  12-JAN-2021  Ian S. Vickerstaff  Logic Enhancements.
     **
     **   1.5  18-JAN-2021  Ian S. Vickerstaff  Logic Enhancements.
     **
     **   1.6  28-JAN-2021  Ian S. Vickerstaff  Logic Enhancements.
     **
     **   1.7  10-FEB-2021  Ian S. Vickerstaff  Logic Enhancements.
     **
     **   1.8  26-FEB-2021  Ian S. Vickerstaff  Logic Enhancements.
     **
     **   1.9  11-MAR-2021  Ian S. Vickerstaff  Logic Enhancements.
     **
     **  1.10  14-JUL-2021  Ian S. Vickerstaff  Header comment updates.
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
     **       This data element is a local constant or type VARCHAR2.
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
     *********************************************
     ** PROCEDURE: extract_src_gl_acct_structures
     *********************************************
     */
     --
     PROCEDURE extract_src_gl_acct_structures;
                    --
                    --
     --** END PROCEDURE extract_src_gl_acct_structures
     --
     --
     /*
     *******************************************
     ** PROCEDURE: extract_src_gl_seg_value_sets
     *******************************************
     */
     --
     PROCEDURE extract_src_gl_seg_value_sets
                    (
                     pv_i_DeleteAllData              IN  VARCHAR2  DEFAULT 'N'
                    ,pv_i_DeleteFrozenData           IN  VARCHAR2  DEFAULT 'N'
                    );
                    --
                    --
     --** END PROCEDURE extract_gl_account_segments
     --
     --
     /*
     *****************************************
     ** FUNCTION: transform_gl_account_segment
     *****************************************
     */
     --
     FUNCTION transform_gl_account_segment
                   (
                    pt_i_SourceLedgerName           IN      xxmx_gl_acct_seg_transforms.source_ledger_name%TYPE
                   ,pt_i_SourceSegmentName          IN      xxmx_gl_acct_seg_transforms.source_segment_name%TYPE
                   ,pt_i_SourceSegmentColumn        IN      xxmx_gl_acct_seg_transforms.source_segment_column%TYPE
                   ,pt_i_SourceSegmentValue         IN      xxmx_gl_acct_seg_transforms.source_segment_value%TYPE
                   )
     RETURN VARCHAR2;
                    --
                    --
     --** END FUNCTION transform_gl_account_segment
     --
     --
     /*
     ******************************************
     ** PROCEDURE: gen_default_gl_acct_transforms
     ******************************************
     */
     --
     PROCEDURE gen_default_gl_acct_transforms;
                    --
                    --
     --** END PROCEDURE gen_default_gl_acct_transforms
     --
     --
     /*
     *******************************************
     ** PROCEDURE: verify_gl_account_transforms
     *******************************************
     */
     --
     PROCEDURE verify_gl_account_transforms
                    (
                     pt_i_ApplicationSuite           IN      xxmx_gl_account_transforms.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_gl_account_transforms.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_gl_account_transforms.business_entity%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_gl_account_transforms.sub_entity%TYPE
                    ,pt_i_SourceLedgerName           IN      xxmx_gl_account_transforms.source_ledger_name%TYPE
                    ,pn_o_TransformRowCount              OUT NUMBER
                    ,pb_o_UnfrozenTransforms             OUT BOOLEAN
                    ,pt_o_TransformEvaluationMsg         OUT xxmx_data_messages.data_message%TYPE
                    );
                    --
                    --
     --** END PROCEDURE verify_gl_account_transforms
     --
     --
     /*
     **********************************
     ** PROCEDURE: transform_gl_account
     **********************************
     */
     --
     PROCEDURE transform_gl_account
                    (
                     pt_i_ApplicationSuite           IN      xxmx_gl_account_transforms.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_gl_account_transforms.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_gl_account_transforms.business_entity%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_gl_account_transforms.sub_entity%TYPE
                    ,pt_i_SourceLedgerName           IN      xxmx_gl_account_transforms.source_ledger_name%TYPE
                    ,pt_i_SourceSegment1             IN      xxmx_gl_account_transforms.source_segment1%TYPE
                    ,pt_i_SourceSegment2             IN      xxmx_gl_account_transforms.source_segment2%TYPE
                    ,pt_i_SourceSegment3             IN      xxmx_gl_account_transforms.source_segment3%TYPE
                    ,pt_i_SourceSegment4             IN      xxmx_gl_account_transforms.source_segment4%TYPE
                    ,pt_i_SourceSegment5             IN      xxmx_gl_account_transforms.source_segment5%TYPE
                    ,pt_i_SourceSegment6             IN      xxmx_gl_account_transforms.source_segment6%TYPE
                    ,pt_i_SourceSegment7             IN      xxmx_gl_account_transforms.source_segment7%TYPE
                    ,pt_i_SourceSegment8             IN      xxmx_gl_account_transforms.source_segment8%TYPE
                    ,pt_i_SourceSegment9             IN      xxmx_gl_account_transforms.source_segment9%TYPE
                    ,pt_i_SourceSegment10            IN      xxmx_gl_account_transforms.source_segment10%TYPE
                    ,pt_i_SourceSegment11            IN      xxmx_gl_account_transforms.source_segment11%TYPE
                    ,pt_i_SourceSegment12            IN      xxmx_gl_account_transforms.source_segment12%TYPE
                    ,pt_i_SourceSegment13            IN      xxmx_gl_account_transforms.source_segment13%TYPE
                    ,pt_i_SourceSegment14            IN      xxmx_gl_account_transforms.source_segment14%TYPE
                    ,pt_i_SourceSegment15            IN      xxmx_gl_account_transforms.source_segment15%TYPE
                    ,pt_i_SourceSegment16            IN      xxmx_gl_account_transforms.source_segment16%TYPE
                    ,pt_i_SourceSegment17            IN      xxmx_gl_account_transforms.source_segment17%TYPE
                    ,pt_i_SourceSegment18            IN      xxmx_gl_account_transforms.source_segment18%TYPE
                    ,pt_i_SourceSegment19            IN      xxmx_gl_account_transforms.source_segment19%TYPE
                    ,pt_i_SourceSegment20            IN      xxmx_gl_account_transforms.source_segment20%TYPE
                    ,pt_i_SourceSegment21            IN      xxmx_gl_account_transforms.source_segment21%TYPE
                    ,pt_i_SourceSegment22            IN      xxmx_gl_account_transforms.source_segment22%TYPE
                    ,pt_i_SourceSegment23            IN      xxmx_gl_account_transforms.source_segment23%TYPE
                    ,pt_i_SourceSegment24            IN      xxmx_gl_account_transforms.source_segment24%TYPE
                    ,pt_i_SourceSegment25            IN      xxmx_gl_account_transforms.source_segment25%TYPE
                    ,pt_i_SourceSegment26            IN      xxmx_gl_account_transforms.source_segment26%TYPE
                    ,pt_i_SourceSegment27            IN      xxmx_gl_account_transforms.source_segment27%TYPE
                    ,pt_i_SourceSegment28            IN      xxmx_gl_account_transforms.source_segment28%TYPE
                    ,pt_i_SourceSegment29            IN      xxmx_gl_account_transforms.source_segment29%TYPE
                    ,pt_i_SourceSegment30            IN      xxmx_gl_account_transforms.source_segment30%TYPE
                    ,pt_i_SourceConcatSegments       IN      xxmx_gl_account_transforms.source_concatenated_segments%TYPE
                    ,pt_o_FusionSegment1                OUT  xxmx_gl_account_transforms.fusion_segment1%TYPE
                    ,pt_o_FusionSegment2                OUT  xxmx_gl_account_transforms.fusion_segment2%TYPE
                    ,pt_o_FusionSegment3                OUT  xxmx_gl_account_transforms.fusion_segment3%TYPE
                    ,pt_o_FusionSegment4                OUT  xxmx_gl_account_transforms.fusion_segment4%TYPE
                    ,pt_o_FusionSegment5                OUT  xxmx_gl_account_transforms.fusion_segment5%TYPE
                    ,pt_o_FusionSegment6                OUT  xxmx_gl_account_transforms.fusion_segment6%TYPE
                    ,pt_o_FusionSegment7                OUT  xxmx_gl_account_transforms.fusion_segment7%TYPE
                    ,pt_o_FusionSegment8                OUT  xxmx_gl_account_transforms.fusion_segment8%TYPE
                    ,pt_o_FusionSegment9                OUT  xxmx_gl_account_transforms.fusion_segment9%TYPE
                    ,pt_o_FusionSegment10               OUT  xxmx_gl_account_transforms.fusion_segment10%TYPE
                    ,pt_o_FusionSegment11               OUT  xxmx_gl_account_transforms.fusion_segment11%TYPE
                    ,pt_o_FusionSegment12               OUT  xxmx_gl_account_transforms.fusion_segment12%TYPE
                    ,pt_o_FusionSegment13               OUT  xxmx_gl_account_transforms.fusion_segment13%TYPE
                    ,pt_o_FusionSegment14               OUT  xxmx_gl_account_transforms.fusion_segment14%TYPE
                    ,pt_o_FusionSegment15               OUT  xxmx_gl_account_transforms.fusion_segment15%TYPE
                    ,pt_o_FusionSegment16               OUT  xxmx_gl_account_transforms.fusion_segment16%TYPE
                    ,pt_o_FusionSegment17               OUT  xxmx_gl_account_transforms.fusion_segment17%TYPE
                    ,pt_o_FusionSegment18               OUT  xxmx_gl_account_transforms.fusion_segment18%TYPE
                    ,pt_o_FusionSegment19               OUT  xxmx_gl_account_transforms.fusion_segment19%TYPE
                    ,pt_o_FusionSegment20               OUT  xxmx_gl_account_transforms.fusion_segment20%TYPE
                    ,pt_o_FusionSegment21               OUT  xxmx_gl_account_transforms.fusion_segment21%TYPE
                    ,pt_o_FusionSegment22               OUT  xxmx_gl_account_transforms.fusion_segment22%TYPE
                    ,pt_o_FusionSegment23               OUT  xxmx_gl_account_transforms.fusion_segment23%TYPE
                    ,pt_o_FusionSegment24               OUT  xxmx_gl_account_transforms.fusion_segment24%TYPE
                    ,pt_o_FusionSegment25               OUT  xxmx_gl_account_transforms.fusion_segment25%TYPE
                    ,pt_o_FusionSegment26               OUT  xxmx_gl_account_transforms.fusion_segment26%TYPE
                    ,pt_o_FusionSegment27               OUT  xxmx_gl_account_transforms.fusion_segment27%TYPE
                    ,pt_o_FusionSegment28               OUT  xxmx_gl_account_transforms.fusion_segment28%TYPE
                    ,pt_o_FusionSegment29               OUT  xxmx_gl_account_transforms.fusion_segment29%TYPE
                    ,pt_o_FusionSegment30               OUT  xxmx_gl_account_transforms.fusion_segment30%TYPE
                    ,pt_o_FusionConcatSegments          OUT  xxmx_gl_account_transforms.fusion_concatenated_segments%TYPE
                    ,pv_o_ReturnStatus                  OUT  VARCHAR2
                    ,pv_o_ReturnMessage                 OUT  VARCHAR2
                    );
                    --
                    --
     --** END PROCEDURE transform_gl_account
     --
     --
     FUNCTION account_code_format_is_valid
                   (
                    pv_i_SourceOrFusionAccount      IN      VARCHAR2
                   ,pt_i_LedgerName                 IN      xxmx_gl_acct_seg_transforms.source_ledger_name%TYPE
                   ,pv_i_ConcatenatedAccountCode    IN      VARCHAR2
                   ,pt_o_AccountEvaluationMsg          OUT  xxmx_data_messages.data_message%TYPE
                   )
     RETURN BOOLEAN;
                    --
                    --
     --** END FUNCTION account_code_format_is_valid
     --
     --
     PROCEDURE separate_account_segments
                    (
                     pv_i_SourceOrFusionAccount      IN      VARCHAR2
                    ,pt_i_LedgerName                 IN      xxmx_gl_acct_seg_transforms.source_ledger_name%TYPE
                    ,pv_i_ConcatenatedAccountCode    IN      VARCHAR2
                    ,pt_o_Segment1                      OUT  xxmx_gl_account_transforms.fusion_segment1%TYPE
                    ,pt_o_Segment2                      OUT  xxmx_gl_account_transforms.fusion_segment2%TYPE
                    ,pt_o_Segment3                      OUT  xxmx_gl_account_transforms.fusion_segment3%TYPE
                    ,pt_o_Segment4                      OUT  xxmx_gl_account_transforms.fusion_segment4%TYPE
                    ,pt_o_Segment5                      OUT  xxmx_gl_account_transforms.fusion_segment5%TYPE
                    ,pt_o_Segment6                      OUT  xxmx_gl_account_transforms.fusion_segment6%TYPE
                    ,pt_o_Segment7                      OUT  xxmx_gl_account_transforms.fusion_segment7%TYPE
                    ,pt_o_Segment8                      OUT  xxmx_gl_account_transforms.fusion_segment8%TYPE
                    ,pt_o_Segment9                      OUT  xxmx_gl_account_transforms.fusion_segment9%TYPE
                    ,pt_o_Segment10                     OUT  xxmx_gl_account_transforms.fusion_segment10%TYPE
                    ,pt_o_Segment11                     OUT  xxmx_gl_account_transforms.fusion_segment11%TYPE
                    ,pt_o_Segment12                     OUT  xxmx_gl_account_transforms.fusion_segment12%TYPE
                    ,pt_o_Segment13                     OUT  xxmx_gl_account_transforms.fusion_segment13%TYPE
                    ,pt_o_Segment14                     OUT  xxmx_gl_account_transforms.fusion_segment14%TYPE
                    ,pt_o_Segment15                     OUT  xxmx_gl_account_transforms.fusion_segment15%TYPE
                    ,pt_o_Segment16                     OUT  xxmx_gl_account_transforms.fusion_segment16%TYPE
                    ,pt_o_Segment17                     OUT  xxmx_gl_account_transforms.fusion_segment17%TYPE
                    ,pt_o_Segment18                     OUT  xxmx_gl_account_transforms.fusion_segment18%TYPE
                    ,pt_o_Segment19                     OUT  xxmx_gl_account_transforms.fusion_segment19%TYPE
                    ,pt_o_Segment20                     OUT  xxmx_gl_account_transforms.fusion_segment20%TYPE
                    ,pt_o_Segment21                     OUT  xxmx_gl_account_transforms.fusion_segment21%TYPE
                    ,pt_o_Segment22                     OUT  xxmx_gl_account_transforms.fusion_segment22%TYPE
                    ,pt_o_Segment23                     OUT  xxmx_gl_account_transforms.fusion_segment23%TYPE
                    ,pt_o_Segment24                     OUT  xxmx_gl_account_transforms.fusion_segment24%TYPE
                    ,pt_o_Segment25                     OUT  xxmx_gl_account_transforms.fusion_segment25%TYPE
                    ,pt_o_Segment26                     OUT  xxmx_gl_account_transforms.fusion_segment26%TYPE
                    ,pt_o_Segment27                     OUT  xxmx_gl_account_transforms.fusion_segment27%TYPE
                    ,pt_o_Segment28                     OUT  xxmx_gl_account_transforms.fusion_segment28%TYPE
                    ,pt_o_Segment29                     OUT  xxmx_gl_account_transforms.fusion_segment29%TYPE
                    ,pt_o_Segment30                     OUT  xxmx_gl_account_transforms.fusion_segment30%TYPE
                    ,pv_o_ReturnStatus                  OUT  VARCHAR2
                    ,pv_o_ReturnMessage                 OUT  VARCHAR2
                    );
                    --
                    --
     --** END PROCEDURE separate_account_segments
     --
     --
END xxmx_gl_utilities_pkg;

/
