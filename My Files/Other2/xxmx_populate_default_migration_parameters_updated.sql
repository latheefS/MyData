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
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  -- parameter_id
         ,'FIN'                                   -- application_suite
         ,'GL'                                    -- application
         ,'ALL'                                   -- business_entity
         ,'ALL'                                   -- sub_entity
         ,'LEDGER_NAME'                           -- parameter_code
         ,distinct_ledgers.name                   -- parameter_value
         ,'Y'                                     -- enabled_flag
         ,'SOURCE_DB'                             -- data_source
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
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  -- parameter_id
         ,'FIN'                                   -- application_suite
         ,'GL'                                    -- application
         ,'BALANCES'                              -- business_entity
         ,'ALL'                                   -- sub_entity
         ,'EXTRACT_YEAR'                          -- parameter_code
         ,'2014'                                  -- parameter_value
         ,'Y'                                     -- enabled_flag
         ,'XXMX'                                  -- data_source
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
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  -- parameter_id
         ,'FIN'                                   -- application_suite
         ,'GL'                                    -- application
         ,'BALANCES'                              -- business_entity
         ,'ALL'                                   -- sub_entity
         ,'EXTRACT_YEAR'                          -- parameter_code
         ,'2015'                                  -- parameter_value
         ,'Y'                                     -- enabled_flag
         ,'XXMX'                                  -- data_source
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
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  -- parameter_id
         ,'FIN'                                   -- application_suite
         ,'GL'                                    -- application
         ,'BALANCES'                              -- business_entity
         ,'ALL'                                   -- sub_entity
         ,'PERIOD_NAME'                           -- parameter_code
         ,'APR-15'                                -- parameter_value
         ,'Y'                                     -- enabled_flag
         ,'XXMX'                                  -- data_source
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
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  -- parameter_id
         ,'FIN'                                   -- application_suite
         ,'GL'                                    -- application
         ,'BALANCES'                              -- business_entity
         ,'ALL'                                   -- sub_entity
         ,'PERIOD_NAME'                           -- parameter_code
         ,'APR-20'                                -- parameter_value
         ,'Y'                                     -- enabled_flag
         ,'XXMX'                                  -- data_source
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
SELECT      xxmx_migration_parameter_ids_s.NEXTVAL   -- parameter_id
           ,'XXMX'                                   -- application_suite
           ,'GL'                                     -- application
           ,'UTILITIES'                              -- business_entity
           ,'DEFAULT_ACCOUNT_TRANSFORMS'             -- sub_entity
           ,'PLACEBO_SEGMENT_VALUE'              -- parameter_code
           ,'#'                                      -- parameter_value
           ,'Y'                                      -- enabled_flag
           ,'XXMX'                                   -- data_source
 FROM       dual
 WHERE      1 = 1
 AND        NOT EXISTS (
                        SELECT 'X'
                        FROM   xxmx_migration_parameters
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
SELECT       xxmx_migration_parameter_ids_s.NEXTVAL  -- parameter_id
            ,'XXMX'                                  -- application_suite
            ,'GL'                                    -- application
            ,'UTILITIES'                             -- business_entity
            ,'DEFAULT_ACCOUNT_TRANSFORMS'            -- sub_entity
            ,'PLACEBO_SEGMENT_VALUE'                 -- parameter_code
            ,'#'                                     -- parameter_value
            ,'Y'                                     -- enabled_flag
            ,'XXMX'                                  -- data_source
FROM        dual
WHERE       1 = 1
AND         NOT EXISTS (
                        SELECT 'X'
                        FROM   xxmx_migration_parameters
                        WHERE  1 = 1
                        AND    application_suite = 'XXMX'
                        AND    application       = 'GL'
                        AND    business_entity   = 'UTILITIES'
                        AND    sub_entity        = 'DEFAULT_ACCOUNT_TRANSFORMS'
                        AND    parameter_code    = 'PLACEBO_SEGMENT_VALUE'
                       );
--
--
--
/*
** GL Journal
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
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  -- parameter_id
         ,'FIN'                                   -- application_suite
         ,'GL'                                    -- application
         ,'GENERAL_LEDGER'                        -- business_entity
         ,'ALL'                                   -- sub_entity
         ,'JE_CATEGORY'                           -- parameter_code
         ,'AP Subledger Entries'                  -- parameter_value
         ,'Y'                                     -- enabled_flag
         ,'XXMX'                                  -- data_source
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
                      AND    parameter_value   = 'AP Subledger Entries'
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
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  -- parameter_id
         ,'FIN'                                   -- application_suite
         ,'GL'                                    -- application
         ,'GENERAL_LEDGER'                        -- business_entity
         ,'ALL'                                   -- sub_entity
         ,'JE_SOURCE'                             -- parameter_code
         ,'Payables'                  			  -- parameter_value
         ,'Y'                                     -- enabled_flag
         ,'XXMX'                                  -- data_source
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
                      AND    parameter_value   = 'Payables'
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
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  -- parameter_id
         ,'FIN'                                   -- application_suite
         ,'GL'                                    -- application
         ,'GENERAL_LEDGER'                        -- business_entity
         ,'ALL'                                   -- sub_entity
         ,'STATUS'                                -- parameter_code
         ,'P'                  			  		  -- parameter_value
         ,'Y'                                     -- enabled_flag
         ,'XXMX'                                  -- data_source
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
                      AND    parameter_value   = 'P'
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
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  -- parameter_id
         ,'FIN'                                   -- application_suite
         ,'ALL'                                   -- application
         ,'ALL'                                   -- business_entity
         ,'ALL'                                   -- sub_entity
         ,'ORGANIZATION_NAME'                     -- parameter_code
         ,distinct_orgs.name                      -- parameter_value
         ,'Y'                                     -- enabled_flag
         ,'SOURCE_DB'                             -- data_source
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
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  -- parameter_id
         ,'FIN'                                   -- application_suite
         ,'AP'                                    -- application
         ,'SUPPLIERS'                             -- business_entity
         ,'ALL'                                   -- sub_entity
         ,'MONTHS_TO_MIGRATE'                     -- parameter_code
         ,'18'                                    -- parameter_value
         ,'Y'                                     -- enabled_flag
         ,'XXMX'                                  -- data_source
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
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  -- parameter_id
         ,'FIN'                                   -- application_suite
         ,'AP'                                    -- application
         ,'INVOICES'                              -- business_entity
         ,'ALL'                                   -- sub_entity
         ,'MONTHS_TO_MIGRATE'                     -- parameter_code
         ,'18'                                    -- parameter_value
         ,'Y'                                     -- enabled_flag
         ,'XXMX'                                  -- data_source
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
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  -- parameter_id
         ,'FIN'                                   -- application_suite
         ,'AP'                                    -- application
         ,'SUPPLIERS'                             -- business_entity
         ,'ALL'                                   -- sub_entity
         ,'VENDOR_TYPE'                           -- parameter_code
         ,vendor_types.lookup_code                -- parameter_value
         ,'Y'                                     -- enabled_flag
         ,'SOURCE_DB'                             -- data_source
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
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  -- parameter_id
         ,'FIN'                                    -- application_suite
         ,'AP'                                     -- application
         ,'SUPPLIERS'                              -- business_entity
         ,'ALL'                                    -- sub_entity
         ,'VENDOR_TYPE'                            -- parameter_code
         ,'#NULL'                                  -- parameter_value
         ,'N'                                      -- enabled_flag
         ,'XXMX'                                   -- data_source
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
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  -- parameter_id
         ,'FIN'                                   -- application_suite
         ,'AP'                                    -- application
         ,'SUPPLIERS'                             -- business_entity
         ,'SUPPLIER_PMT_INSTRS'                   -- sub_entity
         ,'ORDER_OF_PREFERENCE_LIMIT'             -- parameter_code
         ,'1'                                     -- parameter_value
         ,'Y'                                     -- enabled_flag
         ,'XXMX'                                  -- data_source
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
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  -- parameter_id
         ,'FIN'                                   -- application_suite
         ,'AP'                                    -- application
         ,'INVOICES'                              -- business_entity
         ,'ALL'                                   -- sub_entity
         ,'INVOICE_TYPE'                          -- parameter_code
         ,invoice_types.lookup_code               -- parameter_value
         ,'Y'                                     -- enabled_flag
         ,'SOURCE_DB'                             -- data_source
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
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  -- parameter_id
         ,'FIN'                                   -- application_suite
         ,'AP'                                    -- application
         ,'INVOICES'                              -- business_entity
         ,'INVOICE_HEADERS'                       -- sub_entity
         ,'DEFAULT_IMPORT_SOURCE'                 -- parameter_code
         ,'Data Migration'                        -- parameter_value
         ,'Y'                                     -- enabled_flag
         ,'XXMX'                                  -- data_source
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
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  -- parameter_id
         ,'FIN'                                   -- application_suite
         ,'AP'                                    -- application
         ,'INVOICES'                              -- business_entity
         ,'INVOICE_HEADERS'                       -- sub_entity
         ,'DEFAULT_PAY_CODE_CONCATENATED'         -- parameter_code
         ,'XX-XXXXX-XXXXX-XXXXX-00000000'         -- parameter_value
         ,'Y'                                     -- enabled_flag
         ,'XXMX'                                  -- data_source
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
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  -- parameter_id
         ,'FIN'                                   -- application_suite
         ,'AP'                                    -- application
         ,'INVOICES'                              -- business_entity
         ,'INVOICE_LINES'                         -- sub_entity
         ,'DEFAULT_DIST_CODE_CONCATENATED'        -- parameter_code
         ,'YY-YYYYY-YYYYY-YYYYY-00000000'         -- parameter_value
         ,'Y'                                     -- enabled_flag
         ,'XXMX'                                  -- data_source
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
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  -- parameter_id
         ,'FIN'                                   -- application_suite
         ,'AR'                                    -- application
         ,'CUSTOMERS'                             -- business_entity
         ,'ALL'                                   -- sub_entity
         ,'MONTHS_TO_MIGRATE'                     -- parameter_code
         ,'18'                                    -- parameter_value
         ,'Y'                                     -- enabled_flag
         ,'XXMX'                                  -- data_source
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
INTO   xxmx_migration_parameters
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
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  -- parameter_id
         ,'FIN'                                   -- application_suite
         ,'AR'                                    -- application
         ,'CUSTOMERS'                             -- business_entity
         ,'ALL'                                   -- sub_entity
         ,'INCLUDE_INACTIVE_ACCOUNTS'             -- parameter_code
         ,'Y'                                     -- parameter_value
         ,'Y'                                     -- enabled_flag
         ,'XXMX'                                  -- data_source
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
INTO   xxmx_migration_parameters
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
SELECT     xxmx_migration_parameter_ids_s.NEXTVAL  -- parameter_id
         ,'FIN'                                   -- application_suite
         ,'AR'                                    -- application
         ,'CUSTOMERS'                             -- business_entity
         ,'ALL'                                   -- sub_entity
         ,'INCLUDE_INACTIVE_SITES'                -- parameter_code
         ,'Y'                                     -- parameter_value
         ,'Y'                                     -- enabled_flag
         ,'XXMX'                                  -- data_source
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
INTO   xxmx_migration_parameters
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
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  -- parameter_id
         ,'SCM'                                   -- application_suite
         ,'PO'                                    -- application
         ,'PURCHASE_ORDERS'                       -- business_entity
         ,'ALL'                                   -- sub_entity
         ,'INCLUDE_FULLY_RECEIPTED_POS'           -- parameter_code
         ,'N'                                     -- parameter_value
         ,'Y'                                     -- enabled_flag
         ,'XXMX'                                  -- data_source
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
INTO   xxmx_migration_parameters
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
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  -- parameter_id
         ,'SCM'                                   -- application_suite
         ,'PO'                                    -- application
         ,'PURCHASE_ORDERS'                       -- business_entity
         ,'ALL'                                   -- sub_entity
         ,'MONTHS_TO_MIGRATE'                     -- parameter_code
         ,'18'                                    -- parameter_value
         ,'Y'                                     -- enabled_flag
         ,'XXMX'                                  -- data_source
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
INTO   xxmx_migration_parameters
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
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  -- parameter_id
         ,'HCM'                                   -- application_suite
         ,'HR'                                    -- application
         ,'ALL'                                   -- business_entity
         ,'ALL'                                   -- sub_entity
         ,'BUSINESS_GROUP_NAME'                   -- parameter_code
         ,distinct_business_groups.name           -- parameter_value
         ,'Y'                                     -- enabled_flag
         ,'SOURCE_DB'                             -- data_source
FROM     (
          SELECT  DISTINCT
                  haou.name
          FROM    hr_all_organization_units@mxdm_nvis_extract   haou
                 ,hr_organization_information@mxdm_nvis_extract hoi
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
INTO   xxmx_migration_parameters
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
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  -- parameter_id
         ,'HCM'                                   -- application_suite
         ,'HR'                                    -- application
         ,'HCMEMPLOYEE'                           -- business_entity
         ,'ALL'                                   -- sub_entity
         ,'MIGRATE_DATE_FROM'                     -- parameter_code
         ,'1992-01-01'                            -- parameter_value
         ,'Y'                                     -- enabled_flag
         ,'XXMX'                                  -- data_source
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
INTO   xxmx_migration_parameters
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
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  -- parameter_id
         ,'HCM'                                   -- application_suite
         ,'IREC'                                    -- application
         ,'ALL'                           -- business_entity
         ,'ALL'                                   -- sub_entity
         ,'MIGRATE_DATE_FROM'                     -- parameter_code
         ,'1992-01-01'                            -- parameter_value
         ,'Y'                                     -- enabled_flag
         ,'XXMX'                                  -- data_source
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
INTO   xxmx_migration_parameters
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
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  -- parameter_id
         ,'HCM'                                   -- application_suite
         ,'IREC'                                    -- application
         ,'JOB_REFERRAL'                           -- business_entity
         ,'ALL'                                   -- sub_entity
         ,'MIGRATE_DATE_FROM'                     -- parameter_code
         ,'1992-01-01'                            -- parameter_value
         ,'Y'                                     -- enabled_flag
         ,'XXMX'                                  -- data_source
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
INTO   xxmx_migration_parameters
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
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  -- parameter_id
         ,'HCM'                                   -- application_suite
         ,'IREC'                                    -- application
         ,'JR_HIRING_TEAM'                           -- business_entity
         ,'ALL'                                   -- sub_entity
         ,'MIGRATE_DATE_FROM'                     -- parameter_code
         ,'1992-01-01'                            -- parameter_value
         ,'Y'                                     -- enabled_flag
         ,'XXMX'                                  -- data_source
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
INTO   xxmx_migration_parameters
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
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  -- parameter_id
         ,'HCM'                                   -- application_suite
         ,'HR'                                    -- application
         ,'HCMEMPLOYEE'                           -- business_entity
         ,'ALL'                                   -- sub_entity
         ,'MIGRATE_DATE_TO'                       -- parameter_code
         ,'2019-01-01'                            -- parameter_value
         ,'Y'                                     -- enabled_flag
         ,'XXMX'                                  -- data_source
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
INTO   xxmx_migration_parameters
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
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  -- parameter_id
         ,'HCM'                                   -- application_suite
         ,'IREC'                                    -- application
         ,'ALL'                           -- business_entity
         ,'ALL'                                   -- sub_entity
         ,'MIGRATE_DATE_TO'                       -- parameter_code
         ,'2019-01-01'                            -- parameter_value
         ,'Y'                                     -- enabled_flag
         ,'XXMX'                                  -- data_source
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
INTO   xxmx_migration_parameters
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
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  -- parameter_id
         ,'HCM'                                   -- application_suite
         ,'IREC'                                    -- application
         ,'JOB_REFERRAL'                           -- business_entity
         ,'ALL'                                   -- sub_entity
         ,'MIGRATE_DATE_TO'                       -- parameter_code
         ,'2019-01-01'                            -- parameter_value
         ,'Y'                                     -- enabled_flag
         ,'XXMX'                                  -- data_source
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
INTO   xxmx_migration_parameters
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
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  -- parameter_id
         ,'HCM'                                   -- application_suite
         ,'IREC'                                    -- application
         ,'JR_HIRING_TEAM'                           -- business_entity
         ,'ALL'                                   -- sub_entity
         ,'MIGRATE_DATE_TO'                       -- parameter_code
         ,'2019-01-01'                            -- parameter_value
         ,'Y'                                     -- enabled_flag
         ,'XXMX'                                  -- data_source
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
INTO   xxmx_migration_parameters
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
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  -- parameter_id
         ,'HCM'                                   -- application_suite
         ,'HR'                                    -- application
         ,'HCMEMPLOYEE'                           -- business_entity
         ,'ALL'                                   -- sub_entity
         ,'PREV_TAX_YEAR_DATE'                    -- parameter_code
         ,'2019-01-01'                            -- parameter_value
         ,'Y'                                     -- enabled_flag
         ,'XXMX'                                  -- data_source
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
INTO   xxmx_migration_parameters
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
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  -- parameter_id
         ,'HCM'                                   -- application_suite
         ,'PAY'                                   -- application
         ,'PAYROLL'                               -- business_entity
         ,'ALL'                                   -- sub_entity
         ,'PAYROLL_NAME'                          -- parameter_code
         ,distinct_payrolls.payroll_name          -- parameter_value
         ,'Y'                                     -- enabled_flag
         ,'SOURCE_DB'                             -- data_source
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
INTO   xxmx_migration_parameters
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
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  -- parameter_id
         ,'HCM'                                   -- application_suite
         ,'PAY'                                   -- application
         ,'PAYROLL'                               -- business_entity
         ,'ALL'                                   -- sub_entity
         ,'MIGRATION_START_DATE_VAL'              -- parameter_code
         ,'01-JAN-2020'                           -- parameter_value
         ,'Y'                                     -- enabled_flag
         ,'XXMX'                                  -- data_source
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
INTO   xxmx_migration_parameters
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
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  -- parameter_id
         ,'HCM'                                   -- application_suite
         ,'PAY'                                   -- application
         ,'PAYROLL'                               -- business_entity
         ,'ALL'                                   -- sub_entity
         ,'MIGRATION_START_DATE_FMT'              -- parameter_code
         ,'01-JAN-2020'                           -- parameter_value
         ,'Y'                                     -- enabled_flag
         ,'XXMX'                                  -- data_source
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
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  -- parameter_id
         ,'HCM'                                   -- application_suite
         ,'PAY'                                   -- application
         ,'PAYROLL'                               -- business_entity
         ,'ALL'                                   -- sub_entity
         ,'SCOPE_ELEMENT_NAME'                    -- parameter_code
         ,'Student Loan'                          -- parameter_value
         ,'Y'                                     -- enabled_flag
         ,'XXMX'                                  -- data_source
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
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  -- parameter_id
         ,'HCM'                                   -- application_suite
         ,'PAY'                                   -- application
         ,'PAYROLL'                               -- business_entity
         ,'ALL'                                   -- sub_entity
         ,'SCOPE_ELEMENT_NAME'                    -- parameter_code
         ,'NI'                                    -- parameter_value
         ,'Y'                                     -- enabled_flag
         ,'XXMX'                                  -- data_source
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
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  -- parameter_id
         ,'HCM'                                   -- application_suite
         ,'PAY'                                   -- application
         ,'PAYROLL'                               -- business_entity
         ,'ALL'                                   -- sub_entity
         ,'SCOPE_ELEMENT_NAME'                    -- parameter_code
         ,'PAYE Details'                          -- parameter_value
         ,'Y'                                     -- enabled_flag
         ,'XXMX'                                  -- data_source
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
SELECT  XXMX_MIGRATION_PARAMETER_IDS_S.NEXTVAL  -- parameter_id
       ,'HCM'                               -- application_suite
       ,'HR'                                -- application
       ,'HCMEMPLOYEE'                               -- business_entity
       ,'ALL'                               -- sub_entity
       ,'PERSON_TYPE'               -- parameter_code
       ,distinct_person_type.name       -- parameter_value
       ,'Y'                                 -- enabled_flag
FROM    (
         select distinct  UPPER(ppt.user_person_type)  name
		FROM     per_all_people_f@MXDM_NVIS_EXTRACT papf
                ,per_person_type_usages_f@MXDM_NVIS_EXTRACT  pptu
                ,per_person_types@MXDM_NVIS_EXTRACT  ppt
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
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  -- parameter_id
         ,'FIN'                                   -- application_suite
         ,'AR'                                   -- application
         ,'TRANSACTIONS'                               -- business_entity
         ,'ALL'                                   -- sub_entity
         ,'AR_TRX_SOURCE_ID'                    -- parameter_code
         ,'300000012242895'                          -- parameter_value
         ,'Y'                                     -- enabled_flag
         ,'XXMX'                                  -- data_source
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
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  -- parameter_id
         ,'HCM'                                   -- application_suite
         ,'HR'                                   -- application
         ,'ALL'                               -- business_entity
         ,'ALL'                                   -- sub_entity
         ,'ASSIGNMENT_DFF'                    -- parameter_code
         ,'I'                          			-- parameter_value
         ,'Y'                                     -- enabled_flag
         ,'XXMX'                                  -- data_source
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
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  -- parameter_id
         ,'FIN'                                   -- application_suite
         ,'PPM'                                   -- application
         ,'PRJ_COST'                               -- business_entity
         ,'ALL'                                   -- sub_entity
         ,'COST_EXT_TYPE'                    -- parameter_code
         ,'DETAIL'                          			-- parameter_value
         ,'Y'                                     -- enabled_flag
         ,'XXMX'                                  -- data_source
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
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  -- parameter_id
         ,'FIN'                                   -- application_suite
         ,'FA'                                   -- application
         ,'ALL'                               -- business_entity
         ,'ALL'                                   -- sub_entity
         ,'CUT_OFF_DATE'                    -- parameter_code
         ,'31-AUG-2021'                          			-- parameter_value
         ,'Y'                                     -- enabled_flag
         ,'XXMX'                                  -- data_source
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
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  -- parameter_id
         ,'FIN'                                   -- application_suite
         ,'PPM'                                   -- application
         ,'ALL'                               	  -- business_entity
         ,'ALL'                                	  -- sub_entity
         ,'EXTRACT_END_DATE'                      -- parameter_code
         ,'31-DEC-1997'                           -- parameter_value
         ,'Y'                                     -- enabled_flag
         ,'XXMX'                                  -- data_source
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
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  -- parameter_id
         ,'FIN'                                   -- application_suite
         ,'PPM'                                   -- application
         ,'ALL'                               	  -- business_entity
         ,'ALL'                                	  -- sub_entity
         ,'EXTRACT_START_DATE'                      -- parameter_code
         ,'01-JAN-1997'                           -- parameter_value
         ,'Y'                                     -- enabled_flag
         ,'XXMX'                                  -- data_source
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
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  -- parameter_id
         ,'FIN'                                   -- application_suite
         ,'ALL'                                   -- application
         ,'ALL'                               	  -- business_entity
         ,'ALL'                                	  -- sub_entity
         ,'FTP_ENABLED'                      -- parameter_code
         ,'Y'                           -- parameter_value
         ,'Y'                                     -- enabled_flag
         ,'XXMX'                                  -- data_source
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
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  -- parameter_id
         ,'HCM'                                   -- application_suite
         ,'ALL'                                   -- application
         ,'ALL'                               	  -- business_entity
         ,'ALL'                                	  -- sub_entity
         ,'FTP_ENABLED'                      -- parameter_code
         ,'Y'                           -- parameter_value
         ,'Y'                                     -- enabled_flag
         ,'XXMX'                                  -- data_source
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
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  -- parameter_id
         ,'FIN'                                   -- application_suite
         ,'PPM'                                   -- application
         ,'ALL'                               	  -- business_entity
         ,'ALL'                                	  -- sub_entity
         ,'GL_PERIOD_NAME'                      -- parameter_code
         ,'MAR-97'                           -- parameter_value
         ,'Y'                                     -- enabled_flag
         ,'XXMX'                                  -- data_source
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
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  -- parameter_id
         ,'FIN'                                   -- application_suite
         ,'AR'                                   -- application
         ,'TRANSACTIONS'                               	  -- business_entity
         ,'ALL'                                	  -- sub_entity
         ,'INCLUDE_CREDIT_MEMOS'                      -- parameter_code
         ,'Y'                           -- parameter_value
         ,'Y'                                     -- enabled_flag
         ,'XXMX'                                  -- data_source
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
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  -- parameter_id
         ,'FIN'                                   -- application_suite
         ,'AR'                                   -- application
         ,'TRANSACTIONS'                               	  -- business_entity
         ,'ALL'                                	  -- sub_entity
         ,'INCLUDE_DEBIT_MEMOS'                      -- parameter_code
         ,'Y'                           -- parameter_value
         ,'Y'                                     -- enabled_flag
         ,'XXMX'                                  -- data_source
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
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  -- parameter_id
         ,'FIN'                                   -- application_suite
         ,'AR'                                   -- application
         ,'CUSTOMERS'                          -- business_entity
         ,'ALL'                                	  -- sub_entity
         ,'NO_ACTIVITY_CUSTOMER_MONTHS'                    -- parameter_code
         ,'2'                          			 -- parameter_value
         ,'Y'                                     -- enabled_flag
         ,'XXMX'                                  -- data_source
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
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  -- parameter_id
         ,'HCM'                                   -- application_suite
         ,'HR'                                   -- application
         ,'ALL'                          			-- business_entity
         ,'ALL'                                	  -- sub_entity
         ,'PEOPLE_GROUP'                    		-- parameter_code
         ,'SEGMENT1-SEGMENT3'                     -- parameter_value
         ,'Y'                                     -- enabled_flag
         ,'XXMX'                                  -- data_source
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
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  -- parameter_id
         ,'HCM'                                   -- application_suite
         ,'ALL'                                   -- application
         ,'ALL'                          			-- business_entity
         ,'ALL'                                	  -- sub_entity
         ,'SOURCESYSTEMOWNER'                    		-- parameter_code
         ,'EBS'                   				  -- parameter_value
         ,'Y'                                     -- enabled_flag
         ,'XXMX'                                  -- data_source
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
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  -- parameter_id
         ,'XXMX'                                   -- application_suite
         ,'GL'                                   -- application
         ,'UTILITIES'                          		-- business_entity
         ,'DEFAULT_ACCOUNT_TRANSFORMS'        	  -- sub_entity
         ,'USE_PLACEBO_SEGMENT_VALUE'             -- parameter_code
         ,'Y'                   				  -- parameter_value
         ,'Y'                                     -- enabled_flag
         ,'XXMX'                                  -- data_source
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
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  -- parameter_id
         ,'FIN'                                   -- application_suite
         ,'FA'                                    -- application
         ,'ALL'                              	-- business_entity
         ,'ALL'                       			-- sub_entity
         ,'BOOK_TYPE_CODE'                 		-- parameter_code
         ,''                        			-- parameter_value
         ,'Y'                                     -- enabled_flag
         ,'SOURCE_DB'                                  -- data_source
FROM      
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'FA'
                      AND    business_entity   = 'ALL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'BOOK_TYPE_CODE'
					  AND 	 parameter_value   = ''
                     );

--- GL 
--- ALL 
--- LEDGER_NAME

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
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  -- parameter_id
         ,'FIN'                                   -- application_suite
         ,'GL'                                    -- application
         ,'ALL'                              	-- business_entity
         ,'ALL'                       			-- sub_entity
         ,'LEDGER_NAME'                 		-- parameter_code
         ,''                        		-- parameter_value
         ,'N'                                     -- enabled_flag
         ,'SOURCE_DB'                                  -- data_source
FROM      
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'GL'
                      AND    business_entity   = 'ALL'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'LEDGER_NAME'
					  AND 	 parameter_value   = ''
                     );

--- GL 
--- BALANCES 
--- PERIOD_NAME

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
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  -- parameter_id
         ,'FIN'                                   -- application_suite
         ,'GL'                                    -- application
         ,'BALANCES'                              	-- business_entity
         ,'ALL'                       			-- sub_entity
         ,'PERIOD_NAME'                 		-- parameter_code
         ,''                        		-- parameter_value
         ,'Y'                                     -- enabled_flag
         ,'SOURCE_DB'                                  -- data_source
FROM      
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
					  AND 	 parameter_value   = ''
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
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  -- parameter_id
         ,'HCM'                                   -- application_suite
         ,'IREC'                                    -- application
         ,'CANDIDATE'                              	-- business_entity
         ,'ALL'                       			-- sub_entity
         ,'PERSON_TYPE'                 		-- parameter_code
         ,''                        		-- parameter_value
         ,'Y'                                     -- enabled_flag
         ,'SOURCE_DB'                                  -- data_source
FROM      
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
					  AND 	 parameter_value   = ''
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
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  -- parameter_id
         ,'SCM'                                   -- application_suite
         ,'PO'                                   -- application
         ,'ALL'                                   -- business_entity
         ,'ALL'                                   -- sub_entity
         ,'ORGANIZATION_NAME'                     -- parameter_code
         ,distinct_orgs.name                      -- parameter_value
         ,'Y'                                     -- enabled_flag
         ,'SOURCE_DB'                             -- data_source
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
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  -- parameter_id
         ,'SCM'                                   -- application_suite
         ,'PO'                                   -- application
         ,'ALL'                                   -- business_entity
         ,'ALL'                                   -- sub_entity
         ,'PO_TYPE'                     -- parameter_code
         ,distinct_po.PO_TYPE                      -- parameter_value
         ,'Y'                                     -- enabled_flag
         ,'SOURCE_DB'                             -- data_source
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
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  -- parameter_id
         ,'FIN'                                   -- application_suite
         ,'PPM'                                    -- application
         ,'PRJ_COST'                              	-- business_entity
         ,''                       			-- sub_entity
         ,'EXP_SYSTEM_LINK_TYPE'                 		-- parameter_code
         ,''                        			-- parameter_value
         ,'Y'                                     -- enabled_flag
         ,'SOURCE_DB'                                  -- data_source
FROM      
WHERE     1 = 1
AND       NOT EXISTS (
                      SELECT 'X'
                      FROM   XXMX_CORE.xxmx_migration_parameters
                      WHERE  1 = 1
                      AND    application_suite = 'FIN'
                      AND    application       = 'PPM'
                      AND    business_entity   = 'PRJ_COST'
                      AND    sub_entity        = 'ALL'
                      AND    parameter_code    = 'EXP_SYSTEM_LINK_TYPE'
					  AND 	 parameter_value   = ''
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
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  -- parameter_id
         ,'FIN'                                   -- application_suite
         ,'PPM'                                   -- application
         ,'PROJECTS'                                   -- business_entity
         ,'ALL'                                   -- sub_entity
         ,'PROJECT_STATUS_CODE'                     -- parameter_code
         ,distinct_orgs.Project_code                      -- parameter_value
         ,'Y'                                     -- enabled_flag
         ,'SOURCE_DB'                             -- data_source
FROM     (
          SELECT  DISTINCT
                  PPA.PROJECT_STATUS_CODE Project_code
          FROM    apps.pa_projects_all@mxdm_nvis_extract    PPA
          WHERE   
          NOT EXISTS                     (
                                                  SELECT 'X'
                                                  FROM   XXMX_CORE.xxmx_migration_parameters xmp2
                                                  WHERE  1 = 1
                                                  AND    xmp2.application_suite = 'SCM'
                                                  AND    xmp2.application       = 'ALL'
                                                  AND    xmp2.business_entity   = 'ALL'
                                                  AND    xmp2.sub_entity        = 'ALL'
                                                  AND    xmp2.parameter_code    = 'PROJECT_STATUS_CODE'
                                                  AND    xmp2.parameter_value   = PPA.Project_code
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
SELECT    xxmx_migration_parameter_ids_s.NEXTVAL  -- parameter_id
         ,'FIN'                                   -- application_suite
         ,'PPM'                                   -- application
         ,'PROJECTS'                                   -- business_entity
         ,'ALL'                                   -- sub_entity
         ,'PROJECT_TYPE'                     -- parameter_code
         ,distinct_orgs.Project_type                      -- parameter_value
         ,'Y'                                     -- enabled_flag
         ,'SOURCE_DB'                             -- data_source
FROM     (
          SELECT  DISTINCT
                  PPA.Project_type Project_type
          FROM    apps.pa_projects_all@mxdm_nvis_extract    PPA
          WHERE   
          NOT EXISTS                     (
                                                  SELECT 'X'
                                                  FROM   XXMX_CORE.xxmx_migration_parameters xmp2
                                                  WHERE  1 = 1
                                                  AND    xmp2.application_suite = 'SCM'
                                                  AND    xmp2.application       = 'ALL'
                                                  AND    xmp2.business_entity   = 'ALL'
                                                  AND    xmp2.sub_entity        = 'ALL'
                                                  AND    xmp2.parameter_code    = 'PROJECT_TYPE'
                                                  AND    xmp2.parameter_value   = PPA.Project_type
                                                 )
         )   distinct_orgs;                    
--
COMMIT;
--