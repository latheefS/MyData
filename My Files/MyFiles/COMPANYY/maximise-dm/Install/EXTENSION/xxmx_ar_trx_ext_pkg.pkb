create or replace PACKAGE BODY xxmx_ar_trx_ext_pkg 
AS
--//=====================================================================================================
--// Version1
--// $Id:$
--//=====================================================================================================
--// Object Name        :: xxmx_ar_trx_ext_pkg.pkb
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
FIN                                     AR                                              FUSION_BU_AND_LE
FIN                                     AR                                              AR_TRANSACTION_TYPE                                     
FIN                                     AR                                              AR_PAYMENT_TERMS 
FIN                                     AR                                              AR_REASON_CODE
*/
     --
	 --
     /*
     ********************************
     ** PROCEDURE: transform_line
     ********************************
     */
     --
     --
	PROCEDURE transform_line(
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
               FROM    xxmx_ar_trx_lines_xfm
               WHERE   1 = 1
               AND     migration_set_id = pt_i_MigrationSetID
               FOR UPDATE;
    --//
    -- Local Type Variables
    --
    TYPE ar_business_unit_tbl  IS TABLE OF VARCHAR2(100) INDEX BY VARCHAR2(100);
    l_ar_business_unit_t  ar_business_unit_tbl;
    l_business_unit VARCHAR2(240);
    --
    TYPE ar_transaction_types_tbl   IS TABLE OF VARCHAR2(100) INDEX BY VARCHAR2(100);
    l_ar_transaction_types_t   ar_transaction_types_tbl;
    l_transaction_type VARCHAR2(100);
    --
    TYPE ar_payment_terms_tbl   IS TABLE OF VARCHAR2(100) INDEX BY VARCHAR2(100);
    l_ar_payment_terms_t   ar_payment_terms_tbl;
    l_payment_term VARCHAR2(100);
    --
    TYPE ar_reason_code_tbl  IS TABLE OF VARCHAR2(100) INDEX BY VARCHAR2(100);
    l_ar_reason_code_t  ar_reason_code_tbl;
    l_reason_code VARCHAR2(100);
    
    l_start_time varchar2(30);
    ld_begin_date   date;
    --
	gv_location VARCHAR2(100);
    BEGIN
        --
        gv_location := NULL;
        l_start_time := TO_CHAR(systimestamp, 'DDMMYYYYHH24MISS');

        l_ar_business_unit_t('aaa')  := 'aaa';
        l_ar_transaction_types_t('aaa')  := 'aaa';
        l_ar_payment_terms_t('aaa')  := 'aaa';
        l_ar_reason_code_t('aaa')  := 'aaa';
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
            IF mapping_rec.application = 'AR' AND
               mapping_rec.category_code = 'FUSION_BU_AND_LE'
            THEN
                --
                l_ar_business_unit_t (mapping_rec.input_code_1) := mapping_rec.output_code_1;
                --
            ELSIF  mapping_rec.application = 'AR' AND
                   mapping_rec.category_code = 'AR_TRANSACTION_TYPE'
            THEN
            --
                l_ar_transaction_types_t(mapping_rec.input_code_1)  := mapping_rec.output_code_1;
            --
            ELSIF  mapping_rec.application = 'AR' AND
                   mapping_rec.category_code = 'AR_PAYMENT_TERMS'
            THEN
            --
                l_ar_payment_terms_t(mapping_rec.input_code_1)  := mapping_rec.output_code_1;
            --
            ELSIF  mapping_rec.application = 'AR' AND
                   mapping_rec.category_code = 'AR_REASON_CODE'
            THEN
            --
                l_ar_reason_code_t(mapping_rec.input_code_1)  := mapping_rec.output_code_1;
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
                  l_business_unit := null;
                  l_payment_term := null;
                  l_transaction_type := null;                  
                  l_reason_code := null;   

                  IF x.fusion_business_unit is not NULL THEN
                   l_business_unit      :=   l_ar_business_unit_t (x.fusion_business_unit);
                  END IF;
                  
                  IF x.term_name is not NULL THEN
                   l_payment_term    :=   l_ar_payment_terms_t (x.term_name);
                  END IF;
                  
                  IF x.cust_trx_type_name is not NULL THEN
                   l_transaction_type    :=   l_ar_transaction_types_t (x.cust_trx_type_name);
                  END IF;
                  
                  IF x.reason_code is not NULL THEN
                   l_reason_code    :=   l_ar_reason_code_t (x.reason_code);
                  END IF;
 
                   IF l_business_unit is not null       OR
                      l_payment_term  is not null       OR
                      l_transaction_type  is not null   OR
                      l_reason_code is not null         THEN
                  
                   UPDATE xxmx_ar_trx_lines_xfm 
                   SET    fusion_business_unit = nvl(l_business_unit,fusion_business_unit)
                         ,term_name            = nvl(l_payment_term,term_name)
                         ,cust_trx_type_name   = nvl(l_transaction_type,cust_trx_type_name)
                         ,reason_code          = nvl(l_reason_code,reason_code)
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

	END transform_line;


END xxmx_ar_trx_ext_pkg;
/