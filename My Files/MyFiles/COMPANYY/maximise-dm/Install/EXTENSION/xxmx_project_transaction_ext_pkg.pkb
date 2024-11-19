create or replace PACKAGE BODY xxmx_project_transaction_ext_pkg 
AS
--//=====================================================================================================
--// Version1
--// $Id:$
--//=====================================================================================================
--// Object Name        :: xxmx_project_transaction_ext_pkg.pkb
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
-- PROCEDURE: Transform Costs
---------------------------------------------------------------------------------------------------------
--
	PROCEDURE transform_costs(
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
        AND application = 'COSTS';
--
    CURSOR XfmTableUpd_cur
                      (
                       pt_MigrationSetID               xxmx_ppm_prj_misccost_xfm.migration_set_id%TYPE
                      )
    IS
               --
               SELECT  migration_set_id
  			          ,business_unit
                      ,expenditure_type
					  ,organization_name
			   FROM    xxmx_ppm_prj_misccost_xfm
               WHERE   1 = 1
               AND     migration_set_id = pt_i_MigrationSetID
               FOR UPDATE;
--
-- Local Type Variables
    TYPE business_unit_tbl  IS TABLE OF VARCHAR2(100) INDEX BY VARCHAR2(100);
    l_business_unit_t  business_unit_tbl;
    l_business_unit VARCHAR2(240);
    TYPE expenditure_type_tbl  IS TABLE OF VARCHAR2(100) INDEX BY VARCHAR2(100);
    l_expenditure_type_t  expenditure_type_tbl;
    l_expenditure_type VARCHAR2(240);
    TYPE organization_name_tbl  IS TABLE OF VARCHAR2(100) INDEX BY VARCHAR2(100);
    l_organization_name_t  organization_name_tbl;
    l_organization_name VARCHAR2(240);	
    --
    l_start_time varchar2(30);
    ld_begin_date   date;
    --
	gv_location VARCHAR2(100);
    BEGIN
        --
        gv_location := NULL;
        l_start_time := TO_CHAR(systimestamp, 'DDMMYYYYHH24MISS');
--
        l_business_unit_t('aaa')     := 'aaa';
		l_expenditure_type_t('aaa')  := 'aaa';
		l_organization_name_t('aaa') := 'aaa';
--		
        FOR mapping_rec IN mapping_cur
        --
        LOOP
		   BEGIN
        --
            IF mapping_rec.application   = 'PPM_TRX' AND
               mapping_rec.category_code = 'BU'
            THEN
                --
                l_business_unit_t (mapping_rec.input_code_1) := mapping_rec.output_code_1;
                --
            ELSIF mapping_rec.application   = 'PPM_TRX' AND
               mapping_rec.category_code    = 'EXPENDITURE_TYPE'
            THEN
                --
                l_expenditure_type_t (mapping_rec.input_code_1) := mapping_rec.output_code_1;
                --
            ELSIF mapping_rec.application   = 'PPM_TRX' AND
               mapping_rec.category_code = 'ORGANIZATION_NAME'
            THEN
                --
                l_organization_name_t (mapping_rec.input_code_1) := mapping_rec.output_code_1;
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
--
				l_business_unit     := NULL;
				l_expenditure_type  := NULL;
				l_organization_name := NULL;
--
				IF x.business_unit IS NOT NULL THEN 
                   l_business_unit      :=   nvl(l_business_unit_t   (x.business_unit), x.business_unit);
                END IF;
				IF x.expenditure_type IS NOT NULL THEN 
                   l_expenditure_type      :=   nvl(l_expenditure_type_t   (x.expenditure_type), x.expenditure_type);
                END IF;
				IF x.organization_name IS NOT NULL THEN 
                   l_organization_name      :=   nvl(l_organization_name_t   (x.organization_name), x.organization_name);
                END IF;				
				IF l_business_unit IS NOT NULL OR
       			   l_expenditure_type IS NOT NULL OR
				   l_organization_name IS NOT NULL  THEN 
				   UPDATE xxmx_ppm_prj_misccost_xfm 
                   SET    business_unit             = NVL(l_business_unit,business_unit)   --If Project Number changed from EBS to Cloud 
				         ,expenditure_type          = NVL(l_expenditure_type,expenditure_type)
						 ,organization_name         = NVL(l_organization_name,organization_name)
                   WHERE  CURRENT OF XfmTableUpd_cur;
                   END IF;
                END LOOP;
--
        	EXCEPTION
                WHEN OTHERS
                THEN NULL;
--
            END;
        pv_o_ReturnStatus := 'S';
--
	END transform_costs;
--
---------------------------------------------------------------------------------------------------------
-- PROCEDURE: Transform Billing Events
---------------------------------------------------------------------------------------------------------
--
	PROCEDURE transform_events(
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
        AND application = 'EVENTS';

    CURSOR XfmTableUpd_cur
                      (
                       pt_MigrationSetID               xxmx_ppm_prj_billevent_xfm.migration_set_id%TYPE
                      )
    IS
               --
               SELECT  migration_set_id
                      ,project_number
			   FROM    xxmx_ppm_prj_billevent_xfm
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
        l_project_number_t('aaa')  := 'aaa';
--		
        FOR mapping_rec IN mapping_cur
        --
        LOOP
		   BEGIN
        --
            IF mapping_rec.application   = 'PPM' AND
               mapping_rec.category_code = 'EVENTS'
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
				l_project_number    := NULL;
				    IF x.project_number IS NOT NULL THEN 
                       l_project_number      :=   nvl(l_project_number_t   (x.project_number), x.project_number);
                    END IF;
--                  
                    IF l_project_number IS NOT NULL THEN
				       UPDATE xxmx_ppm_prj_billevent_xfm 
                       SET    project_number          = nvl(l_project_number , project_number)
                       WHERE  CURRENT OF XfmTableUpd_cur;
				    END IF;

                END LOOP;
--
        	EXCEPTION
                WHEN others
                THEN NULL;
--
            END;
        pv_o_ReturnStatus := 'S';
--
	END transform_events;

END xxmx_project_transaction_ext_pkg;
/