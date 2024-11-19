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
    DropView ('XXMX_AP_INV_SCOPE_V') ;
END;
/


CREATE MATERIALIZED VIEW  "XXMX_AP_INV_SCOPE_V" ("INVOICE_ID", "ORG_ID") 
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
     eligible_org_id_list
     AS
          (
           SELECT  DISTINCT
                   haou.organization_id    AS org_id
           FROM    apps.hr_all_organization_units@mxdm_nvis_extract    haou
                  ,apps.hr_organization_information@mxdm_nvis_extract  hoi
           WHERE   1 = 1
           AND     hoi.organization_id   = haou.organization_id
           AND     hoi.org_information1  = 'OPERATING_UNIT'
           AND     haou.name            IN (
                                            SELECT xmp.parameter_value
                                            FROM    xxmx_migration_parameters  xmp
                                            WHERE  1 = 1
                                            AND    xmp.application_suite      = 'FIN'            
                                            AND    xmp.application            = 'ALL'
                                            AND    xmp.business_entity        = 'ALL'
                                            AND    xmp.sub_entity             = 'ALL'
                                            AND    xmp.parameter_code         = 'ORGANIZATION_NAME'
                                            AND    NVL(xmp.enabled_flag, 'N') = 'Y'
                                            UNION
                                            SELECT xmp3.parameter_value
                                            FROM    xxmx_migration_parameters  xmp3
                                            WHERE  1 = 1
                                            AND    xmp3.application_suite      = 'FIN'
                                            AND    xmp3.application            = 'AP'
                                            AND    xmp3.business_entity        = 'INVOICES'
                                            AND    xmp3.sub_entity             = 'ALL'
                                            AND    xmp3.parameter_code         = 'ORGANIZATION_NAME'
                                            AND    NVL(xmp3.enabled_flag, 'N') = 'Y'
                                           )
          )
    ,eligible_invoice_types_list
     AS
          (
           SELECT xmp.parameter_value       AS invoice_type_lookup_code
           FROM    xxmx_migration_parameters  xmp
           WHERE  1 = 1
           AND    xmp.application_suite      = 'FIN'            
           AND    xmp.application            = 'ALL'
           AND    xmp.business_entity        = 'ALL'
           AND    xmp.sub_entity             = 'ALL'
           AND    xmp.parameter_code         = 'INVOICE_TYPE'
           AND    NVL(xmp.enabled_flag, 'N') = 'Y'
           UNION
           SELECT xmp3.parameter_value
           FROM    xxmx_migration_parameters  xmp3
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
            ,apps.ap_invoices_all@mxdm_nvis_extract           aia
     WHERE   1 = 1
     AND     aia.payment_status_flag       <> 'Y'                            -- Only Invoices which are not fully paid
     AND     aia.cancelled_date            IS NULL                           -- Only Invoices which are not cancelled
     AND     aia.invoice_type_lookup_code   = eitl.invoice_type_lookup_code  -- Only Invoice Types in scope
     AND     aia.org_id                     = eoil.org_id                    -- Only Organizations in scope
     AND     NOT EXISTS
                  (
                   SELECT 1
                   FROM   apps.ap_holds@mxdm_nvis_extract  ah
                   WHERE  1 = 1
                   AND    ah.invoice_id           = aia.invoice_id
                   AND    ah.release_lookup_code IS NULL
                  )
     AND     EXISTS
                  (select 1
                   from (
                   SELECT   org_id, invoice_id, sum(amount_remaining) amount_remaining
                    FROM     apps.ap_payment_schedules_all@mxdm_nvis_extract
                    WHERE    amount_remaining              != 0
                    AND      nvl(payment_status_flag, 'N')  = 'N'
                    GROUP BY org_id, invoice_id ) aps
                    where aps.invoice_id = aia.invoice_id
                  )
     AND     EXISTS
                 (
                  SELECT 1
                  FROM    xxmx_supplier_scope_v xssv
                  WHERE  1 = 1
                  AND    aia.vendor_id = xssv.vendor_id
                 );
COMMENT ON MATERIALIZED VIEW "XXMX_CORE"."XXMX_AP_INV_SCOPE_V"  IS 'snapshot table for snapshot XXMX_CORE.XXMX_AP_INV_SCOPE_V';        

/