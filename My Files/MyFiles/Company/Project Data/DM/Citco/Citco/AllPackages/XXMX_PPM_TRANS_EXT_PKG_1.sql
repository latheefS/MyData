--------------------------------------------------------
--  DDL for Package Body XXMX_PPM_TRANS_EXT_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "XXMX_CORE"."XXMX_PPM_TRANS_EXT_PKG" AS

--
   PROCEDURE transform_task_number (
        pt_i_applicationsuite      IN    xxmx_seeded_extensions.application_suite%TYPE,
        pt_i_application           IN    xxmx_seeded_extensions.application%TYPE,
        pt_i_businessentity        IN    xxmx_seeded_extensions.business_entity%TYPE,
--        pt_i_subentity             IN    xxmx_seeded_extensions.business_entity%TYPE,
        pt_i_stgpopulationmethod   IN    xxmx_core_parameters.parameter_value%TYPE,
        pt_i_filesetid             IN    xxmx_migration_headers.file_set_id%TYPE,
        pt_i_migrationsetid        IN    xxmx_migration_headers.migration_set_id%TYPE,
        pv_o_returnstatus          OUT   VARCHAR2
    ) IS

        v_select_sql            VARCHAR2(250);
        v_update_sql            VARCHAR2(250);
        v_rowid                 VARCHAR2(200);
        l_task_number           VARCHAR2(250);
        v_table_name            VARCHAR2(250);
        v_task_number           VARCHAR2(250);
        TYPE v_projects_record IS RECORD (
		     rid                VARCHAR2(250),
             v_task_number      VARCHAR2(250)
                                             );
        TYPE v_projects_tbl IS
            TABLE OF v_projects_record INDEX BY BINARY_INTEGER;
        v_projects_tb              v_projects_tbl := v_projects_tbl();


  CURSOR upd_evt_rank IS
  select project_number, ar_invoice_number,  dense_rank() over ( partition by project_number order by ar_invoice_number) rnk
  from (
    select distinct x.project_number, x.attribute6 ar_invoice_number
    from   xxmx_ppm_prj_billevent_xfm x  
    where  1=1 --x.MIGRATION_SET_ID = pt_i_migrationsetid
      and  x.attribute7 = 'CLOSED_AR'
      and  x.attribute6 is not null
/*    union
    select project_number, ar_invoice_number 
    from XXMX_XFM.XXMX_PPM_LIC_UNPAID_XFM 
    where cost_type = 'CLOSED_AR'
    and ar_invoice_number is not null */
    );      


   CURSOR upd_open_ar_batch IS
   select project_number, ar_invoice_number,  dense_rank() over ( partition by project_number order by ar_invoice_number) comb_open_ar_rnk
   from (
    select project_number, ar_invoice_number    
    from XXMX_PPM_PRJ_LBRCOST_XFM 
    where cost_type = 'OPEN_AR'
    and ar_invoice_number is not null
    union
    select project_number, ar_invoice_number
    from XXMX_PPM_PRJ_miscCOST_XFM
    where cost_type = 'OPEN_AR'
    and ar_invoice_number is not null
    union
    select project_number, attribute6 ar_invoice_number
    from XXMX_PPM_PRJ_BILLEVENT_XFM
    where attribute7 = 'OPEN_AR'
    and attribute6 is not null
/*    union 
    select project_number, ar_invoice_number 
    from XXMX_XFM.XXMX_PPM_LIC_UNPAID_XFM 
    where cost_type = 'OPEN_AR'
    and ar_invoice_number is not null */
   );



    BEGIN

        BEGIN

          IF pt_i_businessentity like 'PRJ_COST' THEN

            UPDATE xxmx_ppm_prj_lbrcost_xfm x 
               set x.task_number = nvl((select xmm.output_code_1
                                    from xxmx_mapping_master xmm
                                     WHERE
                                           xmm.application     = 'PPM'
					                   AND xmm.category_code   = 'TASK_NUMBER'
                                       AND upper(xmm.input_code_1) = upper(x.task_number) 
                                       AND ROWNUM = 1
                                       ),x.task_number)
                --where  x.MIGRATION_SET_ID = pt_i_migrationsetid
                ;

            UPDATE xxmx_ppm_prj_misccost_xfm x 
               set x.task_number = nvl((select xmm.output_code_1
                                    from xxmx_mapping_master xmm
                                     WHERE
                                           xmm.application     = 'PPM'
					                   AND xmm.category_code   = 'TASK_NUMBER'
                                       AND upper(xmm.input_code_1) = upper(x.task_number) 
                                       AND ROWNUM = 1
                                       ),x.task_number)
                 ,x.RAW_COST_CR_ACCOUNT = (select case when x.expenditure_type like 'Licen%' 
                                                       then nvl(x.RAW_COST_CR_ACCOUNT,substr(x.RAW_COST_DR_ACCOUNT,1,5)||'021070.000.00.0000.0000')
                                                       else nvl(x.RAW_COST_CR_ACCOUNT,substr(x.RAW_COST_DR_ACCOUNT,1,5)||'031000.000.00.0000.0000')
                                                  end case
                                           from dual)
                --where  x.MIGRATION_SET_ID = pt_i_migrationsetid
                ;

            UPDATE xxmx_ppm_prj_lbrcost_xfm x 
               set x.BUSINESS_UNIT = nvl((select xmm.output_code_1
                                    from xxmx_mapping_master xmm
                                     WHERE
                                           xmm.application     = 'PPM'
					                   AND xmm.category_code   = 'BUSINESS_UNIT'
                                       AND upper(xmm.input_code_1) = upper(x.BUSINESS_UNIT) 
                                       AND ROWNUM = 1
                                       ),x.BUSINESS_UNIT)
                  ,x.acct_rate_type = decode(x.acct_rate_type,'Spot','User','User','User',null,null,x.acct_rate_type)
                  ,x.DENOM_BURDENED_COST = null
                  ,x.ACCT_BURDENED_COST  = null
                  ,x.ACCT_EXCHANGE_ROUNDING_LIMIT = decode(x.acct_rate_type,null,null,x.acct_raw_cost * 0.1)
                  ,x.EXPENDITURE_COMMENT = replace(x.EXPENDITURE_COMMENT,'"','')
               --where  x.MIGRATION_SET_ID = pt_i_migrationsetid
               ;


            UPDATE xxmx_ppm_prj_misccost_xfm x 
               set x.BUSINESS_UNIT = nvl((select xmm.output_code_1
                                    from xxmx_mapping_master xmm
                                     WHERE
                                           xmm.application     = 'PPM'
					                   AND xmm.category_code   = 'BUSINESS_UNIT'
                                       AND upper(xmm.input_code_1) = upper(x.BUSINESS_UNIT) 
                                       AND ROWNUM = 1
                                       ),x.BUSINESS_UNIT)
                  ,x.acct_rate_type = decode(x.acct_rate_type,'Spot','User','User','User',null,null,x.acct_rate_type)
                  ,x.DENOM_BURDENED_COST = null
                  ,x.ACCT_BURDENED_COST  = null
                  ,x.ACCT_EXCHANGE_ROUNDING_LIMIT = decode(x.acct_rate_type,null,null,x.acct_raw_cost * 0.1)
                  ,x.EXPENDITURE_COMMENT = replace(x.EXPENDITURE_COMMENT,'"','')
               --where  x.MIGRATION_SET_ID = pt_i_migrationsetid
               ;

            UPDATE xxmx_ppm_prj_lbrcost_xfm x 
               set x.ORGANIZATION_NAME = nvl((select xmm.output_code_1
                                    from xxmx_mapping_master xmm
                                     WHERE
                                           xmm.application     = 'HR'
					                   AND xmm.category_code   = 'PPM_ORG'
                                       AND upper(xmm.input_code_1) = upper(x.ORGANIZATION_NAME) 
                                       AND ROWNUM = 1
                                       ),x.ORGANIZATION_NAME)
               --where  x.MIGRATION_SET_ID = pt_i_migrationsetid
               ;

            UPDATE xxmx_ppm_prj_misccost_xfm x 
               set x.ORGANIZATION_NAME = nvl((select xmm.output_code_1
                                    from xxmx_mapping_master xmm
                                     WHERE
                                           xmm.application     = 'HR'
					                   AND xmm.category_code   = 'PPM_ORG'
                                       AND upper(xmm.input_code_1) = upper(x.ORGANIZATION_NAME) 
                                       AND ROWNUM = 1
                                       ),x.ORGANIZATION_NAME)
               --where  x.MIGRATION_SET_ID = pt_i_migrationsetid
               ;


           xxmx_citco_fin_ext_pkg.transform_code_combo(
                                                 pt_i_applicationsuite     ,
                                                 pt_i_application          ,
                                                 pt_i_businessentity       ,
                                                 pt_i_stgpopulationmethod   ,
                                                 pt_i_filesetid             ,
                                                 pt_i_migrationsetid        ,
                                                 pv_o_returnstatus          
                                                 );


            UPDATE xxmx_ppm_prj_lbrcost_xfm x 
               SET x.attribute3 = decode(x.cost_type,'OPEN_AR',x.AR_INVOICE_NUMBER,null)
                  ,x.USER_TRANSACTION_SOURCE = 'CONVERSION'
                  ,x.DOCUMENT_NAME = 'CONVERSION'
                  ,x.DOC_ENTRY_NAME = 'CONVERSION - Labor'
                  ,x.hcm_assignment_name = null
                  --,x.gl_date = null
                  --,x.attribute1 = null
                  ,x.unmatched_negative_txn_flag = decode(sign(x.denom_raw_cost),-1,'Y',null)
            --where  x.MIGRATION_SET_ID = pt_i_migrationsetid
            ;


            UPDATE xxmx_ppm_prj_misccost_xfm x 
               SET x.attribute3 = decode(x.cost_type,'OPEN_AR',x.AR_INVOICE_NUMBER,null)
                  ,x.USER_TRANSACTION_SOURCE = 'CONVERSION'
                  ,x.DOCUMENT_NAME = 'CONVERSION'
                  ,x.DOC_ENTRY_NAME = 'CONVERSION - Miscellaneous'
                  ,x.hcm_assignment_name = null
                  --,x.gl_date = null
                  --,x.attribute1 = null
                  ,x.unmatched_negative_txn_flag = decode(sign(x.denom_raw_cost),-1,'Y',null)
                  ,x.unit_of_measure = decode(x.unit_of_measure,'Currency','DOLLARS',x.unit_of_measure)
             --where  x.MIGRATION_SET_ID = pt_i_migrationsetid
             ;


            UPDATE xxmx_ppm_prj_lbrcost_xfm x 
               SET x.exp_batch_name = x.cost_type
            where  1=1 --x.MIGRATION_SET_ID = pt_i_migrationsetid
              and  x.cost_type = 'UNBILLED';

            UPDATE xxmx_ppm_prj_misccost_xfm x 
               SET x.exp_batch_name = x.cost_type
            where  1=1 --x.MIGRATION_SET_ID = pt_i_migrationsetid
              and  x.cost_type = 'UNBILLED';

            COMMIT;

--FX updates here.

            UPDATE xxmx_ppm_prj_lbrcost_xfm x 
               SET x.attribute4 = to_char(x.expenditure_item_date,'DD-MON-YYYY')
            where  1=1 --x.MIGRATION_SET_ID = pt_i_migrationsetid
              and  x.acct_rate_type is not null
              and  x.attribute5 is not null
              and  x.cost_type != 'UNBILLED'
              ;

            UPDATE xxmx_ppm_prj_lbrcost_xfm x 
               SET x.expenditure_item_date = to_date(x.attribute5,'DD-MON-YYYY')
            where  1=1 --x.MIGRATION_SET_ID = pt_i_migrationsetid
              and  x.acct_rate_type is not null
              and  x.attribute5 is not null
              and  x.cost_type != 'UNBILLED'
              ;

            UPDATE xxmx_ppm_prj_lbrcost_xfm x 
               SET x.attribute5 = null
            where  1=1 --x.MIGRATION_SET_ID = pt_i_migrationsetid
              and  x.attribute5 is not null
              ;

            UPDATE xxmx_ppm_prj_misccost_xfm x 
               SET x.attribute4 = to_char(x.expenditure_item_date,'DD-MON-YYYY')
            where  1=1 --x.MIGRATION_SET_ID = pt_i_migrationsetid
              and  x.acct_rate_type is not null
              and  x.attribute5 is not null
              and  x.cost_type != 'UNBILLED'
              ;

            UPDATE xxmx_ppm_prj_misccost_xfm x 
               SET x.expenditure_item_date = to_date(x.attribute5,'DD-MON-YYYY')
            where  1=1 --x.MIGRATION_SET_ID = pt_i_migrationsetid
              and  x.acct_rate_type is not null
              and  x.attribute5 is not null
              and  x.cost_type != 'UNBILLED'
              ;

            UPDATE xxmx_ppm_prj_misccost_xfm x 
               SET x.attribute5 = null
            where  1=1 --x.MIGRATION_SET_ID = pt_i_migrationsetid
              and  x.attribute5 is not null
              ;



          ELSE

            --Delete revenue sundry line as event type is setup for both billing and revenue, added by Milind on 22-FEB-2023 as it is wrong as per Eimear SIT recon.
            
             DELETE FROM xxmx_ppm_prj_billevent_xfm x 
             where  1=1 --x.MIGRATION_SET_ID = pt_i_migrationsetid
             --and    x.attribute5 = 'BOTH_BILL_REV_EVENT'
             and    x.task_number = 'SUNDRY'
             and    x.attribute10 = 'REVENUE';


--FX updates here.

            UPDATE xxmx_ppm_prj_billevent_xfm x 
               SET x.attribute_date2 = to_date(x.completion_date,'DD-MON-RR')
            where  1=1 --x.MIGRATION_SET_ID = pt_i_migrationsetid
              and  x.attribute9 is not null
              and exists (select null from xxmx_ppm_projects_stg r
                          where r.project_number = x.project_number 
                            and x.bill_trns_currency_code <> r.project_currency_code);


            UPDATE xxmx_ppm_prj_billevent_xfm x 
               SET x.completion_date = x.attribute9
            where  1=1 --x.MIGRATION_SET_ID = pt_i_migrationsetid
              and  x.attribute9 is not null
              and exists (select null from xxmx_ppm_projects_stg r
                          where r.project_number = x.project_number 
                            and x.bill_trns_currency_code <> r.project_currency_code);

            UPDATE xxmx_ppm_prj_billevent_xfm x 
               SET x.attribute9 = null
            where  1=1 --x.MIGRATION_SET_ID = pt_i_migrationsetid
              and  x.attribute9 is not null;

            COMMIT;

/*
             UPDATE xxmx_ppm_prj_billevent_xfm x
                SET x.attribute6 = null
                   ,x.attribute8 = null
                   ,x.attribute9 = null
             where  1=1 --x.MIGRATION_SET_ID = pt_i_migrationsetid
             and    x.attribute10 = 'REVENUE';
*/


            UPDATE xxmx_ppm_prj_billevent_xfm x 
               set x.task_number = nvl((select xmm.output_code_1
                                    from xxmx_mapping_master xmm
                                     WHERE
                                           xmm.application     = 'PPM'
					                   AND xmm.category_code   = 'TASK_NUMBER'
                                       AND upper(xmm.input_code_1) = upper(x.task_number) 
                                       AND ROWNUM = 1
                                       ),x.task_number)
                --where  x.MIGRATION_SET_ID = pt_i_migrationsetid
                ;


            UPDATE xxmx_ppm_prj_billevent_xfm x 
               set x.ORGANIZATION_NAME = nvl((select xmm.output_code_1
                                    from xxmx_mapping_master xmm
                                     WHERE
                                           xmm.application     = 'PPM'
					                   AND xmm.category_code   = 'BUSINESS_UNIT'
                                       AND upper(xmm.input_code_1) = upper(x.ORGANIZATION_NAME) 
                                       AND ROWNUM = 1
                                       ),x.ORGANIZATION_NAME)
               --where  x.MIGRATION_SET_ID = pt_i_migrationsetid
               ;


             UPDATE xxmx_ppm_prj_billevent_xfm x 
               set x.event_type_name = (select CASE when x.event_type_name = 'Adjustment' and  x.attribute7 != 'CLOSED_AR' and x.attribute10 = 'BILLING' then 'INVADJ'
                                                    when x.event_type_name = 'Adjustment' and  x.attribute7 != 'CLOSED_AR' and x.attribute10 = 'REVENUE' then 'REVADJ'
                                                    when x.event_type_name = 'Retainer'   and  x.attribute7 != 'CLOSED_AR' and x.attribute10 = 'BILLING' then 'INVRET'
                                                    when x.event_type_name = 'Retainer'   and  x.attribute7 != 'CLOSED_AR' and x.attribute10 = 'REVENUE' then 'REVRET'
                                                    when x.event_type_name = 'Deferred Revenue'                            and x.attribute10 = 'REVENUE' then 'REVDEF'
                                                    when x.event_type_name = 'Deferred Revenue'                            and x.attribute10 = 'BILLING' then 'INV'       --Added for JIRA 27045
                                                    when x.event_type_name = 'License Fee'                                                               then 'CONV_LICENSE_FEE'
                                                    when x.event_type_name = 'License Fee Penalty'                                                       then 'CONV_LICENSE_FEE_PENALTY'
                                                    when x.event_type_name = 'Revenue Accrual'                                                           then 'REVACC'
                                                    when x.event_type_name = 'Sundry Charges'                                                            then 'SUNDRY'
                                                    when x.event_type_name = 'TAX-DM'                                                                    then 'CONV_TAX'
                                                    when x.event_type_name = 'Manual'  and  x.attribute7 = 'CLOSED_AR' and x.attribute10 = 'BILLING'     then 'CONV_INV'
                                                    when x.event_type_name = 'Manual'  and  x.attribute7 = 'CLOSED_AR' and x.attribute10 = 'REVENUE'     then 'CONV_REV'
                                                    when x.event_type_name = 'Deferred Revenue'  and  x.attribute7 = 'CLOSED_AR'                         then 'CONV_REV'
                                                    when x.event_type_name = 'Manual'  and  x.attribute7 != 'CLOSED_AR' and x.attribute10 = 'BILLING'    then 'INV'
                                                    when x.event_type_name = 'Manual'  and  x.attribute7 != 'CLOSED_AR' and x.attribute10 = 'REVENUE'    then 'REV'
                                                    when x.event_type_name = 'Adjustment' and  x.attribute7 = 'CLOSED_AR' and x.attribute10 = 'BILLING'  then 'CONV_INV'
                                                    when x.event_type_name = 'Adjustment' and  x.attribute7 = 'CLOSED_AR' and x.attribute10 = 'REVENUE'  then 'CONV_REV'
                                                END CASE from dual)
                --where  x.MIGRATION_SET_ID = pt_i_migrationsetid
                ;

             UPDATE xxmx_ppm_prj_billevent_xfm x 
                SET    x.event_desc = x.event_type_name
                where  1=1 --x.MIGRATION_SET_ID = pt_i_migrationsetid
                and    x.event_desc = 'Manual';

             UPDATE xxmx_ppm_prj_billevent_xfm x 
                SET    x.event_desc = x.event_type_name
                where  1=1 --x.MIGRATION_SET_ID = pt_i_migrationsetid
                and    x.event_desc = 'Sundry Charges';

            UPDATE xxmx_ppm_prj_billevent_xfm x 
               set x.sourcename = 'ORACLE_EBS'
                  ,x.sourceref  = decode(x.task_number,'TAX',x.attribute3||'-'||x.event_type_name||'-'||x.attribute6,
                                                       'SUNDRY',x.attribute3||'-'||x.event_type_name||'-'||x.attribute10,
                                                       x.attribute3||'-'||x.event_type_name)
               -- where  x.MIGRATION_SET_ID = pt_i_migrationsetid
                ; 

            UPDATE xxmx_ppm_prj_billevent_xfm x 
               set --,x.bill_hold_flag = decode(x.attribute7,'CLOSED_AR','N',x.bill_hold_flag)
                   x.bill_hold_flag = decode(x.attribute10,'REVENUE','N',nvl(x.bill_hold_flag,'N'))
                  --,x.revenue_hold_flag = decode(x.attribute7,'CLOSED_AR','N',x.revenue_hold_flag)
                  ,x.revenue_hold_flag = nvl(x.revenue_hold_flag,'N')
                  ,x.contract_type_name = 'Default Contract Type'
                  ,x.contract_number = x.project_number
                  ,x.contract_line_number = decode(x.task_number,'SUNDRY','SUNDRY_1',x.task_number)
                  ,x.event_desc = replace(x.event_desc,'"','')
/*                  ,x.contract_line_number = (select l.line_number 
                                             from xxmx_ppm_cont_lines l 
                                             where l.header_ext_key = x.project_number ||'HEK' 
                                               and l.task_number = x.task_number 
                                               and rownum < 2) */
                --where  x.MIGRATION_SET_ID = pt_i_migrationsetid
                ;

            COMMIT;

          FOR b in upd_evt_rank LOOP
           BEGIN

            UPDATE xxmx_ppm_prj_billevent_xfm x
               SET x.attribute10 = x.attribute7 || '_' ||to_char(b.rnk)
                  ,x.attribute9  = to_char(b.rnk)
            WHERE  x.project_number = b.project_number
              AND  x.attribute6     = b.ar_invoice_number
              and  x.attribute7 = 'CLOSED_AR'
               and nvl(x.attribute10,'N') not like 'OPEN%' 
               and nvl(x.attribute10,'N') not like 'REVE%' 
               and nvl(x.attribute10,'N') not like 'UNBILL%';

/*
            UPDATE XXMX_XFM.XXMX_PPM_LIC_UNPAID_XFM x
               SET x.AP_LIC_FEE_RANK = to_char(b.rnk)
                  ,x.batch_name = x.cost_type || '_' || to_char(b.rnk)
            WHERE  x.project_number = b.project_number
               and x.ar_invoice_number = b.ar_invoice_number
               and x.cost_type = 'CLOSED_AR';
*/
           EXCEPTION
             WHEN OTHERS THEN null;
           END;
          END LOOP;     

            UPDATE xxmx_ppm_prj_billevent_xfm x 
               SET x.attribute10 = x.attribute7
            where  1=1 --x.MIGRATION_SET_ID = pt_i_migrationsetid
              and   x.attribute7 = 'UNBILLED'
              and   x.event_type_name not like 'REV%'; 


          END IF;

--Stamp common rank and batch on all transactions.

          FOR b in upd_open_ar_batch LOOP
        --  dbms_output.put_line('rank '||b.comb_open_ar_rnk );
           BEGIN
            UPDATE xxmx_ppm_prj_lbrcost_xfm x
               SET x.attribute9 = to_char(b.comb_open_ar_rnk)
                  ,x.exp_batch_name = x.cost_type || '_' || to_char(b.comb_open_ar_rnk)
            WHERE  x.project_number = b.project_number
               and x.ar_invoice_number = b.ar_invoice_number
               and x.cost_type = 'OPEN_AR';
           EXCEPTION
             WHEN OTHERS THEN null;
           END;

           BEGIN
            UPDATE xxmx_ppm_prj_misccost_xfm x
               SET x.attribute9 = to_char(b.comb_open_ar_rnk)
                  ,x.exp_batch_name = x.cost_type || '_' || to_char(b.comb_open_ar_rnk)
            WHERE  x.project_number = b.project_number
               and x.ar_invoice_number = b.ar_invoice_number
               and x.cost_type = 'OPEN_AR'; 
           EXCEPTION
             WHEN OTHERS THEN null;
           END;

           BEGIN
            UPDATE xxmx_ppm_prj_billevent_xfm x
               SET x.attribute10 = 'OPEN_AR' || '_' ||to_char(b.comb_open_ar_rnk)
                  ,x.attribute9  = to_char(b.comb_open_ar_rnk)
            WHERE  x.project_number = b.project_number
               and x.attribute6 = b.ar_invoice_number
               and nvl(x.attribute10,'N') not like 'CLOSED%' 
               and nvl(x.attribute10,'N') not like 'REVE%' 
               and nvl(x.attribute10,'N') not like 'UNBILL%' 
               ;
           EXCEPTION
             WHEN OTHERS THEN null;
           END;
/*
          BEGIN
            UPDATE XXMX_XFM.XXMX_PPM_LIC_UNPAID_XFM x
               SET x.AP_LIC_FEE_RANK = to_char(b.comb_open_ar_rnk)
                  ,x.batch_name = x.cost_type || '_' || to_char(b.comb_open_ar_rnk)
            WHERE  x.project_number = b.project_number
               and x.ar_invoice_number = b.ar_invoice_number
               and x.cost_type = 'OPEN_AR';
           EXCEPTION
             WHEN OTHERS THEN null;
           END; 
*/
          END LOOP;

            COMMIT;


          IF pt_i_businessentity not like 'PRJ_COST' THEN

            UPDATE xxmx_ppm_prj_billevent_xfm x 
               SET x.attribute10 = attribute7||'-'||'REVENUE'
                  ,x.reverse_accrual_flag = decode(x.event_type_name,'REVACC','Y',null)
            where  1=1 --x.MIGRATION_SET_ID = pt_i_migrationsetid
              and  x.attribute7 = 'CLOSED_AR'
              and  ( x.event_type_name like 'REV%' or x.event_type_name like '%REV');


            UPDATE xxmx_ppm_prj_billevent_xfm x 
               SET x.attribute10 = 'REVENUE'
                  ,x.reverse_accrual_flag = decode(x.event_type_name,'REVACC','Y',null)
            where  1=1 --x.MIGRATION_SET_ID = pt_i_migrationsetid
              and  x.attribute7 != 'CLOSED_AR'
              and  ( x.event_type_name like 'REV%' or x.event_type_name like '%REV');


--Blank out DFF not required in events.
            
               UPDATE xxmx_ppm_prj_billevent_xfm x 
               set x.attribute3 = null 
                  ,x.attribute4 = null 
                  ,x.attribute5 = null                   
                  ,x.attribute7 = null 
                  ,x.attribute_date10 = null
             ; 

           END IF;
           
        EXCEPTION
            WHEN OTHERS THEN
                v_table_name := NULL;
                dbms_output.put_line('Error in Procedure xxmx_ppm_ext_pkg.transform_task_number');
                dbms_output.put_line('Error Message :' || sqlerrm);
                dbms_output.put_line('Error text :' || dbms_utility.format_error_backtrace);
                raise_application_error(-20111, 'Error text :' || dbms_utility.format_error_backtrace);
        END;     


        COMMIT;
--

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
         NULL;    
        WHEN OTHERS THEN

                --
            ROLLBACK;
            dbms_output.put_line('Error in Procedure xxmx_ppm_ext_pkg.transform_task_number');
            dbms_output.put_line('Error Message :' || sqlerrm);
            dbms_output.put_line('Error text :' || dbms_utility.format_error_backtrace);
            raise_application_error(-20111, 'Error text :' || dbms_utility.format_error_backtrace);
    END transform_task_number;
-- 
--

PROCEDURE copy_lic_fee_cost_to_evt
is
BEGIN

                 INSERT INTO xxmx_ppm_prj_billevent_xfm (
                                     migration_set_id                 
                                    ,migration_set_name               
                                    ,migration_status                 
                                    ,sourcename                 
                                         , sourceref                  
                                         , organization_name          
                                         , contract_type_name         
                                         , contract_number            
                                         , contract_line_number       
                                         , event_type_name            
                                         , event_desc                 
                                         , completion_date            
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
                                    ,batch_name                       
                                    ,batch_id                         
                                    ,last_updated_by                  
                                    ,created_by                       
                                    ,last_update_login                
                                    ,last_update_date                 
                                    ,creation_date                    
                             )
                             SELECT 
                                     d.migration_set_id                 
                                    ,d.migration_set_name               
                                    ,d.migration_status                 
                                    ,d.sourcename                 
                                         , c.task_number sourceref                  
                                         , c.business_unit organization_name          
                                         , d.contract_type_name         
                                         , d.contract_number            
                                         , d.contract_line_number       
                                         , c.expenditure_type    event_type_name            
                                         , c.expenditure_comment event_desc                 
                                         , c.EXPENDITURE_ITEM_DATE completion_date            
                                         , c.denom_currency_code bill_trns_currency_code    
                                         , c.denom_raw_cost      bill_trns_amount           
                                         , c.project_number             
                                         , c.task_number                
                                         , 'N' bill_hold_flag             
                                         , 'N' revenue_hold_flag          
                                         , null attribute_category         
                                         , null attribute1                     
                                         , null attribute2                 
                                         , c.attribute1        attribute3                 
                                         , null attribute4                 
                                         , null attribute5                 
                                         , c.AR_INVOICE_NUMBER attribute6                 
                                         , c.cost_type         attribute7                 
                                         , c.attribute8        attribute8                
                                         , null attribute9                 
                                         , 'BILLING'           attribute10	             
                                    ,d.batch_name                       
                                    ,d.batch_id                         
                                    ,d.last_updated_by                  
                                    ,d.created_by                       
                                    ,d.last_update_login                
                                    ,d.last_update_date                 
                                    ,d.creation_date
                              FROM (select *      
                                    FROM xxmx_ppm_prj_billevent_xfm 
                                    WHERE rownum < 2) d,
                                    (select cs.*  
                                     from xxmx_ppm_prj_misccost_stg cs 
                                     where cs.expenditure_type like 'Lic%' 
                                     and cs.cost_type = 'OPEN_AR'
                                     and cs.attribute1 in (select expenditure_item_id from xxmx_license_fee_apinv where payment_status_flag = 'Y' and  cost_type = 'OPEN_AR')
                                    ) c
                             WHERE 1=1;


END copy_lic_fee_cost_to_evt;

--
--
PROCEDURE copy_ppm_stg_to_xfm(
     --   pt_i_applicationsuite      IN    xxmx_seeded_extensions.application_suite%TYPE,
     --   pt_i_application           IN    xxmx_seeded_extensions.application%TYPE,
        pt_i_businessentity        IN    xxmx_seeded_extensions.business_entity%TYPE,
--        pt_i_subentity             IN    xxmx_seeded_extensions.business_entity%TYPE,
     --   pt_i_stgpopulationmethod   IN    xxmx_core_parameters.parameter_value%TYPE,
      --  pt_i_filesetid             IN    xxmx_migration_headers.file_set_id%TYPE,
        pt_i_migrationsetid        IN    xxmx_migration_headers.migration_set_id%TYPE
     --   pv_o_returnstatus          OUT   VARCHAR2
    )
is

BEGIN

IF pt_i_businessentity like 'PRJ_COST' THEN

DELETE FROM XXMX_PPM_PRJ_LBRCOST_XFM; -- WHERE migration_set_id = pt_i_migrationsetid;

INSERT INTO XXMX_PPM_PRJ_LBRCOST_XFM SELECT * FROM XXMX_PPM_PRJ_LBRCOST_STG; -- WHERE migration_set_id = pt_i_migrationsetid;

DELETE FROM XXMX_PPM_PRJ_MISCCOST_XFM; -- WHERE migration_set_id = pt_i_migrationsetid;

INSERT INTO XXMX_PPM_PRJ_MISCCOST_XFM SELECT * FROM XXMX_PPM_PRJ_MISCCOST_STG 
--WHERE migration_set_id = pt_i_migrationsetid 
--and expenditure_type not like 'Licen%'
;

ELSE

DELETE FROM XXMX_PPM_PRJ_BILLEVENT_XFM;  -- WHERE migration_set_id = pt_i_migrationsetid;

INSERT INTO XXMX_PPM_PRJ_BILLEVENT_XFM SELECT * FROM XXMX_PPM_PRJ_BILLEVENT_STG; -- WHERE migration_set_id = pt_i_migrationsetid;

/*
delete from xxmx_ppm_prj_billevent_xfm
where attribute1 in (
select attribute1 from (
select sum(decode(attribute10,'BILLING',1,'REVENUE',-1) * bill_trns_amount), attribute1
from  xxmx_ppm_prj_billevent_xfm 
group by attribute1
having sum(decode(attribute10,'BILLING',1,'REVENUE',-1) * bill_trns_amount) = 0
)
)
and attribute7 = 'CLOSED_AR'; 
*/


delete from xxmx_ppm_prj_billevent_xfm o
where o.attribute7 in ('CLOSED_AR','OPEN_AR','UNBILLED','REVACC')
and o.project_number||o.task_number||o.event_type_name||o.event_desc||o.attribute7 in 
(
select z.project_number||z.task_number||z.event_type_name||z.event_desc||z.attribute7
from xxmx_ppm_prj_billevent_xfm z
where z.event_type_name = 'Revenue Accrual'
and z.attribute7 in ('CLOSED_AR','OPEN_AR','UNBILLED','REVACC')
group by z.project_number, z.task_number, z.event_type_name, z.event_desc,z.attribute7
having sum(bill_trns_amount) = 0
);

--delete from XXMX_XFM.XXMX_PPM_LIC_UNPAID_XFM where invoice_number = '4050967ROC2020';

--copy_lic_fee_cost_to_evt;

END IF;

COMMIT;

EXCEPTION
WHEN OTHERS THEN

                --
            ROLLBACK;
            dbms_output.put_line('Error in Procedure xxmx_ppm_ext_pkg.copy_ppm_stg_to_xfm');
            dbms_output.put_line('Error Message :' || sqlerrm);
            dbms_output.put_line('Error text :' || dbms_utility.format_error_backtrace);
            raise_application_error(-20111, 'Error text :' || dbms_utility.format_error_backtrace);

END copy_ppm_stg_to_xfm;
--
PROCEDURE transform_trans(
        pt_i_applicationsuite      IN    xxmx_seeded_extensions.application_suite%TYPE,
        pt_i_application           IN    xxmx_seeded_extensions.application%TYPE,
        pt_i_businessentity        IN    xxmx_seeded_extensions.business_entity%TYPE,
--        pt_i_subentity             IN    xxmx_seeded_extensions.business_entity%TYPE,
        pt_i_stgpopulationmethod   IN    xxmx_core_parameters.parameter_value%TYPE,
        pt_i_filesetid             IN    xxmx_migration_headers.file_set_id%TYPE,
        pt_i_migrationsetid        IN    xxmx_migration_headers.migration_set_id%TYPE,
        pv_o_returnstatus          OUT   VARCHAR2
    )
is
/*
pt_i_applicationsuite VARCHAR2(100) :='PPM';
pt_i_application VARCHAR2(100) :='PPM';
pt_i_subentity VARCHAR2(100);
pt_i_stgpopulationmethod VARCHAR2(100) := 'DBLINK';
pt_i_filesetid VARCHAR2(100);
pv_o_returnstatus VARCHAR2(4000); 
*/
BEGIN

IF pt_i_businessentity like 'PRJ%' THEN

copy_ppm_stg_to_xfm(
     --   pt_i_applicationsuite      IN    xxmx_seeded_extensions.application_suite%TYPE,
     --   pt_i_application           IN    xxmx_seeded_extensions.application%TYPE,
        pt_i_businessentity       ,
--        pt_i_subentity             IN    xxmx_seeded_extensions.business_entity%TYPE,
     --   pt_i_stgpopulationmethod   IN    xxmx_core_parameters.parameter_value%TYPE,
      --  pt_i_filesetid             IN    xxmx_migration_headers.file_set_id%TYPE,
        pt_i_migrationsetid       
     --   pv_o_returnstatus          OUT   VARCHAR2
    );

transform_task_number(
        pt_i_applicationsuite     ,
        pt_i_application          ,
        pt_i_businessentity       ,
        pt_i_stgpopulationmethod   ,
        pt_i_filesetid             ,
        pt_i_migrationsetid        ,
        pv_o_returnstatus          
    );


END IF;
END transform_trans;
END xxmx_ppm_trans_ext_pkg;

/
