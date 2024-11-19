
  CREATE MATERIALIZED VIEW "XXMX_CORE"."XXMX_PURCHASE_ORDER_SCOPE_V" ("PO_HEADER_ID", "ORG_ID")
  SEGMENT CREATION IMMEDIATE
  ORGANIZATION HEAP PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "TS_XXMX_CORE" 
  BUILD IMMEDIATE
  USING INDEX 
  REFRESH FORCE ON DEMAND
  USING DEFAULT LOCAL ROLLBACK SEGMENT
  USING ENFORCED CONSTRAINTS DISABLE ON QUERY COMPUTATION DISABLE QUERY REWRITE
  AS WITH
     eligible_org_id_list
     AS
          (
           SELECT  DISTINCT
                   haou.organization_id    AS org_id
           FROM    apps.hr_all_organization_units@MXDM_NVIS_EXTRACT    haou
                  ,apps.hr_organization_information@MXDM_NVIS_EXTRACT  hoi
           WHERE   1 = 1
           AND     hoi.organization_id   = haou.organization_id
           AND     hoi.org_information1  = 'OPERATING_UNIT'
           AND     haou.name            IN (
                                            SELECT xmp.parameter_value
                                            FROM   xxmx_core.xxmx_migration_parameters  xmp
                                            WHERE  1 = 1
                                            AND    xmp.application_suite      = 'FIN'            
                                            AND    xmp.application            = 'PO'
                                            AND    xmp.business_entity        = 'PURCHASE_ORDERS'
                                            AND    xmp.sub_entity             = 'ALL'
                                            AND    xmp.parameter_code         = 'ORGANIZATION_NAME'
                                            AND    NVL(xmp.enabled_flag, 'N') = 'Y'
                                            AND    NOT EXISTS (
                                                               SELECT 'X'
                                                               FROM   xxmx_core.xxmx_migration_parameters  xmp2
                                                               WHERE  1 = 1
                                                               AND    xmp2.application_suite      = 'FIN'
                                                               AND    xmp2.application            = 'PO'
                                                               AND    xmp2.business_entity        = 'PURCHASE_ORDERS'
                                                               AND    xmp2.sub_entity             = 'ALL'
                                                               AND    xmp2.parameter_code         = 'ORGANIZATION_NAME'
                                                               AND    NVL(xmp2.enabled_flag, 'N') = 'Y'
                                                              )
                                            UNION
                                            SELECT xmp3.parameter_value
                                            FROM   xxmx_core.xxmx_migration_parameters  xmp3
                                            WHERE  1 = 1
                                            AND    xmp3.application_suite      = 'FIN'
                                            AND    xmp3.application            = 'PO'
                                            AND    xmp3.business_entity        = 'PURCHASE_ORDERS'
                                            AND    xmp3.sub_entity             = 'ALL'
                                            AND    xmp3.parameter_code         = 'ORGANIZATION_NAME'
                                            AND    NVL(xmp3.enabled_flag, 'N') = 'Y'
                                           )
          )
    ,eligible_PO_types_list
     AS
          (
           SELECT xmp.parameter_value       AS po_type_lookup_code
           FROM   xxmx_core.xxmx_migration_parameters  xmp
           WHERE  1 = 1
           AND    xmp.application_suite      = 'FIN'            
           AND    xmp.application            = 'PO'
           AND    xmp.business_entity        = 'PURCHASE_ORDERS'
           AND    xmp.sub_entity             = 'ALL'
           AND    xmp.parameter_code         = 'PO_TYPE'
           AND    NVL(xmp.enabled_flag, 'N') = 'Y'
           AND    NOT EXISTS (
                              SELECT 'X'
                              FROM   xxmx_core.xxmx_migration_parameters  xmp2
                              WHERE  1 = 1
                              AND    xmp2.application_suite      = 'FIN'
                              AND    xmp2.application            = 'PO'
                              AND    xmp2.business_entity        = 'PURCHASE_ORDERS'
                              AND    xmp2.sub_entity             = 'ALL'
                              AND    xmp2.parameter_code         = 'PO_TYPE'
                              AND    NVL(xmp2.enabled_flag, 'N') = 'Y'
                             )
           UNION
           SELECT xmp3.parameter_value
           FROM   xxmx_core.xxmx_migration_parameters  xmp3
           WHERE  1 = 1
           AND    xmp3.application_suite      = 'FIN'
           AND    xmp3.application            = 'PO'
           AND    xmp3.business_entity        = 'PURCHASE_ORDERS'
           AND    xmp3.sub_entity             = 'ALL'
           AND    xmp3.parameter_code         = 'PO_TYPE'
           AND    NVL(xmp3.enabled_flag, 'N') = 'Y'
          )
     SELECT  PO.PO_HEADER_ID
            ,PO.org_id  
     FROM    eligible_org_id_list                        eoil
            ,eligible_PO_types_list                      eitl
            ,PO_HEADERS_all@MXDM_NVIS_EXTRACT       po
     WHERE   1 = 1
     AND     po.Cancel_flag                = 'N'                          -- Only po which are not cancelled
     AND     po.TYPE_LOOKUP_CODE           = eitl.po_type_lookup_code        -- Only po Types in scope
     AND     po.org_id                     = eoil.org_id                    -- Only Organizations in scope
     AND     po.APPROVED_FLAG               = 'Y'
     AND     EXISTS
                 (
                  SELECT 1
                  FROM   xxmx_core.xxmx_supplier_scope_v xssv
                  WHERE  1 = 1
                  AND    po.vendor_id = xssv.vendor_id
                 );

   COMMENT ON MATERIALIZED VIEW "XXMX_CORE"."XXMX_PURCHASE_ORDER_SCOPE_V"  IS 'snapshot table for snapshot XXMX_CORE.XXMX_PURCHASE_ORDER_SCOPE_V';

