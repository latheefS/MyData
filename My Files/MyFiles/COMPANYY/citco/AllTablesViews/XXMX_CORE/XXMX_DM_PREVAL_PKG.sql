--------------------------------------------------------
--  DDL for Package XXMX_DM_PREVAL_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "XXMX_CORE"."XXMX_DM_PREVAL_PKG" AUTHID CURRENT_USER AS
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
-- --------------------------------------------------------------------------------
-- |-----------------------< POPULATE PREVAL SUMMARY >----------------------------|
-- --------------------------------------------------------------------------------
--
    PROCEDURE pop_preval_summ (p_load_name   IN  VARCHAR2
                              ,p_object_name IN  VARCHAR2
                              ,p_parameter   IN  VARCHAR2
                              ,p_tab         IN  VARCHAR2
                              ,p_col         IN  VARCHAR2
                              );
--                              
-- --------------------------------------------------------------------------------
-- |------------------------< VALIDATE SUPPLIER TYPE >----------------------------|
-- --------------------------------------------------------------------------------
--
    PROCEDURE validate_supplier_type;

--
-- --------------------------------------------------------------------------------
-- |--------------------------< VALIDATE PPM >------------------------------------|
-- --------------------------------------------------------------------------------
--    
    PROCEDURE validate_ppm;	
-- --------------------------------------------------------------------------------
-- |--------------------------< VALIDATE PPM >------------------------------------|
-- --------------------------------------------------------------------------------
--    
    PROCEDURE validate_scm;
-- --------------------------------------------------------------------------------
-- |--------------------< VALIDATE CROSS VALIDATION RULE >------------------------|
-- --------------------------------------------------------------------------------
--    
/*    PROCEDURE validate_cvr ( p_iteration           VARCHAR2
                       ,p_load_name           VARCHAR2
                       ,p_object_name         VARCHAR2
                       ,p_rule_code           VARCHAR2 
                       ,p_con_include_exclude VARCHAR2  default 'INCLUDE'
                       ,p_val_include_exclude VARCHAR2  default 'INCLUDE') ;
                       */
-- --------------------------------------------------------------------------------
-- |--------------------------< VALIDATE EMPLOYEE_EMAIL_ADDRESS >------------------------------------|
-- --------------------------------------------------------------------------------
    PROCEDURE validate_employee_email_address;
--
-- --------------------------------------------------------------------------------
-- |--------------------------< VALIDATE HCM >------------------------------------|
-- --------------------------------------------------------------------------------
--    
    PROCEDURE validate_hcm;	
--
-- --------------------------------------------------------------------------------
-- |--------------------------< HCM POPULATE PREVAL SUMMARY >------------------------------------|
-- --------------------------------------------------------------------------------
-- 
    PROCEDURE hcm_pop_preval_summ (p_load_name   IN  VARCHAR2
                              ,p_object_name IN  VARCHAR2
                              ,p_parameter   IN  VARCHAR2
                              ,p_tab         IN  VARCHAR2
                              ,p_col         IN  VARCHAR2
                              );
END xxmx_dm_preval_pkg;

/