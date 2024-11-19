--------------------------------------------------------
--  DDL for Package Body XXMX_DM_PREVAL_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "XXMX_CORE"."XXMX_DM_PREVAL_PKG" AS
--
--//===============================================================================
--// Version1
--// $Id:$
--//===============================================================================
--// Object Name        :: xxmx_dm_preval_pkg.pkh
--//
--// Object Type        :: Package Specification
--//
--// Object Description :: This package contains procedure for all components   
--//                       pre-validation code for data migration from R12 to 
--//                       Oracle Cloud
--//
--// Version Control
--//===============================================================================
--// Version      Author               Date               Description
--//-------------------------------------------------------------------------------
--// 1.0          Milind Shanbhag       13/01/2022         Initial Build
--//===============================================================================
--
-- Package Type Variables
    l_count   NUMBER;
--
-- --------------------------------------------------------------------------------
-- |-----------------------< POPULATE PREVAL SUMMARY >----------------------------|
-- --------------------------------------------------------------------------------
--    
    PROCEDURE pop_preval_summ (p_load_name   IN  VARCHAR2
                              ,p_object_name IN  VARCHAR2
                              ,p_parameter   IN  VARCHAR2
                              ,p_tab         IN  VARCHAR2
                              ,p_col         IN  VARCHAR2
                              )
    IS
    --    
        l_sql_string VARCHAR2(5000);
    --    
        BEGIN

           l_sql_string :=  'INSERT INTO xxmx_dm_preval_summary 
                SELECT '''||p_load_name||'''
                      ,'''||p_object_name||'''
                      ,'''||p_parameter||'''
                      ,count(1)
                      ,nvl(s.'||p_col||', ''NULL VALUE'')
                      ,''Does not exist''
                      ,max(s.BATCH_ID)
                      ,max(s.BATCH_NAME)
                      ,max(s.CREATED_BY)
                      ,max(s.CREATION_DATE)
                      ,max(s.LAST_UPDATED_BY)
                      ,max(s.LAST_UPDATE_DATE)
                from  '||p_tab||' s
                where 1=1 
                and   not exists (select null 
                                  from   xxmx_dm_fusion_preval_data d
                                  where  s.'||p_col||' =  d.value
                                    and  d.load_name   = '''||p_load_name||'''
                                    and  d.object_name = '''||p_object_name||'''
                                    and  d.parameter   = '''||p_parameter||''')
                group by nvl(s.'||p_col||', ''NULL VALUE'')';
	--
--    dbms_output.put_line('l_sql_string : = ' ||l_sql_string);
        EXECUTE IMMEDIATE (l_sql_string);

        EXCEPTION
          WHEN OTHERS THEN NULL;
--
    END pop_preval_summ;
--
-- --------------------------------------------------------------------------------
-- |--------------------------< VALIDATE PPM >------------------------------------|
-- --------------------------------------------------------------------------------
--   
    PROCEDURE validate_ppm
         IS
    BEGIN

        BEGIN
         DELETE FROM xxmx_dm_preval_summary WHERE load_name = 'PPM';
        EXCEPTION
         WHEN others THEN null;
        END; 

     pop_preval_summ('PPM','PROJECT','TEMPLATE_NUMBER','xxmx_ppm_projects_xfm','source_template_number');
     pop_preval_summ('PPM','PROJECT','ORGANIZATION_NAME','xxmx_ppm_projects_xfm','ORGANIZATION_NAME');

    -- pop_preval_summ('PPM','XXPPM_EBS_OU_NAME','ATTRIBUTE1','xxmx_ppm_projects_stg','ATTRIBUTE1');
    -- pop_preval_summ('PPM','XXPPM_EBS_BSV','ATTRIBUTE2','xxmx_ppm_projects_stg','ATTRIBUTE2');
     pop_preval_summ('PPM','PROJECT','ORGANIZATION_NAME','xxmx_ppm_prj_lbrcost_xfm','ORGANIZATION_NAME');
     pop_preval_summ('PPM','PROJECT','ORGANIZATION_NAME','xxmx_ppm_prj_misccost_xfm','ORGANIZATION_NAME');
     pop_preval_summ('PPM','PROJECT_COSTS','BUSINESS_UNIT','xxmx_ppm_prj_lbrcost_xfm','BUSINESS_UNIT');
     pop_preval_summ('PPM','PROJECT_COSTS','BUSINESS_UNIT','xxmx_ppm_prj_misccost_xfm','BUSINESS_UNIT');
     pop_preval_summ('PPM','PROJECT_COSTS','BUSINESS_UNIT','xxmx_ppm_prj_billevent_xfm','ORGANIZATION_NAME');
     pop_preval_summ('PPM','PROJECT_COSTS','EXPENDITURE_TYPE_NAME','xxmx_ppm_prj_lbrcost_xfm','EXPENDITURE_TYPE');
     pop_preval_summ('PPM','PROJECT_COSTS','EXPENDITURE_TYPE_NAME','xxmx_ppm_prj_misccost_xfm','EXPENDITURE_TYPE');     
     --pop_preval_summ('PPM','PROJECT_COSTS','EXPENDITURE_TYPE_NAME','xxmx_po_distributions_stg','EXPENDITURE');
     pop_preval_summ('PPM','PROJECT_CLASSES','CLASS_CATEGORY','XXMX_PPM_PRJ_CLASS_XFM','CLASS_CATEGORY');
     pop_preval_summ('PPM','PROJECT_CLASSES','CLASS_CODE','XXMX_PPM_PRJ_CLASS_XFM','CLASS_CODE');
     pop_preval_summ('PPM','PROJECT_TEAM_MEMBER','PROJECT_ROLE_NAME','XXMX_PPM_PRJ_TEAM_MEM_XFM','PROJECT_ROLE_NAME');
--     pop_preval_summ('PPM','PROJECT','ORGANIZATION_NAME','xxmx_ppm_trx_control_stg','ORGANIZATION_NAME');
--     pop_preval_summ('PPM','PROJECT_COSTS','EXPENDITURE_TYPE_NAME','xxmx_ppm_trx_control_stg','EXPENDITURE_TYPE');
--     pop_preval_summ('PPM','PROJECT_COSTS','EXPENDITURE_TYPE_NAME','xxmx_po_distributions_stg','EXPENDITURE_TYPE');

    -- pop_preval_summ('PPM','PROJECT_CLASSES','CLASSIFICATION','xxmx_ppm_classifications_stg','CLASS_CATEGORY||'-'||s.CLASS_CODE');


        BEGIN
            INSERT INTO xxmx_dm_preval_summary 
            SELECT 'PPM'
                  ,'PROJECT_TRANSACTIONS'
                  ,'LABOR_COSTS'
                  ,count(1)
                  ,s.project_number||'-'||s.task_number
                  ,'Contract Line does not exist'
                  ,max(s.BATCH_ID)
                  ,max(s.BATCH_NAME)
                  ,max(s.CREATED_BY)
                  ,max(s.CREATION_DATE)
                  ,max(s.LAST_UPDATED_BY)
                  ,max(s.LAST_UPDATE_DATE)
            from  xxmx_ppm_prj_lbrcost_xfm s
            where 1=1 
            and   not exists (select null from xxmx_ppm_cont_task_int l 
                              where l.project_number = s.project_number and l.task_number = s.task_number)
            group by s.project_number||'-'||s.task_number;

            INSERT INTO xxmx_dm_preval_summary 
            SELECT 'PPM'
                  ,'PROJECT_TRANSACTIONS'
                  ,'MISC_COSTS'
                  ,count(1)
                  ,s.project_number||'-'||s.task_number
                  ,'Contract Line does not exist'
                  ,max(s.BATCH_ID)
                  ,max(s.BATCH_NAME)
                  ,max(s.CREATED_BY)
                  ,max(s.CREATION_DATE)
                  ,max(s.LAST_UPDATED_BY)
                  ,max(s.LAST_UPDATE_DATE)
            from  xxmx_ppm_prj_misccost_xfm s
            where 1=1 
            and   not exists (select null from xxmx_ppm_cont_task_int l 
                              where l.project_number = s.project_number and l.task_number = s.task_number)
            group by s.project_number||'-'||s.task_number;

            INSERT INTO xxmx_dm_preval_summary 
            SELECT 'PPM'
                  ,'PROJECT_TRANSACTIONS'
                  ,'EVENTS'
                  ,count(1)
                  ,s.project_number||'-'||s.task_number
                  ,'Contract Line does not exist'
                  ,max(s.BATCH_ID)
                  ,max(s.BATCH_NAME)
                  ,max(s.CREATED_BY)
                  ,max(s.CREATION_DATE)
                  ,max(s.LAST_UPDATED_BY)
                  ,max(s.LAST_UPDATE_DATE)
            from  xxmx_ppm_prj_billevent_xfm s
            where 1=1 
            and   not exists (select null from xxmx_ppm_cont_task_int l 
                              where l.project_number = s.project_number 
                              and l.task_number = decode(s.task_number,'SUNDRY','SUNDRY_1',s.task_number))
            group by s.project_number||'-'||s.task_number;


            INSERT INTO xxmx_dm_preval_summary 
            SELECT 'PPM'
                  ,'PROJECT'
                  ,'CUST_ACCOUNT_NUMBER'
                  ,count(1)
                  ,s.attribute1
                  ,'Customer Account Number does not exist'
                  ,max(s.BATCH_ID)
                  ,max(s.BATCH_NAME)
                  ,max(s.CREATED_BY)
                  ,max(s.CREATION_DATE)
                  ,max(s.LAST_UPDATED_BY)
                  ,max(s.LAST_UPDATE_DATE)
            from  xxmx_ppm_projects_xfm s
            where 1=1 
            and   not exists (select null from xxmx_hz_cust_accounts_xfm l 
                              where l.account_number = s.attribute1)
            group by s.attribute1;

            INSERT INTO xxmx_dm_preval_summary 
            SELECT 'PPM'
                  ,'PROJECT'
                  ,'CUST_ACCT_SITES'
                  ,count(1)
                  ,x.attribute1||'-'||decode(s.organization_name,'CA4421','CA4420','IE4351','IE4350','LU4371','LU4370','BM2430','KY2430',s.organization_name)
                  ,'Customer Account Site and OU Comb does not exist'
                  ,max(s.BATCH_ID)
                  ,max(s.BATCH_NAME)
                  ,max(s.CREATED_BY)
                  ,max(s.CREATION_DATE)
                  ,max(s.LAST_UPDATED_BY)
                  ,max(s.LAST_UPDATE_DATE)
            from  xxmx_ppm_projects_stg s, xxmx_ppm_projects_xfm x
            where 1=1 
            and s.project_number = x.project_number
            and   not exists (select null from xxmx_hz_cust_acct_sites_xfm l 
                              where l.CUST_ORIG_SYSTEM_REFERENCE = x.attribute1 
                                and l.ou_name = decode(s.organization_name,'CA4421','CA4420','IE4351','IE4350','LU4371','LU4370','BM2430','KY2430',s.organization_name))
            group by s.attribute1||'-'||decode(s.organization_name,'CA4421','CA4420','IE4351','IE4350','LU4371','LU4370','BM2430','KY2430',s.organization_name);



        EXCEPTION
         WHEN others THEN null;

        END;



/*
        BEGIN
            INSERT INTO xxmx_dm_preval_summary 
            SELECT 'PPM'
                  ,'PROJECT_CLASSES'
                  ,'CLASSIFICATION'
                  ,count(1)
                  ,nvl(s.CLASS_CATEGORY||'-'||s.CLASS_CODE, 'NULL VALUE')
                  ,'Does not exist'
                  ,max(s.BATCH_ID)
                  ,max(s.BATCH_NAME)
                  ,max(s.CREATED_BY)
                  ,max(s.CREATION_DATE)
                  ,max(s.LAST_UPDATED_BY)
                  ,max(s.LAST_UPDATE_DATE)
            from  xxmx_ppm_classifications_stg s
            where 1=1 
            and   not exists (select null 
                              from   xxmx_dm_fusion_preval_data d
                              where  s.CLASS_CATEGORY||'-'||s.CLASS_CODE =  d.value
                                and  d.load_name   = 'PPM'
                                and  d.object_name = 'PROJECT_CLASSES'
                                and  d.parameter   = 'CLASSIFICATION')
            group by nvl(s.CLASS_CATEGORY||'-'||s.CLASS_CODE, 'NULL VALUE');

        EXCEPTION
         WHEN others THEN null;

        END;
*/

/*
        BEGIN
            INSERT INTO xxmx_dm_preval_summary 
            SELECT 'PPM'
                  ,'PROJECT_COSTS'
                  ,'EXPENDITURE_TYPE_NAME'
                  ,count(1)
                  ,nvl(s.EXPENDITURE||':'||nvl(m.project_unit,'NULL_PU'), 'NULL VALUE')
                  ,'Does not exist'
                  ,max(s.BATCH_ID)
                  ,max(s.BATCH_NAME)
                  ,max(s.CREATED_BY)
                  ,max(s.CREATION_DATE)
                  ,max(s.LAST_UPDATED_BY)
                  ,max(s.LAST_UPDATE_DATE)
            from  xxmx_po_distributions_stg s, xxmx_project_master_p3_scope m
            where 1=1 
            and   s.project = m.project_number
            and   m.migrate_flag='Yes'
            and   m.project_unit is not null
            and   m.project_unit != 'IES'
            and   not exists (select null 
                              from   xxmx_dm_fusion_preval_data d
                              where  d.value like s.EXPENDITURE||'%'||nvl(m.project_unit,'xyz')||'%'
                                and  d.load_name   = 'PPM'
                                and  d.object_name = 'PROJECT_COSTS'
                                and  d.parameter   = 'EXPENDITURE_TYPE_NAME')
            group by nvl(s.EXPENDITURE||':'||nvl(m.project_unit,'NULL_PU'), 'NULL VALUE');

        EXCEPTION
         WHEN others THEN null;

        END;
*/

     commit;

    EXCEPTION
      WHEN others THEN null;


    END validate_ppm;
--   
-- --------------------------------------------------------------------------------
-- |--------------------------< VALIDATE SCM >------------------------------------|
-- --------------------------------------------------------------------------------
--   
    PROCEDURE validate_scm
         IS
    BEGIN

        BEGIN
         DELETE FROM xxmx_dm_preval_summary WHERE load_name = 'SUPPLIER';
        EXCEPTION
         WHEN others THEN null;
        END; 

     pop_preval_summ('SUPPLIER','SUPPLIER','SUPPLIER_TYPE','xxmx_AP_SUPP_STG','SUPPLIER_TYPE');



     commit;

    EXCEPTION
      WHEN others THEN null;


    END validate_scm;
--                            
-- --------------------------------------------------------------------------------
-- |------------------------< VALIDATE SUPPLIER TYPE >----------------------------|
-- --------------------------------------------------------------------------------
--

    PROCEDURE validate_supplier_type
        IS
    BEGIN
        SELECT
            COUNT(1)
        INTO
            l_count
        FROM dual;
           -- xxmx_ap_supp_stg stg;
		/*WHERE NOT EXISTS (SELECT 1 
							FROM xxmx_fusion_supp_types fusion
						   WHERE  stg.supplier_type =  fusion.supplier_type
						  );*/
/*
        IF
            l_count > 0
        THEN
            INSERT INTO xxmx_dm_preval_summary VALUES (
                'SUPPLIERS',
                'SUPPLIERS',
                 null,
                'FAIL',
                'Supplier Type not valid'
            );
		ELSE
			INSERT INTO xxmx_dm_preval_summary VALUES (
                'SUPPLIERS',
                'SUPPLIERS',
                 null,
                'SUCCESS',
                NULL
            );
        END IF;
*/


    END validate_supplier_type;

-- --------------------------------------------------------------------------------
-- |--------------------------< VALIDATE EMPLOYEE_EMAIL_ADDRESS >------------------|
-- --------------------------------------------------------------------------------
    PROCEDURE validate_employee_email_address
    IS
      BEGIN

        BEGIN
         DELETE FROM xxmx_dm_preval_summary WHERE load_name = 'EMPLOYEE';
        EXCEPTION
         WHEN others THEN null;
        END; 

     pop_preval_summ('EMPLOYEE','EMPLOYEE','EMPLOYEE_EMAIL_ADDRESS','xxmx_FA_MASS_ADDITION_DIST_STG','EMPLOYEE_EMAIL_ADDRESS');
     commit;

    EXCEPTION
      WHEN others THEN null;

      END validate_employee_email_address;

--rk12012022
--
-- --------------------------------------------------------------------------------
-- |--------------------< VALIDATE CROSS VALIDATION RULE >------------------------|
-- --------------------------------------------------------------------------------
--  
/*
PROCEDURE validate_cvr ( p_iteration VARCHAR2
                                         ,p_load_name      VARCHAR2
                                         ,p_object_name  VARCHAR2
                                         ,p_rule_code        VARCHAR2 
                                         ,p_con_include_exclude VARCHAR2
                                         ,p_val_include_exclude VARCHAR2)
IS
--
CURSOR column_name_cur
    IS
        SELECT A.column_name con_segment,b.column_name val_segment  
        FROM dba_tab_columns A,dba_tab_columns b 
        WHERE A.table_name='xxmx_TRIAL_BALANCES_STG'
        AND A.table_name=b.table_name
        AND A.column_name IN(SELECT DISTINCT con_segment 
                             FROM xxmx_dm_fusion_crv_data  
                             WHERE rule_code =p_rule_code
        AND con_include_exclude='INCLUDE')
        AND b.column_name IN(SELECT DISTINCT val_segment 
                                                FROM xxmx_dm_fusion_crv_data  
                                                WHERE rule_code =p_rule_code);
--
l_sql         VARCHAR2(5000);
l_con_include_exclude VARCHAR2(10);
l_val_include_exclude VARCHAR2(10);
BEGIN

        FOR rec_column_name_cur IN column_name_cur
            LOOP
            --  
                BEGIN
                dbms_output.put_line('print_ '||rec_column_name_cur.con_segment );
--
select decode(p_con_include_exclude ,'INCLUDE','IN','EXCLUDE','NOT IN' )
                                   into l_con_include_exclude from dual;
select decode(p_val_include_exclude ,'INCLUDE','NOT IN','EXCLUDE','IN' )
                                   into l_val_include_exclude from dual;

                 l_sql :=  'INSERT INTO xxmx_dm_preval_summary 
				                    SELECT DISTINCT '||''''|| 'TRAIL_BALANCE' ||''','  
                                                     ||''''|| 'TRAIL_BALANCE' ||''','
                                                     ||''''||rec_column_name_cur.con_segment ||' ~ '||rec_column_name_cur.val_segment ||''''||'
                                                     ,count(1)
                                                     , null,
                                                     ( SELECT DISTINCT description 
                                                       FROM xxmx_dm_fusion_crv_data
                                                       WHERE rule_code = '||''''|| p_rule_code ||''''|| 
                                                       ' AND con_segment = '||''''||rec_column_name_cur.con_segment ||''''|| ') error_message
 							                           ,batch_id
                                                       ,batch_name
                                                       ,created_by
                                                       ,trunc(creation_date)
                                                       ,last_updated_by
                                                       ,trunc(last_update_date)'
                                                     ||' FROM xxmx_trial_balances_stg 
                                    WHERE ' || rec_column_name_cur.con_segment ||
                                          ' '|| l_con_include_exclude || ' ( SELECT con_segment_value 
                                                 FROM xxmx_dm_fusion_crv_data
                                                 WHERE rule_code = '||''''|| p_rule_code ||''''|| 
                                                 ' AND con_segment = '||''''||rec_column_name_cur.con_segment ||''''||  ')' 
                                    ||' AND ' || rec_column_name_cur.val_segment || 
                                          ' '||  l_val_include_exclude || ' (SELECT val_segment_Value 
                                                FROM xxmx_dm_fusion_crv_data
                                                WHERE rule_code = '||''''|| p_rule_code ||''''|| 
                                                ' AND val_segment = '||''''|| rec_column_name_cur.val_segment ||''''|| ')
                                     GROUP BY batch_name, batch_id,created_by, trunc(creation_date),last_updated_by, trunc(last_update_date)';
--
 dbms_output.put_line('print_sql '|| l_sql );
--
                EXECUTE IMMEDIATE (l_sql);
--			
                EXCEPTION
                    WHEN OTHERS THEN
                    dbms_output.put_line('Error : ' || SUBSTR(SQLERRM, 1, 250));
                    ROLLBACK;
                END;
            END LOOP;
END validate_cvr;
*/
--rk12012022
--
-- --------------------------------------------------------------------------------
-- |-----------------------< HCM POPULATE PREVAL SUMMARY >----------------------------|
-- --------------------------------------------------------------------------------
--    
    PROCEDURE hcm_pop_preval_summ (p_load_name   IN  VARCHAR2
                              ,p_object_name IN  VARCHAR2
                              ,p_parameter   IN  VARCHAR2
                              ,p_tab         IN  VARCHAR2
                              ,p_col         IN  VARCHAR2
                              )
    IS
    --    
        l_sql_string VARCHAR2(5000);
    --    
        BEGIN

           l_sql_string :=  'INSERT INTO xxmx_dm_preval_summary 
                SELECT '''||p_load_name||'''
                      ,'''||p_object_name||'''
                      ,'''||p_parameter||'''
                      ,count(1)
                      ,nvl(s.'||p_col||', ''NULL VALUE'')
                      ,''Does not exist''
                      ,null --max(s.BATCH_ID)
                     ,null --max(s.BATCH_NAME)
                      ,max(s.CREATED_BY)
                      ,max(s.CREATION_DATE)
                      ,max(s.LAST_UPDATED_BY)
                      ,max(s.LAST_UPDATE_DATE)
                from  '||p_tab||' s
                where 1=1 
                and   not exists (select null 
                                  from   xxmx_dm_fusion_preval_data d
                                  where  s.'||p_col||' =  d.value
                                    and  d.load_name   = '''||p_load_name||'''
                                    and  d.object_name = '''||p_object_name||'''
                                    and  d.parameter   = '''||p_parameter||''')
                group by nvl(s.'||p_col||', ''NULL VALUE'')';
	--
    dbms_output.put_line('l_sql_string : = ' ||l_sql_string);
        EXECUTE IMMEDIATE (l_sql_string);
commit;
DBMS_OUTPUT.PUT_LINE('end of prevalidating summary ');
        EXCEPTION
          WHEN OTHERS THEN 
          DBMS_OUTPUT.PUT_LINE('Error in prevalidating hcm_pop_preval_summ '||sqlerrm);
--
    END hcm_pop_preval_summ;
--
-- --------------------------------------------------------------------------------
-- |--------------------< VALIDATE HCM DM >------------------------|
-- --------------------------------------------------------------------------------
--  
PROCEDURE validate_hcm
         IS
  l_stage VARCHAR2(200) :=NULL;
    BEGIN

        BEGIN
         DELETE FROM xxmx_dm_preval_summary WHERE load_name = 'HCM';
        EXCEPTION
         WHEN others THEN null;
        END; 
DBMS_OUTPUT.PUT_LINE('Prevalidating ');

        BEGIN

		l_stage:= 'location';
        hcm_pop_preval_summ('HCM','WORKER_HIRE','LOCATION_CODE','xxmx_per_assignments_m_xfm','location_code');
	    l_stage:= 'position';
        hcm_pop_preval_summ('HCM','WORKER_HIRE','POSITION_CODE','xxmx_per_assignments_m_xfm','position_code');
	    l_stage:= 'legal-employer';
        hcm_pop_preval_summ('HCM','WORKER_HIRE','LEGAL_EMPLOYER','xxmx_per_assignments_m_xfm','legal_employer_name');
	 --   l_stage:= 'bu';
     --   hcm_pop_preval_summ('HCM','WORKER_HIRE','BUSINESS_UNIT','xxmx_per_assignments_m_xfm','business_unit_name');

        EXCEPTION
         WHEN others THEN
		 DBMS_OUTPUT.PUT_LINE('Error in prevalidating '||l_stage);
    END;

  EXCEPTION
   WHEN others 
   THEN 
   null;
  END validate_hcm;

END xxmx_dm_preval_pkg;

/
