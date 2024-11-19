create or replace PACKAGE BODY xxmx_fa_massadd_ext_pkg 
AS
--//=====================================================================================================
--// Version1
--// $Id:$
--//=====================================================================================================
--// Object Name        :: xxmx_fa_massadd_ext_pkg.pkb
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
--// 1.0          Milind Shanbhag      31/01/2022         Initial Build
--//=====================================================================================================
/* 
category codes referred in this code
APPLICATION_SUITE                       APPLICATION                                     CATEGORY_CODE
FIN                                     FA                                              ASSET_BOOK                                     
FIN                                     FA                                              ASSET_PRORATE   
FIN                                     FA                                              ASSET_CATEGORY 
FIN                                     FA                                              ASSET_KEY 
FIN                                     FA                                              ASSET_LOCATION 
*/
     --
	 --
     /*
     ********************************
     ** PROCEDURE: transform_massadd
     ********************************
     */
     --
     --
	PROCEDURE transform_massadd(
                     pt_i_ApplicationSuite           IN      xxmx_seeded_extensions.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_seeded_extensions.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_seeded_extensions.business_entity%TYPE
                    ,pt_i_StgPopulationMethod        IN      xxmx_core_parameters.parameter_value%TYPE
                    ,pt_i_FileSetID                  IN      xxmx_migration_headers.file_set_id%TYPE
                    ,pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pv_o_ReturnStatus                  OUT  VARCHAR2)
	 IS
  /* Cursor to get mapping values from XXMX_MAPPING_MASTER table
       Update Application values below based on the mapping used in this package.
       Ex. If the mapping from PPM/PROJECTS is required, include PPM application within the AND clause.
  */
    CURSOR mapping_cur
    IS
        --
        SELECT *
        FROM  xxmx_mapping_master
        WHERE 1 = 1
        and application = 'FA';

    /* cursor to get the transformed data so the further transformation can be applied.
    */
    CURSOR XfmTableUpd_cur
                      (
                       pt_MigrationSetID               xxmx_ap_invoices_xfm.migration_set_id%TYPE
                      )
    IS
               --
               SELECT  *
               FROM    xxmx_fa_mass_additions_xfm
               WHERE   1 = 1
               AND     migration_set_id = pt_i_MigrationSetID
               FOR UPDATE;
    --//
    -- Local Type Variables
    --
    TYPE fa_book_type_tbl  IS TABLE OF VARCHAR2(100) INDEX BY VARCHAR2(100);
    l_fa_book_type_t  fa_book_type_tbl;
    l_fa_book_type VARCHAR2(30);
    --
    TYPE fa_prorate_convention_tbl  IS TABLE OF VARCHAR2(100) INDEX BY VARCHAR2(100);
    l_fa_prorate_convention_t  fa_prorate_convention_tbl;
    l_fa_prorate_convention VARCHAR2(30);
    --
    TYPE fa_category1_tbl  IS TABLE OF VARCHAR2(100) INDEX BY VARCHAR2(100);
    l_fa_category1_t  fa_category1_tbl;
    l_fa_category1 VARCHAR2(10);
    --
    TYPE fa_category2_tbl  IS TABLE OF VARCHAR2(100) INDEX BY VARCHAR2(100);
    l_fa_category2_t  fa_category2_tbl;
    l_fa_category2 VARCHAR2(10);
    --
    TYPE fa_asset_key_tbl  IS TABLE OF VARCHAR2(100) INDEX BY VARCHAR2(100);
    l_fa_asset_key_t  fa_asset_key_tbl;
    l_fa_asset_key VARCHAR2(30);
    --


    l_start_time varchar2(30);
    ld_begin_date   date;
    --
	gv_location VARCHAR2(100);
    BEGIN
        --
        gv_location := NULL;
        l_start_time := TO_CHAR(systimestamp, 'DDMMYYYYHH24MISS');

        l_fa_book_type_t('aaa')  := 'aaa';
        l_fa_prorate_convention_t('aaa')  := 'aaa';
        l_fa_category1_t('aaa')  := 'aaa';
        l_fa_category2_t('aaa')  := 'aaa';
        l_fa_asset_key_t('aaa')  := 'aaa';
        /*
        Loop through the mapping master and  load All Mappings into PLSQL Key Value Pairs
        Application and category code must match to the details on the mapping master spreadsheet.
        Ex. Application  = 'AP' , category_code = 'UOM'.        
        Extend this based on the number of mappings required for this code.
        */
        FOR mapping_rec IN mapping_cur
        --
        LOOP
          BEGIN
        --
            IF mapping_rec.application = 'FA' AND 
               mapping_rec.category_code = 'ASSET_BOOK'
            THEN
                -- 
                l_fa_book_type_t (mapping_rec.input_code_1) := mapping_rec.output_code_1;
                --
            ELSIF  mapping_rec.application = 'FA' AND
                   mapping_rec.category_code = 'ASSET_PRORATE'
            THEN
            --
                l_fa_prorate_convention_t(mapping_rec.input_code_1||'~'||
                                          mapping_rec.input_code_2)  := mapping_rec.output_code_1;
            --
            ELSIF  mapping_rec.application = 'FA' AND
                   mapping_rec.category_code = 'ASSET_CATEGORY'
            THEN
            -- FA Category Segment1
            --
                l_fa_category1_t (mapping_rec.input_code_1||'~'||
                                 mapping_rec.input_code_2||'~'||
                                 mapping_rec.input_code_3)  := mapping_rec.output_code_1;
            -- FA Category Segment2
                --
                l_fa_category2_t (mapping_rec.input_code_1||'~'||
                                 mapping_rec.input_code_2||'~'||
                                 mapping_rec.input_code_3)  := mapping_rec.output_code_2;
            --
            ELSIF  mapping_rec.application = 'FA' AND
                   mapping_rec.category_code = 'ASSET_KEY'
            THEN
            --
            l_fa_asset_key_t(mapping_rec.input_code_1||'~'||
                                 mapping_rec.input_code_2||'~'||
                                 mapping_rec.input_code_3)  := mapping_rec.output_code_1;
            --
            --
           END IF;

		  EXCEPTION
                WHEN NO_DATA_FOUND
                THEN NULL;

          END;
        --
       END LOOP;

            /* Update XFM data with the mappings provided*/
        	BEGIN 


                FOR x in XfmTableUpd_cur(pt_i_MigrationSetID)
                LOOP
                  l_fa_book_type := null;
                  l_fa_prorate_convention := null;
                  l_fa_category1 := null;
                  l_fa_category2 := null;
                  l_fa_asset_key := null;

                  IF x.book_type_code is not NULL THEN
                   l_fa_book_type      :=   l_fa_book_type_t (x.book_type_code);
                  END IF;

                  IF x.prorate_convention_code is not NULL THEN
                   l_fa_prorate_convention      :=   l_fa_prorate_convention_t (x.book_type_code||'~'||x.prorate_convention_code);
                  END IF;


                  IF x.category_segment1 is not NULL THEN
                   l_fa_category1      :=   l_fa_category1_t (x.book_type_code||'~'||x.category_segment1||'~'||x.category_segment2);
                  END IF;

                  IF x.category_segment2 is not NULL THEN
                   l_fa_category2      :=   l_fa_category2_t (x.book_type_code||'~'||x.category_segment1||'~'||x.category_segment2);
                  END IF;

                  IF x.asset_key_segment1 is not NULL THEN
                   l_fa_asset_key      :=   l_fa_asset_key_t (x.asset_key_segment1||'~'||x.asset_key_segment2||'~'||x.asset_key_segment3);
                  END IF;


                   IF l_fa_book_type is not null   OR
                      l_fa_prorate_convention is not null   OR
                      l_fa_asset_key is not null   OR
                      l_fa_category1 is not null   OR
                      l_fa_category2 is not null   THEN

                   UPDATE xxmx_fa_mass_additions_xfm 
                   SET    book_type_code = nvl(l_fa_book_type,book_type_code)
                         ,prorate_convention_code = nvl(l_fa_prorate_convention,prorate_convention_code)
                         ,asset_key_segment1 = nvl(l_fa_asset_key,asset_key_segment1)
                         ,category_segment1 = nvl(l_fa_category1,category_segment1)
                         ,category_segment2 = nvl(l_fa_category2,category_segment2)
                   WHERE  CURRENT OF XfmTableUpd_cur;

                  END IF;

                END LOOP;

        	EXCEPTION
                WHEN others
                THEN NULL;

            END;

        --
        --COMMIT;
        --
        pv_o_ReturnStatus := 'S';

	END transform_massadd;


     /*
     ********************************
     ** PROCEDURE: transform_ma_dist
     ********************************
     */
     --
     --
	PROCEDURE transform_ma_dist(
                     pt_i_ApplicationSuite           IN      xxmx_seeded_extensions.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_seeded_extensions.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_seeded_extensions.business_entity%TYPE
                    ,pt_i_StgPopulationMethod        IN      xxmx_core_parameters.parameter_value%TYPE
                    ,pt_i_FileSetID                  IN      xxmx_migration_headers.file_set_id%TYPE
                    ,pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pv_o_ReturnStatus                  OUT  VARCHAR2)
	 IS
  /* Cursor to get mapping values from XXMX_MAPPING_MASTER table
       Update Application values below based on the mapping used in this package.
       Ex. If the mapping from PPM/PROJECTS is required, include PPM application within the AND clause.
  */
    CURSOR mapping_cur
    IS
        --
        SELECT *
        FROM  xxmx_mapping_master
        WHERE 1 = 1
        and application = 'FA';

    /* cursor to get the transformed data so the further transformation can be applied.
    */
    CURSOR XfmTableUpd_cur
                      (
                       pt_MigrationSetID               xxmx_ap_invoices_xfm.migration_set_id%TYPE
                      )
    IS
               --
               SELECT  *
               FROM    xxmx_fa_mass_addition_dist_xfm
               WHERE   1 = 1
               AND     migration_set_id = pt_i_MigrationSetID
               FOR UPDATE;
    --//
    -- Local Type Variables
    --
    TYPE fa_locations1_tbl       IS TABLE OF VARCHAR2(100) INDEX BY VARCHAR2(100);
    l_fa_locations1_t            fa_locations1_tbl;
    l_fa_locations1 VARCHAR2(100);
     --
    TYPE fa_locations2_tbl       IS TABLE OF VARCHAR2(100) INDEX BY VARCHAR2(100);
    l_fa_locations2_t            fa_locations2_tbl;
    l_fa_locations2 VARCHAR2(100);
     --
    TYPE fa_locations3_tbl       IS TABLE OF VARCHAR2(100) INDEX BY VARCHAR2(100);
    l_fa_locations3_t            fa_locations3_tbl;
    l_fa_locations3 VARCHAR2(100);
    --


    l_start_time varchar2(30);
    ld_begin_date   date;
    --
	gv_location VARCHAR2(100);
    BEGIN
        --
        gv_location := NULL;
        l_start_time := TO_CHAR(systimestamp, 'DDMMYYYYHH24MISS');

        l_fa_locations1_t('aaa')  := 'aaa';
        l_fa_locations2_t('aaa')  := 'aaa';
        l_fa_locations3_t('aaa')  := 'aaa';
        /*
        Loop through the mapping master and  load All Mappings into PLSQL Key Value Pairs
        Application and category code must match to the details on the mapping master spreadsheet.
        Ex. Application  = 'AP' , category_code = 'UOM'.        
        Extend this based on the number of mappings required for this code.
        */
        FOR mapping_rec IN mapping_cur
        --
        LOOP
          BEGIN
        --
            IF mapping_rec.application = 'FA' AND 
               mapping_rec.category_code = 'ASSET_LOCATION'
            THEN
                -- 
            l_fa_locations1_t(mapping_rec.input_code_1||'~'||
                             mapping_rec.input_code_2||'~'||
                             mapping_rec.input_code_3):= mapping_rec.output_code_1;
            --
            l_fa_locations2_t(mapping_rec.input_code_1||'~'||
                             mapping_rec.input_code_2||'~'||
                             mapping_rec.input_code_3):= mapping_rec.output_code_2;
            --
            l_fa_locations3_t(mapping_rec.input_code_1||'~'||
                             mapping_rec.input_code_2||'~'||
                             mapping_rec.input_code_3):= mapping_rec.output_code_3;
            --
           END IF;

		  EXCEPTION
                WHEN NO_DATA_FOUND
                THEN NULL;

          END;
        --
       END LOOP;

            /* Update XFM data with the mappings provided*/
        	BEGIN 


                FOR x in XfmTableUpd_cur(pt_i_MigrationSetID)
                LOOP
                  l_fa_locations1 := null;
                  l_fa_locations2 := null;
                  l_fa_locations3 := null;

                  IF x.location_segment1 is not NULL THEN
                   l_fa_locations1      :=   l_fa_locations1_t (x.location_segment1||'~'||x.location_segment2||'~'||x.location_segment3);
                  END IF;

                  IF x.location_segment2 is not NULL THEN
                   l_fa_locations2      :=   l_fa_locations2_t (x.location_segment1||'~'||x.location_segment2||'~'||x.location_segment3);
                  END IF;

                  IF x.location_segment3 is not NULL THEN
                   l_fa_locations3      :=   l_fa_locations3_t (x.location_segment1||'~'||x.location_segment2||'~'||x.location_segment3);
                  END IF;

                   IF l_fa_locations1 is not null OR
                      l_fa_locations2 is not null OR
                      l_fa_locations3 is not null THEN

                   UPDATE xxmx_fa_mass_addition_dist_xfm 
                   SET    location_segment1 = nvl(l_fa_locations1,location_segment1)
                         ,location_segment2 = nvl(l_fa_locations2,location_segment2)
                         ,location_segment3 = nvl(l_fa_locations3,location_segment3)
                   WHERE  CURRENT OF XfmTableUpd_cur;

                  END IF;

                END LOOP;

        	EXCEPTION
                WHEN others
                THEN NULL;

            END;

        --
        --COMMIT;
        --
        pv_o_ReturnStatus := 'S';

	END transform_ma_dist;

END xxmx_fa_massadd_ext_pkg;
/