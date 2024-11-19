create or replace PACKAGE BODY xxmx_validate_code_comb_cvr_pkg AS
     --
     --**********************
     --** Global Declarations
     --**********************
     --
     /*
     ** Maximise Integration Globals
     */
     --
     /*
     ** Global Constants for use in all xxmx_utilities_pkg Procedure/Function Calls within this package
     */
     --
                -- Added for SMBC flexibility, could move to migration parameter table
     --
     --
    gvv_progressindicator       VARCHAR2(100);
     --
     /*
     ** Global Variables for receiving Status/Messages from certain Procedure/Function Calls (e.g. xxmx_utilities_pkg.clear_messages
     */
     --
    gvv_returnstatus            VARCHAR2(1);
    gvt_returnmessage           xxmx_module_messages.module_message%TYPE;
     --
     /*
     ** Global Variables for Exception Handlers
     */
     --
    gvv_applicationerrormessage VARCHAR2(2048);
    gvt_severity                xxmx_module_messages.severity%TYPE;
    gvt_modulemessage           xxmx_module_messages.module_message%TYPE;
    gvt_oracleerror             xxmx_module_messages.oracle_error%TYPE;
     --
     /*
     ** Global Variables for Exception Handlers
     */
     --
    gvt_migrationsetname        xxmx_migration_headers.migration_set_name%TYPE;
     --
     /*
     ** Global constants and variables for dynamic SQL usage
     */
     --
    gcv_sqlspace                CONSTANT VARCHAR2(1) := ' ';
    gvv_sqlaction               VARCHAR2(20);
    gvv_sqltableclause          VARCHAR2(100);
    gvv_sqlcolumnlist           VARCHAR2(4000);
    gvv_sqlvalueslist           VARCHAR2(4000);
    gvv_sqlwhereclause          VARCHAR2(4000);
    gvv_sqlstatement            VARCHAR2(32000);
    gvv_sqlresult               VARCHAR2(4000);
     --
     /*
     ** Global variables for holding table row counts
     */
     --
    gvn_rowcount                NUMBER;
     --
     --
     /*
     ******************************
     ** PROCEDURE: <Procedure Name>
     ** keep parameters as is
     ******************************
     */
     --
    PROCEDURE gl_code_comb_cvr (
        p_xfm_tbl IN varchar2,
        x_status      OUT varchar2
    ) IS
          --
          --
          --**********************
          --** CURSOR Declarations
          --**********************
          --
          --<<Cursor to get the detail ??>>
          --
        CURSOR get_code_comb_cur IS
        select 1 s_no, main.xfm_table,main.gl_acccount_desc,main.segment1,main.segment2,main.segment3,main.segment4,main.segment5
        ,main.segment6,main.segment7, null segment8,null segment9,null segment10, main.status,null error_code, null error_message,
        main.creation_date, main.last_update_date, null future1, null future2, null future3, main.ledger_name, main.xfm_table_column from (SELECT
    'XXMX_GL_OPENING_BALANCES_XFM' AS xfm_table,
    'GL_CODE_COMBINATIONS'         xfm_table_column,
    'GL_CODE_COMBINATIONS'         gl_acccount_desc,
    a.segment1,
    a.segment2,
    a.segment3,
    a.segment4,
    a.segment5,
    a.segment6,
    a.segment7,
    'NEW'                          status,
    sysdate                        creation_date,
    sysdate                        last_update_date,
    a.ledger_name
FROM
    xxmx_gl_opening_balances_xfm a
    where not exists (select 1 from xxmx_gl_account_code_combinations xglobx
    where a.segment1=xglobx.segment1
    and a.segment2=xglobx.segment2
    and a.segment3=xglobx.segment3
    and a.segment4=xglobx.segment4
    and a.segment5=xglobx.segment5
    and a.segment6=xglobx.segment6
    and a.segment7=xglobx.segment7
    and a.ledger_name=xglobx.ledger_name
    and xglobx.status='Valid')
GROUP BY
    a.segment1,
    a.segment2,
    a.segment3,
    a.segment4,
    a.segment5,
    a.segment6,
    a.segment7,
    a.ledger_name
UNION
SELECT
    'XXMX_GL_SUMMARY_BALANCES_XFM' AS xfm_table,
    'GL_CODE_COMBINATIONS'         xfm_table_column,
    'GL_CODE_COMBINATIONS'         gl_acccount_desc,
    b.segment1,
    b.segment2,
    b.segment3,
    b.segment4,
    b.segment5,
    b.segment6,
    b.segment7,
    'NEW'                          status,
    sysdate,
    sysdate,
    b.ledger_name
FROM
    xxmx_gl_summary_balances_xfm b
    where not exists (select 1 from xxmx_gl_account_code_combinations xglobx
    where b.segment1=xglobx.segment1
    and b.segment2=xglobx.segment2
    and b.segment3=xglobx.segment3
    and b.segment4=xglobx.segment4
    and b.segment5=xglobx.segment5
    and b.segment6=xglobx.segment6
    and b.segment7=xglobx.segment7
    and b.ledger_name=xglobx.ledger_name
    and xglobx.status='Valid')
GROUP BY
    b.segment1,
    b.segment2,
    b.segment3,
    b.segment4,
    b.segment5,
    b.segment6,
    b.segment7,
    b.ledger_name
UNION
SELECT
    'XXMX_GL_DETAIL_BALANCES_XFM' AS xfm_table,
    'GL_CODE_COMBINATIONS'         xfm_table_column,
    'GL_CODE_COMBINATIONS'         gl_acccount_desc,
    b.segment1,
    b.segment2,
    b.segment3,
    b.segment4,
    b.segment5,
    b.segment6,
    b.segment7,
    'NEW'                          status,
    sysdate,
    sysdate,
    b.ledger_name
FROM
    xxmx_gl_detail_balances_xfm b
    where not exists (select 1 from xxmx_gl_account_code_combinations xglobx
    where b.segment1=xglobx.segment1
    and b.segment2=xglobx.segment2
    and b.segment3=xglobx.segment3
    and b.segment4=xglobx.segment4
    and b.segment5=xglobx.segment5
    and b.segment6=xglobx.segment6
    and b.segment7=xglobx.segment7
    and b.ledger_name=xglobx.ledger_name
    and xglobx.status='Valid')
GROUP BY
    b.segment1,
    b.segment2,
    b.segment3,
    b.segment4,
    b.segment5,
    b.segment6,
    b.segment7,
    b.ledger_name
UNION
SELECT
    'XXMX_GL_HISTORICALRATES_XFM' AS xfm_table,
    'GL_CODE_COMBINATIONS'        xfm_table_column,
    'GL_CODE_COMBINATIONS'        gl_acccount_desc,
    a.segment1,
    a.segment2,
    a.segment3,
    a.segment4,
    a.segment5,
    a.segment6,
    a.segment7,
    'NEW'                         status,
    sysdate                       creation_date,
    sysdate                       last_update_date,
    a.ledger_name
FROM
    xxmx_gl_historicalrates_xfm a
    where not exists (select 1 from xxmx_gl_account_code_combinations xglobx
    where a.segment1=xglobx.segment1
    and a.segment2=xglobx.segment2
    and a.segment3=xglobx.segment3
    and a.segment4=xglobx.segment4
    and a.segment5=xglobx.segment5
    and a.segment6=xglobx.segment6
    and a.segment7=xglobx.segment7
    and a.ledger_name=xglobx.ledger_name
    and xglobx.status='Valid')
GROUP BY
    a.segment1,
    a.segment2,
    a.segment3,
    a.segment4,
    a.segment5,
    a.segment6,
    a.segment7,
    a.ledger_name
UNION
SELECT
    'XXMX_SCM_PO_DISTRIBUTIONS_STD_XFM' AS xfm_table,
    'GL_CODE_COMBINATIONS'        xfm_table_column,
    'GL_CODE_COMBINATIONS'        gl_acccount_desc,
    charge_account_segment1,
    charge_account_segment2,
    charge_account_segment3,
    charge_account_segment4,
    charge_account_segment5,
    charge_account_segment6,
    charge_account_segment7,
    'NEW'                         status,
    sysdate                       creation_date,
    sysdate                       last_update_date,
    c.ledger_name
FROM
    xxmx_scm_po_headers_std_xfm       a,
    xxmx_scm_po_distributions_std_xfm b,
    xxmx_dm_fusion_das                c
WHERE
    a.po_header_id = b.po_header_id
    AND a.prc_bu_name = c.bu_name
    AND not exists (select 1 from xxmx_gl_account_code_combinations xglobx
    where b.charge_account_segment1=xglobx.segment1
    and b.charge_account_segment2=xglobx.segment2
    and b.charge_account_segment3=xglobx.segment3
    and b.charge_account_segment4=xglobx.segment4
    and b.charge_account_segment5=xglobx.segment5
    and b.charge_account_segment6=xglobx.segment6
    and b.charge_account_segment7=xglobx.segment7
    and c.ledger_name=xglobx.ledger_name
    and xglobx.status='Valid')
GROUP BY
    charge_account_segment1,
    charge_account_segment2,
    charge_account_segment3,
    charge_account_segment4,
    charge_account_segment5,
    charge_account_segment6,
    charge_account_segment7,
    c.ledger_name
    UNION
    select * from (select 
'XXMX_AP_SUPP_SITE_ASSIGNS_XFM' AS xfm_table,
    'LIABILITY_DISTRIBUTION'        xfm_table_column,
    'GL_CODE_COMBINATIONS'        gl_acccount_desc,
substr(LIABILITY_DISTRIBUTION,1,instr(LIABILITY_DISTRIBUTION,'.',1,1)-1) segment1,
 substr(LIABILITY_DISTRIBUTION,instr(LIABILITY_DISTRIBUTION,'.',1,1)+1,instr(LIABILITY_DISTRIBUTION,'.',1,2)-instr(LIABILITY_DISTRIBUTION,'.',1,1)-1) segment2 ,
 substr(LIABILITY_DISTRIBUTION,instr(LIABILITY_DISTRIBUTION,'.',1,2)+1,instr(LIABILITY_DISTRIBUTION,'.',1,3)-instr(LIABILITY_DISTRIBUTION,'.',1,2)-1) segment3 , 
 substr(LIABILITY_DISTRIBUTION,instr(LIABILITY_DISTRIBUTION,'.',1,3)+1,instr(LIABILITY_DISTRIBUTION,'.',1,4)-instr(LIABILITY_DISTRIBUTION,'.',1,3)-1) segment4 , 
 substr(LIABILITY_DISTRIBUTION,instr(LIABILITY_DISTRIBUTION,'.',1,4)+1,instr(LIABILITY_DISTRIBUTION,'.',1,5)-instr(LIABILITY_DISTRIBUTION,'.',1,4)-1) segment5 , 
 substr(LIABILITY_DISTRIBUTION,instr(LIABILITY_DISTRIBUTION,'.',1,5)+1,instr(LIABILITY_DISTRIBUTION,'.',1,6)-instr(LIABILITY_DISTRIBUTION,'.',1,5)-1) segment6 , 
 substr(LIABILITY_DISTRIBUTION,instr(LIABILITY_DISTRIBUTION,'.',1,6)+1) segment7  ,
 'NEW'                         status,
    sysdate                       creation_date,
    sysdate                       last_update_date,
    c.ledger_name
 from xxmx_ap_supp_site_assigns_xfm a, xxmx_dm_fusion_das c
 where  a.procurement_bu = c.bu_name
 GROUP BY
 LIABILITY_DISTRIBUTION,
 c.ledger_name) d
 where not exists (select 1 from xxmx_gl_account_code_combinations xglobx
    where d.segment1=xglobx.segment1
    and d.segment2=xglobx.segment2
    and d.segment3=xglobx.segment3
    and d.segment4=xglobx.segment4
    and d.segment5=xglobx.segment5
    and d.segment6=xglobx.segment6
    and d.segment7=xglobx.segment7
    and d.ledger_name=xglobx.ledger_name
    and xglobx.status='Valid')

 UNION
 select * from (select 
'XXMX_AP_SUPP_SITE_ASSIGNS_XFM' AS xfm_table,
    'PREPAYMENT_DISTRIBUTION'        xfm_table_column,
    'GL_CODE_COMBINATIONS'        gl_acccount_desc,
substr(PREPAYMENT_DISTRIBUTION,1,instr(PREPAYMENT_DISTRIBUTION,'.',1,1)-1) segment1,
 substr(PREPAYMENT_DISTRIBUTION,instr(PREPAYMENT_DISTRIBUTION,'.',1,1)+1,instr(PREPAYMENT_DISTRIBUTION,'.',1,2)-instr(PREPAYMENT_DISTRIBUTION,'.',1,1)-1) segment2 ,
 substr(PREPAYMENT_DISTRIBUTION,instr(PREPAYMENT_DISTRIBUTION,'.',1,2)+1,instr(PREPAYMENT_DISTRIBUTION,'.',1,3)-instr(PREPAYMENT_DISTRIBUTION,'.',1,2)-1) segment3 , 
 substr(PREPAYMENT_DISTRIBUTION,instr(PREPAYMENT_DISTRIBUTION,'.',1,3)+1,instr(PREPAYMENT_DISTRIBUTION,'.',1,4)-instr(PREPAYMENT_DISTRIBUTION,'.',1,3)-1) segment4 , 
 substr(PREPAYMENT_DISTRIBUTION,instr(PREPAYMENT_DISTRIBUTION,'.',1,4)+1,instr(PREPAYMENT_DISTRIBUTION,'.',1,5)-instr(PREPAYMENT_DISTRIBUTION,'.',1,4)-1) segment5 , 
 substr(PREPAYMENT_DISTRIBUTION,instr(PREPAYMENT_DISTRIBUTION,'.',1,5)+1,instr(PREPAYMENT_DISTRIBUTION,'.',1,6)-instr(PREPAYMENT_DISTRIBUTION,'.',1,5)-1) segment6 , 
 substr(PREPAYMENT_DISTRIBUTION,instr(PREPAYMENT_DISTRIBUTION,'.',1,6)+1) segment7  ,
 'NEW'                         status,
    sysdate                       creation_date,
    sysdate                       last_update_date,
    c.ledger_name
 from xxmx_ap_supp_site_assigns_xfm a, xxmx_dm_fusion_das c
 where  a.procurement_bu = c.bu_name
 GROUP BY
 PREPAYMENT_DISTRIBUTION, c.ledger_name ) d
 where not exists (select 1 from xxmx_gl_account_code_combinations xglobx
    where d.segment1=xglobx.segment1
    and d.segment2=xglobx.segment2
    and d.segment3=xglobx.segment3
    and d.segment4=xglobx.segment4
    and d.segment5=xglobx.segment5
    and d.segment6=xglobx.segment6
    and d.segment7=xglobx.segment7
    and d.ledger_name=xglobx.ledger_name
    and xglobx.status='Valid')

 UNION
 select * from (
 select 
 'XXMX_FA_MASS_ADDITIONS_XFM' AS xfm_table,
    'GL_CODE_COMBINATIONS'        xfm_table_column,
    'GL_CODE_COMBINATIONS'        gl_acccount_desc,
 CLEARING_ACCT_SEGMENT1 segment1,
 CLEARING_ACCT_SEGMENT2 segment2,
 CLEARING_ACCT_SEGMENT3 segment3,
 CLEARING_ACCT_SEGMENT4 segment4,
 CLEARING_ACCT_SEGMENT5 segment5,
 CLEARING_ACCT_SEGMENT6 segment6,
 CLEARING_ACCT_SEGMENT7 segment7,
 'NEW'                         status,
    sysdate                       creation_date,
    sysdate                       last_update_date,
 b.name ledger_name
 from xxmx_fa_mass_additions_xfm a, xxmx_dm_asset_books_in_scope b
 where a.book_type_code=b.book_type_code
 group by
 CLEARING_ACCT_SEGMENT1,
 CLEARING_ACCT_SEGMENT2,
 CLEARING_ACCT_SEGMENT3,
 CLEARING_ACCT_SEGMENT4,
 CLEARING_ACCT_SEGMENT5,
 CLEARING_ACCT_SEGMENT6,
 CLEARING_ACCT_SEGMENT7,
 b.name) d
 where not exists (select 1 from xxmx_gl_account_code_combinations xglobx
    where d.segment1=xglobx.segment1
    and d.segment2=xglobx.segment2
    and d.segment3=xglobx.segment3
    and d.segment4=xglobx.segment4
    and d.segment5=xglobx.segment5
    and d.segment6=xglobx.segment6
    and d.segment7=xglobx.segment7
    and d.ledger_name=xglobx.ledger_name
    and xglobx.status='Valid')
UNION
select * from (
select 
'XXMX_PPM_PRJ_LBRCOST_XFM' AS xfm_table,
    'RAW_COST_CR_ACCOUNT'        xfm_table_column,
    'GL_CODE_COMBINATIONS'        gl_acccount_desc,
    substr(RAW_COST_CR_ACCOUNT,1,instr(RAW_COST_CR_ACCOUNT,'.',1,1)-1) segment1,
 substr(RAW_COST_CR_ACCOUNT,instr(RAW_COST_CR_ACCOUNT,'.',1,1)+1,instr(RAW_COST_CR_ACCOUNT,'.',1,2)-instr(RAW_COST_CR_ACCOUNT,'.',1,1)-1) segment2 ,
 substr(RAW_COST_CR_ACCOUNT,instr(RAW_COST_CR_ACCOUNT,'.',1,2)+1,instr(RAW_COST_CR_ACCOUNT,'.',1,3)-instr(RAW_COST_CR_ACCOUNT,'.',1,2)-1) segment3 , 
 substr(RAW_COST_CR_ACCOUNT,instr(RAW_COST_CR_ACCOUNT,'.',1,3)+1,instr(RAW_COST_CR_ACCOUNT,'.',1,4)-instr(RAW_COST_CR_ACCOUNT,'.',1,3)-1) segment4 , 
 substr(RAW_COST_CR_ACCOUNT,instr(RAW_COST_CR_ACCOUNT,'.',1,4)+1,instr(RAW_COST_CR_ACCOUNT,'.',1,5)-instr(RAW_COST_CR_ACCOUNT,'.',1,4)-1) segment5 , 
 substr(RAW_COST_CR_ACCOUNT,instr(RAW_COST_CR_ACCOUNT,'.',1,5)+1,instr(RAW_COST_CR_ACCOUNT,'.',1,6)-instr(RAW_COST_CR_ACCOUNT,'.',1,5)-1) segment6 , 
 substr(RAW_COST_CR_ACCOUNT,instr(RAW_COST_CR_ACCOUNT,'.',1,6)+1) segment7,
 'NEW'                         status,
    sysdate                       creation_date,
    sysdate                       last_update_date ,
    c.ledger_name from xxmx_ppm_prj_lbrcost_xfm a 
    , xxmx_dm_fusion_das c
 where  a.business_unit = c.bu_name
 GROUP BY
 RAW_COST_CR_ACCOUNT, c.ledger_name, 'XXMX_PPM_PRJ_LBRCOST_XFM', 'GL_CODE_COMBINATIONS', 'NEW', 
sysdate) d
 where not exists (select 1 from xxmx_gl_account_code_combinations xglobx
    where d.segment1=xglobx.segment1
    and d.segment2=xglobx.segment2
    and d.segment3=xglobx.segment3
    and d.segment4=xglobx.segment4
    and d.segment5=xglobx.segment5
    and d.segment6=xglobx.segment6
    and d.segment7=xglobx.segment7
    and d.ledger_name=xglobx.ledger_name
    and xglobx.status='Valid')
UNION
select * from (select 
'XXMX_PPM_PRJ_LBRCOST_XFM' AS xfm_table,
    'RAW_COST_DR_ACCOUNT'        xfm_table_column,
    'GL_CODE_COMBINATIONS'        gl_acccount_desc,
    substr(RAW_COST_DR_ACCOUNT,1,instr(RAW_COST_DR_ACCOUNT,'.',1,1)-1) segment1,
 substr(RAW_COST_DR_ACCOUNT,instr(RAW_COST_DR_ACCOUNT,'.',1,1)+1,instr(RAW_COST_DR_ACCOUNT,'.',1,2)-instr(RAW_COST_DR_ACCOUNT,'.',1,1)-1) segment2 ,
 substr(RAW_COST_DR_ACCOUNT,instr(RAW_COST_DR_ACCOUNT,'.',1,2)+1,instr(RAW_COST_DR_ACCOUNT,'.',1,3)-instr(RAW_COST_DR_ACCOUNT,'.',1,2)-1) segment3 , 
 substr(RAW_COST_DR_ACCOUNT,instr(RAW_COST_DR_ACCOUNT,'.',1,3)+1,instr(RAW_COST_DR_ACCOUNT,'.',1,4)-instr(RAW_COST_DR_ACCOUNT,'.',1,3)-1) segment4 , 
 substr(RAW_COST_DR_ACCOUNT,instr(RAW_COST_DR_ACCOUNT,'.',1,4)+1,instr(RAW_COST_DR_ACCOUNT,'.',1,5)-instr(RAW_COST_DR_ACCOUNT,'.',1,4)-1) segment5 , 
 substr(RAW_COST_DR_ACCOUNT,instr(RAW_COST_DR_ACCOUNT,'.',1,5)+1,instr(RAW_COST_DR_ACCOUNT,'.',1,6)-instr(RAW_COST_DR_ACCOUNT,'.',1,5)-1) segment6 , 
 substr(RAW_COST_DR_ACCOUNT,instr(RAW_COST_DR_ACCOUNT,'.',1,6)+1) segment7,
 'NEW'                         status,
    sysdate                       creation_date,
    sysdate                       last_update_date ,
    c.ledger_name from xxmx_ppm_prj_lbrcost_xfm a 
    , xxmx_dm_fusion_das c
 where  a.business_unit = c.bu_name
 GROUP BY
 RAW_COST_DR_ACCOUNT, c.ledger_name ) d
 where not exists (select 1 from xxmx_gl_account_code_combinations xglobx
    where d.segment1=xglobx.segment1
    and d.segment2=xglobx.segment2
    and d.segment3=xglobx.segment3
    and d.segment4=xglobx.segment4
    and d.segment5=xglobx.segment5
    and d.segment6=xglobx.segment6
    and d.segment7=xglobx.segment7
    and d.ledger_name=xglobx.ledger_name
    and xglobx.status='Valid')

UNION
select * from (
select 
'XXMX_PPM_PRJ_MISCCOST_XFM' AS xfm_table,
    'RAW_COST_DR_ACCOUNT'        xfm_table_column,
    'GL_CODE_COMBINATIONS'        gl_acccount_desc,
    substr(RAW_COST_DR_ACCOUNT,1,instr(RAW_COST_DR_ACCOUNT,'.',1,1)-1) segment1,
 substr(RAW_COST_DR_ACCOUNT,instr(RAW_COST_DR_ACCOUNT,'.',1,1)+1,instr(RAW_COST_DR_ACCOUNT,'.',1,2)-instr(RAW_COST_DR_ACCOUNT,'.',1,1)-1) segment2 ,
 substr(RAW_COST_DR_ACCOUNT,instr(RAW_COST_DR_ACCOUNT,'.',1,2)+1,instr(RAW_COST_DR_ACCOUNT,'.',1,3)-instr(RAW_COST_DR_ACCOUNT,'.',1,2)-1) segment3 , 
 substr(RAW_COST_DR_ACCOUNT,instr(RAW_COST_DR_ACCOUNT,'.',1,3)+1,instr(RAW_COST_DR_ACCOUNT,'.',1,4)-instr(RAW_COST_DR_ACCOUNT,'.',1,3)-1) segment4 , 
 substr(RAW_COST_DR_ACCOUNT,instr(RAW_COST_DR_ACCOUNT,'.',1,4)+1,instr(RAW_COST_DR_ACCOUNT,'.',1,5)-instr(RAW_COST_DR_ACCOUNT,'.',1,4)-1) segment5 , 
 substr(RAW_COST_DR_ACCOUNT,instr(RAW_COST_DR_ACCOUNT,'.',1,5)+1,instr(RAW_COST_DR_ACCOUNT,'.',1,6)-instr(RAW_COST_DR_ACCOUNT,'.',1,5)-1) segment6 , 
 substr(RAW_COST_DR_ACCOUNT,instr(RAW_COST_DR_ACCOUNT,'.',1,6)+1) segment7,
 'NEW'                         status,
    sysdate                       creation_date,
    sysdate                       last_update_date ,
    c.ledger_name from xxmx_ppm_prj_misccost_xfm a 
    , xxmx_dm_fusion_das c
 where  a.business_unit = c.bu_name
 GROUP BY
 RAW_COST_DR_ACCOUNT, c.ledger_name ) d
 where not exists (select 1 from xxmx_gl_account_code_combinations xglobx
    where d.segment1=xglobx.segment1
    and d.segment2=xglobx.segment2
    and d.segment3=xglobx.segment3
    and d.segment4=xglobx.segment4
    and d.segment5=xglobx.segment5
    and d.segment6=xglobx.segment6
    and d.segment7=xglobx.segment7
    and d.ledger_name=xglobx.ledger_name
    and xglobx.status='Valid')
UNION
select * from (
Select 
'XXMX_PPM_PRJ_MISCCOST_XFM' AS xfm_table,
    'RAW_COST_CR_ACCOUNT'        xfm_table_column,
    'GL_CODE_COMBINATIONS'        gl_acccount_desc,
    substr(RAW_COST_CR_ACCOUNT,1,instr(RAW_COST_CR_ACCOUNT,'.',1,1)-1) segment1,
 substr(RAW_COST_CR_ACCOUNT,instr(RAW_COST_CR_ACCOUNT,'.',1,1)+1,instr(RAW_COST_CR_ACCOUNT,'.',1,2)-instr(RAW_COST_CR_ACCOUNT,'.',1,1)-1) segment2 ,
 substr(RAW_COST_CR_ACCOUNT,instr(RAW_COST_CR_ACCOUNT,'.',1,2)+1,instr(RAW_COST_CR_ACCOUNT,'.',1,3)-instr(RAW_COST_CR_ACCOUNT,'.',1,2)-1) segment3 , 
 substr(RAW_COST_CR_ACCOUNT,instr(RAW_COST_CR_ACCOUNT,'.',1,3)+1,instr(RAW_COST_CR_ACCOUNT,'.',1,4)-instr(RAW_COST_CR_ACCOUNT,'.',1,3)-1) segment4 , 
 substr(RAW_COST_CR_ACCOUNT,instr(RAW_COST_CR_ACCOUNT,'.',1,4)+1,instr(RAW_COST_CR_ACCOUNT,'.',1,5)-instr(RAW_COST_CR_ACCOUNT,'.',1,4)-1) segment5 , 
 substr(RAW_COST_CR_ACCOUNT,instr(RAW_COST_CR_ACCOUNT,'.',1,5)+1,instr(RAW_COST_CR_ACCOUNT,'.',1,6)-instr(RAW_COST_CR_ACCOUNT,'.',1,5)-1) segment6 , 
 substr(RAW_COST_CR_ACCOUNT,instr(RAW_COST_CR_ACCOUNT,'.',1,6)+1) segment7,
 'NEW'                         status,
    sysdate                       creation_date,
    sysdate                       last_update_date ,
    c.ledger_name from xxmx_ppm_prj_misccost_xfm a 
    , xxmx_dm_fusion_das c
 where  a.business_unit = c.bu_name
 GROUP BY
 RAW_COST_CR_ACCOUNT, c.ledger_name) d
 where not exists (select 1 from xxmx_gl_account_code_combinations xglobx
    where d.segment1=xglobx.segment1
    and d.segment2=xglobx.segment2
    and d.segment3=xglobx.segment3
    and d.segment4=xglobx.segment4
    and d.segment5=xglobx.segment5
    and d.segment6=xglobx.segment6
    and d.segment7=xglobx.segment7
    and d.ledger_name=xglobx.ledger_name
    and xglobx.status='Valid')
    UNION
    select * from (select 'XXMX_FA_MASS_ADDITION_DIST_XFM' AS xfm_table,
    'GL_CODE_COMBINATIONS'        xfm_table_column,
    'GL_CODE_COMBINATIONS'        gl_acccount_desc,
    c.DEPRN_EXPENSE_SEGMENT1 segment1,
 c.DEPRN_EXPENSE_SEGMENT2 segment2,
 c.DEPRN_EXPENSE_SEGMENT3 segment3,
 c.DEPRN_EXPENSE_SEGMENT4 segment4,
 c.DEPRN_EXPENSE_SEGMENT5 segment5,
 c.DEPRN_EXPENSE_SEGMENT6 segment6,
 c.DEPRN_EXPENSE_SEGMENT7 segment7,
 'NEW'                         status,
    sysdate                       creation_date,
    sysdate                       last_update_date,
b.name ledger_name
 from xxmx_fa_mass_addition_dist_xfm c, xxmx_dm_asset_books_in_scope b, xxmx_fa_mass_additions_xfm a
 where a.MASS_ADDITION_ID=c.MASS_ADDITION_ID
 and a.book_type_code=b.book_type_code
 group by
 c.DEPRN_EXPENSE_SEGMENT1,
 c.DEPRN_EXPENSE_SEGMENT2,
 c.DEPRN_EXPENSE_SEGMENT3,
 c.DEPRN_EXPENSE_SEGMENT4,
 c.DEPRN_EXPENSE_SEGMENT5,
 c.DEPRN_EXPENSE_SEGMENT6,
 c.DEPRN_EXPENSE_SEGMENT7,
 b.name) d
 where not exists (select 1 from xxmx_gl_account_code_combinations xglobx
    where d.segment1=xglobx.segment1
    and d.segment2=xglobx.segment2
    and d.segment3=xglobx.segment3
    and d.segment4=xglobx.segment4
    and d.segment5=xglobx.segment5
    and d.segment6=xglobx.segment6
    and d.segment7=xglobx.segment7
    and d.ledger_name=xglobx.ledger_name
    and xglobx.status='Valid')
    UNION
    select * from (select 
'XXMX_PER_ASSIGNMENTS_M_XFM' AS xfm_table,
    'GL_CODE_COMBINATIONS'        xfm_table_column,
    'GL_CODE_COMBINATIONS'        gl_acccount_desc,
substr(default_expense_account,1,instr(default_expense_account,'.',1,1)-1) segment1,
 substr(default_expense_account,instr(default_expense_account,'.',1,1)+1,instr(default_expense_account,'.',1,2)-instr(default_expense_account,'.',1,1)-1) segment2 ,
 substr(default_expense_account,instr(default_expense_account,'.',1,2)+1,instr(default_expense_account,'.',1,3)-instr(default_expense_account,'.',1,2)-1) segment3 , 
 substr(default_expense_account,instr(default_expense_account,'.',1,3)+1,instr(default_expense_account,'.',1,4)-instr(default_expense_account,'.',1,3)-1) segment4 , 
 substr(default_expense_account,instr(default_expense_account,'.',1,4)+1,instr(default_expense_account,'.',1,5)-instr(default_expense_account,'.',1,4)-1) segment5 , 
 substr(default_expense_account,instr(default_expense_account,'.',1,5)+1,instr(default_expense_account,'.',1,6)-instr(default_expense_account,'.',1,5)-1) segment6 , 
 substr(default_expense_account,instr(default_expense_account,'.',1,6)+1) segment7  ,
 'NEW'                         status,
    sysdate                       creation_date,
    sysdate                       last_update_date,
    c.ledger_name
 from XXMX_PER_ASSIGNMENTS_M_XFM a, xxmx_dm_fusion_das c
 where  a.business_unit_name = c.bu_name
 and a.default_expense_account is not null
 GROUP BY
 default_expense_account,
 c.ledger_name) d
 where not exists (select 1 from xxmx_gl_account_code_combinations xglobx
    where d.segment1=xglobx.segment1
    and d.segment2=xglobx.segment2
    and d.segment3=xglobx.segment3
    and d.segment4=xglobx.segment4
    and d.segment5=xglobx.segment5
    and d.segment6=xglobx.segment6
    and d.segment7=xglobx.segment7
    and d.ledger_name=xglobx.ledger_name
    and xglobx.status='Valid')) main
    where xfm_table in 
    (select regexp_substr(upper(p_xfm_tbl),'[^,]+',1,level) from dual
    connect by regexp_substr(upper(p_xfm_tbl),'[^,]+',1,level) is not null) OR least(p_xfm_tbl) is null;
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
        TYPE get_code_comb_tt IS
            TABLE OF xxmx_gl_account_code_combinations%rowtype INDEX BY BINARY_INTEGER;
          --
          --
          --************************
          --** Constant Declarations
          --************************
          --
        ct_procorfuncname        CONSTANT xxmx_module_messages.proc_or_func_name%TYPE := 'ap_supp_party_site_reg';  --<< Procedure Name>>
        ct_stgschema             CONSTANT VARCHAR2(10) := 'xxmx_stg';
        ct_stgtable              CONSTANT xxmx_migration_metadata.stg_table%TYPE := 'xxmx_ap_supp_tax_reg_stg';  --<< Staging Table Name>>
        ct_phase                 CONSTANT xxmx_module_messages.phase%TYPE := 'EXTRACT';
          --
          --
          --************************
          --** Variable Declarations
          --************************
          --
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
          --** Set gvt_Severity, gvv_ProgressIndicator and gvt_ModuleMessage
          --** before raising this exception.
          --
        e_moduleerror EXCEPTION;
          --
     --** END Declarations
     --
    BEGIN
          --

          --
        gvv_returnstatus := '';
        gvt_returnmessage := '';
          --

               --
            OPEN get_code_comb_cur;
               --
            gvv_progressindicator := '0060';
               --
            LOOP
                    --
                FETCH get_code_comb_cur
                BULK COLLECT INTO get_code_comb_tbl LIMIT xxmx_utilities_pkg.gcn_bulkcollectlimit;
                    --
                EXIT WHEN get_code_comb_tbl.count = 0;
                    --
                gvv_progressindicator := '0070';
                    --
                FORALL i IN 1..get_code_comb_tbl.count
                         --
                    INSERT INTO xxmx_gl_account_code_combinations (
                        xfm_table,
                        xfm_table_column,
                        gl_acccount_desc,
                        segment1,
                        segment2,
                        segment3,
                        segment4,
                        segment5,
                        segment6,
                        segment7,
                        status,
                        creation_date,
                        last_update_date,
                        ledger_name
                    ) VALUES (
                        get_code_comb_tbl(i).xfm_table,
                        get_code_comb_tbl(i).xfm_table_column,
                        get_code_comb_tbl(i).gl_acccount_desc,
                        get_code_comb_tbl(i).segment1,
                        get_code_comb_tbl(i).segment2,
                        get_code_comb_tbl(i).segment3,
                        get_code_comb_tbl(i).segment4,
                        get_code_comb_tbl(i).segment5,
                        get_code_comb_tbl(i).segment6,
                        get_code_comb_tbl(i).segment7,
                        get_code_comb_tbl(i).status,
                        get_code_comb_tbl(i).creation_date,
                        get_code_comb_tbl(i).last_update_date,
                        get_code_comb_tbl(i).ledger_name


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

            x_status:= 'SUCCESS';
               --

          --
    EXCEPTION
               --

        WHEN OTHERS THEN
                    --
            IF get_code_comb_cur%isopen THEN
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
     PROCEDURE tot_count (
        p_xfm_tbl IN varchar2,
        x_count      OUT number,
        x_status      OUT varchar2)



        IS 
        BEGIN
         SELECT count(1)
 into x_count 
 from xxmx_gl_account_code_combinations where (xfm_table in 
    (select regexp_substr(upper(p_xfm_tbl),'[^,]+',1,level) from dual
    connect by regexp_substr(upper(p_xfm_tbl),'[^,]+',1,level) is not null) OR least(p_xfm_tbl) is null)
    --and status in ('NEW', 'Invalid')
    ;
    EXCEPTION
    WHEN OTHERS THEN

        x_status:= 'ERROR: '||SQLERRM||' '||SQLCODE;

        END tot_count;

        PROCEDURE acct_combination(p_xfm_tbl IN varchar2,
        p_cur      OUT sys_refcursor,
        x_status      OUT varchar2,
        p_var_skip     IN number)

        is
        begin
        open p_cur for select s_no, segment1, segment2, segment3, segment4, segment5, segment6, segment7,ledger_name
    from xxmx_gl_account_code_combinations where (xfm_table in 
    (select regexp_substr(upper(p_xfm_tbl),'[^,]+',1,level) from dual
    connect by regexp_substr(upper(p_xfm_tbl),'[^,]+',1,level) is not null) OR least(p_xfm_tbl) is null)
    and status in ('NEW', 'Invalid')
    order by s_no offset p_var_skip rows fetch next 800 rows only;

    EXCEPTION
    WHEN OTHERS THEN
                    --
            IF p_cur%isopen THEN
                         --
                CLOSE p_cur;
                         --
            END IF;
                    --


            x_status:= 'ERROR: '||SQLERRM||' '||SQLCODE;

        end acct_combination;

     --
END xxmx_validate_code_comb_cvr_pkg;