
DECLARE

   PROCEDURE DropView (pView IN VARCHAR2) IS
   BEGIN
      EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW ' || pView ;
   EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -12003 THEN
         RAISE;
      END IF;
   END DropVIew ;
   
BEGIN
    DropView ('XXMX_SUPPLIER_SCOPE_V') ;
END;
/



CREATE MATERIALIZED VIEW "XXMX_SUPPLIER_SCOPE_V" ("VENDOR_ID", "VENDOR_NUMBER", "VENDOR_NAME", "PARTY_ID", "ORG_ID", "OPERATING_UNIT_NAME", "VENDOR_SITE_ID", "VENDOR_SITE_CODE", "PARTY_SITE_ID") 
SEGMENT CREATION IMMEDIATE
  ORGANIZATION HEAP PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  BUILD IMMEDIATE
  USING INDEX 
  REFRESH FORCE ON DEMAND
  USING DEFAULT LOCAL ROLLBACK SEGMENT
  USING ENFORCED CONSTRAINTS DISABLE ON QUERY COMPUTATION DISABLE QUERY REWRITE
  AS
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
                              'SCM'
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
           FROM    apps.hr_all_organization_units@mxdm_nvis_extract    haou
                  ,apps.hr_organization_information@mxdm_nvis_extract  hoi
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
   ,suppliers_and_sites_list
      AS  (
           SELECT  aps.vendor_id                            AS vendor_id
                  ,aps.segment1                             AS Segment1
                  ,assa.org_id                              AS org_id
                  ,assa.vendor_site_code                    AS vendor_site_code
                  ,assa.party_site_id                       AS party_site_id
                  ,eoil.operating_unit_name                 AS operating_unit_name
                  ,assa.vendor_site_id                      AS vendor_site_id
                  ,aps.vendor_name                          AS vendor_name
                  ,aps.party_id                             AS party_id
           FROM   eligible_org_id_list                     eoil
                 ,eligible_supplier_types_list             estl
                 ,apps.ap_suppliers@mxdm_nvis_extract           aps
                 ,apps.ap_supplier_sites_all@mxdm_nvis_extract  assa
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
                                     ,apps.ap_invoices_all@mxdm_nvis_extract   aia
                               WHERE  1 = 1
                               AND    aia.org_id                = assa.org_id                          /* Joins to outer query */
                               AND    aia.vendor_id             = assa.vendor_id                       /* Joins to outer query */
                               AND    aia.vendor_site_id        = assa.vendor_site_id                  /* Joins to outer query */
                               AND    TRUNC(aia.creation_date) >= xpc.supplier_scope_start_date        /* Invoice created within last X months */
                              )
                     OR
                       EXISTS ( /* POs created for active Suppliers and Sites within last X months */
                               SELECT 'X'
                               FROM   xxmx_parameter_conversions             xpc
                                     ,apps.po_headers_all@mxdm_nvis_extract  pha
                               WHERE  1 = 1
                               AND    pha.org_id                = assa.org_id                          /* Joins to outer query */
                               AND    pha.vendor_id             = assa.vendor_id                       /* Joins to outer query */
                               AND    pha.vendor_site_id        = assa.vendor_site_id                  /* Joins to outer query */
                               AND    TRUNC(pha.creation_date) >= xpc.supplier_scope_start_date        /* PO created within last X months */
                              )
                   )
          )
          SELECT  ssl.vendor_id            AS vendor_id
                 ,ssl.segment1             AS vendor_number
                 ,ssl.vendor_name          AS vendor_name
                 ,ssl.party_id             AS party_id
                 ,ssl.org_id               AS org_id
                 ,ssl.operating_unit_name  AS operating_unit_name
                 ,ssl.vendor_site_id       AS vendor_site_id
                 ,ssl.vendor_site_code     AS vendor_site_code
                 ,ssl.party_site_id        AS party_site_id
          FROM   suppliers_and_sites_list ssl
        ;
 COMMENT ON MATERIALIZED VIEW "XXMX_CORE"."XXMX_SUPPLIER_SCOPE_V"  IS 'snapshot table for snapshot XXMX_CORE.XXMX_SUPPLIER_SCOPE_V';        
 /