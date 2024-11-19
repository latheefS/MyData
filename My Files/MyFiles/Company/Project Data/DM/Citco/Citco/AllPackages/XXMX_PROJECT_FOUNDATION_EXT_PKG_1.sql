--------------------------------------------------------
--  DDL for Package Body XXMX_PROJECT_FOUNDATION_EXT_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "XXMX_CORE"."XXMX_PROJECT_FOUNDATION_EXT_PKG" 
AS
--//=====================================================================================================
--// Version1
--// $Id:$
--//=====================================================================================================
--// Object Name        :: xxmx_project_foundation_ext_pkg.pkb
--//
--// Object Type        :: Package Body
--//
--// Object Description :: This package contains Procedures for applying transformation rules after
--//                       copying from STG and applying simple transforms
--//
--// Version Control
--//=====================================================================================================
--// Version      Author               Date               Description
--//-----------------------------------------------------------------------------------------------------
--// 1.0          Rafikahmada Mujawar  25/01/2022         Initial Build
--//=====================================================================================================
--
---------------------------------------------------------------------------------------------------------
-- PROCEDURE: Transform_Projects
---------------------------------------------------------------------------------------------------------
--
	PROCEDURE transform_projects(
                     pt_i_ApplicationSuite           IN      xxmx_seeded_extensions.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_seeded_extensions.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_seeded_extensions.business_entity%TYPE
                    ,pt_i_StgPopulationMethod        IN      xxmx_core_parameters.parameter_value%TYPE
                    ,pt_i_FileSetID                  IN      xxmx_migration_headers.file_set_id%TYPE
                    ,pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pv_o_ReturnStatus                  OUT  VARCHAR2)
	 IS
    -- Cursor to get mapping values from XXMX_MAPPING_MASTER table
    CURSOR mapping_cur
    IS
        --
        SELECT *
        FROM  xxmx_mapping_master
        WHERE 1 = 1
		AND application_suite= 'PPM'
        AND application = 'PROJECTS';
--
    CURSOR XfmTableUpd_cur
                      (
                       pt_MigrationSetID               xxmx_ppm_projects_xfm.migration_set_id%TYPE
                      )
    IS
               --
               SELECT  migration_set_id
  			          ,source_application_code
                      ,project_number
					  ,proj_owning_org
                      ,source_template_number
               FROM    xxmx_ppm_projects_xfm
               WHERE   1 = 1
               AND     migration_set_id = pt_i_MigrationSetID
               FOR UPDATE;
--
-- Local Type Variables
    TYPE project_number_tbl  IS TABLE OF VARCHAR2(100) INDEX BY VARCHAR2(100);
    l_project_number_t  project_number_tbl;
    l_project_number VARCHAR2(240);
    TYPE project_own_org_tbl  IS TABLE OF VARCHAR2(100) INDEX BY VARCHAR2(100);
    l_project_own_org_t  project_own_org_tbl;
    l_project_own_org VARCHAR2(240);
    TYPE project_template_tbl  IS TABLE OF VARCHAR2(100) INDEX BY VARCHAR2(100);
    l_project_template_t  project_template_tbl;
    l_project_template VARCHAR2(240);
    TYPE team_member_role_tbl  IS TABLE OF VARCHAR2(100) INDEX BY VARCHAR2(100);
    l_team_member_role_t  team_member_role_tbl;
    l_team_member_role VARCHAR2(240);
    --
    l_start_time varchar2(30);
    ld_begin_date   date;
    --
	gv_location VARCHAR2(100);
    BEGIN
        --
        gv_location := NULL;
        l_start_time := TO_CHAR(systimestamp, 'DDMMYYYYHH24MISS');
        -- MA 07-12-2022 Project_finish_date to be set to 31/12/2050
        update xxmx_ppm_projects_xfm 
            set project_finish_date=to_date('31/12/2050','DD/MM/YYYY');
        --
        FOR mapping_rec IN mapping_cur
        --
        LOOP
		   BEGIN
        --
            IF mapping_rec.application   = 'PPM' AND
               mapping_rec.category_code = 'PROJECT_NUMBER'
            THEN
                --
                l_project_number_t (mapping_rec.input_code_1) := mapping_rec.output_code_1;
                --
        --
            ELSIF mapping_rec.application   = 'PPM' AND
               mapping_rec.category_code = 'PROJ_OWNING_ORG'
            THEN
                --
                l_project_own_org_t (mapping_rec.input_code_1) := mapping_rec.output_code_1;
                --
            ELSIF mapping_rec.application   = 'PPM' AND
               mapping_rec.category_code = 'PROJECT_TEMPLATE'
            THEN
                --
                l_project_template_t (mapping_rec.input_code_1) := mapping_rec.output_code_1;
                --
            ELSIF mapping_rec.application   = 'PPM' AND
               mapping_rec.category_code = 'TEAM_MEMBER_ROLE'
            THEN
                --
                l_team_member_role_t (mapping_rec.input_code_1) := mapping_rec.output_code_1;
                --
--
        END IF;
		  EXCEPTION
                WHEN NO_DATA_FOUND
                THEN NULL;
          END;
        --
       END LOOP;
--
        	BEGIN
--
                FOR x in XfmTableUpd_cur(pt_i_MigrationSetID)
                LOOP
                   l_project_number    := nvl(l_project_number_t   (x.project_number), x.project_number);
                   l_project_own_org   := nvl(l_project_own_org_t  (x.proj_owning_org), x.proj_owning_org);
                   l_project_template  := nvl(l_project_template_t (x.source_template_number), x.source_template_number);
                   --
				   UPDATE xxmx_ppm_projects_xfm
                   SET    project_number          = l_project_number   --If Project Number changed from EBS to Cloud
				         ,organization_name       = l_project_own_org
						 ,source_template_number  = l_project_template
                   WHERE  CURRENT OF XfmTableUpd_cur;
                END LOOP;
--
        	EXCEPTION
                WHEN others
                THEN NULL;
--
            END;
        pv_o_ReturnStatus := 'S';
--
	END transform_projects;
--
---------------------------------------------------------------------------------------------------------
-- PROCEDURE: Transform_Tasks
---------------------------------------------------------------------------------------------------------
--
	PROCEDURE transform_tasks(
                     pt_i_ApplicationSuite           IN      xxmx_seeded_extensions.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_seeded_extensions.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_seeded_extensions.business_entity%TYPE
                    ,pt_i_StgPopulationMethod        IN      xxmx_core_parameters.parameter_value%TYPE
                    ,pt_i_FileSetID                  IN      xxmx_migration_headers.file_set_id%TYPE
                    ,pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pv_o_ReturnStatus                  OUT  VARCHAR2)
	 IS
    -- Cursor to get mapping values from XXMX_MAPPING_MASTER table
    CURSOR mapping_cur
    IS
        --
        SELECT *
        FROM  xxmx_mapping_master
        WHERE 1 = 1
		AND application_suite= 'PPM'
        AND application = 'TASKS';
--
    CURSOR XfmTableUpd_cur
                      (
                       pt_MigrationSetID               xxmx_ppm_prj_tasks_xfm.migration_set_id%TYPE
                      )
    IS
               --
               SELECT  migration_set_id
  			          ,source_application_code
                      ,project_number
			   FROM    xxmx_ppm_prj_tasks_xfm
               WHERE   1 = 1
               AND     migration_set_id = pt_i_MigrationSetID
               FOR UPDATE;
--
-- Local Type Variables
    TYPE project_number_tbl  IS TABLE OF VARCHAR2(100) INDEX BY VARCHAR2(100);
    l_project_number_t  project_number_tbl;
    l_project_number VARCHAR2(240);
    --
    l_start_time varchar2(30);
    ld_begin_date   date;
    --
	gv_location VARCHAR2(100);
    BEGIN
        --
        gv_location := NULL;
        l_start_time := TO_CHAR(systimestamp, 'DDMMYYYYHH24MISS');

        FOR mapping_rec IN mapping_cur
        --
        LOOP
		   BEGIN
        --
            IF mapping_rec.application   = 'PPM' AND
               mapping_rec.category_code = 'PROJECT_NUMBER'
            THEN
                --
                l_project_number_t (mapping_rec.input_code_1) := mapping_rec.output_code_1;
                --
        END IF;
		  EXCEPTION
                WHEN NO_DATA_FOUND
                THEN NULL;
          END;
        --
       END LOOP;
--
        	BEGIN
--
                FOR x in XfmTableUpd_cur(pt_i_MigrationSetID)
                LOOP
                   l_project_number      :=   nvl(l_project_number_t   (x.project_number), x.project_number);
                   --
				   UPDATE xxmx_ppm_prj_tasks_xfm
                   SET    project_number             = l_project_number   --If Project Number changed from EBS to Cloud
				         ,chargeable_flag            = 'Y'
						 ,billable_flag              = 'Y'
						 ,allow_cross_charge_flag    = 'Y'
						 ,cc_process_labor_flag      = 'Y'
						 ,cc_process_nl_flag         = 'Y'
                   WHERE  CURRENT OF XfmTableUpd_cur;
                END LOOP;
--
        	EXCEPTION
                WHEN others
                THEN NULL;
--
            END;
        pv_o_ReturnStatus := 'S';
--
	END transform_tasks;
--
---------------------------------------------------------------------------------------------------------
-- PROCEDURE: Transform_TeamMembers
---------------------------------------------------------------------------------------------------------
--
	PROCEDURE transform_team_members(
                     pt_i_ApplicationSuite           IN      xxmx_seeded_extensions.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_seeded_extensions.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_seeded_extensions.business_entity%TYPE
                    ,pt_i_StgPopulationMethod        IN      xxmx_core_parameters.parameter_value%TYPE
                    ,pt_i_FileSetID                  IN      xxmx_migration_headers.file_set_id%TYPE
                    ,pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pv_o_ReturnStatus                  OUT  VARCHAR2)
	 IS
    -- Cursor to get mapping values from XXMX_MAPPING_MASTER table
    CURSOR mapping_cur
    IS
        --
        SELECT *
        FROM  xxmx_mapping_master
        WHERE 1 = 1
		AND application_suite   = 'PPM'
        and business_entity     = 'PROJECT_FOUNDATION'
        AND sub_entity          = 'PROJECT_TEAM_MEMBER';

    CURSOR XfmTableUpd_cur
                      (
                       pt_MigrationSetID               xxmx_ppm_prj_team_mem_xfm.migration_set_id%TYPE
                      )
    IS
               --
               SELECT  migration_set_id
  			          ,project_role
			   FROM    xxmx_ppm_prj_team_mem_xfm
               WHERE   1 = 1
               AND     migration_set_id = pt_i_MigrationSetID
               FOR UPDATE;
--
-- Local Type Variables
    TYPE project_role_tbl  IS TABLE OF VARCHAR2(100) INDEX BY VARCHAR2(100);
    l_project_role_t  project_role_tbl;
    l_project_role VARCHAR2(240);
    --
    l_start_time varchar2(30);
    ld_begin_date   date;
    --
	gv_location VARCHAR2(100);
BEGIN
    -- REplace the code below with the update below the code
/*
        gv_location := NULL;
        l_start_time := TO_CHAR(systimestamp, 'DDMMYYYYHH24MISS');

        FOR mapping_rec IN mapping_cur
        LOOP
		   BEGIN
            IF mapping_rec.application   = 'PPM' AND
               mapping_rec.category_code = 'PROJECT_ROLE'
            THEN
                l_project_role_t (mapping_rec.input_code_1) := mapping_rec.output_code_1;
        END IF;
		  EXCEPTION
                WHEN NO_DATA_FOUND
                THEN NULL;
          END;
       END LOOP;
        	BEGIN
                FOR x in XfmTableUpd_cur(pt_i_MigrationSetID)
                LOOP
                   l_project_role      :=   nvl(l_project_role_t   (x.project_role), x.project_role);
                   --
				   UPDATE xxmx_ppm_prj_team_mem_xfm
                   SET    project_role          = l_project_role
                   WHERE  CURRENT OF XfmTableUpd_cur;
                END LOOP;
        	EXCEPTION
                WHEN others
                THEN NULL;
            END;
*/
    -- Map the EBS (source) to  Cloud (target) values
    UPDATE xxmx_ppm_prj_team_mem_xfm u
        SET     u.project_role          =
        nvl(
        (
            select      m.output_code_1
            from        xxmx_mapping_master m
            where       m.application_suite   = 'PPM'
            and         m.business_entity     = 'PROJECT_FOUNDATION'
            and         m.sub_entity          = 'PROJECT_TEAM_MEMBER'
            and         m.category_code       = 'PROJECT_ROLE'
            and         m.input_code_1        = u.project_role
        ), u.project_role) ;
    -- Check if there is a project with out both PM ans MD and report as ERROR
    begin
        insert into XXMX_MODULE_MESSAGES
            (
                MODULE_MESSAGE_ID
                ,APPLICATION_SUITE
                ,APPLICATION
                ,BUSINESS_ENTITY
                ,SUB_ENTITY
                ,MIGRATION_SET_ID
                ,PHASE
                ,MESSAGE_TIMESTAMP
                ,SEVERITY
                ,PACKAGE_NAME
                ,PROC_OR_FUNC_NAME
                ,PROGRESS_INDICATOR
                ,MODULE_MESSAGE 
            )
            select  
                XXMX_DATA_MESSAGE_IDS_S.nextval,'PPM','PPM','PROJECT_FOUNDATION','PROJECT_TEAM_MEMBER',pt_i_MigrationSetID,'MAPPING',
                sysdate,'ERROR','XXMX_PROJECT_FOUNDATION_EXT_PKG','transform_team_members','0020','Project '||project_name||' is missing a PM and MD'
            from xxmx_ppm_prj_team_mem_stg
            where project_role='Managing Director'
            and project_name in
            (
            select distinct project_name from  xxmx_ppm_prj_team_mem_stg 
            where project_name not in
                (select project_name from  xxmx_ppm_prj_team_mem_stg where project_role='Project Manager')
            );
        -- Use MD as PM for projects with no PM
        insert into xxmx_ppm_prj_team_mem_stg
        (
            MIGRATION_SET_ID                   ,
            MIGRATION_SET_NAME                 ,
            MIGRATION_STATUS                   ,
            PROJECT_NAME                       ,
            TEAM_MEMBER_NUMBER                 ,
            TEAM_MEMBER_NAME                   ,
            TEAM_MEMBER_EMAIL                  ,
            PROJECT_ROLE                       ,
            START_DATE_ACTIVE                  ,
            END_DATE_ACTIVE                    ,
            ALLOCATION                         ,
            LABOUR_EFFORT                      ,
            COST_RATE                          ,
            BILL_RATE                          ,
            TRACK_TIME_FLAG                    ,
            ASSIGNMENT_TYPE_CODE               ,
            BILLABLE_PERCENT                   ,
            BILLABLE_PERCENT_REASON_CODE       ,
            BATCH_ID                           ,
            BATCH_NAME                         ,
            LAST_UPDATED_BY                    ,
            CREATED_BY                         ,
            LAST_UPDATE_LOGIN                  ,
            LAST_UPDATE_DATE                   ,
            CREATION_DATE                      ,
            PROJECT_NUMBER                     ,
            ORGANIZATION_NAME                  
        )
        select 
            MIGRATION_SET_ID                   ,
            MIGRATION_SET_NAME                 ,
            MIGRATION_STATUS                   ,
            PROJECT_NAME                       ,
            TEAM_MEMBER_NUMBER                 ,
            TEAM_MEMBER_NAME                   ,
            TEAM_MEMBER_EMAIL                  ,
            'Project Manager'                  ,
            START_DATE_ACTIVE                  ,
            END_DATE_ACTIVE                    ,
            ALLOCATION                         ,
            LABOUR_EFFORT                      ,
            COST_RATE                          ,
            BILL_RATE                          ,
            TRACK_TIME_FLAG                    ,
            ASSIGNMENT_TYPE_CODE               ,
            BILLABLE_PERCENT                   ,
            BILLABLE_PERCENT_REASON_CODE       ,
            BATCH_ID                           ,
            BATCH_NAME                         ,
            LAST_UPDATED_BY                    ,
            CREATED_BY                         ,
            LAST_UPDATE_LOGIN                  ,
            LAST_UPDATE_DATE                   ,
            CREATION_DATE                      ,
            PROJECT_NUMBER                     ,
            ORGANIZATION_NAME                  
            from xxmx_ppm_prj_team_mem_stg
            where project_role='Managing Director'
            and project_name in
            (
                select distinct project_name from  xxmx_ppm_prj_team_mem_stg 
                where project_name not in
                    (select project_name from  xxmx_ppm_prj_team_mem_stg where project_role='Project Manager')
            );
   exception
        when no_data_found then
            -- No data found means the check passed and we have no projects with out both MD and PM
            null;
        when others then
            -- Error in SQL etc
            null;
    end;
    --
    pv_o_ReturnStatus := 'S';
--
	END transform_team_members;
--
---------------------------------------------------------------------------------------------------------
-- PROCEDURE: Transform_Classifications
---------------------------------------------------------------------------------------------------------
--
	PROCEDURE transform_classifications(
                     pt_i_ApplicationSuite           IN      xxmx_seeded_extensions.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_seeded_extensions.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_seeded_extensions.business_entity%TYPE
                    ,pt_i_StgPopulationMethod        IN      xxmx_core_parameters.parameter_value%TYPE
                    ,pt_i_FileSetID                  IN      xxmx_migration_headers.file_set_id%TYPE
                    ,pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pv_o_ReturnStatus                  OUT  VARCHAR2)
	 IS
    -- Cursor to get mapping values from XXMX_MAPPING_MASTER table
    CURSOR mapping_cur
    IS
        --
        SELECT *
        FROM  xxmx_mapping_master
        WHERE 1 = 1
		AND application_suite= 'PPM'
        AND application = 'CLASSIFICATION';

    CURSOR XfmTableUpd_cur
                      (
                       pt_MigrationSetID               xxmx_ppm_prj_class_xfm.migration_set_id%TYPE
                      )
    IS
               --
               SELECT  migration_set_id
  			          ,class_category
					  ,class_code
			   FROM    xxmx_ppm_prj_class_xfm
               WHERE   1 = 1
               AND     migration_set_id = pt_i_MigrationSetID
               FOR UPDATE;
--
-- Local Type Variables
    TYPE class_category_tbl  IS TABLE OF VARCHAR2(100) INDEX BY VARCHAR2(100);
    l_class_category_t  class_category_tbl;
    l_class_category VARCHAR2(240);
    --
    TYPE class_code_tbl  IS TABLE OF VARCHAR2(100) INDEX BY VARCHAR2(100);
    l_class_code_t  class_code_tbl;
    l_class_code VARCHAR2(240);
    --
    l_start_time varchar2(30);
    ld_begin_date   date;
    --
	gv_location VARCHAR2(100);
    BEGIN
        --
        gv_location := NULL;
        l_start_time := TO_CHAR(systimestamp, 'DDMMYYYYHH24MISS');

        FOR mapping_rec IN mapping_cur
        --
        LOOP
		   BEGIN
        --
            IF mapping_rec.application   = 'PPM' AND
               mapping_rec.category_code = 'CLASS_CATEGORY'
            THEN
                --
                l_class_category_t (mapping_rec.input_code_1) := mapping_rec.output_code_1;
                --
            ELSIF mapping_rec.application   = 'PPM' AND
                  mapping_rec.category_code = 'CLASS_CODE'
            THEN
                --
                l_class_code_t (mapping_rec.input_code_1) := mapping_rec.output_code_1;
                --
        END IF;
		  EXCEPTION
                WHEN NO_DATA_FOUND
                THEN NULL;
          END;
        --
       END LOOP;
--
        	BEGIN
--
                FOR x in XfmTableUpd_cur(pt_i_MigrationSetID)
                LOOP
                   l_class_category      :=   nvl(l_class_category_t   (x.class_category), x.class_category);
				   l_class_code          :=   nvl(l_class_code_t       (x.class_code), x.class_code);
                   --
				   UPDATE xxmx_ppm_prj_class_xfm
                   SET    class_category          = l_class_category
				         ,class_code              = l_class_code
                   WHERE  CURRENT OF XfmTableUpd_cur;
                END LOOP;
--
        	EXCEPTION
                WHEN others
                THEN NULL;
--
            END;
        pv_o_ReturnStatus := 'S';
--
	END transform_classifications;
--
END xxmx_project_foundation_ext_pkg;

/
