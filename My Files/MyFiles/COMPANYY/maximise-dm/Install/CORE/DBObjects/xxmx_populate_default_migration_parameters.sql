--**
--** Example Values:
--** ===============
--**
--** MIGRATION_APPLICATION = FIN             - for parameters applicable to all functional areas (AP, AR, GL etc)
--**                         AP              - Accounts Payables specific parameters
--**                         AR              - Accounts Receivable/Revenue Accounting specific parameters
--**                         FA              - Fixed Assets specific parameters
--**                         GL              - General Ledger specific parameters
--**                         PO              - Purchasing specific parameters
--
--** BUSINESS_ENTITY       = ALL             - All entities within the scope of the MIGRATION_APPLICATION
--**                         ASSETS
--**                         CHART_OF_ACCOUNTS
--                           BALANCES
--**                         CUSTOMERS
--**                         SUPPLIERS
--**                         INVOICES          (Qualified by Application as either AP INVOICES or AR INVOICES)
--**                         PURCHASE_ORDERS
--**                         BANKS_MASTER
--**
--** BUSINESS_ENTITY_LEVEL = INVOICE_HEADERS
--**                         INVOICE_LINES
--**                         INVOICE_DISTS
--**
--
--ALTER SESSION SET CONTAINER = MXDM_PDB1;
--
--
/*
*****************
** FIN Parameters
*****************
*/
--
/*
****************
** GL Parameters
****************
*/
--
--
/*]
** GL Ledgers
*/
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'ALL'                                   
         ,'ALL'                                   
         ,'LEDGER_NAME'                           
         ,distinct_ledgers.name                   
         ,'Y'                                     
         ,'SOURCE_DB'                             
FROM     (
          SELECT  DISTINCT
                  gl.name
          FROM    apps.gl_ledgers@mxdm_nvis_extract  gl
          WHERE   1 = 1
          AND     NOT EXISTS (
                              SELECT 'X'
                              FROM   XXMX_CORE.xxmx_migration_parameters xmp2
                              WHERE  1 = 1
                              AND    xmp2.application_suite = 'FIN'
                              AND    xmp2.application       = 'GL'
                              AND    xmp2.business_entity   = 'ALL'
                              AND    xmp2.sub_entity        = 'ALL'
                              AND    xmp2.parameter_code    = 'LEDGER_NAME'
                              AND    xmp2.parameter_value   = gl.name
                             )
         )   distinct_ledgers;
--
--
--
/*
** GL Balances Parameters
*/
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'BALANCES'                              
         ,'ALL'                                   
         ,'EXTRACT_YEAR'                          
         ,'2014'                                  
         ,'Y'                                     
         ,'XXMX'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'BALANCES'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'EXTRACT_YEAR'
                      AND    parameter_value   = '2014'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'BALANCES'                              
         ,'ALL'                                   
         ,'EXTRACT_YEAR'                          
         ,'2015'                                  
         ,'Y'                                     
         ,'XXMX'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'BALANCES'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'EXTRACT_YEAR'
                      AND    parameter_value   = '2015'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'BALANCES'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'APR-15'                                
         ,'Y'                                     
         ,'XXMX'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'BALANCES'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'APR-15'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'BALANCES'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'APR-20'                                
         ,'Y'                                     
         ,'XXMX'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'BALANCES'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'APR-20'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
            (
             parameter_id
            ,application_suite
            ,application
            ,business_entity
            ,sub_entity
            ,parameter_code
            ,parameter_value
            ,enabled_flag
            ,data_source
            )
SELECT      xxmx_migration_parameter_ids_s.NEXTVAL   
           ,'XXMX'                                   
           ,'GL'                                     
           ,'UTILITIES'                              
           ,'DEFAULT_ACCOUNT_TRANSFORMS'             
           ,'PLACEBO_SEGMENT_VALUE'              
           ,'#'                                      
           ,'Y'                                      
           ,'XXMX'                                   
 FROM       dual
 WHERE      1 = 1
 AND        NOT EXISTS (
                        SELECT 'X'
                        FROM   XXMX_CORE.xxmx_migration_parameters
                        WHERE  1 = 1
                        AND    application_suite = 'XXMX'
                        AND    application       = 'GL'
                        AND    business_entity   = 'UTILITIES'
                        AND    sub_entity        = 'DEFAULT_ACCOUNT_TRANSFORMS'
                        AND    parameter_code    = 'PLACEBO_SEGMENT_VALUE'
                       );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
            (
             parameter_id
            ,application_suite
            ,application
            ,business_entity
            ,sub_entity
            ,parameter_code
            ,parameter_value
            ,enabled_flag
            ,data_source
            )
SELECT       xxmx_migration_parameter_ids_s.NEXTVAL  
            ,'XXMX'                                  
            ,'GL'                                    
            ,'UTILITIES'                             
            ,'DEFAULT_ACCOUNT_TRANSFORMS'            
            ,'PLACEBO_SEGMENT_VALUE'                 
            ,'#'                                     
            ,'Y'                                     
            ,'XXMX'                                  
FROM        dual
WHERE       1 = 1
AND         NOT EXISTS (
                        SELECT 'X'
                        FROM   XXMX_CORE.xxmx_migration_parameters
                        WHERE  1 = 1
                        AND    application_suite = 'XXMX'
                        AND    application       = 'GL'
                        AND    business_entity   = 'UTILITIES'
                        AND    sub_entity        = 'DEFAULT_ACCOUNT_TRANSFORMS'
                        AND    parameter_code    = 'PLACEBO_SEGMENT_VALUE'
                       );
--
--
/*
*************************
** FIN Organization Names
*************************
*/
--
--
/*
** Organizations (Operating Units)
*/
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'ALL'                                   
         ,'ALL'                                   
         ,'ALL'                                   
         ,'ORGANIZATION_NAME'                     
         ,distinct_orgs.name                      
         ,'Y'                                     
         ,'SOURCE_DB'                             
FROM     (
          SELECT  DISTINCT
                  haou.name
          FROM    apps.hr_all_organization_units@mxdm_nvis_extract    haou
                 ,apps.hr_organization_information@mxdm_nvis_extract  hoi
          WHERE   1 = 1
          AND     NVL(haou.date_to, SYSDATE + 1) > SYSDATE
          AND     hoi.organization_id            = haou.organization_id
          AND     hoi.org_information1           = 'OPERATING_UNIT'
          AND     NOT EXISTS                     (
                                                  SELECT 'X'
                                                  FROM   XXMX_CORE.xxmx_migration_parameters xmp2
                                                  WHERE  1 = 1
                                                  AND    xmp2.application_suite = 'FIN'
                                                  AND    xmp2.application       = 'ALL'
                                                  AND    xmp2.business_entity   = 'ALL'
                                                  AND    xmp2.sub_entity        = 'ALL'
                                                  AND    xmp2.parameter_code    = 'ORGANIZATION_NAME'
                                                  AND    xmp2.parameter_value   = haou.name
                                                 )
         )   distinct_orgs;
--
--
/*
****************
** AP Parameters
****************
*/
--
/*
** Supplier Parameters
*/
--
/*
** MONTHS_TO_MIGRATE
*/
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'AP'                                    
         ,'SUPPLIERS'                             
         ,'ALL'                                   
         ,'MONTHS_TO_MIGRATE'                     
         ,'18'                                    
         ,'Y'                                     
         ,'XXMX'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'AP'
                      AND    business_entity   = 'SUPPLIERS'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'MONTHS_TO_MIGRATE'
                     );

INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'AP'                                    
         ,'INVOICES'                              
         ,'ALL'                                   
         ,'MONTHS_TO_MIGRATE'                     
         ,'18'                                    
         ,'Y'                                     
         ,'XXMX'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'AP'
                      AND    business_entity   = 'INVOICES'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'MONTHS_TO_MIGRATE'
                     );


--
--
/*
** VENDOR_TYPE
*/
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters xmp
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'AP'                                    
         ,'SUPPLIERS'                             
         ,'ALL'                                   
         ,'VENDOR_TYPE'                           
         ,vendor_types.lookup_code                
         ,'Y'                                     
         ,'SOURCE_DB'                             
FROM     (
          SELECT  flv.lookup_code
          FROM    apps.fnd_application_tl@mxdm_nvis_extract  fat
                 ,apps.fnd_lookup_values@mxdm_nvis_extract   flv
          WHERE   1 = 1
          AND     fat.application_name       = 'Purchasing'
          AND     flv.view_application_id    = fat.application_id
          AND     flv.lookup_type            = 'VENDOR TYPE'
          AND     NVL(flv.enabled_flag, 'N') = 'Y'
          AND     SYSDATE                    < NVL(flv.end_date_active, SYSDATE + 1)
          AND     NOT EXISTS                 (
                                              SELECT 'X'
                                              FROM   XXMX_CORE.xxmx_migration_parameters xmp2
                                              WHERE  1 = 1
                                              AND    xmp2.application_suite = 'FIN'
                                              AND    xmp2.application       = 'AP'
                                              AND    xmp2.business_entity   = 'SUPPLIERS'
                                              AND    xmp2.sub_entity        = 'ALL'
                                              AND    xmp2.parameter_code    = 'VENDOR_TYPE'
                                              AND    xmp2.parameter_value   = flv.lookup_code
                                             )
          ORDER BY flv.lookup_code
         )   vendor_types;
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                    
         ,'AP'                                     
         ,'SUPPLIERS'                              
         ,'ALL'                                    
         ,'VENDOR_TYPE'                            
         ,'#NULL'                                  
         ,'N'                                      
         ,'XXMX'                                   
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'AP'
                      AND    business_entity   = 'SUPPLIERS'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'VENDOR_TYPE'
                      AND    parameter_value   = '#NULL'
                     );
--
--
/*
** ORDER_OF_PREFERENCE_LIMIT
*/
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'AP'                                    
         ,'SUPPLIERS'                             
         ,'SUPPLIER_PMT_INSTRS'                   
         ,'ORDER_OF_PREFERENCE_LIMIT'             
         ,'1'                                     
         ,'Y'                                     
         ,'XXMX'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'AP'
                      AND    business_entity   = 'SUPPLIERS'
                      AND    sub_entity        = 'SUPPLIER_PMT_INSTRS'
                      AND    parameter_code    = 'ORDER_OF_PREFERENCE_LIMIT'
                     );
--
--
/*
** Invoice Parameters
*/
--
/*
** INVOICE_TYPE
*/
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'AP'                                    
         ,'INVOICES'                              
         ,'ALL'                                   
         ,'INVOICE_TYPE'                          
         ,invoice_types.lookup_code               
         ,'Y'                                     
         ,'SOURCE_DB'                             
FROM     (
          SELECT  flv.lookup_code
          FROM    apps.fnd_application_tl@mxdm_nvis_extract  fat
                 ,apps.fnd_lookup_values@mxdm_nvis_extract   flv
          WHERE   1 = 1
          AND     fat.application_name       = 'Payables'
          AND     flv.view_application_id    = fat.application_id
          AND     flv.lookup_type            = 'INVOICE TYPE'
          AND     NVL(flv.enabled_flag, 'N') = 'Y'
          AND     SYSDATE                    < NVL(flv.end_date_active, SYSDATE + 1)
          AND     NOT EXISTS                 (
                                              SELECT 'X'
                                              FROM   XXMX_CORE.xxmx_migration_parameters xmp2
                                              WHERE  1 = 1
                                              AND    xmp2.application_suite = 'FIN'
                                              AND    xmp2.application       = 'AP'
                                              AND    xmp2.business_entity   = 'INVOICES'
                                              AND    xmp2.sub_entity       = 'ALL'
                                              AND    xmp2.parameter_code    = 'INVOICE_TYPE'
                                              AND    xmp2.parameter_value   = flv.lookup_code
                                             )
          ORDER BY flv.lookup_code
         )   invoice_types;
--
/*
** DEFAULT_IMPORT_SOURCE
*/
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'AP'                                    
         ,'INVOICES'                              
         ,'INVOICE_HEADERS'                       
         ,'DEFAULT_IMPORT_SOURCE'                 
         ,'Data Migration'                        
         ,'Y'                                     
         ,'XXMX'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'AP'
                      AND    business_entity   = 'INVOICES'
                      AND    sub_entity        = 'INVOICE_HEADERS'
                      AND    parameter_code    = 'DEFAULT_IMPORT_SOURCE'
                     );
--
/*
** DEFAULT_PAY_CODE_CONCATENATED
*/
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'AP'                                    
         ,'INVOICES'                              
         ,'INVOICE_HEADERS'                       
         ,'DEFAULT_PAY_CODE_CONCATENATED'         
         ,'XX-XXXXX-XXXXX-XXXXX-00000000'         
         ,'Y'                                     
         ,'XXMX'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'AP'
                      AND    business_entity   = 'INVOICES'
                      AND    sub_entity        = 'INVOICE_LINES'
                      AND    parameter_code    = 'DEFAULT_PAY_CODE_CONCATENATED'
                     );
--
/*
** DEFAULT_DIST_CODE_CONCATENATED
*/
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'AP'                                    
         ,'INVOICES'                              
         ,'INVOICE_LINES'                         
         ,'DEFAULT_DIST_CODE_CONCATENATED'        
         ,'YY-YYYYY-YYYYY-YYYYY-00000000'         
         ,'Y'                                     
         ,'XXMX'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'AP'
                      AND    business_entity   = 'INVOICES'
                      AND    sub_entity        = 'INVOICE_LINES'
                      AND    parameter_code    = 'DEFAULT_DIST_CODE_CONCATENATED'
                     );
--
/***************
** AR Parameters
****************/
--
/*
** CUSTOMERS:
** ----------
** Parameters allow for any Customer Account created during the MONTHS_TO_MIGRATE to be loaded
** regardless of any outstanding transactions.
** If the customer  has either the Account or an active account site changed during the MONTHS_TO_MIGRATE period
** then it will load when active; if Flag INCLUDE INACTIVE ACCOUNTS = 'Y' then inactive accounts are included and
** if INCLUDE_INACTIVE_SITES = 'Y' then inactive sites will also migrate providing the account is migrating.
** the 'ORGANIZATION_NAME' (can be many) will override the 'ALL' organization orgid scope
*/
--
/*
** MONTHS_TO_MIGRATE
*/
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'AR'                                    
         ,'CUSTOMERS'                             
         ,'ALL'                                   
         ,'MONTHS_TO_MIGRATE'                     
         ,'18'                                    
         ,'Y'                                     
         ,'XXMX'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'AR'
                      AND    business_entity   = 'CUSTOMERS'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'MONTHS_TO_MIGRATE'
                     );
--
--
/*
** INCLUDE_INACTIVE_ACCOUNTS
*/
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'AR'                                    
         ,'CUSTOMERS'                             
         ,'ALL'                                   
         ,'INCLUDE_INACTIVE_ACCOUNTS'             
         ,'Y'                                     
         ,'Y'                                     
         ,'XXMX'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'AR'
                      AND    business_entity   = 'CUSTOMERS'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'INCLUDE_INACTIVE_ACCOUNTS'
                     );
--
--
/*
** INCLUDE_INACTIVE_SITES
*/
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'AR'                                    
         ,'CUSTOMERS'                             
         ,'ALL'                                   
         ,'INCLUDE_INACTIVE_SITES'                
         ,'Y'                                     
         ,'Y'                                     
         ,'XXMX'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'AR'
                      AND    business_entity   = 'CUSTOMERS'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'INCLUDE_INACTIVE_SITES'
                     );
--
--
/*
****************
** PO Parameters
****************
*/
--
/*
** INCLUDE_FULLY_RECEIPTED_POS
*/
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'SCM'                                   
         ,'PO'                                    
         ,'PURCHASE_ORDERS'                       
         ,'ALL'                                   
         ,'INCLUDE_FULLY_RECEIPTED_POS'           
         ,'N'                                     
         ,'Y'                                     
         ,'XXMX'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'SCM'
                      AND    application       = 'PO'
                      AND    business_entity   = 'PURCHASE_ORDERS'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'INCLUDE_FULLY_RECEIPTED_POS'
                     );
--
--
/*
** MONTHS_TO_MIGRATE
*/
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'SCM'                                   
         ,'PO'                                    
         ,'PURCHASE_ORDERS'                       
         ,'ALL'                                   
         ,'MONTHS_TO_MIGRATE'                     
         ,'18'                                    
         ,'Y'                                     
         ,'XXMX'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'SCM'
                      AND    application       = 'PO'
                      AND    business_entity   = 'PURCHASE_ORDERS'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'MONTHS_TO_MIGRATE'
                     );
--
--
/*****************************************************************************************************
** HCM Global HR Parameters
******************************************************************************************************/
--
--
/*
** All existing Business Groups
*/
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'HCM'                                   
         ,'HR'                                    
         ,'ALL'                                   
         ,'ALL'                                   
         ,'BUSINESS_GROUP_NAME'                   
         ,distinct_business_groups.name           
         ,'Y'                                     
         ,'SOURCE_DB'                             
FROM     (
          SELECT  DISTINCT
                  haou.name
          FROM    apps.hr_all_organization_units@mxdm_nvis_extract   haou
                 ,apps.hr_organization_information@mxdm_nvis_extract hoi
          WHERE   1 = 1
          AND     NVL(haou.date_to, SYSDATE + 1) > SYSDATE
          AND     hoi.organization_id            = haou.organization_id
          AND     hoi.org_information_context    = 'CLASS'
          AND     hoi.org_information1           = 'HR_BG'
          AND     NOT EXISTS                     (
                                                  SELECT 'X'
                                                  FROM   XXMX_CORE.xxmx_migration_parameters xmp2
                                                  WHERE  1 = 1
                                                  AND    xmp2.application_suite = 'HCM'
                                                  AND    xmp2.application       = 'HR'
                                                  AND    xmp2.business_entity   = 'ALL'
                                                  AND    xmp2.sub_entity       = 'ALL'
                                                  AND    xmp2.parameter_code    = 'BUSINESS_GROUP_NAME'
                                                  AND    xmp2.parameter_value   = haou.name
                                                 )
         )   distinct_business_groups;
--
--
/*
** MIGRATE_DATE_FROM
*/
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'HCM'                                   
         ,'HR'                                    
         ,'HCMEMPLOYEE'                           
         ,'ALL'                                   
         ,'MIGRATE_DATE_FROM'                     
         ,'1992-01-01'                            
         ,'Y'                                     
         ,'XXMX'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'HCM'
                      AND    application       = 'HR'
                      AND    business_entity   = 'HCMEMPLOYEE'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'MIGRATE_DATE_FROM'
                     );
					 
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'HCM'                                   
         ,'IREC'                                    
         ,'ALL'                           
         ,'ALL'                                   
         ,'MIGRATE_DATE_FROM'                     
         ,'1992-01-01'                            
         ,'Y'                                     
         ,'XXMX'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'HCM'
                      AND    application       = 'IREC'
                      AND    business_entity   = 'ALL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'MIGRATE_DATE_FROM'
                     );
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'HCM'                                   
         ,'IREC'                                    
         ,'JOB_REFERRAL'                           
         ,'ALL'                                   
         ,'MIGRATE_DATE_FROM'                     
         ,'1992-01-01'                            
         ,'Y'                                     
         ,'XXMX'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'HCM'
                      AND    application       = 'IREC'
                      AND    business_entity   = 'JOB_REFERRAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'MIGRATE_DATE_FROM'
                     );

INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'HCM'                                   
         ,'IREC'                                    
         ,'JR_HIRING_TEAM'                           
         ,'ALL'                                   
         ,'MIGRATE_DATE_FROM'                     
         ,'1992-01-01'                            
         ,'Y'                                     
         ,'XXMX'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'HCM'
                      AND    application       = 'IREC'
                      AND    business_entity   = 'JR_HIRING_TEAM'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'MIGRATE_DATE_FROM'
                     );
--
--
/*
** MIGRATE_DATE_TO
*/
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'HCM'                                   
         ,'HR'                                    
         ,'HCMEMPLOYEE'                           
         ,'ALL'                                   
         ,'MIGRATE_DATE_TO'                       
         ,'2019-01-01'                            
         ,'Y'                                     
         ,'XXMX'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'HCM'
                      AND    application       = 'HR'
                      AND    business_entity   = 'HCMEMPLOYEE'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'MIGRATE_DATE_TO'
                     );
					 
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'HCM'                                   
         ,'IREC'                                    
         ,'ALL'                           
         ,'ALL'                                   
         ,'MIGRATE_DATE_TO'                       
         ,'2019-01-01'                            
         ,'Y'                                     
         ,'XXMX'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'HCM'
                      AND    application       = 'IREC'
                      AND    business_entity   = 'ALL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'MIGRATE_DATE_TO'
                     );

INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'HCM'                                   
         ,'IREC'                                    
         ,'JOB_REFERRAL'                           
         ,'ALL'                                   
         ,'MIGRATE_DATE_TO'                       
         ,'2019-01-01'                            
         ,'Y'                                     
         ,'XXMX'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'HCM'
                      AND    application       = 'IREC'
                      AND    business_entity   = 'JOB_REFERRAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'MIGRATE_DATE_TO'
                     );

INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'HCM'                                   
         ,'IREC'                                    
         ,'JR_HIRING_TEAM'                           
         ,'ALL'                                   
         ,'MIGRATE_DATE_TO'                       
         ,'2019-01-01'                            
         ,'Y'                                     
         ,'XXMX'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'HCM'
                      AND    application       = 'IREC'
                      AND    business_entity   = 'JR_HIRING_TEAM'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'MIGRATE_DATE_TO'
                     );
--
--
/*
** MIGRATE_DATE_TO
*/
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'HCM'                                   
         ,'HR'                                    
         ,'HCMEMPLOYEE'                           
         ,'ALL'                                   
         ,'PREV_TAX_YEAR_DATE'                    
         ,'2019-01-01'                            
         ,'Y'                                     
         ,'XXMX'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'HCM'
                      AND    application       = 'HR'
                      AND    business_entity   = 'HCMEMPLOYEE'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PREV_TAX_YEAR_DATE'
                     );
--
--
/*****************************************************************************************************
** HCM Payroll Parameters
******************************************************************************************************/
--
--
--** All existing DISTINCT Payroll Names
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'HCM'                                   
         ,'PAY'                                   
         ,'PAYROLL'                               
         ,'ALL'                                   
         ,'PAYROLL_NAME'                          
         ,distinct_payrolls.payroll_name          
         ,'Y'                                     
         ,'SOURCE_DB'                             
FROM     (
          SELECT  DISTINCT
                  ppf.payroll_name
          FROM    apps.pay_payrolls_f@mxdm_nvis_extract  ppf
          WHERE   1 = 1
          AND     SYSDATE   BETWEEN ppf.effective_start_date
                                AND ppf.effective_end_date
          AND     NOT EXISTS      (
                                   SELECT 'X'
                                   FROM   XXMX_CORE.xxmx_migration_parameters xmp2
                                   WHERE  1 = 1
                                   AND    xmp2.application_suite = 'HCM'
                                   AND    xmp2.application       = 'PAY'
                                   AND    xmp2.business_entity   = 'PAYROLL'
                                   AND    xmp2.sub_entity       = 'ALL'
                                   AND    xmp2.parameter_code    = 'PAYROLL_NAME'
                                   AND    xmp2.parameter_value   = ppf.payroll_name
                                  )
         )   distinct_payrolls;
--
--
/*
** MIGRATION_START_DATE_VAL
*/
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'HCM'                                   
         ,'PAY'                                   
         ,'PAYROLL'                               
         ,'ALL'                                   
         ,'MIGRATION_START_DATE_VAL'              
         ,'01-JAN-2020'                           
         ,'Y'                                     
         ,'XXMX'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'HCM'
                      AND    application       = 'PAY'
                      AND    business_entity   = 'PAYROLL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'MIGRATION_START_DATE_VAL'
                     );
--
/*
** MIGRATION_START_DATE_FMT
*/
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'HCM'                                   
         ,'PAY'                                   
         ,'PAYROLL'                               
         ,'ALL'                                   
         ,'MIGRATION_START_DATE_FMT'              
         ,'01-JAN-2020'                           
         ,'Y'                                     
         ,'XXMX'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'HCM'
                      AND    application       = 'PAY'
                      AND    business_entity   = 'PAYROLL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'MIGRATION_START_DATE_FMT'
                     );
--
--
/*
** SCOPE_ELEMENT_NAME - Student Loan
*/
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'HCM'                                   
         ,'PAY'                                   
         ,'PAYROLL'                               
         ,'ALL'                                   
         ,'SCOPE_ELEMENT_NAME'                    
         ,'Student Loan'                          
         ,'Y'                                     
         ,'XXMX'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'HCM'
                      AND    application       = 'PAY'
                      AND    business_entity   = 'PAYROLL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'SCOPE_ELEMENT_NAME'
                      AND    parameter_value   = 'Student Loan'
                     );
--
--
/*
** SCOPE_ELEMENT_NAME - NI
*/
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'HCM'                                   
         ,'PAY'                                   
         ,'PAYROLL'                               
         ,'ALL'                                   
         ,'SCOPE_ELEMENT_NAME'                    
         ,'NI'                                    
         ,'Y'                                     
         ,'XXMX'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'HCM'
                      AND    application       = 'PAY'
                      AND    business_entity   = 'PAYROLL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'SCOPE_ELEMENT_NAME'
                      AND    parameter_value   = 'NI'
                     );
--
--
/*
** SCOPE_ELEMENT_NAME - PAYE Details
*/
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'HCM'                                   
         ,'PAY'                                   
         ,'PAYROLL'                               
         ,'ALL'                                   
         ,'SCOPE_ELEMENT_NAME'                    
         ,'PAYE Details'                          
         ,'Y'                                     
         ,'XXMX'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'HCM'
                      AND    application       = 'PAY'
                      AND    business_entity   = 'PAYROLL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'SCOPE_ELEMENT_NAME'
                      AND    parameter_value   = 'PAYE Details'
                     );
--
COMMIT;
--

INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         )
         (
SELECT  XXMX_MIGRATION_PARAMETER_IDS_S.NEXTVAL  
       ,'HCM'                               
       ,'HR'                                
       ,'HCMEMPLOYEE'                               
       ,'ALL'                               
       ,'PERSON_TYPE'               
       ,distinct_person_type.name       
       ,'Y'                                 
FROM    (
         select distinct  UPPER(ppt.user_person_type)  name
		FROM     apps.per_all_people_f@MXDM_NVIS_EXTRACT papf
                ,apps.per_person_type_usages_f@MXDM_NVIS_EXTRACT  pptu
                ,apps.per_person_types@MXDM_NVIS_EXTRACT  ppt
        WHERE   1 = 1
        AND papf.person_id = pptu.person_id
        AND ppt.person_type_id  = pptu.person_type_id
        AND ppt.system_person_type IN('EMP','CWK')
        AND trunc(sysdate) BETWEEN  pptu.effective_Start_Date and pptu.effective_end_date
        AND trunc(sysdate) BETWEEN  papf.effective_Start_Date and papf.effective_end_date
        )   distinct_person_type
    );
	
---
COMMIT;	
---

/*
** SCOPE_ELEMENT_NAME - 300000012242895
*/
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'AR'                                   
         ,'TRANSACTIONS'                               
         ,'ALL'                                   
         ,'AR_TRX_SOURCE_ID'                    
         ,'300000012242895'                          
         ,'Y'                                     
         ,'XXMX'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'AR'
                      AND    business_entity   = 'TRANSACTIONS'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'AR_TRX_SOURCE_ID'
                      AND    parameter_value   = '300000012242895'
                     );
--
COMMIT;
--

/*
** SCOPE_ELEMENT_NAME - I
*/
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'HCM'                                   
         ,'HR'                                   
         ,'ALL'                               
         ,'ALL'                                   
         ,'ASSIGNMENT_DFF'                    
         ,'I'                          			
         ,'Y'                                     
         ,'XXMX'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'HCM'
                      AND    application       = 'HR'
                      AND    business_entity   = 'ALL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'ASSIGNMENT_DFF'
                      AND    parameter_value   = 'I'
                     );
--
COMMIT;
--

/*
** SCOPE_ELEMENT_NAME - DETAIL
*/
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'PPM'                                   
         ,'PRJ_COST'                               
         ,'ALL'                                   
         ,'COST_EXT_TYPE'                    
         ,'DETAIL'                          			
         ,'Y'                                     
         ,'XXMX'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'PPM'
                      AND    business_entity   = 'PRJ_COST'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'COST_EXT_TYPE'
                      AND    parameter_value   = 'DETAIL'
                     );
--
COMMIT;
--

/*
** SCOPE_ELEMENT_NAME - 31-AUG-2021
*/
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'FA'                                   
         ,'ALL'                               
         ,'ALL'                                   
         ,'CUT_OFF_DATE'                    
         ,'31-AUG-2021'                          			
         ,'Y'                                     
         ,'XXMX'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'FA'
                      AND    business_entity   = 'ALL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'CUT_OFF_DATE'
                      AND    parameter_value   = '31-AUG-2021'
                     );
--
COMMIT;
--

/*
** SCOPE_ELEMENT_NAME - 31-DEC-1997
*/
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'PPM'                                   
         ,'ALL'                               	  
         ,'ALL'                                	  
         ,'EXTRACT_END_DATE'                      
         ,'31-DEC-1997'                           
         ,'Y'                                     
         ,'XXMX'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'FA'
                      AND    business_entity   = 'ALL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'EXTRACT_END_DATE'
                      AND    parameter_value   = '31-DEC-1997'
                     );
--
COMMIT;
--

/*
** SCOPE_ELEMENT_NAME - 01-JAN-1997
*/
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'PPM'                                   
         ,'ALL'                               	  
         ,'ALL'                                	  
         ,'EXTRACT_START_DATE'                      
         ,'01-JAN-1997'                           
         ,'Y'                                     
         ,'XXMX'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'FA'
                      AND    business_entity   = 'ALL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'EXTRACT_START_DATE'
                      AND    parameter_value   = '01-JAN-1997'
                     );
--
COMMIT;
--

/*
** SCOPE_ELEMENT_NAME - Y
*/
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'ALL'                                   
         ,'ALL'                               	  
         ,'ALL'                                	  
         ,'FTP_ENABLED'                      
         ,'Y'                           
         ,'Y'                                     
         ,'XXMX'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'ALL'
                      AND    business_entity   = 'ALL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'FTP_ENABLED'
                      AND    parameter_value   = 'Y'
                     );
					 
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'HCM'                                   
         ,'ALL'                                   
         ,'ALL'                               	  
         ,'ALL'                                	  
         ,'FTP_ENABLED'                      
         ,'Y'                           
         ,'Y'                                     
         ,'XXMX'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'HCM'
                      AND    application       = 'ALL'
                      AND    business_entity   = 'ALL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'FTP_ENABLED'
                      AND    parameter_value   = 'Y'
                     );					 
--
COMMIT;
--

/*
** SCOPE_ELEMENT_NAME - MAR-97
*/
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'PPM'                                   
         ,'ALL'                               	  
         ,'ALL'                                	  
         ,'GL_PERIOD_NAME'                      
         ,'MAR-97'                           
         ,'Y'                                     
         ,'XXMX'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'PPM'
                      AND    business_entity   = 'ALL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'GL_PERIOD_NAME'
                      AND    parameter_value   = 'MAR-97'
                     );
					 
--
COMMIT;
--

/*
** SCOPE_ELEMENT_NAME - Y
*/
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'AR'                                   
         ,'TRANSACTIONS'                               	  
         ,'ALL'                                	  
         ,'INCLUDE_CREDIT_MEMOS'                      
         ,'Y'                           
         ,'Y'                                     
         ,'XXMX'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'AR'
                      AND    business_entity   = 'TRANSACTIONS'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'INCLUDE_CREDIT_MEMOS'
                      AND    parameter_value   = 'Y'
                     );
	

INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'AR'                                   
         ,'TRANSACTIONS'                               	  
         ,'ALL'                                	  
         ,'INCLUDE_DEBIT_MEMOS'                      
         ,'Y'                           
         ,'Y'                                     
         ,'XXMX'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'AR'
                      AND    business_entity   = 'TRANSACTIONS'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'INCLUDE_DEBIT_MEMOS'
                      AND    parameter_value   = 'Y'
                     );	
--
COMMIT;
--

/*
** SCOPE_ELEMENT_NAME - 2
*/
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'AR'                                   
         ,'CUSTOMERS'                          
         ,'ALL'                                	  
         ,'NO_ACTIVITY_CUSTOMER_MONTHS'                    
         ,'2'                          			 
         ,'Y'                                     
         ,'XXMX'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'AR'
                      AND    business_entity   = 'CUSTOMERS'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'NO_ACTIVITY_CUSTOMER_MONTHS'
                      AND    parameter_value   = '2'
                     );	
--
COMMIT;
--

/*
** SCOPE_ELEMENT_NAME - SEGMENT1-SEGMENT3
*/
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'HCM'                                   
         ,'HR'                                   
         ,'ALL'                          			
         ,'ALL'                                	  
         ,'PEOPLE_GROUP'                    		
         ,'SEGMENT1-SEGMENT3'                     
         ,'Y'                                     
         ,'XXMX'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'HCM'
                      AND    application       = 'HR'
                      AND    business_entity   = 'ALL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PEOPLE_GROUP'
                      AND    parameter_value   = 'SEGMENT1-SEGMENT3'
                     );	
--
COMMIT;
--


/*
** SCOPE_ELEMENT_NAME - EBS
*/
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'HCM'                                   
         ,'ALL'                                   
         ,'ALL'                          			
         ,'ALL'                                	  
         ,'SOURCESYSTEMOWNER'                    		
         ,'EBS'                   				  
         ,'Y'                                     
         ,'XXMX'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'HCM'
                      AND    application       = 'HR'
                      AND    business_entity   = 'ALL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'SOURCESYSTEMOWNER'
                      AND    parameter_value   = 'EBS'
                     );	
--
COMMIT;
--

/*
** SCOPE_ELEMENT_NAME - Y
*/
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'XXMX'                                   
         ,'GL'                                   
         ,'UTILITIES'                          		
         ,'DEFAULT_ACCOUNT_TRANSFORMS'        	  
         ,'USE_PLACEBO_SEGMENT_VALUE'             
         ,'Y'                   				  
         ,'Y'                                     
         ,'XXMX'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'XXMX'
                      AND    application       = 'GL'
                      AND    business_entity   = 'UTILITIES'
                      AND    sub_entity        = 'DEFAULT_ACCOUNT_TRANSFORMS'
                      AND    parameter_code    = 'USE_PLACEBO_SEGMENT_VALUE'
                      AND    parameter_value   = 'Y'
                     );	

---FA
---ALL
---BOOK_TYPE_CODE

INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'FA'                                    
         ,'ALL'                              	
         ,'ALL'                       			
         ,'BOOK_TYPE_CODE'                 		
         ,distinct_book.BOOK_TYPE_CODE           
         ,'Y'                                     
         ,'SOURCE_DB'                             
FROM     (
          SELECT  distinct FB.BOOK_TYPE_CODE 
          FROM    apps.fa_books@mxdm_nvis_extract    FB
          WHERE   
          NOT EXISTS                     (
                                                  SELECT 'X'
                                                  FROM   XXMX_CORE.xxmx_migration_parameters xmp2
                                                  WHERE  1 = 1
                                                  AND    xmp2.application_suite = 'FIN'
                                                  AND    xmp2.application       = 'FA'
                                                  AND    xmp2.business_entity   = 'ALL'
                                                  AND    xmp2.sub_entity        = 'ALL'
                                                  AND    xmp2.parameter_code    = 'BOOK_TYPE_CODE'
                                                  AND    xmp2.parameter_value   = fb.BOOK_TYPE_CODE 
                                                 )
         )   distinct_book;         




--- IREC 
--- CANDIDATE 
--- PERSON_TYPE

INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'HCM'                                   
         ,'IREC'                                  
         ,'CANDIDATE'                             
         ,'ALL'                       			    
         ,'PERSON_TYPE'                 		    
         ,'APPLICANT'                        		 
         ,'Y'                                    
         ,'SOURCE_DB'                             
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'HCM'
                      AND    application       = 'IREC'
                      AND    business_entity   = 'CANDIDATE'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERSON_TYPE'
                      AND 	 parameter_value   = 'APPLICANT'
                     );

--- IREC 
--- CANDIDATE 
--- PERSON_TYPE

INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'HCM'                                   
         ,'IREC'                                  
         ,'CANDIDATE'                              	
         ,'ALL'                       			
         ,'PERSON_TYPE'                 		
         ,'EXTERNAL'                        		
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      Dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'HCM'
                      AND    application       = 'IREC'
                      AND    business_entity   = 'CANDIDATE'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERSON_TYPE'
                      AND 	 parameter_value   = 'EXTERNAL'
                     );
--- PO 
--- PURCHASE_ORDERS 
--- ORGANIZATION_NAME

INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'SCM'                                   
         ,'PO'                                   
         ,'ALL'                                   
         ,'ALL'                                   
         ,'ORGANIZATION_NAME'                     
         ,distinct_orgs.name                      
         ,'Y'                                     
         ,'SOURCE_DB'                             
FROM     (
          SELECT  DISTINCT
                  haou.name
          FROM    apps.hr_all_organization_units@mxdm_nvis_extract    haou
                 ,apps.hr_organization_information@mxdm_nvis_extract  hoi
          WHERE   1 = 1
          AND     NVL(haou.date_to, SYSDATE + 1) > SYSDATE
          AND     hoi.organization_id            = haou.organization_id
          AND     hoi.org_information1           = 'OPERATING_UNIT'
          AND     NOT EXISTS                     (
                                                  SELECT 'X'
                                                  FROM   XXMX_CORE.xxmx_migration_parameters xmp2
                                                  WHERE  1 = 1
                                                  AND    xmp2.application_suite = 'SCM'
                                                  AND    xmp2.application       = 'PO'
                                                  AND    xmp2.business_entity   = 'ALL'
                                                  AND    xmp2.sub_entity        = 'ALL'
                                                  AND    xmp2.parameter_code    = 'ORGANIZATION_NAME'
                                                  AND    xmp2.parameter_value   = haou.name
                                                 )
         )   distinct_orgs;
					 
---PO
---PURCHASE_ORDERS
---PO_TYPE

INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'SCM'                                   
         ,'PO'                                   
         ,'ALL'                                   
         ,'ALL'                                   
         ,'PO_TYPE'                     
         ,distinct_po.PO_TYPE                      
         ,'Y'                                     
         ,'SOURCE_DB'                             
FROM     (
          SELECT  DISTINCT
                  poh.Type_lookup_code PO_TYPE
          FROM    apps.po_headers_all@mxdm_nvis_extract    poh
          WHERE   
          NOT EXISTS                     (
                                                  SELECT 'X'
                                                  FROM   XXMX_CORE.xxmx_migration_parameters xmp2
                                                  WHERE  1 = 1
                                                  AND    xmp2.application_suite = 'SCM'
                                                  AND    xmp2.application       = 'ALL'
                                                  AND    xmp2.business_entity   = 'ALL'
                                                  AND    xmp2.sub_entity        = 'ALL'
                                                  AND    xmp2.parameter_code    = 'PO_TYPE'
                                                  AND    xmp2.parameter_value   = poh.Type_lookup_code
                                                 )
         )   distinct_po;  
         


---PPM
---PRJ_COST
---EXP_SYSTEM_LINK_TYPE

INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'PPM'                                    
         ,'PRJ_COST'                              	
         ,'EXPENSE_COST'                       			
         ,'EXP_SYSTEM_LINK_TYPE'                 		
         ,'ER'                        			
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'PPM'
                      AND    business_entity   = 'PRJ_COST'
                      AND    sub_entity        = 'EXPENSE_COST'
                      AND    parameter_code    = 'EXP_SYSTEM_LINK_TYPE'
                      AND 	  parameter_value   = 'ER'
                     );


INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'PPM'                                    
         ,'PRJ_COST'                              	
         ,'SUPPLIER_COST'                       			
         ,'EXP_SYSTEM_LINK_TYPE'                 		
         ,'VI'                        			
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'PPM'
                      AND    business_entity   = 'PRJ_COST'
                      AND    sub_entity        = 'SUPPLIER_COST'
                      AND    parameter_code    = 'EXP_SYSTEM_LINK_TYPE'
                      AND 	  parameter_value   = 'VI'
                     );
                     

INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'PPM'                                    
         ,'PRJ_COST'                              	
         ,'MISC_COSTS'                       			
         ,'EXP_SYSTEM_LINK_TYPE'                 		
         ,'PJ'                        			
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'PPM'
                      AND    business_entity   = 'PRJ_COST'
                      AND    sub_entity        = 'MISC_COSTS'
                      AND    parameter_code    = 'EXP_SYSTEM_LINK_TYPE'
                      AND 	  parameter_value   = 'PJ'
                     );  


INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'PPM'                                    
         ,'PRJ_COST'                              	
         ,'LABOUR_COST'                       			
         ,'EXP_SYSTEM_LINK_TYPE'                 		
         ,'OT'                        			
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM     dual 
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'PPM'
                      AND    business_entity   = 'PRJ_COST'
                      AND    sub_entity        = 'LABOUR_COST'
                      AND    parameter_code    = 'EXP_SYSTEM_LINK_TYPE'
                      AND 	  parameter_value   = 'OT'
                     ); 


INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'PPM'                                    
         ,'PRJ_COST'                              	
         ,'LABOUR_COST'                       			
         ,'EXP_SYSTEM_LINK_TYPE'                 		
         ,'ST'                        			
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM     dual 
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'PPM'
                      AND    business_entity   = 'PRJ_COST'
                      AND    sub_entity        = 'LABOUR_COST'
                      AND    parameter_code    = 'EXP_SYSTEM_LINK_TYPE'
                      AND 	  parameter_value   = 'ST'
                     );      


INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'PPM'                                    
         ,'PRJ_COST'                              	
         ,'NON_LBR_COST'                       			
         ,'EXP_SYSTEM_LINK_TYPE'                 		
         ,'INV'                        			
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'PPM'
                      AND    business_entity   = 'PRJ_COST'
                      AND    sub_entity        = 'NON_LBR_COST'
                      AND    parameter_code    = 'EXP_SYSTEM_LINK_TYPE'
                      AND 	  parameter_value   = 'INV'
                     ); 

INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'PPM'                                    
         ,'PRJ_COST'                              	
         ,'NON_LBR_COST'                       			
         ,'EXP_SYSTEM_LINK_TYPE'                 		
         ,'WIP'                        			
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'PPM'
                      AND    business_entity   = 'PRJ_COST'
                      AND    sub_entity        = 'NON_LBR_COST'
                      AND    parameter_code    = 'EXP_SYSTEM_LINK_TYPE'
                      AND 	  parameter_value   = 'WIP'
                     );                      

INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'PPM'                                    
         ,'PRJ_COST'                              	
         ,'NON_LBR_COST'                       			
         ,'EXP_SYSTEM_LINK_TYPE'                 		
         ,'USG'                        			
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'PPM'
                      AND    business_entity   = 'PRJ_COST'
                      AND    sub_entity        = 'NON_LBR_COST'
                      AND    parameter_code    = 'EXP_SYSTEM_LINK_TYPE'
                      AND 	  parameter_value   = 'USG'
                     ); 

INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'PPM'                                    
         ,'PRJ_COST'                              	
         ,'NON_LBR_COST'                       			
         ,'EXP_SYSTEM_LINK_TYPE'                 		
         ,'BTC'                        			
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'PPM'
                      AND    business_entity   = 'PRJ_COST'
                      AND    sub_entity        = 'NON_LBR_COST'
                      AND    parameter_code    = 'EXP_SYSTEM_LINK_TYPE'
                      AND 	  parameter_value   = 'BTC'
                     );                       

--- PPM 
--- PROJECTS 
--- PROJECT_STATUS_CODE

INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'PPM'                                   
         ,'PROJECTS'                                   
         ,'ALL'                                   
         ,'PROJECT_STATUS_CODE'                     
         ,distinct_orgs.Project_code                      
         ,'Y'                                     
         ,'SOURCE_DB'                             
FROM     (
          SELECT  DISTINCT
                  PPA.PROJECT_STATUS_CODE Project_code
          FROM    apps.pa_projects_all@mxdm_nvis_extract    PPA
          WHERE   
          NOT EXISTS                     (
                                                  SELECT 'X'
                                                  FROM   XXMX_CORE.xxmx_migration_parameters xmp2
                                                  WHERE  1 = 1
                                                  AND    xmp2.application_suite = 'FIN'
                                                  AND    xmp2.application       = 'PPM'
                                                  AND    xmp2.business_entity   = 'PROJECTS'
                                                  AND    xmp2.sub_entity        = 'ALL'
                                                  AND    xmp2.parameter_code    = 'PROJECT_STATUS_CODE'
                                                  AND    xmp2.parameter_value   = PPA.PROJECT_STATUS_CODE
                                                 )
         )   distinct_orgs;           
         
					 
---PPM
---PROJECTS
---PROJECT_TYPE

INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'PPM'                                   
         ,'PROJECTS'                                   
         ,'ALL'                                   
         ,'PROJECT_TYPE'                     
         ,distinct_orgs.Project_type                      
         ,'Y'                                     
         ,'SOURCE_DB'                             
FROM     (
          SELECT  DISTINCT
                  PPA.Project_type Project_type
          FROM    apps.pa_projects_all@mxdm_nvis_extract    PPA
          WHERE   
          NOT EXISTS                     (
                                                  SELECT 'X'
                                                  FROM   XXMX_CORE.xxmx_migration_parameters xmp2
                                                  WHERE  1 = 1
                                                  AND    xmp2.application_suite = 'FIN'
                                                  AND    xmp2.application       = 'PPM'
                                                  AND    xmp2.business_entity   = 'PROJECTS'
                                                  AND    xmp2.sub_entity        = 'ALL'
                                                  AND    xmp2.parameter_code    = 'PROJECT_TYPE'
                                                  AND    xmp2.parameter_value   = PPA.Project_type
                                                 )
         )   distinct_orgs;                    
--
COMMIT;
--

INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'GENERAL_LEDGER'                              	
         ,'ALL'                       			
         ,'JE_CATEGORY'                 		
         ,'AP Subledger Entries'                        			
         ,'Y'                                     
         ,'XXMX'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'GENERAL_LEDGER'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'JE_CATEGORY'
                      AND 	  parameter_value   = 'AP Subledger Entries'
                     );   
--


INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'GENERAL_LEDGER'                              	
         ,'ALL'                       			
         ,'JE_SOURCE'                 		
         ,'Payables'                        			
         ,'Y'                                     
         ,'XXMX'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'GENERAL_LEDGER'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'JE_SOURCE'
                      AND 	  parameter_value   = 'Payables'
                     );   
--

INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'GENERAL_LEDGER'                              	
         ,'ALL'                       			
         ,'STATUS'                 		
         ,'P'                        			
         ,'Y'                                     
         ,'XXMX'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'GENERAL_LEDGER'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'STATUS'
                      AND 	  parameter_value   = 'P'
                     );  
--
/*
** GL Daily Rates Parameters
*/
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'DAILY_RATES'                              
         ,'ALL'                                   
         ,'CUT_OFF_DATE'                          
         ,'01-JAN-2015'                                  
         ,'Y'                                     
         ,'XXMX'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'DAILY_RATES'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'CUT_OFF_DATE'
                      AND    parameter_value   = '01-JAN-2015'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'DAILY_RATES'                              
         ,'ALL'                                   
         ,'CONVERSION_TYPE'                          
         ,'Actual Average'                                  
         ,'Y'                                     
         ,'XXMX'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'DAILY_RATES'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'CONVERSION_TYPE'
                      AND    parameter_value   = 'Corporate'
                     );
--
--
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'DAILY_RATES'                              
         ,'ALL'                                   
         ,'CONVERSION_TYPE'                          
         ,'Actual Ending'                                  
         ,'Y'                                     
         ,'XXMX'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'DAILY_RATES'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'CONVERSION_TYPE'
                      AND    parameter_value   = '1000'
                     );
                     
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'HCM'                                   
         ,'HR'                                    
         ,'ALL'                              
         ,'ALL'                                   
         ,'BANK_TYPE'                          
         ,'EXTERNAL'                                  
         ,'Y'                                     
         ,'XXMX'                                  
FROM      dual
;
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'HCM'                                   
         ,'HR'                                    
         ,'ALL'                              
         ,'ALL'                                   
         ,'BANK_TYPE'                          
         ,'INTERNAL'                                  
         ,'Y'                                     
         ,'XXMX'                                  
FROM      dual
;
--                  
--
--
					 
--
COMMIT;
--   
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'HCM'                                   
         ,'HR'                                    
         ,'ALL'                              
         ,'ALL'                                   
         ,'BANK_TYPE'                          
         ,'HCM_BANK'                                  
         ,'Y'                                     
         ,'XXMX'                                  
FROM      dual
;
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'HCM'                                   
         ,'HR'                                    
         ,'ALL'                              
         ,'ALL'                                   
         ,'BANK_TYPE'                          
         ,'ALL'                                  
         ,'Y'                                     
         ,'XXMX'                                  
FROM      dual
;

                     
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'XXMX'                                   
         ,'XXMX'                                    
         ,'ALL'                              
         ,'ALL'                                   
         ,'DEBUG'                          
         ,'Y'                                  
         ,'Y'                                     
         ,'XXMX'                                  
FROM      dual
;              
--                  
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'HISTORICAL_RATES'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'APR-15'                                
         ,'Y'                                     
         ,'XXMX'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'HISTORICAL_RATES'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'APR-15'
                     );        

--
/*
** GL Open Balances Parameters
*/
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'OPEN_BAL'                              
         ,'ALL'                                   
         ,'EXTRACT_YEAR'                          
         ,'2009'                                  
         ,'Y'                                     
         ,'XXMX'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'OPEN_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'EXTRACT_YEAR'
                      AND    parameter_value   = '2009'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'OPEN_BAL'                              
         ,'ALL'                                   
         ,'EXTRACT_YEAR'                          
         ,'2010'                                  
         ,'Y'                                     
         ,'XXMX'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'OPEN_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'EXTRACT_YEAR'
                      AND    parameter_value   = '2010'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'OPEN_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'APR-15'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'OPEN_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'APR-15'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'OPEN_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'APR-20'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'OPEN_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'APR-20'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'OPEN_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'JUN-09'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'OPEN_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'JUN-09'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'OPEN_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'JUL-09'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'OPEN_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'JUL-09'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'OPEN_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'AUG-09'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'OPEN_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'AUG-09'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'OPEN_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'SEP-09'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'OPEN_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'SEP-09'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'OPEN_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'OCT-09'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'OPEN_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'OCT-09'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'OPEN_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'NOV-20'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'OPEN_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'NOV-20'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'OPEN_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'DEC-09'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'OPEN_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'DEC-09'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'OPEN_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'JAN-10'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'OPEN_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'JAN-10'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'OPEN_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'FEB-10'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'OPEN_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'FEB-10'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'OPEN_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'MAR-10'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'OPEN_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'MAR-10'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'OPEN_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'APR-10'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'OPEN_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'APR-10'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'OPEN_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'MAY-10'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'OPEN_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'MAY-10'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'OPEN_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'JUN-10'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'OPEN_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'JUN-10'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'OPEN_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'JUL-10'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'OPEN_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'JUL-10'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'OPEN_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'AUG-10'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'OPEN_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'AUG-10'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'OPEN_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'SEP-10'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'OPEN_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'SEP-10'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'OPEN_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'OCT-10'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'OPEN_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'OCT-10'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'OPEN_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'NOV-10'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'OPEN_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'NOV-10'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'OPEN_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'DEC-10'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'OPEN_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'DEC-10'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'OPEN_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'Jan-10'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'OPEN_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'Jan-10'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'OPEN_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'Feb-10'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'OPEN_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'Feb-10'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'OPEN_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'Mar-10'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'OPEN_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'Mar-10'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'OPEN_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'Apr-10'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'OPEN_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'Apr-10'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'OPEN_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'May-10'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'OPEN_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'May-10'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'OPEN_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'Jun-10'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'OPEN_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'Jun-10'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'OPEN_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'Jul-10'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'OPEN_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'Jul-10'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'OPEN_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'Aug-10'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'OPEN_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'Aug-10'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'OPEN_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'Sep-10'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'OPEN_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'Sep-10'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'OPEN_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'Oct-10'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'OPEN_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'Oct-10'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'OPEN_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'Nov-10'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'OPEN_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'Nov-10'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'OPEN_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'Dec-10'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'OPEN_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'Dec-10'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'OPEN_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'JAN-09'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'OPEN_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'JAN-09'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'OPEN_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'FEB-09'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'OPEN_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'FEB-09'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'OPEN_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'MAR-09'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'OPEN_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'MAR-09'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'OPEN_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'APR-09'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'OPEN_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'APR-09'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'OPEN_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'MAY-09'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'OPEN_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'MAY-09'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'OPEN_BAL'                              
         ,'ALL'                                   
         ,'EXTRACT_YEAR'                           
         ,'2014'                                
         ,'Y'                                     
         ,'XXMX'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'OPEN_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'EXTRACT_YEAR'
                      AND    parameter_value   = '2014'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'OPEN_BAL'                              
         ,'ALL'                                   
         ,'EXTRACT_YEAR'                           
         ,'2015'                                
         ,'Y'                                     
         ,'XXMX'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'OPEN_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'EXTRACT_YEAR'
                      AND    parameter_value   = '2015'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'OPEN_BAL'                              
         ,'ALL'                                   
         ,'BATCH_SOURCE'                           
         ,'EBS Data Migration'                                
         ,'Y'                                     
         ,'EBS'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'OPEN_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'BATCH_SOURCE'
                      AND    parameter_value   = 'EBS Data Migration'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'OPEN_BAL'                              
         ,'ALL'                                   
         ,'BATCH_CATEGORY_NAME'                           
         ,'EBS Data Migration'                                
         ,'Y'                                     
         ,'EBS'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'OPEN_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'BATCH_CATEGORY_NAME'
                      AND    parameter_value   = 'EBS Data Migration'
                     );
--
--
/*
** GL Summary Balances Parameters
*/
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'SUMM_BAL'                              
         ,'ALL'                                   
         ,'EXTRACT_YEAR'                          
         ,'2009'                                  
         ,'Y'                                     
         ,'XXMX'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'SUMM_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'EXTRACT_YEAR'
                      AND    parameter_value   = '2009'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'SUMM_BAL'                              
         ,'ALL'                                   
         ,'EXTRACT_YEAR'                          
         ,'2010'                                  
         ,'Y'                                     
         ,'XXMX'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'SUMM_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'EXTRACT_YEAR'
                      AND    parameter_value   = '2010'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'SUMM_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'APR-15'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'SUMM_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'APR-15'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'SUMM_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'APR-20'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'SUMM_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'APR-20'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'SUMM_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'JUN-09'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'SUMM_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'JUN-09'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'SUMM_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'JUL-09'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'SUMM_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'JUL-09'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'SUMM_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'AUG-09'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'SUMM_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'AUG-09'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'SUMM_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'SEP-09'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'SUMM_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'SEP-09'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'SUMM_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'OCT-09'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'SUMM_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'OCT-09'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'SUMM_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'NOV-20'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'SUMM_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'NOV-20'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'SUMM_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'DEC-09'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'SUMM_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'DEC-09'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'SUMM_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'JAN-10'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'SUMM_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'JAN-10'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'SUMM_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'FEB-10'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'SUMM_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'FEB-10'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'SUMM_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'MAR-10'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'SUMM_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'MAR-10'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'SUMM_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'APR-10'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'SUMM_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'APR-10'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'SUMM_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'MAY-10'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'SUMM_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'MAY-10'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'SUMM_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'JUN-10'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'SUMM_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'JUN-10'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'SUMM_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'JUL-10'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'SUMM_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'JUL-10'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'SUMM_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'AUG-10'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'SUMM_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'AUG-10'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'SUMM_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'SEP-10'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'SUMM_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'SEP-10'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'SUMM_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'OCT-10'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'SUMM_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'OCT-10'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'SUMM_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'NOV-10'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'SUMM_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'NOV-10'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'SUMM_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'DEC-10'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'SUMM_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'DEC-10'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'SUMM_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'Jan-10'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'SUMM_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'Jan-10'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'SUMM_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'Feb-10'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'SUMM_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'Feb-10'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'SUMM_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'Mar-10'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'SUMM_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'Mar-10'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'SUMM_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'Apr-10'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'SUMM_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'Apr-10'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'SUMM_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'May-10'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'SUMM_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'May-10'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'SUMM_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'Jun-10'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'SUMM_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'Jun-10'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'SUMM_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'Jul-10'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'SUMM_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'Jul-10'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'SUMM_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'Aug-10'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'SUMM_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'Aug-10'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'SUMM_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'Sep-10'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'SUMM_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'Sep-10'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'SUMM_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'Oct-10'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'SUMM_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'Oct-10'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'SUMM_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'Nov-10'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'SUMM_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'Nov-10'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'SUMM_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'Dec-10'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'SUMM_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'Dec-10'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'SUMM_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'JAN-09'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'SUMM_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'JAN-09'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'SUMM_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'FEB-09'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'SUMM_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'FEB-09'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'SUMM_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'MAR-09'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'SUMM_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'MAR-09'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'SUMM_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'APR-09'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'SUMM_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'APR-09'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'SUMM_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'MAY-09'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'SUMM_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'MAY-09'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'SUMM_BAL'                              
         ,'ALL'                                   
         ,'EXTRACT_YEAR'                           
         ,'2014'                                
         ,'Y'                                     
         ,'XXMX'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'SUMM_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'EXTRACT_YEAR'
                      AND    parameter_value   = '2014'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'SUMM_BAL'                              
         ,'ALL'                                   
         ,'EXTRACT_YEAR'                           
         ,'2015'                                
         ,'Y'                                     
         ,'XXMX'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'SUMM_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'EXTRACT_YEAR'
                      AND    parameter_value   = '2015'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'SUMM_BAL'                              
         ,'ALL'                                   
         ,'BATCH_SOURCE'                           
         ,'EBS Data Migration'                                
         ,'Y'                                     
         ,'EBS'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'SUMM_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'BATCH_SOURCE'
                      AND    parameter_value   = 'EBS Data Migration'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'SUMM_BAL'                              
         ,'ALL'                                   
         ,'BATCH_CATEGORY_NAME'                           
         ,'EBS Data Migration'                                
         ,'Y'                                     
         ,'EBS'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'SUMM_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'BATCH_CATEGORY_NAME'
                      AND    parameter_value   = 'EBS Data Migration'
                     );
--
--
/*
** GL Detail Balances Parameters
*/
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'DETAIL_BAL'                              
         ,'ALL'                                   
         ,'EXTRACT_YEAR'                          
         ,'2009'                                  
         ,'Y'                                     
         ,'XXMX'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'DETAIL_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'EXTRACT_YEAR'
                      AND    parameter_value   = '2009'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'DETAIL_BAL'                              
         ,'ALL'                                   
         ,'EXTRACT_YEAR'                          
         ,'2010'                                  
         ,'Y'                                     
         ,'XXMX'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'DETAIL_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'EXTRACT_YEAR'
                      AND    parameter_value   = '2010'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'DETAIL_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'APR-15'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'DETAIL_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'APR-15'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'DETAIL_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'APR-20'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'DETAIL_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'APR-20'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'DETAIL_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'JUN-09'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'DETAIL_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'JUN-09'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'DETAIL_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'JUL-09'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'DETAIL_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'JUL-09'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'DETAIL_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'AUG-09'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'DETAIL_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'AUG-09'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'DETAIL_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'SEP-09'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'DETAIL_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'SEP-09'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'DETAIL_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'OCT-09'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'DETAIL_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'OCT-09'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'DETAIL_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'NOV-20'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'DETAIL_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'NOV-20'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'DETAIL_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'DEC-09'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'DETAIL_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'DEC-09'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'DETAIL_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'JAN-10'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'DETAIL_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'JAN-10'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'DETAIL_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'FEB-10'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'DETAIL_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'FEB-10'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'DETAIL_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'MAR-10'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'DETAIL_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'MAR-10'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'DETAIL_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'APR-10'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'DETAIL_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'APR-10'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'DETAIL_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'MAY-10'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'DETAIL_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'MAY-10'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'DETAIL_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'JUN-10'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'DETAIL_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'JUN-10'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'DETAIL_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'JUL-10'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'DETAIL_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'JUL-10'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'DETAIL_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'AUG-10'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'DETAIL_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'AUG-10'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'DETAIL_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'SEP-10'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'DETAIL_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'SEP-10'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'DETAIL_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'OCT-10'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'DETAIL_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'OCT-10'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'DETAIL_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'NOV-10'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'DETAIL_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'NOV-10'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'DETAIL_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'DEC-10'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'DETAIL_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'DEC-10'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'DETAIL_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'Jan-10'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'DETAIL_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'Jan-10'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'DETAIL_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'Feb-10'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'DETAIL_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'Feb-10'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'DETAIL_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'Mar-10'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'DETAIL_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'Mar-10'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'DETAIL_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'Apr-10'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'DETAIL_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'Apr-10'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'DETAIL_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'May-10'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'DETAIL_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'May-10'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'DETAIL_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'Jun-10'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'DETAIL_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'Jun-10'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'DETAIL_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'Jul-10'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'DETAIL_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'Jul-10'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'DETAIL_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'Aug-10'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'DETAIL_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'Aug-10'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'DETAIL_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'Sep-10'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'DETAIL_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'Sep-10'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'DETAIL_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'Oct-10'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'DETAIL_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'Oct-10'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'DETAIL_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'Nov-10'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'DETAIL_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'Nov-10'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'DETAIL_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'Dec-10'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'DETAIL_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'Dec-10'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'DETAIL_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'JAN-09'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'DETAIL_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'JAN-09'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'DETAIL_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'FEB-09'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'DETAIL_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'FEB-09'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'DETAIL_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'MAR-09'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'DETAIL_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'MAR-09'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'DETAIL_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'APR-09'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'DETAIL_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'APR-09'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'DETAIL_BAL'                              
         ,'ALL'                                   
         ,'PERIOD_NAME'                           
         ,'MAY-09'                                
         ,'Y'                                     
         ,'SOURCE_DB'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'DETAIL_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'PERIOD_NAME'
                      AND    parameter_value   = 'MAY-09'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'DETAIL_BAL'                              
         ,'ALL'                                   
         ,'EXTRACT_YEAR'                           
         ,'2014'                                
         ,'Y'                                     
         ,'XXMX'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'DETAIL_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'EXTRACT_YEAR'
                      AND    parameter_value   = '2014'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'DETAIL_BAL'                              
         ,'ALL'                                   
         ,'EXTRACT_YEAR'                           
         ,'2015'                                
         ,'Y'                                     
         ,'XXMX'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'DETAIL_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'EXTRACT_YEAR'
                      AND    parameter_value   = '2015'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'DETAIL_BAL'                              
         ,'ALL'                                   
         ,'BATCH_SOURCE'                           
         ,'EBS Data Migration'                                
         ,'Y'                                     
         ,'EBS'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'DETAIL_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'BATCH_SOURCE'
                      AND    parameter_value   = 'EBS Data Migration'
                     );
--
--
INSERT
INTO   XXMX_CORE.xxmx_migration_parameters
         (
          parameter_id
         ,application_suite
         ,application
         ,business_entity
         ,sub_entity
         ,parameter_code
         ,parameter_value
         ,enabled_flag
         ,data_source
         )
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  
         ,'FIN'                                   
         ,'GL'                                    
         ,'DETAIL_BAL'                              
         ,'ALL'                                   
         ,'BATCH_CATEGORY_NAME'                           
         ,'EBS Data Migration'                                
         ,'Y'                                     
         ,'EBS'                                  
FROM      dual
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'DETAIL_BAL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'BATCH_CATEGORY_NAME'
                      AND    parameter_value   = 'EBS Data Migration'
                     );
--
--
COMMIT;
--                                       