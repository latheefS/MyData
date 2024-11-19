--------------------------------------------------------
--  DDL for Package Body XXMX_AP_INV_EXT_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "XXMX_CORE"."XXMX_AP_INV_EXT_PKG" 
AS
--//=====================================================================================================
--// Version1
--// $Id:$
--//=====================================================================================================
--// Object Name        :: xxmx_ap_inv_ext_pkg.pkb
--//
--// Object Type        :: Package Body
--//
--// Object Description :: This package contains Procedures for applying transformation rules after
--//                       copying from STG and applying simple transforms
--// Pre-Reqs: xxmx_mapping_master table must be populated using the Mapping master spreadsheet.
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
FIN                                     AP                                              AP_INVOICE_TYPE
FIN                                     AP                                              AP_INVOICE_LINE_TYPE
FIN                                     AP                                              UNIT_OF_MEASURE
FIN                                     AP                                              TRANSACTION_BUSINESS_CATEGORY

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
                    ,pv_o_ReturnStatus                  OUT  VARCHAR2
                    )
	 IS
  /* Cursor to get mapping values from XXMX_MAPPING_MASTER table
       Update Application values below based on the mapping used in this package.
       Ex. If the mapping from PPM/PROJECTS is required, include PPM application within the AND clause.
  */
    CURSOR ap_inv_mapping_cur
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
               SELECT *
               FROM    xxmx_ap_invoices_xfm
               WHERE   1 = 1
                   AND     migration_set_id = pt_i_MigrationSetID
               FOR UPDATE;

    --//
    -- Local Type Variables
    --
    --
    TYPE ap_operating_unit_tbl  IS TABLE OF VARCHAR2(100) INDEX BY VARCHAR2(100);
    l_ap_operating_unit_t  ap_operating_unit_tbl;
    l_operating_unit VARCHAR2(240);
    --
    TYPE ap_invoice_types_tbl   IS TABLE OF VARCHAR2(100) INDEX BY VARCHAR2(100);
    l_ap_invoice_types_t   ap_invoice_types_tbl;
    l_invoice_type VARCHAR2(100);
    --
    TYPE ap_legal_entity_tbl    IS TABLE OF VARCHAR2(100) INDEX BY VARCHAR2(100);
    l_ap_legal_entity_t    ap_legal_entity_tbl;
    l_legal_entity VARCHAR2(100);
    --
    TYPE ap_payment_terms_tbl   IS TABLE OF VARCHAR2(100) INDEX BY VARCHAR2(100);
    l_ap_payment_terms_t   ap_payment_terms_tbl;
    l_payment_term VARCHAR2(100);
    --
    --
    TYPE ap_payment_method_tbl  IS TABLE OF VARCHAR2(100) INDEX BY VARCHAR2(100);
    l_ap_payment_method_t  ap_payment_method_tbl;
    l_payment_method VARCHAR2(100);
    --
    TYPE ap_acct_segment1_tbl  IS TABLE OF VARCHAR2(100) INDEX BY VARCHAR2(100);
    l_ap_acct_segment1_t  ap_acct_segment1_tbl;
    l_acct_segment1 VARCHAR2(250);
    --
    TYPE ap_acct_segment2_tbl  IS TABLE OF VARCHAR2(100) INDEX BY VARCHAR2(100);
    l_ap_acct_segment2_t  ap_acct_segment2_tbl;
    l_acct_segment2 VARCHAR2(250);
    --
    TYPE ap_acct_segment3_tbl  IS TABLE OF VARCHAR2(100) INDEX BY VARCHAR2(100);
    l_ap_acct_segment3_t  ap_acct_segment3_tbl;
    l_acct_segment3 VARCHAR2(250);
    --
    TYPE ap_acct_segment4_tbl  IS TABLE OF VARCHAR2(100) INDEX BY VARCHAR2(100);
    l_ap_acct_segment4_t  ap_acct_segment4_tbl;
    l_acct_segment4 VARCHAR2(250);
    --
    TYPE ap_acct_segment5_tbl  IS TABLE OF VARCHAR2(100) INDEX BY VARCHAR2(100);
    l_ap_acct_segment5_t  ap_acct_segment5_tbl;
    l_acct_segment5 VARCHAR2(250);
    --
	TYPE ap_ebs_seg2_999999_tbl  IS TABLE OF VARCHAR2(100) INDEX BY VARCHAR2(100);
    l_ap_ebs_seg2_999999_t  ap_ebs_seg2_999999_tbl;
    l_ap_ebs_seg2_999999 VARCHAR2(100);
    --
    l_trans_accts_pay_code_concat VARCHAR2(250);
    l_start_time varchar2(30);
    ld_begin_date   date;
    --
	gv_location VARCHAR2(100);
    BEGIN
        --
        gv_location := NULL;
        l_start_time := TO_CHAR(systimestamp, 'DDMMYYYYHH24MISS');
		--
        l_ap_invoice_types_t('aaa')  := 'aaa';
        /*
        Loop through the mapping master and  load All Mappings into PLSQL Key Value Pairs
        Application and category code must match to the details on the mapping master spreadsheet.
        Ex. Application  = 'AP' , category_code = 'UOM'.
        Extend this based on the number of mappings required for this code.
        */
        FOR ap_inv_mapping_rec IN ap_inv_mapping_cur
        --
        LOOP
		   BEGIN
        --
            IF ap_inv_mapping_rec.application = 'FUSION_BU_AND_LE' AND
               ap_inv_mapping_rec.category_code = 'FUSION_BU_AND_LE'
            THEN
                --
                l_ap_operating_unit_t (ap_inv_mapping_rec.input_code_1) := ap_inv_mapping_rec.output_code_1;
                --
                l_ap_legal_entity_t (ap_inv_mapping_rec.input_code_1) := ap_inv_mapping_rec.output_code_3;
                --
            ELSIF  ap_inv_mapping_rec.application = 'AP' AND
                   ap_inv_mapping_rec.category_code = 'AP_INVOICE_TYPE'
            THEN
                --
                l_ap_invoice_types_t(ap_inv_mapping_rec.input_code_1)  := ap_inv_mapping_rec.output_code_1;
                --
         END IF;
         --
		 EXCEPTION
                WHEN NO_DATA_FOUND
                THEN NULL;
            END;
        --
    END LOOP;
    --
            /* Update XFM data with the mappings provided*/
        	BEGIN
                FOR x in XfmTableUpd_cur(pt_i_MigrationSetID)
                LOOP
                --
                   l_invoice_type    := null;
                --
                  IF x.invoice_type_lookup_code is not NULL THEN
                   l_invoice_type    :=   l_ap_invoice_types_t (x.invoice_type_lookup_code);
                  END IF;
                --
                  IF l_invoice_type is not null THEN
                --
                   UPDATE xxmx_ap_invoices_xfm
                   SET    invoice_type_lookup_code = nvl(l_invoice_type,invoice_type_lookup_code)
                   WHERE  CURRENT OF XfmTableUpd_cur;
                --
                 END IF;

                END LOOP;
--
        	EXCEPTION
                WHEN NO_DATA_FOUND
                THEN NULL;
            END;
        pv_o_ReturnStatus   := 'S';
        --
	END transform_header;
	 --
     /*
     ********************************
     ** PROCEDURE: transform_lines
     ********************************
     */
	 --
	PROCEDURE transform_lines(
                     pt_i_ApplicationSuite           IN      xxmx_seeded_extensions.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_seeded_extensions.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_seeded_extensions.business_entity%TYPE
                    ,pt_i_StgPopulationMethod        IN      xxmx_core_parameters.parameter_value%TYPE
                    ,pt_i_FileSetID                  IN      xxmx_migration_headers.file_set_id%TYPE
                    ,pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pv_o_ReturnStatus                  OUT  VARCHAR2
                    )
	 IS
   /* Cursor to get mapping values from PFC_MAPPING_MASTER table
       Update Application values below based on the mapping used in this package.
       Ex. If the mapping from PPM/PROJECTS is required, include PPM application within the AND clause.
  */
    CURSOR ap_inv_mapping_cur
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
               FROM    xxmx_ap_invoice_lines_xfm
               WHERE   1 = 1
               AND     migration_set_id = pt_i_MigrationSetID
               FOR UPDATE;
               --
          --** END CURSOR XfmTableUpd_cur
          --
      --
    TYPE ap_invoice_line_type_tbl       IS TABLE OF VARCHAR2(100) INDEX BY VARCHAR2(100);
    l_ap_invoice_line_type_t            ap_invoice_line_type_tbl;
    l_ap_invoice_line_type VARCHAR2(100);
    --
    TYPE ap_invoice_line_uom_tbl        IS TABLE OF VARCHAR2(100) INDEX BY VARCHAR2(100);
    l_ap_invoice_line_uom_t             ap_invoice_line_uom_tbl;
    l_ap_invoice_line_uom VARCHAR2(100);

    TYPE ap_acct_segment1_tbl  IS TABLE OF VARCHAR2(100) INDEX BY VARCHAR2(100);
    l_ap_acct_segment1_t  ap_acct_segment1_tbl;
    l_acct_segment1 VARCHAR2(250);
    --
    TYPE ap_acct_segment2_tbl  IS TABLE OF VARCHAR2(100) INDEX BY VARCHAR2(100);
    l_ap_acct_segment2_t  ap_acct_segment2_tbl;
    l_acct_segment2 VARCHAR2(250);
    --
    TYPE ap_acct_segment3_tbl  IS TABLE OF VARCHAR2(100) INDEX BY VARCHAR2(100);
    l_ap_acct_segment3_t  ap_acct_segment3_tbl;
    l_acct_segment3 VARCHAR2(250);
    --
    TYPE ap_acct_segment4_tbl  IS TABLE OF VARCHAR2(100) INDEX BY VARCHAR2(100);
    l_ap_acct_segment4_t  ap_acct_segment4_tbl;
    l_acct_segment4 VARCHAR2(250);
    --
    TYPE ap_acct_segment5_tbl  IS TABLE OF VARCHAR2(100) INDEX BY VARCHAR2(100);
    l_ap_acct_segment5_t  ap_acct_segment5_tbl;
    l_acct_segment5 VARCHAR2(250);
    --
    TYPE ap_line_trx_business_cat_tbl   IS TABLE OF VARCHAR2(100) INDEX BY VARCHAR2(100);
    l_ap_line_trx_business_cat_t        ap_line_trx_business_cat_tbl;
    l_ap_line_trx_business_cat VARCHAR2(240);
    --
	TYPE ap_ebs_seg2_999999_tbl  IS TABLE OF VARCHAR2(100) INDEX BY VARCHAR2(100);
    l_ap_ebs_seg2_999999_t  ap_ebs_seg2_999999_tbl;
    l_ap_ebs_seg2_999999 VARCHAR2(100);
    --
    l_trans_accts_pay_code_concat VARCHAR2(250);
    --
    l_start_time varchar2(30);
    ld_begin_date   date;
	gv_location VARCHAR2(100);
    --
    BEGIN
        --
        gv_location  := NULL;
        l_start_time := TO_CHAR(systimestamp, 'DDMMYYYYHH24MISS');

        l_ap_invoice_line_type_t('aaa')  := 'aaa';
        l_ap_invoice_line_uom_t('aaa')  := 'aaa';
        l_ap_line_trx_business_cat_t('aaa')  := 'aaa';
        /*
        Loop through the mapping master and  load All Mappings into PLSQL Key Value Pairs
        Application and category code must match to the details on the mapping master spreadsheet.
        Ex. Application  = 'AP' , category_code = 'UOM'.
        Extend this based on the number of mappings required for this code.
        */
        FOR ap_inv_mapping_rec IN ap_inv_mapping_cur
        --
        LOOP
        --
		 BEGIN

            IF ap_inv_mapping_rec.application = 'AP' AND
               ap_inv_mapping_rec.category_code = 'AP_INVOICE_LINE_TYPE'
            THEN
            --
            l_ap_invoice_line_type_t(ap_inv_mapping_rec.input_code_1):= ap_inv_mapping_rec.output_code_1;
            --
            ELSIF  ap_inv_mapping_rec.application = 'UNIT_OF_MEASURE' AND
                   ap_inv_mapping_rec.category_code = 'UNIT_OF_MEASURE'
            THEN
            --
            l_ap_invoice_line_uom_t(ap_inv_mapping_rec.input_code_1):= ap_inv_mapping_rec.output_code_1;
            --
            ELSIF  ap_inv_mapping_rec.application = 'AP' AND
                   ap_inv_mapping_rec.category_code = 'TRANSACTION_BUSINESS_CATEGORY'
            THEN
            --
            l_ap_line_trx_business_cat_t(ap_inv_mapping_rec.input_code_1):= ap_inv_mapping_rec.output_code_1;
            --
        END IF;
        --
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

                  l_ap_invoice_line_type := null;
                  l_ap_invoice_line_uom := null;
                  l_ap_line_trx_business_cat := null;

                  IF x.line_type_lookup_code is not NULL THEN
                   l_ap_invoice_line_type        := l_ap_invoice_line_type_t (x.line_type_lookup_code);
                  END IF;

                  IF x.unit_of_meas_lookup_code is not NULL THEN
                   l_ap_invoice_line_uom         := l_ap_invoice_line_uom_t (x.unit_of_meas_lookup_code);
                  END IF;

                  IF x.trx_business_category is not NULL THEN
                   l_ap_line_trx_business_cat    := l_ap_line_trx_business_cat_t (x.trx_business_category);
                  END IF;

                  IF l_ap_invoice_line_type is not null   OR
                     l_ap_invoice_line_uom  is not null   OR
                     l_ap_line_trx_business_cat is not null THEN

                   UPDATE xxmx_ap_invoice_lines_xfm
                   SET    line_type_lookup_code    = nvl(l_ap_invoice_line_type,line_type_lookup_code)
                         ,unit_of_meas_lookup_code = nvl(l_ap_invoice_line_uom,unit_of_meas_lookup_code)
                         ,trx_business_category    = nvl(l_ap_line_trx_business_cat,trx_business_category)
                   WHERE  CURRENT OF XfmTableUpd_cur;

                  END IF;

                END LOOP;

        	EXCEPTION
                WHEN NO_DATA_FOUND
                THEN NULL;
            END;
        --
        pv_o_ReturnStatus   := 'S';
        --
	END transform_lines;
	 --
	 --
END xxmx_ap_inv_ext_pkg;

/
