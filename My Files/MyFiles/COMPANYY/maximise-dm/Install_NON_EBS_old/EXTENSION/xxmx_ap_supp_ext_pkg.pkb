create or replace PACKAGE BODY xxmx_ap_supp_ext_pkg 
AS
--//=====================================================================================================
--// Version1
--// $Id:$
--//=====================================================================================================
--// Object Name        :: xxmx_ap_supp_ext_pkg.pkb
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
--// 1.0          Milind Shanbhag      27/01/2022         Initial Build
--//=====================================================================================================
/* 
category codes referred in this code
APPLICATION_SUITE                       APPLICATION                                     CATEGORY_CODE
FIN                                     AP                                              SUPPLIER_TYPE                                     
FIN                                     AP                                              SUPP_PROCUREMENT_BU
FIN                                     AP                                              PAY_GROUP
FIN                                     AP                                              QUANTITY_TOLERANCE
FIN                                     AP                                              AP_PAYMENT_TERMS
FIN                                     AP                                              AP_PAYMENT_METHODS

*/    
     --
	 --
     /*
     ********************************
     ** PROCEDURE: transform_header
     ********************************
     */
     --
     --
	PROCEDURE transform_header(
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
        and application = 'AP';

    /* cursor to get the transformed data so the further transformation can be applied.
    */
    CURSOR XfmTableUpd_cur
                      (
                       pt_MigrationSetID               xxmx_ap_invoices_xfm.migration_set_id%TYPE
                      )
    IS
               --
               SELECT  *
               FROM    xxmx_ap_suppliers_xfm
               WHERE   1 = 1
               AND     migration_set_id = pt_i_MigrationSetID
               FOR UPDATE;
    --//
    -- Local Type Variables
    --
    TYPE ap_supplier_type_tbl   IS TABLE OF VARCHAR2(100) INDEX BY VARCHAR2(100);
    l_ap_supplier_type_t   ap_supplier_type_tbl;
    l_ap_supplier_type VARCHAR2(100);

    l_start_time varchar2(30);
    ld_begin_date   date;
    --
	gv_location VARCHAR2(100);
    BEGIN
        --
        gv_location := NULL;
        l_start_time := TO_CHAR(systimestamp, 'DDMMYYYYHH24MISS');

        l_ap_supplier_type_t('aaa')  := 'aaa';
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
            IF  mapping_rec.application = 'AP' AND   
                mapping_rec.category_code = 'SUPPLIER_TYPE'  
            THEN
            --
                l_ap_supplier_type_t(mapping_rec.input_code_1)  := mapping_rec.output_code_1;

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
                   l_ap_supplier_type := null;            

                  IF x.supplier_type is not NULL THEN                
                   l_ap_supplier_type      :=   l_ap_supplier_type_t (x.supplier_type);
                  END IF;

                  IF l_ap_supplier_type is not null   THEN                  

                   UPDATE xxmx_ap_suppliers_xfm
                   SET    supplier_type = nvl(l_ap_supplier_type,supplier_type)
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

	END transform_header;

     --
	 --
     /*
     ********************************
     ** PROCEDURE: transform_sites
     ********************************
     */
     --
     --

	PROCEDURE transform_sites(
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
        and application = 'AP';

    /* cursor to get the transformed data so the further transformation can be applied.
    */
    CURSOR XfmTableUpd_cur
                      (
                       pt_MigrationSetID               xxmx_ap_invoices_xfm.migration_set_id%TYPE
                      )
    IS
               --
               SELECT  *
               FROM    xxmx_ap_supplier_sites_xfm
               WHERE   1 = 1
               AND     migration_set_id = pt_i_MigrationSetID
               FOR UPDATE;
    --//
    -- Local Type Variables
    --
    TYPE ap_procurement_bu_tbl   IS TABLE OF VARCHAR2(100) INDEX BY VARCHAR2(100);
    l_ap_procurement_bu_t   ap_procurement_bu_tbl;
    l_ap_procurement_bu VARCHAR2(100);

    TYPE ap_pay_group_tbl   IS TABLE OF VARCHAR2(100) INDEX BY VARCHAR2(100);
    l_ap_pay_group_t   ap_pay_group_tbl;
    l_ap_pay_group VARCHAR2(100);

    TYPE ap_quantity_tolerances_tbl   IS TABLE OF VARCHAR2(100) INDEX BY VARCHAR2(100);
    l_ap_quantity_tolerances_t   ap_quantity_tolerances_tbl;
    l_ap_quantity_tolerances VARCHAR2(100);

    TYPE ap_payment_terms_tbl   IS TABLE OF VARCHAR2(100) INDEX BY VARCHAR2(100);
    l_ap_payment_terms_t   ap_payment_terms_tbl;
    l_ap_payment_terms VARCHAR2(100);
    
    l_start_time varchar2(30);
    ld_begin_date   date;
    --
	gv_location VARCHAR2(100);
    BEGIN
        --
        gv_location := NULL;
        l_start_time := TO_CHAR(systimestamp, 'DDMMYYYYHH24MISS');

        l_ap_procurement_bu_t('aaa')  := 'aaa';
        l_ap_pay_group_t('aaa')  := 'aaa';
        l_ap_quantity_tolerances_t('aaa')  := 'aaa';
        l_ap_payment_terms_t('aaa')  := 'aaa';
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
            IF  mapping_rec.application = 'AP' AND   
                mapping_rec.category_code = 'SUPP_PROCUREMENT_BU'  
            THEN
            --
                l_ap_procurement_bu_t(mapping_rec.input_code_1)  := mapping_rec.output_code_1;

            ELSIF  mapping_rec.application = 'AP' AND   
                mapping_rec.category_code = 'PAY_GROUP'  
            THEN
            --
                l_ap_pay_group_t(mapping_rec.input_code_1)  := mapping_rec.output_code_1;

            ELSIF  mapping_rec.application = 'AP' AND   
                mapping_rec.category_code = 'QUANTITY_TOLERANCE'  
            THEN
            --
                l_ap_quantity_tolerances_t(mapping_rec.input_code_1)  := mapping_rec.output_code_1;

            ELSIF  mapping_rec.application = 'AP' AND   
                mapping_rec.category_code = 'AP_PAYMENT_TERMS'  
            THEN
            --
                l_ap_payment_terms_t(mapping_rec.input_code_1)  := mapping_rec.output_code_1;
                                
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
                   l_ap_procurement_bu := null;            
                   l_ap_pay_group := null;
                   l_ap_quantity_tolerances := null;
                   l_ap_payment_terms := null;


                  IF x.procurement_bu is not NULL THEN                
                   l_ap_procurement_bu      :=   l_ap_procurement_bu_t (x.procurement_bu);
                  END IF;

                  IF x.pay_group is not NULL THEN                
                   l_ap_pay_group      :=   l_ap_pay_group_t (x.pay_group);
                  END IF;

                  IF x.quantity_tolerances is not NULL THEN                
                   l_ap_quantity_tolerances      :=   l_ap_quantity_tolerances_t (x.quantity_tolerances);
                  END IF;

                  IF x.payment_terms is not NULL THEN                
                   l_ap_payment_terms      :=   l_ap_payment_terms_t (x.payment_terms);
                  END IF;

                  IF l_ap_procurement_bu is not null     OR       
                   l_ap_pay_group is not null            OR
                   l_ap_quantity_tolerances is not null  OR
                   l_ap_payment_terms is not null        THEN                  

                   UPDATE xxmx_ap_supplier_sites_xfm
                   SET    procurement_bu = nvl(l_ap_procurement_bu,procurement_bu)
                         ,pay_group = nvl(l_ap_pay_group,pay_group)
                         ,quantity_tolerances = nvl(l_ap_quantity_tolerances,quantity_tolerances)
                         ,payment_terms = nvl(l_ap_payment_terms,payment_terms)
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

	END transform_sites;

     --
	 --
     /*
     ********************************
     ** PROCEDURE: transform_payees
     ********************************
     */
     --
     --

	PROCEDURE transform_payees(
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
        and application = 'AP';

    /* cursor to get the transformed data so the further transformation can be applied.
    */
    CURSOR XfmTableUpd_cur
                      (
                       pt_MigrationSetID               xxmx_ap_invoices_xfm.migration_set_id%TYPE
                      )
    IS
               --
               SELECT  *
               FROM    xxmx_ap_supp_payees_xfm
               WHERE   1 = 1
               AND     migration_set_id = pt_i_MigrationSetID
               AND     default_payment_method_code is not null
               FOR UPDATE;
    --//
    -- Local Type Variables
    --
    TYPE ap_payment_method_tbl   IS TABLE OF VARCHAR2(100) INDEX BY VARCHAR2(100);
    l_ap_payment_method_t   ap_payment_method_tbl;
    l_ap_payment_method VARCHAR2(100);

    l_start_time varchar2(30);
    ld_begin_date   date;
    --
	gv_location VARCHAR2(100);
    BEGIN
        --
        gv_location := NULL;
        l_start_time := TO_CHAR(systimestamp, 'DDMMYYYYHH24MISS');

        l_ap_payment_method_t('aaa')  := 'aaa';
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
            IF  mapping_rec.application = 'AP' AND   
                mapping_rec.category_code = 'AP_PAYMENT_METHODS'  
            THEN
            --
                l_ap_payment_method_t(mapping_rec.input_code_1)  := mapping_rec.output_code_1;

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
                   l_ap_payment_method := null;            

                  IF x.default_payment_method_code is not NULL THEN                
                   l_ap_payment_method      :=   l_ap_payment_method_t (x.default_payment_method_code);
                  END IF;

                  IF l_ap_payment_method is not null   THEN                  

                   UPDATE xxmx_ap_supp_payees_xfm
                   SET    default_payment_method_code = nvl(l_ap_payment_method,default_payment_method_code)
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

	END transform_payees;

END xxmx_ap_supp_ext_pkg;
/