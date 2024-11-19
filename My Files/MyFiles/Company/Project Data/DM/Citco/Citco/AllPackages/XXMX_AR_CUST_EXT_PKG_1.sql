--------------------------------------------------------
--  DDL for Package Body XXMX_AR_CUST_EXT_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "XXMX_CORE"."XXMX_AR_CUST_EXT_PKG" 
AS
--//=====================================================================================================
--// Version1
--// $Id:$
--//=====================================================================================================
--// Object Name        :: xxmx_ar_cust_ext_pkg.pkb
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
FIN                                     AR                                              CUSTOMER_CLASS_CODE
FIN                                     AR                                              AR_PAYMENT_TERMS
*/
     --
	 --
     /*
     ********************************
     ** PROCEDURE: transform_profiles
     ********************************
     */
     --
     --
	PROCEDURE transform_profiles(
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
        and application = 'AR';

    /* cursor to get the transformed data so the further transformation can be applied.
    */
    CURSOR XfmTableUpd_cur
                      (
                       pt_MigrationSetID               xxmx_ap_invoices_xfm.migration_set_id%TYPE
                      )
    IS
               --
               SELECT  *
               FROM    xxmx_hz_cust_profiles_xfm
               WHERE   1 = 1
               AND     migration_set_id = pt_i_MigrationSetID
               FOR UPDATE;
    --//
    -- Local Type Variables
    --
    TYPE ar_payment_terms_tbl   IS TABLE OF VARCHAR2(100) INDEX BY VARCHAR2(100);
    l_ar_payment_terms_t   ar_payment_terms_tbl;
    l_payment_term VARCHAR2(100);

    TYPE ar_cust_class_tbl   IS TABLE OF VARCHAR2(100) INDEX BY VARCHAR2(100);
    l_ar_cust_class_t   ar_cust_class_tbl;
    l_cust_class VARCHAR2(100);

    l_start_time varchar2(30);
    ld_begin_date   date;
    --
	gv_location VARCHAR2(100);
    BEGIN
        --
        gv_location := NULL;
        l_start_time := TO_CHAR(systimestamp, 'DDMMYYYYHH24MISS');

        l_ar_cust_class_t('aaa')  := 'aaa';
        l_ar_payment_terms_t('aaa')  := 'aaa';
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
            IF  mapping_rec.application = 'AR' AND   -----
                mapping_rec.category_code = 'CUSTOMER_CLASS_CODE'
            THEN
            --
                l_ar_cust_class_t(mapping_rec.input_code_1)  := mapping_rec.output_code_1;

            ELSIF  mapping_rec.application = 'AR' AND   -----
                mapping_rec.category_code = 'AR_PAYMENT_TERMS'
            THEN
            --
                l_ar_payment_terms_t(mapping_rec.input_code_1)  := mapping_rec.output_code_1;

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
                   l_cust_class := null;
                   l_payment_term := null;

                  IF x.customer_profile_class_name is not NULL THEN
                   l_cust_class      :=   l_ar_cust_class_t (x.customer_profile_class_name);
                  END IF;

                  IF x.standard_term_name is not NULL THEN
                   l_payment_term    :=   l_ar_payment_terms_t (x.standard_term_name);
                  END IF;

                  IF l_cust_class is not null   OR
                     l_payment_term is not null THEN

                   UPDATE xxmx_hz_cust_profiles_xfm
                   SET    customer_profile_class_name = nvl(l_cust_class,customer_profile_class_name)
                         ,standard_term_name          = nvl(l_payment_term,standard_term_name)
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

	END transform_profiles;


END xxmx_ar_cust_ext_pkg;

/
