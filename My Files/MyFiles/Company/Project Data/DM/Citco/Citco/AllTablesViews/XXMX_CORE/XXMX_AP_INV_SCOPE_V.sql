--------------------------------------------------------
--  DDL for View XXMX_AP_INV_SCOPE_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_CORE"."XXMX_AP_INV_SCOPE_V" ("INVOICE_ID", "ORG_ID") AS 
  WITH
     eligible_org_id_list
     AS
          (
           SELECT  DISTINCT
                   haou.organization_id    AS org_id
           FROM    apps.hr_all_organization_units@XXMX_EXTRACT    haou
                  ,apps.hr_organization_information@XXMX_EXTRACT  hoi
           WHERE   1 = 1
           AND     hoi.organization_id   = haou.organization_id
           AND     hoi.org_information1  = 'OPERATING_UNIT'
           AND     haou.name            IN (
                                            SELECT xsou.source_operating_unit_name
                                            FROM   xxmx_core.xxmx_source_operating_units  xsou
                                            WHERE  1 = 1
                                            AND    NVL(xsou.fin_migration_enabled_flag, 'N') = 'Y'
                                           )
/*                                           
           AND     haou.name            IN (
                                            SELECT xmp.parameter_value
                                            FROM   xxmx_core.xxmx_migration_parameters  xmp
                                            WHERE  1 = 1
                                            AND    xmp.application_suite      = 'FIN'
                                            AND    xmp.application            = 'ALL'
                                            AND    xmp.business_entity        = 'ALL'
                                            AND    xmp.sub_entity             = 'ALL'
                                            AND    xmp.parameter_code         = 'ORGANIZATION_NAME'
                                            AND    NVL(xmp.enabled_flag, 'N') = 'Y'
                                            AND    NOT EXISTS (
                                                               SELECT 'X'
                                                               FROM   xxmx_core.xxmx_migration_parameters  xmp2
                                                               WHERE  1 = 1
                                                               AND    xmp2.application_suite      = 'FIN'
                                                               AND    xmp2.application            = 'AP'
                                                               AND    xmp2.business_entity        = 'INVOICES'
                                                               AND    xmp2.sub_entity             = 'ALL'
                                                               AND    xmp2.parameter_code         = 'ORGANIZATION_NAME'
                                                               AND    NVL(xmp2.enabled_flag, 'N') = 'Y'
                                                              )
                                            UNION
                                            SELECT xmp3.parameter_value
                                            FROM   xxmx_core.xxmx_migration_parameters  xmp3
                                            WHERE  1 = 1
                                            AND    xmp3.application_suite      = 'FIN'
                                            AND    xmp3.application            = 'AP'
                                            AND    xmp3.business_entity        = 'INVOICES'
                                            AND    xmp3.sub_entity             = 'ALL'
                                            AND    xmp3.parameter_code         = 'ORGANIZATION_NAME'
                                            AND    NVL(xmp3.enabled_flag, 'N') = 'Y'
                                           )
*/                                           
          )
    ,eligible_invoice_types_list
     AS
          (
           SELECT xmp.parameter_value       AS invoice_type_lookup_code
           FROM   xxmx_core.xxmx_migration_parameters  xmp
           WHERE  1 = 1
           AND    xmp.application_suite      = 'FIN'
           AND    xmp.application            = 'ALL'
           AND    xmp.business_entity        = 'ALL'
           AND    xmp.sub_entity             = 'ALL'
           AND    xmp.parameter_code         = 'INVOICE_TYPE'
           AND    NVL(xmp.enabled_flag, 'N') = 'Y'
           AND    NOT EXISTS (
                              SELECT 'X'
                              FROM   xxmx_core.xxmx_migration_parameters  xmp2
                              WHERE  1 = 1
                              AND    xmp2.application_suite      = 'FIN'
                              AND    xmp2.application            = 'AP'
                              AND    xmp2.business_entity        = 'INVOICES'
                              AND    xmp2.sub_entity             = 'ALL'
                              AND    xmp2.parameter_code         = 'INVOICE_TYPE'
                              AND    NVL(xmp2.enabled_flag, 'N') = 'Y'
                             )
           UNION
           SELECT xmp3.parameter_value
           FROM   xxmx_core.xxmx_migration_parameters  xmp3
           WHERE  1 = 1
           AND    xmp3.application_suite      = 'FIN'
           AND    xmp3.application            = 'AP'
           AND    xmp3.business_entity        = 'INVOICES'
           AND    xmp3.sub_entity             = 'ALL'
           AND    xmp3.parameter_code         = 'INVOICE_TYPE'
           AND    NVL(xmp3.enabled_flag, 'N') = 'Y'
          )
     SELECT  aia.invoice_id
            ,aia.org_id
     FROM    eligible_org_id_list                        eoil
            ,eligible_invoice_types_list                 eitl
            ,apps.ap_invoices_all@XXMX_EXTRACT           aia
     WHERE   1 = 1
     AND     aia.payment_status_flag       <> 'Y'                            -- Only Invoices which are not fully paid
     AND     aia.cancelled_date            IS NULL                           -- Only Invoices which are not cancelled
     AND     aia.invoice_type_lookup_code   = eitl.invoice_type_lookup_code  -- Only Invoice Types in scope
     AND     aia.org_id                     = eoil.org_id                    -- Only Organizations in scope
     AND     NOT EXISTS
                  (
                   SELECT 1
                   FROM   apps.ap_holds@XXMX_EXTRACT  ah
                   WHERE  1 = 1
                   AND    ah.invoice_id           = aia.invoice_id
                   AND    ah.release_lookup_code IS NULL
                  )
     AND     EXISTS
                  (select 1
                   from (
                   SELECT   org_id, invoice_id, sum(amount_remaining) amount_remaining
                    FROM     apps.ap_payment_schedules_all@XXMX_EXTRACT
                    WHERE    1                              = 1
                    AND      amount_remaining              != 0
                    AND      nvl(payment_status_flag, 'N')  = 'N'
                    GROUP BY org_id, invoice_id ) aps
                    where aps.invoice_id = aia.invoice_id
                  )
     AND     EXISTS
                 (
                  SELECT 1
                  FROM   xxmx_core.xxmx_supplier_scope_v xssv
                  WHERE  1 = 1
                  AND    aia.vendor_id = xssv.vendor_id
                 )
;
  GRANT SELECT ON "XXMX_CORE"."XXMX_AP_INV_SCOPE_V" TO "XXMX_READONLY";
