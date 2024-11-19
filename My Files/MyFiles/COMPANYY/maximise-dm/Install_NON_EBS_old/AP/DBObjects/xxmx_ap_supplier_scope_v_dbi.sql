
  CREATE OR REPLACE VIEW "XXMX_SUPPLIER_SCOPE_V" ("VENDOR_ID", "VENDOR_NUMBER", "VENDOR_NAME", "PARTY_ID", "ORG_ID", "OPERATING_UNIT_NAME", "VENDOR_SITE_ID", "VENDOR_SITE_CODE", "PARTY_SITE_ID") AS 
  WITH
     xxmx_parameters
     AS
          (
           SELECT   xxmx_utilities_pkg.get_single_parameter_value
                             (
                              'FIN'
                             ,'AP'
                             ,'SUPPLIERS'
                             ,'ALL'
                             ,'MONTHS_TO_MIGRATE'
                             )      AS supplier_months_to_migrate
                  , xxmx_utilities_pkg.get_single_parameter_value
                             (
                              'FIN'
                             ,'PO'
                             ,'PURCHASE_ORDERS'
                             ,'ALL'
                             ,'MONTHS_TO_MIGRATE'
                             )      AS po_months_to_migrate
           FROM    dual
          )
          --
     /*
     ** ABS function is used in the calls to the ADD_MONTHS function to remove any existing
     ** negative signs from the values retrieved for the MONTHS_TO_MIGRATE parameters.  The
     ** ABSolute value is then multiplied by -1 to get a past date.  This is to allow for
     ** users assigning a positive or negative value to the parameter.
     */
     --
    ,xxmx_parameter_conversions
     AS
          (
           SELECT CASE
                       WHEN ABS(xp.supplier_months_to_migrate) > ABS(xp.po_months_to_migrate)
                            THEN ADD_MONTHS(
                                            SYSDATE
                                           ,(ABS(xp.supplier_months_to_migrate) * -1)
                                           )
                       WHEN ABS(xp.po_months_to_migrate) > ABS(xp.supplier_months_to_migrate)
                            THEN ADD_MONTHS(
                                            SYSDATE
                                           ,(ABS(xp.po_months_to_migrate) * -1)
                                           )
                       ELSE ADD_MONTHS(
                                       SYSDATE
                                      ,(ABS(xp.supplier_months_to_migrate) * -1)
                                      )
                  END       AS supplier_scope_start_date
           FROM   xxmx_parameters xp
          )
    ,eligible_org_id_list
     AS
          (
           SELECT  DISTINCT
                   haou.organization_id                                AS org_id
                  ,haou.name                                           AS operating_unit_name
           FROM    apps.hr_all_organization_units@MXDM_NVIS_EXTRACT    haou
                  ,apps.hr_organization_information@MXDM_NVIS_EXTRACT  hoi
           WHERE   1 = 1
           AND     hoi.organization_id   = haou.organization_id
           AND     hoi.org_information1  = 'OPERATING_UNIT'
           AND     haou.name            IN (
                                            SELECT xsou.source_operating_unit_name
                                            FROM    xxmx_source_operating_units  xsou
                                            WHERE  1 = 1
                                            AND    NVL(xsou.migration_enabled_flag, 'N') = 'Y'
                                           )
          )
    ,eligible_supplier_types_list
     AS
          (
           SELECT xmp.parameter_value       AS vendor_type_lookup_code
           FROM    xxmx_migration_parameters  xmp
           WHERE  1 = 1
           AND    xmp.application_suite      = 'FIN'
           AND    xmp.application            = 'ALL'
           AND    xmp.business_entity        = 'ALL'
           AND    xmp.sub_entity             = 'ALL'
           AND    xmp.parameter_code         = 'VENDOR_TYPE'
           AND    NVL(xmp.enabled_flag, 'N') = 'Y'
           AND    NOT EXISTS (
                              SELECT 'X'
                              FROM    xxmx_migration_parameters  xmp2
                              WHERE  1 = 1
                              AND    xmp2.application_suite      = 'FIN'
                              AND    xmp2.application            = 'AP'
                              AND    xmp2.business_entity        = 'SUPPLIERS'
                              AND    xmp2.sub_entity             = 'ALL'
                              AND    xmp2.parameter_code         = 'VENDOR_TYPE'
                              AND    NVL(xmp2.enabled_flag, 'N') = 'Y'
                             )
           UNION
           SELECT xmp3.parameter_value
           FROM    xxmx_migration_parameters  xmp3
           WHERE  1 = 1
           AND    xmp3.application_suite      = 'FIN'
           AND    xmp3.application            = 'AP'
           AND    xmp3.business_entity        = 'SUPPLIERS'
           AND    xmp3.sub_entity             = 'ALL'
           AND    xmp3.parameter_code         = 'VENDOR_TYPE'
           AND    NVL(xmp3.enabled_flag, 'N') = 'Y'
          )
     --,open_po_distributions
     -- AS
     --     (
     --      SELECT    pda.org_id
     --               ,pda.po_header_id
     --               ,SUM(pda.quantity_ordered - pda.quantity_cancelled - pda.quantity_billed)
     --      FROM      eligible_org_id_list               eoil
     --               ,po_distributions_all@MXDM_NVIS_EXTRACT  pda
     --      WHERE     1 = 1
     --      AND       pda.org_id = eoil.org_id
     --      GROUP BY  pda.org_id
     --               ,pda.po_header_id
     --      HAVING SUM(pda.quantity_ordered - pda.quantity_cancelled - pda.quantity_billed) > 0
     --     )
     --,open_release_lines
     -- AS
     --     (
     --      SELECT    plla.org_id
     --               ,plla.po_release_id
     --               ,plla.po_line_id
     --               ,SUM(plla.quantity - plla.quantity_cancelled - plla.quantity_billed)
     --      FROM      eligible_org_id_list               eoil
     --               ,apps.po_line_locations_all@mxdm_nvis_extract  plla
     --      WHERE     1 = 1
     --      AND       plla.org_id = eoil.org_id
     --      GROUP BY  plla.org_id
     --               ,plla.po_release_id
     --               ,plla.po_line_id
     --      HAVING SUM(plla.quantity - plla.quantity_cancelled - plla.quantity_billed) > 0
     --     )
     --,suppliers_on_open_po
     -- AS
     --     (
     --      /* Standard PO with Quantity Remaining */
     --      SELECT  pha.vendor_id                            AS vendor_id
     --             ,pha.org_id                               AS org_id
     --             ,eoil.operating_unit_name                 AS operating_unit_name
     --             ,pha.vendor_site_id                       AS vendor_site_id
     --             ,pha.creation_date                        AS creation_date
     --      FROM    eligible_org_id_list                     eoil
     --             ,apps.po_headers_all@MXDM_NVIS_EXTRACT         pha
     --      WHERE   1 = 1
     --      AND     pha.org_id                       = eoil.org_id
     --      AND     pha.type_lookup_code             = 'STANDARD'
     --      AND     NVL(pha.closed_code,'OPEN') NOT IN ('CLOSED','FINALLY CLOSED')
     --      AND     pha.authorization_status        IN ('APPROVED', 'PRE-APPROVED')
     --      AND     EXISTS (
     --                      SELECT 1
     --                      FROM   open_po_distributions  opd
     --                      WHERE  1 = 1
     --                      AND    opd.org_id       = pha.org_id
     --                      AND    opd.po_header_id = pha.po_header_id
     --                     )
     --      UNION ALL
     --      /* Blanket PO Releases with Quantity Remaining */
     --      SELECT  pha.vendor_id                            AS vendor_id
     --             ,pha.org_id                               AS org_id
     --             ,eoil.operating_unit_name                 AS operating_unit_name
     --             ,pha.vendor_site_id                       AS vendor_site_id
     --             ,pra.creation_date                        AS creation_date
     --      FROM    eligible_org_id_list                     eoil
     --             ,apps.po_headers_all@MXDM_NVIS_EXTRACT         pha
     --             ,apps.po_releases_all@MXDM_NVIS_EXTRACT        pra
     --             ,apps.po_lines_all@MXDM_NVIS_EXTRACT           pla
     --      WHERE   1 = 1
     --      AND     pha.org_id                       = eoil.org_id
     --      AND     pha.type_lookup_code             = 'BLANKET'
     --      AND     NVL(pha.closed_code,'OPEN') NOT IN ('CLOSED','FINALLY CLOSED')
     --      AND     pha.authorization_status        IN ('APPROVED', 'PRE-APPROVED')
     --      AND     pra.org_id                       = pha.org_id
     --      AND     pra.po_header_id                 = pha.po_header_id
     --      AND     pla.po_header_id                 = pha.po_header_id
     --      AND     EXISTS (
     --                      SELECT  1
     --                      FROM    open_release_lines  orl
     --                      WHERE   1 = 1
     --                      AND     orl.org_id        = pra.org_id
     --                      AND     orl.po_release_id = pra.po_release_id
     --                      AND     orl.po_line_id    = pla.po_line_id
     --                     )
     --     )
     ,suppliers_and_sites_list
      AS  (
           SELECT  aps.vendor_id                            AS vendor_id
                  ,assa.org_id                              AS org_id
                  ,eoil.operating_unit_name                 AS operating_unit_name
                  ,assa.vendor_site_id                      AS vendor_site_id
           FROM    xxmx_parameter_conversions               xpc
                  ,eligible_org_id_list                     eoil
                  ,eligible_supplier_types_list             estl
                  ,apps.ap_suppliers@MXDM_NVIS_EXTRACT           aps
                  ,apps.ap_supplier_sites_all@MXDM_NVIS_EXTRACT  assa
           WHERE  1 = 1
           AND    assa.org_id                                    = eoil.org_id                                 /* Organisations in scope */
           AND    NVL(aps.vendor_type_lookup_code, '#NULL')      = estl.vendor_type_lookup_code                /* Only Supplier Sites associated with Supplier Types in scope */
           AND    (
                       aps.enabled_flag                          = 'Y'                                         /* Enabled Suppliers */
                   AND NVL(aps.end_date_active, SYSDATE + 1)     > TRUNC(SYSDATE)                              /* Supplier IS NOT end dated */
                  )
           AND    NVL(aps.one_time_flag,'N')                    <> 'Y'                                         /* Omit One Time Suppliers */
           AND    assa.vendor_id                                 = aps.vendor_id                               /* Sites to Suppliers Join */
           AND    SYSDATE                                        < NVL(TRUNC(assa.inactive_date),SYSDATE + 1)  /* Supplier Site IS NOT end dated */
           AND    (
                      assa.rfq_only_site_flag                    = 'Y'
                   OR assa.purchasing_site_flag                  = 'Y'
                   OR assa.pay_site_flag                         = 'Y'
                  )
           AND     (
                       EXISTS ( /* AP Invoices created for active Suppliers and Sites within last X months */
                               SELECT 'X'
                               FROM   xxmx_parameter_conversions               xpc
                                     ,apps.ap_invoices_all@MXDM_NVIS_EXTRACT   aia
                               WHERE  1 = 1
                               AND    aia.org_id                = assa.org_id                          /* Joins to outer query */
                               AND    aia.vendor_id             = assa.vendor_id                       /* Joins to outer query */
                               AND    aia.vendor_site_id        = assa.vendor_site_id                  /* Joins to outer query */
                               AND    TRUNC(aia.creation_date) >= xpc.supplier_scope_start_date        /* Invoice created within last X months */
                              )
                    OR EXISTS ( /* POs created for active Suppliers and Sites within last X months */
                               SELECT 'X'
                               FROM   xxmx_parameter_conversions             xpc
                                     ,apps.po_headers_all@MXDM_NVIS_EXTRACT  pha
                               WHERE  1 = 1
                               AND    pha.org_id                = assa.org_id                          /* Joins to outer query */
                               AND    pha.vendor_id             = assa.vendor_id                       /* Joins to outer query */
                               AND    pha.vendor_site_id        = assa.vendor_site_id                  /* Joins to outer query */
                               AND    TRUNC(pha.creation_date) >= xpc.supplier_scope_start_date        /* PO created within last X months */
                              )
                   )
          )
          SELECT  distinct_vendor_and_sites_list.vendor_id            AS vendor_id
                 ,aps.segment1                                        AS vendor_number
                 ,aps.vendor_name                                     AS vendor_name
                 ,aps.party_id                                        AS party_id
                 ,distinct_vendor_and_sites_list.org_id               AS org_id
                 ,distinct_vendor_and_sites_list.operating_unit_name  AS operating_unit_name
                 ,distinct_vendor_and_sites_list.vendor_site_id       AS vendor_site_id
                 ,assa.vendor_site_code                               AS vendor_site_code
                 ,assa.party_site_id                                  AS party_site_id
          FROM   (
                  SELECT  DISTINCT
                          vendor_and_sites_list.vendor_id
                         ,vendor_and_sites_list.org_id
                         ,vendor_and_sites_list.operating_unit_name
                         ,vendor_and_sites_list.vendor_site_id
                  FROM   (
                         --SELECT  vendor_id
                         --       ,org_id
                         --       ,operating_unit_name
                         --       ,vendor_site_id
                         --FROM    suppliers_on_open_po
                         --UNION ALL
                         SELECT  vendor_id
                                ,org_id
                                ,operating_unit_name
                                ,vendor_site_id
                         FROM    suppliers_and_sites_list
                        ) vendor_and_sites_list
                 ) distinct_vendor_and_sites_list
                ,apps.ap_suppliers@MXDM_NVIS_EXTRACT           aps  /* Only required to lookup additional details for Suppliers      */
                ,apps.ap_supplier_sites_all@MXDM_NVIS_EXTRACT  assa /* Only required to lookup additional details for Supplier Sites */
          WHERE  1 = 1
          AND    aps.vendor_id       = distinct_vendor_and_sites_list.vendor_id
          AND    assa.vendor_id      = aps.vendor_id
          AND    assa.org_id         = distinct_vendor_and_sites_list.org_id
          AND    assa.vendor_site_id = distinct_vendor_and_sites_list.vendor_site_id;
        --  AND    assa.vendor_site_code not like '%CONFIRM%';
/